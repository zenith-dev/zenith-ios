//
//  ztOAPreviewViewController.h
//  OAMobileIOS
//
//  当系统版本>=7.0时，采用此方案显示预览文件
//
//  Created by ran chen on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOABaseViewController.h"
#import <QuickLook/QuickLook.h>

@interface ztOAPreviewViewController : ztOABaseViewController<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
- (id)initWithURL:(NSString *)aURL andFileName:(NSString *)aFileName;
@end
