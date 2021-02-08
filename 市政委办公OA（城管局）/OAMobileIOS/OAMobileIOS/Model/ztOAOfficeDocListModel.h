//
//  ztOAOfficeDocListModel.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-1-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOAOfficeDocListModel : NSObject
@property(nonatomic,strong)NSString *intgwlsh;//公文流水号
@property(nonatomic,strong)NSString *intgwlzlsh;//公文流转流水号
@property(nonatomic,strong)NSString *intbzjllsh;//流转步骤流水号

@property(nonatomic,strong)NSString *chrgwbt;//公文标题
@property(nonatomic,strong)NSString *chrgwz;//公文字
@property(nonatomic,strong)NSString *intgwnh;//公文年号
@property(nonatomic,strong)NSString *chrlzlx;//公文类型

@property(nonatomic,strong)NSString *chrgzrwmc;//工作任务
@property(nonatomic,strong)NSString *chrdjrcsmc;//起草部门
@property(nonatomic,strong)NSString *chrfwdwmc;//发文机关
@property(nonatomic,strong)NSString *chrlwdwmc;//来文单位

@property(nonatomic,strong)NSString *chrmj;//秘密等级
@property(nonatomic,strong)NSString *chrhjcd;//紧急程度
@property(nonatomic,strong)NSString *dtmblsx;//办理时限
@property(nonatomic,strong)NSString *dtmfssj;//发送时间

@property(nonatomic,strong)NSString *chrckbz;//查看标志<!---0：未查看;1:已查看-->
@property(nonatomic,strong)NSString *intcstsblsx;//<!---大于0代表超期-->

@property(nonatomic,strong)NSString *intgwqh;//ps：未知数据

@end
