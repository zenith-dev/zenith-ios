//
//  AFAppNetAPI.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/12.
//  Copyright © 2016年 xj. All rights reserved.
//

//#import <AFNetworking/AFNetworking.h>

@interface AFAppNetAPI : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
