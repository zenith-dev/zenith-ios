//
//  ztOASettingViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASettingViewController.h"
#import "ztOAGlobalVariable.h"
#import "CXAlertView.h"

@interface ztOASettingViewController ()
{
    NSString *bandStateStr ;
    BOOL     canCancelBandFlag;
}

@property(nonatomic,strong)UITableView  *settingTable;//设置界面
@end

@implementation ztOASettingViewController

@synthesize settingTable;
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
	[self.view setBackgroundColor:MF_ColorFromRGB(234, 234, 234)];
    bandStateStr = @"信息获取失败";
    canCancelBandFlag = NO;
    __block ztOASettingViewController *selfController = self;
    [self.leftBtn removeTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addEventHandler:^(id sender) {
        [[NSNotificationCenter defaultCenter]removeObserver:selfController];//注意
        [selfController.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.settingTable = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, self.view.height) style:UITableViewStylePlain];
    settingTable.delegate = self;
    [settingTable setShowsHorizontalScrollIndicator:NO];
    [settingTable setShowsVerticalScrollIndicator:NO];
    settingTable.backgroundColor = [UIColor clearColor];
    settingTable.dataSource = self;
    settingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:settingTable];
    
    addN(@selector(idChanged:), @"SERVICEIDDONE");
    addN(@selector(portChanged:), @"SERVICEPORTDONE");
    addN(@selector(bandChanged:), @"SERVICEBANDDONE");
    
    [self reflashBandInfo];
}

