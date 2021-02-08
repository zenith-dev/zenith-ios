//
//  DealFjVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealFjVC : UIView
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic,assign)int type;//2通知 3公告附件 4历史库附件 5刊物 8文档
@property (nonatomic,strong)UIViewController *controller;//控制器
@property (nonatomic,strong)NSString *intgwlzlsh;
@property (nonatomic,strong)UITableView *fjtb;
@property (nonatomic,strong)NSMutableArray *fjary;//附件数组
@property (nonatomic,assign)BOOL ctrone;//控制是否有改稿
- (id)initWithFrame:(CGRect)frame fjAry:(NSMutableArray*)ary type1:(int)type1 controller:(UIViewController*)contro;
//上传附件
-(BOOL)updateGwfj:(NSData*)fileData;

@end
