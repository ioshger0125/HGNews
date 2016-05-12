//
//  SinglePictureNewsTableViewCell.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "SinglePictureNewsTableViewCell.h"
#import "UIImageView+Extension.h"

@interface SinglePictureNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictrueImageView;

@property (weak, nonatomic) IBOutlet UILabel *newsTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;



@end

@implementation SinglePictureNewsTableViewCell

- (void)awakeFromNib {
    self.commentCount.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.pictrueImageView TT_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)setContentTittle:(NSString *)contentTittle
{
    _contentTittle = contentTittle;
    self.newsTittleLabel.text = contentTittle;
}

- (void)setDesc:(NSString *)desc
{
    _desc = desc;
    self.descLabel.text = desc;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
