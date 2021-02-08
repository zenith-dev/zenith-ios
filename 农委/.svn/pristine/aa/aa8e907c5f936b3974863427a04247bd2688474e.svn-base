//
//  Tools.m
//  dtgh
//
//  Created by 熊佳佳 on 15/10/14.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
static Byte iv[] = {1,2,3,4,5,6,7,8};
@implementation Tools
/**提示窗口
 */
+ (void)showMsgBox:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提 示" message:msg
                                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
/**
 *  时间戳转化任意格式
 *
 *  @param confromTimesp 时间戳
 *  @param formater      格式
 *
 *  @return 时间
 */
+(NSString*)dealDateFormater:(NSString*)confromTimesp formater:(NSString*)mater
{
    NSString *times=[NSString stringWithFormat:@"%@",confromTimesp];
    if (times.length<10) {
        return nil;
    }
    NSString *substr=[times substringToIndex:10];
    NSDate *timeisdate =[NSDate dateWithTimeIntervalSince1970: [substr intValue]];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: mater];
    NSString *destDateString = [formater stringFromDate:timeisdate];
    return destDateString;
    
}
//程序中使用的，提交日期的格式 format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSString *) dateToStr:(NSDate *)indate andFormat:(NSString *) format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:indate];
}
//日期字符串转换成NSDate format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSDate*) strToDate:(NSString*)strDate andFormat:(NSString *) format{
    if (strDate.length>format.length) {
        format=@"yyyy-MM-dd HH:mm:ss.s";
    }
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    NSDate *dt = [formatter dateFromString:strDate];
    return dt;
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
#pragma mark-----------------判断网络环境----------

+ (BOOL) IsNetwork{
    if([self IsEnable3G] || [self IsEnableWIFI])
    {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL) IsEnableWIFI{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
+ (BOOL) IsEnable3G{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}
#pragma mark -----------------正则表达式------------------
/**邮箱验证
 */
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
/**手机号码验证
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"\\d{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/**姓名验证
 */
+(int)isValidateName:(NSString *)name
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    if ([name lengthOfBytesUsingEncoding:enc]>0&&[name lengthOfBytesUsingEncoding:enc]<14) {
        return YES;
    }else{
        return NO;
    }
}
/**是否办公电话正则表达式
 */
+(BOOL) isvalidatePhone :(NSString*)phone
{
    NSString * CT = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestct evaluateWithObject:phone]) {
        return YES;
    }
    return NO;
}
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
#pragma mark------------------字符串的处理----------------
/**字符串截取
 */
+ (NSString*)strcut:(NSString*) str fromindex:(NSInteger)fromindex lengthindex:(NSInteger)lengthindex
{
    if (str.length<fromindex+lengthindex) {
        return nil;
    }
    str=[str substringWithRange:NSMakeRange(fromindex, lengthindex)];
    return str;
}
/**判断字符串是否为空
 */
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
        
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
        
    }
    return NO;
}
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    
    NSString *ciphertext = nil;
    plainText = [plainText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//先编码后再加密
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64Encoding];
    }
    return ciphertext;
}
//获取每次请求需要的时间轴
+(NSString *) getEncryptTime{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
}
/**将字符转成bufferBytes
 */
+(NSData*) hexToBytes :(NSString*)str
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

/**处理字符串去掉网咯标签
*/
+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
/**将带有标签的字符串转化成AttributedString
 */
+(NSMutableAttributedString *)attributedStringWithHtml:(NSString *)html {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    return attrString;
}
/**判断是否是UTF-8 用于加载网页
 */
+ (BOOL)ISUTF8_STRING:(NSString*)str
{
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            NSLog(@"汉字");
            return false;
        }
    }
    return true;
}
/**将某个字段 改变颜色
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andColor:(UIColor*)color
{
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:text];
    NSRange range=[text rangeOfString:targetStr];
    [attriString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(range.location, targetStr.length)];
    return attriString;
}

/**将某个字段 改变字体
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andFont:(UIFont*)font
{
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:text];
    NSRange range=[text rangeOfString:targetStr];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range.location, targetStr.length)];
    return attriString;
}
#pragma mark-----------------处理图片----------------
//按指定的CGSize 压缩图片
+(UIImage *)scaleImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//按指定系数(0-1之间)  等比压缩图片
+(UIImage *)scaleImage:(UIImage *)image toScale:(float) scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
/**图片处理成灰色图片
 */
