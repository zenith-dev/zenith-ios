//
//  ztOAProcessDetailListCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-27.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAProcessDetailListCell : UITableViewCell
@property(nonatomic, strong) UIImageView    *blueLineImg;//蓝色束线
@property(nonatomic, strong) UIImageView    *pointImg;//节点
@property(nonatomic, strong) UILabel        *strgzrwmc;//工作任务
@property(nonatomic, strong) UILabel        *dtmfssj;//发送时间
@property(nonatomic, strong) UILabel        *dtmbjsj;//处理时间
@property(nonatomic, strong) UILabel        *strczrxm;//处理人姓名
@property(nonatomic, strong) UILabel        *strfsrxm;//录入人姓名
@property(nonatomic, strong) UILabel        *stryjnr;//处理意见
@property(nonatomic, strong) UIButton       *openOrCloseBtn;//展开收起按钮
@property(nonatomic, strong) UIImageView    *breakLine;//切割线

@property(nonatomic, strong) UILabel        *blueSendLable;//蓝色录入图标
@property(nonatomic, strong) UILabel        *blueDoneLable;//蓝色处理图标

@property(nonatomic, strong) UILabel        *sendInfoLabel;//发送数据
@property(nonatomic, strong) UILabel        *opinionLabel;//处理意见
@property(nonatomic, strong) UILabel        *dealInfoLabel;//处理数据
@property(nonatomic, strong) UILabel        *sendTimeLabel;//处理时间
@property(nonatomic, strong) UILabel      *zrzlb;
@end
