//
//  ztOALoadingViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//
#import <sys/socket.h>
#import <sys/time.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <time.h>
#import <pthread.h>
#import "ztOALoadingViewController.h"
#import "ztOALoadingBaseView.h"
#import "ztOANewMainViewController.h"
#import "ztOASettingViewController.h"
#import "DCRoundSwitch.h"
#import "ztOAAppDelegate.h"
#import "ztOABandDeviceViewController.h"
#import "SVProgressHUD.h"
#define toolbarHeight	35

// 以下是认证可能会用到的认证信息
short port = 4443;                        //vpn设备端口号，一般为443
NSString *vpnIp =    @"61.128.195.218";  //vpn设备IP地址
NSString *userName = @"szwoa";             //用户名认证的用户名
NSString *password = @"szw250.4";                //用户名认证的密码

NSString *certName = @"";     //导入证书名字，如果服务端没有设置证书认证可以不设置
NSString *certPwd =  @"";          //证书密码，如果服务端没有设置证书
@interface ztOALoadingViewController ()
{
    NSString    *bandStateStr;//绑定状态值
    NSString    *bandStateMessage;//绑定提示信息
    BOOL        isDeviceLoginOrUserName;//设备号绑定登陆或用户名登陆
    BOOL        canSeePasswordFlag;
}
@property(nonatomic,strong)ztOALoadingBaseView      *loadingView;
@end

@implementation ztOALoadingViewController
@synthesize loadingView,helper;
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    loadingView.loadingKeyword.text = @"";//暂时写死
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"VPN链接中..."];
    helper = [[AuthHelper alloc] initWithHostAndPort:vpnIp port:port delegate:self];
    [ztOAGlobalVariable sharedInstance].helper=helper;
    //设置认证参数 用户名和密码以数值map的形式传入
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
    //开始用户名密码认证
    [helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    
    //显示界面
    self.loadingView = [[ztOALoadingBaseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.view.height)];
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
    [self showWaitView];
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
            else if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==6)
            {
                bandStateStr = @"6";
                bandStateMessage = @"已申请但未通过审核";
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
//登陆
- (void)toLogin
{
    [loadingView.loadingUserName resignFirstResponder];
    [loadingView.loadingKeyword resignFirstResponder];
    NSDictionary *dataDic;
    if (isDeviceLoginOrUserName==YES) {
        //设备号登陆
        dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"userName",loadingView.loadingKeyword.text?:@"",@"password", [ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
    }
    else
    {
        //用户名登陆
        dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[self UnicodeToISO88591:loadingView.loadingUserName.text?:@""],@"userName",loadingView.loadingKeyword.text?:@"",@"password",  [ztOAGlobalVariable sharedInstance].deviceId,@"moveEquipmentId",nil];
    }
    
    [self showWaitViewWithTitle:@"登陆中..."];
    [ztOAService userLogin:dataDic Success:^(id result){
        
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        
        NSLog(@"登陆结果--%@",dic);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"] !=NULL) {
            if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"root"] forKey:@"userInfo"];
                [ztOAGlobalVariable sharedInstance].alldwlsh = [NSString stringWithFormat:@"%@", [[dic objectForKey:@"root"]objectForKey:@"alldwlsh"]?:@""];
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
                [ztOAGlobalVariable sharedInstance].intsessionlsh = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"root"] objectForKey:@"intsessionlsh"]?:@""];
                
                
                ztOANewMainViewController *mainVC = [[ztOANewMainViewController alloc] init];
                mainVC.hideLeft=YES;
                mainVC.title=@"首 页";
                UINavigationController *mainnav=[[UINavigationController alloc]initWithRootViewController:mainVC];
                [ztOAAppDelegate Share].window.rootViewController=mainnav;
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 1 ) {
                //跳转到用户绑定界面
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备未注册！"];
                [alert addButtonWithTitle:@"确定" handler:^(void){
                    ztOABandDeviceViewController *bandVC = [[ztOABandDeviceViewController alloc] init];
                    [self.navigationController pushViewController:bandVC animated:YES];
                }];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]== 2) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"密码错误!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue] == 3) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"校验登录用户名和密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==6)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已申请但未通过审核" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                if ([[dic objectForKey:@"root"][@"message"] length]!=0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[dic objectForKey:@"root"][@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败:服务器异常，请稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败:服务器异常，请稍后重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } Failed:^(NSError *error) {
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登录失败，请重新登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
{
    switch (vpnErrno)
    {
        case RESULT_VPN_INIT_FAIL:
            NSLog(@"Vpn Init failed!");
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            [helper clearAuthParam:@SET_RND_CODE_STR];
            [SVProgressHUD dismiss];
            NSLog(@"Vpn auth failed!");
            break;
            
        case RESULT_VPN_INIT_SUCCESS:
            NSLog(@"Vpn init success!");
            break;
        case RESULT_VPN_AUTH_SUCCESS:
            [self startOtherAuth:authType];
            break;
        case RESULT_VPN_AUTH_LOGOUT:
            NSLog(@"Vpn logout success!");
            break;
        case RESULT_VPN_OTHER:
            if (VPN_OTHER_RELOGIN_FAIL == (VPN_RESULT_OTHER_NO)authType) {
                NSLog(@"Vpn relogin failed, maybe network error");
            }
            break;
            
        case RESULT_VPN_NONE:
            break;
            
        default:
            break;
    }
}

- (void) onReloginCallback:(const int)status result:(const int)result
{
    switch (status) {
        case START_RECONNECT:
            NSLog(@"vpn relogin start reconnect ...");
            break;
        case END_RECONNECT:
            NSLog(@"vpn relogin end ...");
            if (result == SUCCESS) {
                NSLog(@"Vpn relogin success!");
            } else {
                NSLog(@"Vpn relogin failed");
            }
            break;
        default:
            break;
    }
}

- (void) startOtherAuth:(const int)authType
{
    NSArray *paths = nil;
    switch (authType)
    {
        case SSL_AUTH_TYPE_CERTIFICATE:
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
            
            if (nil != paths && [paths count] > 0)
            {
                NSString *dirPaths = [paths objectAtIndex:0];
                NSString *authPaths = [dirPaths stringByAppendingPathComponent:certName];
                NSLog(@"PATH = %@",authPaths);
                [helper setAuthParam:@CERT_P12_FILE_NAME param:authPaths];
                [helper setAuthParam:@CERT_PASSWORD param:certPwd];
            }
            
            [SVProgressHUD showInfoWithStatus:@"VPN连接失败!请联系管理员"];
            NSLog(@"Start Cert Auth!!!");
            break;
        case SSL_AUTH_TYPE_PASSWORD:
            NSLog(@"Start Password Name Auth!!!");
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
            
            [SVProgressHUD showInfoWithStatus:@"VPN连接失败!请联系管理员"];
            break;
        case SSL_AUTH_TYPE_NONE:
            [SVProgressHUD showSuccessWithStatus:@"VPN连接成功!"];
            NSLog(@"Auth success!!!");
            return;
        default:
        {
            [SVProgressHUD showInfoWithStatus:@"VPN连接失败!请联系管理员"];
        }
            NSLog(@"Other failed!!!");
            return;
    }
    [helper loginVpn:authType];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
