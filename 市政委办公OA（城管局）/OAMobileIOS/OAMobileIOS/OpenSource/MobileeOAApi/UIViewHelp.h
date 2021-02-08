//
//  UIViewHelp.h
//  OAMobileIPad
//
//  Created by 陈 也 on 12-5-18.
//  Copyright (c) 2012年 zt.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//展示UI试图辅助类
@interface UIViewHelp : NSObject <UIAlertViewDelegate>

/*!
 @method 向界面弹出提示框
 @param alertTitle 提示框标题
 @param alertMessage 提示框消息
 */
+ (void) alertTitle:(NSString*)title alertMessage:(NSString*)message;

/*!
 @method 向界面弹出加载提示框
 @param alertTitle 提示框信息
 */
+ (void) showProgressDialog:(NSString*)message;

/*!
 @method 去掉加载提示框
 */
+ (void) dismissProgressDialog;

- (void) showConfig;

@end
