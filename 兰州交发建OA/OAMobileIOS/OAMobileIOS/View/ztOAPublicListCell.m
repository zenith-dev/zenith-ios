//
//  ztOAPublicListCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-26.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPublicListCell.h"

@implementation ztOAPublicListCell
@synthesize iconImg,name,publicDate,detailInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 30, 30)];
        iconImg.backgroundColor = [UIColor clearColor];
        iconImg.image = [UIImage imageNamed:@"kw_icon"];
        [self.contentView addSubview:iconImg];
        
        name= [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 10, self.width-iconImg.right-10, 20)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor blackColor]];
        [name setText:@""];
        [name setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:name];
        
        publicDate = [[UILabel alloc] initWithFrame:CGRectMake(self.width-80-5, 35, 80, 15)];
        [publicDate setBackgroundColor:[UIColor clearColor]];
        [publicDate setTextAlignment:NSTextAlignmentRight];
        [publicDate setTextColor:[UIColor grayColor]];
        [publicDate setText:@""];
        [publicDate setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:publicDate];
        
        detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 35, self.width-iconImg.right-10-80, 15)];
        [detailInfo setBackgroundColor:[UIColor clearColor]];
        [detailInfo setTextAlignment:NSTextAlignmentLeft];
        [detailInfo setTextColor:[UIColor grayColor]];
        [detailInfo setText:@""];
        [detailInfo setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1) ];
        breakLine.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:breakLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
