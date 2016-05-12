//
//  NewsViewController.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "NewsViewController.h"
#import <POP.h>
#import <SVProgressHUD.h>
#import "HGJudgeNewworking.h"
#import "TTConst.h"
#import "HGTopChannelContianerView.h"
#import "ContentTableViewController.h"
#import "ChannelCollectionViewCell.h"
#import "ChannelsSectionHeaderView.h"


@interface NewsViewController ()<UIScrollViewDelegate, HGTopChannelContianerViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, strong) NSMutableArray *remainChannelsArray;
@property (nonatomic, strong) NSMutableArray *allChannelsArray;
@property (nonatomic, strong) NSMutableDictionary *channelsUrlDictionary;
@property (nonatomic, weak) HGTopChannelContianerView *topContianerView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentSkinModel;
@property (nonatomic, assign) BOOL isCellShouldShake;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isCellShouldShake = NO;
    [self setupTopContianerView];
    [self setupChildController];
    [self setupContentScrollView];
    [self setupCollectionView];
}


#pragma mark --private Method--存储更新后的currentChannelsArray到偏好设置中
-(void)updateCurrentChannelsArrayToDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.view.backgroundColor = [UIColor grayColor];
}

- (void)setupTopContianerView
{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    HGTopChannelContianerView *topContianerView = [[HGTopChannelContianerView alloc]initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.currentChannelsArray;
    self.topContianerView = topContianerView;
    self.topContianerView.scrollView.delegate = self;
    
    [self.view addSubview:topContianerView];
    
}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    for (NSInteger i = 0; i<self.currentChannelsArray.count; i++) {
        ContentTableViewController *viewController = [[ContentTableViewController alloc] init];
        viewController.channelName = self.currentChannelsArray[i];
        viewController.chnnelId = self.channelsUrlDictionary[viewController.channelName];
        [self addChildViewController:viewController];
    }
}

#pragma mark --UIScrollViewDelegate-- 重新设置了UIScrollView的contentOffset,并且animate=YES会调用这个方法，scrollViewDidEndDecelerating中也调用了这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        ContentTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:vc.view];
    }
}

#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --TTTopChannelContianerViewDelegate--选择了某个新闻频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}



- (void)setupContentScrollView
{
    
}

- (void)setupCollectionView
{
    
}
#pragma mark --private Method--懒加载currentChannelsArray
-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        _currentChannelsArray = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"currentChannelsArray"];
        [_currentChannelsArray addObjectsFromArray:array];
        if (_currentChannelsArray.count == 0) {
            [_currentChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车"]];
            [self updateCurrentChannelsArrayToDefaults];
        }
    }
    return _currentChannelsArray;
}

#pragma mark --懒加载--remainChannelsArray
-(NSMutableArray *)remainChannelsArray {
    if (!_remainChannelsArray) {
        _remainChannelsArray = [NSMutableArray array];
        [_remainChannelsArray addObjectsFromArray:self.allChannelsArray];
        [_remainChannelsArray removeObjectsInArray:self.currentChannelsArray];
    }
    return _remainChannelsArray;
}


#pragma mark - 懒加载所有频道数组
- (NSMutableArray *)allChannelsArray
{
    if (!_allChannelsArray) {
        _allChannelsArray = [NSMutableArray array];
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"allChannelsArray"];
        [_allChannelsArray addObjectsFromArray:tempArray];
        if (_allChannelsArray.count == 0) {
            [_allChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车", @"军事", @"理财", @"经济", @"房产", @"国际足球", @"国内足球", @"综合体育", @"电影", @"电视", @"游戏", @"教育", @"美容", @"情感",@"养生", @"数码", @"电脑", @"科普", @"社会", @"台湾", @"港澳"]];
            [[NSUserDefaults standardUserDefaults] setObject:_allChannelsArray forKey:@"allChannelsArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _allChannelsArray;
}

#pragma mark --懒加载--channelsUrlDictionary
-(NSMutableDictionary *)channelsUrlDictionary {
    if (!_channelsUrlDictionary) {
        _channelsUrlDictionary = [NSMutableDictionary dictionary];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"channelsUrlDictionary"];
        [_channelsUrlDictionary addEntriesFromDictionary:dict];
        if (_channelsUrlDictionary.count == 0) {
            NSDictionary *tempDictionary = @{
                                             @"国内": @"5572a109b3cdc86cf39001db",
                                             @"国际": @"5572a109b3cdc86cf39001de",
                                             @"娱乐": @"5572a10ab3cdc86cf39001eb",
                                             @"互联网": @"5572a109b3cdc86cf39001e3",
                                             @"体育": @"5572a109b3cdc86cf39001e6",
                                             @"财经": @"5572a109b3cdc86cf39001e0",
                                             @"科技": @"5572a10ab3cdc86cf39001f4",
                                             @"汽车": @"5572a109b3cdc86cf39001e5",
                                             @"军事": @"5572a109b3cdc86cf39001df",
                                             @"理财": @"5572a109b3cdc86cf39001e1",
                                             @"经济": @"5572a109b3cdc86cf39001e2",
                                             @"房产": @"5572a109b3cdc86cf39001e4",
                                             @"国际足球": @"5572a10ab3cdc86cf39001e7",
                                             @"国内足球": @"5572a10ab3cdc86cf39001e8",
                                             @"综合体育": @"5572a10ab3cdc86cf39001ea",
                                             @"电影": @"5572a10ab3cdc86cf39001ec",
                                             @"电视": @"5572a10ab3cdc86cf39001ed",
                                             @"游戏": @"5572a10ab3cdc86cf39001ee",
                                             @"教育": @"5572a10ab3cdc86cf39001ef",
                                             @"美容": @"5572a10ab3cdc86cf39001f1",
                                             @"情感": @"5572a10ab3cdc86cf39001f2",
                                             @"养生": @"5572a10ab3cdc86cf39001f3",
                                             @"数码": @"5572a10bb3cdc86cf39001f5",
                                             @"电脑": @"5572a10bb3cdc86cf39001f6",
                                             @"科普": @"5572a10bb3cdc86cf39001f7",
                                             @"社会": @"5572a10bb3cdc86cf39001f8",
                                             @"台湾": @"5572a109b3cdc86cf39001dc",
                                             @"港澳": @"5572a109b3cdc86cf39001dd"
                                             };
            [_channelsUrlDictionary addEntriesFromDictionary:tempDictionary];
            [[NSUserDefaults standardUserDefaults] setObject:_channelsUrlDictionary forKey:@"channelsUrlDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return _channelsUrlDictionary;
}


@end
