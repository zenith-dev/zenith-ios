//
//  SHNetWork.m
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "SHNetWork.h"
#import "AFHTTPRequestOperationManager+Synchronous.h"
#import "NSData+AES256.h"



//#define url(method)   [NSString stringWithFormat:@"http://61.186.136.3:8001/OA/action/InvokeAppAction?service=%@",method] //农委测试OA  com.zentih.ios.nyoa

//#define url(method)   [NSString stringWithFormat:@"http://211.158.23.166:8888/newoa/action/InvokeAppAction?service=%@",method]
//国土分局 com.zenith.ios.gtfj


//#define url(method)   [NSString stringWithFormat:@"http://192.168.21.134:7001/newoa/action/InvokeAppAction?service=%@",method]//公司环境

#define url(method)   [NSString stringWithFormat:@"http://192.168.0.241:7001/newoa/action/InvokeAppAction?service=%@",method]//客户内网环境

//#define url(method)   [NSString stringWithFormat:@"http://192.168.21.97:7001/newoa/action/InvokeAppAction?service=%@",method]//测试环境

//#define url(method)   [NSString stringWithFormat:@"http://10.50.0.67:80/OA/action/InvokeAppAction?service=%@",method] //农委OA  com.zentih.ios.nyoa

//#define url(method)   [NSString stringWithFormat:@"http://106.15.56.159:80/action/InvokeAppAction?service=%@",method] //农业OA com.zenith.nwoa

//#define url(method)   [NSString stringWithFormat:@"http://222.177.234.121:7001/action/InvokeAppAction?service=%@",method] //农科院OA com.zenith.ios.nky

//#define url(method)   [NSString stringWithFormat:@"http://10.23.16.8:7001/action/InvokeAppAction?service=%@",method] //农综办OA com.zenith.ios.nzb



//#define url(method)   [NSString stringWithFormat:@"http://192.168.191.1:7001/action/InvokeAppAction?service=%@",method]//农委测试APP com.zenith.ios.nwcs

#define UserApI @"userApi.login"
#define TaskApI @"taskApi.getWaitTaskView"
#define GetSWRunphInfo @"taskApi.getBumphInfo"
#define GetHandleOpinion @"taskApi.getHandleOpinion"
#define GetHandleProcedure @"taskApi.getHandleProcedure"
#define GetOperateList @"taskApi.getOperateList"
#define GetOpinion @"flowOperateApi.getOpinion"
#define SaveOpinion @"flowOperateApi.saveOpinion"
#define GetDepartment @"departmentApi.getDepartment"
#define GetDw @"departmentApi.getDw"
#define GetDepartmentPeople @"departmentApi.getDepartmentPeople"
#define AppointPeople @"flowOperateApi.appointPeople"//指定人员
#define AppointDepartment @"flowOperateApi.appointDepartment"//指定处室
#define SwConference @"flowOperateApi.swConference"//收文会商
#define QueryBwhpage @"dHandleApi.queryBwhpage"//编文号页面
#define QueryWh @"dHandleApi.queryWh"//查询当前期号、预留号
#define SetBwh @"dHandleApi.setBwh"//编文号操作
#define Querybjpage @"dHandleApi.querybjpage"//办结页面显示
#define Setbjopt @"dHandleApi.setbjopt"//办结操作
#define Setzdswdw  @"tblcTaskApi.setzdswdw"//指定接受单位页面显示
#define Fwzdswdw @"tblcTaskApi.fwzdswdw"//指定收文单位操作
#define Querytbshow @"tblcTaskApi.querytbshow"//退办显示页面
#define Gwhtopt @"tblcTaskApi.gwhtopt"//退办操作
#define GetWorkTaskPeople @"departmentApi.getWorkTaskPeople"//查询工作任务领导
#define GetExistSubFlowPeople @"departmentApi.getExistSubFlowPeople"//查询已定义的工作流程名单
#define SubFlowPermit @"flowOperateApi.subFlowPermit"//定义子流程
#define SubFlowEnd @"flowOperateApi.subFlowEnd"//继续流转
#define Setsfsropt @"dHandleApi.setsfsropt"//送返发送人
#define GetPartFlowPeople @"departmentApi.getPartFlowPeople"//查询分流人员
#define GetFlclzdxxx @"departmentApi.getFlclzdxxx"//查询分流人员人员树(从Android移植过来)


#define PartFlowPermit @"flowOperateApi.partFlowPermit"//分流定义
#define PartFlowEnd @"flowOperateApi.partFlowEnd"//分流成完成
#define AppointCS @"flowOperateApi.appointCS"//指定处室
#define AppointUndertakePeople @"flowOperateApi.appointUndertakePeople"//指定承办人
#define ReturnUndertakePeople @"flowOperateApi.returnUndertakePeople"//返回承办人
#define TransactBzEnd @"flowOperateApi.transactBzEnd"//结束办理步骤
#define GetArchives @"taskApi.getArchives"//查询公文列表
#define GetReceiveMailList @"mailApi.getReceiveMailList"//收件箱
#define GetMailInfo @"mailApi.getMailInfo"//邮件信息
#define ReviceMailInfo @"mailApi.reviceMailInfo"
#define NoticeList @"noticeApi.noticeList"//通知列表
#define NoticeDetails @"noticeApi.noticeDetails"//通知详情
#define SearchNewVersion @"versionApi.searchNewVersion"//搜索最新版本
#define QueryGovernList @"governApi.queryGovernList"//政务信息
#define QueryGovernDetails @"governApi.queryGovernDetails"//政务信息详情
#define Home @"userApi.home"
#define Feedback @"userApi.feedback"//意见反馈
#define GetPeople @"flowOperateApi.getPeople"
#define MailApi @"mailApi.sendMail"
#define GetFlowPeople @"flowOperateApi.getFlowPeople"
#define FlowOperateApi @"flowOperateApi.yyPartFlowPermit"
#define GetGwhsDw @"departmentApi.getGwhsDw"
#define GetDepartmentAndPeople @"departmentApi.getDepartmentAndPeople"
#define FindLanguage @"everydayLanguageApi.findLanguage"
#define AddLanguage @"everydayLanguageApi.addLanguage"
#define UpdateLanguage @"everydayLanguageApi.updateLanguage"
#define DeleteLanguage @"everydayLanguageApi.deleteLanguage"

