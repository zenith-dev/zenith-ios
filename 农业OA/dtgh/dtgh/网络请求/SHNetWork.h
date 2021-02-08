//
//  SHNetWork.h
//  SeeHim
//
//  Created by 熊佳佳 on 15/9/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"AFAppDotNetAPIClient.h"
#import "AFNetworking.h"
#import "UpLoadData.h"
@interface SHNetWork : NSObject
/**
 *  登录
 *
 *  @param stryhm 用户名
 *  @param strmm 密码
 */
+(void)login:(NSString*)stryhm strmm:(NSString*)strmm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  代办列表
 *
 *  @param intrylsh 人员流水号
 *  @param intcsdwlsh 科室流水号
 *  @param intCurrentPage 当前页
 *  @param intPageRows 显示条数
 */
+(void)getWaitTaskView:(NSString*)intrylsh intcsdwlsh:(NSString*)intcsdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  公文基本信息
 *
 *  @param intgwlzlsh 公文流转流水号
 *  @param intbzjllsh 步骤流水号 
 */
+(void)getSwBumphInfo:(NSString*)intgwlzlsh intbzjllsh:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


/**
 *  查询意见
 *
 *  @param intact 操作号
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getOpinion:(NSString*)intbzjllsh intact:(NSString*)intact completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


/**
 *  保存意见
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
+(void)saveOpinion:(NSString*)intclyjlsh intact:(NSString*)intact intgwlsh:(NSString*)intgwlsh chrlrryxm:(NSString*)chrlrryxm intyjbh:(NSString*)intyjbh intbzjllsh:(NSString*)intbzjllsh intgwlzlsh:(NSString*)intgwlzlsh chryjnr:(NSString*)chryjnr intlrrylsh:(NSString*)intlrrylsh intrylsh:(NSString*)intrylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  流程处理意见
 *
 *  @param intgwlzlsh 公文流转流水号
 */
+(void)getHandleOpinion:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 * 公文办理流程
 *
 *  @param intgwlzlsh 公文流转流水号
 */
+(void)getHandleProcedure:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

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
+(void)getOperateList:(NSString*)intbzjllsh intrylsh:(NSString*)intrylsh intcsdwlsh:(NSString*)intcsdwlsh intjsid:(NSString*)intjsid strlclxbm:(NSString*)strlclxbm intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh strgqbz:(NSString*)strgqbz  completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


/**
 * 查询部门
 *
 *  @param intdwlsh 单位流水号
 *  @param strdwccbm 单位层次编码
 */
+(void)getDw:(NSString*)intdwlsh strdwccbm:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 * 查询单位
 *
 *  @param strdwccbm 单位层次编码
 */
+(void)getDepartment:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 * 查询单位人员
 *
 *  @param strdwccbm 单位层次编码
 */
+(void)getDepartmentPeople:(NSString*)strdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 * 收文会商
 *
 *  @param intbzjllsh 步骤记录流水号
 *  @param intfsdwlsh 发送单位流水号
 *  @param intfwdwlsh 发文单位流水号
 *  @param strfsrdwmc 发送单位名称
 *  @param intxtsessionlsh 会话流水号
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
+(void)swConference:(NSString*)intbzjllsh intfsdwlsh:(NSString*)intfsdwlsh intfwdwlsh:(NSString*)intfwdwlsh strfsrdwmc:(NSString*)strfsrdwmc intxtsessionlsh:(NSString*)intxtsessionlsh strjsdwmclst:(NSString*)strjsdwmclst intjxlz:(NSString*)intjxlz strmjlst:(NSString*)strmjlst strczrxm:(NSString*)strczrxm strjsdwdzlst:(NSString*)strjsdwdzlst strsmsset:(NSString*)strsmsset strsfyqfsyjbz:(NSString*)strsfyqfsyjbz dtmyqhfsj:(NSString*)dtmyqhfsj strisscbz:(NSString*)strisscbz strdbbz:(NSString*)strdbbz lcxx:(NSString*)lcxx strfsdwyj:(NSString*)strfsdwyj completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  编文号页面
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intgwlsh 步骤记录流水号
 *  @param intdwlsh 单位流水号
 */
+(void)queryBwhpage:(NSString*)intbzjllsh intgwlsh:(NSString*)intgwlsh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  查询当前期号、预留号
 *
 *  @param strwzbh 公文字编号
 *  @param intgwlsh 年号
 *  @param intdwlsh 单位流水号
 */