#pragma mark - 编译处理
- (void)idChanged:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    [ztOAGlobalVariable sharedInstance].serviceIp = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].serviceIp forKey:@"baseServiceIp"];
    [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationMiddle];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)portChanged:(NSNotification *)notify
{
    NSDictionary *dic = [notify userInfo];
    [ztOAGlobalVariable sharedInstance].servicePort = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    [[NSUserDefaults standardUserDefaults] setValue:[ztOAGlobalVariable sharedInstance].servicePort forKey:@"baseServicePort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationMiddle];
}
- (void)bandChanged:(NSNotification *)notify
{
    [self reflashBandInfo];
    
}
- (void)reflashBandInfo
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
    [ztOAService getDeviceBandState:dic Success:^(id result){
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            bandStateStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
            canCancelBandFlag = YES;
        }
        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==1)
        {
            bandStateStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
            canCancelBandFlag = NO;
        }
        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==2)
        {
            bandStateStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
            canCancelBandFlag = NO;
        }
        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==3)
        {
            bandStateStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
            canCancelBandFlag = YES;
        }
        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==100)
        {
            bandStateStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
            canCancelBandFlag = NO;
        }
        else
        {
            bandStateStr = @"信息获取失败";
            canCancelBandFlag = NO;
        }
        //[docInfoView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationMiddle];
        [settingTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationMiddle];
    } Failed:^(NSError *error){
        bandStateStr = @"信息获取失败";
        canCancelBandFlag = NO;
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
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"OPENDOCINWEBVIEW"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"OPENDOCINWEBVIEW"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark-tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 15)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
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
    if (section==0) {
        return  3;
    }
    if (section==1)
    {
        return 4;
    }
    else
    {
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString *cellId = @"id";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender){
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        UIImageView *whiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width,70)];
        whiteBack.backgroundColor = [UIColor whiteColor];
        [cell addSubview:whiteBack];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.width-20, 20)];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = [UIColor blackColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        [cell addSubview:nameLable];
        
        UITextField *detailLable = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, tableView.width-20, 20)];
        detailLable.textAlignment = NSTextAlignmentLeft;
        [detailLable setEnabled:NO];
        if (indexPath.row==2) {
            detailLable.textColor = BACKCOLOR;
            UIButton *relashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            relashBtn.frame = CGRectMake(tableView.width-5-30, 40, 30, 30);
            [relashBtn setImage:[UIImage imageNamed:@"oa_refresh_off"] forState:UIControlStateNormal];
            [relashBtn addTarget:self action:@selector(reflashBandInfo) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:relashBtn];
        }
        else
        {
            detailLable.textColor = [UIColor grayColor];
        }
        detailLable.font = [UIFont systemFontOfSize:12.0f];
        [cell addSubview:detailLable];
        if (indexPath.row==0) {
            nameLable.text = @"访问服务器地址：";
            detailLable.text = [ztOAGlobalVariable sharedInstance].serviceIp;
            [detailLable setSecureTextEntry:YES];
        }
        else if (indexPath.row==1)
        {
            nameLable.text = @"访问服务器端口：";
            detailLable.text = [ztOAGlobalVariable sharedInstance].servicePort;
            [detailLable setSecureTextEntry:YES];
        }
        else if (indexPath.row==2)
        {
            nameLable.text = @"接入申请：";
            detailLable.text = bandStateStr;
        }
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(240, 240, 240);
        [cell addSubview:lineBreak];
        
        return cell;
    }
    if (indexPath.section==1)
    {
        static NSString *cellID = @"cellsetting";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [[cell.contentView subviews] each:^(id sender){
        
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *whiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width,44)];
        whiteBack.backgroundColor = [UIColor whiteColor];
        [cell addSubview:whiteBack];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, tableView.width-90, 20)];
        nameLable.textAlignment = NSTextAlignmentLeft;
        nameLable.textColor = [UIColor blackColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        [cell addSubview:nameLable];
        
        if (indexPath.row==0) {
            nameLable.text = @"默认直接打开正文文稿";
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UISwitch *swithBtn = [[UISwitch alloc] initWithFrame:CGRectMake(nameLable.right, 7, 30, 30)];
            [swithBtn setOn:NO];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OPENDOCINWEBVIEW"]!=nil) {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"OPENDOCINWEBVIEW"] isEqualToString:@"yes"]) {
                    [swithBtn setOn:YES];
                }
            }
            
            [swithBtn addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            [cell addSubview:swithBtn];
        }
        else if (indexPath.row==1) {
            nameLable.text = @"用户反馈";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if (indexPath.row==2) {
            nameLable.text = @"关于";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if (indexPath.row==3) {
            nameLable.text = @"免责声明";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(240, 240, 240);
        [cell addSubview:lineBreak];
        return cell;
    }
    else
    {
        static NSString *cellID = @"cellsetting";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [[cell.contentView subviews] each:^(id sender){
            
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        UIImageView *whiteBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.width,44)];
        whiteBack.backgroundColor = BACKCOLOR;
        [cell addSubview:whiteBack];
        
        UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, tableView.width-20, 20)];
        nameLable.textAlignment = NSTextAlignmentCenter;
        nameLable.textColor = [UIColor whiteColor];
        nameLable.backgroundColor = [UIColor clearColor];
        nameLable.font = [UIFont systemFontOfSize:15.0f];
        nameLable.text = @"退出登录";
        [cell addSubview:nameLable];
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(240, 240, 240);
        [cell addSubview:lineBreak];
        return cell;
        
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //i_type:1:访问服务器地址；2:访问服务器端口；3:接入申请  －－－（已去掉这部分）
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            ztOASettingEditViewController *editVC = [[ztOASettingEditViewController alloc] initWithTitle:@"访问服务器地址设置" type:@"1" currentStr:[ztOAGlobalVariable sharedInstance].serviceIp];
            UINavigationController *navztoasetting=[[UINavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:navztoasetting animated:YES completion:^{
                
            }];
        }
        else if (indexPath.row==1){
            ztOASettingEditViewController *editVC = [[ztOASettingEditViewController alloc] initWithTitle:@"访问服务器端口设置" type:@"2" currentStr:[ztOAGlobalVariable sharedInstance].servicePort];
            UINavigationController *navztoasetting=[[UINavigationController alloc]initWithRootViewController:editVC];
            [self presentViewController:navztoasetting animated:YES completion:^{
                
            }];
        }else if (indexPath.row==2){
            if (canCancelBandFlag == NO) {
                ztOASettingEditViewController *editVC = [[ztOASettingEditViewController alloc] initWithTitle:@"接入申请" type:@"3" currentStr:[ztOAGlobalVariable sharedInstance].serviceIp];
                UINavigationController *navztoasetting=[[UINavigationController alloc]initWithRootViewController:editVC];
                [self presentViewController:navztoasetting animated:YES completion:^{
                    
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"取消设备号绑定"];
                [alert addButtonWithTitle:@"确定" handler:^(void){
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
                    [ztOAService userCancelDeviceBand:dic Success:^(id result){
                        NSDictionary *dataDic = [result objectFromJSONData];
                        NSLog(@"%@",dataDic);
                        NSString *msg = @"";
                        if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                            msg = @"取消绑定申请成功";
                        }
                        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==1) {
                            msg = @"设备id没有绑定过帐号";
                        }
                        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==2) {
                            msg = @"设备未传入值";
                        }
                        else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==100) {
                            msg = @"未知异常";
                        }
                        else{
                            msg = @"未知异常";
                        }
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        [self reflashBandInfo];
                        
                    } Failed:^(NSError *error){
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }];
                }];
                [alert addButtonWithTitle:@"取消" handler:^(void){
                }];
                [alert show];
                
            }
            
        }
    }
    if (indexPath.section==1)
    {
        if (indexPath.row==1) {
            NSLog(@"用户反馈");
            ztOAFeedbackViewController *feedbackVC = [[ztOAFeedbackViewController alloc] init];
            feedbackVC.title=@"用户反馈";
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
        else if (indexPath.row==2) {
            NSLog(@"关于");
            ztOAAboutThisAPPViewController *aboutVC = [[ztOAAboutThisAPPViewController alloc] init];
            aboutVC.title=@"关于";
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        else if (indexPath.row==3) {
            NSLog(@"免责声明");
            ztOADisclaimerViewController *disclaimerVC = [[ztOADisclaimerViewController alloc] init];
            disclaimerVC.title=@"免责声明";
            [self.navigationController pushViewController:disclaimerVC animated:YES];
        }
    }
    else if(indexPath.section==2)
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userInfo"];
        [JPUSHService resetBadge];
        [JPUSHService setTags:[NSSet set] alias:@"" callbackSelector:nil object:nil];
        [JPUSHService clearAllLocalNotifications];
        
        ztOALoadingViewController *loadingVC = [[ztOALoadingViewController alloc] init];
        [self.navigationController pushViewController:loadingVC animated:YES];
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
@end
