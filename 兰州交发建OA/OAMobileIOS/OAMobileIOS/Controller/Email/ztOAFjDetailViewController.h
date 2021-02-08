//
//  ztOAFjDetailViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-31.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOABigImgViewController.h"
@interface ztOAFjDetailViewController : ztOABaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

- (id)initWithFjArray:(NSMutableArray *)fjarray;
@end
