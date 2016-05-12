//
//  SinglePictureNewsTableViewCell.h
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePictureNewsTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *contentTittle;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray *pictureArray;


@end
