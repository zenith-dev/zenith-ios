//
//  ChooseHotCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/15.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ChooseHotCell.h"

@implementation ChooseHotCell
@synthesize iconImageView,numlb,bgColor,titlelb;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        [bgImg setBackgroundColor:UIColorFromRGB(0x6faff5)];
        bgImg.centerX=self.width/2.0;
        bgImg.centerY=self.height/2.0-10;
        [self.contentView addSubview:bgImg];
        iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        iconImageView.centerX=bgImg.width/2.0;
        iconImageView.centerY=bgImg.height/2.0;
        [bgImg addSubview:iconImageView];
        
        numlb =[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+5, iconImageView.top+5, 20, 20)];
        numlb.font=Font(13);
        numlb.adjustsFontSizeToFitWidth=YES;
        numlb.textColor=[UIColor redColor];
        numlb.textAlignment=NSTextAlignmentCenter;
        [numlb setBackgroundColor:[UIColor whiteColor]];
        ViewRadius(numlb, numlb.height/2.0);
        [self.contentView addSubview:numlb];
        
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(2, bgImg.bottom+6, self.contentView.width-4, 18)];
        titlelb.textAlignment=NSTextAlignmentCenter;
        titlelb.font=Font(13);
        titlelb.textColor=RGBCOLOR(100, 100, 100);
        [self.contentView addSubview:titlelb];
    }
    return self;
}
@end
