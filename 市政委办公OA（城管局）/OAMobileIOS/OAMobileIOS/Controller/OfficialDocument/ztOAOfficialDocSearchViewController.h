//
//  ztOAOfficialDocSearchViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
@interface ztOAOfficialDocSearchViewController : ztOABaseViewController<UITextFieldDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
@property (nonatomic,assign)int i_type;//0 公文查询 1历史库查询

@end
