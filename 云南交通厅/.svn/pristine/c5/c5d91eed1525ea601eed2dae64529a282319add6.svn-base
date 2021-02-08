//
//  NSString+util.m
//  HaiPa
//
//  Created by 熊佳佳 on 16/6/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "NSString+util.h"
@implementation NSString (util)
-(BOOL)regex:(RegexType)regexindex
{
    if (self.length==0) {
        return NO;
    }
    NSString *regexStr;
    switch (regexindex) {
        case ResTypePhone:
            regexStr=@"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
            break;
        case ResTypeEmail:
            regexStr=@"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
            break;
        case ResTypeHttp:
            regexStr=@"[a-zA-z]+://[^\\s]*";
            break;
        case ResTypeQQ:
            regexStr=@"[1-9][0-9]{4,}";
            break;
        case ResTypeIdCard:
            regexStr=@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}(\\d|x|X)$";
            break;
        case ResTypeAccount:
            regexStr=@"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
            break;
        case ResTypePassWord:
            regexStr=@"^[a-zA-Z]\\w{5,17}$";
            break;
        default:
            break;
    }
    NSPredicate *testStr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [testStr evaluateWithObject:self];
}
-(BOOL) checkCardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[self length];
    int lastNum = [[self substringFromIndex:cardNoLength-1] intValue];
    NSString *cardNo = [self substringToIndex:cardNoLength - 1];
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
-(NSString*)CodeUTF
{
     NSString *url = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}

-(NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
-(NSString*)deletespace
{
    return  [self  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //看剩下的字符串的长度是否为零
}
//字符串去空格



/**
 *  转换成ISO889591
 *
 *  @return
 */
-(NSString*)unicodeToISO88591{
    if (self.length==0) {
        return  self;
    }
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *pageSource = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    return pageSource;
}
@end