#define GetQuiGckbw @"flowOperateApi.getQuickbw"//获取下步处理任务
#define GetFlclzdxxxksbw @"departmentApi.getFlclzdxxxksbw"//并行多个流程选择处理人

#define SubmitQuickbw @"flowOperateApi.submitQuickbw"//提交多个分流程数据
@implementation SHNetWork
/**
 *  登录
 *
 *  @param stryhm 用户名
 *  @param strmm 密码
 */
+(void)login:(NSString*)stryhm strmm:(NSString*)strmm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strmm":strmm,@"stryhm":stryhm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(UserApI) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}

/**
 *  代办列表
 *
 *  @param intrylsh 人员流水号
 *  @param intcsdwlsh 科室流水号
 *  @param intCurrentPage 当前页
 *  @param intPageRows 显示条数
 */
+(void)getWaitTaskView:(NSString*)intrylsh intcsdwlsh:(NSString*)intcsdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intrylsh":intrylsh,@"intcsdwlsh":intcsdwlsh,@"intCurrentPage":[NSString stringWithFormat:@"%i",(int)intCurrentPage],@"intPageRows":[NSString stringWithFormat:@"%i",(int)intPageRows]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(TaskApI) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  公文基本信息
 *
 *  @param intgwlzlsh 公文流转流水号
 *  @param intdwlsh 单位流水号
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getSwBumphInfo:(NSString*)intgwlzlsh intbzjllsh:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic;
        if (intbzjllsh==nil||[Tools isBlankString:intbzjllsh]) {
            dic=@{@"intgwlzlsh":intgwlzlsh,@"intdwlsh":[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"]};
        }
        else
        {
            dic=@{@"intgwlzlsh":intgwlzlsh,@"intbzjllsh":intbzjllsh,@"intdwlsh":[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"]};
        }
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetSWRunphInfo) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询意见
 *
 *  @param intact 操作号
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getOpinion:(NSString*)intbzjllsh intact:(NSString*)intact completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,@"intact":intact};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetOpinion) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询意见
 *
 *  @param intclyjlsh 处理意见流水号：第一次意见为0
 *  @param intact 操作号
 *  @param intgwlsh 公文流水号
 *  @param chrlrryxm 录入人员名称
 *  @param intyjbh 意见种类编号
 *  @param intbzjllsh 步骤记录流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param chryjnr 意见内容
 *  @param intlrrylsh 实际录入人员流水号
 *  @param intrylsh 人员流水号
 */
+(void)saveOpinion:(NSString*)intclyjlsh intact:(NSString*)intact intgwlsh:(NSString*)intgwlsh chrlrryxm:(NSString*)chrlrryxm intyjbh:(NSString*)intyjbh intbzjllsh:(NSString*)intbzjllsh intgwlzlsh:(NSString*)intgwlzlsh chryjnr:(NSString*)chryjnr intlrrylsh:(NSString*)intlrrylsh intrylsh:(NSString*)intrylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intclyjlsh":intclyjlsh,@"intact":intact,@"intgwlsh":intgwlsh,@"intgwlsh":intgwlsh,@"strlrryxm":chrlrryxm,@"intbzjllsh":intbzjllsh,@"intgwlzlsh":intgwlzlsh,@"stryjnr":chryjnr,@"intlrrylsh":intlrrylsh,@"intrylsh":intrylsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SaveOpinion) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  流程处理意见
 *
 *  @param intgwlzlsh 公文流转流水号
 */
+(void)getHandleOpinion:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetHandleOpinion) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 公文办理流程
 *
 *  @param intgwlzlsh 公文流转流水号
 */
+(void)getHandleProcedure:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetHandleProcedure) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 业务流转处理操作
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intrylsh 人员流水号
 *  @param intcsdwlsh 科室流水号
 *  @param intjsid 任务编号
 *  @param strlclxbm 流程类型编码
 *  @param intgwlsh 公文流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param intgzlclsh 工作流程流水号
 *  @param strgqbz 步骤挂起标志
 */
+(void)getOperateList:(NSString*)intbzjllsh intrylsh:(NSString*)intrylsh intcsdwlsh:(NSString*)intcsdwlsh intjsid:(NSString*)intjsid strlclxbm:(NSString*)strlclxbm intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh strgqbz:(NSString*)strgqbz  completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,@"intrylsh":intrylsh,@"intcsdwlsh":intcsdwlsh,@"intjsid":intjsid,@"strlclxbm":strlclxbm,@"intgwlsh":intgwlsh,@"intgwlzlsh":intgwlzlsh,@"intgzlclsh":intgzlclsh,@"strgqbz":strgqbz};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetOperateList) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 查询部门
 *
 *  @param intdwlsh 单位流水号
 *  @param strdwccbm 单位层次编码
 */
+(void)getDw:(NSString*)intdwlsh strdwccbm:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intdwlsh":intdwlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetDw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 查询单位
 *
 *  @param strdwccbm 单位层次编码
 */
+(void)getDepartment:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strdwccbm":strdwccbm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetDepartment) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 查询单位人员
 *
 *  @param strdwccbm 单位层次编码
 */
+(void)getDepartmentPeople:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strdwccbm":strdwccbm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetDepartmentPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 指定人员
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param intzrrlshlst 责任人流水号
 *  @param strczrxm 操作人名称
 *  @param bolsendsms 是否发送短信（0：不发，1：发送）
 */
