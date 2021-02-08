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
@interface AppDelegate ()<UIAlertViewDelegate>
{
    NSString *strwjdz;
}
@end

@implementation AppDelegate
+ (AppDelegate *)Share
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
