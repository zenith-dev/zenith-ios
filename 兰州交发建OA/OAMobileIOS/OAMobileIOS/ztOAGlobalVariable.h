//
//  ztOAGlobalVariable.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ztOAGlobalVariable.h"
@interface ztOAGlobalVariable : NSObject

@property(nonatomic,strong)NSString *userId;//用户登录id
@property(nonatomic,strong)NSString *userKey;//登录用户密码
@property(nonatomic,strong)NSString *userName;//登录用户名

//服务器获取
@property(nonatomic,strong)NSString *userzh;//用户账号
@property(nonatomic,strong)NSString *username;//用户中文名
@property(nonatomic,strong)NSString *intrylsh;//人员流水号
@property(nonatomic,strong)NSString *intdwlsh;//用户所在单位流水号
@property(nonatomic,strong)NSString *dwccbm;//单位层次编码
@property(nonatomic,strong)NSString *intdwlsh_child;//用户所在处室流水号
@property(nonatomic,strong)NSString *unitname;//用户所在单位简称
@property(nonatomic,strong)NSString *unitname_child;//用户所在处室简称
//设备信息
@property(nonatomic,strong)NSString *deviceId;//设备号
@property(nonatomic,strong)NSString *serviceIp;//服务器地质
@property(nonatomic,strong)NSString *servicePort;//服务器ip
//
@property(nonatomic,strong)NSString *userHeadPicName;//用户头像图片名称
@property(nonatomic,strong)NSString *intsessionlsh;//session

+ (ztOAGlobalVariable *)sharedInstance;
@end