+(void)appointPeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intzrrlshlst":intzrrlshlst,
                            @"strczrxm":strczrxm,
                            @"bolsendsms":bolsendsms};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(AppointPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 指定科室
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param intzrrlshlst 责任人流水号
 *  @param strczrxm 操作人名称
 *  @param bolsendsms 是否发送短信（0：不发，1：发送）
 */
+(void)appointDepartment:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intzrrlshlst":intzrrlshlst,
                            @"strczrxm":strczrxm,
                            @"bolsendsms":bolsendsms};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(AppointDepartment) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 收文会商
 *
 *  @param intbzjllsh 步骤记录流水号
 *  @param intfsdwlsh 发送单位流水号
 *  @param intfwdwlsh 发文单位流水号
 *  @param strfsrdwmc 发送单位名称
 *  @param intxtsessionlsh 部门分组编号
 *  @param strjsdwmclst 接收单位名称串，以","隔开,传入
 *  @param intjxlz 是否继续流转
 *  @param strmjlst 接收单位密级串
 *  @param strczrxm 操作人名称
 *  @param strjsdwdzlst 单位地址，多个逗号分隔
 *  @param intfsdwlsh 单位流水号
 *  @param strsmsset 短信提示,1：提示，0：不提示，或者不传
 *  @param strsfyqfsyjbz 要求返回（1：返回，0不返回）
 *  @param dtmyqhfsj 回复时间
 *  @param strisscbz 转交类型（0：纸件，2：电子件）
 *  @param strdbbz 是否督办（1：是，0：否）
 *  @param lcxx 交出内部流程（1：是，0：否）
 *  @param strfsdwyj 转交意见
 */
+(void)swConference:(NSString*)intbzjllsh intfsdwlsh:(NSString*)intfsdwlsh intfwdwlsh:(NSString*)intfwdwlsh strfsrdwmc:(NSString*)strfsrdwmc intxtsessionlsh:(NSString*)intxtsessionlsh strjsdwmclst:(NSString*)strjsdwmclst intjxlz:(NSString*)intjxlz strmjlst:(NSString*)strmjlst strczrxm:(NSString*)strczrxm strjsdwdzlst:(NSString*)strjsdwdzlst strsmsset:(NSString*)strsmsset strsfyqfsyjbz:(NSString*)strsfyqfsyjbz dtmyqhfsj:(NSString*)dtmyqhfsj strisscbz:(NSString*)strisscbz strdbbz:(NSString*)strdbbz lcxx:(NSString*)lcxx strfsdwyj:(NSString*)strfsdwyj completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intfsdwlsh":intfsdwlsh,
                            @"intfwdwlsh":intfwdwlsh,
                            @"strfsrdwmc":strfsrdwmc,
                            @"intxtsessionlsh":intxtsessionlsh,
                            @"strjsdwmclst":strjsdwmclst,
                            @"intjxlz":intjxlz,
                            @"strmjlst":strmjlst,
                            @"strczrxm":strczrxm,
                            @"strjsdwdzlst":strjsdwdzlst,
                            @"strsmsset":strsmsset,
                            @"strsfyqfsyjbz":strsfyqfsyjbz,
                            @"dtmyqhfsj":dtmyqhfsj,
                            @"strdbbz":strdbbz,
                            @"lcxx":lcxx,
                            @"strfsdwyj":strfsdwyj,
                            @"strisscbz":strisscbz};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SwConference) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  编文号页面
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intgwlsh 步骤记录流水号
 *  @param intdwlsh 单位流水号
 */
+(void)queryBwhpage:(NSString*)intbzjllsh intgwlsh:(NSString*)intgwlsh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intgwlsh":intgwlsh,
                            @"intdwlsh":intdwlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(QueryBwhpage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询当前期号、预留号
 *
 *  @param strwzbh 公文字编号
 *  @param intgwlsh 年号
 *  @param intdwlsh 单位流水号
 */
+(void)queryWh:(NSString*)strwzbh strcurnh:(NSString*)strcurnh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strwzbh":strwzbh,
                            @"strcurnh":strcurnh,
                            @"intdwlsh":intdwlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(QueryWh) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  编文号操作
 *
 *  @param intgwlsh 公文流水号
 *  @param intbzjllsh 步骤记录流水号
 *  @param intdwlsh 单位流水号
 *  @param strgwz 公文字（如：渝农发）
 *  @param intgwnh 年号
 *  @param intgwqh 期号
 *  @param strusegwz 原始公文字
 *  @param intusewzbh 原始公文字编号
 *  @param intusegwnh 原始公文年号
 *  @param intusegwqh 原始公文期号
 */
+(void)setBwh:(NSString*)intgwlsh intbzjllsh:(NSString*)intbzjllsh intdwlsh:(NSString*)intdwlsh strgwz:(NSString*)strgwz intgwnh:(NSString*)intgwnh intgwqh:(NSString*)intgwqh strusegwz:(NSString*)strusegwz intusewzbh:(NSString*)intusewzbh intusegwnh:(NSString*)intusegwnh intusegwqh:(NSString*)intusegwqh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intgwlsh":intgwlsh,
                            @"intbzjllsh":intbzjllsh,
                            @"intdwlsh":intdwlsh,
                            @"strgwz":strgwz,
                            @"intgwnh":intgwnh,
                            @"intgwqh":intgwqh,
                            @"strusegwz":strusegwz,
                            @"intusewzbh":intusewzbh,
                            @"intusegwnh":intusegwnh,
                            @"intusegwqh":intusegwqh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SetBwh) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}

/**
 *  办结页面显示
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)querybjpage:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Querybjpage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  办结操作
 *
 *  @param intbzjllsh 步骤记录流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param intdwlsh 操作人单位流水号
 *  @param intrylsh 操作人流水号
 *  @param strryxm 操作人姓名
 *  @param strdwjc 操作人单位名称
 *  @param stryjnr 办结原因
 *  @param intgwgdbz 公文归档标志（等于intgwgdbz表示归档）
 */
