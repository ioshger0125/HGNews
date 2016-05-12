//
//  ContentTableViewController.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGNormalNews;


@interface ContentTableViewController : UITableViewController

@property (nonatomic, strong) HGNormalNews *news;
@property (nonatomic, copy) NSString *chnnelId;
@property (nonatomic, copy) NSString *channelName;


@end
