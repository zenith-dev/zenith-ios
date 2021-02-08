//
//  ztOASmartTime.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-10.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOASmartTime : NSObject
//时间戳
+ (NSString *)intervalSinceNow: (NSString *) theDate;
//智能时间
+ (NSString *)ecodingDateStr:(NSString *) theDate;

//日期
+ (NSString *)dateFromStr:(NSString *) theDate;
//时间
+ (NSString *)timeFromStr:(NSString *) theDate;
+ (NSString *)sjFromStr:(NSString *) theDate;
/**通过格式将字符串转化成时间
 */
+(NSDate*) strToDate1:(NSString*)strDate andFormat:(NSString *) format;
//程序中使用的，提交日期的格式 format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSString *) dateToStr:(NSDate *)indate andFormat:(NSString *) format;
/**时间判断大小 1、表示oneDay大 -1、表示anotherDay大 0 表示相同
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;
@end
