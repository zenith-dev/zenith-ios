//
//  QueryChatXqCell.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/7.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QcXqModel.h"
@interface QueryChatXqCell : UITableViewCell
@property (nonatomic,strong)QcXqModel *qcxqModel;
@property (nonatomic,strong)NSString *fristTime;//一次时间
@property (nonatomic,strong) NSString *tempTime;
@end
