//
//  PlanModel.h
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject
@property (nonatomic,strong)NSString *fllx;
@property (nonatomic,strong)NSString *strmlccbm;
@property (nonatomic,strong)NSString *strmlmc;
@property (assign,nonatomic)BOOL isOpen;//是否展开
@property (nonatomic,strong)NSMutableArray *childlst;//子节点
@property (assign,nonatomic)int nodeint;//当前节点
@property (nonatomic,strong)NSString *intmllx;
@property (nonatomic,strong)NSString *intwdmllsh;
@end
