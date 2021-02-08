//
//  NSString+URL.m
//  ZtTravel
//
//  Created by ian chen on 13-12-3.
//  Copyright (c) 2013年 ian chan. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
//URLEncode编码nsstring
- (NSString *)URLEncodedString{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}
@end