+(void)setbjopt:(NSString*)intbzjllsh intgwlzlsh:(NSString*)intgwlzlsh intdwlsh:(NSString*)intdwlsh intrylsh:(NSString*)intrylsh strryxm:(NSString*)strryxm strdwjc:(NSString*)strdwjc stryjnr:(NSString*)stryjnr intgwgdbz:(NSString*)intgwgdbz completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intgwlzlsh":intgwlzlsh,
                            @"intdwlsh":intdwlsh,
                            @"intrylsh":intrylsh,
                            @"strryxm":strryxm,
                            @"strdwjc":strdwjc,
                            @"stryjnr":stryjnr,
                            @"intgwgdbz":intgwgdbz};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Setbjopt) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 指定接受单位页面显示
 *
 *  @param intbzjllsh 步骤记录流水号
 *  @param intgwlsh 公文流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param intdwlsh 单位流水号
 */
+(void)setzdswdw:(NSString*)intbzjllsh intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intgwlsh":intgwlsh,
                            @"intgwlzlsh":intgwlzlsh,
                            @"intdwlsh":intdwlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Setzdswdw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 * 指定收文单位操作
 *
 *  @param strjsdwmclst 接收单位名称串（以”,”分割）
 *  @param strmjlst 公文的密级编号(用,号隔开)
 *  @param strdzc 接收单位地址(多个以”,”分割)
 *  @param intgwlsh 公文流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param intxzrlblst 接收人类别(多个以”,”分割)
 *  @param strzcsbzlst 接收单位主抄送标志(多个以”,”分割)
 *  @param intfslst 接收单位份数串(多个以”,”分割)
 *  @param strzjbzlst 发纸件(多个以”,”分割)
 *  @param strfsdwdz 发送单位地址
 *  @param intfwdwlsh 发送单位流水号
 *  @param strfsrdwmc 发送人单位名称
 *  @param intfsrlsh 发送人流水号
 *  @param strfsrxm 发送人姓名
 *  @param intbzjllsh 步骤记录流水号
 *  @param strsmsset 是否发送短信【1：是】
 *  @param strimset 是否发送即时消息【1：是】
 *  @param strljfsbz 立即发送标志
 *  @param strisscbz 是否上传标志
 
 */
+(void)fwzdswdw:(NSString*)strjsdwmclst strmjlst:(NSString*)strmjlst strdzc:(NSString*)strdzc intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intxzrlblst:(NSString*)intxzrlblst strzcsbzlst:(NSString*)strzcsbzlst intfslst:(NSString*)intfslst strzjbzlst:(NSString*)strzjbzlst strfsdwdz:(NSString*)strfsdwdz intfwdwlsh:(NSString*)intfwdwlsh strfsrdwmc:(NSString*)strfsrdwmc intfsrlsh:(NSString*)intfsrlsh strfsrxm:(NSString*)strfsrxm intbzjllsh:(NSString*)intbzjllsh strsmsset:(NSString*)strsmsset strimset:(NSString*)strimset strljfsbz:(NSString*)strljfsbz strisscbz:(NSString*)strisscbz completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strjsdwmclst":strjsdwmclst,
                            @"strmjlst":strmjlst,
                            @"strdzc":strdzc,
                            @"intgwlsh":intgwlsh,
                            @"intgwlzlsh":intgwlzlsh,
                            @"intxzrlblst":intxzrlblst,
                            @"strzcsbzlst":strzcsbzlst,
                            @"intfslst":intfslst,
                            @"strzjbzlst":strzjbzlst,
                            @"strfsdwdz":strfsdwdz,
                            @"intfwdwlsh":intfwdwlsh,
                            @"strfsrdwmc":strfsrdwmc,
                            @"intfsrlsh":intfsrlsh,
                            @"strfsrxm":strfsrxm,
                            @"intbzjllsh":intbzjllsh,
                            @"strsmsset":strsmsset,
                            @"strimset":strimset,
                            @"strljfsbz":strljfsbz,
                            @"strisscbz":strisscbz,
                            @"strswdwlx":@"0"};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Fwzdswdw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  退办显示页面
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)querytbshow:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Querytbshow) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  退办操作
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 当前操作人流水号
 *  @param stryjnr 回退原因
 *  @param strczrxm 当前操作人姓名
 *  @param intgwlsh 上一步公文流水号
 *  @param intgwlzlsh 上一步公文流转流水号
 *  @param strsmsset 短信提示
 */
