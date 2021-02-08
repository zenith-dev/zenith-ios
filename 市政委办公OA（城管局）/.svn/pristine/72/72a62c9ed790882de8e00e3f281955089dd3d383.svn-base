//
//  ztOANewMainViewItem.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-21.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOANewMainViewItem.h"

@implementation ztOANewMainViewItem
@synthesize backImg,logoImg,nameInfoLable,readCountLable,readCountRound;
- (id)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName iconImgWidth:(float)width_t  iconImgHeight_t:(float)height_t iconImgName:(NSString *)iconImgName withSide:(int)indexSide
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        UIImage *btnImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@",backImgName]];
        NSInteger leftCapWidth = btnImg.size.width * 0.5f;
        NSInteger topCapHeight = btnImg.size.height * 0.5f;
        btnImg = [btnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        [backImg setBackgroundImage:btnImg forState:UIControlStateNormal];
        
        [self addSubview:backImg];
        //indexSide=0  文字上 图片下； indexSide=1 文字在右，图片在左
        if (indexSide==0) {
            nameInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(5,10 , frame.size.width-20, 20)];
            logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-width_t)/2, (frame.size.height-height_t-20)/2+20, width_t, height_t)];
            
        }
        else if(indexSide == 1)
        {
            logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, (frame.size.height-height_t)/2, width_t, height_t)];
            nameInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(logoImg.right,(frame.size.height-20)/2 , frame.size.width-logoImg.right-10, 20)];
            nameInfoLable.textAlignment = NSTextAlignmentCenter;
        }
        else
        {//默认0
            nameInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(5,10 , frame.size.width-20, 20)];
            logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-width_t)/2, (frame.size.height-height_t-20)/2+20, width_t, height_t)];
        }
        
        [nameInfoLable setFont:[UIFont systemFontOfSize:13.0]];
        nameInfoLable.textColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.000 alpha:1.000];
        nameInfoLable.textColor = [UIColor whiteColor];
        nameInfoLable.backgroundColor = [UIColor clearColor];
        [self addSubview:nameInfoLable];
        
        
        logoImg.image = [UIImage imageNamed:iconImgName];
        logoImg.backgroundColor = [UIColor clearColor];
        [backImg addSubview:logoImg];
        
        readCountRound = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-23, 5, 21, 21)];
        readCountRound.image = [UIImage imageNamed:@"headView_WhiteRound"];
        readCountRound.backgroundColor = [UIColor clearColor];
        [backImg addSubview:readCountRound];
        
        readCountLable = [[UILabel alloc] initWithFrame:CGRectMake(1,3, 20, 15)];
        readCountLable.font = [UIFont systemFontOfSize:10.0f];
        readCountLable.textColor = [UIColor redColor];
        readCountLable.backgroundColor = [UIColor clearColor];
        readCountLable.textAlignment = NSTextAlignmentCenter;
        readCountLable.text = @"99+";
        [readCountRound addSubview:readCountLable];
        
        [readCountRound setHidden:YES];
    }
    return self;
}

@end
