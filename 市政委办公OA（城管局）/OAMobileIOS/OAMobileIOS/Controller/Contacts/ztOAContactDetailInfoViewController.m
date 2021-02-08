//
//  ztOAContactDetailInfoViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-7.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAContactDetailInfoViewController.h"
#import "ztOAAddressBookInfoViewController.h"
@interface ztOAContactDetailInfoViewController ()
{
    NSMutableArray *infoNameArray;
    NSMutableArray *infoDetailArray;
    NSString       *i_isLocalPhotoInfo;
}
@property(nonatomic,strong)UITableView      *detailTable;
@end

@implementation ztOAContactDetailInfoViewController
@synthesize dicDate;
@synthesize detailTable;

//isLocalPhotoInfo:1,服务器数据；2本地手机数据
- (id)initWithData:(NSDictionary *)dic isLocalPhotoInfo:(NSString *)isLocalPhotoInfo
{
    self = [super init];
    if (self) {
        
        self.dicDate = dic;;
        i_isLocalPhotoInfo = isLocalPhotoInfo;
        if ([i_isLocalPhotoInfo isEqualToString:@"2"]) {
            infoNameArray =[ [NSMutableArray alloc] initWithObjects:@"姓名:",@"移动电话:",@"办公电话:",@"单位:",@"Email:" ,nil];
            infoDetailArray = [[NSMutableArray alloc] init];
            [infoDetailArray addObject:[dicDate objectForKey:@"姓名"]];
            [infoDetailArray addObject:[dicDate objectForKey:@"移动电话"]];
            [infoDetailArray addObject:[dicDate objectForKey:@"办公电话"]];
            [infoDetailArray addObject:[dicDate objectForKey:@"单位"]];
            [infoDetailArray addObject:[dicDate objectForKey:@"Email"]];
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
   // //self.appTitle.text = @"通讯录详细信息";
    
    self.detailTable = [[UITableView alloc] initWithFrame:CGRectMake(5, 64, self.view.width-10, self.view.height-64-80) style:UITableViewStylePlain];
    self.detailTable.separatorStyle = UITableViewCellSelectionStyleNone;
    detailTable.delegate = self;
    detailTable.dataSource = self;
    [self.view addSubview:self.detailTable];
    
    UIButton *doLoadToPhone = [[UIButton alloc] initWithFrame:CGRectMake(10, detailTable.bottom+20, self.view.width/2-20, 40)];
    [doLoadToPhone setTitle:@"导入手机" forState:UIControlStateNormal];
    [doLoadToPhone.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [doLoadToPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doLoadToPhone setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [doLoadToPhone setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [doLoadToPhone addTarget:self action:@selector(doToLoadPhone) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *doSendMessage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10,detailTable.bottom+20, self.view.width/2-20, 40)];
    [doSendMessage setTitle:@"手机联系人" forState:UIControlStateNormal];
    [doSendMessage.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [doSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doSendMessage setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [doSendMessage setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [doSendMessage addTarget:self action:@selector(goToAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doLoadToPhone];
    [self.view addSubview:doSendMessage];
    
    if ([i_isLocalPhotoInfo isEqualToString:@"1"]) {
        infoNameArray =[ [NSMutableArray alloc] initWithObjects:@"姓名:",@"英文名:",@"性别:",@"生日:",@"单位:",@"职务:",@"部门:",@"职业:",@"电子邮件:",@"网址:",@"邮编:",@"地址:",@"电话:",@"移动电话:",@"办公电话:",@"共享标志:",@"备注:", nil];
        infoDetailArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<infoNameArray.count; i++) {
            [infoDetailArray addObject:@""];
        }
        [self loadDetailData];
    }
    
}
-(void)loadDetailData{
    
    
    NSDictionary *contactDic= [[NSDictionary alloc] initWithObjectsAndKeys:[self.dicDate objectForKey:@"intmplsh"],@"intmplsh", nil];
    NSLog(@"%@",contactDic);
    [self showWaitView];
    [ztOAService getContactsDetailInfo:contactDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *resultDic = [result objectFromJSONData];
        NSLog(@"%@",resultDic);
        
        if ([[[resultDic objectForKey:@"root"]objectForKey:@"result"] intValue]==0) {
            NSDictionary *dataDetailDic =[[resultDic objectForKey:@"root"]objectForKey:@"contactperson"];
            infoDetailArray = nil;
            infoDetailArray = [[NSMutableArray alloc] init];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strxm"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strywm"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strxb"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strsr"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strdw"]?:@""]];
            
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strzw"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strbm"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strzy"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strdzyj"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strwz"]?:@""]];
            
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"stryb"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strdz"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strdh"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"stryddh"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strxh"]?:@""]];
            
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strgxbz"]?:@""]];
            [infoDetailArray addObject:[NSString stringWithFormat:@"%@",[dataDetailDic objectForKey:@"strbz"]?:@""]];
            
            [detailTable reloadData];
            
        }
        
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
}
//调用电话
-(void)toPhotoNumber
{
    //调用 电话phone
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[dicDate objectForKey:@"移动电话"]]]];
}
//导入手机
-(void)doToLoadPhone
{
    int seccessCount=0;
    ztOAAddressBook *onebook = [[ztOAAddressBook alloc] init];
    if ([i_isLocalPhotoInfo isEqualToString:@"1"]) {
        onebook.nameStr = [infoDetailArray objectAtIndex:0];
        onebook.companyNameStr = [infoDetailArray objectAtIndex:4];
        onebook.mobilePhoneStr = [infoDetailArray objectAtIndex:13];
        onebook.telePhoneStr = [infoDetailArray objectAtIndex:12];
        onebook.emailStr = [infoDetailArray objectAtIndex:8];
    }
    else
    {
        onebook.nameStr = [infoDetailArray objectAtIndex:0];
        onebook.companyNameStr = [infoDetailArray objectAtIndex:3];
        onebook.mobilePhoneStr = [infoDetailArray objectAtIndex:2];
        onebook.telePhoneStr = [infoDetailArray objectAtIndex:1];
        onebook.emailStr = [infoDetailArray objectAtIndex:4];
    }
    //name
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    CFErrorRef error = NULL;
    if (onebook.nameStr.length!=0) {
        ABRecordSetValue(newPerson, kABPersonMiddleNameProperty,(__bridge CFTypeRef)onebook.nameStr, &error);
    }
    if (onebook.companyNameStr.length!=0) {
        ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)onebook.companyNameStr, &error);
    }
    //phone number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    if (onebook.mobilePhoneStr.length!=0) {
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.mobilePhoneStr, kABPersonPhoneMobileLabel, NULL);
    }
    if (onebook.telePhoneStr.length!=0) {
        ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.telePhoneStr, kABPersonPhoneWorkFAXLabel, NULL);
    }
    
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
    if ([i_isLocalPhotoInfo isEqualToString:@"2"]) {
        //email
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)onebook.emailStr, kABWorkLabel, NULL);
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    }
    
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    
    if (ABAddressBookSave(iPhoneAddressBook, &error)) {
        if (error!=NULL) {
            NSLog(@"Danger Will Robinson! Danger!");
        }
        seccessCount =1;
    }
    NSString *mesgStr = [NSString stringWithFormat:@"成功导入%d个联系人",seccessCount];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:mesgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
//查看手机通讯录
-(void)goToAddressBook
{
    ztOAAddressBookInfoViewController *addressBook = [[ztOAAddressBookInfoViewController alloc] init];
    [self.navigationController pushViewController:addressBook animated:YES];
}

#pragma mark -tableview delegate-
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"listInfoCell";
    ztOADetailContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[ztOADetailContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.name.text= [infoNameArray objectAtIndex:indexPath.row];
    cell.detailInfo.text = [infoDetailArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoNameArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
