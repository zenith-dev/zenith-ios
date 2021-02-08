//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIButton (Bootstrap)
-(void)defaultStyle;

/**
 *  按钮颜色无边框
 *
 *  @param NomColor
 */
-(void)bootstrapNoborderStyle:(UIColor*)NomColor titleColor:(UIColor*)color andbtnFont:(UIFont*)font;
/**
 *  设置按钮背景色
 *
 */
-(void)bootStrapBG:(UIColor*)color forState:(UIControlState)state;
@end
