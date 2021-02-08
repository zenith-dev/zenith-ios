//
//  HomePageCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/28.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "HomePageCell.h"

@implementation HomePageCell
@synthesize iconImageView,numlb,bgColor,titlelb;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
        iconImageView.centerX=self.width/2.0;
        iconImageView.centerY=self.height/2.0-10;
        [self.contentView addSubview:iconImageView];

        numlb =[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.right+5, iconImageView.top+5, 20, 20)];
        numlb.font=Font(13);
        numlb.adjustsFontSizeToFitWidth=YES;
        numlb.textColor=[UIColor redColor];
        numlb.textAlignment=NSTextAlignmentCenter;
        [numlb setBackgroundColor:[UIColor whiteColor]];
        ViewRadius(numlb, numlb.height/2.0);
        [self.contentView addSubview:numlb];
        
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(0, iconImageView.bottom+8, self.contentView.width, 18)];
        titlelb.textAlignment=NSTextAlignmentCenter;
        titlelb.font=Font(15);
        titlelb.textColor=[UIColor whiteColor];
        [self.contentView addSubview:titlelb];
    }
    return self;
}

@end
