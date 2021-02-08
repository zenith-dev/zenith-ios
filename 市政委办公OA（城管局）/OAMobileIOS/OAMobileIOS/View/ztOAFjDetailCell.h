//
//  ztOAFjDetailCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-31.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOAFjDetailCell : UITableViewCell
@property(nonatomic,strong)UIImageView  *fileSimpleImg;//文件缩略图
@property(nonatomic,strong)UILabel      *fileNameLable;//文件名称
@property(nonatomic,strong)UIButton     *fileDeleteBtn;//删除按钮
@end
