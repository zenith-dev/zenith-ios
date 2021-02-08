//
//  LoginModel.m
//  MobileOA
//
//  Created by 大熊 on 16/11/24.
//  Copyright © 2016年 dx. All rights reserved.
//

#import "LoginModel.h"
#import "Userinfo.h"
#import "Unitinfo.h"

@implementation LoginModel

+ (NSString*)protocolForArrayProperty:(NSString *)propertyName {
	if ([propertyName isEqualToString:@"unitinfo"]) {
		return NSStringFromClass([Userinfo class]);
	}
	if ([propertyName isEqualToString:@"userinfo"]) {
		return NSStringFromClass([Unitinfo class]);
	}
	return nil;
}


@end
