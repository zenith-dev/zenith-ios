//
//  QueryChatxqVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/7.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface QueryChatxqVC : BaseViewController
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)NSString *intjsrlsh;//接收人流水号
@property (nonatomic,strong)NSString *jsrxm;//接受人姓名
@property (nonatomic,strong)NSString *intfsrlsh;//发送人流水号
@property (nonatomic,strong)NSString *fsrxm;//发送人姓名
@end
