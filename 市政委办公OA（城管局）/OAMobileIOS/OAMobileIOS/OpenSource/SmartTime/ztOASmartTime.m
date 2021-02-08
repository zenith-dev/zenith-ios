//
//  ztOASmartTime.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-10.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASmartTime.h"

@implementation ztOASmartTime
+ (NSString *)ecodingDateStr:(NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSString *currentDateStr = [date stringFromDate:d];
    //NSLog(@"时间:%@",currentDateStr);
    return currentDateStr;
}

+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    if (theDate!=NULL&&![theDate isEqualToString:@""]) {
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *d=[date dateFromString:theDate];
        NSTimeInterval late=[d timeIntervalSince1970]*1;
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        NSTimeInterval cha=now-late;
        
        if (cha/3600<1) {
            if (cha/60<1) {
                timeString = @"1";
            }
            else
            {
                timeString = [NSString stringWithFormat:@"%f", cha/60];
                timeString = [timeString substringToIndex:timeString.length-7];
            }
            
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
        else if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }
        else if (cha/86400>1&&cha/(86400*30)<1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
        }
        else if (cha/(86400*30)>1&&cha/(86400*365)<1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/(86400*30)];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@个月前", timeString];
        }
        else
        {
            NSArray *array = [theDate componentsSeparatedByString:@" "];
            timeString = [array objectAtIndex:0];
        }
        return timeString;
    }
    else
    {
        return @"";
    }
    
}
+ (NSString *)sjFromStr:(NSString *) theDate
{
    if (theDate.length>=16) {
        theDate=[theDate substringToIndex:16];
    }
     return theDate;
}
/**通过格式将字符串转化成时间
 */
+(NSDate*) strToDate1:(NSString*)strDate andFormat:(NSString *) format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    NSDate *dt = [formatter dateFromString:strDate];
    return dt;
}
//日期
+ (NSString *)dateFromStr:(NSString *) theDate
{
    if (theDate!=NULL&&![theDate isEqualToString:@""]) {
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *d=[date dateFromString:theDate];
        NSTimeInterval late=[d timeIntervalSince1970]*1;
        
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        NSTimeInterval cha=now-late;
        //@"yyyy-MM-dd HH:mm:ss"
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        NSString *dateString = [array objectAtIndex:0];
        
        NSArray *dateArray =[dateString componentsSeparatedByString:@"-"];
        NSString *timeAndDateNoYearString = [NSString stringWithFormat:@"%@月%@日",[dateArray objectAtIndex:1],[dateArray objectAtIndex:2]];//x月x日
        NSString *yearAndDateSting = [NSString stringWithFormat:@"%@年%@月%@日",[dateArray objectAtIndex:0],[dateArray objectAtIndex:1],[dateArray objectAtIndex:2]];//x年x月x日
        if (cha/(86400*365*60)<1)
        {
            timeString= timeAndDateNoYearString;//月－日
        }
        else
        {
            //timeString = dateString;//年－月－日
            timeString = yearAndDateSting;
        }
        return timeString;
    }
    else
    {
        return @"";
    }
    
}
//时间
+ (NSString *)timeFromStr:(NSString *) theDate
{
    if (theDate!=NULL&&![theDate isEqualToString:@""]) {
        NSDateFormatter *date=[[NSDateFormatter alloc] init];
        [date setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *d=[date dateFromString:theDate];
        NSTimeInterval late=[d timeIntervalSince1970]*1;
        
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[dat timeIntervalSince1970]*1;
        NSString *timeString=@"";
        NSTimeInterval cha=now-late;
        //@"yyyy-MM-dd HH:mm:ss"
        NSArray *fomartArray = [theDate componentsSeparatedByString:@":"];
        NSString *dateFormatt = [NSString stringWithFormat:@"%@:%@",[fomartArray objectAtIndex:0],[fomartArray objectAtIndex:1]];//yyyy-MM-dd HH:mm
        
        NSArray *array = [dateFormatt componentsSeparatedByString:@" "];
        NSString *dateString = [array objectAtIndex:0];//yyyy-MM-dd
        NSString *onlyTimeString = [array objectAtIndex:1];//HH:mm
        NSArray *dateArray =[dateString componentsSeparatedByString:@"-"];
        NSString *timeAndDateNoYearString = [NSString stringWithFormat:@"%@月%@日 %@",[dateArray objectAtIndex:1],[dateArray objectAtIndex:2],onlyTimeString];//x月x日 HH:mm
        NSString *yearAndDateSting = [NSString stringWithFormat:@"%@年%@月%@日",[dateArray objectAtIndex:0],[dateArray objectAtIndex:1],[dateArray objectAtIndex:2]];//x年x月x日
        
        //NSArray *dateArray =[dateFormatt componentsSeparatedByString:@"-"];
        //NSString *timeAndDateNoYearString = [NSString stringWithFormat:@"%@-%@",[dateArray objectAtIndex:1],[dateArray objectAtIndex:2]];
        
        if (cha/(86400*60)<1) {
            timeString=onlyTimeString;//时：分
        }
        else if (cha/(86400*60)>1&&cha/(86400*365*60)<1)
        {
            timeString= timeAndDateNoYearString;//月－日 时：分
        }
        else
        {
            timeString = yearAndDateSting;//年－月－日
        }
        //NSLog(@"--%@",timeString);
        return timeString;
    }
    else
    {
        return @"";
    }
    
}
//程序中使用的，提交日期的格式 format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSString *) dateToStr:(NSDate *)indate andFormat:(NSString *) format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:indate];
}
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}

@end