+(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context =CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}
/**将颜色处理成图片
 */
+ (UIImage *)buttonImageFromColor:(UIColor *)color :(CGRect )frame{
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/**颜色拉伸
  */
+(UIImage *)lsImge:(UIImage*)sourcImg
{
    CGFloat top = sourcImg.size.height*0.5-1; // 顶端盖高度
    CGFloat bottom = top ; // 底端盖高度
    CGFloat left = sourcImg.size.width*0.5-1; // 左端盖宽度
    CGFloat right = left; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
  return [sourcImg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
}
/**颜色值16进制转化成颜色
 */
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
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
{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    baseLabel.lineBreakMode=NSLineBreakByWordWrapping;
    baseLabel.text=atext;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=[UIColor whiteColor];
    return baseLabel;// autorelease];
}
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image
{
    return [self imageviewWithFrame:_frame defaultimage:_image stretchW:0 stretchH:0];// autorelease];
}
//-1 if want stretch half of image.size
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h
{
    UIImageView *imageview = nil;
    if(_image){
        if (_w&&_h) {
            UIImage *image = [UIImage imageNamed:_image];
            if (_w==-1) {
                _w = image.size.width/2;
            }
            if(_h==-1){
                _h = image.size.height/2;
            }
            imageview = [[UIImageView alloc] initWithImage:
                         [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h]];
        }else{
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_image]];
        }
    }
    if (CGRectIsEmpty(_frame)) {
        [imageview setFrame:CGRectMake(_frame.origin.x,_frame.origin.y, imageview.image.size.width, imageview.image.size.height)];
    }else{
        [imageview setFrame:_frame];
    }
    return  imageview;// autorelease];
}
//递归算法
+(void)testPetch:(NSString*) json forDeep:(int) level
{
    NSString* result = @"";
    NSString* prevChar = @"";
    NSUInteger slen = [json length];
    BOOL needrec = NO;
    NSString* lStr = @"";
    for ( int i=0; i < slen; i++) {
        NSString* sc = [json substringWithRange: NSMakeRange(i,1)];
        if ([sc isEqualToString: @"{"] && (!needrec))
        {
            if ([result length]>0) {
                // delete left and right space
                [result stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet]];
                if ([[result substringWithRange: NSMakeRange(0,1)] isEqualToString: @","])
                {
                    result = [result substringWithRange: NSMakeRange(1,[result length]-1)];
                }
                NSLog( @"add (%d)deep json object :%@ ",level,result);
                result = @"";
            }
            else
            {
                NSLog( @"add (%d)deep json object : object name is null",level);
            }
            lStr = [json substringWithRange: NSMakeRange(i+1,slen-i-1)];
            break;
        }
        if ([sc isEqualToString: @"["] && (!needrec))
        {
            if ([result length]>0) {
                // delete left and right space
                [result stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet]];
                if ([[result substringWithRange: NSMakeRange(0,1)] isEqualToString: @","])
                {
                    result = [result substringWithRange: NSMakeRange(1,[result length]-1)];
                }
                NSLog( @"add (%d)deep json array : %@",level,result);
                result = @"";
            }
            else
            {
                NSLog( @"add (%d)deep json array : array name is null",level);
            }
            lStr = [json substringWithRange: NSMakeRange(i+1,slen-i-1)];
            break;
        }
        if ([sc isEqualToString: @"}"] && (!needrec))
        {
            NSLog( @"Add (%d) a member%@",level,result);
            level = level -1;
            result = @"";
            continue;
        }
        if ([sc isEqualToString: @"]"] && (!needrec))
        {
            NSLog( @"Add (%d) a array member%@",level,result);
            level = level -1;
            result = @"";
            continue ;
        }
        if ([sc isEqualToString: @"\""] && (![prevChar isEqualToString: @"\\"]))
        {
            needrec = !needrec;
        }
        result = [result stringByAppendingFormat: @"%@",sc];
        prevChar = sc;
    }
    // Loop
    if (0 < [lStr length])
    {
        [self testPetch:lStr forDeep:level+1];
    }
    return ;
}

@end
