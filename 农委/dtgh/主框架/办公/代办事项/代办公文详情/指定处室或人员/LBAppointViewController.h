//
//  LBAppointViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/24.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"
#import "LBAgentsDetailViewController.h"
@interface LBAppointViewController : LBBaseViewController
@property(nonatomic,assign)int  lcint;//0:处室 1:人员
@property(nonatomic,strong)NSDictionary *savedic;
@property(nonatomic,strong)LBAgentsDetailViewController *detailContorller;
@end
