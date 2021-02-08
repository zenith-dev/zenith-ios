//
//  ztOALoadingViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOALoadingViewController.h"
#import "ztOALoadingBaseView.h"
#import "ztOANewMainViewController.h"
#import "ztOASettingViewController.h"
#import "DCRoundSwitch.h"
#import "ztOAAppDelegate.h"
#import "ztOABandDeviceViewController.h"
#define toolbarHeight	35
@interface ztOALoadingViewController ()
{
    NSString    *bandStateStr;//绑定状态值
    NSString    *bandStateMessage;//绑定提示信息
    BOOL        isDeviceLoginOrUserName;//设备号绑定登录或用户名登录
    BOOL        canSeePasswordFlag;
}
@property(nonatomic,strong)ztOALoadingBaseView      *loadingView;
@end

@implementation ztOALoadingViewController
@synthesize loadingView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        //获取服务器ip及端口号
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    loadingView.loadingKeyword.text = @"";//暂时写死
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //显示界面
    self.loadingView = [[ztOALoadingBaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight)];
    loadingView.loadingKeyword.delegate = self;
    loadingView.loadingUserName.delegate = self;
    [loadingView.loadingInBtn addTarget:self action:@selector(toLogin) forControlEvents:UIControlEventTouchUpInside];
    [loadingView.settingBtn addTarget:self action:@selector(toSetting) forControlEvents:UIControlEventTouchUpInside];
    canSeePasswordFlag = NO;
    [loadingView.canSeeWordBtn addTarget:self action:@selector(changeSecret:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadingView];
}
- (void)dimissAlertView:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
//判断设备是否绑定
- (void)deviceBandState
{
    bandStateStr = @"1000";
    bandStateMessage = @"信息获取失败";
    NSDictionary *deviceDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
    [self showWaitView];
    [ztOAService getDeviceBandState:deviceDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        //返回结果节点；0：已申请并通过审核;1：设备id没有绑定过帐号;100:未知异常；2:设备未传入值，3:已申请但未通过审核
        if ([[dataDic objectForKey:@"root"] objectForKey:@"result"]!=NULL) {
            if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                bandStateStr = @"0";
                bandStateMessage = [NSString stringWithFormat:@"设备绑定信息:%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
                isDeviceLoginOrUserName=YES;
                [loadingView showUserLoginView:NO];
            }
            else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==1)
            {
                bandStateStr = @"1";
                bandStateMessage = [NSString stringWithFormat:@"设备绑定信息:%@，请先绑定设备帐号哦～",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
                //跳转到用户绑定界面
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage];
                [alert addButtonWithTitle:@"确定" handler:^(void){
                    ztOABandDeviceViewController *bandVC = [[ztOABandDeviceViewController alloc] init];
                    [self.navigationController pushViewController:bandVC animated:YES];
                }];
                [alert show];
            }
            else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==2)
            {
                bandStateStr = @"2";
                bandStateMessage = [NSString stringWithFormat:@"设备绑定信息:%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==3)
            {
                bandStateStr = @"3";
                bandStateMessage = [NSString stringWithFormat:@"设备绑定信息:%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==100)
            {
                bandStateStr = @"100";
                bandStateMessage = [NSString stringWithFormat:@"设备绑定信息:%@",[[dataDic objectForKey:@"root"] objectForKey:@"message"]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                bandStateStr = @"100";
                bandStateMessage = @"设备绑定信息:未知异常";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
        else
        {
            bandStateStr = @"1000";
            bandStateMessage = @"设备绑定信息:未知异常";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:bandStateMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        bandStateStr = @"1000";
        bandStateMessage = @"设备绑定信息:获取失败";
        
    }];
    
}
//计算两个日期之间的差距，过了多少天
-(NSInteger)getDateToDateDays:(NSDate *)saveDate withSaveDate:(NSDate *)nowDate{
    NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
    NSUInteger unitFlags =  NSDayCalendarUnit;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [formatter stringFromDate:nowDate];
    NSString *oldDateStr = [formatter stringFromDate:saveDate];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *today = [formatter dateFromString:todayStr];
    today = [today dateByAddingTimeInterval:interval];
    NSDate *oldDate =[formatter dateFromString:oldDateStr];
    oldDate = [oldDate dateByAddingTimeInterval:interval];
    NSDateComponents *cps = [ chineseClendar components:unitFlags fromDate:oldDate  toDate:today  options:0];
    NSInteger diffDay = [cps day];
    return diffDay;
}
//执行
-(void)changeSecret:(id)sender{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    //手机端键盘打开不知道为什么一直都只进入一个if条件，键盘收起就是成功的，解决－》设置enabled
    if (canSeePasswordFlag==NO) {
        canSeePasswordFlag = YES;
        //明码
        loadingView.loadingKeyword.enabled = NO;
        [loadingView.loadingKeyword setSecureTextEntry:NO];
        loadingView.loadingKeyword.enabled = YES;
    }
    else
    {
        canSeePasswordFlag = NO;
        //加密
        loadingView.loadingKeyword.enabled = NO;
        [loadingView.loadingKeyword setSecureTextEntry:YES];
        loadingView.loadingKeyword.enabled = YES;
    }
    
}
//查看设置
- (void)toSetting
{
    self.navigationController.navigationBarHidden=NO;
    ztOASettingViewController *settingVC = [[ztOASettingViewController alloc] init];
    settingVC.title=@"设 置";
    [self.navigationController pushViewController:settingVC animated:YES];
}
//登录
- (void)toLogin
{
    [loadingView.loadingUserName resignFirstResponder];
    [loadingView.loadingKeyword resignFirstResponder];
    NSDictionary *dataDic;
    if (isDeviceLoginOrUserName==YES) {
        //设备号登录
        dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userName",loadingView.loadingKeyword.text?:@"",@"password", [ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
    }
    else
    {
        //用户名登录
        dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[self UnicodeToISO88591:loadingView.loadingUserName.text?:@""],@"userName",loadingView.loadingKeyword.text?:@"",@"password", @"",@"moveEquipmentId",nil];
    }
    
    [self showWaitViewWithTitle:@"登录中..."];
    [ztOAService userLogin:dataDic Success:^(id result){
        
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        
        NSLog(@"登录结果--%@",dic);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"] !=NULL) {
            if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"root"] forKey:@"userInfo"];
                //初始化用户信息
                [ztOAGlobalVariable sharedInstance].userzh = [NSString stringWithFormat:@"%@", [[[dic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"userzh"]?:@""];
                [ztOAGlobalVariable sharedInstance].dwccbm=[NSString stringWithFormat:@"%@", [[[dic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"dwccbm"]?:@""];
                [ztOAGlobalVariable sharedInstance].intrylsh = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"intrylsh"]?:@""];
                [ztOAGlobalVariable sharedInstance].username = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"username"]?:@""];
                [ztOAGlobalVariable sharedInstance].intdwlsh = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"intdwlsh"]?:@""];
                [ztOAGlobalVariable sharedInstance].intdwlsh_child = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"intdwlsh_child"]?:@""];
                [ztOAGlobalVariable sharedInstance].unitname = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname"]?:@""];
                [ztOAGlobalVariable sharedInstance].unitname_child = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname_child"]?:@""];
                [ztOAGlobalVariable sharedInstance].userHeadPicName = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"root"] objectForKey:@"chrxpmc"]?:@""];
                 [[NSUserDefaults standardUserDefaults] setObject:[ztOAGlobalVariable sharedInstance].userHeadPicName forKey:@"USERHEADIMAGENAME"];
                [ztOAGlobalVariable sharedInstance].intsessionlsh = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"root"] objectForKey:@"intsessionlsh"]?:@""];
                
                [JPUSHService setTags:[NSSet setWithObjects:[ztOAGlobalVariable sharedInstance].userzh, nil]
                                alias:[ztOAGlobalVariable sharedInstance].userzh
                     callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
                
                ztOANewMainViewController *mainVC = [[ztOANewMainViewController alloc] init];
                mainVC.hideLeft=YES;
                mainVC.title=@"首 页";
                UINavigationController *mainnav=[[UINavigationController alloc]initWithRootViewController:mainVC];
                [ztOAAppDelegate Share].window.rootViewController=mainnav;
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 1 ) {
                //跳转到用户绑定界面
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"设备id无效，请先绑定设备帐号哦～"];
                [alert addButtonWithTitle:@"确定" handler:^(void){
                    ztOABandDeviceViewController *bandVC = [[ztOABandDeviceViewController alloc] init];
                    [self.navigationController pushViewController:bandVC animated:YES];
                }];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]== 2) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 3) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名无效" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 4) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"用户名或者设备id未传入值" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 5) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码未传入值" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未知异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } Failed:^(NSError *error) {
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    //[self toLogin];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
