//
//  ztOABaseViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-1.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOABaseViewController.h"

@interface ztOABaseViewController ()
{
    int height;
}
@end

@implementation ztOABaseViewController
@synthesize waitView, leftBtn, leftBtnLab, rightBtn, rightBtnLab,scrollToTopBtn,scrollToBottomBtn;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.hideLeft!=YES) {
        UIButton *leftbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,20, 55, 44)];
        [leftbtn setImage:PNGIMAGE(@"back_btn_n") forState:UIControlStateNormal];
        [leftbtn setImage:PNGIMAGE(@"back_btn_h") forState:UIControlStateHighlighted];
        [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = 10;
        self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftbtn],negativeSpacer];
    }
    //Wait View
    self.waitView = [[MBProgressHUD alloc] initWithView:self.view];
    self.waitView.delegate = self;
    [self.waitView setMode:MBProgressHUDModeIndeterminate];
    [self.waitView setTaskInProgress:YES];
    self.waitView.labelText = @"加载中...";
    
    //scroll to top
    self.scrollToTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scrollToTopBtn.frame = CGRectMake(self.view.width-35, self.view.height-90, 30, 30);
    scrollToTopBtn.backgroundColor = [UIColor clearColor];
    [scrollToTopBtn setImage:[UIImage imageNamed:@"gotoTopViewBtn"] forState:UIControlStateNormal];
    
    //scroll to bottom
    self.scrollToBottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scrollToBottomBtn.frame = CGRectMake(self.view.width-35, self.view.height-90+40, 30, 30);
    scrollToBottomBtn.backgroundColor = [UIColor clearColor];
    [scrollToBottomBtn setImage:[UIImage imageNamed:@"btn_scroll_bottom.png"] forState:UIControlStateNormal];
}
- (void)back{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title imagen:(NSString*)imagen imageh:(NSString*)imageh sel:(SEL)sel
{
    UIButton *rightbtn= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 45, 44)];
    if(imagen){
        [rightbtn setImage:[UIImage imageNamed:imagen] forState:UIControlStateNormal];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if (imageh) {
        [rightbtn setImage:[UIImage imageNamed:imageh] forState:UIControlStateHighlighted];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [rightbtn setTitle:title forState:UIControlStateNormal];
        [rightbtn setTitleColor:MF_ColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
        [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        rightbtn.titleLabel.font = Font(15);
        rightbtn.frame=CGRectMake(X(rightbtn), Y(rightbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(rightbtn));
    }
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightbtn]];
    return rightbtn;
}
/**
 *  定义左边按钮
 */
-(UIButton*)rightButton:(NSString*)title Sel:(SEL)sel
{
    UIButton *rightbtnone= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 45, 44)];
    [rightbtnone setTitle:title forState:UIControlStateNormal];
    [rightbtnone setTitleColor:MF_ColorFromRGB(255, 255, 255) forState:UIControlStateNormal];
    rightbtnone.titleLabel.font = Font(13);
    rightbtnone.frame=CGRectMake(X(rightbtnone), Y(rightbtnone), [title sizeWithAttributes:@{NSFontAttributeName:Font(13)}].width+10, 20);
    ViewBorderRadius(rightbtnone, H(rightbtnone)/2.0, 1, [UIColor whiteColor]);
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    [rightbtnone addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems=@[negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightbtnone]];
    return rightbtnone;
}
//document路径
- (NSString *)UrlFromPathOfDocuments:(NSString *)path
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString *url = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@",path]];
    return url;
}

//自己传递参数显示waitview
- (void)showWaitViewWithTitle:(NSString *)msg {
    [self.waitView setLabelText:msg];
    [self.view addSubview:self.waitView];
    [self.view bringSubviewToFront:self.waitView];
    [self.waitView show:YES];
}

//默认的waitview
- (void)showWaitView {
    [self showWaitViewWithTitle:@"加载中"];
}

//关闭waitview
- (void)closeWaitView {
    if (self.waitView) {
        [self.waitView hide:YES];
    }
}
//str转ISO 8859-1
-(NSString *)UnicodeToISO88591:(NSString *)src
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSData *data = [src dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *pageSource = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    return pageSource;
}

