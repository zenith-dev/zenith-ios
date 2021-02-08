//
//  NSString+util.h
//  HaiPa
//
//  Created by 熊佳佳 on 16/6/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ResTypePhone   = 1,//手机号
    ResTypeEmail   = 2,//邮箱
    ResTypeHttp    = 3,//网址
    ResTypeQQ      = 4,//QQ号
    ResTypeIdCard  = 5,//身份证号
    ResTypeAccount = 6,//账号
    ResTypePassWord= 7,//密码(以字母开头，长度在6~18之间，只能包含字母、数字和下划线)
    
} RegexType;

@interface NSString (util)
//正则表达式
-(BOOL)regex:(RegexType)regexindex;
-(BOOL) checkCardNo;
-(NSString*)CodeUTF;
-(NSString*)md5;
/**
 *  转换成ISO889591
 *
 *  @return
 */
-(NSString*)unicodeToISO88591;
/**
 *  去除空格
 *
 *  @return
 */
-(NSString*)deletespace;
@end
