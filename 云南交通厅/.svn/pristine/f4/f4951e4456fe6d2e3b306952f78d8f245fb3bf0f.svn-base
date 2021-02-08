//
//  LoginVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/9/27.
//  Copyright © 2016年 xj. All rights reserved.
//



#import "LoginVC.h"
#import "CTextField.h"
#import "ztOASettingViewController.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "QButton.h"
#import "iAppOffice.h"
@interface LoginVC ()
@property (nonatomic,strong)CTextField *usernametf;//用户
@property (nonatomic,strong)CTextField *passwrodtf;//密码
@end

@implementation LoginVC
@synthesize usernametf,passwrodtf;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkVPN) name:@"HomePage" object:nil];
    [self initview];
    //[self deviceBandState];
    // Do any additional setup after loading the view.
}
#pragma mark---------初始化界面----------------------
-(void)initview{
    UIImageView *bg_img=[[UIImageView alloc]initWithFrame:self.view.bounds];
    [bg_img setImage:PNGIMAGE(@"loading_BigBackImg")];
    [self.view addSubview:bg_img];
    
    UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, 20, 20)];
    setBtn.right=kScreenWidth-15;
    [setBtn setBackgroundImage:PNGIMAGE(@"设置") forState:0];
    [setBtn bk_addEventHandler:^(id sender) {
        ztOASettingViewController *bingdingvc=[[ztOASettingViewController alloc]initWithTitle:@"设置"];
        [self.navigationController pushViewController:bingdingvc animated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setBtn];
    
    UIImageView *logoImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight/2-184, 80, 80)];
    logoImg.contentMode=UIViewContentModeScaleAspectFit;
    logoImg.image = [Tools getIconImge];
    logoImg.centerX=kScreenWidth/2.0;
    logoImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:logoImg];
   
    UIImageView *wzImge=[[UIImageView alloc]initWithFrame:CGRectMake(0, logoImg.bottom+20, 200, 12)];
    wzImge.centerX=kScreenWidth/2.0;
    wzImge.image = [UIImage imageNamed:@"wzlogo"];
    wzImge.backgroundColor = [UIColor clearColor];
    [self.view addSubview:wzImge];
    
    UIImageView *srk=[[UIImageView alloc]initWithFrame:CGRectMake(20, wzImge.bottom+20, kScreenWidth-40, 44)];
    [srk setImage:PNGIMAGE(@"srk")];
    [self.view addSubview:srk];
    UIImageView *userImge=[[UIImageView alloc]initWithFrame:CGRectMake(40, srk.top+7, 30, 30)];
    [userImge setImage:PNGIMAGE(@"loading_user_btnImg")];
    [self.view addSubview:userImge];
    
    usernametf =[[CTextField alloc] initWithFrame:CGRectMake(userImge.right, userImge.top+1, srk.width-40-20, 30-1)];
    usernametf.text=SingObj.userInfo.userzh;
    //关闭系统自动联想和首字母大写功能
    [usernametf setAutocorrectionType:UITextAutocorrectionTypeNo];
    [usernametf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    usernametf.returnKeyType = UIReturnKeyDone;
    [usernametf setBackgroundColor:[UIColor whiteColor]];
    [usernametf setBorderStyle:UITextBorderStyleNone];
    [usernametf setFont:Font(14)];
    [usernametf setKeyboardType:UIKeyboardTypeDefault];
    usernametf.placeholder = @"请输入用户名";
    [self.view addSubview:usernametf];
    
    UIImageView *srk2=[[UIImageView alloc]initWithFrame:CGRectMake(20, srk.bottom+7, srk.width, srk.height)];
    [srk2 setImage:PNGIMAGE(@"srk")];
    [self.view addSubview:srk2];
    
    UIImageView *pasImg=[[UIImageView alloc]initWithFrame:CGRectMake(40, srk2.top+7, 30, 30)];
    [pasImg setImage:PNGIMAGE(@"loadingkey")];
    [self.view addSubview:pasImg];
    
    
    passwrodtf =[[CTextField alloc] initWithFrame:CGRectMake(pasImg.right, pasImg.top+1, srk.width-40-20, 30-1)];
    passwrodtf.returnKeyType = UIReturnKeyDone;
    [passwrodtf setSecureTextEntry:YES];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"remberPassword"]==YES) {
        passwrodtf.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"PasWord"];
    }
    [passwrodtf setBackgroundColor:[UIColor whiteColor]];
    [passwrodtf setBorderStyle:UITextBorderStyleNone];
    [passwrodtf setFont:Font(14)];
    [passwrodtf setKeyboardType:UIKeyboardTypeDefault];
    passwrodtf.placeholder = @"请输入密码";
    [self.view addSubview:passwrodtf];
    
    UIButton *buton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, passwrodtf.height)];
    buton.backgroundColor = [UIColor clearColor];
    [buton setBackgroundImage:[UIImage imageNamed:@"can_off"] forState:UIControlStateNormal];
    [buton setBackgroundImage:[UIImage imageNamed:@"can_on"] forState:UIControlStateSelected];
    [buton setSelected:NO];
    [buton bk_addEventHandler:^(UIButton *sender) {
        sender.selected=!sender.selected;
        if (sender.selected) {
            [passwrodtf setSecureTextEntry:NO];
        }else
        {
            [passwrodtf setSecureTextEntry:YES];
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    passwrodtf.rightView=buton;
    passwrodtf.rightViewMode=UITextFieldViewModeAlways;
    //记住密码
    QButton *rmberBtn=[[QButton alloc]initWithFrame:CGRectMake(srk2.left+5, srk2.bottom+6, 120, 30)];
    rmberBtn.selected=[[NSUserDefaults standardUserDefaults]boolForKey:@"remberPassword"];
    [rmberBtn setImage:PNGIMAGE(@"unchecked") forState:UIControlStateNormal];
    [rmberBtn setImage:PNGIMAGE(@"checked") forState:UIControlStateSelected];
    [rmberBtn setTitle:@"记住密码" forState:UIControlStateSelected];
    [rmberBtn setTitle:@"记住密码" forState:UIControlStateNormal];
    [rmberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rmberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rmberBtn bk_addEventHandler:^(UIButton *sender) {
        sender.selected=!sender.selected;
        [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:@"remberPassword"];
    } forControlEvents:UIControlEventTouchUpInside];
    rmberBtn.titleLabel.font=Font(13);
    [self.view addSubview:rmberBtn];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(90, rmberBtn.bottom+20, kScreenWidth-180, 40)];
    [btn bootstrapNoborderStyle:UIColorFromRGB(0xffa700) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    [btn setTitle:@"登录" forState:0];
    ViewRadius(btn, 4);
    [btn bk_addEventHandler:^(id sender) {
        [self loginBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UILabel *bottomLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 15)];
    bottomLable1.font = [UIFont systemFontOfSize:12.0f];
    bottomLable1.text = @"Copyright © 2017 重庆南华中天";
    bottomLable1.textAlignment = NSTextAlignmentCenter;
    [bottomLable1 setTextColor:[UIColor whiteColor]];
    [bottomLable1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bottomLable1];
    
    UILabel *bottomLable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomLable1.bottom+15, bottomLable1.width, 15)];
    bottomLable2.font = [UIFont systemFontOfSize:10.0f];
    bottomLable2.text = @"All Right Reserved.";
    bottomLable2.textAlignment = NSTextAlignmentCenter;
    [bottomLable2 setTextColor:[UIColor whiteColor]];
    [bottomLable2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bottomLable2];
}
#pragma mark--------设备号绑定状态---------------------
-(void)deviceBandState
{
    NSDictionary *deviceDic =@{@"moveEquipmentId":[YYBSingObj defaultManager].deviceId};
    [self network:@"userbindservices" requestMethod:@"selBindState" requestHasParams:@"true" parameter:deviceDic progresHudText:@"加载中..." completionBlock:^(id rep) {
        
    }];
}
#pragma mark-------------用户登录-------
-(void)loginBtn{
    if ([usernametf.text deletespace].length==0) {
        [Tools showMsgBox:@"请输入用户名"];
        return;
    }else if ([passwrodtf.text deletespace].length==0)
    {
        [Tools showMsgBox:@"请输入密码"];
        return;
    }
    NSDictionary *dataDic=@{@"userName":[usernametf.text deletespace],@"password":[passwrodtf.text deletespace],@"moveEquipmentId":[YYBSingObj defaultManager].deviceId,@"moveEquipmentLx":@"IOS"};
    [self networkLogin:@"usercenter" requestMethod:@"login" requestHasParams:@"true" parameter:dataDic progresHudText:@"登录中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"result"] intValue]==0) {
                [[NSUserDefaults standardUserDefaults] setObject:rep forKey:@"LoginModel"];
                LoginModel *loginData=[LoginModel mj_objectWithKeyValues:rep];
                SingObj.loginModel=loginData;
                SingObj.userInfo=loginData.userinfo;
                SingObj.unitInfo=loginData.unitinfo;
                [[NSUserDefaults standardUserDefaults]setObject:passwrodtf.text forKey:@"PasWord"];
                NSLog(@"%@",SingObj.userInfo.strjgsqbz);
              [iAppOffice registerApp:@"SxD/phFsuhBWZSmMVtSjKZmm/c/3zSMrkV2Bbj5tznSkEVZmTwJv0wwMmH/+p6wLoNnijZivte1o2Pp/TKv+CGGZP5RXoJcf1DoZz6y2IY7Mtp4LyzKIV3xPRYF3lGXWamCYPINmxaVaa6a2HH1k/M5NbDM5XKhiPM4XdfRA3OxPvsnYdbfI55ihHRO83/szbsTJteY5ygPAD1k/8DTGN1Q9PW1waQ44Wyx97rcHxfA6ZrJXaGett5dn6pZWrNH3+8AeeXdPnFU7ViaZZz+Cb8zZ6PzW00XssjUrFarnaGftVCa2fPSzjGPW+nVFg+el0WKoxaHyYx/QrV7St7Yy8GzeDYUeCGH3mqNaobVYFovYh9I9pW7lBnOBFhskXFYAgkQLXJLGBuoP95zYF78d6Dc7qpKiQmpkMVMtYsbbuIT7wB55d0+cVTtWJplnP4JvnwGBxbb+c/6f8a64N4TtJA==" wpsKey:[SingObj.userInfo.strjgsqbz intValue]==1?@"USXEVT-SMEK-NHSSKKWG-GRKNEP-TZVHGEYH":nil];//NMWGKW-GPWZ-PHSEZZWT-TYGVWT-WPMUVYEU
                [[AppDelegate Share] showHomePage];
            }else if ([rep[@"result"] intValue]==1)
            {
                UIAlertView *alerview=[UIAlertView bk_alertViewWithTitle:@"温馨提示" message:@"设备id无效，请先绑定设备帐号哦～"];
                [alerview bk_setCancelButtonWithTitle:@"确定" handler:^{
                    ztOASettingViewController *bingdingvc=[[ztOASettingViewController alloc]initWithTitle:@"设置"];
                    [self.navigationController pushViewController:bingdingvc animated:YES];
                }];
                [alerview show];
            }
            else if ([rep[@"result"] intValue]==2)
            {
                [Tools showMsgBox:@"密码错误"];
            }
            else if ([rep[@"result"] intValue]==3)
            {
                [Tools showMsgBox:@"用户名无效"];
            }
            else if ([rep[@"result"] intValue]==4)
            {
                
            }
            else if ([rep[@"result"] intValue]==5)
            {
                
            }
            else{
                [Tools showMsgBox:@"未知异常"];
            }
        }
    }];
}
-(void)linkVPN{
    [self versionUp];
}
#pragma mark-----------------------请求升级接口-----------------
-(void)versionUp{
    [self newworkversionallGet:@"ios.json" parameter:nil progresHudText:nil completionBlock:^(id rep) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"%@",app_Version);
        if (rep!=nil) {
            NSLog(@"%@",[rep mj_JSONObject]);
            NSDictionary *redic=[rep mj_JSONObject];
            if ([redic isKindOfClass:[NSDictionary class]])
            {
                if (![app_Version isEqualToString:redic[@"version"]]) {
                    UIAlertView *alertv=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"已有新版本请升级" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                         if (buttonIndex==1) {
                            // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:redic[@"apkurl"]]];
                             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",redic[@"apkurl"]]]];
                        }
                    }];
                    [alertv show];
                }
                NSLog(@"%@",redic);
            }
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
