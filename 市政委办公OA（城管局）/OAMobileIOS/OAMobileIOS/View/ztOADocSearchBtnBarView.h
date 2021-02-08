//
//  ztOADocSearchBtnBarView.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-12.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOADocSearchBtnBarView : UIView
@property(nonatomic,strong)UILabel      *typeLabel;
@property(nonatomic,strong)UIButton     *typeSearchBtn;//根据类型查询
@property(nonatomic,strong)UILabel      *yearLabel;
@property(nonatomic,strong)UIButton     *yearSearchBtn;//根据年号查询
@property(nonatomic,strong)UILabel      *filterLabel;
@property(nonatomic,strong)UIButton     *filterSearchBtn;//筛选查询
@end
