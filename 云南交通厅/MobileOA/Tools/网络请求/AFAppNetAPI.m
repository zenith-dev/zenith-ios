//
//  AFAppNetAPI.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/12.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "AFAppNetAPI.h"

@implementation AFAppNetAPI
static AFAppNetAPI *_sharedClient;
+ (instancetype)sharedClient
{
    if (!_sharedClient) {
        _sharedClient = [AFAppNetAPI manager];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.securityPolicy.allowInvalidCertificates=YES;
        _sharedClient.securityPolicy.validatesDomainName = NO;
        //设置网络请求超时时间
        _sharedClient.requestSerializer.HTTPShouldHandleCookies=YES;
        _sharedClient.requestSerializer.timeoutInterval = 50;
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",nil];


    }
    return _sharedClient;
}
@end
