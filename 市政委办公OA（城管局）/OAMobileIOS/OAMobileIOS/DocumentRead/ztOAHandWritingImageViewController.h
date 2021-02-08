//
//  ztOAHandWritingImageViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import <CoreText/CoreText.h>
#import <MessageUI/MessageUI.h>
@interface ztOAHandWritingImageViewController : ztOABaseViewController<UIGestureRecognizerDelegate,UIPrintInteractionControllerDelegate,UIWebViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate>
- (id)initWithType:(NSString *)typeStr withOldImg:(UIImage *)image;
@end
