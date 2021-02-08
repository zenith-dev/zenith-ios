//
//  NoticeVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/28.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"
@interface NoticeGGVC : BaseViewController
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic,assign)int type;//type 1 公告 2通知
@end
