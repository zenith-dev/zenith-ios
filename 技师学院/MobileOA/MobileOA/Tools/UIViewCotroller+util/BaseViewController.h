//
//  BaseViewController.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/5/11.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController
@property (nonatomic,assign)BOOL hideLeft;
-(id)initWithTitle:(NSString*)title;
-(void)backPage;
@end
