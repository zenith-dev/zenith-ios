//
//  DocDealVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"
#import "DocToDoModel.h"
@interface DocDealVC : BaseViewController
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)NSString *gwlx;//公文类型type  1 收文 0发文
@property (nonatomic,strong)NSString *intbzjllsh;
@property (nonatomic,strong)DocToDoModel *doctodoModel;
@end
