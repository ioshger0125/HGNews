//
//  HGVidioFetchDataParameter.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGVidioFetchDataParameter : NSObject

@property (nonatomic, copy) NSString *recentTime;
@property (nonatomic, copy) NSString *remoteTime;
@property (nonatomic, copy) NSString *maxTime;
@property (nonatomic, assign) NSInteger page;

@end
