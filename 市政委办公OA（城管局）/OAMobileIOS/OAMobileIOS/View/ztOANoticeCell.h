//
//  ztOANoticeCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-11.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOANoticeCell : UITableViewCell

@property(nonatomic, strong) UIImageView    *iconImg;//状态图标
@property(nonatomic, strong) UIImageView    *zhidingIconImg;//置顶图标
@property(nonatomic, strong) UIImageView    *theNewIconImg;//new图标
@property(nonatomic, strong) UILabel        *noticeName;//名称
@property(nonatomic, strong) UIImageView    *readImg;//访问图标
@property(nonatomic, strong) UILabel        *readCount;//访问量
@property(nonatomic, strong) UILabel        *noticeTime;//时间

@property(nonatomic, strong) UILabel        *detailInfo;//信息栏
@end
