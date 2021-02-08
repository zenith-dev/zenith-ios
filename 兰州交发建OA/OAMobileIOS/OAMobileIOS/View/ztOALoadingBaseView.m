//
//  ztOALoadingBaseView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-10.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOALoadingBaseView.h"

@implementation ztOALoadingBaseView
@synthesize bigBackImage,logoImg,titleImage,loadingKeyword,loadingInBtn,bottomLable1,bottomLable2,settingBtn;
@synthesize passWordBckBtn,messageLoadingBtn,canSeeWordBtn;
@synthesize bandDeviceStateLable;
@synthesize keyBackImg1,keyBackImg2,keyBackImg3,keyWordWhiteBack,deviceBandImage,loadingUserName,userBandImage,userNameWhiteBack;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //背景图
        self.bigBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bigBackImage.image = [UIImage imageNamed:@"loading_BigBackImg"];
        bigBackImage.backgroundColor = [UIColor clearColor];
        [self addSubview:bigBackImage];
        //字
        UIImageView *ziImge=[[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height/2-20-32-30-14-88, 255, 16)];
        ziImge.contentMode=UIViewContentModeScaleAspectFit;
        ziImge.centerX=kScreenWidth/2.0;
        [ziImge setImage:PNGIMAGE(@"logo_text")];
        [self addSubview:ziImge];
        
        //logo
        self.logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 90, 60)];
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        logoImg.image = [UIImage imageNamed:@"icon"];
        logoImg.backgroundColor = [UIColor clearColor];
        [self addSubview:logoImg];
        //标题
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-200)/2, ziImge.bottom+40, 200, 12)];
        titleImage.image = [UIImage imageNamed:@"loading_yidongbangong_wenzi"];
        titleImage.backgroundColor = [UIColor clearColor];
        [self addSubview:titleImage];
        
        self.keyBackImg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_key_backImg1"]];
        keyBackImg2.backgroundColor = [UIColor clearColor];
        keyBackImg2.frame = CGRectMake(20, frame.size.height/2-88, frame.size.width-40, 44);
        [self addSubview:keyBackImg2];
        
        self.keyBackImg3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_key_backImg1"]];
        keyBackImg3.backgroundColor = [UIColor clearColor];
        keyBackImg3.frame = CGRectMake(20, frame.size.height/2-44, frame.size.width-40, 44);
        [self addSubview:keyBackImg3];
        
        //用户名输入栏
        self.userNameWhiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(40, frame.size.height/2-88+7, frame.size.width-80, 30)];
        userNameWhiteBack.backgroundColor = [UIColor whiteColor];
        [self addSubview:userNameWhiteBack];
        
        self.userBandImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_user_btnImg"]];
        userBandImage.frame = CGRectMake(40,frame.size.height/2-88+7,30, 30);
        [self addSubview:userBandImage];
        
        self.loadingUserName =[[UITextField alloc] initWithFrame:CGRectMake(40+30+5, frame.size.height/2-88+7+5, frame.size.width-80-30-10, 20)];
        loadingUserName.returnKeyType = UIReturnKeyDone;
        loadingUserName.textAlignment = NSTextAlignmentLeft;
        loadingUserName.backgroundColor = [UIColor clearColor];
        [loadingUserName setBorderStyle:UITextBorderStyleNone];
        [loadingUserName setFont:[UIFont systemFontOfSize:14.0f]];
        [loadingUserName setKeyboardType:UIKeyboardTypeDefault];
        loadingUserName.placeholder = @"请输入用户名";
        [self addSubview:loadingUserName];

        //密码输入栏
        self.keyWordWhiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(40, frame.size.height/2-44+7, frame.size.width-80, 30)];
        keyWordWhiteBack.backgroundColor = [UIColor whiteColor];
        [self addSubview:keyWordWhiteBack];
        
        self.deviceBandImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_key_btnImg"]];
        deviceBandImage.frame = CGRectMake(40,frame.size.height/2-44+7,30, 30);
        [self addSubview:deviceBandImage];
        
        self.loadingKeyword = [[UITextField alloc] initWithFrame:CGRectMake(40+30+5, frame.size.height/2-44+7+5, frame.size.width-80-30-50, 20)];
        loadingKeyword.returnKeyType = UIReturnKeyDone;
        loadingKeyword.textAlignment = NSTextAlignmentLeft;
        loadingKeyword.backgroundColor = [UIColor clearColor];
        [loadingKeyword setBorderStyle:UITextBorderStyleNone];
        [loadingKeyword setFont:[UIFont systemFontOfSize:14.0f]];
        [loadingKeyword setKeyboardType:UIKeyboardTypeDefault];
        loadingKeyword.leftViewMode = UITextFieldViewModeAlways;
        [loadingKeyword setSecureTextEntry:YES];
        loadingKeyword.placeholder = @"请输入密码";
        [self addSubview:loadingKeyword];

        //密码显示开关按钮
        self.canSeeWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        canSeeWordBtn.frame = CGRectMake(loadingKeyword.right+5, frame.size.height/2-44+7, 40, 30);
        canSeeWordBtn.backgroundColor = [UIColor clearColor];
        [canSeeWordBtn setBackgroundImage:[UIImage imageNamed:@"canSeeIcon_off"] forState:UIControlStateNormal];
        [canSeeWordBtn setBackgroundImage:[UIImage imageNamed:@"canSeeIcon_on"] forState:UIControlStateSelected];
        [canSeeWordBtn setSelected:NO];
        [self addSubview:canSeeWordBtn];
        
        //绑定状态
        self.bandDeviceStateLable =[[UILabel alloc] initWithFrame:CGRectMake(30, frame.size.height/2, frame.size.width-150-30, 20)];
        bandDeviceStateLable.font = [UIFont systemFontOfSize:12.0f];
        bandDeviceStateLable.text = @"设备绑定状态:未知";
        bandDeviceStateLable.textAlignment = NSTextAlignmentLeft;
        [bandDeviceStateLable setTextColor:[UIColor whiteColor]];
        [bandDeviceStateLable setBackgroundColor:[UIColor clearColor]];
        //[self addSubview:bandDeviceStateLable];
        
        //密码找回
        self.passWordBckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        passWordBckBtn.frame = CGRectMake(frame.size.width-150, frame.size.height/2, 60, 30);
        [passWordBckBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [passWordBckBtn setTitle:@"密码找回" forState:UIControlStateNormal];
        [passWordBckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [passWordBckBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [passWordBckBtn setBackgroundColor:[UIColor clearColor]];
        //[self addSubview:passWordBckBtn];
        
        //短信登录
        self.messageLoadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageLoadingBtn.frame = CGRectMake(frame.size.width-80, frame.size.height/2, 60, 30);
        [messageLoadingBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [messageLoadingBtn setTitle:@"短信登录" forState:UIControlStateNormal];
        [messageLoadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [messageLoadingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [messageLoadingBtn setBackgroundColor:[UIColor clearColor]];
        //[self addSubview:messageLoadingBtn];
        
        UIImage *loadindBtnImg = [UIImage imageNamed:@"color_03"];
        NSInteger leftCapWidth = loadindBtnImg.size.width * 0.5f;
        NSInteger topCapHeight = loadindBtnImg.size.height * 0.5f;
        loadindBtnImg = [loadindBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        //登录按钮
        self.loadingInBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, frame.size.height/2+20, frame.size.width-40, 38)];
        [loadingInBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loadingInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loadingInBtn setBackgroundImage:loadindBtnImg forState:UIControlStateNormal];
        
        [self addSubview:loadingInBtn];
        
        self.bottomLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-50, frame.size.width, 15)];
        bottomLable1.font = [UIFont systemFontOfSize:12.0f];
        bottomLable1.text = @"Copyright © 2017 重庆南华中天";
        bottomLable1.textAlignment = NSTextAlignmentCenter;
        [bottomLable1 setTextColor:[UIColor whiteColor]];
        [bottomLable1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLable1];
        
        self.bottomLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-50+15, frame.size.width, 15)];
        bottomLable2.font = [UIFont systemFontOfSize:10.0f];
        bottomLable2.text = @"All Right Reserved.";
        bottomLable2.textAlignment = NSTextAlignmentCenter;
        [bottomLable2 setTextColor:[UIColor whiteColor]];
        [bottomLable2 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLable2];
        
        self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        settingBtn.frame = CGRectMake(frame.size.width-55, 20, 50, 50);
        [settingBtn setImageEdgeInsets:UIEdgeInsetsMake(10,10 , 10, 10)];
        [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [settingBtn setImage:[UIImage imageNamed:@"loading_setting_btn_off"] forState:UIControlStateNormal];
        [self addSubview:settingBtn];
        //[settingBtn setHidden:YES];
    }
    return self;
}
- (void)showUserLoginView:(BOOL)showType
{
    if (showType==YES) {
        //用户名登录
        [self.keyBackImg2 setHidden:NO];
        [self.userNameWhiteBack setHidden:NO];
        [self.userBandImage setHidden:NO];
        [self.loadingUserName setHidden:NO];
    }
    else
    {
        //设备号登录
        [self.keyBackImg2 setHidden:NO];
        [self.userNameWhiteBack setHidden:NO];
        [self.userBandImage setHidden:NO];
        [self.loadingUserName setHidden:NO];
    }
}
@end
