//
//  YwzdGnCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "YwzdGnCell.h"

@implementation YwzdGnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
        [iconImg setImage:[UIImage imageNamed:@"icon_we"]];
        [self.contentView addSubview:iconImg];
        self.csmclb =[[UILabel alloc]initWithFrame:CGRectMake(iconImg.right+8, iconImg.top, kScreenWidth-iconImg.right-16, iconImg.height)];
        self.csmclb.font=Font(14);
        [self.contentView addSubview:self.csmclb];
        self.contentView.height=iconImg.bottom+8;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
