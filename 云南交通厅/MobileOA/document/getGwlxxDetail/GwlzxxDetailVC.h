//
//  GwlzxxDetailVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/2.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"
#import "DocMentModel.h"
#import "DocToDoModel.h"
#import "SdmkModel.h"
@interface GwlzxxDetailVC : BaseViewController
@property (nonatomic,strong)NSString *type;//签报件查询:010 信访查询：012 电话单处理:013 便函查询:011  014 收文 015 历史库查询 016 发文
@property (nonatomic,strong)NSString *ngrqstr;
@property (nonatomic,strong)NSString *gwlx;//公文类型type  1 收文 0发文
@property (nonatomic,strong)NSString *intgwlzlsh;
@property (nonatomic,strong)NSString *intgwlsh;
@property (nonatomic,strong)DocToDoModel *doctodomodel;
@property (nonatomic,strong)SdmkModel *sdmkmodel;
@property (nonatomic,strong)DocMentModel *docmentModel;//历史库获取详情用
@property (nonatomic,strong)NSString *intlxid;//督办件类型ID
@property (nonatomic,copy)NSString *strblgcbz;//督办类型
@end
