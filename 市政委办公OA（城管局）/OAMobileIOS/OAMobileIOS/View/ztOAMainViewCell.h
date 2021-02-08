//
//  ztOAMainViewCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ztOAMainViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView    *iconView;//图标
@property(nonatomic, strong) UILabel        *nameLab;//标题
@property(nonatomic, strong) UILabel        *detailLab;//小标题
@property(nonatomic, strong) UILabel        *noReadCount;//未读数

@end