//获取当前时间戳
- (NSString *)getCurrentTimeStr
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}
//是否已登陆
- (BOOL)isLogin
{
    if ([ztOAGlobalVariable sharedInstance].intrylsh!=NULL && ![[ztOAGlobalVariable sharedInstance].intrylsh isEqualToString:@""]) {
        return YES;
    }
    else
        return NO;
}
//清理用户数据
- (void)clearOldUserInfo
{
    /*
     移动OA设备解绑后可能需要清楚的数据列表：
     1、是否打开正文文稿默认值－》设为空
     2、通讯录数据
     3、本地收藏数据（公文、邮件）
     4、头像及其他下载的文件
     */
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //1.OPENDOCINWEBVIEW
    if ([userDefaults objectForKey:@"OPENDOCINWEBVIEW"] != nil) {
        [userDefaults setObject:nil forKey:@"OPENDOCINWEBVIEW"];
    }
    //2.ADDRESSBOOKLIST
    if ([userDefaults objectForKey:@"ADDRESSBOOKLIST"] != nil)
    {
        [userDefaults setObject:nil forKey:@"ADDRESSBOOKLIST"];
    }
    //3.localDocCollectArray\localEmailCollectArray
    [userDefaults setObject:nil forKey:@"localDocCollectArray"];
    [userDefaults setObject:nil forKey:@"localEmailCollectArray"];
    [userDefaults synchronize];
    //3.headimage & name。。。
    [userDefaults setObject:nil forKey:@"USERHEADIMAGENAME"];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSArray *files = [fileManage contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *fileName in files) {
        BOOL isDir = TRUE;
        if ([fileManage fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName] isDirectory:&isDir]) {
            [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName] error:nil];
        }
    }
    
}

#pragma mark- 调用电话，拨打
- (void)toCallPhotoNumber:(NSString *)number
{
    //调用 电话phone
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
}

#pragma mark-MFMessageComposeViewControllerDelegate-
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        NSLog(@"Message sent");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"Message failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark- 导入手机
- (void)doLoadToPhone:(NSMutableArray *)arraySelectContacts
{
    [UIViewHelp showProgressDialog:@"正在导入到通讯录，请稍后"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int seccessCount = 0;
            for (int i = 0 ; i < arraySelectContacts.count; i++) {
                ztOAABModel *onebook;
                onebook = [arraySelectContacts objectAtIndex:i];
                NSLog(@"%@",onebook.strxm);
                
                ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();// 创建一条空的联系人
                ABRecordRef newPerson = ABPersonCreate();
                CFErrorRef error = NULL;
                //name
                if (onebook.strxm.length!=0) {
                    ABRecordSetValue(newPerson, kABPersonMiddleNameProperty,(__bridge CFTypeRef)onebook.strxm, &error);
                }
                //单位
                if (onebook.strdw.length!=0) {
                    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)onebook.strdw, &error);
                }
                //职务
                if (onebook.strdw.length!=0) {
                    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, (__bridge CFTypeRef)onebook.strzw, &error);
                }
                
                //phone number
                ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                //移动电话
                if (onebook.stryddh.length!=0) {
                    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.stryddh, kABPersonPhoneMobileLabel, NULL);
                }
                //办公电话
                if (onebook.strbgdh.length!=0) {
                    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.strbgdh, kABPersonPhoneWorkFAXLabel, NULL);
                }
                
                ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
                //请求用户访问授权
                AB_EXTERN void ABAddressBookRequestAccessWithCompletion(ABAddressBookRef addressBook,  ABAddressBookRequestAccessCompletionHandler completion) __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
                
                ABAddressBookRef addressBook = nil;
                
                if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
                    addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
                    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
                    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool greanted, CFErrorRef error){
                        dispatch_semaphore_signal(sema);
                    });
                    
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                    //dispatch_release(sema);
                }
                else
                {
                    addressBook =ABAddressBookCreate();
                }
                
                ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
                
                if (ABAddressBookSave(iPhoneAddressBook, &error)) {
                    if (error!=NULL) {
                        NSLog(@"Danger Will Robinson! Danger!");
                    }
                    seccessCount ++;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"导入失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            [UIViewHelp dismissProgressDialog];
            NSString *mesgStr = [NSString stringWithFormat:@"成功导入%d个联系人",seccessCount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:mesgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        });
    });
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
