//
//  SingleObj.m
//  dtgh
//
//  Created by 熊佳佳 on 15/10/30.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "SingleObj.h"

@implementation SingleObj
+(SingleObj*)defaultManager
{
    static SingleObj *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
