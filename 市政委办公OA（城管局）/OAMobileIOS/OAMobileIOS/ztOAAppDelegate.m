//
//  ztOAAppDelegate.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAAppDelegate.h"
#import "ztOALoadingViewController.h"
#import "ztOANewMainViewController.h"
#import "ztOABaseNavigationViewController.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import <AdSupport/AdSupport.h>
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
    //提示框
    
    
    [SVProgressHUD setBackgroundColor:MF_ColorFromRGBA(0, 0, 0, .7)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"]==nil){
        [ztOAGlobalVariable sharedInstance].serviceIp = @"172.17.250.2";
        [ztOAGlobalVariable sharedInstance].servicePort = @"7070";
        [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].serviceIp forKey:@"baseServiceIp"];
        [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].servicePort forKey:@"baseServicePort"];
    }
    else
    {
        [ztOAGlobalVariable sharedInstance].serviceIp =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServiceIp"];
        [ztOAGlobalVariable sharedInstance].servicePort =[[NSUserDefaults standardUserDefaults] stringForKey:@"baseServicePort"];
    }
     NSLog(@"%@:%@",[ztOAGlobalVariable sharedInstance].serviceIp,[ztOAGlobalVariable sharedInstance].servicePort);
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"]==nil) {
        NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [ztOAGlobalVariable sharedInstance].deviceId = advertisingId;
        [[NSUserDefaults standardUserDefaults] setValue:advertisingId forKey:@"deviceIdSave"];
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
        [ztOAGlobalVariable sharedInstance].userHeadPicName = [NSString stringWithFormat:@"%@",[rootdic objectForKey:@"chrxpmc"]?:@""];
        [ztOAGlobalVariable sharedInstance].intsessionlsh = [NSString stringWithFormat:@"%@",[rootdic objectForKey:@"intsessionlsh"]?:@""];
    }
    self.nav = [[UINavigationController alloc] initWithRootViewController:[[ztOALoadingViewController alloc] init]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

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
    //处理导航栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [UINavigationBar appearance].barTintColor=MF_ColorFromRGB(39, 87, 197);
    addN(@selector(loginout), @"SINGLEPOINT");
    
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"bb61f1a7ba3c3b03cbe5e6d4e0efafa4"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"bb61f1a7ba3c3b03cbe5e6d4e0efafa4"];
    
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
    return YES;
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
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]!=nil) {
        [ztOAGlobalVariable sharedInstance].userzh =@"";
        [ztOAGlobalVariable sharedInstance].intrylsh =@"";
        [ztOAGlobalVariable sharedInstance].username =@"";
        [ztOAGlobalVariable sharedInstance].intdwlsh =@"";
        [ztOAGlobalVariable sharedInstance].intdwlsh_child =@"";
        [ztOAGlobalVariable sharedInstance].unitname =@"";
        [ztOAGlobalVariable sharedInstance].unitname_child =@"";
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
        self.nav = [[UINavigationController alloc] initWithRootViewController:[[ztOALoadingViewController alloc] init]];
        self.window.rootViewController = nav;
    }
    NSLog(@"程序关闭");
}
-(void)loginout{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的账号已在另一台设备登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
    //退出登陆清理数据
    [ztOAGlobalVariable sharedInstance].userzh =@"";
    [ztOAGlobalVariable sharedInstance].intrylsh =@"";
    [ztOAGlobalVariable sharedInstance].username =@"";
    [ztOAGlobalVariable sharedInstance].intdwlsh =@"";
    [ztOAGlobalVariable sharedInstance].intdwlsh_child =@"";
    [ztOAGlobalVariable sharedInstance].unitname =@"";
    [ztOAGlobalVariable sharedInstance].unitname_child =@"";
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
    self.nav = [[UINavigationController alloc] initWithRootViewController:[[ztOALoadingViewController alloc] init]];
    self.window.rootViewController = nav;
    
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
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
