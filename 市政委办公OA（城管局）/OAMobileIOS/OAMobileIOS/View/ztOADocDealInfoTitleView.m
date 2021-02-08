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
        warnLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-10, 15)];
        warnLable.backgroundColor = [UIColor clearColor];
        [warnLable setTextColor:[UIColor blueColor]];
        warnLable.textAlignment = NSTextAlignmentLeft;
        //warnLable.text = warnStr;
        warnLable.font = [UIFont systemFontOfSize:12.0f];
        warnLable.numberOfLines = 0;
        warnLable.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:warnLable];
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10+20, self.width-40, titleHeight_t)];
        titleLable.backgroundColor = [UIColor clearColor];
        [titleLable setTextColor:[UIColor blackColor]];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont boldSystemFontOfSize:16.0f];
        titleLable.text = titleStr;
        titleLable.numberOfLines = 0;
        titleLable.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:titleLable];
        
        for (int i = 0; i<infoArray.count; i++) {
            NSString *infoStringIndex = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:i]];
            UILabel *zihaoLable = [[UILabel alloc] initWithFrame:CGRectMake(20, titleHeight_t+40+20*i, self.width-40, 20)];
            zihaoLable.backgroundColor = [UIColor clearColor];
            [zihaoLable setTextColor:[UIColor grayColor]];
            zihaoLable.textAlignment = NSTextAlignmentLeft;
            zihaoLable.font = [UIFont systemFontOfSize:12.0f];
            zihaoLable.text = infoStringIndex;
            [self addSubview:zihaoLable];
        }
        float hight=titleHeight_t+40+20*[infoArray count]+20;
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, hight, self.width-10, 1)];
        lineView.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self addSubview:lineView];
        self.height=lineView.bottom;
    }
    return self;
}



@end
