//
//  LBAgentsDetailViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/11.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"

@interface LBAgentsDetailViewController : LBBaseViewController

@property(nonatomic,strong)NSDictionary *detaildic;//公文详情
@property(nonatomic,strong)NSArray *optionary;//公文详情
@property(nonatomic,strong)NSDictionary *lstdic;
@property(nonatomic,strong)NSString *intbzjllsh;
@property(nonatomic,assign)BOOL isshow;
@property(nonatomic,strong)UINavigationController *nav;
-(void)getSwBumphInfo;
@end
