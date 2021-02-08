//
//  LBChoosePersonViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/20.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"
@protocol ChooseLxPersonDelegate <NSObject>
-(void) setZrrValue:(NSMutableArray *) value andid:(id)lbs andGupID:(NSString *) gupid;//需要得到对象数组,对象,任务名称,和显示在某个Label上
@end
@interface LBChoosePersonViewController : LBBaseViewController
@property(nonatomic,strong)NSMutableArray *qcheckary;//选择的;
@property(nonatomic,assign) id lbs;
@property(nonatomic,strong)NSString *type;//选择类型(单位 还是人员信息)
@property(nonatomic,strong)NSString *gupid;
@property(nonatomic,assign)BOOL singordouble;//单选多选
@property (nonatomic,assign)id<ChooseLxPersonDelegate>   delegate;//记住这里是assign哦
@end
