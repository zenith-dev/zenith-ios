//
//  ztOAPDFShowViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "NDHTMLtoPDF.h"
#import "ReaderViewController.h"
@interface ztOAPDFShowViewController : ztOABaseViewController<NDHTMLtoPDFDelegate,UIWebViewDelegate,ReaderViewControllerDelegate>

@end
