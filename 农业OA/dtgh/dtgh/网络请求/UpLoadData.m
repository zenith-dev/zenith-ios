//
//  UpLoadData.m
//  HZDLHuiXianXia
//
//  Created by hzdlapple2 on 15/4/13.
//  Copyright (c) 2015年 hzdlapple2. All rights reserved.
//

#import "UpLoadData.h"
static NSOperationQueue *sharedQueue = nil;
@implementation UpLoadData
static NSString * const FORM_FLE_INPUT = @"file1";
+ (NSURLRequest *)uploadRequestWithURL: (NSURL *)url
                                  data: (NSData *)data
                              fileName: (NSString*)fileName{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init] ;
    urlRequest.URL = url;
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}

/**
 *  上传照片
 *
 *  @param url      url
 *  @param data     图片data
 *  @param fileName 文件名
 *  @param handler
 */
+ (void)upLoadImageWithURL:(NSURL*)url data:(NSData *)data fileName:(NSString*)fileName completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    NSURLRequest *request = [self uploadRequestWithURL:url data:data fileName:fileName];
    [NSURLConnection sendAsynchronousRequest:request queue:[self sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(response,data,connectionError);
            }
        });
    }];
}

/**
 *  多张上传
 *
 *  @param url     uerl
 *  @param datas   图片 datas
 *  @param names   name
 *  @param handler
 */
+(void)upLoadImageWithURL:(NSURL*)url datas:(NSArray*)datas fileNames:(NSArray*)names completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler
{
    for (int i=0; i<[datas count]; i++) {
        NSData *data = datas[i];
        NSString *name = names[i];
        [UpLoadData upLoadImageWithURL:url data:data fileName:name completionHandler:handler];
    }
}

+(NSOperationQueue*)sharedQueue
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        [sharedQueue setSuspended:NO];
        [sharedQueue setMaxConcurrentOperationCount:20];
        sharedQueue.name = @"uploadImage";
    });
    return sharedQueue;
}
/**
 *  停止线程
 */
+(void)cancelAllRequest{
    [[UpLoadData sharedQueue] cancelAllOperations];
}

@end
