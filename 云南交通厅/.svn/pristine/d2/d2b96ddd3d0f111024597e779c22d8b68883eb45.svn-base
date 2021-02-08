//
//  BaseViewController.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/5/11.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+util.h"
@implementation BaseViewController
-(id)initWithTitle:(NSString *)title{
    self=[super init];
    if (self) {
        self.title=title;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.hideLeft!=YES) {
        UIButton *leftbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,20, 55, 44)];
        [leftbtn setImage:PNGIMAGE(@"back_btn_n") forState:UIControlStateNormal];
        [leftbtn setImage:PNGIMAGE(@"back_btn_h") forState:UIControlStateHighlighted];
        [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftbtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftbtn],negativeSpacer];
    }

    
}
-(void)backPage
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
