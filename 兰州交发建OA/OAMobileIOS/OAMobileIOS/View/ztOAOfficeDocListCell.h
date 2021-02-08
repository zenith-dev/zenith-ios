//
//  ztOAOfficeDocListCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-1-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAOfficeDocListCell : UITableViewCell
@property(nonatomic, strong) UIImageView    *iconImg;//状态图标
@property(nonatomic, strong) UILabel        *docName;//公文标题
@property(nonatomic, strong) UILabel        *detailInfo;//发送人姓名和任务名称
@property(nonatomic, strong) UILabel        *docSendTime;//公文发送时间
@property(nonatomic, strong) UILabel         *line;
@property(nonatomic, strong) NSString *i_type;
@property(nonatomic, strong) NSDictionary    *modedic;

@end
