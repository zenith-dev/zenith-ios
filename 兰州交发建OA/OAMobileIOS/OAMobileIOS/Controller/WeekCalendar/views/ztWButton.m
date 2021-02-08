//
//  ztWButton.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/7.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztWButton.h"
#define IconW 24
@implementation ztWButton
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(CGRectGetWidth(contentRect)-IconW-2, (CGRectGetHeight(contentRect)-IconW)/2.0, IconW, IconW);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, 0,CGRectGetWidth(contentRect)-(IconW+7),CGRectGetHeight(contentRect));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
