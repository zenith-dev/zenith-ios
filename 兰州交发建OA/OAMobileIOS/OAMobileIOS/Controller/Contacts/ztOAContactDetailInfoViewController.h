//
//  ztOAContactDetailInfoViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-7.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOADetailContactInfoCell.h"
@interface ztOAContactDetailInfoViewController : ztOABaseViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *dicDate;//详情信息数据

- (id)initWithData:(NSDictionary *)dic isLocalPhotoInfo:(NSString *)isLocalPhotoInfo;
@end
