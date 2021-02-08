//
//  ztOANewDocTableViewController.h
//  OAMobileIOS
//
//  Created by ran chen on 14-5-14.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOABaseViewController.h"

@interface ztOANewDocTableViewController : ztOABaseViewController<UITableViewDataSource, UITableViewDelegate>

- (id)initWithTitleName:(NSString *)titleName data:(id)initData strcxlx:(NSString *)strcxlx multiSelectFlag:(NSString *)multiSelectFlag withCompanylsh:(NSString *)initCompanylsh isMail:(BOOL)isMail;

@end
