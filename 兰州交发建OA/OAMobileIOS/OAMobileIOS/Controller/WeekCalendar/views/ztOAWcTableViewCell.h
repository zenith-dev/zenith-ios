//
//  ztOAWcTableViewCell.h
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAWcTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *weeklb;//周几
@property(nonatomic,strong)UILabel *rqlb;//日期
@property(nonatomic,strong)UIButton *addrcBtn;//添加日程
@property(nonatomic,strong)NSMutableArray *dataary;//获取日程信息
@property(nonatomic,strong)UIImageView *icon_arrowview;//是否展开
@property(nonatomic,strong)NSDictionary *weekdic;
@property(nonatomic,strong)UILabel *onelinelb;//线条
@end
