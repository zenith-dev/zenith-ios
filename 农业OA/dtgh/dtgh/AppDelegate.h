//
//  AppDelegate.h
//  dtgh
//
//  Created by 熊佳佳 on 15/10/9.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)Share;
-(void)showLogin;
-(void)showMain;
@end

