//
//  ztOAMainBaseView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-8.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAMainBaseView.h"
#import <QuartzCore/QuartzCore.h>
#define Width   80.0f
#define Heighth     110.0f
@implementation ztOAMainBaseView
@synthesize backImg,logoImg,nameInfoLable,readCountLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, Width-10, Width-10)];
        //backImg.image = [UIImage imageNamed:@"pagesBackImg"];
        backImg.backgroundColor = [UIColor whiteColor];
        [backImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
        [backImg.layer setBorderWidth:1];
        [backImg.layer setShadowOffset:CGSizeMake(5, 5)];
        [backImg.layer setShadowColor:[[UIColor grayColor] CGColor]];
        [backImg.layer setShadowRadius:2];
        [backImg.layer setShadowOpacity:1];
        [backImg setBackgroundImage:[UIImage imageNamed:@"pagesBackImg"] forState:UIControlStateHighlighted];
        
        [self addSubview:backImg];
        
        logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, Width-20, Width-20)];
        logoImg.image = [UIImage imageNamed:@""];
        logoImg.backgroundColor = [UIColor clearColor];
        [backImg addSubview:logoImg];
        
        nameInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(0,Heighth-20 , Width, 20)];
        //nameInfoLable.font = [UIFont systemFontOfSize:15.0f];
        [nameInfoLable setFont:[UIFont fontWithName:@"Papyrus" size:15.0f]];
        nameInfoLable.textColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.000 alpha:1.000];
        nameInfoLable.backgroundColor = [UIColor clearColor];
        nameInfoLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameInfoLable];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0) {
            [readCountLable setClipsToBounds:YES];
        }
        readCountLable = [[UILabel alloc] initWithFrame:CGRectMake(Width-23,0 , 22, 22)];
        readCountLable.font = [UIFont boldSystemFontOfSize:10.0f];
        [readCountLable.layer setCornerRadius:11];
        readCountLable.textColor = [UIColor whiteColor];
        readCountLable.textAlignment = NSTextAlignmentCenter;
        readCountLable.backgroundColor = [UIColor redColor];
        readCountLable.text = @"";
        [readCountLable setHidden:YES];
        [self addSubview:readCountLable];
        
    }
    return self;
}

@end