+(void)queryWh:(NSString*)strwzbh strcurnh:(NSString*)strcurnh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


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
+(void)setBwh:(NSString*)intgwlsh intbzjllsh:(NSString*)intbzjllsh intdwlsh:(NSString*)intdwlsh strgwz:(NSString*)strgwz intgwnh:(NSString*)intgwnh intgwqh:(NSString*)intgwqh strusegwz:(NSString*)strusegwz intusewzbh:(NSString*)intusewzbh intusegwnh:(NSString*)intusegwnh intusegwqh:(NSString*)intusegwqh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


/**
 *  指定科室人员
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param intzrrlshlst 责任人流水号
 *  @param strczrxm 操作人名称
 *  @param bolsendsms 是否发送短信（0：不发，1：发送）
 */
+(void)appointPeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

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
+(void)appointDepartment:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;


/**
 *  办结页面显示
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)querybjpage:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)setbjopt:(NSString*)intbzjllsh intgwlzlsh:(NSString*)intgwlzlsh intdwlsh:(NSString*)intdwlsh intrylsh:(NSString*)intrylsh strryxm:(NSString*)strryxm strdwjc:(NSString*)strdwjc stryjnr:(NSString*)stryjnr intgwgdbz:(NSString*)intgwgdbz completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 * 指定接受单位页面显示
 *
 *  @param intbzjllsh 步骤记录流水号
 *  @param intgwlsh 公文流水号
 *  @param intgwlzlsh 公文流转流水号
 *  @param intdwlsh 单位流水号
 */
+(void)setzdswdw:(NSString*)intbzjllsh intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intdwlsh:(NSString*)intdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)fwzdswdw:(NSString*)strjsdwmclst strmjlst:(NSString*)strmjlst strdzc:(NSString*)strdzc intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh intxzrlblst:(NSString*)intxzrlblst strzcsbzlst:(NSString*)strzcsbzlst intfslst:(NSString*)intfslst strzjbzlst:(NSString*)strzjbzlst strfsdwdz:(NSString*)strfsdwdz intfwdwlsh:(NSString*)intfwdwlsh strfsrdwmc:(NSString*)strfsrdwmc intfsrlsh:(NSString*)intfsrlsh strfsrxm:(NSString*)strfsrxm intbzjllsh:(NSString*)intbzjllsh strsmsset:(NSString*)strsmsset strimset:(NSString*)strimset strljfsbz:(NSString*)strljfsbz strisscbz:(NSString*)strisscbz completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  退办显示页面
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)querytbshow:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)gwhtopt:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh stryjnr:(NSString*)stryjnr strczrxm:(NSString*)strczrxm intgwlsh:(NSString*)intgwlsh intgwlzlsh:(NSString*)intgwlzlsh strsmsset:(NSString*)strsmsset completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  查询工作任务领导
 *
 *  @param intlcczlsh 流程操作流水号
 *  @param intdwlsh 部门流水号
 *  @param strlclxbm 流程类型编码
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getWorkTaskPeople:(NSString*)intlcczlsh intdwlsh:(NSString*)intdwlsh strlclxbm:(NSString*)strlclxbm intbzjllsh:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  查询已定义的工作流程名单
 *
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getExistSubFlowPeople:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
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
+(void)subFlowPermit:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intrylshlst:(NSString*)intrylshlst intgzlclshlst:(NSString*)intgzlclshlst strlzlxlst:(NSString*)strlzlxlst intbzlst:(NSString*)intbzlst intlcdylshlst:(NSString*)intlcdylshlst intbcbhlst:(NSString*)intbcbhlst strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  查询工作任务领导
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 */
+(void)subFlowEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  送返发送人
 *
 *  @param intbzjllsh 步骤流水号
 *  @param intczrylsh 操作人流水号
 *  @param intnextgzlclsh 下一个流程流水号
 *  @param strczrxm 操作人名称
 */
+(void)setsfsropt:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  查询分流人员
 *
 *  @param strdwccbm 单位流水号
 *  @param intlcczlsh 流程操作流水号
 *  @param intdwlsh 单位流水号
 *  @param intbzjllsh 步骤记录流水号
 */
