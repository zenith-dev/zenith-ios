//
//  ztOANoticeDetialViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOAFjSimpelCell.h"
#import "ztOANewMainViewController.h"
@interface ztOANoticeDetialViewController : ztOABaseViewController<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,FilePluginDelegate>
- (id)initWithType:(NSString *)whichType Data:(NSDictionary *)initData;
@end
