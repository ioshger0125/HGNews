//
//  HGImageCyclePlayView.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGImageCyclePlayViewDelegate <NSObject>
@optional

- (void)clickCurrentImageViewInImageCyclePlay;

@end

@interface HGImageCyclePlayView : UIView

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentMiddleImageViewIndex;

@property (nonatomic, weak)id<HGImageCyclePlayViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateImageViewsAndTitleLabel;
- (void)addTimer;
- (void)removeTimer;



@end
