//
//  ztOAContactsListCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAContactsListCell : UITableViewCell
@property(nonatomic,strong)UIImageView  *backImg;//
@property(nonatomic,strong)UIButton     *selecteBtn;//选中框
@property(nonatomic,strong)UIButton     *contactName;//联系人姓名
@property(nonatomic,strong)UIButton     *contactPhoneNum;//联系电话
@end
