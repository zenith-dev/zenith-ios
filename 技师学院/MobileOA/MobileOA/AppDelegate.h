//
//  AppDelegate.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/2/24.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AuthHelper.h"
//#import "sdkheader.h"
//#import "sslvpnnb.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>//SangforSDKDelegate
+ (AppDelegate *)Share;
@property (strong, nonatomic) UIWindow *window;
//@property(nonatomic,strong)AuthHelper *helper;
-(void)showHomePage;
-(void)showLogin;
@end

