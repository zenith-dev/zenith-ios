//
//  AddressBookListVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "AddressBookListVC.h"
#import "AddressBookCell.h"
#import "AddUnitInfo.h"
#import "AddUserInfo.h"
#import "ztOAContactCheckedActionBar.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "AddressBookHelper.h"
#import "AddressBookDetailVC.h"
@interface AddressBookListVC ()<UITableViewDelegate,UITableViewDataSource,longPressUpDelegate,MFMessageComposeViewControllerDelegate>
{
    int level;
    NSString *lastTitle;
}
@property(nonatomic,strong)ztOAContactCheckedActionBar  *checkTitleBar;//选中提示框bar
@property (nonatomic,strong)UITableView *newbooklist_tb;
@property (nonatomic,strong)NSMutableArray *lshArr;
@property (nonatomic,strong)NSMutableDictionary *storeDict;//组织机构保存字典
@property (nonatomic,strong)NSMutableArray *dwNameArr;
@property (nonatomic,strong) NSMutableArray  *allData;//所有节点
@property (nonatomic,strong) NSMutableArray *grouSetArray;
@end

@implementation AddressBookListVC
@synthesize newbooklist_tb,storeDict,allData,lshArr,currentCompanylsh,dwNameArr,checkTitleBar,grouSetArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    level = 0;
    allData=[[NSMutableArray alloc]init];
    dwNameArr=[[NSMutableArray alloc] init];
    lshArr=[[NSMutableArray alloc]init];
    storeDict=[[NSMutableDictionary alloc]init];
    newbooklist_tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    newbooklist_tb.delegate=self;
    newbooklist_tb.dataSource=self;
    [self.view addSubview:newbooklist_tb];
    [self loadDataWithCompanyLsh:currentCompanylsh andLoadType:0 andLevel:0];
    
    checkTitleBar = [[ztOAContactCheckedActionBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
    [checkTitleBar setHidden:YES];
    [checkTitleBar.closeBtn addTarget:self action:@selector(closeCheckTitleBar) forControlEvents:UIControlEventTouchUpInside];
    [checkTitleBar.loadAllToPhone addTarget:self action:@selector(loadAllMemberToPhoto) forControlEvents:UIControlEventTouchUpInside];
    [checkTitleBar.sendMessageToPhone addTarget:self action:@selector(sendMessageAllMember) forControlEvents:UIControlEventTouchUpInside];
    [checkTitleBar.cancelCheckedBtn addTarget:self action:@selector(cancelCheckedAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkTitleBar];
    // Do any additional setup after loading the view.
}
- (void)closeCheckTitleBar
{
    [self.checkTitleBar setHidden:YES];
}
- (void)loadAllMemberToPhoto{
    if (grouSetArray.count==0) {
        [self showMessage:@"请选择人员"];
        return;
    }
    AddUserInfo *copyuserInfo;
    BOOL flag=NO;
    for (AddUserInfo *userInfo in grouSetArray) {
        if ([userInfo isKindOfClass:[AddUserInfo class]]) {
            NSString *dhstr=[NSString stringWithFormat:@"%@",userInfo.stryddh];
            if ([AddressBookHelper existPhone:dhstr] == ABHelperExistSpecificContact)
            {
                continue;
            }
            if([AddressBookHelper addContactName:userInfo.strryxm phoneNum:dhstr withLabel:@"电话" strdw:userInfo.strdw strzw:userInfo.strzwmc]==NO){
                copyuserInfo =userInfo;
                flag=YES;
                break;
            };
        }
    }
    if (flag==YES) {
        [self showMessage:[NSString stringWithFormat:@"%@导入通讯录失败!",copyuserInfo.strryxm]];
    }else
    {
         [self showMessage:@"导入通讯录成功!"];
    }
    
}
-(void)sendMessageAllMember{
    
    if (grouSetArray.count==0) {
        [self showMessage:@"请选择人员"];
        return;
    }
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    for (AddUserInfo *userInfo in grouSetArray) {
        if ([userInfo isKindOfClass:[AddUserInfo class]]) {
            NSString *dhstr=[NSString stringWithFormat:@"%@",userInfo.stryddh];
            if (dhstr.length==0) {
                return;
            }
            [phoneArray addObject:dhstr];
        }
    }
    [self sendSMS:@"" recipientList:phoneArray];
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
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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


-(void)cancelCheckedAll{
    NSArray *allV=[storeDict allValues];
    for (id addBook in allV) {
        if ([addBook isKindOfClass:[NSArray class]]) {
            for (id addinfo in addBook) {
                if ([addinfo isKindOfClass:[AddUserInfo class]]) {
                    AddUserInfo *adduser=(AddUserInfo*)addinfo;
                    if (adduser.selectFlg==YES) {
                        adduser.selectFlg=NO;
                    }
                }
            }
        }
    }
    checkTitleBar.sendMsgNumLable.text = @"";
    checkTitleBar.loadToPhoneNumLable.text = @"";
    [newbooklist_tb reloadData];
}
/**
 *  通过单位流水号获取信息
 *
 */
- (void)loadDataWithCompanyLsh:(NSString *)aLsh andLoadType:(int)aType andLevel:(int)aLevel{
    //已有数据，无需重新请求
    for (NSString *key in [storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh] isEqualToString:key]) {
            [self replaceLshWithLsh:aLsh];
            allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:key]];
            [newbooklist_tb reloadData];
            return;
        }
    }
     NSString *xml =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strdwccbm>%@</strdwccbm></root>",@(SingObj.unitInfo.dwccbm)];
     NSDictionary *sendData = [NSDictionary dictionaryWithObjectsAndKeys:aLsh, @"intdwlsh", @"3", @"strcxlx", xml, @"queryTermXML", nil];
    [self network:@"lxrservices" requestMethod:@"getDwTxlLxrListNoContionByzipNew" requestHasParams:@"true" parameter:sendData progresHudText:@"获取中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            [self replaceLshWithLsh:aLsh];
            NSArray *unitInfoData = [rep objectForKey:@"unitinfo"];
            NSArray *userInfoData = [rep objectForKey:@"userinfo"];
            allData =[[NSMutableArray alloc]init];
            if (unitInfoData) {
                if ([unitInfoData isKindOfClass:[NSDictionary class]]) {
                    AddUnitInfo *unitInfo=[AddUnitInfo mj_objectWithKeyValues:unitInfoData];
                    [allData addObject:unitInfo];
                }else if ([unitInfoData isKindOfClass:[NSArray class]])
                {
                    NSArray *unitary=[AddUnitInfo mj_objectArrayWithKeyValuesArray:unitInfoData];
                    [allData addObjectsFromArray:unitary];
                }
            }
            if (userInfoData) {
                if ([userInfoData isKindOfClass:[NSDictionary class]]) {
                    AddUserInfo *userInfo=[AddUserInfo mj_objectWithKeyValues:userInfoData];
                    [allData addObject:userInfo];
                }else if ([userInfoData isKindOfClass:[NSArray class]])
                {
                    NSArray *userary=[AddUserInfo mj_objectArrayWithKeyValuesArray:userInfoData];
                    [allData addObjectsFromArray:userary];
                }
            }
        }
        // NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
        [storeDict setObject:allData forKey:[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh]];
        [newbooklist_tb reloadData];
    }];
}
- (void)replaceLshWithLsh:(NSString *)aLsh{
    NSDictionary *lshDict = [NSDictionary dictionaryWithObject:aLsh forKey:[NSString stringWithFormat:@"level%d", level]];
    if (lshArr.count == 0) {
        [lshArr addObject:lshDict];
    } else{
        for (int i = 0; i < lshArr.count; i++) {
            NSDictionary *dict = [lshArr objectAtIndex:i];
            if ([[[dict allKeys] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"level%d", level]]) {
                [lshArr replaceObjectAtIndex:i withObject:lshDict];
                break;
            } else{
                if (i == lshArr.count - 1) {
                    [lshArr addObject:lshDict];
                }
            }
        }
    }
}
#pragma mark-------------------UITableViewDelegate---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allData.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    if (level != 0) {
        [self setHeaderView:sectionView title:lastTitle];
    }else{
        [sectionView setBackgroundColor:[UIColor clearColor]];
    }
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (level == 0) {
        return 0.01;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addressId";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if ([allData[indexPath.row] isKindOfClass:[AddUnitInfo class]])
    {
        AddUnitInfo *aunit=allData[indexPath.row];
        cell.addUnitInfo=aunit;
    }else if(([allData[indexPath.row] isKindOfClass:[AddUserInfo class]]))
    {
        AddUserInfo *auserInfo=allData[indexPath.row];
        cell.addUserInfo=auserInfo;
    }
    cell.delegate=self;
    return cell;
}
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([allData[indexPath.row] isKindOfClass:[AddUnitInfo class]])
    {
        AddUnitInfo *aunit=allData[indexPath.row];
        [self setLastTitleAndDwNameArr:aunit.strdwjc];
        level++;
        [self loadDataWithCompanyLsh:[NSString stringWithFormat:@"%@",@(aunit.intdwlsh)] andLoadType:1 andLevel:level];
    }else if([allData[indexPath.row] isKindOfClass:[AddUserInfo class]])
    {
        AddressBookDetailVC *addressBookdetaivc=[[AddressBookDetailVC  alloc]initWithTitle:@"个人信息"];
        AddUserInfo *auser=allData[indexPath.row];

        addressBookdetaivc.adduserInfo=auser;
        [self.navigationController pushViewController:addressBookdetaivc animated:YES];
    }
}
- (void)setLastTitleAndDwNameArr:(NSString *)dwName{
    NSDictionary *dwNameDict = [NSDictionary dictionaryWithObject:dwName forKey:[NSString stringWithFormat:@"level%d", level]];
    if (dwNameArr.count == 0) {
        [dwNameArr addObject:dwNameDict];
    } else{
        for (int i = 0; i < dwNameArr.count; i++) {
            NSDictionary *dict = [dwNameArr objectAtIndex:i];
            if ([[[dict allKeys] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"level%d", level]]) {
                [dwNameArr replaceObjectAtIndex:i withObject:dwNameDict];
                break;
            } else{
                if (i == dwNameArr.count - 1) {
                    [dwNameArr addObject:dwNameDict];
                }
            }
        }
    }
    lastTitle = dwName;
}
- (void)setHeaderView:(UIView *)aView title:(NSString *)aTitle{
    [aView setFrame:CGRectMake(0, 0, self.view.width, 44)];
    [aView setBackgroundColor:[UIColor whiteColor]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setBackgroundImage:[self createImageWithColor:RGBCOLOR(245, 245, 245)] forState:UIControlStateHighlighted];
    [backBtn setFrame:aView.frame];
    [backBtn addTarget:self action:@selector(backToLastLevel:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:backBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10,5, self.view.width-40, 30)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.text = aTitle;
    [backBtn addSubview:lab];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 24, 24)];
    iconImg.left=kScreenWidth-34;
    [iconImg setImage:[UIImage imageNamed:@"icon_arrow_up"]];
    [backBtn addSubview:iconImg];
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.width, 1)];
    [splitView setBackgroundColor:[UIColor lightGrayColor]];
    [aView addSubview:splitView];
}
#pragma mark------------------返回上一级-------------
- (void)backToLastLevel:(id)sender{
    if (level == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        level--;
        NSString *lsh = [[lshArr objectAtIndex:level] objectForKey:[NSString stringWithFormat:@"level%d", level]];
        allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:[NSString stringWithFormat:@"level%d&lsh%@", level, lsh]]];
        lastTitle = level > 0? [[dwNameArr objectAtIndex:level - 1] objectForKey:[NSString stringWithFormat:@"level%d", level - 1]] : @"";
        [newbooklist_tb reloadData];
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(void)longPressUpLateAction
{
   grouSetArray=[[NSMutableArray alloc]init];
   NSArray *allV=[storeDict allValues];
    for (id addBook in allV) {
        if ([addBook isKindOfClass:[NSArray class]]) {
            for (id addinfo in addBook) {
                if ([addinfo isKindOfClass:[AddUserInfo class]]) {
                    AddUserInfo *adduser=(AddUserInfo*)addinfo;
                    if (adduser.selectFlg==YES) {
                        [grouSetArray addObject:adduser];
                    }
                }
            }
        }
    }
    if (grouSetArray.count>0) {
        checkTitleBar.sendMsgNumLable.text = [NSString stringWithFormat:@"(%@)",@(grouSetArray.count)];
        checkTitleBar.loadToPhoneNumLable.text = [NSString stringWithFormat:@"(%@)",@(grouSetArray.count)];
        [self.checkTitleBar setHidden:NO];
    }
    else
    {
        [self.checkTitleBar setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
