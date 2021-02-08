//
//  ztOADocDealInfoTitleView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-18.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADocDealInfoTitleView.h"

@implementation ztOADocDealInfoTitleView
@synthesize titleLable,warnLedImg,warnLable,lineView;
- (id)initWithFrame:(CGRect)frame withHeight:(float)titleHeight_t withTitleStr:(NSString *)titleStr  withWarnStr:(NSString *)warnStr withWarnImage:(NSString *)warnImgStr infoArray:(NSMutableArray *)infoArray
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.width-40, titleHeight_t)];
        titleLable.backgroundColor = [UIColor clearColor];
        [titleLable setTextColor:[UIColor blackColor]];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLable.text = titleStr;
        titleLable.numberOfLines = 0;
        titleLable.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:titleLable];
        if (warnStr.length!=0) {
            warnLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLable.bottom+10, self.width-10, 15)];
            warnLable.backgroundColor = [UIColor clearColor];
            [warnLable setTextColor:[UIColor blueColor]];
            warnLable.textAlignment = NSTextAlignmentLeft;
            warnLable.text =[NSString stringWithFormat:@"办理时限：%@天", warnStr];
            warnLable.font = [UIFont systemFontOfSize:12.0f];
            warnLable.numberOfLines = 0;
            warnLable.lineBreakMode = NSLineBreakByCharWrapping;
            [self addSubview:warnLable];
            titleHeight_t=warnLable.bottom;
        }else
        {
            titleHeight_t=titleLable.bottom+10;
        }
        
        for (int i = 0; i<infoArray.count; i++) {
            NSString *infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:i]];
            if (infoStringIndex.length==0) {
                break;
            }
            UILabel *zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleHeight_t, self.width-40, 20)];
            zihaoLable.backgroundColor = [UIColor clearColor];
            [zihaoLable setTextColor:[UIColor grayColor]];
            zihaoLable.textAlignment = NSTextAlignmentLeft;
            zihaoLable.font = [UIFont systemFontOfSize:12.0f];
            zihaoLable.text = infoStringIndex;
            [self addSubview:zihaoLable];
            titleHeight_t=zihaoLable.bottom+5;
        }
//        NSString *infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:0]];
//        UILabel *zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleHeight_t+40, self.width-40, 20)];
//        zihaoLable.backgroundColor = [UIColor clearColor];
//        [zihaoLable setTextColor:[UIColor grayColor]];
//        zihaoLable.textAlignment = NSTextAlignmentLeft;
//        zihaoLable.font = [UIFont systemFontOfSize:12.0f];
//        zihaoLable.text = infoStringIndex;
//        [self addSubview:zihaoLable];
//        
//        infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:1]];
//        zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleHeight_t+40+20*1, self.width-40, 20)];
//        zihaoLable.backgroundColor = [UIColor clearColor];
//        [zihaoLable setTextColor:[UIColor grayColor]];
//        zihaoLable.textAlignment = NSTextAlignmentLeft;
//        zihaoLable.font = [UIFont systemFontOfSize:12.0f];
//        zihaoLable.text = infoStringIndex;
//        [self addSubview:zihaoLable];
//        
//        infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:2]];
//        zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleHeight_t+40+20*2, self.width-4-150, 20)];
//        zihaoLable.backgroundColor = [UIColor clearColor];
//        [zihaoLable setTextColor:[UIColor grayColor]];
//        zihaoLable.textAlignment = NSTextAlignmentLeft;
//        zihaoLable.font = [UIFont systemFontOfSize:12.0f];
//        zihaoLable.text = infoStringIndex;
//        [self addSubview:zihaoLable];
//        
//        infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:3]];
//        zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20+self.width-4-150+10, titleHeight_t+40+20*2, 120, 20)];
//        zihaoLable.backgroundColor = [UIColor clearColor];
//        [zihaoLable setTextColor:[UIColor grayColor]];
//        zihaoLable.textAlignment = NSTextAlignmentLeft;
//        zihaoLable.font = [UIFont systemFontOfSize:12.0f];
//        zihaoLable.text = infoStringIndex;
//        [self addSubview:zihaoLable];
        
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, titleHeight_t, self.width-10, 1)];
        lineView.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self addSubview:lineView];
        self.height=lineView.bottom;
    }
    return self;
}



@end
