//
//  ztOAAboutThisAPPViewController.m
//  OAMobileIOS
//aaa
//  Created by 陈杨 on 14-6-3.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAAboutThisAPPViewController.h"

@interface ztOAAboutThisAPPViewController ()

@end

@implementation ztOAAboutThisAPPViewController

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
	self.view.backgroundColor =RGBCOLOR(234, 233, 230);
	UIImageView *appIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(110, 64+40, 100, 100)];
    [appIconImg setImage:[Tools getIconImge]];
    appIconImg.centerX=kScreenWidth/2.0;
	[self.view addSubview:appIconImg];
	
	UIImageView *appIconInfoImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, appIconImg.bottom, 200, 30)];
	NSString *imgStrName = [NSString stringWithFormat:@"main_title_text"];
    [appIconInfoImg setImage:[UIImage imageNamed:imgStrName]];
	[self.view addSubview:appIconInfoImg];
    appIconInfoImg.centerX=kScreenWidth/2.0;
	
	UILabel *appVerSion = [[UILabel alloc] initWithFrame:CGRectMake(110, appIconInfoImg.bottom+10,100, 20)];
    [appVerSion setBackgroundColor:[UIColor clearColor]];
    [appVerSion setTextAlignment:NSTextAlignmentCenter];
    [appVerSion setText:[NSString stringWithFormat:@"iOS版本 - %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    appVerSion.centerX=kScreenWidth/2.0;
    [appVerSion setTextColor:RGBCOLOR(85, 87, 89)];
    [appVerSion setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:appVerSion];
	
	UIImageView *appIconLine = [[UIImageView alloc] initWithFrame:CGRectMake(30, appVerSion.bottom+20, 260, 1)];
    [appIconLine setBackgroundColor:[UIColor lightGrayColor]];
    appIconLine.centerX=kScreenWidth/2.0;
    
	[self.view addSubview:appIconLine];
	
	UILabel *appInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(60, appIconLine.bottom+20,200, 100)];
    [appInfoLab setBackgroundColor:[UIColor clearColor]];
    [appInfoLab setTextColor:RGBCOLOR(85, 87, 89)];
    [appInfoLab setTextAlignment:NSTextAlignmentCenter];
    [appInfoLab setLineBreakMode:NSLineBreakByWordWrapping];
    appInfoLab.numberOfLines = 0;
    appInfoLab.centerX=kScreenWidth/2.0;
    [appInfoLab setText:@"移动办公"];
    [appInfoLab setFont:[UIFont systemFontOfSize:10]];
    [self.view addSubview:appInfoLab];
}



@end
