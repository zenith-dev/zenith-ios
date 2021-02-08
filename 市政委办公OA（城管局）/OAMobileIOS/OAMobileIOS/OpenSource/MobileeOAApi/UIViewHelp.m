//
//  UIViewHelp.m
//  OAMobileIPad
//
//  Created by 陈 也 on 12-5-18.
//  Copyright (c) 2012年 zt.com. All rights reserved.
//

#import "UIViewHelp.h"

//展示UI试图辅助类
@implementation UIViewHelp

/*!
 @method 向界面弹出提示框
 @param alertTitle 提示框标题
 @param alertMessage 提示框消息
 */
+ (void) alertTitle:(NSString*)title alertMessage:(NSString*)message{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];  
    [alert show];  
}

//加载框控件
static UIAlertView *alertView;

/*!
 @method 向界面弹出加载提示框
 @param alertTitle 提示框信息
 */
+ (void) showProgressDialog:(NSString*)message{
    alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    activityView.frame = CGRectMake(120.f,48.0f,37.0f,37.0f);
    [alertView addSubview:activityView];
    [activityView startAnimating];
    [alertView show];
    
}

/*!
 @method 去掉加载提示框
 */
+ (void) dismissProgressDialog{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) showConfig{
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://devprograms@apple.com"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
}

@end
