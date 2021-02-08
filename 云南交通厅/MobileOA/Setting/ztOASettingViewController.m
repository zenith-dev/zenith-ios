//
//  ztOASettingViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASettingViewController.h"
#import "AuthHelper.h"
#import "sdkheader.h"
#import "sslvpnnb.h"
#import "NSArray+BlocksKit.h"
#import "LoginVC.h"
#import "MyCollectVC.h"
@interface ztOASettingViewController ()<UIAlertViewDelegate>
{
    NSString *bandStateStr ;
    BOOL     canCancelBandFlag;
}
@property(nonatomic,strong)UITableView  *settingTable;//设置界面
@property(nonatomic,strong)NSArray *setary;
@end

@implementation ztOASettingViewController
@synthesize settingTable,setary;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    setary=@[@[@"访问服务器",@"接入申请"],@[@"开启VPN服务",@"我的收藏",@"关于"],@[@"退出登录"]];
    [self.view setBackgroundColor:RGBCOLOR(234, 234, 234)];
    bandStateStr = @"信息获取失败";
    canCancelBandFlag = NO;
    self.settingTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, self.view.height) style:UITableViewStylePlain];
    settingTable.delegate = self;
    [settingTable setShowsHorizontalScrollIndicator:NO];
    [settingTable setShowsVerticalScrollIndicator:NO];
    settingTable.backgroundColor = [UIColor clearColor];
    settingTable.dataSource = self;
    settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTable];
    [self reflashBandInfo];
}

