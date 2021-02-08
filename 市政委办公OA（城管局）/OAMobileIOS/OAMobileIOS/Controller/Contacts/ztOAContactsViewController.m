//
//  ztOAContactsViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAContactsViewController.h"
#import "ztOAContactsListCell.h"
#import "ztOAContactDetailInfoViewController.h"
#import "ztOASendMesssageViewController.h"
#import "ztOAAddressBookInfoViewController.h"
@interface ztOAContactsViewController ()
{
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    BOOL isHeadSelected;//全选标志yes
    
    NSMutableArray *arrayFlags;
    NSMutableArray *arrayContactsInfo;
    NSMutableArray *arraySelectContacts;
    
    NSMutableArray *infoListArray;
}
@property(nonatomic,strong)UITableView  *contactsInfoTable;//列表
@property(nonatomic,strong)UITextField  *searchCompanyLab;//搜索部门
@property(nonatomic,strong)UITextField  *searchNameLab;//搜索名称
@property(nonatomic,strong)UIButton     *searchBtn;//搜索按钮
@property(nonatomic,strong)UIButton     *loadToPhone;//导入手机
@property(nonatomic,strong)UIButton     *sendMessage;//发送短信
@end

@implementation ztOAContactsViewController
@synthesize contactsInfoTable,searchBtn,searchCompanyLab,searchNameLab,loadToPhone,sendMessage;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isHeadSelected = NO;
    iRecentPageIndex = 1;
    infoListArray = nil;
    isLoadFinish = NO;
    infoListArray = [[NSMutableArray alloc] init];
    arraySelectContacts = [[NSMutableArray alloc] init];
    arrayContactsInfo = [[NSMutableArray alloc] init];
    
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    [self.rightBtn setHidden:NO];
    self.rightBtnLab.text = @"电话联系人";
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"btnClick"] forState:UIControlStateHighlighted];
    [self.rightBtn setFrame:CGRectMake(self.view.width-120/2.0-5-40, self.rightBtn.origin.y, 100, 30)];
    [self.rightBtnLab setFrame:CGRectMake(0, 0, self.rightBtn.frame.size.width, self.rightBtn.frame.size.height)];
    [self.rightBtn addTarget:self action:@selector(goToAddressBook) forControlEvents:UIControlEventTouchUpInside];
   // //self.appTitle.text = @"通讯录";
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10,64+20, 50 , 20)];
    lab.backgroundColor = [UIColor clearColor];
    [lab setTextColor:[UIColor blackColor]];
    lab.text = @"姓名：";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:lab];
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(10,64+20+35, 50 , 20)];
    lab.backgroundColor = [UIColor clearColor];
    [lab setTextColor:[UIColor blackColor]];
    lab.text = @"部门：";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:14.0f];
    [self.view addSubview:lab];
    
    UIImageView *searchKuangImg = [[UIImageView alloc] initWithFrame:CGRectMake(70,64+15, 180, 30)];
    searchKuangImg.image = [UIImage imageNamed:@"searchKuang"];
    [self.view addSubview:searchKuangImg];
    
    self.searchNameLab = [[UITextField alloc] initWithFrame:CGRectMake(75,64+15+5, 170, 20)];
    searchNameLab.backgroundColor = [UIColor clearColor];
    searchNameLab.delegate = self;
    [searchNameLab setFont:[UIFont systemFontOfSize:14.0f]];
    [searchNameLab setKeyboardType:UIKeyboardTypeDefault];
    searchNameLab.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:searchNameLab];
    
    searchKuangImg = [[UIImageView alloc] initWithFrame:CGRectMake(70,64+15+40, 180, 30)];
    searchKuangImg.image = [UIImage imageNamed:@"searchKuang"];
    [self.view addSubview:searchKuangImg];
    
    self.searchCompanyLab = [[UITextField alloc] initWithFrame:CGRectMake(75, 64+15+40+5, 170, 20)];
    searchCompanyLab.backgroundColor = [UIColor clearColor];
    searchCompanyLab.delegate = self;
    [searchCompanyLab setFont:[UIFont systemFontOfSize:14.0f]];
    [searchCompanyLab setKeyboardType:UIKeyboardTypeDefault];
    searchCompanyLab.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:searchCompanyLab];
    
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchCompanyLab.right+10,64+30 , 50, 40)];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchContacts"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"searchContacts"] forState:UIControlStateSelected];
    [self.searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    self.contactsInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(10, self.searchBtn.bottom+20, self.view.width-20, self.view.height-(self.searchBtn.bottom+20)-40-50) style:UITableViewStylePlain];
    contactsInfoTable.backgroundColor = [UIColor clearColor];
    contactsInfoTable.delegate = self;
    contactsInfoTable.dataSource = self;
    contactsInfoTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:contactsInfoTable];
    
    self.loadToPhone = [[UIButton alloc] initWithFrame:CGRectMake(10, contactsInfoTable.bottom+15, self.view.width/2-20, 40)];
    [loadToPhone setTitle:@"导入手机" forState:UIControlStateNormal];
    [loadToPhone.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [loadToPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loadToPhone setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [loadToPhone setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [loadToPhone addTarget:self action:@selector(doloadToPhone) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendMessage = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10,contactsInfoTable.bottom+15, self.view.width/2-20, 40)];
    [sendMessage setTitle:@"发送短信" forState:UIControlStateNormal];
    [sendMessage.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [sendMessage setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [sendMessage addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadToPhone];
    [self.view addSubview:sendMessage];
    
    //加载数据
    [self loadTableDate:@""];
    
}
#pragma mark- 搜索
- (void)doSearch
{
    isLoadFinish = NO;
    isHeadSelected = NO;
    infoListArray = nil;
    arrayContactsInfo = nil;
    iRecentPageIndex = 1;
    infoListArray = [[NSMutableArray alloc] init];
    arrayContactsInfo = [[NSMutableArray alloc] init];
    [arraySelectContacts removeAllObjects];
    
    if (searchCompanyLab.text.length==0 && searchNameLab.text.length==0) {
        [self loadTableDate:@""];
        return;
    }
    
    NSString *searchStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strxm>%@</strxm><sttbm>%@</sttbm><sttgxbz>%@</sttgxbz></root>",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchNameLab.text?:@""]],[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchCompanyLab.text?:@""] ] ,@"1"];
    
    [contactsInfoTable reloadData];
    [self loadTableDate:searchStr];
    
}

#pragma mark- 查看手机通讯录
- (void)goToAddressBook
{
    ztOAAddressBookInfoViewController *addressBook = [[ztOAAddressBookInfoViewController alloc] init];
    [self.navigationController pushViewController:addressBook animated:YES];
}

#pragma mark- 加载数据
- (void)loadTableDate:(NSString *)searchStr
{
    NSDictionary *datadic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchStr,@"queryTermXML",nil];
    
    NSLog(@"dic=%@",datadic);
    //联系人列表
    [self showWaitView];
    [ztOAService getContactsList:datadic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"%@",dic);
        
        if ([[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
            if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"contactperson"]).count>0) {
                iRecentPageIndex ++;
                NSMutableArray *dataArray = [[NSMutableArray alloc] init] ;
                if ([[[dic objectForKey:@"root"]objectForKey:@"contactperson"] isKindOfClass:[NSDictionary class]]) {
                    [infoListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"contactperson"]];
                    [dataArray addObject:[[dic objectForKey:@"root"]objectForKey:@"contactperson"]];
                }
                else
                {
                    [infoListArray addObjectsFromArray:[[dic objectForKey:@"root"]objectForKey:@"contactperson"]];
                    dataArray = [[dic objectForKey:@"root"]objectForKey:@"contactperson"];
                }
                if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                    isLoadFinish=YES;
                }
                for (int i =0; i<dataArray.count; i++) {
                    ztOAAddressBook *book =[[ztOAAddressBook alloc] init];
                    book.nameStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"strxm"]?:@""];
                    book.mobilePhoneStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"stryddh"]?:@""];
                    book.telePhoneStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"strxh"]?:@""];
                    book.companyNameStr =[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"strdw"]?:@""];
                    book.sectorNameStr =[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"strbm"]?:@""];
                    book.jobNameStr = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"strzw"]?:@""];
                 
                    [arrayContactsInfo addObject:book];
                }
                
            }
        }
        arrayFlags = nil;
        arrayFlags = [[NSMutableArray alloc] init];
        for (int i = 0; i<infoListArray.count; i++) {
            [arrayFlags addObject:@"0"];
        }
        [contactsInfoTable reloadData];
        
    } Failed:^(NSError *error){
        NSLog(@"wrong");
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }];
    
}
#pragma mark- 导入手机
- (void)doloadToPhone
{
    if (arraySelectContacts.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择要导入的联系人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    int seccessCount = 0;
    for (int i = 0 ; i < arraySelectContacts.count; i++) {
        ztOAAddressBook *onebook;
        onebook = [arraySelectContacts objectAtIndex:i];
        NSLog(@"%@",onebook.nameStr);
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
        //    ABRecordSetValue(newPerson, kABPersonFirstNamePhoneticProperty, @"y", &error);
        //    ABRecordSetValue(newPerson, kABPersonLastNamePhoneticProperty, @"y", &error);
        
        //phone number
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        //ABMultiValueAddValueAndLabel(multiPhone,(__bridge CFTypeRef)onebook.faxPhoneStr, kABPersonPhoneHomeFAXLabel, NULL);
        if (onebook.mobilePhoneStr.length!=0) {
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.mobilePhoneStr, kABPersonPhoneMobileLabel, NULL);
        }
        if (onebook.telePhoneStr.length!=0) {
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)onebook.telePhoneStr, kABPersonPhoneWorkFAXLabel, NULL);
        }
        
        ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, &error);
        //CFRelease(multiPhone);
        //email
        //ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        //ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)onebook.emailStr, kABWorkLabel, NULL);
        //ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
        
        //picture
        //    NSData *dataRef = UIImagePNGRepresentation(head.image);
        //    ABPersonSetImageData(newPerson, (CFDataRef)dataRef, &error);
        
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
    NSString *mesgStr = [NSString stringWithFormat:@"成功导入%d个联系人",seccessCount];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:mesgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark- 发送短信
