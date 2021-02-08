//
//  UIViewController+util.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/5/11.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface UIViewController (util)

-(void)showMessage:(NSString*)message;

-(MBProgressHUD*)progressWaitingWithMessage:(NSString*)message;
/**
 *  数据请求接口
 *
 *  @param requestClass     访问类
 *  @param requestMethod    访问类函数
 *  @param requestHasParams 是否
 *  @param paramterdic      访问参数
 *  @param hudText          是否需要等待指示器
 *  @param completionBlock  返回值
 */
-(void)network:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;

/**
 *  数据请求接口
 *
 *  @param requestClass     访问类
 *  @param requestMethod    访问类函数
 *  @param requestHasParams 是否
 *  @param paramterdic      访问参数
 *  @param hudText          是否需要等待指示器
 *  @param completionBlock  返回值
 */
-(void)networkall:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;


-(void)networkLogin:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;


-(void)newworkGet:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;

-(void)newworkGetall:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;

-(void)newworkversionallGet:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;

- (UIButton*)rightButton:(NSString*)title imagen:(NSString*)imagen imageh:(NSString*)imageh sel:(SEL)sel;
/**定义右边按钮文字
 */
- (UIButton*)leftButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;

@end
