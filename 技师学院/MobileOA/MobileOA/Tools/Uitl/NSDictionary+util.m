//
//  NSDictionary+util.m
//  tencentTest
//
//  Created by Mao on 16/3/21.
//  Copyright © 2016年 Mao. All rights reserved.
//

#import "NSDictionary+util.h"

@implementation NSDictionary (util)
-(NSDictionary*)killNull{
    NSMutableDictionary *mutable=[self mutableCopy];
        for (NSString *key in [self allKeys]) {
        id value=self[key];
        if ([value isEqual:[NSNull null]]) {
            [mutable setValue:@"" forKey:key];
        }else if([value isKindOfClass:[NSArray class]]){
            [mutable setObject:[value killNull] forKey:key];
        }
        else if([value isKindOfClass:[NSDictionary class]])
        {
            [mutable setObject:[value killNull] forKey:key];
        }
    }
    return  [mutable copy];
}
@end
