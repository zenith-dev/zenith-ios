//
//  ztOAOfficialDocSendAndReceiveViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOAUnderLinedButton.h"
#import "ztOAUnderLineLabel.h"
#import "ztOAResponsibleManInfoModel.h"
#import "ztOAProcessDetailListCell.h"
#import "ztOATreeTableViewController.h"
#import "ztOASimpleInfoListViewController.h"
#import "ztOADocDealInfoTitleView.h"
#import "ztOANewDocTableViewController.h"
#import "ztOAHttpRequest.h"
#import "NDHTMLtoPDF.h"
#import "ReaderViewController.h"
#import "ztOALeaderOpinionsView.h"
#import <AudioToolbox/AudioToolbox.h>
@interface ztOAOfficialDocSendAndReceiveViewController : ztOABaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,ZMOFjDelegate,UIWebViewDelegate,ReaderViewControllerDelegate>

//isOnSearch:yes公文查询,no公文处理
- (id)initWithData:(NSDictionary *)intDataDic isOnSearch:(BOOL)isOnSearch;
@end
