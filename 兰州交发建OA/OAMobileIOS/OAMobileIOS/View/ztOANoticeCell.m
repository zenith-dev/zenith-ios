//
//  ztOANoticeCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-11.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOANoticeCell.h"

@implementation ztOANoticeCell
@synthesize iconImg,noticeName,noticeTime,readImg,readCount,zhidingIconImg,theNewIconImg;
@synthesize detailInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 0,0)];
        iconImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconImg];
        
        zhidingIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_zhiding"]];
        zhidingIconImg.backgroundColor = [UIColor clearColor];
        
        theNewIconImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notice_new"]];
        theNewIconImg.backgroundColor = [UIColor clearColor];
        
        noticeName = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 10, kScreenWidth-iconImg.right-5, 20)];
        [noticeName setBackgroundColor:[UIColor clearColor]];
        [noticeName setTextAlignment:NSTextAlignmentLeft];
        [noticeName setTextColor:[UIColor blackColor]];
        [noticeName setText:@""];
        [noticeName setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:noticeName];
        
        noticeTime = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-120-10+40, 40, 80, 15)];
        [noticeTime setBackgroundColor:[UIColor clearColor]];
        [noticeTime setTextAlignment:NSTextAlignmentRight];
        [noticeTime setTextColor:[UIColor grayColor]];
        [noticeTime setText:@""];
        [noticeTime setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:noticeTime];
        
        detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 40, kScreenWidth-120-iconImg.right-5+40-15, 15)];
        [detailInfo setBackgroundColor:[UIColor clearColor]];
        [detailInfo setTextAlignment:NSTextAlignmentLeft];
        [detailInfo setTextColor:[UIColor grayColor]];
        [detailInfo setText:@""];
        [detailInfo setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60-1, kScreenWidth,1)];
        line.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:line];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
