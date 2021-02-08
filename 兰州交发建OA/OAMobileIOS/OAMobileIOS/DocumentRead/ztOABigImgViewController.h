//
//  ztOABigImgViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-17.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import "ztOASingleScrollView.h"
#import "UIImageView+WebCache.h"
@interface ztOABigImgViewController : ztOABaseViewController<UIScrollViewDelegate>
{
    NSString *i_titleStr;
    int i_displayIndex;
    int i_AllPage;
    int i_currentIndex;
    int i_type;
}
@property(nonatomic,strong) NSArray *i_pictureUrlArray;//图片路径数组
@property(nonatomic,strong) UIScrollView *i_scrollView;
//展示入口
- (id)initWithTitle:(NSString *)titleName selectedIndex:(int)iIndex pictureArray:(NSArray *)array currentType:(int)myType;
@end
