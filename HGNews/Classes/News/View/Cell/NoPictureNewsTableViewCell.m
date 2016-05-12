//
//  NoPictureNewsTableViewCell.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "NoPictureNewsTableViewCell.h"

@interface NoPictureNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end

@implementation NoPictureNewsTableViewCell

- (void)awakeFromNib {
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.newsTitleLabel.text = titleText;
}

- (void)setContentText:(NSString *)contentText
{
    _contentText = contentText;
    self.newsTitleLabel.text = contentText;
}

@end
