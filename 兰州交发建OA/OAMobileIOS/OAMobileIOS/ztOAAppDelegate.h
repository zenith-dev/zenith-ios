//
//  ztOAAppDelegate.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *appKey = @"1f9c2d610e60fc8b97a2149c";
static NSString *channel = @"Publish channel";
static BOOL isProduction = true;

@interface ztOAAppDelegate : UIResponder <UIApplicationDelegate>
+ (ztOAAppDelegate *)Share;
@property (strong, nonatomic) UIWindow *window;
@end