+(void)getPartFlowPeople:(NSString*)strdwccbm intlcczlsh:(NSString*)intlcczlsh intdwlsh:(NSString*)intdwlsh intbzjllsh:(NSString*)intbzjllsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

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
+(void)partFlowPermit:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm intlcczlsh:(NSString*)intlcczlsh intrylshlst:(NSString*)intrylshlst intbcbhlst:(NSString*)intbcbhlst intgzlclshlst:(NSString*)intgzlclshlst strlzlxlst:(NSString*)strlzlxlst intgwlzlsh:(NSString*)intgwlzlsh intbzlst:(NSString*)intbzlst intlcdylshlst:(NSString*)intlcdylshlst strnextgzrylx:(NSString*)strnextgzrylx intnextgzrylsh:(NSString*)intnextgzrylsh strzrrlxLst:(NSString*)strzrrlxLst lint:(int)lint completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)appointCS:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)appointUndertakePeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh intzrrlshlst:(NSString*)intzrrlshlst strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)returnUndertakePeople:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strnextzrrmc:(NSString*)strnextzrrmc strczrxm:(NSString*)strczrxm bolsendsms:(NSString*)bolsendsms intgwlzlsh:(NSString*)intgwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  分流成完成
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param intnextgzlclsh  下一个流程流水号
 *  @param strczrxm        操作人名称
 */
+(void)partFlowEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh intnextgzlclsh:(NSString*)intnextgzlclsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  结束办理步骤
 *
 *  @param intbzjllsh      步骤流水号
 *  @param intczrylsh      操作人流水号
 *  @param strczrxm        操作人名称
 */
+(void)transactBzEnd:(NSString*)intbzjllsh intczrylsh:(NSString*)intczrylsh strczrxm:(NSString*)strczrxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
+(void)getArchives:(NSString*)intdwlsh intrylsh:(NSString*)intrylsh strjsid:(NSString*)strjsid intcsdwlsh:(NSString*)intcsdwlsh strgwbt:(NSString*)strgwbt intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  收件箱
 *
 *  @param querytype       查询方式（0:全部查询，1 已读,2 未读）
 *  @param intrylsh        人员流水号
 *  @param intdwlsh        单位流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)getReceiveMailList:(NSString*)querytype intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  邮件信息
 *
 *  @param inttzlsh        通知流水号
 *  @param inttzjslsh      通知接受流水号
 *  @param intrylsh        人员流水号
 */
+(void)getMailInfo:(NSString*)inttzlsh inttzjslsh:(NSString*)inttzjslsh intrylsh:(NSString*)intrylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  邮件回复
 *
 *  @param inttzlsh        通知流水号
 *  @param inttzjslsh      通知接受流水号
 *  @param intrylsh        人员流水号
 */
+(void)reviceMailInfo:(NSDictionary*)dic completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  通知列表
 *
 *  @param strwzyddw       用户当前所在科室、兄弟科室、所属单位流水号串（登录接口）
 *  @param intrylsh        操作人流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)noticeList:(NSString*)strwzyddw intrylsh:(NSString*)intrylsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  通知详情
 *
 *  @param inttzlsh        通知
 *  @param intrylsh        操作人流水号
 *  @param intdwlsh        单位流水号
 *  @param strryxm         人员姓名
 */
+(void)noticeDetails:(NSString*)inttzlsh intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh strryxm:(NSString*)strryxm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  版本升级
 *
 */
+(void)searchNewVersioncompletionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  政务信息
 *
 *  @param intjsdwlsh      单位流水号
 *  @param intCurrentPage  当前页
 *  @param intPageRows     显示条数
 */
+(void)queryGovernList:(NSString*)intjsdwlsh intCurrentPage:(NSInteger)intCurrentPage intPageRows:(NSInteger)intPageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  政务信息详情
 *
 *  @param intxxbslsh      信息流水号
 *  @param intsessionlsh   回话流水号
 */
+(void)queryGovernDetails:(NSString*)intxxbslsh intsessionlsh:(NSString*)intsessionlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  首页提示标识及最新通知
 *
 *  @param strwzyddw       用户当前所在科室、兄弟科室、所属单位流水号串（登录接口）
 *  @param intrylsh        操作人流水号
 *  @param intdwlsh        单位流水号
 *  @param intcsdwlsh      科室流水号
 */
+(void)home:(NSString*)strwzyddw intrylsh:(NSString*)intrylsh intdwlsh:(NSString*)intdwlsh intcsdwlsh:(NSString*)intcsdwlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  意见反馈
 *
 *  @param strfkrmc        当前用户名称
 *  @param strfknr         内容
 *  @param intlx           类型（1:安卓，2：IOS）
 *  @param strbbh          当前版本号
 */
+(void)feedback:(NSString*)strfkrmc strfknr:(NSString*)strfknr intlx:(NSString*)intlx strbbh:(NSString*)strbbh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  要人的时候
 *
 *  @param intdwlsh
 *  @param intnextgzlclsh
 *  @param intgwlzlsh
 *  @param intbzjllsh
 *  @param completionBlock
 */
