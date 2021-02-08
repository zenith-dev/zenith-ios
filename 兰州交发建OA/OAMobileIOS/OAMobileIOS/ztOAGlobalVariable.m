//
//  ztOAGlobalVariable.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAGlobalVariable.h"

@implementation ztOAGlobalVariable
@synthesize userId,userKey,userName;
@synthesize userzh,intrylsh,intdwlsh,intdwlsh_child,username,unitname,unitname_child;
@synthesize deviceId,serviceIp,servicePort;
@synthesize userHeadPicName,intsessionlsh;
+ (ztOAGlobalVariable *)sharedInstance {
    static ztOAGlobalVariable *_sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[ztOAGlobalVariable alloc] init];
    });
    return _sharedObj;
}
@end
