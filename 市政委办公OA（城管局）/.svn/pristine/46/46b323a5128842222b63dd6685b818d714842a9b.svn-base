//
//  ztOAWelcomeViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-13.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAWelcomeViewController.h"

@interface ztOAWelcomeViewController ()
{
    NSArray *imageNameArray;
}
@property(nonatomic,strong)UIScrollView     *welcomeScrollView;
@end

@implementation ztOAWelcomeViewController
@synthesize welcomeScrollView;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        imageNameArray = [NSArray arrayWithObjects:@"welcome_5_1",@"welcome_5_2",@"welcome_3", nil];
    }else
    {
        imageNameArray = [NSArray arrayWithObjects:@"welcome_4_1",@"welcome_4_2",@"welcome_3", nil];
    }
    
    
    int pages = imageNameArray.count;
    self.welcomeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.width, self.view.height)];
    self.welcomeScrollView.backgroundColor = [UIColor clearColor];
    [self.welcomeScrollView setPagingEnabled:YES];
    [self.welcomeScrollView setContentOffset:CGPointMake(0, 0)];
    [self.welcomeScrollView setContentSize:CGSizeMake(self.view.width*pages, self.view.height)];
    [self.view addSubview:welcomeScrollView];
    for (int i= 0; i<pages; i++) {
        UIImageView *imageIndex = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
        imageIndex.image = [UIImage imageNamed:[imageNameArray objectAtIndex:i]];
        
        
        if (i==pages-1) {
            imageIndex.backgroundColor = BACKCOLOR;
            imageIndex.userInteractionEnabled = YES;
            UIButton *goToMainViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            goToMainViewBtn.backgroundColor = [UIColor clearColor];
            goToMainViewBtn.frame = CGRectMake((self.view.width-100)/2, self.view.height-100, 100, 30);
            [goToMainViewBtn setTitle:@"开始体验" forState:UIControlStateNormal];
            [goToMainViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [goToMainViewBtn setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
            [goToMainViewBtn addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
            [imageIndex addSubview:goToMainViewBtn];
        }
        
        [welcomeScrollView addSubview:imageIndex];
    }
    
}
- (void)goToMainView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"welcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController pushViewController:[[ztOALoadingViewController alloc]init] animated:YES];
}
#pragma UIScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (welcomeScrollView == scrollView){
        
        //int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
