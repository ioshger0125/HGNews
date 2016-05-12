//
//  MultiPictureTableViewCell.m
//  HGNews
//
//  Created by HuaGuo on 16/5/10.
//  Copyright © 2016年 HG. All rights reserved.
//

#import "MultiPictureTableViewCell.h"
#import "UIImageView+Extension.h"

@interface MultiPictureTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *newsTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pictureCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@end
@implementation MultiPictureTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    [self.imageView1 TT_setImageWithURL:imageUrls[0][@"url"]];
    [self.imageView2 TT_setImageWithURL:imageUrls[1][@"url"]];
    [self.imageView3 TT_setImageWithURL:imageUrls[2][@"url"]];
    self.pictureCountLabel.text = [NSString stringWithFormat:@"%ld图",imageUrls.count];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",arc4random()%1000];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.newsTittleLabel.text = title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
