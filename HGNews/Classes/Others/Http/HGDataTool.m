//
//  HGDataTool.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "HGDataTool.h"
#import "HGVidio.h"
#import "HGPicture.h"
#import "HGHeaderNews.h"
#import "HGNormalNews.h"
#import "HGVidioFetchDataParameter.h"
#import "HGPictureFetchDataParameter.h"
#import "HGNormalNewsFetchDataParameter.h"
#import "HGVidioComment.h"
#import "HGJudgeNewworking.h"
#import <FMDB.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>


static NSString *const apikey = @"06ed1f1d30eb7679632c674641fce902";

@interface HGDataTool ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation HGDataTool
static FMDatabaseQueue *_queue;

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"data.sqlite"];
//    NSLog(@"%@", path);
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists table_video(id integer primary key autoincrement, idstr text, time integer, video blob);"];
        
        [db executeUpdate:@"create table if not exists table_picture(id integer primary key autoincrement, idstr text, time integer, picture blob);"];
        
        [db executeUpdate:@"create table if not exists table_ttheadernews(id integer primary key autoincrement, title text, url text, abstract text, image_url text);"];
        
        [db executeUpdate:@"create table if not exists table_normalnews(id integer primary key autoincrement, channelid text, title text, imageurls blob, desc text, link text, pubdate text, createdtime integer, source text);"];
        [db executeUpdate:@"create table if not exists table_videocomment(id integer primary key autoincrement, idstr text, page integer, hotcommentarray blob, latestcommentarray blob, total integer);"];

    }];
}
+ (void)vidioWithParameters:(HGVidioFetchDataParameter *)vidioParameters success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    if ([HGJudgeNewworking currentNetworkingType] == NetworkingTypeNoReachable) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        vidioParameters.recentTime = nil;
        vidioParameters.remoteTime = nil;
        NSMutableArray *videoArray = [self selectDataFromCacheWithVidioParameters:vidioParameters];
        if (videoArray.count > 0) {
            HGVidio *lastVideo = videoArray.lastObject;
            NSString *maxtime = lastVideo.maxtime;
            success(videoArray, maxtime);
        }
        success([videoArray copy], @"");
    }else{
        NSMutableArray *videoArray = [self selectDataFromCacheWithVidioParameters:vidioParameters];
        if (videoArray.count > 0) {
            HGVidio *lastVideo = videoArray.lastObject;
            NSString *maxtime = lastVideo.maxtime;
            success(videoArray, maxtime);
        }else{
            __weak typeof(self)weakself = self;
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"a"] = @"list";
            parameters[@"c"] = @"data";
            parameters[@"type"] = @(41);
            parameters[@"page"] = @(vidioParameters.page);
            if (vidioParameters.maxTime) {
                parameters[@"maxtime"] = vidioParameters.maxTime;
            }
            [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray *array = [HGVidio mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                
                NSString *maxtime = responseObject[@"info"][@"maxtime"];
                for (HGVidio *video in array) {
                    video.maxtime = maxtime;
                }
                [weakself addVideoArray:array];
                success(array, maxtime);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
    }
}

+ (NSMutableArray *)selectDataFromCacheWithVidioParameters:(HGVidioFetchDataParameter *)parameters
{
    __block NSMutableArray *vidioArray = nil;
    [_queue inDatabase:^(FMDatabase *db) {
        vidioArray = [NSMutableArray array];
        FMResultSet *result = nil;
        if (parameters.recentTime) {
            NSInteger time = [[[parameters.recentTime stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;

            result = [db executeQuery:@"select * from table_video where time > ? order by time desc limit 0,20;", @(time)];
        }
        if(parameters.remoteTime) {
            NSInteger time = [[[parameters.remoteTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            result = [db executeQuery:@"select * from table_video where time < ? order by time desc limit 0,20;",@(time)];
        }
        if (parameters.remoteTime==nil &&parameters.recentTime==nil){
            result = [db executeQuery:@"select * from table_video order by time desc limit 0,20;"];
        }
        while (result.next) {
            NSData *data = [result dataForColumn:@"video"];
            HGVidio *vidio = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [vidioArray addObject:vidio];
        }

    }];
    return vidioArray;
}

+ (void)addVideoArray:(NSArray *)videoArray
{
    for (HGVidio *video in videoArray) {
        [self addVideo:video];
    }
}
+ (void)addVideo:(HGVidio *)vidio
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *idstr = vidio.ID;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_video WHERE idstr = '%@';", idstr];
        result = [db executeQuery:querySql];
        if (result.next == NO) {//不存在此条数据
            NSString *string = vidio.created_at;
            NSInteger time = [[[string stringByReplacingOccurrencesOfString:@"-" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:vidio];
            [db executeUpdate:@"insert into table_video(idstr,time,video) values(?,?,?);", idstr,@(time), data];
        }
        [result close];
    }];
}

+ (void)pictureWithParameters:(HGPictureFetchDataParameter *)pictureParameters success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{
    if ([HGJudgeNewworking currentNetworkingType] == NetworkingTypeNoReachable) {//没有网络
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        pictureParameters.recentTime = nil;
        pictureParameters.remoteTime = nil;
        NSMutableArray *pictureArray = [self selectDataFromCacheWithPictureParameters:pictureParameters];
        if (pictureArray.count>0) {
            HGPicture *lastPicture = pictureArray.lastObject;
            NSString *maxtime = lastPicture.maxtime;
            success([pictureArray copy], maxtime);
        }
        success([pictureArray copy], @"");
    } else {
        NSMutableArray *pictureArray = [self selectDataFromCacheWithPictureParameters:pictureParameters];
        if (pictureArray.count>0) {
            HGPicture *lastPicture = pictureArray.lastObject;
            NSString *maxtime = lastPicture.maxtime;
            success([pictureArray copy], maxtime);
        } else {
            __weak typeof (self)weakself=self;
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"a"] = @"list";
            parameters[@"c"] = @"data";
            parameters[@"type"] = @(10);
            parameters[@"page"] = @(pictureParameters.page);
            if (pictureParameters.maxtime) {
                parameters[@"maxtime"] = pictureParameters.maxtime;
            }
            
            [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                NSArray *array = [HGPicture mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
                NSString *maxTime = responseObject[@"info"][@"maxtime"];
                for (HGPicture *picture in array) {
                    picture.maxtime = maxTime;
                }
                [weakself addPictureArray:array];
                success(array,maxTime);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];
        }
    }

}

+(NSMutableArray *)selectDataFromCacheWithPictureParameters:(HGPictureFetchDataParameter *)parameters {
    __block NSMutableArray *pictureArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        pictureArray = [NSMutableArray array];
        FMResultSet *result = nil;
        
        if (parameters.recentTime) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = [[[parameters.recentTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            
            result = [db executeQuery:@"select * from table_picture where time > ? order by time desc limit 0,20;", @(time)];
            
        }
        
        if(parameters.remoteTime) {
            NSInteger time = [[[parameters.remoteTime stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            result = [db executeQuery:@"select * from table_picture where time < ? order by time desc limit 0,20;",@(time)];
        }
        
        if (parameters.remoteTime==nil && parameters.recentTime==nil){
            result = [db executeQuery:@"select * from table_picture order by time desc limit 0,20;"];
            
        }
        
        while (result.next) {
            NSData *data = [result dataForColumn:@"picture"];
            HGPicture *picture = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [pictureArray addObject:picture];
        }
        
    }];
    return pictureArray;
    
}

+(void)addPicture:(HGPicture *)picture {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *idstr = picture.ID;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_picture WHERE idstr = '%@';",idstr];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSString *string = picture.created_at;
            NSInteger time = [[[string stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""].integerValue;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:picture];
            [db executeUpdate:@"insert into table_picture (idstr,time,picture) values(?,?,?);", idstr, @(time), data];
        }
        [result close];
    }];
}

+ (void)addPictureArray:(NSArray *)pictureArray {
    for (HGPicture *picture in pictureArray) {
        [self addPicture:picture];
    }
}

+ (void)HGHeaderNewsFromServerOrCacheWithMaxHGHeaderNews:(HGHeaderNews *)headerNews success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure {
    if ([HGJudgeNewworking currentNetworkingType] == NetworkingTypeNoReachable) {//没有网络
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        NSMutableArray *array = [self HGHeaderNewsFromCacheWithMaxHGHeaderNews:headerNews];
        success(array);
    } else {//有网络
        __weak typeof (self)weakself=self;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        [manager GET:@"http://apis.baidu.com/songshuxiansheng/news/news" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *headerNewsArray = [HGHeaderNews mj_objectArrayWithKeyValuesArray:responseObject[@"retData"]];
            NSArray *temmArray = [headerNewsArray copy];
            for (HGHeaderNews *headerNews in temmArray) {
                if ([headerNews.image_url isEqualToString:@""]) {
                    [headerNewsArray removeObject:headerNews];
                }
            }
            [weakself addHGHeaderNewsArray:[headerNewsArray copy]];
            success(headerNewsArray);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            NSLog(@"%@",error);
        }];
    }
    
}

+(NSMutableArray *)HGHeaderNewsFromCacheWithMaxHGHeaderNews:(HGHeaderNews *)headerNews {
    __block NSMutableArray *headerNewsArray;
    [_queue inDatabase:^(FMDatabase *db) {
        headerNewsArray = [NSMutableArray array];
        FMResultSet *result = nil;
        result = [db executeQuery:@"select * from table_ttheadernews order by id desc limit 0,5"];
        while (result.next) {
            HGHeaderNews *headerNews = [[HGHeaderNews alloc] init];
            headerNews.title = [result stringForColumn:@"title"];
            headerNews.url = [result stringForColumn:@"url"];
            headerNews.image_url = [result stringForColumn:@"image_url"];
            headerNews.abstract = [result stringForColumn:@"abstract"];
            [headerNewsArray addObject:headerNews];
        }
    }];
    return headerNewsArray;
}


+(void)addHGHeaderNews:(HGHeaderNews *)news {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *url = news.url;
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_ttheadernews WHERE url = '%@';",url];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            [db executeUpdate:@"insert into table_ttheadernews (title ,url, abstract, image_url) values(?,?,?,?);",news.title, news.url, news.abstract, news.image_url];
        }
        [result close];
    }];
}

+(void)addHGHeaderNewsArray:(NSArray *)headerNewsArray {
    for (HGHeaderNews *news in headerNewsArray) {
        [self addHGHeaderNews:news];
    }
}

+(void)HGNormalNewsWithParameters:(HGNormalNewsFetchDataParameter *)normalNewsParameters success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure {
    if (![HGJudgeNewworking judge]) {
        [SVProgressHUD showErrorWithStatus:@"无网络连接"];
        HGNormalNewsFetchDataParameter *tempParameters = [[HGNormalNewsFetchDataParameter alloc] init];
        tempParameters.channelId = normalNewsParameters.channelId;
        NSMutableArray *tempCacheArray = [self selectDataFromHGNormalNewsCacheWithParameters:tempParameters];
        success(tempCacheArray);
        return;
    }
    NSMutableArray *cacheArray = [self selectDataFromHGNormalNewsCacheWithParameters:normalNewsParameters];
    
    if (cacheArray.count == 20) {
        success(cacheArray);
    } else {
        __weak typeof (self)weakself=self;
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"channelid"] = normalNewsParameters.channelId;
        parameters[@"channelName"] = [normalNewsParameters.channelName stringByAppendingString:@"最新"];
        parameters[@"title"] = normalNewsParameters.title;
        parameters[@"page"] = @(normalNewsParameters.page);
        [manager GET:@"http://apis.baidu.com/showapi_open_bus/channel_news/search_news" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *pictureArray = [HGNormalNews mj_objectArrayWithKeyValuesArray:responseObject[@"showapi_res_body"][@"pagebean"][@"contentlist"]];
            for (HGNormalNews *news in pictureArray) {
                news.allPages = [responseObject[@"showapi_res_body"][@"pagebean"][@"allPages"] integerValue];
            }
            [weakself addHGNormalNewsArray:pictureArray];
            success(pictureArray);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
            NSLog(@"%@",error);
        }];
    }
    
}


+ (NSMutableArray *)selectDataFromHGNormalNewsCacheWithParameters:(HGNormalNewsFetchDataParameter *)parameters {
    __block NSMutableArray *newsArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        newsArray = [NSMutableArray array];
        FMResultSet *result = nil;
        if (parameters.recentTime!=0) {//时间更大，代表消息发布越靠后，因为时间是按real来储存的
            NSInteger time = parameters.recentTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime > %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
            
            result = [db executeQuery:sql];
            
        }
        
        if(parameters.remoteTime!=0) {
            NSInteger time = parameters.remoteTime;
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where createdtime < %@ and channelid = '%@' order by createdtime desc limit 0,20;", @(time),parameters.channelId];
            
            result = [db executeQuery:sql];
        }
        
        if (parameters.remoteTime==0 && parameters.recentTime==0){
            
            NSString *sql = [NSString stringWithFormat:@"select * from table_normalnews where channelid = '%@' order by createdtime desc limit 0,20;", parameters.channelId];
            result = [db executeQuery:sql];
        }
        
        while (result.next) {
            HGNormalNews *news = [[HGNormalNews alloc] init];
            news.title = [result stringForColumn:@"title"];
            news.pubDate = [result stringForColumn:@"pubdate"];
            news.createdtime  = [result longLongIntForColumn:@"createdtime"];
            
            news.imageurls = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"imageurls"]];
            news.source = [result stringForColumn:@"source"];
            news.desc = [result stringForColumn:@"desc"];
            news.link = [result stringForColumn:@"link"];
            news.channelId = [result stringForColumn:@"channelId"];
            [newsArray addObject:news];
        }
    }];
    return newsArray;
    
}


+(void)addHGNormalNews:(HGNormalNews *)news {
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = nil;
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM table_normalnews WHERE link = '%@';",news.link];
        result = [db executeQuery:querySql];
        if (result.next==NO) {//不存在此条数据
            NSData *imageurls = [NSKeyedArchiver archivedDataWithRootObject:news.imageurls];
            [db executeUpdate:@"insert into table_normalnews (title , pubdate, createdtime, source, desc, link, imageurls, channelid) values(?,?,?,?,?,?,?,?);",news.title, news.pubDate, @(news.createdtime), news.source, news.desc, news.link, imageurls,news.channelId];
        }
        [result close];
    }];
}

+(void)addHGNormalNewsArray:(NSMutableArray *)newsArray {
    for (HGNormalNews *news in newsArray) {
        [self addHGNormalNews:news];
    }
}

+(void)deletePartOfCacheInSqlite {
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"delete from table_video where id > 20"];
        [db executeUpdate:@"delete from table_picture where id > 20"];
        [db executeUpdate:@"delete from table_normalnews where id > 20"];
        [db executeUpdate:@"delete from table_ttheadernews where id > 5"];
    }];
}

@end
