//
//  Tools.h
//  dtgh
//
//  Created by 熊佳佳 on 15/10/14.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+DES.h"
@interface Tools : NSObject
#pragma mark---------提示窗口---------------
/**提示窗口
 */
+ (void)showMsgBox:(NSString *)msg;

/**
 *  时间戳转化任意格式
 *
 *  @param confromTimesp 时间戳
 *  @param formater      格式
 *
 *  @return 时间
 */
#pragma mark------------处理各种时间问题---------
+(NSString*)dealDateFormater:(NSString*)confromTimesp formater:(NSString*)mater;
/**通过格式将时间转化成字符串
 */
+(NSString *)dateToStr:(NSDate *)indate andFormat:(NSString *) format;
/**通过格式将字符串转化成时间
 */
+(NSDate*) strToDate:(NSString*)strDate andFormat:(NSString *) format;
/**时间判断大小 1、表示oneDay大 -1、表示anotherDay大 0 表示相同
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

#pragma mark------------------网络环境判断---------
/**判断是否有WIFI和3G
 */
+ (BOOL) IsNetwork;
/**判断是否有WIFI
 */
+ (BOOL) IsEnableWIFI;
/**判断是否有3G
 */
+ (BOOL) IsEnable3G;
#pragma mark----------------正则表达式----------------
/**邮件判断
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**移动判断
 */
+(BOOL) isValidateMobile:(NSString *)mobile;
/**办公电话判断
 */
+(BOOL) isvalidatePhone :(NSString*)phone;
/**姓名验证
 */
+(int)isValidateName:(NSString *)name;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
#pragma mark------------------字符串的处理----------------
/**字符串截取
 */
+ (NSString*)strcut:(NSString*) str fromindex:(NSInteger)fromindex lengthindex:(NSInteger)lengthindex;
/**判断字符为空
 */
+ (BOOL)isBlankString:(NSString *)string;
/**MD5加密
 */
+ (NSString *)md5:(NSString *)str;
/**DES加密
 */
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
/**获取每次请求需要的时间轴
 */
+(NSString *) getEncryptTime;

/**将字符转成bufferBytes
 */
+(NSData*) hexToBytes :(NSString*)str ;

/**处理字符串去掉网咯标签
 */
+(NSString *)filterHTML:(NSString *)html;
/**将带有标签的字符串转化成AttributedString
 */
+(NSMutableAttributedString *)attributedStringWithHtml:(NSString *)html;
/**判断是否是UTF-8 用于加载网页
 */
+ (BOOL)ISUTF8_STRING:(NSString*)str;
/**将某个字段 改变颜色
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andColor:(UIColor*)color;

/**将某个字段 改变字体
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andFont:(UIFont*)font;
#pragma mark------------------处理图片-------------
/**按指定的CGSize 压缩图片
 */
+(UIImage *)scaleImage:(UIImage *)image toSize:(CGSize) size;
/**按指定系数(0-1之间)  等比压缩图片
 */
+(UIImage *)scaleImage:(UIImage *)image toScale:(float) scaleSize;

/**图片处理成灰色图片
 */
+(UIImage*)getGrayImage:(UIImage*)sourceImage;
/**颜色变成图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color :(CGRect )frame;
/**颜色拉伸
 */
+(UIImage *)lsImge:(UIImage*)sourcImg;
/**颜色值16进制转化成颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color;
/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *
 *	@return	UILabel
 */
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image;
//递归算法

+(void)testPetch:(NSString*) json forDeep:(int) level;
@end
