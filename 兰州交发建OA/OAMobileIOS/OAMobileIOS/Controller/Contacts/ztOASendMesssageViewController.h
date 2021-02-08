//
//  ztOASendMesssageViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-7.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MFMessageComposeViewController.h>
@interface ztOASendMesssageViewController : ztOABaseViewController<MFMessageComposeViewControllerDelegate,UITextViewDelegate>

-(id)initWithData:(NSMutableArray *)dataArray;
@end
