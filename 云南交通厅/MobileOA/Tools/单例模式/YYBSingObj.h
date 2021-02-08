//
//  MOSingObj.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/2/24.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthHelper.h"
#import "LoginModel.h"
#import "Unitinfo.h"
#import "Userinfo.h"
#import "LoginModel.h"
#import "DealFjVC.h"
@interface YYBSingObj : NSObject
+(YYBSingObj*)defaultManager;
@property (nonatomic,strong)DealFjVC *dealFjVC;
@property (nonatomic,strong)AuthHelper *helper;
@property(nonatomic,strong)NSString *serviceIp;//访问IP
@property(nonatomic,strong)NSString *servicePort;//访问端口
@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,strong)UIColor *mainColor;//主题颜色
@property(nonatomic,strong)UIColor *bgColor;//背景颜色
@property(nonatomic,strong)Userinfo *userInfo;//用户信息
@property(nonatomic,strong)Unitinfo *unitInfo;//单位信息
@property(nonatomic,strong)LoginModel *loginModel;//登录信息
@property(nonatomic,strong)NSString *remberPassword;//登录信息
@property(nonatomic,strong)NSString *tempTime;

@end
