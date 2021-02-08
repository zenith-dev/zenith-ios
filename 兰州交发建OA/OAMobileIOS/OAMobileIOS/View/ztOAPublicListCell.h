//
//  ztOAPublicListCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-26.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAPublicListCell : UITableViewCell
@property(nonatomic, strong) UIImageView    *iconImg;//图标
@property(nonatomic, strong) UILabel        *name;//刊物目录名称
@property(nonatomic, strong) UILabel        *publicDate;//发布日期
@property(nonatomic, strong) UILabel        *detailInfo;//详情

@end
