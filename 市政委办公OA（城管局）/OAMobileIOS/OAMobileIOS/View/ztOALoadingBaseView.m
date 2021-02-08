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
        //logo
        self.logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 90, 90)];
        logoImg.centerX=kScreenWidth/2.0;
        logoImg.clipsToBounds=YES;
        logoImg.contentMode=UIViewContentModeScaleAspectFit;
        logoImg.image = [UIImage imageNamed:@"icon"];
        logoImg.backgroundColor = [UIColor clearColor];
        [self addSubview:logoImg];
        //标题
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-200)/2, logoImg.bottom+10, 200, 12)];
        titleImage.image = [UIImage imageNamed:@"loading_yidongbangong_wenzi"];
        titleImage.backgroundColor = [UIColor clearColor];
        [self addSubview:titleImage];
        
        self.userBandImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_user_btnImg"]];
        userBandImage.frame = CGRectMake(0,0,30, 30);
        
        self.loadingUserName =[[CTextField alloc] initWithFrame:CGRectMake(30, titleImage.bottom+20, kScreenWidth-60, 30)];
        [loadingUserName setBackgroundColor:[UIColor whiteColor]];
        loadingUserName.leftView=userBandImage;
        loadingUserName.leftViewMode=UITextFieldViewModeAlways;
        loadingUserName.returnKeyType = UIReturnKeyDone;
        [loadingUserName setBorderStyle:UITextBorderStyleNone];
        [loadingUserName setFont:[UIFont systemFontOfSize:14.0f]];
        [loadingUserName setKeyboardType:UIKeyboardTypeDefault];
        loadingUserName.placeholder = @"请输入OA账号";
        [self addSubview:loadingUserName];

        self.deviceBandImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_key_btnImg"]];
        deviceBandImage.frame = CGRectMake(0,0,30, 30);
      
        
        self.loadingKeyword = [[CTextField alloc] initWithFrame:CGRectMake(30, loadingUserName.bottom+10,loadingUserName.width,loadingUserName.height)];
        loadingKeyword.leftView=deviceBandImage;
        [loadingKeyword setBackgroundColor:[UIColor whiteColor]];
        loadingKeyword.leftViewMode=UITextFieldViewModeAlways;
        loadingKeyword.returnKeyType = UIReturnKeyDone;
        [loadingKeyword setBorderStyle:UITextBorderStyleNone];
        [loadingKeyword setFont:[UIFont systemFontOfSize:14.0f]];
        [loadingKeyword setKeyboardType:UIKeyboardTypeDefault];
        [loadingKeyword setSecureTextEntry:YES];
        loadingKeyword.placeholder = @"请输入密码";
        [self addSubview:loadingKeyword];

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
        
        //短信登陆
        self.messageLoadingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        messageLoadingBtn.frame = CGRectMake(frame.size.width-80, frame.size.height/2, 60, 30);
        [messageLoadingBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [messageLoadingBtn setTitle:@"短信登陆" forState:UIControlStateNormal];
        [messageLoadingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [messageLoadingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [messageLoadingBtn setBackgroundColor:[UIColor clearColor]];
        //[self addSubview:messageLoadingBtn];
        
        UIImage *loadindBtnImg = [UIImage imageNamed:@"color_03"];
        NSInteger leftCapWidth = loadindBtnImg.size.width * 0.5f;
        NSInteger topCapHeight = loadindBtnImg.size.height * 0.5f;
        loadindBtnImg = [loadindBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        //登陆按钮
        self.loadingInBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, loadingKeyword.bottom+30, frame.size.width-180, 38)];
        [loadingInBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [loadingInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loadingInBtn setBackgroundImage:loadindBtnImg forState:UIControlStateNormal];
        [self addSubview:loadingInBtn];
        
        self.bottomLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-70, frame.size.width, 15)];
        bottomLable1.font = [UIFont systemFontOfSize:10.0f];
        bottomLable1.text = @"Copyright @ 2017 重庆市城市管理局";
        bottomLable1.textAlignment = NSTextAlignmentCenter;
        [bottomLable1 setTextColor:[UIColor whiteColor]];
        [bottomLable1 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLable1];
        
        self.bottomLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomLable1.bottom, frame.size.width, 15)];
        bottomLable2.font = [UIFont systemFontOfSize:10.0f];
        bottomLable2.text = @"All Right Reserved.";
        bottomLable2.textAlignment = NSTextAlignmentCenter;
        [bottomLable2 setTextColor:[UIColor whiteColor]];
        [bottomLable2 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLable2];
        
        UILabel *bottomLable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomLable2.bottom, frame.size.width, 15)];
        bottomLable3.font = [UIFont systemFontOfSize:10.0f];
        bottomLable3.text = @"技术支持:重庆南华中天信息技术有限公司";
        bottomLable3.textAlignment = NSTextAlignmentCenter;
        [bottomLable3 setTextColor:[UIColor whiteColor]];
        [bottomLable3 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bottomLable3];
        
        
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
        //用户名登陆
        [self.keyBackImg2 setHidden:NO];
        [self.userNameWhiteBack setHidden:NO];
        [self.userBandImage setHidden:NO];
        [self.loadingUserName setHidden:NO];
    }
    else
    {
        //设备号登陆
        [self.keyBackImg2 setHidden:NO];
        [self.userNameWhiteBack setHidden:NO];
        [self.userBandImage setHidden:NO];
        [self.loadingUserName setHidden:NO];
    }
}
@end
