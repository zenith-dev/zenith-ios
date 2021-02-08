//
//  Tools.h
//  MoothClub
//
//  Created by Dx on 15/8/5.
//  Copyright (c) 2015年 Dc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface Tools : NSObject
+ (NSString *) getRandomStr:(int)len;
+ (BOOL)isBlankString:(NSString *)string;
+ (UIImage *)buttonImageFromColor:(UIColor *)color :(CGRect )frame;
/**移动判断
 */
+(BOOL) isValidateMobile:(NSString *)mobile;
/**邮箱验证
 */
+(BOOL)isValidateEmail:(NSString *)email;
/**提示窗口
 */
+ (void)showMsgBox:(NSString *)msg;
/**
 *  时间戳转化为年月日
 *
 *  @param confromTimesp 时间戳
 *
 *  @return 年月日
 */
+(NSString*)dealDate:(NSString*)confromTimesp;
/**
 *  时间戳转化任意格式
 *
 *  @param confromTimesp 时间戳
 *  @param formater      格式
 *
 *  @return 时间
 */
+(NSString*)dealDateFormater:(NSString*)confromTimesp formater:(NSString*)mater;

/**
 *  两个时间之间相差多少秒
 *
 *  @param 时间戳
 *
 *  @return 秒数
 */
+(int)nowDate:(NSDate*)nowdata fromDate:(NSDate*)fromdate;





/**
 *  两个时间之间相差时间
 *
 *  @param 时间戳
 *
 *  @return 时分秒
 */
+(NSString*)nowDsate:(NSDate*)nowdata fromDate:(NSDate*)fromdate flg:(int)flg;
/**
 *  数字替换成多少K
 *
 *  @param num 数字
 *
 *  @return K
 */
+(NSString*)numTurnToMoney:(NSString *)num;


+ (NSString *)sjFromStr:(NSString *) theDate;


//日期
+ (NSString *)dateFromStr:(NSString *) theDate;

#pragma mark------------------网络环境判断---------
/**判断是否有WIFI和3G
 */
+ (BOOL) IsNetwork;
+ (BOOL) IsEnableWIFI;
+ (BOOL) IsEnable3G;
+ (NSString *)md5:(NSString *)str;
/**
 *  设置左边按钮
 *
 *  @param title 文字
 *  @param image 图片
 *  @param sel   点击时间
 *
 *  @return 按钮
 */
+ (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;
/**通过格式将字符串转化成时间
 */
+(NSDate*) strToDate:(NSString*)strDate andFormat:(NSString *) format;
//程序中使用的，提交日期的格式 format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSString *) dateToStr:(NSDate *)indate andFormat:(NSString *) format;
+ (BOOL)ISUTF8_STRING:(NSString*)str;
/**判断是非是银行卡
 */
+ (BOOL) checkCardNo:(NSString*) cardNo;
/**字符串截取
 */
+ (NSString*)strcut:(NSString*) str fromindex:(NSInteger)fromindex lengthindex:(NSInteger)lengthindex;
/**
 *  获取Icon图标
 *
 *  @return
 */
+(UIImage*)getIconImge;
/**将某个字段 字体
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andfont:(UIFont*)font;
+ (NSString*)deviceString;
//获取每次请求需要的时间轴
+(NSString *) getEncryptTime;
+(NSDate*)dealStringToDate:(NSString*)confromTimesp;
+(UIColor*)mostColor:(UIImage*)logoImage;
+(NSString *) getAPIimageUrl:(NSString *) orginImage;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h;
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
+ (NSString *)sjFromStr1:(NSString *) theDate;
+(NSMutableAttributedString *)attributedStringWithHtml:(NSString *)html;

@end
