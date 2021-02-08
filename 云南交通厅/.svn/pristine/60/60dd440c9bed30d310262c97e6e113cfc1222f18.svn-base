//
//  QButton.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/15.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "QButton.h"
#define Q_CHECK_ICON_WH                    (15.0)
#define Q_ICON_TITLE_MARGIN                (5.0)
@implementation QButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
