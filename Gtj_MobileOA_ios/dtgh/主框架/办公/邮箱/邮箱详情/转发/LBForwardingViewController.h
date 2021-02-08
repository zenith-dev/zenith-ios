//
//  LBForwardingViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 16/3/29.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"

@interface LBForwardingViewController : LBBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *forwardScr;
@property (nonatomic,strong)NSDictionary *msgboxdic;
@property (nonatomic,strong)NSString*inttzlsh_pre;//通知流水号
@property (nonatomic,strong)NSMutableArray *selectryary;//选择人员
@end
