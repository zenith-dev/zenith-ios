//
//  ZtOAFlowPersonVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/9.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface MultFlowPersonVC : BaseViewController
@property (nonatomic,strong)NSDictionary *processOpr;
@property (nonatomic,strong)NSMutableArray *selectary;
@property (nonatomic,strong)NSString *intgzlclsh;
@property (nonatomic, copy) void (^callback)(NSMutableArray * selectAry,NSMutableDictionary *storeDict);
@property (nonatomic,strong)NSMutableDictionary *storeDict;//组织机构保存字典
-(id)init:(NSString*)title selectAry:(NSMutableArray*)selectAry storeDict:(NSMutableDictionary*)storeDict;
- (void)selectedPersonCallback:(void (^)(NSMutableArray * selectAry,NSMutableDictionary *storeDict))callback;
@end
