//
//  HGPicture.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGPictureComment;

@interface HGPicture : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *love;
@property (nonatomic, copy) NSString *cai;
@property (nonatomic, copy) NSString *repost;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *maxtime;
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *image0;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;
@property (nonatomic, copy) NSString *playcount;
@property (nonatomic, copy) NSString *videotime;
@property (nonatomic, copy) NSString *videouri;

@property (nonatomic, strong) HGPictureComment *top_cmt;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect pictureFrame;
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;


@end
