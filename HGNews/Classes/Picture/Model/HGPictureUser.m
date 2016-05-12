//
//  HGPictureUser.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "HGPictureUser.h"
#import <MJExtension.h>

@implementation HGPictureUser

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self mj_encode:aCoder];
}

@end
