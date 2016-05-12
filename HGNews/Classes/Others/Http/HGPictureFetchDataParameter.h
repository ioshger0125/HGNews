//
//  HGPictureFetchDataParameter.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGPictureFetchDataParameter : NSObject

@property (nonatomic, copy) NSString *recentTime;//最新的picture的时间

@property (nonatomic, copy) NSString *remoteTime;//最晚的picture的时间

@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, assign) NSInteger page;


@end