#pragma mark--------设备号绑定状态---------------------
-(void)deviceBandState
{
    NSDictionary *deviceDic =@{@"moveEquipmentId":[YYBSingObj defaultManager].deviceId};
    [self network:@"userbindservices" requestMethod:@"selBindState" requestHasParams:@"true" parameter:deviceDic progresHudText:@"加载中..." completionBlock:^(id rep) {
        
    }];
}
- (void)reflashBandInfo
{
     NSDictionary *deviceDic =@{@"moveEquipmentId":[YYBSingObj defaultManager].deviceId};
    [self networkall:@"userbindservices" requestMethod:@"selBindState" requestHasParams:@"true" parameter:deviceDic progresHudText:nil completionBlock:^(id rep) {
        if (rep!=nil) {
             rep=rep[@"root"];
            if ([rep[@"result"] intValue]==0) {
              bandStateStr = [NSString stringWithFormat:@"%@",rep[@"message"]];
                 canCancelBandFlag = YES;
            }else if ([rep[@"result"] intValue]==1) {
                bandStateStr = [NSString stringWithFormat:@"%@",rep[@"message"]];
                canCancelBandFlag = NO;
            }else if ([rep[@"result"] intValue]==2) {
                bandStateStr = [NSString stringWithFormat:@"%@",rep[@"message"]];
                 canCancelBandFlag = NO;
            }else if ([rep[@"result"] intValue]==3) {
                bandStateStr = [NSString stringWithFormat:@"%@",rep[@"message"]];
                 canCancelBandFlag = YES;
            }else if ([rep[@"result"] intValue]==100) {
                bandStateStr = [NSString stringWithFormat:@"%@",rep[@"message"]];
                canCancelBandFlag = NO;
            }else
            {
                bandStateStr = @"信息获取失败";
                canCancelBandFlag = NO;
            }
        }else
        {
            bandStateStr = @"信息获取失败";
            canCancelBandFlag = NO;
        }
        [settingTable reloadData];
    }];
}
//绑定
- (void)doEdit
{
    
}
- (void)switchValueChange:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn==YES) {
        [SingObj.helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    }
    else
    {
        [SingObj.helper logoutVpn];
    }
    [[NSUserDefaults standardUserDefaults]setBool:isButtonOn forKey:@"openVPN"];
}
#pragma mark-tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return setary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 70;
    }
    else
    {
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [setary[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=setary[indexPath.section][indexPath.row];
    if (indexPath.section==0) {
        static NSString *cellId = @"id";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] bk_each:^(id sender){
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.width-20, 20)];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = [UIColor blackColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        nameLable.text = str;
        [cell addSubview:nameLable];
        UILabel *detailLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, tableView.width-20, 20)];
        detailLable.font = [UIFont systemFontOfSize:14.0f];
        detailLable.textAlignment = NSTextAlignmentLeft;
        if ([str isEqualToString:@"接入申请"]) {
            detailLable.text = bandStateStr;
            detailLable.textColor=SingObj.mainColor;
            UIButton *relashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            relashBtn.frame = CGRectMake(tableView.width-5-30, 40, 30, 30);
            [relashBtn setImage:[UIImage imageNamed:@"oa_refresh_off"] forState:UIControlStateNormal];
            [relashBtn addTarget:self action:@selector(reflashBandInfo) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:relashBtn];
        }
        else
        {
            detailLable.text =[NSString stringWithFormat:@"%@:%@", SingObj.serviceIp,SingObj.servicePort];
            detailLable.textColor = [UIColor grayColor];
        }
        [cell addSubview:detailLable];
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, tableView.width, 1)];
        lineBreak.backgroundColor = RGBCOLOR(240, 240, 240);
        [cell addSubview:lineBreak];
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *cellID = @"cellsetting";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [[cell.contentView subviews] bk_each:^(id sender){
            
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        UIImageView *whiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width,44)];
        whiteBack.backgroundColor =[UIColor whiteColor];
        [cell addSubview:whiteBack];
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, tableView.width-90, 20)];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = [UIColor blackColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        nameLable.text = str;
        [cell addSubview:nameLable];
        if ([str isEqualToString:@"开启VPN服务"]) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UISwitch *swithBtn = [[UISwitch alloc] initWithFrame:CGRectMake(nameLable.right+15, 7, 30, 30)];
            [swithBtn setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"openVPN"]];
            [swithBtn addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:swithBtn];
        }
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableView.width, 1)];
        lineBreak.backgroundColor = RGBCOLOR(240, 240, 240);
        [cell addSubview:lineBreak];
        return cell;
    }
    else
    {
        static NSString *cellID = @"cellsetting";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [[cell.contentView subviews] bk_each:^(id sender){
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.textColor = [UIColor whiteColor];
        nameLable.backgroundColor = SingObj.mainColor;
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        nameLable.text = str;
        [cell addSubview:nameLable];
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableView.width, 1)];
        lineBreak.backgroundColor = RGBCOLOR(240, 240, 240);
        [cell addSubview:lineBreak];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str=setary[indexPath.section][indexPath.row];
    if ([str isEqualToString:@"访问服务器"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"访问服务器设置" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag=1958;
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        UITextField *serviceIp = [alert textFieldAtIndex:0];
        serviceIp.placeholder = @"请输入地址";
        serviceIp.text=SingObj.serviceIp;
        UITextField *servicePort = [alert textFieldAtIndex:1];
        servicePort.placeholder = @"请输入端口号";
        [servicePort setSecureTextEntry:NO];
        servicePort.text=SingObj.servicePort;
        [alert show];
    }
    else if ([str isEqualToString:@"接入申请"])
    {
        if (canCancelBandFlag == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"绑定账号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag=1959;
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            UITextField *serviceIp = [alert textFieldAtIndex:0];
            serviceIp.placeholder = @"请输入用户名";
            UITextField *servicePort = [alert textFieldAtIndex:1];
            servicePort.placeholder = @"请输入密码";
            [servicePort setSecureTextEntry:YES];
            [alert show];
        }else
        {
            UIAlertView *alertview=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"取消设备号绑定" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                     NSDictionary *dicCode =@{@"moveEquipmentId":[YYBSingObj defaultManager].deviceId};
                    [self networkall:@"userbindservices" requestMethod:@"userCancelBind" requestHasParams:@"true" parameter:dicCode progresHudText:@"解绑中..." completionBlock:^(id rep) {
                        if (rep!=nil) {
                            if ([rep[@"root"] intValue]==0) {
                                [self showMessage:@"取消绑定申请成功"];

                            }
                            else if ([rep[@"root"] intValue]==1) {
                                [self showMessage:@"设备id没有绑定过帐号"];
                                
                            }
                            else if ([rep[@"root"] intValue]==2) {
                                [self showMessage:@"设备未传入值"];
                                
                            }
                            else if ([rep[@"root"] intValue]==3) {
                                [self showMessage:@"取消绑定申请成功"];
                                
                            }
                            else if ([rep[@"root"] intValue]==100) {
                                [self showMessage:@"未知异常"];
                                
                            }
                        }
                        [self reflashBandInfo];
                    }];
                }
            }];
            [alertview show];
        }
    }
    else if ([str isEqualToString:@"我的收藏"]){
        
        MyCollectVC *mycollectVc=[[MyCollectVC alloc]initWithTitle:@"我的收藏"];
        [self.navigationController pushViewController:mycollectVc animated:YES];
        
    }else if ([str isEqualToString:@"关于"])
    {
        ztOAAboutThisAPPViewController *aboutVC = [[ztOAAboutThisAPPViewController alloc] init];
        aboutVC.title=@"关于";
        [self.navigationController pushViewController:aboutVC animated:YES];
    }else if ([str isEqualToString:@"退出登录"])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
        LoginVC *loadingVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loadingVC animated:NO];
    }
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
}
#pragma mark --------------alertView delegate-
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1958) {
        if (buttonIndex==1) {
            UITextField *serviceIp = [alertView textFieldAtIndex:0];
            UITextField *servicePort = [alertView textFieldAtIndex:1];
            if (serviceIp.text.length==0) {
                [Tools showMsgBox:@"输入地址不能为空"];
                return ;
            }else if (servicePort.text.length==0)
            {
                [Tools showMsgBox:@"输入端口号为空"];
                return;
            }
            SingObj.serviceIp=serviceIp.text;
            SingObj.servicePort=servicePort.text;
            [[NSUserDefaults standardUserDefaults] setValue:SingObj.serviceIp forKey:@"baseServiceIp"];
            [[NSUserDefaults standardUserDefaults] setValue:SingObj.servicePort forKey:@"baseServicePort"];
            [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if (alertView.tag==1959)
    {
        if (buttonIndex==1) {
            UITextField *serviceIp = [alertView textFieldAtIndex:0];
            UITextField *servicePort = [alertView textFieldAtIndex:1];
            if (serviceIp.text.length==0) {
                [Tools showMsgBox:@"输入用户名为空"];
                return ;
            }else if (servicePort.text.length==0)
            {
                [Tools showMsgBox:@"输入密码为空"];
                return;
            }
            NSDictionary *dicCode =@{@"userName":serviceIp.text,@"password":servicePort.text,@"moveEquipmentId":[YYBSingObj defaultManager].deviceId};
            [self networkall:@"userbindservices" requestMethod:@"userBind" requestHasParams:@"true" parameter:dicCode progresHudText:@"申请绑定中..." completionBlock:^(id rep) {
                if (rep!=nil) {
                    [self showMessage:rep[@"root"][@"message"]];
                    [self reflashBandInfo];
                }
            }];
        }
    }
}
@end