- (void)doSend
{
    if (arraySelectContacts.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择要发送短信的联系人" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //调用 SMS    
    ztOASendMesssageViewController *sendMsgVC = [[ztOASendMesssageViewController alloc] initWithData:arraySelectContacts];
    [self.navigationController pushViewController:sendMsgVC animated:YES];
}
#pragma mark- 调用电话，拨打
- (void)toPhotoNumber:(NSString *)number
{
    //调用 电话phone
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
}
#pragma mark- 查看详情
- (void)goToDetailInfoView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag-1000;
     NSDictionary *dic = [infoListArray objectAtIndex:index];
    ztOAContactDetailInfoViewController *detailVC = [[ztOAContactDetailInfoViewController alloc] initWithData:dic isLocalPhotoInfo:@"1"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark- 列表选中事件处理
- (void)btnValueChange:(id )sender{
    UIButton *btn = (UIButton *)sender;
    int btnTag = btn.tag-1000;
    if ([btn isSelected])
    {
        [btn setSelected:NO];
        isHeadSelected = NO;
        [arrayFlags replaceObjectAtIndex:btnTag withObject:@"0"];
    }else
    {
        [btn setSelected:YES];
        [arrayFlags replaceObjectAtIndex:btnTag withObject:@"1"];
    }
    
    [arraySelectContacts removeAllObjects];
    
    for (int i = 0; i<arrayContactsInfo.count; i++) {
        if ([[arrayFlags objectAtIndex:i] isEqualToString:@"1"]) {
            [arraySelectContacts addObject:[arrayContactsInfo objectAtIndex:i]];
        }
    }
    if (arraySelectContacts.count==arrayContactsInfo.count) {
        isHeadSelected = YES;
    }
    [self.contactsInfoTable reloadData];
}
- (void)selecteHeadView:(id )sender
{
     UIButton *btn = (UIButton *)sender;
    if ([btn isSelected]) {
        [btn setSelected:NO];
        isHeadSelected = NO;
        for (int i=0; i<arrayFlags.count; i++) {
            [arrayFlags replaceObjectAtIndex:i withObject:@"0"];
        }
    }else{
        [btn setSelected:YES];
        isHeadSelected = YES;
        for (int i=0; i<arrayFlags.count; i++) {
            [arrayFlags replaceObjectAtIndex:i withObject:@"1"];
        }
    }
    
    [arraySelectContacts removeAllObjects];
    for (int i = 0; i<arrayContactsInfo.count; i++) {
        if ([[arrayFlags objectAtIndex:i] isEqualToString:@"1"]) {
            [arraySelectContacts addObject:[arrayContactsInfo objectAtIndex:i]];
        }
    }
    [self.contactsInfoTable reloadData];
}
#pragma mark -tableview delegate-
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width-20, 44)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:headView.frame];
    [backImg.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [backImg.layer setBorderWidth:1];
    
    backImg.backgroundColor = BACKCOLOR;;
    [headView addSubview:backImg];
    
    UIButton *selecteBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, (headView.height-20)/2-2, 25, 25)];
    [selecteBtn setBackgroundImage:[UIImage imageNamed:@"contact_select_off"] forState:UIControlStateNormal];
    [selecteBtn setBackgroundImage:[UIImage imageNamed:@"contact_select_on"] forState:UIControlStateSelected];
    [selecteBtn addTarget:self action:@selector(selecteHeadView:) forControlEvents:UIControlEventTouchUpInside];
    if (isHeadSelected==YES) {
        [selecteBtn setSelected:YES];
    }
    else
    {
        [selecteBtn setSelected:NO];
    }
    [headView addSubview:selecteBtn];
    
    UIButton *contactName =[[UIButton alloc] initWithFrame:CGRectMake(headView.width/10+22, 0, headView.width*3/10+7, headView.height)];
    [contactName setTitle:@"" forState:UIControlStateNormal];
    
    [contactName.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [contactName.layer setBorderWidth:1];
    [contactName.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contactName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [contactName setTitle:@"姓名" forState:UIControlStateNormal];
    [headView addSubview:contactName];
    
    UIButton *contactPhoneNum =[[UIButton alloc] initWithFrame:CGRectMake(headView.width*2/5+28, 0, headView.width*3/5-20, headView.height)];
    
    [contactPhoneNum.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [contactPhoneNum.layer setBorderWidth:1];
    contactPhoneNum.backgroundColor = [UIColor clearColor];
    [contactPhoneNum.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [contactPhoneNum setTitle:@"联系电话" forState:UIControlStateNormal];
    [contactPhoneNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headView addSubview:contactPhoneNum];
    
    return headView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<=infoListArray.count) {
        static NSString *cellId = @"lookingForMore";
        ztOAContactsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[ztOAContactsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        
        ztOAAddressBook *addressBook = (ztOAAddressBook *)[arrayContactsInfo objectAtIndex:indexPath.row];
        [cell.contactName setTitle:[NSString stringWithFormat:@"%@",addressBook.nameStr] forState:UIControlStateNormal];
        [cell.contactPhoneNum setTitle:[NSString stringWithFormat:@"%@",addressBook.mobilePhoneStr] forState:UIControlStateNormal];
        cell.contactName.tag = 1000+indexPath.row;
        [cell.contactName addTarget:self action:@selector(goToDetailInfoView:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contactPhoneNum addEventHandler:^(id sender){
            [self toPhotoNumber:cell.contactPhoneNum.currentTitle];
        } forControlEvents:UIControlEventTouchUpInside];
        
        if ([[arrayFlags objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            [cell.selecteBtn setSelected:NO];
        }else{
            [cell.selecteBtn setSelected:YES];
        }
        cell.selecteBtn.tag = 1000+indexPath.row;
        [cell.selecteBtn addTarget:self action:@selector(btnValueChange:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else
    {
        static NSString *cellId = @"lookingForMore";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
        lab.backgroundColor = [UIColor clearColor];
        [lab setTextColor:[UIColor blackColor]];
        lab.text = @"";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:14.0f];
        [cell addSubview:lab];
        return cell;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (infoListArray.count!=0) {
        if (isLoadFinish==YES) {
            return infoListArray.count;
        }
        else
        {
            return infoListArray.count+1;
        }
    }
    else{
        return 0;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row<infoListArray.count) {
        
    }
    else
    {
        if (searchCompanyLab.text.length==0 && searchNameLab.text.length==0) {
            [self loadTableDate:@""];
            return;
        }
        
        NSString *searchStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strxm>%@</strxm><sttbm>%@</sttbm><sttgxbz>%@</sttgxbz></root>",searchNameLab.text?:@"",searchCompanyLab.text?:@"",@"1"];
        [self loadTableDate:searchStr];
    }
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
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
