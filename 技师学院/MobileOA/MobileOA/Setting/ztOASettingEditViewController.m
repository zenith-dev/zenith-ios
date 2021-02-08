//
//  ztOASettingEditViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-1.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASettingEditViewController.h"

@interface ztOASettingEditViewController ()
{
    NSString *i_title;
    NSString *i_type;
    NSString *i_currentStr;
    
    UITextField *ipField;
    UITextField *portField;
    UITextField *usernameField;
    UITextField *userKeyField;
}

@end

@implementation ztOASettingEditViewController
//i_type:1:访问服务器地址；2:访问服务器端口；3:接入申请
- (id)initWithTitle:(NSString *)titleStr type:(NSString *)whichType currentStr:(NSString *)currentStr
{
    self = [super init];
    if (self) {
        i_currentStr = currentStr;
        i_title = titleStr;
        i_type = whichType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = i_title;
    if ([i_type isEqualToString:@"3"]) {
        [self rightButton:@"提交" imagen:nil imageh:nil sel:@selector(doneEdit)];
    }
    else
    {
       [self rightButton:@"保存" imagen:nil imageh:nil sel:@selector(doneEdit)];
    }
    //现实界面
    [self loadCurrentView];
}
- (void)doneEdit
{
    
}
- (void)loadCurrentView
{
    //i_type:1:访问服务器地址；2:访问服务器端口；3:接入申请
    if ([i_type isEqualToString:@"1"]) {
        
        ipField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64+20, self.view.width-40, 25)];
        ipField.textAlignment = NSTextAlignmentLeft;
        [ipField setEnabled:YES];
        ipField.textColor = [UIColor grayColor];
        [ipField setBorderStyle:UITextBorderStyleRoundedRect];
        [ipField setKeyboardType:UIKeyboardTypeAlphabet];
        ipField.font = [UIFont systemFontOfSize:15.0f];
        ipField.text = i_currentStr;
        [self.view addSubview:ipField];
    }
    else if ([i_type isEqualToString:@"2"]) {
        
        portField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64+20, self.view.width-40, 25)];
        portField.textAlignment = NSTextAlignmentLeft;
        [portField setEnabled:YES];
        portField.textColor = [UIColor grayColor];
        [portField setBorderStyle:UITextBorderStyleRoundedRect];
        [portField setKeyboardType:UIKeyboardTypeAlphabet];
        portField.font = [UIFont systemFontOfSize:15.0f];
        portField.text = i_currentStr;
        [self.view addSubview:portField];
    }
    else if ([i_type isEqualToString:@"3"]) {
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+20, 70, 25)];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = [UIColor blackColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.text = @"用户名：";
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:nameLable];
        
        usernameField = [[UITextField alloc] initWithFrame:CGRectMake(80, 64+20, self.view.width-90, 25)];
        usernameField.textAlignment = NSTextAlignmentLeft;
        [usernameField setEnabled:YES];
        usernameField.textColor = [UIColor grayColor];
        [usernameField setBorderStyle:UITextBorderStyleRoundedRect];
        [usernameField setKeyboardType:UIKeyboardTypeDefault];
        usernameField.font = [UIFont systemFontOfSize:15.0f];
        usernameField.text = @"";
        [self.view addSubview:usernameField];
        
        UILabel *keyLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+20+35, 70, 25)];
        keyLable.textAlignment = NSTextAlignmentLeft;
        keyLable.textColor = [UIColor blackColor];
        keyLable.backgroundColor = [UIColor clearColor];
        keyLable.text = @"密  码：";
        keyLable.font = [UIFont systemFontOfSize:15.0f];
        [self.view addSubview:keyLable];
        
        userKeyField = [[UITextField alloc] initWithFrame:CGRectMake(80, 64+20+35, self.view.width-90, 25)];
        userKeyField.textAlignment = NSTextAlignmentLeft;
        [userKeyField setEnabled:YES];
        userKeyField.textColor = [UIColor grayColor];
        [userKeyField setBorderStyle:UITextBorderStyleRoundedRect];
        [userKeyField setKeyboardType:UIKeyboardTypeAlphabet];
        userKeyField.font = [UIFont systemFontOfSize:15.0f];
        userKeyField.text = @"";
        [self.view addSubview:userKeyField];
        
    }
    

}


@end
