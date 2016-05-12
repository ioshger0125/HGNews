//
//  HGJudgeNewworking.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGJudgeNewworking : NSObject

typedef NS_ENUM(NSUInteger, NetworkingType) {
    NetworkingTypeNoReachable = 1,
    NetworkingType3G = 2,
    NetworkingTypeWiFi = 3,
};

+ (BOOL)judge;

+ (NetworkingType)currentNetworkingType;

@end
