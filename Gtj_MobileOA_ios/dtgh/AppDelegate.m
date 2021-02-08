//
//  AppDelegate.m
//  dtgh
//
//  Created by 熊佳佳 on 15/10/9.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "AppDelegate.h"
#import "SingleObj.h"
#import "LoginViewController.h"
#import "LBMainTabViewController.h"
#import "LBWorkViewController.h"
#import "VSGService.h"
@interface AppDelegate ()<UIAlertViewDelegate,VSGServiceDelegate>
{
    NSString *strwjdz;
    VSGService *service;
}
@end

@implementation AppDelegate
+ (AppDelegate *)Share
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self logoutVPN];
    //处理键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    // 控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    // 是否显示键盘上的工具条
    manager.enableAutoToolbar = YES;
    // 设置文本框的键盘距离,不能小于零,默认是10
    manager.keyboardDistanceFromTextField = 40;
    //处理主题风格
    [SingleObj defaultManager].mainColor=UIColorFromRGB(0x3b9ea8);
    [SingleObj defaultManager].backColor=RGBCOLOR(238, 240, 242);
    [SingleObj defaultManager].lineColor=UIColorFromRGB(0xefe8e8);
    [SingleObj defaultManager].boderlineColor=UIColorFromRGB(0xb1b2b4);
    [SingleObj defaultManager].origColor=UIColorFromRGB(0xda8601);
    [SingleObj defaultManager].subtitleColor=UIColorFromRGB(0x8d8d8d);
    [SingleObj defaultManager].emailColor=UIColorFromRGB(0x608e94);
    //提示框
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, .7)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    //处理导航栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:BoldFont(16),NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UINavigationBar appearance].barTintColor=[SingleObj defaultManager].mainColor;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
    [self showLogin];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
-(void)showLogin
{
    LoginViewController *pjhome=[[LoginViewController alloc]init];
    self.window.rootViewController=pjhome;
}
-(void)showMain
{
    LBWorkViewController *lbmainTab=[[LBWorkViewController alloc]init];
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *str=[NSString stringWithFormat:@"%@-%@",dic[@"strdwjc"],dic[@"strcsjc"]];
    lbmainTab.title=str;
    lbmainTab.ishide=YES;
    UINavigationController *lbmainlb=[[UINavigationController alloc]initWithRootViewController:lbmainTab];
    if (IOSOver(7.0)) {
        lbmainlb.interactivePopGestureRecognizer.delegate = (id)self;
    }
    self.window.rootViewController=lbmainlb;
    [SingleObj defaultManager].rootnav=lbmainlb;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self logoutVPN];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self logoutVPN];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self loginVPN];
}

- (void)applicationWillTerminate:(UIApplication *)application {
     [self logoutVPN];
}

/**
 登录连接VPN
 */
-(void)loginVPN
{
    [SVProgressHUD showWithStatus:@"VPN认证登录中！" maskType:SVProgressHUDMaskTypeClear];
    service = [[VSGService alloc] initWithAddress:@"218.70.58.218" port:4430 delegate:self];
    [service authWithParam:@"user1" paramKey:VSGAuthPassWordkUserName];
    [service authWithParam:@"Gtzy@123456" paramKey:VSGAuthPassWordkPassword];

    [service startAuthWithResourceType:VSGResourceTypeCSResource];
}

/**
 注销VPN
 */
- (void)logoutVPN
{
    //5.通信完成注销
    [service logout];
}


- (void)VSGService:(VSGService *)service authResult:(VSGAuthResult)result param:(NSDictionary *)param
{
    {
        switch (result)
        {
            case VSGAUTH_SUCCESS: //操作成功
            {
                //4.客户端开始自己的操作，SDK代理客转发户端数据
                [SVProgressHUD dismiss];
                NSLog(@"%@",[service getResources]);
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_USERNAMEPASSWORD: //多因素认证,上一因素认证成功,口令未验证
            {
                
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_CERTIFICATE: //多因素认证,上一因素认证成功,证书未验证
            {
                
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_SMS: //多因素认证,上一因素认证成功,短信未认证
            {
                
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_HARDWARE:  //多因素认证,上一因素认证成功,硬件特征码未认证
            {
                
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_BIND_IP: //多因素认证,上一因素认证成功,绑定主机未认证
            {
                
            }
                break;
            case VSGAUTH_MULTIFACTOR_NEED_MAC:  //多因素认证,上一因素认证成功,绑定 MAC 未认证
            {
                
            }
                break;
            case VSGAUTH_FRIST_LOGIN_MODIFY_PSW:  //口令因素,首次登陆,需修改密码,目前不支持
            {
                
            }
                break;
            case VSGAUTH_USER_NOT_FOUND_ERROR:  //认证失败,无该用户
            {
                [Tools showMsgBox:@"VPN认证失败,无效用户"];
            }
                break;
            case VSGAUTH_USER_PASSWORD_ERROR:  //认证失败,口令错
            {
                [Tools showMsgBox:@"VPN认证失败,认证密码错误"];
            }
                break;
                
            case VSGAUTH_MULTIFACTOR_REQUEST_NOT_LEGAL:  //多因素请求不合法
            {
                
            }
                break;
            case VSGAUTH_USERNAME_LOCKED:   //用户名已锁定
            {
                
            }
                break;
            case VSGAUTH_USER_OUTOF_VALID_PERIOD: //当前用户不在登录有效期内
            {
                [Tools showMsgBox:@"VPN认证失败,当前用户不在登录有效期内"];
            }
            case VSGAUTH_FORCE_ATTACK_LOCK: //暴力破解锁定用户或IP
                
            {
                
            }
                break;
            case VSGAUTH_ONLINE_OVER_LICENSE: //系统在线用户数已达最大
                
            {
                [Tools showMsgBox:@"VPN认证失败,系统在线用户数已达最大"];
            }
                break;
            case VSGAUTH_USER_NO_ACL: //该用户没有任何访问权限
                
            {
                [Tools showMsgBox:@"VPN认证失败,该用户没有任何访问权限"];
            }
                break;
            case VSGAUTH_USER_OR_PWD_WRONG:
            {
                [Tools showMsgBox:@"VPN认证失败,用户名或密码错误！"];
            }
                break;
            case VSGAUTH_GET_RESOURCE_ERROR: //获取资源错误
                
            {
                [Tools showMsgBox:@"VPN认证失败,获取资源错误！"];
            }
                break;
            case VSGAUTH_USER_NO_NET:
            {
                [Tools showMsgBox:@"VPN认证失败,无效的网络连接！"];
            }
                break;
            case VSGAUTH_USER_NO_VALID_WORLD:
            {
                [Tools showMsgBox:@"VPN认证失败,用户名或密码为空！"];
            }
                break;
            case VSGAUTH_USER_TIME_OUT:
            {
                [Tools showMsgBox:@"VPN认证失败,请求超时！"];
            }
                break;
            case VSGAUTH_USER_NO_VALID_ADDRESS:
            {
                [Tools showMsgBox:@"VPN认证失败,地址无效！"];
            }
                break;
            case VSGAUTH_MULTAPP_NO_AUTH:
            {
                NSLog(@"多APP情况时，还没有其他APP认证通过！");
            }
                break;
            case VSGAUTH_MULTAPP_NO_SESSION:
            {
                NSLog(@"多APP情况时，认证超时，请重新认证！");
            }
                break;
            default:
                break;
        }
    }
    
}

@end