+(void)gwhtopt:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh stryjnr:(NSString*)stryjnr strczrxm:(NSString*)strczrxm intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh strsmsset:(NSString*)strsmsset completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"stryjnr":stryjnr,
                            @"strczrxm":strczrxm,
                            @"intgwlsh":intgwlsh,
                            @"intgwlzlsh":intgwlzlsh,
                            @"strsmsset":strsmsset};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Gwhtopt) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询工作任务领导
 *
 *  @param intlcczlsh 流程操作流水号
 *  @param intdwlsh 部门流水号
 *  @param strlclxbm 流程类型编码
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getWorkTaskPeople:(NSString*)intlcczlsh intdwlsh:(NSString*)intdwlsh strlclxbm:(NSString*)strlclxbm intbzjllsh:(NSString*)intbzjllsh  completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intlcczlsh":intlcczlsh,
                            @"intdwlsh":intdwlsh,
                            @"strlclxbm":strlclxbm,
                            @"intbzjllsh":intbzjllsh,
                            @"strdwccbm":[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"],
                            @"strcsdwccbm":[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strcsdwccbm"]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetWorkTaskPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询已定义的工作流程名单
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getExistSubFlowPeople:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetExistSubFlowPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}/**
  *  定义子流程
  *
  *  @param intbzjllsh 步骤记录流水号
  *  @param intczrylsh 本次操作人员流水号
  *  @param intnextgzlclsh 下一个流程处理流水号
  *  @param intrylshlst 人员流水号（多个人员逗号分隔）
  *  @param intbcbhlst 插入步骤编号（多个人员逗号分隔）
  *  @param intgzlclshlst 工作流程流水号（多个人员逗号分隔,代办列表里面也可以取到）
  *  @param strlzlxlst 流程类型，0：网上办理，1:纸件流传（多个人员逗号分隔）默认0
  *  @param intbzlst 标示. 0:历史，1:新添(多个人员逗号分隔)
  *  @param intlcdylshlst 流程定义流水号,新添的默认0，（多个人员逗号分隔）
  *  @param intczrylsh 操作人员流水号
  *  @param strczrxm 本次操作人名称
  */
+(void)subFlowPermit:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intrylshlst:(NSString*)intrylshlst intgzlclshlst:(NSString*)intgzlclshlst strlzlxlst:(NSString*)strlzlxlst intbzlst:(NSString*)intbzlst intlcdylshlst:(NSString*)intlcdylshlst intbcbhlst:(NSString*)intbcbhlst strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intrylshlst":intrylshlst,
                            @"intbcbhlst":intbcbhlst,
                            @"intgzlclshlst":intgzlclshlst,
                            @"strlzlxlst":strlzlxlst,
                            @"intbzlst":intbzlst,
                            @"intlcdylshlst":intlcdylshlst,
                            @"intczrylsh":intczrylsh,
                            @"strczrxm":strczrxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SubFlowPermit) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询工作任务领导
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 */
+(void)subFlowEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strczrxm":strczrxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SubFlowEnd) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  送返发送人
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 */
+(void)setsfsropt:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strczrxm":strczrxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Setsfsropt) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询分流人员
 *
 *  @param strdwccbm 单位层次编码
 *  @param intlcczlsh 流程操作流水号
 *  @param intdwlsh 单位流水号
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getPartFlowPeople:(NSString*)strdwccbm intlcczlsh:(NSString*)intlcczlsh intdwlsh:(NSString*)intdwlsh intbzjllsh:(NSString*)intbzjllsh intgzlclsh:(NSString*)intgzlclsh strcsdwccbm:(NSString*)strcsdwccbm strxzbz:(NSString*)strxzbz completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strdwccbm":strdwccbm,
                            @"intlcczlsh":intlcczlsh,
                            @"intdwlsh":intdwlsh,
                            @"intbzjllsh":intbzjllsh,
                            @"intgzlclsh":intgzlclsh,
                            @"strcsdwccbm":strcsdwccbm,
                            @"strxzbz":strxzbz};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetPartFlowPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}


/**
 根据服务器配置，返回不同类型的人员树
 
 @param intrylsh 人员流水号
 @param strryxm 人员姓名
 @param intbzjllsh 步骤记录流水号
 @param intcsdwlsh 处室单位流水号
 @param xtDwlsh 单位流水号
 @param dwccbm 层次编码
 @param intnextgzlclsh 下一步工作流程流水号
 @param intlcczlsh 流程操作流水号
 */
+(void)getFlclzdxxx:(NSString *)intrylsh:(NSString *)strryxm:(NSString *)intbzjllsh
                   :(NSString *)intcsdwlsh:(NSString *)xtDwlsh:(NSString *)dwccbm
                   :(NSString *)intnextgzlclsh:(NSString *)intlcczlsh
                   :(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intrylsh":intrylsh,
                            @"strryxm":strryxm,
                            @"intbzjllsh":intbzjllsh,
                            @"intcsdwlsh":intcsdwlsh,
                            @"xtDwlsh":xtDwlsh,
                            @"dwccbm":dwccbm,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intlcczlsh":intlcczlsh
                            };
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetFlclzdxxx) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}


/**
 并行多个流程选择处理人
 
 @param intrylsh 人员流水号
 @param strryxm 人员姓名
 @param intbzjllsh 步骤记录流水号
 @param intcsdwlsh 处室单位流水号
 @param xtDwlsh 单位流水号
 @param dwccbm 层次编码
 @param intnextgzlclsh 下一步工作流程流水号
 @param intlcczlsh 流程操作流水号
 */
+(void)getFlclzdxxxksbw:(NSString *)intrylsh:(NSString *)strryxm:(NSString *)intbzjllsh
                   :(NSString *)intcsdwlsh:(NSString *)xtDwlsh:(NSString *)dwccbm
                       :(NSString *)intnextgzlclsh:(NSString *)intlcczlsh
:(NSString*)appintlcbh
                   :(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intrylsh":intrylsh,
                            @"strryxm":strryxm,
                            @"intbzjllsh":intbzjllsh,
                            @"intcsdwlsh":intcsdwlsh,
                            @"xtDwlsh":xtDwlsh,
                            @"dwccbm":dwccbm,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intlcczlsh":intlcczlsh,
                            @"appintlcbh":appintlcbh
                            };
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetFlclzdxxxksbw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}

/**
 *  分流定义
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 *  @param intlcczlsh 流程操作流水号
 *  @param intrylshlst 责任人
 *  @param intbcbhlst 步骤编号
 *  @param intgzlclshlst 工作流程流水号
 *  @param strlzlxlst 流转类型
 *  @param intgwlzlsh 公文流转流水号
 *  @param intbzlst 0:表示原来的保持不变,是指没有被删除
 *  @param intlcdylshlst 原来定义的流水号,如果为新加的则为0
 *  @param strnextgzrylx 下一步工作人员类型
 *  @param intnextgzrylsh 下一步工作人员流水号
 *  @param strzrrlxLst 责任人类型 （0：人，1:处室，多个逗号分隔）
 */
