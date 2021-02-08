//
//  ztOAAPIClient.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ztOAAPIClient : AFHTTPClient
+(ztOAAPIClient *)sharedClient;
- (void)setRequestClass:(NSString *)requestClass requestMethod:(NSString *)requestMethod requestHasParams:(NSString *)requestHasParams;

-(void)cancelAllOperation;
@end
