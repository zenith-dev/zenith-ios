//
//  MOSingObj.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/2/24.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "YYBSingObj.h"

@implementation YYBSingObj
+(YYBSingObj*)defaultManager
{
    static YYBSingObj *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
@end
