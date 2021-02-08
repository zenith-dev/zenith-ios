//
//  LBrightImageButton.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/20.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBrightImageButton.h"
#define Q_CHECK_ICON_WH 11
@implementation LBrightImageButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetWidth(contentRect)-Q_CHECK_ICON_WH-10, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH, 0,
                      CGRectGetWidth(contentRect) - 2*Q_CHECK_ICON_WH,
                      CGRectGetHeight(contentRect));
}
@end
