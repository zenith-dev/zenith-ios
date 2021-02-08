//
//  ztOABaseNavigationViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOABaseNavigationViewController.h"
#import "ztOAHandWritingImageViewController.h"
@interface ztOABaseNavigationViewController ()

@end

@implementation ztOABaseNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[ztOAHandWritingImageViewController class]]) {
        return self.topViewController.shouldAutorotate;
    }
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
