//
//  AFAppDotNetAPIClient.m
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
@implementation AFAppDotNetAPIClient
static AFAppDotNetAPIClient *_sharedClient;
+ (instancetype)sharedClient
{
    if (!_sharedClient) {
        _sharedClient = [AFAppDotNetAPIClient manager];
        _sharedClient.securityPolicy.allowInvalidCertificates=YES;
        _sharedClient.securityPolicy.validatesDomainName = NO;
        //设置网络请求超时时间
        _sharedClient.requestSerializer.timeoutInterval = 50;
    }
    return _sharedClient;
}
@end
