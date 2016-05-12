//
//  HGDataTool.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HGVidio,HGHeaderNews,HGVidioFetchDataParameter,HGPictureFetchDataParameter,HGNormalNewsFetchDataParameter;

@interface HGDataTool : NSObject

+ (void)vidioWithParameters:(HGVidioFetchDataParameter *)vidioParameters success:(void(^)(NSArray *array, NSString *maxtime))success failure:(void(^)(NSError *error))failure;

+ (void)pictureWithParameters:(HGPictureFetchDataParameter *)pictureParameters success:(void(^)(NSArray *array, NSString *maxtime))success failure:(void(^)(NSError *error))failure;

+ (void)HGNormalNewsWithParameters:(HGNormalNewsFetchDataParameter *)normalNewsParameters success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

+ (void)HGHeaderNewsFromServerOrCacheWithMaxHGHeaderNews:(HGHeaderNews *)headerNews success:(void (^)(NSMutableArray *array))success failure:(void (^)(NSError *error))failure;

+ (void)deletePartOfCacheInSqlite;


@end
