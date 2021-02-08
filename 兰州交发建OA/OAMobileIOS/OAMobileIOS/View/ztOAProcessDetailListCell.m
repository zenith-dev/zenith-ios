//
//  ztOAProcessDetailListCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-27.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAProcessDetailListCell.h"

@implementation ztOAProcessDetailListCell
//@synthesize strgzrwmc,strczrxm,strfsrxm,stryjnr,dtmfssj,dtmbjsj;
//@synthesize blueSendLable,blueDoneLable;
@synthesize blueLineImg,pointImg,breakLine,openOrCloseBtn;
@synthesize sendInfoLabel,opinionLabel,dealInfoLabel,sendTimeLabel,zrzlb;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        blueLineImg = [[UIImageView alloc] initWithFrame:CGRectMake(10-0.5, 0, 1, 60)];
        [blueLineImg setBackgroundColor:BACKCOLOR];
        [self.contentView addSubview:blueLineImg];

        pointImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"process_pointImg"]];
        pointImg.frame = CGRectMake(10-8, 5, 16, 16);
        [self.contentView addSubview:pointImg];
        //处理信息(操作信息)
        dealInfoLabel= [[UILabel alloc] initWithFrame:CGRectMake(20, 5, kScreenWidth-40-100, 15)];
        [dealInfoLabel setBackgroundColor:[UIColor clearColor]];
        [dealInfoLabel setTextAlignment:NSTextAlignmentLeft];
        [dealInfoLabel setTextColor:[UIColor grayColor]];
        [dealInfoLabel setText:@""];
        [dealInfoLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:dealInfoLabel];
        
        sendTimeLabel= [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-100-10, 5, 100, 15)];
        [sendTimeLabel setBackgroundColor:[UIColor clearColor]];
        [sendTimeLabel setTextAlignment:NSTextAlignmentRight];
        [sendTimeLabel setTextColor:BACKCOLOR];
        [sendTimeLabel setText:@""];
        [sendTimeLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:sendTimeLabel];
        
        //意见
        opinionLabel= [[UILabel alloc] initWithFrame:CGRectMake(20+10, dealInfoLabel.bottom+10, kScreenWidth-40-10, 20)];
        [opinionLabel setBackgroundColor:[UIColor clearColor]];
        [opinionLabel setTextAlignment:NSTextAlignmentLeft];
        [opinionLabel setTextColor:BACKCOLOR];
        [opinionLabel setText:@""];
        [opinionLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:opinionLabel];
        
        zrzlb =[[UILabel alloc]initWithFrame:CGRectMake(10, opinionLabel.bottom+10, kScreenWidth-20, 18)];
        zrzlb.font=Font(12);
        [zrzlb setTextColor:[UIColor grayColor]];
        zrzlb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:zrzlb];
        
        //展开收起按钮
        openOrCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openOrCloseBtn.backgroundColor = [UIColor clearColor];
        openOrCloseBtn.frame = CGRectMake(20, zrzlb.bottom,self.width-40 , 20);
        [openOrCloseBtn setImageEdgeInsets:UIEdgeInsetsMake(4, (self.width-40-36)/2, 4, (self.width-40-36)/2)];
        [openOrCloseBtn setImage:[UIImage imageNamed:@"common_detail_open"] forState:UIControlStateNormal];
        [openOrCloseBtn setHidden:YES];
        [self.contentView addSubview:openOrCloseBtn];
        
        breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, openOrCloseBtn.bottom, kScreenWidth-30, 1)];
        breakLine.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        blueLineImg.height=breakLine.bottom;
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
