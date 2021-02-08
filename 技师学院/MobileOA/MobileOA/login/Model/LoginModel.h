//
//  LoginModel.h
//  MobileOA
//
//  Created by 大熊 on 16/11/24.
//  Copyright © 2016年 dx. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Userinfo;
@class Unitinfo;

@interface LoginModel : NSObject

@property (nonatomic, assign) long alldwlsh;
@property (nonatomic, strong) NSString * chrxpmc;
@property (nonatomic, assign) long intsessionlsh;
@property (nonatomic, assign) long result;
@property (nonatomic, strong) Unitinfo * unitinfo;
@property (nonatomic, strong) Userinfo * userinfo;

@end
