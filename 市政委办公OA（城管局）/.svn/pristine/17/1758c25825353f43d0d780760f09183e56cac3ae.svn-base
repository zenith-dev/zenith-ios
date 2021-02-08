//
//  ztOAMainViewCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAMainViewCell.h"
#define HEIGHT_t  40
#define WIDTH_t   40
@implementation ztOAMainViewCell
@synthesize iconView,nameLab,detailLab,noReadCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, WIDTH_t, HEIGHT_t)];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:iconView];
        
        nameLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right*1.2, 5, self.width-WIDTH_t*4, 20)];
        [nameLab setBackgroundColor:[UIColor clearColor]];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setText:@""];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:nameLab];
        
        detailLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right*1.2, nameLab.bottom, self.width-WIDTH_t*4, 20)];
        [detailLab setBackgroundColor:[UIColor clearColor]];
        [detailLab setTextAlignment:NSTextAlignmentRight];
        [detailLab setTextColor:[UIColor grayColor]];
        [detailLab setText:@""];
        [detailLab setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:detailLab];
        
        noReadCount = [[UILabel alloc] initWithFrame:CGRectMake(self.width-80, 15, 50, 20)];
        [noReadCount setHidden:YES];
//        [noReadCount.layer setBorderWidth:1];
//        [noReadCount.layer setCornerRadius:5];
//        [noReadCount.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [noReadCount setBackgroundColor:[UIColor clearColor]];
        [noReadCount setTextAlignment:NSTextAlignmentCenter];
        [noReadCount setTextColor:[UIColor redColor]];
        [noReadCount setText:@""];
        [noReadCount setFont:[UIFont systemFontOfSize:10]];
        [self.contentView addSubview:noReadCount];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
