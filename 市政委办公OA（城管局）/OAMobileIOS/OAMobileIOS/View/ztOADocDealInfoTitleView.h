//
//  ztOADocDealInfoTitleView.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-18.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOADocDealInfoTitleView : UIView
@property(nonatomic,strong) UILabel *titleLable;
@property(nonatomic,strong) UIImageView *warnLedImg;
@property(nonatomic,strong) UILabel *warnLable;
@property(nonatomic,strong) UIImageView *lineView;

- (id)initWithFrame:(CGRect)frame withHeight:(float)titleHeight_t withTitleStr:(NSString *)titleStr  withWarnStr:(NSString *)warnStr withWarnImage:(NSString *)warnImgStr infoArray:(NSMutableArray *)infoArray;
@end
