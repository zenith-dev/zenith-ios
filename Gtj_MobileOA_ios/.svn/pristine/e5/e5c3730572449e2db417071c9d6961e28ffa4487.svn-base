//
//  UpLoadData.h
//  HZDLHuiXianXia
//
//  Created by hzdlapple2 on 15/4/13.
//  Copyright (c) 2015年 hzdlapple2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpLoadData : NSObject
/**
 *  上传照片
 *
 *  @param url      url
 *  @param data     图片data
 *  @param fileName 文件名
 *  @param handler
 */
+ (void)upLoadImageWithURL:(NSURL*)url data:(NSData *)data fileName:(NSString*)fileName completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;
/**
 *  多张上传
 *
 *  @param url     uerl
 *  @param datas   图片 datas
 *  @param names   name
 *  @param handler
 */
+(void)upLoadImageWithURL:(NSURL*)url datas:(NSArray*)datas fileNames:(NSArray*)names completionHandler:(void (^)(NSURLResponse* response,NSData *data,NSError *error))handler;



@end
