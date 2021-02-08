//
//  PersonCenterVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/14.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonCenterVC : BaseViewController
@property (nonatomic, copy) void (^callback)(BOOL issu);
@property (nonatomic, copy) void (^callbackGG)(BOOL issu);
@property (nonatomic, copy) void (^callbackGW)(BOOL issu);
@end