+(void)partFlowPermit:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm intlcczlsh:(NSString*)intlcczlsh intrylshlst:(NSString*)intrylshlst intbcbhlst:(NSString*)intbcbhlst intgzlclshlst:(NSString*)intgzlclshlst strlzlxlst:(NSString*)strlzlxlst intgwlzlsh:(NSString*)intgwlzlsh intbzlst:(NSString*)intbzlst intlcdylshlst:(NSString*)intlcdylshlst strnextgzrylx:(NSString*)strnextgzrylx intnextgzrylsh:(NSString*)intnextgzrylsh strzrrlxLst:(NSString*)strzrrlxLst lint:(int)lint completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strczrxm":strczrxm,
                            @"intlcczlsh":intlcczlsh,
                            @"intrylshlst":intrylshlst,
                            @"intbcbhlst":intbcbhlst,
                            @"intgzlclshlst":intgzlclshlst,
                            @"strlzlxlst":strlzlxlst,
                            @"intgwlzlsh":intgwlzlsh,
                            @"intbzlst":intbzlst,
                            @"intlcdylshlst":intlcdylshlst,
                            @"strnextgzrylx":strnextgzrylx,
                            @"intnextgzrylsh":intnextgzrylsh,
                            @"strzrrlxLst":strzrrlxLst};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        NSString *bburl=nil;
        if (lint==321) {
            //bburl=url(PartFlowPermit);
            bburl =url(FlowOperateApi);
        }
        else
        {
            bburl=url(PartFlowPermit);
        }
        [[AFAppDotNetAPIClient sharedClient]POST:bburl parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  分流成完成
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 */
+(void)partFlowEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strczrxm":strczrxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(PartFlowEnd) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  指定处室
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param intnextgzlclsh  下一个流程流水号
 *  @param intzrrlshlst    责任处室流水号
 *  @param strczrxm        操作人名称
 *  @param bolsendsms      公文流转流水号
 *  @param intgwlzlsh      是否发送短信（0：不发，1：发送
 */
+(void)appointCS:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intzrrlshlst":intzrrlshlst,
                            @"strczrxm":strczrxm,
                            @"bolsendsms":bolsendsms,
                            @"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(AppointCS) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  指定承办人
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param intnextgzlclsh  下一个流程流水号
 *  @param intzrrlshlst    责任人流水号
 *  @param strczrxm        操作人名称
 *  @param bolsendsms      是否发送短信（0：不发，1：发送）
 *  @param intgwlzlsh      公文流转流水号
 */
+(void)appointUndertakePeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"intzrrlshlst":intzrrlshlst,
                            @"strczrxm":strczrxm,
                            @"bolsendsms":bolsendsms,
                            @"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(AppointUndertakePeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  返回承办人
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param intnextgzlclsh  下一个流程流水号
 *  @param strnextzrrmc    操作人员名称
 *  @param strczrxm        操作人名称
 *  @param bolsendsms      是否发送短信（0：不发，1：发送）
 *  @param intgwlzlsh      公文流转流水号
 */
+(void)returnUndertakePeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strnextzrrmc:(NSString*)strnextzrrmc strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strnextzrrmc":strnextzrrmc,
                            @"strczrxm":strczrxm,
                            @"bolsendsms":bolsendsms,
                            @"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(ReturnUndertakePeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  结束办理步骤
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param strczrxm        操作人名称
 */
+(void)transactBzEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"strczrxm":strczrxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(TransactBzEnd) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询公文列表
 *
 *  @param intdwlsh        部门分组编号
 *  @param intrylsh        人员流水号
 *  @param strjsid         角色ID
 *  @param intcsdwlsh      单位科室流水号
 *  @param strgwbt         标题
 *  @param intCurrentPage  当前页数
 *  @param intPageRows     显示条数
 */
+(void)getArchives:(NSString*)intdwlsh intrylsh:(NSString*)intrylsh strjsid:(NSString*)strjsid intcsdwlsh:(NSString*)intcsdwlsh strgwbt:(NSString*)strgwbt intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intdwlsh":intdwlsh,
                            @"intrylsh":intrylsh,
                            @"strjsid":strjsid,
                            @"intcsdwlsh":intcsdwlsh,
                            @"strgwbt":strgwbt,
                            @"intCurrentPage":[NSString stringWithFormat:@"%i",(int)intCurrentPage],
                            @"intPageRows":[NSString stringWithFormat:@"%i",(int)intPageRows]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetArchives) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  收件箱
 *
 *  @param querytype       查询方式（0:全部查询，1 已读,2 未读）
 *  @param intrylsh        人员流水号
 *  @param intdwlsh        单位流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)getReceiveMailList:(NSString*)querytype intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"querytype":querytype,
                            @"intrylsh":intrylsh,
                            @"intdwlsh":intdwlsh,
                            @"intCurrentPage":[NSString stringWithFormat:@"%i",(int)intCurrentPage],
                            @"intPageRows":[NSString stringWithFormat:@"%i",(int)intPageRows]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetReceiveMailList) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  邮件信息
 *
 *  @param inttzlsh        通知流水号
 *  @param inttzjslsh      通知接受流水号
 *  @param intrylsh        人员流水号
 */
+(void)getMailInfo:(NSString*)inttzlsh inttzjslsh:(NSString*)inttzjslsh intrylsh:(NSString*)intrylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"inttzlsh":inttzlsh,
                            @"inttzjslsh":inttzjslsh,
                            @"intrylsh":intrylsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetMailInfo) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}

/**
 *  邮件回复
 *
 *  @param inttzlsh        通知流水号
 *  @param inttzjslsh      通知接受流水号
 *  @param intrylsh        人员流水号
 */
+(void)reviceMailInfo:(NSDictionary*)dic completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(ReviceMailInfo) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}



/**
 *  通知列表
 *
 *  @param strwzyddw       用户当前所在科室、兄弟科室、所属单位流水号串（登录接口）
 *  @param intrylsh        操作人流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)noticeList:(NSString*)strwzyddw intrylsh:(NSString*)intrylsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strwzyddw":strwzyddw,
                            @"intrylsh":intrylsh,
                            @"intCurrentPage":[NSString stringWithFormat:@"%i",(int)intCurrentPage],
                            @"intPageRows":[NSString stringWithFormat:@"%i",(int)intPageRows]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(NoticeList) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            DLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  通知详情
 *
 *  @param inttzlsh        通知
 *  @param intrylsh        操作人流水号
 *  @param intdwlsh        单位流水号
 *  @param strryxm         人员姓名
 */
+(void)noticeDetails:(NSString*)inttzlsh intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh strryxm:(NSString*)strryxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"inttzlsh":inttzlsh,
                            @"intrylsh":intrylsh,
                            @"intdwlsh":intdwlsh,
                            @"strryxm":strryxm};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(NoticeDetails) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            DLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  版本升级
 *
 */
