//
//  HGTabBarController.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "HGTabBarController.h"
#import "HGNavigationController.h"
#import "NewsViewController.h"
#import "PictureTableViewController.h"
#import "VidioTableViewController.h"
#import "MeTableViewController.h"

@interface HGTabBarController ()

@end

@implementation HGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NewsViewController *vc1 = [[NewsViewController alloc]init];
    [self addChildViewController:vc1 withNormalImage:@"tabbar_news" selectedImage:@"tabbar_news_hl" withTitle:@"新闻"];
    PictureTableViewController *vc2 = [[PictureTableViewController alloc]init];
    
    [self addChildViewController:vc2 withNormalImage:@"tabbar_picture" selectedImage:@"tabbar_picture_hl" withTitle:@"图片"];
    
    VidioTableViewController *vc3 = [[VidioTableViewController alloc]init];
    
    [self addChildViewController:vc3 withNormalImage:@"tabbar_video" selectedImage:@"tabbar_video_hl" withTitle:@"视频"];
    
    MeTableViewController *vc4 = [[MeTableViewController alloc]init];
    
    [self addChildViewController:vc4 withNormalImage:@"tabbar_setting" selectedImage:@"tabbar_setting_hl" withTitle:@"我的"];
}

- (void)addChildViewController:(UIViewController *)controller withNormalImage:(NSString *)norImg selectedImage:(NSString *)selImg withTitle:(NSString *)title
{
    HGNavigationController *nav = [[HGNavigationController alloc]initWithRootViewController:controller];
    [nav.tabBarItem setImage:[UIImage imageNamed:norImg]];
    [nav.tabBarItem setSelectedImage:[UIImage imageNamed:selImg]];
    controller.title = title;
    [nav.tabBarItem setTitleTextAttributes:@{
        NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
    [self addChildViewController:nav];

}


@end
