//
//  AppDelegate.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/2/24.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//
#import <sys/socket.h>
#import <sys/time.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <time.h>
#import <pthread.h>
#import "AppDelegate.h"
#import "YYBSingObj.h"
#import <AdSupport/AdSupport.h>
#import "LoginVC.h"
#import "HomePageVC.h"
#import "iAppOffice.h"
#import "iAppOfficeService.h"
#import "KWFileSystemModel.h"
#define  LOGINPATH @"ZTMobileGateway/oaAjaxServlet"
// 以下是认证可能会用到的认证信息
short port = 443;                      //vpn设备端口号，一般为443
NSString *vpnIp =    @"221.3.143.67";  //vpn设备IP地址
NSString *userName = @"移动OA";         //用户名认证的用户名
NSString *password = @"jttOA@123456";  //用户名认证的密码
NSString *certName = @"";    //导入证书名字，如果服务端没有设置证书认证可以不设置
NSString *certPwd =  @"";    //证书密码，如果服务端没有设置证书

@interface AppDelegate ()

@end

@implementation AppDelegate
//@synthesize helper;
+ (AppDelegate *)Share
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //处理键盘
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self baseunit];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LoginModel"]!=nil) {
        NSDictionary *rep=[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginModel"];
        LoginModel *loginData=[LoginModel mj_objectWithKeyValues:rep];
        SingObj.loginModel=loginData;
        SingObj.userInfo=loginData.userinfo;
        SingObj.unitInfo=loginData.unitinfo;
    }
    //[iAppOffice registerApp:@"SxD/phFsuhBWZSmMVtSjKZmm/c/3zSMrkV2Bbj5tznSkEVZmTwJv0wwMmH/+p6wLoNnijZivte1o2Pp/TKv+CGGZP5RXoJcf1DoZz6y2IY7Mtp4LyzKIV3xPRYF3lGXWamCYPINmxaVaa6a2HH1k/M5NbDM5XKhiPM4XdfRA3OxPvsnYdbfI55ihHRO83/szbsTJteY5ygPAD1k/8DTGN1Q9PW1waQ44Wyx97rcHxfA6ZrJXaGett5dn6pZWrNH3+8AeeXdPnFU7ViaZZz+Cb8zZ6PzW00XssjUrFarnaGftVCa2fPSzjGPW+nVFg+el0WKoxaHyYx/QrV7St7Yy8GzeDYUeCGH3mqNaobVYFovYh9I9pW7lBnOBFhskXFYAgkQLXJLGBuoP95zYF78d6Dc7qpKiQmpkMVMtYsbbuIT7wB55d0+cVTtWJplnP4JvnwGBxbb+c/6f8a64N4TtJA==" wpsKey:nil];//NMWGKW-GPWZ-PHSEZZWT-TYGVWT-WPMUVYEU
    //[iAppOffice setPort:3121];
    //[iAppOffice sharedInstance].debugMode = YES;
    //NSLog(@"AppDelegate: <-[application:didFinishLaunchingWithOptions:] 授权结果：[%d]", [iAppOffice sharedInstance].isAuthorized);
    //for (NSString *key in [iAppOffice sharedInstance].authorizedInfo.allKeys) {
        
      //  NSLog(@" %@ = %@", key, [[iAppOffice sharedInstance].authorizedInfo objectForKey:key]);
    //}
    //NSLog(@"}>");
    
    //注册通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWPSDocumentNotification:) name:@"WPSDocumentNotification" object:nil];
    
    LoginVC *loginvc=[[LoginVC alloc]initWithTitle:@"登录"];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:loginvc];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
/**
 *显示首页
 */
-(void)showHomePage{
    NSDictionary *rep=[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginModel"];
    LoginModel *loginData=[LoginModel mj_objectWithKeyValues:rep];
    SingObj.loginModel=loginData;
    SingObj.userInfo=loginData.userinfo;
    SingObj.unitInfo=loginData.unitinfo;
    HomePageVC *hompagevc=[[HomePageVC alloc]initWithTitle:@"首页"];
    hompagevc.hideLeft=YES;
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:hompagevc];
}
-(void)showLogin
{
    LoginVC *loginvc=[[LoginVC alloc]initWithTitle:@"登录"];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:loginvc];
}
/**
 *  基本配置
 */
