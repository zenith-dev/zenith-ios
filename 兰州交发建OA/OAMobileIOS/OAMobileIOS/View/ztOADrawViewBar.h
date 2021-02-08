//
//  ztOADrawViewBar.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOADrawViewBar : UIView
@property(nonatomic,strong)UIImageView      *barBackImg;
@property(nonatomic,strong)UILabel          *barTitle;
@property(nonatomic,strong)UIButton         *backBtn;
@property(nonatomic,strong)UIButton         *saveBtn;
@property(nonatomic,strong)UIButton         *eraserBtn;
@property(nonatomic,strong)UIButton         *loadSignImgBtn;
@property(nonatomic,strong)UIButton         *widthChangeBtn;
@property(nonatomic,strong)UIButton         *colorChangeBtn;
@property(nonatomic,strong)UIButton         *preDrawBtn;
@property(nonatomic,strong)UIButton         *nextDrawBtn;
@property(nonatomic,strong)UIButton         *helpInBtn;
@end
