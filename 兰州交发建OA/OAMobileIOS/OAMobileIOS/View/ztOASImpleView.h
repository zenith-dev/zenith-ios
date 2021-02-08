//
//  ztOASImpleView.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ztOAUnderLineLabel.h"
@interface ztOASImpleView : UIView
@property(nonatomic,strong)UILabel *docName;
@property(nonatomic,strong)UILabel *writer;
@property(nonatomic,strong)UILabel *writeTime;
@property(nonatomic,strong)ztOAUnderLineLabel *docLink;
@property(nonatomic,strong)UIImageView *signOneImgView;
@property(nonatomic,strong)UIImageView *signTwoImgView;

@property(nonatomic,strong)UIButton *oneBigImgViewBtn;
@property(nonatomic,strong)UIButton *oneWriteImgViewBtn;
@property(nonatomic,strong)UIButton *twoBigImgViewBtn;
@property(nonatomic,strong)UIButton *twoWriteImgViewBtn;
@end
