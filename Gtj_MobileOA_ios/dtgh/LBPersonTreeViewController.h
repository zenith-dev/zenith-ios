//
//  LBShuntViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/28.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"
#import "LBPersonModel.h"

@class LBPersonTreeViewController;
@protocol LBPersonTreeViewControllerDelegate <NSObject>

-(void)personTreeViewController:(LBPersonTreeViewController *)Vc didClickedButtonWithPerson:(LBPersonModel *)person;

@end
@interface LBPersonTreeViewController : LBBaseViewController
@property(nonatomic,assign)int lint;
@property (nonatomic,assign)int bzlcint;
@property(nonatomic,strong)NSMutableDictionary *savedic;
//代理属性
@property(nonatomic,assign) id<LBPersonTreeViewControllerDelegate> delegate;
@end



