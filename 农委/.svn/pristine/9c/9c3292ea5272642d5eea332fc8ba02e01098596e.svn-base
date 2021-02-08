//
//  LoginViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/10/28.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UIScrollView *mainScr;
    UITextField *usertf;//电话号码
    UITextField *passwordtf;//输入密码
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
-(void)initview
{
    mainScr=[[UIScrollView alloc]initWithFrame:CGRectMake(X(self.view), 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:mainScr];
    UIImageView *logoimgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , kScreenWidth, 258*Scale)];
    [logoimgview setImage:PNGIMAGE(@"login-bg")];
    [mainScr addSubview:logoimgview];
    //用户名
    UIImageView *logoimg=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-250)/2.0, YH(logoimgview)+60, 18, 22)];
    logoimg.contentMode=UIViewContentModeScaleAspectFit;
    [logoimg setImage:PNGIMAGE(@"login-ico1")];
    [mainScr addSubview:logoimg];
    usertf=[[CTextField alloc]initWithFrame:CGRectMake(XW(logoimg), Y(logoimg), 250-(XW(logoimg)), 22)];
    usertf.delegate=self;
    usertf.font=Font(16);
    usertf.autocorrectionType = UITextAutocorrectionTypeNo;
    usertf.placeholder=@"请输入用户名";
    usertf.text=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"stryhm"];
    [mainScr addSubview:usertf];
    
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(X(logoimg)-10, YH(logoimg)-2, 1, 4)];
    [line setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:line];
    
    UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(X(logoimg)-10+270-1, YH(logoimg)-2, 1, 4)];
    [line2 setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:line2];
    
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(X(logoimg)-10, YH(logoimg)+2, 270, 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:oneline];
    
    //密码
    UIImageView *passwordimg=[[UIImageView alloc]initWithFrame:CGRectMake(X(logoimg), YH(oneline)+25, 18, 22)];
    [passwordimg setImage:PNGIMAGE(@"login-ico2")];
    passwordimg.contentMode=UIViewContentModeScaleAspectFit;
    [mainScr addSubview:passwordimg];
    passwordtf=[[CTextField alloc]initWithFrame:CGRectMake(X(usertf), Y(passwordimg)+2, W(usertf), H(usertf))];
    passwordtf.delegate=self;
    passwordtf.font=Font(16);
    passwordtf.placeholder=@"请输入密码";
    passwordtf.secureTextEntry = YES;
    [mainScr addSubview:passwordtf];

    
    UIImageView *line3=[[UIImageView alloc]initWithFrame:CGRectMake(X(passwordimg)-10, YH(passwordimg)+1, 1, 4)];
    [line3 setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:line3];
    
    UIImageView *line4=[[UIImageView alloc]initWithFrame:CGRectMake(X(passwordimg)-10+270-1, Y(line3), 1, 4)];
    [line4 setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:line4];

    UIImageView *twoline=[[UIImageView alloc]initWithFrame:CGRectMake(X(oneline), YH(passwordimg)+5, W(oneline), 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].mainColor];
    [mainScr addSubview:twoline];
    //登陆按钮
    UIButton *loginbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginbtn.frame=CGRectMake(X(oneline), YH(twoline)+35, W(oneline), 45) ;
    [loginbtn setTitle:@"登  录" forState:0];
    [loginbtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(16)];
    [loginbtn addTarget:self action:@selector(loginBtnSEL:) forControlEvents:UIControlEventTouchUpInside];
    [mainScr addSubview:loginbtn];
    ViewRadius(loginbtn, 4);
    [mainScr setContentSize:CGSizeMake(W(mainScr), YH(loginbtn))];
}
#pragma mark--------------登录--------------
-(void)loginBtnSEL:(UIButton*)sender
{
    if ([Tools isBlankString:usertf.text]) {
        [Tools showMsgBox:@"请输入用户名"];
        [usertf becomeFirstResponder];
        return;
    }
    else if([Tools isBlankString:passwordtf.text])
    {
        [Tools showMsgBox:@"请输入密码"];
        [passwordtf becomeFirstResponder];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork login:usertf.text strmm:passwordtf.text completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功！"];
                NSMutableDictionary *userinfodic=[[NSMutableDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                if ([Tools isBlankString:[userinfodic objectForKey:@"strjsid"]]) {
                    [userinfodic setObject:@"-1" forKey:@"strjsid"];
                }
                [[NSUserDefaults standardUserDefaults]setObject:userinfodic forKey:@"userInfo"];
                 [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
            }
            else
            {
                [SVProgressHUD dismiss];
                [Tools showMsgBox:[rep objectForKey:@"msg"]];
            
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [Tools showMsgBox:emsg];
        }
    }];
}
-(void)gogo
{
    [[AppDelegate Share] showMain];
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
