//
//  LBAboutUsViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/12/9.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAboutUsViewController.h"

@interface LBAboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionlb;

@end

@implementation LBAboutUsViewController
@synthesize versionlb;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *sysversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    versionlb.text=sysversion;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
