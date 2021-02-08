//
//  ztOApesonalBaseInfoView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-19.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOApesonalBaseInfoView.h"

@implementation ztOApesonalBaseInfoView
@synthesize titleBackImg,userNameLable,userSex,userHeadImg,companyLable,phoneLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80-1, self.width, 1)];
        [titleBackImg setBackgroundColor:BACKCOLOR];
        [self addSubview:titleBackImg];
        
        userHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        userHeadImg.image = [UIImage imageNamed:@"pesnal1"];
        [self addSubview:userHeadImg];
        
        userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(userHeadImg.right+10, 15, self.width-60-10-10-10-30, 18)];
        userNameLable.backgroundColor = [UIColor clearColor];
        userNameLable.text = @"";
        userNameLable.font = [UIFont systemFontOfSize:15.0f];
        [userNameLable sizeToFit];
        [self addSubview:userNameLable];
        
        userSex = [[UIImageView alloc] initWithFrame:CGRectMake(userNameLable.right+10, 15, 15, 15)];
        userSex.backgroundColor = [UIColor clearColor];
        [userSex setHidden:YES];
        [self addSubview:userSex];
        
        companyLable = [[UILabel alloc] initWithFrame:CGRectMake(userHeadImg.right+10, 40, self.width-60-10-10-10, 20)];
        companyLable.backgroundColor = [UIColor clearColor];
        companyLable.text = @"单位:";
        
        companyLable.font = [UIFont systemFontOfSize:12.0f];
        [companyLable sizeToFit];
        [self addSubview:companyLable];
        
        phoneLable = [[UILabel alloc] initWithFrame:CGRectMake(userHeadImg.right+10, 60, self.width-60-10-10-10, 20)];
        phoneLable.backgroundColor = [UIColor clearColor];
        phoneLable.text = @"电话:";
        phoneLable.font = [UIFont systemFontOfSize:12.0f];
        [phoneLable sizeToFit];
        [self addSubview:phoneLable];
    }
    return self;
}

@end
