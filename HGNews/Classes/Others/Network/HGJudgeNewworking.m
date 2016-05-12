//
//  HGJudgeNewworking.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "HGJudgeNewworking.h"
#import "Reachability.h"

@implementation HGJudgeNewworking

+ (BOOL)judge
{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}

+ (NetworkingType)currentNetworkingType
{
    Reachability *reachablity = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if ([reachablity currentReachabilityStatus] == ReachableViaWiFi) {
        return NetworkingTypeWiFi;
    }else if ([reachablity currentReachabilityStatus] == ReachableViaWWAN){
        return NetworkingType3G;
    }
    return NetworkingTypeNoReachable;
}
@end
