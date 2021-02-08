//
//  LBUnitChooseViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 16/4/22.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"

@interface LBUnitChooseViewController : LBBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *unitTb;
@property (strong,nonatomic)  NSString *chrdwccbm;
@property (strong,nonatomic)NSMutableArray *selcetAry;//选择人员
@end
