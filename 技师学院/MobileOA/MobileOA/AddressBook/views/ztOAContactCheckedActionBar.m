//
//  ztOAContactCheckedActionBar.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-16.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAContactCheckedActionBar.h"
#import <QuartzCore/QuartzCore.h>
@implementation ztOAContactCheckedActionBar
@synthesize backImage,closeBtn,checkNumberInfo,loadAllToPhone,sendMessageToPhone,cancelCheckedBtn;
@synthesize loadToPhoneNumLable,sendMsgNumLable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backBtnImg = [UIImage imageNamed:@"banner_bg"];
        NSInteger leftCapWidth = backBtnImg.size.width * 0.5f;
        NSInteger topCapHeight = backBtnImg.size.height * 0.5f;
        backBtnImg = [backBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        loadAllToPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        loadAllToPhone.frame = CGRectMake(0, 0, (self.width-50)/3, self.height);
        [loadAllToPhone setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        loadAllToPhone.backgroundColor = [UIColor clearColor];
        [self addSubview:loadAllToPhone];
        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(((self.width-50)/3-40)/2, (self.height-40)/2, 40, 40)];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image = [UIImage imageNamed:@"checkBar_phone"];
        [loadAllToPhone addSubview:iconImage];
        
        loadToPhoneNumLable = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right,10 , ((self.width-50)/3-30)/2, 15)];
        loadToPhoneNumLable.backgroundColor = [UIColor clearColor];
        loadToPhoneNumLable.font = [UIFont systemFontOfSize:10];
        loadToPhoneNumLable.textAlignment = NSTextAlignmentLeft;
        loadToPhoneNumLable.textColor = [UIColor redColor];
        loadToPhoneNumLable.text = @"(0)";
        [loadAllToPhone addSubview:loadToPhoneNumLable];
        
        sendMessageToPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        sendMessageToPhone.frame = CGRectMake(loadAllToPhone.right, 0, (self.width-50)/3, self.height);
        [sendMessageToPhone setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        sendMessageToPhone.backgroundColor = [UIColor clearColor];
        [self addSubview:sendMessageToPhone];
        
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(((self.width-50)/3-40)/2, (self.height-40)/2, 40, 40)];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image = [UIImage imageNamed:@"checkBar_sendMesg"];
        [sendMessageToPhone addSubview:iconImage];
        
        sendMsgNumLable = [[UILabel alloc] initWithFrame:CGRectMake(iconImage.right,10 , ((self.width-50)/3-30)/2, 15)];
        sendMsgNumLable.font = [UIFont systemFontOfSize:10];
        sendMsgNumLable.backgroundColor = [UIColor clearColor];
        sendMsgNumLable.textAlignment = NSTextAlignmentLeft;
        sendMsgNumLable.textColor = [UIColor redColor];
        sendMsgNumLable.text = @"(0)";
        [sendMessageToPhone addSubview:sendMsgNumLable];
        
        cancelCheckedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelCheckedBtn.frame = CGRectMake(sendMessageToPhone.right, 0, (self.width-50)/3, self.height);
        [cancelCheckedBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        cancelCheckedBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:cancelCheckedBtn];
        
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(((self.width-50)/3-40)/2, (self.height-40)/2, 40, 40)];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image = [UIImage imageNamed:@"checkBar_cancelCheck"];
        [cancelCheckedBtn addSubview:iconImage];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(cancelCheckedBtn.right, 0, 50, self.height);
        [closeBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        closeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:closeBtn];
        
        iconImage = [[UIImageView alloc]initWithFrame:CGRectMake((50-40)/2, (self.height-40)/2, 40, 40)];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image = [UIImage imageNamed:@"checkBar_closeCheckBar"];
        [closeBtn addSubview:iconImage];
    }
    return self;
}



@end