+(void)searchNewVersioncompletionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=nil;
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SearchNewVersion) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            DLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  政务信息
 *
 *  @param intjsdwlsh      单位流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)queryGovernList:(NSString*)intjsdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intdwlsh":intjsdwlsh,
                            @"intCurrentPage":[NSString stringWithFormat:@"%i",(int)intCurrentPage],
                            @"intPageRows":[NSString stringWithFormat:@"%i",(int)intPageRows]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(QueryGovernList) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  政务信息详情
 *
 *  @param intxxbslsh      信息流水号
 *  @param intsessionlsh   回话流水号
 */
+(void)queryGovernDetails:(NSString*)intxxbslsh intsessionlsh:(NSString*)intsessionlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intxxbslsh":intxxbslsh,
                            @"intsessionlsh":intsessionlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(QueryGovernDetails) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  首页提示标识及最新通知
 *
 *  @param strwzyddw       用户当前所在科室、兄弟科室、所属单位流水号串（登录接口）
 *  @param intrylsh        操作人流水号
 *  @param intdwlsh        单位流水号
 *  @param intcsdwlsh      科室流水号
 */
+(void)home:(NSString*)strwzyddw intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh intcsdwlsh:(NSString*)intcsdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strwzyddw":strwzyddw==nil?@"":strwzyddw,
                            @"intrylsh":intrylsh==nil?@"":intrylsh,
                            @"intdwlsh":intdwlsh==nil?@"":intdwlsh,
                            @"intcsdwlsh":intcsdwlsh==nil?@"":intcsdwlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Home) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  意见反馈
 *
 *  @param strfkrmc        当前用户名称
 *  @param strfknr         内容
 *  @param intlx           类型（1:安卓，2：IOS）
 *  @param strbbh          当前版本号
 */
+(void)feedback:(NSString*)strfkrmc strfknr:(NSString*)strfknr intlx:(NSString*)intlx strbbh:(NSString*)strbbh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strfkrmc":strfkrmc,
                            @"strfknr":strfknr,
                            @"intlx":intlx,
                            @"strbbh":strbbh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(Feedback) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  要人的时候
 *
 *  @param intdwlsh
 *  @param intnextgzlclsh
 *  @param intgwlzlsh
 *  @param intbzjllsh
 *  @param type 只有在分流程要人的时候才传type:1
 */
+(void)getPeople:(NSString*)intdwlsh intnextgzlclsh:(NSString*)intnextgzlclsh intgwlzlsh:(NSString*)intgwlzlsh intbzjllsh:(NSString*)intbzjllsh intlcczlsh:(NSString*)intlcczlsh type:(NSString*)type completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:@{@"intdwlsh":intdwlsh,@"intnextgzlclsh":intnextgzlclsh,@"intgwlzlsh":intgwlzlsh,@"intbzjllsh":intbzjllsh,@"intlcczlsh":intlcczlsh}];
        if ([type intValue]==1) {
            [dic setObject:@"1" forKey:@"type"];
        }
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  转发邮件
 *
 *  @param strbzlst        <#strbzlst description#>
 *  @param intjslshlst     <#intjslshlst description#>
 *  @param intcsdwlsh      <#intcsdwlsh description#>
 *  @param strxxjbz        <#strxxjbz description#>
 *  @param strzw           <#strzw description#>
 *  @param strcsjc         <#strcsjc description#>
 *  @param rbtzfs          <#rbtzfs description#>
 *  @param strryxm         <#strryxm description#>
 *  @param intrylsh        <#intrylsh description#>
 *  @param strxmlst        <#strxmlst description#>
 *  @param intdwlsh        <#intdwlsh description#>
 *  @param strtzbt         <#strtzbt description#>
 *  @param strdwjc         <#strdwjc description#>
 *  @param inttzfs         <#inttzfs description#>
 *  @param strhhbz         <#strhhbz description#>
 *  @param inttzlsh_pre         通知流水号
 *  @param completionBlock <#completionBlock description#>
 */
+(void)sendMail:(NSString*)strbzlst intjslshlst:(NSString*)intjslshlst intcsdwlsh:(NSString*)intcsdwlsh strxxjbz:(NSString*)strxxjbz strzw:(NSString*)strzw strcsjc:(NSString*)strcsjc rbtzfs:(NSString*)rbtzfs strryxm:(NSString*)strryxm intrylsh:(NSString*)intrylsh strxmlst:(NSString*)strxmlst intdwlsh:(NSString*)intdwlsh strtzbt:(NSString*)strtzbt strdwjc:(NSString*)strdwjc inttzfs:(NSString*)inttzfs strhhbz:(NSString*)strhhbz isZf:(NSString*)isZf inttzlsh_pre:(NSString*)inttzlsh_pre completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strbzlst":strbzlst,
                            @"intjslshlst":intjslshlst,
                            @"intcsdwlsh":intcsdwlsh,
                            @"strxxjbz":strxxjbz,
                            @"strzw":strzw,
                            @"strcsjc":strcsjc,
                            @"rbtzfs":rbtzfs,
                            @"strryxm":strryxm,
                            @"intrylsh":intrylsh,
                            @"strxmlst":strxmlst,
                            @"intdwlsh":intdwlsh,
                            @"strtzbt":strtzbt,
                            @"strdwjc":strdwjc,
                            @"inttzfs":inttzfs,
                            @"strhhbz":strhhbz,
                            @"iszf":isZf,
                            @"inttzlsh_pre":inttzlsh_pre};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(MailApi) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  分流程已经选择人员
 *
 *  @param intgwlzlsh
 *  @param intgzlclsh
 *  @param intnextgzlclsh
 *  @param completionBlock
 */
+(void)getFlowPeople:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh intnextgzlclsh:(NSString*)intnextgzlclsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intgwlzlsh":intgwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetFlowPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  同步请求数据
 *
 *  @param url         请求地址
 *  @param paramterdic 请求参数
 *
 *  @return 返回值
 */
