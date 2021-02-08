//
//  ztOAZdcyVC.h
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOABaseViewController.h"

@interface ztOAZdcyVC : ztOABaseViewController
@property (nonatomic,strong)NSDictionary *processOpr;
@property (nonatomic,strong)NSMutableArray *selectary;

@property (nonatomic, copy) void (^callback)(NSMutableArray * selectAry,NSMutableDictionary *storeDict);
@property (nonatomic,strong)NSMutableDictionary *storeDict;//组织机构保存字典
-(id)init:(NSString*)title selectAry:(NSMutableArray*)selectAry storeDict:(NSMutableDictionary*)storeDict;
- (void)selectedPersonCallback:(void (^)(NSMutableArray * selectAry,NSMutableDictionary *storeDict))callback;
@property (nonatomic,strong) NSString *currentCompanylsh;//单位流水号
@end
