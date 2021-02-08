//
//  Tools.m
//  MoothClub
//
//  Created by Dx on 15/8/5.
//  Copyright (c) 2015年 Dc. All rights reserved.
//

#import "Tools.h"
#import "sys/utsname.h"
@implementation Tools
static char chaArray[36]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}
+ (NSString *) getRandomStr:(int)len
{
    NSMutableString *res = [NSMutableString stringWithCapacity:len];
    //[res appendString:@"IOS"];
    int arrCount = 36;
    for(int i=0;i<len;i++){
        int rNum = arc4random() % arrCount;
        [res appendFormat:@"%c",chaArray[rNum]];
    }
    return res;
}
/**手机号码验证
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    if (mobile.length<5) {
        return NO;
    }
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"\\d{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
/**提示窗口
 */
+ (void)showMsgBox:(NSString *)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提 示" message:msg
                                                   delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//将时间戳转化成时间 之显示年月日
+(NSString*)dealDate:(NSString*)confromTimesp
{
    NSString *times=[NSString stringWithFormat:@"%@",confromTimesp];
    NSString *substr=[times substringToIndex:10];
    NSDate *timeisdate =[NSDate dateWithTimeIntervalSince1970: [substr intValue]];
    NSLog(@"%@",timeisdate);
    // [NSDate dateWithTimeIntervalSince1970:confromTimesp];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat: @"yyyy年MM月dd日"];
    NSString *destDateString = [formater stringFromDate:timeisdate];
    return destDateString;
}
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
/**通过格式将字符串转化成时间
 */
+(NSDate*) strToDate:(NSString*)strDate andFormat:(NSString *) format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: format];
    NSDate *dt = [formatter dateFromString:strDate];
    return dt;
}
//程序中使用的，提交日期的格式 format可以是：yyyy-MM-dd HH:mm:ss.SSS
+(NSString *) dateToStr:(NSDate *)indate andFormat:(NSString *) format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:indate];
}
+(NSDate*)dealStringToDate:(NSString*)confromTimesp
{
    confromTimesp=[NSString stringWithFormat:@"%@",confromTimesp];
    if (confromTimesp.length!=0) {
        NSString *times=[NSString stringWithFormat:@"%@",confromTimesp];
        NSString *substr=[times substringToIndex:confromTimesp.length-3];
        NSDate *timeisdate =[NSDate dateWithTimeIntervalSince1970: [substr intValue]];
        return timeisdate;
    }
    else
    {
        return [NSDate date];
    }
}

+(NSString*)dealDateFormater:(NSString*)confromTimesp formater:(NSString*)mater
{
    confromTimesp=[NSString stringWithFormat:@"%@",confromTimesp];
    if (confromTimesp.length!=0) {
        NSString *times=[NSString stringWithFormat:@"%@",confromTimesp];
        NSString *substr=[times substringToIndex:confromTimesp.length-3];
        NSDate *timeisdate =[NSDate dateWithTimeIntervalSince1970: [substr intValue]];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat: mater];
        NSString *destDateString = [formater stringFromDate:timeisdate];
        return destDateString;
    }else
    {
        return confromTimesp;
    }
}
/**
 *  两个时间之间相差多少秒
 *
 *  @param 时间戳
 *
 *  @return 秒数
 */
