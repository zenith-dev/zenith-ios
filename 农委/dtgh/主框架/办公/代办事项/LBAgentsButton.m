//
//  LBAgentsButton.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/13.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgentsButton.h"
#define IconW 5
@implementation LBAgentsButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(5, (CGRectGetHeight(contentRect) - IconW)/2.0, IconW, IconW);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(IconW + 10, 0, CGRectGetWidth(contentRect) - IconW - 10, CGRectGetHeight(contentRect));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
