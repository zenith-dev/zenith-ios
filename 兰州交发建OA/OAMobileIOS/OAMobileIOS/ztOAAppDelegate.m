//
//  ztOAAppDelegate.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//11

#import "ztOAAppDelegate.h"
#import "ztOALoadingViewController.h"
#import "ztOANewMainViewController.h"
#import "ztOABaseNavigationViewController.h"
#import "Reachability.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

#define PGY_APPKEY @"b9e6b2bd0ef8cc56c19fff3db75444d5"
@interface ztOAAppDelegate ()
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation ztOAAppDelegate
@synthesize reachability;
@synthesize nav;
+ (ztOAAppDelegate *)Share
{
    return (ztOAAppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    [self updateInterfaceWithReachability:reachability];
    
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
    
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    //处理导航栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UINavigationBar appearance].barTintColor=UIColorFromRGB(0x3c6eec);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"]==nil){
        [ztOAGlobalVariable sharedInstance].serviceIp = @"61.178.231.53";
        [ztOAGlobalVariable sharedInstance].servicePort = @"7070";
        [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].serviceIp forKey:@"baseServiceIp"];
        [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].servicePort forKey:@"baseServicePort"];
    }
    else
    {
        [ztOAGlobalVariable sharedInstance].serviceIp =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"];
        [ztOAGlobalVariable sharedInstance].servicePort =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServicePort"];
        NSLog(@"%@ ; %@",[ztOAGlobalVariable sharedInstance].serviceIp,[ztOAGlobalVariable sharedInstance].servicePort);
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"]==nil) {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        [ztOAGlobalVariable sharedInstance].deviceId = cfuuidString;
        [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].deviceId forKey:@"deviceIdSave"];
    }
    else
    {
        [ztOAGlobalVariable sharedInstance].deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]) {
        NSDictionary *rootdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
        //初始化用户信息
        [ztOAGlobalVariable sharedInstance].userzh = [NSString stringWithFormat:@"%@", [[rootdic objectForKey:@"userinfo"] objectForKey:@"userzh"]?:@""];
        [ztOAGlobalVariable sharedInstance].dwccbm=[NSString stringWithFormat:@"%@", [[rootdic objectForKey:@"unitinfo"] objectForKey:@"dwccbm"]?:@""];
        [ztOAGlobalVariable sharedInstance].intrylsh = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"userinfo"] objectForKey:@"intrylsh"]?:@""];
        [ztOAGlobalVariable sharedInstance].username = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"userinfo"] objectForKey:@"username"]?:@""];
        [ztOAGlobalVariable sharedInstance].intdwlsh = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"unitinfo"] objectForKey:@"intdwlsh"]?:@""];
        [ztOAGlobalVariable sharedInstance].intdwlsh_child = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"unitinfo"] objectForKey:@"intdwlsh_child"]?:@""];
        [ztOAGlobalVariable sharedInstance].unitname = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"unitinfo"] objectForKey:@"unitname"]?:@""];
        [ztOAGlobalVariable sharedInstance].unitname_child = [NSString stringWithFormat:@"%@",[[rootdic objectForKey:@"unitinfo"] objectForKey:@"unitname_child"]?:@""];
        
        [ztOAGlobalVariable sharedInstance].intsessionlsh = [NSString stringWithFormat:@"%@",[rootdic objectForKey:@"intsessionlsh"]?:@""];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"]!=nil) {
            [ztOAGlobalVariable sharedInstance].userHeadPicName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"];
        }
        ztOANewMainViewController *mainVC = [[ztOANewMainViewController alloc] init];
        mainVC.hideLeft=YES;
        mainVC.title=@"兰州交通发展建设集团有限公司";
        UINavigationController *mainnav=[[UINavigationController alloc]initWithRootViewController:mainVC];
         self.window.rootViewController =mainnav;
    }else
    {
        self.nav = [[UINavigationController alloc] initWithRootViewController:[[ztOALoadingViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //注册接收通知类型
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"] isEqualToString:@""] || [[NSUserDefaults standardUserDefaults] objectForKey:@"isPush"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"isPush"];
    }
    if ([[userDefaults objectForKey:@"isPush"] isEqualToString:@"yes"]) {
        //JPush Required
        [JPUSHService registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert categories:nil];
        [JPUSHService setupWithOption:launchOptions appKey:appKey
                              channel:channel
                     apsForProduction:isProduction
                advertisingIdentifier:nil];
        
    }
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"remoteNotify:%@", remoteNotification);
    }
    return YES;
}

//注册过程比较长，它通过APNS从苹果公司返回，注册结束后的回调方法代码：
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if(application.applicationState==UIApplicationStateBackground || application.applicationState==UIApplicationStateInactive){
        
    }
    else
    {
        // 取得 APNs 标准信息内容
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
        int badge = [[aps valueForKey:@"badge"] intValue]; //badge数量
        NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
        NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
        NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field  =[%@]",content,(long)badge,sound,customizeField1);
        [JPUSHService setLocalNotification:[NSDate date] alertBody:content badge:badge alertAction:nil identifierKey:@"identifierKey" userInfo:userInfo soundName:sound];
    }
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.r
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *files = [fileManage contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *fileName in files) {
        BOOL isDir = TRUE;
        if ([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName] isDirectory:&isDir]) {
            if (![fileName isEqualToString:@"headImage_tt0711"]) {
                [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName] error:nil];
            }
            
        }
        else
        {
            NSLog(@"11");
        }
    }
    NSLog(@"程序关闭");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //APP完全退出时调用此方法， 清空所有已下载的文档
}
#pragma mark - 检测网络
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)curReach {
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    // 3G网络
    if (status == ReachableViaWWAN) {
        UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"您正在使用移动网络"];
        [alert addButtonWithTitle:@"确定"];
        [userdefaults setObject:@"WWAN" forKey:@"contype"];
        //[alert show];
    }
    // WIFI
    else if (status == ReachableViaWiFi) {
        UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"您正在使用WIFI网络"];
        [alert addButtonWithTitle:@"确定"];
        [userdefaults setObject:@"WiFi" forKey:@"contype"];
        //[alert show];
    }
    
    //没有连接到网络就弹出提示框
    else{
        UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"您目前没有连接到网络"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    }
}
@end
