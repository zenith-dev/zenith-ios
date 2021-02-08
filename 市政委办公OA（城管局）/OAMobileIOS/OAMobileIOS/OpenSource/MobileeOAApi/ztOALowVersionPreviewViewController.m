//
//  ztOATestPreviewViewController.m
//  OAMobileIOS
//
//  Created by ran chen on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOALowVersionPreviewViewController.h"

@interface ztOALowVersionPreviewViewController ()
@property(nonatomic, strong)UIBarButtonItem *leftBarBtn;
@property(nonatomic, strong)NSTimer         *myTimer;
//@property(nonatomic, strong)UIDocumentInteractionController *controller;
@property(nonatomic, strong)NSString        *fileURL;
@end

@implementation ztOALowVersionPreviewViewController
@synthesize leftBarBtn, myTimer, fileURL;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [myTimer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [myTimer setFireDate:[NSDate distantFuture]];
}

- (id)initWithURL:(NSString *)aURL
{
    self = [super init];
    if (self) {
        self.fileURL = aURL;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:MF_ColorFromRGB(53, 105, 236)] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *leftBrn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBrn setFrame:CGRectMake(0, 0, 120 / 2.0 , 30)];
    [leftBrn setBackgroundImage:[UIImage imageNamed:@"icon_back_nomal"] forState:UIControlStateNormal];
    [leftBrn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:leftBrn];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(hideRightBtn) userInfo:nil repeats:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hideRightBtn{
        self.navigationItem.leftBarButtonItem = leftBarBtn;
        self.navigationItem.rightBarButtonItem = nil;
}

- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 **预览界面分享按钮，暂时屏蔽
- (void)openShareMenu{
    NSURL *filePath = [NSURL fileURLWithPath:self.fileURL];
    self.controller = [UIDocumentInteractionController  interactionControllerWithURL:filePath];
    self.controller.delegate =self;
    CGRect navRect = self.view.frame;
    navRect.size = CGSizeMake(50.0f,20.0f);
    [self.controller presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
}

- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller

{
    return self;
    
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller

{
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    
    return self.view.frame;
    
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
