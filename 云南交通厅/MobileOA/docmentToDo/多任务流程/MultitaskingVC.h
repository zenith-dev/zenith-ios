//
//  MultitaskingVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 17/2/10.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface MultitaskingVC : BaseViewController
@property (nonatomic, copy) void (^callback)(NSMutableArray * multRwselectRylst,NSDictionary *responsibleManDic);
@property (nonatomic,strong) NSDictionary *responsibleManDic;
@property (nonatomic,strong) NSMutableArray *multRwselectRylst;
@property (nonatomic,strong)NSDictionary *processOpr;
@property (nonatomic,strong) NSMutableArray *gzrwlst;
@property (nonatomic,strong) NSString *intlcczlsh;//流程操作流水号
@end
