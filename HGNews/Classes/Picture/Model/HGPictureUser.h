//
//  HGPictureUser.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGPictureUser : NSObject<NSCoding>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *sex;

@end
