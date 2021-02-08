//
//  ztOAPublicatiinDetailInfoViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOADetailContactInfoCell.h"
@interface ztOAPublicatiinDetailInfoViewController : ztOABaseViewController<UITableViewDelegate,UITableViewDataSource>
- (id)initWithData:(NSDictionary *)dicData;
@end
