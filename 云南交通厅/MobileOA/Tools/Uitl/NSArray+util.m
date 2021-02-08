//
//  NSArray+util.m
//  tencentTest
//
//  Created by Mao on 16/4/19.
//  Copyright © 2016年 Mao. All rights reserved.
//

#import "NSArray+util.h"

@implementation NSArray (util)
-(NSArray*)killNull{
    NSMutableArray *mutable=[NSMutableArray arrayWithCapacity:[self count]];
    
    for (id x in self) {
        if ([x isEqual:[NSNull null]]) {
            [mutable addObject:@""];
        }else
        if ([x isKindOfClass:[NSDictionary class]]) {
            [mutable addObject:[x killNull]];
        }else
        {
            [mutable addObject:x];
        }
    }
    return [mutable copy];
}
@end
