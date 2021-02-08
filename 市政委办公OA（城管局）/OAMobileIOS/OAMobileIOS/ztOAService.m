//
//  ztOAService.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAService.h"
#import "ztOAAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#define PATH   @""
#define LOGINPATH   @"ZTMobileGateway/oaAjaxServletProxy"
@implementation ztOAService

/*+++++++++++++++设备绑定+++++++++++++++*/
//申请接入许可
+(void)userDeviceBand:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"userbindservices" requestMethod:@"userBind" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath1:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//取消绑定
+(void)userCancelDeviceBand:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"userbindservices" requestMethod:@"userCancelBind" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath1:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//查询绑定状态
+(void)getDeviceBandState:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"userbindservices" requestMethod:@"selBindState" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath1:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}


//登陆
+(void)userLogin:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"usercenter" requestMethod:@"login" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath1:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//人员信息
+(void)userInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"usercenter" requestMethod:@"getRyxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
         //NSLog(@"%@",responseObject);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//获取头像
+(void)downloadUserHeadImage:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"usercenter" requestMethod:@"downloadRyxp" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSLog(@"%@",responseObject);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
    
}

//上传头像
+(void)updateUserHeadImage:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"usercenter" requestMethod:@"uploadRyxp" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSLog(@"%@",responseObject);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark -/*+++++++++++++++公文历史库查询+++++++++++++++*/
+(void)getlsgwList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getlsgwList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

#pragma mark -/*+++++++++++++++个人公文+++++++++++++++*/
//获取待办公文列表
+(void)getGrGwcxList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGrGwcxList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark -/*+++++++++++++++公文+++++++++++++++*/
//获取待办公文数量
+(void)getOfficeDocNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getDclgwNum" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//获取待办公文列表
+(void)getOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getDclgwList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//公文查询列表
+(void)searchOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
   [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGwcxList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//获取公文基本信息及流转信息
+(void)getOfficeDocDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGwlzxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//公文收藏
+(void)setGwgrscfj:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"setGwgrscfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//公文取消收藏
+(void)delGwgrscfj:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"delGwgrscfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//获取公文基本信息及流转处理信息
+(void)getOfficeDocLzclInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGwlzclxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//获取公文附件内容
+(void)getDocAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getFj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//提交公文流转
+(void)saveOfficeDocFlowInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"setGwlz" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:100];
}

//个人公文查询
+(void)searchPersonalOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGrGwcxList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}


//获取公文基本信息及流转处理信息
+(void)getOfficeDocDealInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"setGwfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//改稿上传正文搞
+(void)upLoadDocAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getGwlzclxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//分流程查询人员
+(void)getFlclzdxxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getFlclzdxxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//指定内部人员下载 、指定传阅功能、指定公文查询方式
+(void)getZdcydxxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getZdcydxxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}




//查询组织机构人员信息
+(void)getCompanyPersonList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"dwservices" requestMethod:@"getDw" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//查询人员组信息
+(void)getPersonGroupList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"lxrservices" requestMethod:@"selRyzByContion" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//查询人员信息
+(void)getPersonList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"lxrservices" requestMethod:@"selRyByIntryzbh" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

#pragma mark -/*+++++++++++++++公告++++++++++++++*/
//公告查询列表
+(void)searchNoticeList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"ggservices" requestMethod:@"getGgList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//公告未读条数
+(void)getggNum:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"ggservices" requestMethod:@"getGgNum" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//获取公告信息内容
+(void)getNoticeDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"ggservices" requestMethod:@"getGgxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//公告信息内容(内容有图片不返回)
+(void)getNoticeWithoutPicDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"ggservices" requestMethod:@"getGgxxnotTP" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

#pragma mark -/*+++++++++++++++通知+++++++++++++++*/
//通知数量
+(void)getInformNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"tzServices" requestMethod:@"getTzNum" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//通知列表查询
+(void)getInformList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"tzServices" requestMethod:@"getTzList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//通知信息内容
+(void)getInformDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"tzServices" requestMethod:@"getTzxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//通知附件
+(void)getInformAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"tzServices" requestMethod:@"getTzfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       // NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark -/*+++++++++++++++邮件+++++++++++++++*/
//邮件数量
+(void)getEmailNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjNum" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//内部邮件收件箱查询
+(void)getReceiveEmailList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//内部邮件发件箱查询
+(void)getSendEmailList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjJk" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//发送邮件
+(void)sendEmail:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"sendNbyj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//上传邮件附件
+(void)sendEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"sendNbyjFj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//转发更新附件
+(void)sendForwardEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"updateYfjToXfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//查询邮件详情
+(void)getEmailDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjXx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//邮件附件
+(void)getEmailAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjFj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//查看收件情况
+(void)fadeEmailReceiveStatusInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"getNbyjJk" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//更新内部邮件查看标志
+(void)updateEmailLookingFlag:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"updateCkbz" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//删除临时附件
+(void)deleteEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"delNbyjLsfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//根据附件流水号删除邮件附件
+(void)deleteEmailAttachmentsBylsh:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"delNbyjLsfjByfjlsh" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//根据流水号删除邮件(删除邮件)
+(void)deleteEmailsBylsh:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"nbyjServices" requestMethod:@"delNbyjByInttzlsh" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];

}

