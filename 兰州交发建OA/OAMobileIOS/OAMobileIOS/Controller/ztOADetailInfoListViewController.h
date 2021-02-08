//
//  ztOADetailInfoListViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOAOfficeDocListCell.h"
#import "ztOANoticeCell.h"
#import "MJRefresh.h"
@interface ztOADetailInfoListViewController : ztOABaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)NSMutableDictionary *searchDic;
- (id)initWithType:(NSString *)whichType withTitle:(NSString *)title queryTerm:(NSString *)queryTermXML;
@end