+(int)nowDate:(NSDate*)nowdata fromDate:(NSDate*)fromdate
{
    NSTimeInterval late=[fromdate timeIntervalSince1970]*1;
    NSTimeInterval now=[nowdata timeIntervalSince1970]*1;
    NSTimeInterval cha=late-now;
    NSLog(@"==========%@",@(cha));
    return (int)cha;
}
+(NSString*)nowDsate:(NSDate*)nowdata fromDate:(NSDate*)fromdate flg:(int)flg
{
    NSTimeInterval late=[fromdate timeIntervalSince1970]*1;
    NSTimeInterval now=[nowdata timeIntervalSince1970]*1;
    NSTimeInterval cha=late-now;
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    
    house=[NSString stringWithFormat:@"%@", house];
    if (flg==1) {
        return house;
    }
    else if (flg==2)
    {
        return min;
    }
    else
    {
        return sen;
    }
}
+(NSString*)numTurnToMoney:(NSString *)num
{
    int  numint=[num floatValue];
    int  k=numint/1000;
    if (numint%1000!=0) {
        int b=numint%1000/100;
        if (numint%100!=0) {
            int s=numint%100/10;
            if (numint%10!=0) {
                int g=numint%10;
                return [NSString stringWithFormat:@"%i.%i%i%i",k,b,s,g];
            }
            else
            {
                return  [NSString stringWithFormat:@"%i.%i%i",k,b,s];
            }
        }
        else
        {
            return  [NSString stringWithFormat:@"%i.%i",k,b];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%i",k];
    }
}
+ (NSString *)sjFromStr:(NSString *) theDate
{
    if (theDate.length>=16) {
        theDate=[theDate substringToIndex:16];
    }
    return theDate;
}

+ (NSString *)sjFromStr1:(NSString *) theDate
{
    if (theDate.length>=10) {
        theDate=[theDate substringToIndex:10];
    }
    return theDate;
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
+ (BOOL) IsNetwork{
    if([self IsEnable3G] || [self IsEnableWIFI])
    {
        return YES;
    }else{
        return NO;
    }
}
/**
 *  获取Icon图标
 *
 *  @return
 */
+(UIImage*)getIconImge
{
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}

+ (BOOL) IsEnableWIFI{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
+ (BOOL) IsEnable3G{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
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
/**邮箱验证
 */
+(BOOL)isValidateEmail:(NSString *)email
{
    if (email.length==0) {
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) checkCardNo:(NSString*) cardNo{
    if (cardNo.length==0) {
        return NO;
    }
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
/**字符串截取
 */
+ (NSString*)strcut:(NSString*) str fromindex:(int)fromindex lengthindex:(int)lengthindex
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

/**定义→_→按钮文字
 */
+ (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    UIButton *rightbtn= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 45, 44)];
    if(image){
        [rightbtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [rightbtn setTitle:title forState:UIControlStateNormal];
        [rightbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        if (image) {
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        rightbtn.titleLabel.font = Font(15);
        rightbtn.frame=CGRectMake(X(rightbtn), Y(rightbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(rightbtn));
    }
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return rightbtn;
}
/**将某个字段 字体
 */
+(NSMutableAttributedString*)renderText:(NSString*)text targetStr:(NSString*)targetStr andfont:(UIFont*)font
{
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:text];
    NSRange range=[text rangeOfString:targetStr];
    [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(range.location, targetStr.length)];
    return attriString;
}
+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"i386"]) return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"]) return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString); 
    return deviceString; 
}
//获取每次请求需要的时间轴
+(NSString *) getEncryptTime{
    return [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000];
}




+(UIColor*)mostColor:(UIImage*)logoImage{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, logoImage.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (red>235&&green>235&&blue>235) {
                continue;
            }
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:(1)];
}

//处理图片地址
+(NSString *) getAPIimageUrl:(NSString *) orginImage
{
    if (orginImage.length==0) {
        return nil;
    }
    else
    {
        if ([orginImage rangeOfString:@"http://"].location!=NSNotFound) {
            return orginImage;
        }
        else
        {
            NSString *urlAPI=API;
            NSRange range = [urlAPI rangeOfString:@"/" options:NSBackwardsSearch];//匹配得到的下标
            NSString *webschoolstr=[urlAPI substringFromIndex:range.length+range.location];
            if ([orginImage rangeOfString:webschoolstr].location!=NSNotFound) {
                urlAPI=[urlAPI substringWithRange:NSMakeRange(0, range.location)];
            }
            NSString *str;
            if ([[orginImage substringWithRange:NSMakeRange(0,1)] isEqualToString:@"/"]) {
                str=[NSString stringWithFormat:@"%@%@",urlAPI,orginImage];
            }
            else
            {
                str=[NSString stringWithFormat:@"%@/%@",urlAPI,orginImage];
            }
            //处理参数
            if ([[orginImage substringFromIndex:orginImage.length-1] isEqualToString:@"?"]) {
                str=[str stringByAppendingString:[NSString stringWithFormat:@"&jsessionid=5104wv4PPEa9BsIj7HuPRNOJEQ==6081"]];
            }
            else
            {
                str=[str stringByAppendingString:[NSString stringWithFormat:@"?jsessionid=5104wv4PPEa9BsIj7HuPRNOJEQ==6081"]];
            }
            str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            return  str;
            
        }
    }
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
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext
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
+(NSMutableAttributedString *)attributedStringWithHtml:(NSString *)html {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    return attrString;
}
@end
