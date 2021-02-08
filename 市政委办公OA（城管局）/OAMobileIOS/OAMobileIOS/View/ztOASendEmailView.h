//
//  ztOASendEmailView.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-24.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ztOASendEmailView : UIView
//收件人
@property(nonatomic,strong)UILabel      *pepoleLabel;
@property(nonatomic,strong)UILabel      *pepoleInfoLabel;
@property(nonatomic,strong)UIButton     *addPepoleBtn;
//标题
@property(nonatomic,strong)UILabel      *titleLabel;
@property(nonatomic,strong)UITextField  *titleInfoField;
//内容
@property(nonatomic,strong)UILabel      *contextLabel;
@property(nonatomic,strong)UITextView   *contextInfoView;

@end
