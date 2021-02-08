//
//  ztOABandDeviceViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-7-3.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOABandDeviceViewController.h"
#import "ztOATextField.h"
@interface ztOABandDeviceViewController ()
{
    ztOATextField          *userNameField;//用户名
    ztOATextField          *userPasswardField;//密
    UIButton             *userBandBtn;
}

@end

@implementation ztOABandDeviceViewController
- (id)init
{
    self = [super init];
    if (self) {
        //清除旧的用户数据
        [self clearOldUserInfo];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   self.title = @"设备绑定";
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+20, 70, 25)];
    nameLable.textAlignment = NSTextAlignmentLeft;
    nameLable.textColor = [UIColor blackColor];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = @"用户名：";
    nameLable.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:nameLable];
    
    userNameField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 64+20, self.view.width-90, 25)];
    userNameField.textAlignment = NSTextAlignmentLeft;
    [userNameField setEnabled:YES];
    userNameField.placeholder=@"请输入用户名";
    userNameField.textColor = [UIColor grayColor];
    [userNameField setBorderStyle:UITextBorderStyleRoundedRect];
    [userNameField setKeyboardType:UIKeyboardTypeDefault];
    userNameField.font = [UIFont systemFontOfSize:15.0f];
    userNameField.text = @"";
    [self.view addSubview:userNameField];
    
    UILabel *keyLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+20+35, 70, 25)];
    keyLable.textAlignment = NSTextAlignmentLeft;
    keyLable.textColor = [UIColor blackColor];
    keyLable.backgroundColor = [UIColor clearColor];
    keyLable.text = @"密  码：";
    keyLable.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:keyLable];
    
    userPasswardField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 64+20+35, self.view.width-90, 25)];
    userPasswardField.placeholder=@"请输入密码";
    userPasswardField.textAlignment = NSTextAlignmentLeft;
    [userPasswardField setEnabled:YES];
    userPasswardField.textColor = [UIColor grayColor];
    [userPasswardField setBorderStyle:UITextBorderStyleRoundedRect];
    [userPasswardField setKeyboardType:UIKeyboardTypeAlphabet];
    userPasswardField.font = [UIFont systemFontOfSize:15.0f];
    userPasswardField.text = @"";
    [self.view addSubview:userPasswardField];
    
    userBandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userBandBtn.frame = CGRectMake(30, userPasswardField.bottom+30, self.view.width-60, 30);
    userBandBtn.backgroundColor = BACKCOLOR;
    [userBandBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [userBandBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [userBandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userBandBtn addTarget:self action:@selector(bandDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userBandBtn];
}
- (void)bandDeviceAction
{
    if([userNameField.text length]==0 || [[userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if([userPasswardField.text length]==0 || [[userPasswardField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *dicCode = [[NSDictionary alloc] initWithObjectsAndKeys:userNameField.text,@"userName",userPasswardField.text,@"password",[ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId", nil];
    NSLog(@"%@",dicCode);
    [self showWaitView];
    [ztOAService userDeviceBand:dicCode Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        NSString *msg=@"";
        if ([[dataDic objectForKey:@"root"] objectForKey:@"message"]!=NULL) {
            msg = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
        }
        if ([[dataDic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            //写入时间
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FIRSTLOADINGDATA"]==nil) {
                NSDate *currentTime = [NSDate date];
                [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"FIRSTLOADINGDATA"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg];
        [alert addButtonWithTitle:@"确定" handler:^(void){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
