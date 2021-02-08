//
//  ztOAPublicationSearchResultViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOAPublicListCell.h"
#import "MJRefresh.h"
#import "NIDropDown.h"
#import "ztOASimpleInfoListViewController.h"
#import "ztOANoticeDetialViewController.h"
@interface ztOAPublicationSearchResultViewController : ztOABaseViewController<UITableViewDataSource,UITableViewDelegate,FilePluginDelegate,UIScrollViewDelegate>

@end