+(id)asnetworkgetFlowPeopleintgwlzlsh:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh intbzjllsh:(NSString*)intbzjllsh
{
    NSDictionary *dic=@{@"intgzlclsh":intgzlclsh,
                        @"intgwlzlsh":intgwlzlsh,
                        @"intbzjllsh":intbzjllsh};
    NSString *str=[dic JSONString];
    NSString *randomcode=[Tools getEncryptTime];//时间戳
    NSString *verifycode=@"a2c4e6";
    NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
    NSString *params=[NSData AES256EncryptWithPlainText:str :key];
    NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
    NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError *error = nil;
    id result =[manager syncPOST:url(GetFlowPeople) parameters:parameterdic operation:NULL error:&error];
    if (error!=nil) {
        return error;
    }
    else
    {
        return result;
    }
}
/**
 *  收文转交
 *
 *  @param gwlzlsh         公文流转流水号
 *  @param completionBlock
 */
+(void)getGwhsDw:(NSString*)gwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"gwlzlsh":gwlzlsh};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetGwhsDw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  查询单位
 *
 *  @param chrdwccbm       （单位层次编码）（第一层不传）
 *  @param completionBlock
 */
+(void)getDepartmentAndPeople:(NSString*)chrdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strdwccbm":chrdwccbm==nil?@"":chrdwccbm};
        
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetDepartmentAndPeople) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
  *  查询常用语
  *
  *  @param row             显示条数
  *  @param currentPage     当前页数
  */
+(void)everydayLanguageApi:(NSNumber*)row currentPage:(NSNumber*)currentPage completionBlock:(void (^)(id rep,NSString *emsg))completionBlock{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"rows":row,@"currentPage":currentPage,@"intrylsh":[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"intrylsh"]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(FindLanguage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
+(void)addLanguage:(NSString*)strps completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strps":strps,@"intrylsh":[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"intrylsh"]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(AddLanguage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  修改常用语
 *
 *  @param strps           常用数据
 *  @param intpscyylsh     常用ID
 *  @param completionBlock
 */
+(void)updateLanguage:(NSString*)strps intpscyylsh:(NSString*)intpscyylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"strps":strps,@"intpscyylsh":intpscyylsh,@"intrylsh":[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"intrylsh"]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(UpdateLanguage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
/**
 *  删除常用语
 *
 *  @param strps           常用数据
 *  @param intpscyylsh     常用ID
 *  @param completionBlock
 */
+(void)deleteLanguage:(NSString*)strps intpscyylsh:(NSString*)intpscyylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
         NSDictionary *dic=@{@"strps":strps,@"intpscyylsh":intpscyylsh,@"intrylsh":[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"intrylsh"]};
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(DeleteLanguage) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            NSLog(@"%@",[responseObject JSONString]);
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}



/**
 在并行多个分流程中获取下步处理任务

 @param intdwlsh 单位流水号
 @param intlcczlsh 流程操作流水号
 @param completionBlock
 */
+(void)getQuickbw:(NSString*)intdwlsh :(NSString*)intlcczlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{@"intdwlsh":intdwlsh,
                            @"intlcczlsh":intlcczlsh
                           };
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(GetQuiGckbw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}


/**
 在并行多个分流程中提交结果数据
 
 @param intdwlsh 单位流水号
 @param intlcczlsh 流程操作流水号
 @param completionBlock
 */
+(void)submitQuickbw:
    (NSString*)intbzjllsh:
    (NSString*)intczrylsh:
    (NSString*)intnextgzlclsh:
    (NSString*)strczrxm:
    (NSString*)intnextgzrylsh:
    (NSString*)intbcbhlst:
    (NSString*)intgzlclshlst:
    (NSString*)strlzlxlst:
    (NSString*)intlcczlsh:
    (NSString*)intrylshlst:
    (NSString*)intgwlzlsh:
    (NSString*)intbzlst:
    (NSString*)intlcdylshlst:
    (NSString*)strnextgzrylx:
    (NSString*)strzrrlxLst completionBlock:(void (^)(id rep,NSString *emsg))completionBlock
{
    if ([Tools IsNetwork]) {
        NSDictionary *dic=@{
                            @"intbzjllsh":intbzjllsh,
                            @"intczrylsh":intczrylsh,
                            @"intnextgzlclsh":intnextgzlclsh,
                            @"strczrxm":strczrxm,
                            @"intnextgzrylsh":intnextgzrylsh,
                            @"intbcbhlst":intbcbhlst,
                            @"intgzlclshlst":intgzlclshlst,
                            @"strlzlxlst":strlzlxlst,
                            @"intlcczlsh":intlcczlsh,
                            @"intrylshlst":intrylshlst,
                            @"intgwlzlsh":intgwlzlsh,
                            @"intbzlst":intbzlst,
                            @"intlcdylshlst":intlcdylshlst,
                            @"strnextgzrylx":strnextgzrylx,
                            @"strzrrlxLst":strzrrlxLst
                            };
        NSString *str=[dic JSONString];
        NSString *randomcode=[Tools getEncryptTime];//时间戳
        NSString *verifycode=@"a2c4e6";
        NSString *key=[Tools md5:[NSString stringWithFormat:@"%@%@",verifycode,[Tools md5:[NSString stringWithFormat:@"%@%@",randomcode,verifycode]]]];
        NSString *params=[NSData AES256EncryptWithPlainText:str :key];
        NSString *mac =[Tools md5:[NSString stringWithFormat:@"%@%@%@",randomcode,verifycode,params]];
        NSDictionary *parameterdic=@{@"r":randomcode,@"v":verifycode,@"key":key,@"mac":mac,@"param":params,@"source_type":@"2"};
        [[AFAppDotNetAPIClient sharedClient]POST:url(SubmitQuickbw) parameters:parameterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            completionBlock(responseObject,nil);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            completionBlock(nil,errorMsg);
        }];
    }
    else{
        completionBlock(nil,NotWrok);
    }
}
@end

