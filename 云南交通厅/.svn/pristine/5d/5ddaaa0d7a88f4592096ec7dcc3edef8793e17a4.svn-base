//
//  UIViewController+util.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/5/11.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "UIViewController+util.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFAppDotNetAPIClient.h"
#import "AFAppNetAPI.h"
#import "NSDictionary+util.h"
#import "NSArray+util.h"
#define  LOGINPATH @"ZTMobileGateway/oaAjaxServlet"
@implementation UIViewController (util)
-(void)showMessage:(NSString*)message{
    UIView *views=self.navigationController?self.navigationController.view:self.view;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:views animated:YES];
    hud.mode=MBProgressHUDModeCustomView;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(kScreenWidth/4, 24);
    hud.margin = 15;
    hud.labelText=message;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}
-(MBProgressHUD*)progressWaitingWithMessage:(NSString*)message{
    if (!message) {
        return nil;
    }
    UIView *views=self.navigationController?self.navigationController.view:self.view;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:views animated:YES];
    hud.minShowTime=0.5;
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.labelText=message;
    return hud;
}
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
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        
        [[AFAppDotNetAPIClient setRequestClass:requestClass requestMethod:requestMethod requestHasParams:requestHasParams] POST:[NSString stringWithFormat:@"http://%@:%@/%@",SingObj.serviceIp,SingObj.servicePort,LOGINPATH] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            [hud hide:YES];
            NSLog(@"%@",[responseObject mj_JSONString]);
            responseObject=[responseObject killNull];
            if ([responseObject[@"root"][@"result"] intValue]==0) {
                completionBlock(responseObject[@"root"]);
            }
            else
            {
                [self showMessage:responseObject[@"root"][@"message"]];
                completionBlock(nil);
            }
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            [hud hide:YES];
            [self showMessage:@"网络不稳定，请重试"];
            completionBlock(nil);
        }];
    }
    else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}
-(void)networkall:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppDotNetAPIClient setRequestClass:requestClass requestMethod:requestMethod requestHasParams:requestHasParams] POST:[NSString stringWithFormat:@"http://%@:%@/%@",SingObj.serviceIp,SingObj.servicePort,LOGINPATH] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            [hud hide:YES];
            NSLog(@"%@",[responseObject mj_JSONString]);
            responseObject=[responseObject killNull];
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            [hud hide:YES];
            [self showMessage:@"网络不稳定，请重试"];
            completionBlock(nil);
        }];
        
    }
    else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}
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
-(void)networkLogin:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock;
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppDotNetAPIClient setRequestClass:requestClass requestMethod:requestMethod requestHasParams:requestHasParams] POST: [NSString stringWithFormat:@"http://%@:%@/%@",SingObj.serviceIp,SingObj.servicePort,LOGINPATH] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            [hud hide:YES];
            NSLog(@"%@",[responseObject mj_JSONString]);
            responseObject=[responseObject killNull];
            completionBlock(responseObject[@"root"]);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            [hud hide:YES];
            [self showMessage:@"网络不稳定，请重试"];
            completionBlock(nil);
        }];
    }
    else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}

-(void)newworkGet:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppNetAPI sharedClient] GET:[NSString stringWithFormat:@"http://172.17.204.119:9090/WebService/mobile/%@",url] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id  responseObject) {
            [hud hide:YES];
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",[aString mj_JSONString]);
            NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            resdic=[resdic killNull];
            completionBlock(resdic);
        } failure:^(AFHTTPRequestOperation *  operation, NSError *  error) {
            [hud hide:YES];
            [self showMessage:error.localizedFailureReason];
            completionBlock(nil);
        }];
    }else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}

-(void)newworkversionallGet:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppNetAPI sharedClient] GET:[NSString stringWithFormat:@"http://%@:%@/ZTMobileGateway/%@",SingObj.serviceIp,SingObj.servicePort,url] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id  responseObject) {
            [hud hide:YES];
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",[aString mj_JSONString]);
            completionBlock(aString);
        } failure:^(AFHTTPRequestOperation *  operation, NSError *  error) {
            [hud hide:YES];
            [self showMessage:error.localizedFailureReason];
            completionBlock(nil);
        }];
    }else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}





-(void)newworkGetall:(NSString*)url parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppNetAPI sharedClient] GET:[NSString stringWithFormat:@"http://172.17.204.119:9090/WebService/mobile/%@",url] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id  responseObject) {
            [hud hide:YES];
            NSString *aString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",[aString mj_JSONString]);
            completionBlock(aString);
        } failure:^(AFHTTPRequestOperation *  operation, NSError *  error) {
            [hud hide:YES];
            [self showMessage:error.localizedFailureReason];
            completionBlock(nil);
        }];
    }else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    UIButton *rightbtn= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 40, 40)];
    if(image){
        [rightbtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [rightbtn setTitle:title forState:UIControlStateNormal];
        [rightbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        if (image) {
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        rightbtn.titleLabel.font = Font(15);
        rightbtn.frame=CGRectMake(X(rightbtn), Y(rightbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(rightbtn));
    }
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightbtn]];
    return rightbtn;
}
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title imagen:(NSString*)imagen imageh:(NSString*)imageh sel:(SEL)sel
{
    UIButton *rightbtn= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 45, 44)];
    if(imagen){
        [rightbtn setImage:[UIImage imageNamed:imagen] forState:UIControlStateNormal];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if (imageh) {
        [rightbtn setImage:[UIImage imageNamed:imageh] forState:UIControlStateHighlighted];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [rightbtn setTitle:title forState:UIControlStateNormal];
        [rightbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        rightbtn.titleLabel.font = Font(15);
        rightbtn.frame=CGRectMake(X(rightbtn), Y(rightbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(rightbtn));
    }
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightbtn]];
    return rightbtn;
}

/**定义右边按钮文字
 */
- (UIButton*)leftButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    UIButton *lefbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,20, 40, 40)];
    if(image){
        [lefbtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [lefbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [lefbtn setTitle:title forState:UIControlStateNormal];
        [lefbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        if (image) {
            [lefbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [lefbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [lefbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        lefbtn.titleLabel.font = Font(15);
        lefbtn.frame=CGRectMake(X(lefbtn), Y(lefbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(lefbtn));
    }
    lefbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [lefbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:lefbtn],negativeSpacer];
    return lefbtn;
}
@end
