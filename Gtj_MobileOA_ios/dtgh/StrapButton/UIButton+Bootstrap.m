//
//  UIButton+Bootstrap.m
//  UIButton+Bootstrap
//
//  Created by Oskur on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//
#import "UIButton+Bootstrap.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIButton (Bootstrap)

-(void)bootstrapStyle{
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    //点击背景颜色
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(245, 245, 245)] forState:UIControlStateHighlighted];
}
-(void)defaultStyle{
    [self bootstrapStyle];
    //设置字体颜色
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    //边框颜色
    self.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1] CGColor];
    //点击背景颜色
    [self setBackgroundImage:[self buttonImageFromColor:RGBCOLOR(245, 245, 245)] forState:UIControlStateSelected];
}

-(void)bootstrapNoborderStyle:(UIColor*)NomColor titleColor:(UIColor*)color andbtnFont:(UIFont*)font
{
    [self bootstrapStyle];
    //设置字体颜色
    self.titleLabel.font=font;
    self.layer.borderWidth = 0;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setBackgroundImage:[self buttonImageFromColor:NomColor] forState:UIControlStateNormal];
}
//用颜色设置背景图片
- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
