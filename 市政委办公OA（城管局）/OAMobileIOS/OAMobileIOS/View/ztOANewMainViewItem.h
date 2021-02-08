//
//  ztOANewMainViewItem.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-21.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOANewMainViewItem : UIView
@property(nonatomic,strong)UIButton     *backImg;
@property(nonatomic,strong)UIImageView  *logoImg;
@property(nonatomic,strong)UILabel      *nameInfoLable;
@property(nonatomic,strong)UIImageView  *readCountRound;
@property(nonatomic,strong)UILabel      *readCountLable;
- (id)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName iconImgWidth:(float)width_t  iconImgHeight_t:(float)height_t iconImgName:(NSString *)iconImgName withSide:(int)indexSide;
@end
