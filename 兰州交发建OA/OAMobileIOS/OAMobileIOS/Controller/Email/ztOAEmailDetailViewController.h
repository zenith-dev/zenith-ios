//
//  ztOAEmailDetailViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ztOAFjSimpelCell.h"
@interface ztOAEmailDetailViewController : ztOABaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FilePluginDelegate>
- (id)initWithDataDic:(NSDictionary *)dic withTitle:(NSString *)titleString withBaseInfoDic:(NSDictionary *)baseInfoDic;
@end
