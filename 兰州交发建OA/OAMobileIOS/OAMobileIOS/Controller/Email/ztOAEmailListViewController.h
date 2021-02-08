//
//  ztOAEmailListViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-19.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOAEmailListCell.h"
#import "MJRefresh.h"
#import "ztOASendEmailViewController.h"
#import "ztOAEmailDetailViewController.h"
@interface ztOAEmailListViewController : ztOABaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

- (id)initWithTitle:(NSString *)title;

@end
