//
//  VSGService.h
//  VSGVPNSDK
//
//  Created by Gavin on 16/1/15.
//  Copyright © 2016年 com.leadsec. All rights reserved.
//  SDK 版本 1.1.3.5 20170811

#import <Foundation/Foundation.h>

#import "VSGDefine.h"


@class VSGService;

@protocol VSGServiceDelegate <NSObject>

@required
/**
 *  认证完成或者认证到某一阶段的回调函数
 *
 *  @param service  VSGService对象
 *  @param result   认证结果
 */
- (void)VSGService:(VSGService*)service authResult:(VSGAuthResult)result param:(NSDictionary*)param;
@optional
/**
 *  注销回调
 *
 *  @param service VSGService对象
 *  @param result  注销结果值, 值为VSGAUTH_SUCCESS代表注销成功
 */
- (void)VSGService:(VSGService*)service logoutResult:(VSGAuthResult)result;

/**
 *  service事件回调
 *
 *  @param service VSGService对象
 *  @param type    回调事件类型，暂时只有建立隧道失败的事件
 *  @param param   回调参数
 */
- (void)VSGService:(VSGService*)service callBackEventType:(VSGServiceCallBackType)type param:(id)param;

/**
 * 第一次添加VPN配置出错的时候会调用，客户端应该实现此方法
 *
 *  @param service VSGService对象
 *  @param errorMsg 出错描述
 */
- (void)VSGService:(VSGService*)service saveNCConfigerationFailed:(NSString*)errorMsg1;

@end




@interface VSGService : NSObject

@property (nonatomic, readonly) NSString *vpnAddress;
@property (nonatomic, readonly) NSInteger vpnPort;
@property (nonatomic, readonly) NSString *dns;

/**
 *  回调代理
 */
@property (weak) id <VSGServiceDelegate>  delegate;


/**
 *  初始化方法
 *
 *  @param address  VPN地址
 *  @param port     VPN端口
 *  @param delegate 代理
 *
 *  @return     instancetype
 */
- (instancetype)initWithAddress:(NSString *)address port:(NSInteger)port delegate:(id <VSGServiceDelegate>)delegate;

/**
 *  CS模式多个app共享认证的初始化接口，用户应该使用并且只能使用此接口作为初始化入口
 *
 *  @param groupID app groups 组的ID
 *  @param delegate 代理
 *
 *  @return     instancetype
 */
- (instancetype)initWithCheckAuthStateGroupID:(NSString*)groupID delegate:(id <VSGServiceDelegate>)delegate;

/**
 *  设置认证参数
 *
 *  @param paramValue 参数value值
 *  @param paramKey   参数key值
 */
- (void)authWithParam:(id)paramValue paramKey:(NSString *)paramKey;

/**
 *  开始认证
 *
 *  @param type 枚举值，需要传入指定是CS资源还是远程应用资源
 */
- (void)startAuthWithResourceType:(VSGResourceType)type;

/**
 * 获取VPN状态
 * CS模式下暂时只有三种状态，默认 断开 连接, 初始化之后为默认状态，认证成功即认为是连接状态，注销之后就是断开状态
 * NC模式暂时不支持，待补充:
 * 如果是使用的NC模式的VPN，因为NC的VPN是系统级的VPN，进程被杀掉也不会影响其连通性，因此进程启动之初就应该KVO监控本接口获取VPN的连接状态
 * @return 状态码
 */
@property (assign, readonly) VSGVPNStatus status;


/**
 * 删除NC的VPN配置，这个接口只给NC模式使用，NC的SDK是全局的VPN，这个配置一台机器只有一个就可以了，
 * 一旦这个配置必须修改,修改配置之前要先把旧的删除掉，就要先调用这个接口做下清理工作
 */
- (void)deleteTheNCConfigeration;

/**
 *  获取SDK版本
 *
 *  @return 版本号
 */
- (NSString *)vsgSDKVersion;

/**
 *  注销VPN
 */
- (void)logout;

/**
 *  获取保护资源信息，在登录成功后才能调用
 *
 *  @return 一个数组，内容都是字典，每个字典对应一个保护资源
 */
- (NSArray*)getResources;

///////////////////////////////// 以下接口作用不大，可以不关注 ////////////////////////////////////
/**
 *  查看日志并可以通过邮件发送日志，只需要在按钮点击事件中调用此方法即可。
 */
+ (void)feedbackLogsByMail;

/**
 *  开启web网页可查看日志，开启之后只要将电脑和手机连接入同一网段，就可以通过电脑浏览器输入 http://手机ip:8080 查看日志，但是过程稍耗性能，不建议一直开启，应该做成按钮，需要的时候开启，不需要的时候关闭
 */
+ (void)viewLogsByWebService;

/**
 *  关闭web查看日志
 */
+ (void)closeViewLogsByWebService;


/**
 *  打开通过浏览器传输文件接口，在同一网断的PC上的浏览器中输入 http://手机ip 即可自由传输文件
 *
 */
- (void)startUploadFileWithWebBrower;

/**
 *  关闭传输文件接口，用完了应该马上关闭，因为比较耗性能
 *
 */
- (void)stopUploadFileWithWebBrower;



@end
