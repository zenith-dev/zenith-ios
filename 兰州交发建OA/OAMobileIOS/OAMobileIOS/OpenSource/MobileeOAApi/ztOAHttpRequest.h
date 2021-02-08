//
//  ztOAHttpRequest.h
//  OAMobileIOS
//
//  Created by ran chen on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface ztOAHttpRequest : NSObject
+ (void) sendUrl:(NSString*)url sendParams:(NSDictionary*)params sendClass:(NSString*)sclass sendMethod:(NSString*)method sendHasParams:(NSString*)hasParams completionBlock:(SuccessBlock)success andFailedBlock:(FailedBlock)failed;
@end