+(void)getPeople:(NSString*)intdwlsh intnextgzlclsh:(NSString*)intnextgzlclsh intgwlzlsh:(NSString*)intgwlzlsh intbzjllsh:(NSString*)intbzjllsh intlcczlsh:(NSString*)intlcczlsh type:(NSString*)type completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
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
 *  @param completionBlock <#completionBlock description#>
 */
+(void)sendMail:(NSString*)strbzlst intjslshlst:(NSString*)intjslshlst intcsdwlsh:(NSString*)intcsdwlsh strxxjbz:(NSString*)strxxjbz strzw:(NSString*)strzw strcsjc:(NSString*)strcsjc rbtzfs:(NSString*)rbtzfs strryxm:(NSString*)strryxm intrylsh:(NSString*)intrylsh strxmlst:(NSString*)strxmlst intdwlsh:(NSString*)intdwlsh strtzbt:(NSString*)strtzbt strdwjc:(NSString*)strdwjc inttzfs:(NSString*)inttzfs strhhbz:(NSString*)strhhbz isZf:(NSString*)isZf inttzlsh_pre:(NSString*)inttzlsh_pre completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  分流程已经选择人员
 *
 *  @param intgwlzlsh
 *  @param intgzlclsh
 *  @param intnextgzlclsh
 *  @param completionBlock
 */
+(void)getFlowPeople:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh intnextgzlclsh:(NSString*)intnextgzlclsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  同步请求数据
 *
 *  @param url         请求地址
 *  @param paramterdic 请求参数
 *
 *  @return 返回值
 */
+(id)asnetworkgetFlowPeopleintgwlzlsh:(NSString*)intgwlzlsh intgzlclsh:(NSString*)intgzlclsh intbzjllsh:(NSString*)intbzjllsh;
/**
 *  收文转交
 *
 *  @param gwlzlsh         公文流转流水号
 *  @param completionBlock
 */
+(void)getGwhsDw:(NSString*)gwlzlsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  查询单位
 *
 *  @param chrdwccbm       （单位层次编码）（第一层不传）
 *  @param completionBlock
 */
+(void)getDepartmentAndPeople:(NSString*)chrdwccbm completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  查询常用语
 *
 *  @param row             显示条数
 *  @param currentPage     当前页数
 */
+(void)everydayLanguageApi:(NSNumber*)row currentPage:(NSNumber*)currentPage completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  添加常用语
 *
 *  @param strps           常用语
 *  @param completionBlock nil
 */
+(void)addLanguage:(NSString*)strps completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  修改常用语
 *
 *  @param strps           常用数据
 *  @param intpscyylsh     常用ID
 *  @param completionBlock
 */
+(void)updateLanguage:(NSString*)strps intpscyylsh:(NSString*)intpscyylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  删除常用语
 *
 *  @param strps           常用数据
 *  @param intpscyylsh     常用ID
 *  @param completionBlock
 */
+(void)deleteLanguage:(NSString*)strps intpscyylsh:(NSString*)intpscyylsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  统计表
 *
 *  @param intrylsh        当前人员流水号
 *  @param dtmfbsj1     开始时间
 *  @param dtmfbsj2  结束时间
 *  @param strryxm 姓名
 */
+(void)getTjb:(NSString*)intrylsh  strryxm:(NSString*)strryxm dtmfbsj1:(NSString*)dtmfbsj1 dtmfbsj2:(NSString*)dtmfbsj2 intCurrentPage:(NSNumber*)currentPage intPageRows:(NSNumber*)pageRows completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
/**
 *  添加统计表
 strryxm -人员姓名
 strlrryxm --当前登录人
 intlrrylsh  --当前登录人流水号
 dtmrzsj -任职时间
 strdwzw  --单位及职务
 strsjgzqk ---传达上级工作部署情况
 strlslzfwqk ---落实同级党委党风廉政建设和反腐败工作任务情况
 strlzfwjdqk --在分管范围内开展党风廉政建设和反腐败工作监督检查的情况
 stryt --约谈下级党员领导干部情况
 strzdlzqk --指导分管部门制定党风廉政建设防控措施、制度及解决问题的情况
 strlzjwqk  --对党员干部廉政教育的情况
 strqt ---其他
 */
+(void)saveTjb:(NSDictionary*)pramers completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;

/**
 *  统计表详情
 inttjblsh -统计表流水号

 */
+(void)getTjbxx:(NSString*)inttjblsh completionBlock:(void (^)(id rep,NSString *emsg))completionBlock;
@end
