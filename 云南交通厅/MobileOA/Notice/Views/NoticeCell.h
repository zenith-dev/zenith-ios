//
//  NoticeCell.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/28.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
#import "TzModel.h"
@interface NoticeCell : UITableViewCell
@property (nonatomic,strong)NoticeModel *noticeModel;
@property (nonatomic,strong)TzModel *ztModel;
@end
