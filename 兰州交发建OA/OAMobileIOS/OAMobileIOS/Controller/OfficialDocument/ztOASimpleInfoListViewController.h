//
//  ztOASimpleInfoListViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-12.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
@interface ztOASimpleInfoListViewController : ztOABaseViewController<UITableViewDataSource,UITableViewDelegate>
//i_type;//1，处理意见；2，下步任务；3下步处理人;4所属刊物列表；5刊物年号;6公文类型
-(id)initWithTitle:(NSString *)titleString listArray:(NSMutableArray *)listArray whichType:(NSString *)whitchType;

@end
