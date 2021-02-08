//
//  ztOABaseViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ztOAGlobalVariable.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "ztOAService.h"
#import "ztOAOfficeDocListModel.h"
#import "EGORefreshTableHeaderView.h"
#import "ztOAButton.h"
#import "ztOASmartTime.h"
#import "NSData+Base64.h"
#import "ztOAABModel.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface ztOABaseViewController : UIViewController<MBProgressHUDDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) MBProgressHUD     *waitView;
@property (nonatomic, strong) UIButton          *leftBtn;
@property (nonatomic, strong) UILabel           *leftBtnLab;
@property (nonatomic, strong) UIButton          *rightBtn;
@property (nonatomic, strong) UILabel           *rightBtnLab;
@property (nonatomic, strong)UIButton           *scrollToTopBtn;
@property (nonatomic, strong)UIButton           *scrollToBottomBtn;
@property (nonatomic,assign)BOOL hideLeft;
- (void)back;
- (void)showWaitViewWithTitle:(NSString *)msg;
- (void)showWaitView;
- (void)closeWaitView;
- (NSString *)UrlFromPathOfDocuments:(NSString *)path;
-(NSString *)UnicodeToISO88591:(NSString *)src;
- (NSString *)getCurrentTimeStr;
- (BOOL)isLogin;

/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title imagen:(NSString*)imagen imageh:(NSString*)imageh sel:(SEL)sel;
/**
 *  定义左边按钮
 */
-(UIButton*)rightButton:(NSString*)title Sel:(SEL)sel;

//- 调用电话，拨打
- (void)toCallPhotoNumber:(NSString *)number;
//-MFMessageComposeViewControllerDelegate- recipients为电话号码字符串集合
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
//导入手机 arraySelectContacts为ztOAABModel集合
- (void)doLoadToPhone:(NSMutableArray *)arraySelectContacts;
//判断设备是否绑定
- (void)deviceBandState;
//清理用户数据
- (void)clearOldUserInfo;

@end
