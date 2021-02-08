//
//  AFAppDotNetAPIClient.h
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFAppDotNetAPIClient : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;
@end
