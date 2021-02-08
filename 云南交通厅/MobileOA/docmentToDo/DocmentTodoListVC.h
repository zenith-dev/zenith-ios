//
//  DocmentTodoListVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface DocmentTodoListVC : BaseViewController
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic,strong)NSString *type;//016 待办公文
@property (nonatomic,strong) NSString *searchBarStr;//搜索字符串
@end
