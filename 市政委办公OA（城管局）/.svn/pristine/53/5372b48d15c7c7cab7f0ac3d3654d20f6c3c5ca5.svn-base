//
//  ztOAAPIClient.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAAPIClient.h"
#import "AFJSONRequestOperation.h"

//#define BASE_URL @"http://192.168.20.11:9001/"

@implementation ztOAAPIClient
//单例模式
+ (ztOAAPIClient *)sharedClient{
    static ztOAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    NSURL *base_url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@/",[ztOAGlobalVariable sharedInstance].serviceIp,[ztOAGlobalVariable sharedInstance].servicePort]];
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ztOAAPIClient alloc] initWithBaseURL:base_url];
    });
    _sharedClient.baseURL=base_url;
    return _sharedClient;
}
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        // HTTP Header
        [self setDefaultHeader:@"Accept" value:@"text/html"];
        [self setDefaultHeader:@"Cache-Control" value:@"no-cache"];
        [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [self setDefaultHeader:@"RequestType" value:@"ajax"];
    }
    
    return self;
}
- (void)setRequestClass:(NSString *)requestClass requestMethod:(NSString *)requestMethod requestHasParams:(NSString *)requestHasParams
{
    [self setDefaultHeader:@"RequestClass" value:requestClass];
    [self setDefaultHeader:@"RequestMethod" value:requestMethod];
    [self setDefaultHeader:@"RequestHasParams" value:requestHasParams];
}
-(void)cancelAllOperation{
    [[self operationQueue] cancelAllOperations];
}

@end
