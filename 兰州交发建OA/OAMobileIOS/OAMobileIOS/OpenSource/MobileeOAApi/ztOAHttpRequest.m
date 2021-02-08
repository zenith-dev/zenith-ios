//
//  ztOAHttpRequest.m
//  OAMobileIOS
//
//  Created by ran chen on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAHttpRequest.h"

@implementation ztOAHttpRequest

+ (void) sendUrl:(NSString*)url sendParams:(NSDictionary*)params sendClass:(NSString*)sclass sendMethod:(NSString*)method sendHasParams:(NSString*)hasParams completionBlock:(SuccessBlock)success andFailedBlock:(FailedBlock)failed{
    NSData *sendData = [params JSONData];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"no-cache" forHTTPHeaderField: @"Cache-Control"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"ajax" forHTTPHeaderField: @"RequestType"];
    [request setValue:sclass forHTTPHeaderField: @"RequestClass"];
    [request setValue:method forHTTPHeaderField: @"RequestMethod"];
    [request setValue:hasParams forHTTPHeaderField: @"RequestHasParams"];
    [request setHTTPBody:sendData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                SAFE_BLOCK_CALL(failed, connectionError);
            });
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                SAFE_BLOCK_CALL(success, responseString);
            });
        }
    }];
}

@end
