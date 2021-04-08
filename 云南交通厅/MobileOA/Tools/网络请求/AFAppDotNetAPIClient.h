//
//  AFAppDotNetAPIClient.h
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

//#import <AFHTTPRequestOperationManager.h>
#import <AFHTTPSessionManager.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager
+ (AFAppDotNetAPIClient*)setRequestClass:(NSString *)requestClass requestMethod:(NSString *)requestMethod requestHasParams:(NSString *)requestHasParams;
+ (AFAppDotNetAPIClient*)sharedClientHTTP;



@end