-(void)baseunit{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
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
    //处理导航栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UINavigationBar appearance].barTintColor=RGBCOLOR(39, 87, 197);
    SingObj.mainColor=RGBCOLOR(39, 87, 197);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"]==nil){
        NSArray *tempary=[[NSArray alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:tempary forKey:@"gwsc"];
        [YYBSingObj defaultManager].serviceIp = @"220.163.10.230";
        [YYBSingObj defaultManager].servicePort = @"7070";
        [[NSUserDefaults standardUserDefaults] setValue:[YYBSingObj defaultManager].serviceIp forKey:@"baseServiceIp"];
        [[NSUserDefaults standardUserDefaults] setValue:[YYBSingObj defaultManager].servicePort forKey:@"baseServicePort"];
    }
    else
    {
        [YYBSingObj defaultManager].serviceIp =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"];
        [YYBSingObj defaultManager].servicePort =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServicePort"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"]==nil) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"openVPN"];
        NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [YYBSingObj defaultManager].deviceId = advertisingId;
        [[NSUserDefaults standardUserDefaults] setValue:advertisingId forKey:@"deviceIdSave"];
    }
    else
    {
        [YYBSingObj defaultManager].deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openVPN"];
//    helper = [[AuthHelper alloc] initWithHostAndPort:vpnIp port:port delegate:self];
//    //设置认证参数 用户名和密码以数值map的形式传入
//    [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
//    [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
    //开始用户名密码认证
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"openVPN"]==YES) {
    //   [SVProgressHUD showWithStatus:@"正在连接VPN..." maskType:SVProgressHUDMaskTypeClear];
      [SVProgressHUD setMaximumDismissTimeInterval:1];
      // [helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    }
  //  SingObj.helper=helper;
}
//- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
//{
//    switch (vpnErrno)
//    {
//        case RESULT_VPN_INIT_FAIL:
//            NSLog(@"Vpn Init failed!");
//            break;
//        case RESULT_VPN_AUTH_FAIL:
//            [helper clearAuthParam:@SET_RND_CODE_STR];
//            [SVProgressHUD dismiss];
//            NSLog(@"Vpn auth failed!");
//            break;
//            
//        case RESULT_VPN_INIT_SUCCESS:
//            NSLog(@"Vpn init success!");
//            break;
//        case RESULT_VPN_AUTH_SUCCESS:
//            [self startOtherAuth:authType];
//            break;
//        case RESULT_VPN_AUTH_LOGOUT:
//            NSLog(@"Vpn logout success!");
//            [SVProgressHUD showSuccessWithStatus:@"VPN断开成功!"];
//            break;
//        case RESULT_VPN_OTHER:
//            if (VPN_OTHER_RELOGIN_FAIL == (VPN_RESULT_OTHER_NO)authType) {
//                NSLog(@"Vpn relogin failed, maybe network error");
//            }
//            break;
//            
//        case RESULT_VPN_NONE:
//            break;
//            
//        default:
//            break;
//    }
//}
//- (void) startOtherAuth:(const int)authType
//{
//    NSArray *paths = nil;
//    switch (authType)
//    {
//        case SSL_AUTH_TYPE_CERTIFICATE:
//            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                        NSUserDomainMask, YES);
//            
//            if (nil != paths && [paths count] > 0)
//            {
//                NSString *dirPaths = [paths objectAtIndex:0];
//                NSString *authPaths = [dirPaths stringByAppendingPathComponent:certName];
//                NSLog(@"PATH = %@",authPaths);
//                [helper setAuthParam:@CERT_P12_FILE_NAME param:authPaths];
//                [helper setAuthParam:@CERT_PASSWORD param:certPwd];
//            }
//            NSLog(@"Start Cert Auth!!!");
//            break;
//        case SSL_AUTH_TYPE_PASSWORD:
//            NSLog(@"Start Password Name Auth!!!");
//            [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
//            [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
//            break;
//        case SSL_AUTH_TYPE_NONE:
//        {
//            [SVProgressHUD showSuccessWithStatus:@"VPN连接成功!"];
//            NSLog(@"Auth success!!!");
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"HomePage" object:nil];//通知刷新左边菜单栏
//            return;
//        }
//            
//        default:
//        {
//            [SVProgressHUD showInfoWithStatus:@"VPN连接失败!请联系管理员"];
//        }
//            NSLog(@"Other failed!!!");
//            return;
//    }
//    [helper loginVpn:authType];
//}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[[iAppOffice sharedInstance] setApplicationDidEnterBackground:application];//必须使用
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if (![iAppOffice isAppStoreWPSInstalled]) {
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到未安装WPS" message:@"请退出应用安装WPS后重试" preferredStyle:UIAlertControllerStyleAlert];
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WPSDocumentNotification" object:nil];
}
//
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //重新拉起WPS做相应的配置
    return [iAppOffice handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
