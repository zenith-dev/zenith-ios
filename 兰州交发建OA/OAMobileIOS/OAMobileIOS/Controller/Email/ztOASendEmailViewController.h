//
//  ztOASendEmailViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-24.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOATreeTableViewController.h"
#import "ztOASendEmailFjDetailView.h"
#import "ztOAFjDetailCell.h"
#import "ztOANewDocTableViewController.h"
#import "ztOAWQPlaySound.h"
#import "CXAlertView.h"
#import "ztOAPhotoViewController.h"
#import "ztOANewDocTableViewCell.h"
@interface ztOASendEmailViewController : ztOABaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>
- (id)initWithTitle:(NSString *)titleStr withDic:(NSDictionary *)dic;
@end
