//
//  HGTopChannelContianerView.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGTopChannelContianerViewDelegate <NSObject>

@optional

- (void)showOrHiddenAddChannelsCollectionView:(UIButton *)button;
- (void)chooseChannelWithIndex:(NSInteger)index;

@end

@interface HGTopChannelContianerView : UIView

@property (nonatomic, strong) NSArray *channelNameArray;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, weak) id<HGTopChannelContianerViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAChannelButtonWithChannelName:(NSString *)channelName;
- (void)selectChannelButtonWithIndex:(NSInteger)index;
- (void)deleteChannelButtonWithIndex:(NSInteger)index;
- (void)updateToDaySkinMode;
- (void)updateToNightSkinMode;
- (void)didShowEditChannelView:(BOOL)value;



@end