#pragma mark -/*+++++++++++++++刊物+++++++++++++++*/
//刊物目录
+(void)getPublicationDirectory:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getKwml" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//刊物目录列表查询
+(void)searchPublicationDirectoryList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getKwByKwlb" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//刊物详情
+(void)getPublicDetailDirectory:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getKwXx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
       
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//刊物下载
+(void)loadPublication:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getKwxz" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

#pragma mark -/*+++++++++++++++联系人+++++++++++++++*/
//联系人列表
+(void)getContactsList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"lxrservices" requestMethod:@"getDwTxlLxrListNoContionBygzip" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];

}
#pragma mark---------------联系人市政委-----------------
+(void)getDwTxlLxrListNoContionByzipNew:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"lxrservices" requestMethod:@"getDwTxlLxrListNoContionByzipNew" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);

        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

//联系人详细信息
+(void)getContactsDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"lxrservices" requestMethod:@"getLxrxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark-新增接口
//获取常用语接口
+(void)getPersonCyyList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"userbindservices" requestMethod:@"selCyy" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"res=%@",str);
        
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

/*+++++++++++++++每周日程+++++++++++++++*/
+(void)getRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"rcxxServices" requestMethod:@"getRcxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//每周日程（新增）接口
+(void)addRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"rcxxServices" requestMethod:@"addOneRcxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//每周日程（删除）接口
+(void)deleteRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"rcxxServices" requestMethod:@"deleteRcxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//每周日程（修改）接口
+(void)updateRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"rcxxServices" requestMethod:@"updateRcxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark-----------会议模块
//会议列表
+(void)getHyList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"HyServices" requestMethod:@"getHyList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//会议详情
+(void)getdetailList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"HyServices" requestMethod:@"getHyxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
#pragma mark--------------领导讲话模块------------
//领导讲话列表
+(void)getWzglList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"fzbgservices" requestMethod:@"getWzglList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//获取领导讲话信息内容
+(void)getWzglxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"fzbgservices" requestMethod:@"getWzglxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//**获取领导分类列表*/
+(void)getrysyflbyrylshlst:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"fzbgservices" requestMethod:@"getrysyflbyrylshlst" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/*+++++++++++++++政务信息模块+++++++++++++++*/
//政务信息列表
+(void)getZxZwxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getZxZwxx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//获取政务信息内容
+(void)getZxzwxxxq:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getZxzwxxxq" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//*政务信息收藏*/
+(void)setxxgrscfj:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"setxxgrscfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
//*政务信息收藏取消*/
+(void)delxxgrscfj:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"delxxgrscfj" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/*+++++++++++++++业务指导模块+++++++++++++++*/
/**业务指导处室列表*/
+(void)getYwzdCs:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getYwzdCs" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/**业务指导处室功能模块*/
+(void)getYwzdGn:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getYwzdGn" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/**业务指导处室功能模块文档列表*/
+(void)getYwzdGnWd:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getYwzdGnWd" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/**业务指导详情页面*/
+(void)getBmzlXx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getBmzlXx" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

/*+++++++++++++++收藏模块+++++++++++++++*/
/**政务信息收藏列表*/
+(void)getxxscjList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"kwservices" requestMethod:@"getxxscjList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}
/**公文收藏列表*/
+(void)getgwscjList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [[ztOAAPIClient sharedClient] setRequestClass:@"document" requestMethod:@"getgwscjList" requestHasParams:@"true"];
    [[ztOAAPIClient sharedClient] postPath:LOGINPATH parameters:sendData success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *response=[responseObject objectFromJSONData];
        NSString *resultstr=[NSString stringWithFormat:@"%@",response[@"root"][@"result"]];
        if ([resultstr isEqualToString:@"-110"]) {
            postNWithInfos(@"SINGLEPOINT",nil, nil);
            return ;
        }
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"res=%@",str);
        SAFE_BLOCK_CALL(success, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
        SAFE_BLOCK_CALL(failed, error);
    } timeOut:10];
}

@end
