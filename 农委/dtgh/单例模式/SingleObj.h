//
//  SingleObj.h
//  dtgh
//
//  Created by 熊佳佳 on 15/10/30.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleObj : NSObject
+(SingleObj*)defaultManager;
@property(nonatomic,strong)UIColor *backColor;//背景颜色
@property(nonatomic,strong)UIColor *titleColor;//标题颜色
@property(nonatomic,strong)UIColor *lineColor;//线的颜色
@property(nonatomic,strong)UIColor *boderlineColor;//深色线
@property(nonatomic,strong)UIColor *mainColor;//主题颜色
@property(nonatomic,strong)UIColor *subtitleColor;//副标题颜色
@property(nonatomic,strong)UIColor *origColor;//标题颜色
@property(nonatomic,strong)UIColor *emailColor;//邮件列表颜色
@property(nonatomic,strong)UINavigationController *rootnav;//root导航栏
@end
