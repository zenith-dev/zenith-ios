//
//  ztOAService.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOAService : NSObject



//+(void)sendFile:(NSDictionary *)sendData fileData:(NSData*)fileData        Success:(SuccessBlock)success failed:(FailedBlock)failed;
/*+++++++++++++++设备绑定+++++++++++++++*/

//申请接入许可
+(void)userDeviceBand:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//取消绑定
+(void)userCancelDeviceBand:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查询绑定状态
+(void)getDeviceBandState:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//登陆
+(void)userLogin:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//人员信息
+(void)userInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取头像
+(void)downloadUserHeadImage:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//上传头像
+(void)updateUserHeadImage:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;


/*+++++++++++++++公文历史库查询+++++++++++++++*/
+(void)getlsgwList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++个人公文+++++++++++++++*/
//获取待办公文列表
+(void)getGrGwcxList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++公文+++++++++++++++*/
//获取待办公文数量
+(void)getOfficeDocNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取待办公文列表
+(void)getOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//公文查询列表
+(void)searchOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取公文基本信息及流转信息
+(void)getOfficeDocDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取公文基本信息及流转处理信息
+(void)getOfficeDocLzclInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//公文收藏
+(void)setGwgrscfj:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//公文取消收藏
+(void)delGwgrscfj:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;


//获取公文附件内容
+(void)getDocAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//提交公文流转
+(void)saveOfficeDocFlowInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//分流程人员选择
+(void)getFlclzdxxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//指定内部人员下载 、指定传阅功能、指定公文查询方式
+(void)getZdcydxxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//个人公文查询
+(void)searchPersonalOfficeDocList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取公文基本信息及流转处理信息
+(void)getOfficeDocDealInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//改稿上传正文搞
+(void)upLoadDocAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查询组织机构人员信息
+(void)getCompanyPersonList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查询人员组信息
+(void)getPersonGroupList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查询人员组人员信息
+(void)getPersonList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//获取常用语接口
+(void)getPersonCyyList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++公告++++++++++++++*/
 //公告查询列表
+(void)searchNoticeList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//公告未读条数
+(void)getggNum:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
 //获取公告信息内容
+(void)getNoticeDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
 
//公告信息内容(内容有图片不返回)
+(void)getNoticeWithoutPicDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++通知+++++++++++++++*/
//通知数量
+(void)getInformNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//通知列表查询
+(void)getInformList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//通知信息内容
+(void)getInformDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//通知附件
+(void)getInformAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++邮件+++++++++++++++*/
//邮件数量
+(void)getEmailNumber:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//内部邮件收件箱查询
+(void)getReceiveEmailList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//内部邮件发件箱查询
+(void)getSendEmailList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//发送邮件
+(void)sendEmail:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//上传邮件附件
+(void)sendEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//转发更新附件
+(void)sendForwardEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查询邮件详情
+(void)getEmailDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//邮件附件
+(void)getEmailAttachmentsInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//查看收件情况
+(void)fadeEmailReceiveStatusInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//更新内部邮件查看标志
+(void)updateEmailLookingFlag:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//删除临时附件
+(void)deleteEmailAttachments:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//根据附件流水号删除邮件附件
+(void)deleteEmailAttachmentsBylsh:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//根据流水号删除邮件(删除邮件)
+(void)deleteEmailsBylsh:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++刊物+++++++++++++++*/
//刊物目录
+(void)getPublicationDirectory:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//刊物详情
+(void)getPublicDetailDirectory:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//刊物目录列表查询
+(void)searchPublicationDirectoryList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//刊物下载
+(void)loadPublication:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++联系人+++++++++++++++*/
//联系人列表
+(void)getContactsList:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
+(void)getDwTxlLxrListNoContionByzipNew:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//联系人详细信息
+(void)getContactsDetailInfo:(NSDictionary *)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++每周日程+++++++++++++++*/
//日程信息接口
+(void)getRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//每周日程（新增）接口
+(void)addRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//每周日程（删除）接口
+(void)deleteRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//每周日程（修改）接口
+(void)updateRcxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++会议模块+++++++++++++++*/
//会议列表
+(void)getHyList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
+(void)getdetailList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++领导讲话模块+++++++++++++++*/
//领导讲话列表
+(void)getWzglList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//获取领导讲话信息内容
+(void)getWzglxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//**获取领导分类列表*/
+(void)getrysyflbyrylshlst:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++政务信息模块+++++++++++++++*/
//政务信息列表
+(void)getZxZwxx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//获取政务信息内容
+(void)getZxzwxxxq:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//*政务信息收藏*/
+(void)setxxgrscfj:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
//*政务信息收藏取消*/
+(void)delxxgrscfj:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/*+++++++++++++++业务指导模块+++++++++++++++*/
/**业务指导处室列表*/
+(void)getYwzdCs:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/**业务指导处室功能模块*/
+(void)getYwzdGn:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/**业务指导处室功能模块文档列表*/
+(void)getYwzdGnWd:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/**业务指导详情页面*/
+(void)getBmzlXx:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;

/*+++++++++++++++收藏模块+++++++++++++++*/
/**政务信息收藏列表*/
+(void)getxxscjList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;
/**公文收藏列表*/
+(void)getgwscjList:(NSDictionary*)sendData Success:(SuccessBlock)success Failed:(FailedBlock)failed;


@end
