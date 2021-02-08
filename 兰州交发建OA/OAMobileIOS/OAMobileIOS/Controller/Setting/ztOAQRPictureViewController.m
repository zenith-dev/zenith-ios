//
//  ztOAQRPictureViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-3.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAQRPictureViewController.h"
#import "QRCodeGenerator.h"
@interface ztOAQRPictureViewController ()
@property(nonatomic,strong)UIImageView      *QRCodeImageView;
@end

@implementation ztOAQRPictureViewController
@synthesize QRCodeImageView;
- (id)init
{
    self = [super init ];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.QRCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 64+20,self.view.width-40, self.view.width-40)];
    self.QRCodeImageView.backgroundColor = [UIColor clearColor];
    self.QRCodeImageView.image = [QRCodeGenerator qrImageForString:@"移动OA" imageSize:QRCodeImageView.width];
    [self.view addSubview:QRCodeImageView];
}

@end
