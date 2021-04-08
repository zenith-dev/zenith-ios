//
//  AFAppDotNetAPIClient.m
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"
@implementation AFAppDotNetAPIClient
+ (AFAppDotNetAPIClient*)sharedClientHTTP
{
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [AFAppDotNetAPIClient manager];
        _sharedClient.securityPolicy.allowInvalidCertificates=YES;
        _sharedClient.securityPolicy.validatesDomainName = NO;
        _sharedClient.requestSerializer=[AFJSONRequestSerializer serializer];
        _sharedClient.responseSerializer=[AFJSONResponseSerializer serializer];
        [_sharedClient.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
        [_sharedClient.requestSerializer setValue:@"no-cache"forHTTPHeaderField:@"Cache-Control"];
        [_sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [_sharedClient.requestSerializer setValue:@"ajax" forHTTPHeaderField:@"RequestType"];
        _sharedClient.requestSerializer.HTTPShouldHandleCookies=YES;
        _sharedClient.requestSerializer.timeoutInterval = 50;
        // 添加这句代码
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    return _sharedClient;
}

+ (AFAppDotNetAPIClient*)setRequestClass:(NSString *)requestClass requestMethod:(NSString *)requestMethod requestHasParams:(NSString *)requestHasParams
{
    [[self sharedClientHTTP].requestSerializer setValue:requestClass forHTTPHeaderField:@"RequestClass"];
    [[self sharedClientHTTP].requestSerializer setValue:requestMethod forHTTPHeaderField:@"RequestMethod"];
    [[self sharedClientHTTP].requestSerializer setValue:requestHasParams forHTTPHeaderField:@"RequestHasParams"];
    return [self sharedClientHTTP];
}

@end
