//
//  ztOANewBookListVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/2.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOANewBookListVC.h"
#import "ztOAABModel.h"
#import "ztOAAddressBookItemCell.h"
#import "ztOANewDocTableViewCell.h"
#import "ztOAAddressBookDetailInfoViewController.h"
#import "ztOAContactCheckedActionBar.h"
@interface ztOANewBookListVC ()<UITableViewDelegate,UITableViewDataSource,longPressUpDelegate,UIActionSheetDelegate>
{
    NSMutableArray  *grouSetArray;//勾选中得群组
    NSMutableArray  *allData;//所有节点
    NSString        *lastTitle;
    NSString        *ryzTitle;
    int level;
    ztOAABModel     *longPressABModel;//长按cell数据
    
}
@property (nonatomic,strong)NSMutableArray      *dwNameArr;
@property (nonatomic,strong)NSMutableDictionary *storeDict;//组织机构保存字典
@property (nonatomic,strong)NSMutableArray      *lshArr;
@property (nonatomic,strong)UITableView *newbooklist_tb;//列表
@property(nonatomic,strong)ztOAContactCheckedActionBar  *checkTitleBar;//选中提示框bar
@end

@implementation ztOANewBookListVC
@synthesize newbooklist_tb,storeDict,lshArr,currentCompanylsh,dwNameArr,checkTitleBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    level = 0;
    lastTitle = @"";
    ryzTitle = @"";
    grouSetArray            = [[NSMutableArray alloc] init];
    dwNameArr=[[NSMutableArray alloc] init];
    allData= [[NSMutableArray alloc] init];
    storeDict = [[NSMutableDictionary alloc] init];
    lshArr = [[NSMutableArray alloc] init];
    newbooklist_tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    newbooklist_tb.delegate=self;
    newbooklist_tb.dataSource=self;
    [self.view addSubview:newbooklist_tb];
    self.checkTitleBar = [[ztOAContactCheckedActionBar alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    [self.checkTitleBar setHidden:YES];
    [self.checkTitleBar.closeBtn addTarget:self action:@selector(closeCheckTitleBar) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.loadAllToPhone addTarget:self action:@selector(loadAllMemberToPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.sendMessageToPhone addTarget:self action:@selector(sendMessageAllMember) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.cancelCheckedBtn addTarget:self action:@selector(cancelCheckedAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkTitleBar];
    
    [self loadDataWithCompanyLsh:currentCompanylsh andLoadType:0 andLevel:0];
    addN(@selector(checkedInsertAddressBook:), @"CELLCHECHEDUP");
    // Do any additional setup after loading the view.
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
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:key]];
            [newbooklist_tb reloadData];
            return;
        }
    }
    //数据没保存或者没有数据
    [self showWaitView];
    NSDictionary *sendData = [NSDictionary dictionaryWithObjectsAndKeys:aLsh, @"intdwlsh", @"3", @"strcxlx", @"", @"queryTermXML", nil];
    [ztOAService getDwTxlLxrListNoContionByzipNew:sendData Success:^(id result) {
        NSDictionary *resultDict = [result objectFromJSONData];
        if (allData.count > 0) {
            [allData removeAllObjects];
        }
        if ([[[resultDict objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
            [self replaceLshWithLsh:aLsh];
            NSArray *unitInfoData = [[resultDict objectForKey:@"root"] objectForKey:@"unitinfo"];
            NSArray *userInfoData = [[resultDict objectForKey:@"root"] objectForKey:@"userinfo"];
            
            //单位数据
            if (unitInfoData) {
                if ([unitInfoData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in unitInfoData) {
                        ztOAABModel *unitInfo = [[ztOAABModel alloc] init];
                        
                        
                        unitInfo.type = 2;
                        unitInfo.chrbz = @"0";
                        unitInfo.fullName = [dict objectForKey:@"strdwmc"];
                        unitInfo.shortName = [dict objectForKey:@"strdwjc"];
                        unitInfo.dwlsh = [dict objectForKey:@"intdwlsh"];
                        [allData addObject:unitInfo];
                    }
                } else{
                    ztOAABModel *unitInfo = [[ztOAABModel alloc] init];
                    unitInfo.type = 2;
                    unitInfo.chrbz = @"0";
                    unitInfo.fullName = [(NSDictionary *)unitInfoData objectForKey:@"strdwmc"];
                    unitInfo.shortName = [(NSDictionary *)unitInfoData objectForKey:@"strdwjc"];
                    unitInfo.dwlsh = [(NSDictionary *)unitInfoData objectForKey:@"intdwlsh"];
                    [allData addObject:unitInfo];
                }
            }
            
            //个人数据
            if (userInfoData) {
                if ([userInfoData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in userInfoData) {
                        ztOAABModel *userInfo = [[ztOAABModel alloc] init];
                        userInfo.type = 1;
                        userInfo.chrbz = @"1";
                        userInfo.fullName = [dict objectForKey:@"strryxm"];
                        userInfo.shortName = [dict objectForKey:@"strryxm"];
                        userInfo.dwlsh = [dict objectForKey:@"intrylsh"];
                        userInfo.intrylsh=[dict objectForKey:@"intrylsh"];
                        userInfo.strxm=[dict objectForKey:@"strryxm"];
                        userInfo.strdw=[dict objectForKey:@"strdw"];
                        if ([[dict objectForKey:@"strzwmc"] isKindOfClass:[NSArray class]]) {
                            NSArray *zw=[dict objectForKey:@"strzwmc"];
                            NSString *strzw = [zw componentsJoinedByString:@","];
                            userInfo.strzw=strzw;
                        }else
                        {
                            userInfo.strzw=[dict objectForKey:@"strzwmc"];
                        }
                        userInfo.stryddh=[NSString stringWithFormat:@"%@",[dict objectForKey:@"stryddh"]];
                        userInfo.strbgdh=[NSString stringWithFormat:@"%@",[dict objectForKey:@"strbgdh"]];
                        
                        [allData addObject:userInfo];
                    }
                } else{
                    ztOAABModel *userInfo = [[ztOAABModel alloc] init];
                    userInfo.type = 1;
                    userInfo.chrbz = @"1";
                    userInfo.fullName = [NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                    userInfo.shortName = [NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                    userInfo.dwlsh = [(NSDictionary *)userInfoData objectForKey:@"intrylsh"];
                    userInfo.intrylsh=[(NSDictionary *)userInfoData objectForKey:@"intrylsh"];
                    
                    userInfo.strxm=[NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                    userInfo.strdw=[NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strdw"]];
                    if ([[(NSDictionary *)userInfoData objectForKey:@"strzwmc"] isKindOfClass:[NSArray class]]) {
                        NSArray *zw=[(NSDictionary *)userInfoData objectForKey:@"strzwmc"];
                        NSString *strzw = [zw componentsJoinedByString:@","];
                         userInfo.strzw=strzw;
                    }else
                    {
                        userInfo.strzw=[(NSDictionary *)userInfoData objectForKey:@"strzwmc"];
                    }
                    userInfo.stryddh=[NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"stryddh"]];
                    userInfo.strbgdh=[NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strbgdh"]];
                    [allData addObject:userInfo];
                }
                
            }
        }
        NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
        [storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh]];
        [newbooklist_tb reloadData];
        [self closeWaitView];
    } Failed:^(NSError *error) {
        [self closeWaitView];
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
#pragma mark------------------返回上一级-------------
- (void)backToLastLevel:(id)sender{
    if (level == 0) {
        //已是第一页时，点击返回退出返回之前的页面
        [self.navigationController popViewControllerAnimated:YES];
    } else{
        level--;
        [allData removeAllObjects];
        NSString *lsh = [[lshArr objectAtIndex:level] objectForKey:[NSString stringWithFormat:@"level%d", level]];
        allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:[NSString stringWithFormat:@"level%d&lsh%@", level, lsh]]];
        lastTitle = level > 0? [[dwNameArr objectAtIndex:level - 1] objectForKey:[NSString stringWithFormat:@"level%d", level - 1]] : @"";
        [newbooklist_tb reloadData];
    }
}
- (void)setHeaderView:(UIView *)aView title:(NSString *)aTitle{
    [aView setFrame:CGRectMake(0, 0, self.view.width, 44)];
    [aView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setBackgroundImage:[self createImageWithColor:MF_ColorFromRGB(245, 245, 245)] forState:UIControlStateHighlighted];
    [backBtn setFrame:aView.frame];
    [backBtn addTarget:self action:@selector(backToLastLevel:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:backBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10,5, self.view.width-40, 30)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.text = aTitle;
    [backBtn addSubview:lab];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(lab.right + 1, 18, 25 / 2, 7)];
    [iconImg setImage:[UIImage imageNamed:@"arrow_up"]];
    [backBtn addSubview:iconImg];
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.width, 1)];
    [splitView setBackgroundColor:[UIColor lightGrayColor]];
    [aView addSubview:splitView];
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
    ztOAAddressBookItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ztOAAddressBookItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    ztOAABModel *addressItem = [[ztOAABModel alloc] init];
    addressItem = (ztOAABModel *)[allData objectAtIndex:indexPath.row];
    cell.name.text = addressItem.shortName;
    [cell.cellIcon setOrigin:CGPointMake(2+20, 7)];
    [cell.name setOrigin:CGPointMake(35+20, 5)];
    [cell.name setCenterY:22];
    [cell.companyName setOrigin:CGPointMake(35+20, 30)];
    [cell.checkedBtn setOrigin:CGPointMake(cell.name.right+5, 2)];
    cell.ABookCell = addressItem;
    [cell setChecked:addressItem.isCheckedUp];
    if (addressItem.type==2) {
        cell.upImg.hidden=NO;
        cell.checkedBtn.hidden=YES;
    }
    else
    {
        cell.upImg.hidden=YES;
        cell.checkedBtn.hidden=NO;
    }
    cell.delegate = self;
    return cell;
}
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ztOAABModel *info = [allData objectAtIndex:indexPath.row];
    if (info.type == 2) {   //2为单位
        [self setLastTitleAndDwNameArr:info.shortName];
        level++;
        [self loadDataWithCompanyLsh:info.dwlsh andLoadType:1 andLevel:level];
    } else{
        ztOAABModel *addressItem = [allData objectAtIndex:indexPath.row];
        ztOAAddressBookDetailInfoViewController *VC = [[ztOAAddressBookDetailInfoViewController alloc] initWithBook:addressItem];
        VC.title=@"通讯录详情";
        [self.navigationController pushViewController:VC animated:YES];
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
#pragma mark - longPressUpDelegate -
- (void)longPressUpLateAction:(ztOAABModel *)ABook
{
    longPressABModel = ABook;
    if (![ABook.stryddh isEqualToString:@""] || ![ABook.strbgdh isEqualToString:@""]) {
        //长按选择框
        UIActionSheet *longPressUpActionSheet = [[UIActionSheet alloc] initWithTitle:ABook.strxm delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"呼叫",@"发送短信",@"导入到通讯录", nil];
        [longPressUpActionSheet setFrame:CGRectMake(0, self.view.size.height-260, 320, 260)];
        longPressUpActionSheet.delegate = self;
        longPressUpActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [longPressUpActionSheet showInView:self.view];
    }
}
#pragma mark--------------- 勾选处理------------------
- (void)checkedInsertAddressBook:(NSNotification *)notify
{
    NSDictionary *bookDic = (NSDictionary *)[notify userInfo];
    NSString *ischecked = [bookDic objectForKey:@"ischecked"];
    ztOAABModel *bookModel = [[ztOAABModel alloc]init];
    bookModel.intrylsh = [bookDic objectForKey:@"intrylsh"];
    bookModel.strxm = [bookDic objectForKey:@"strxm"];
    bookModel.strdw = [bookDic objectForKey:@"strdw"];
    bookModel.strzw = [bookDic objectForKey:@"strzw"];
    bookModel.strbgdh = [bookDic objectForKey:@"strbgdh"];
    bookModel.stryddh = [bookDic objectForKey:@"stryddh"];
    bookModel.intdwpxh = [bookDic objectForKey:@"intdwpxh"];
    bookModel.intrypxh = [bookDic objectForKey:@"intrypxh"];
    
    NSLog(@"%@",notify);
    BOOL isAlreadyStay=NO;
    for (int i = 0;i<grouSetArray.count;i++) {
        ztOAABModel *model = [grouSetArray objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@",model.intrylsh] isEqualToString:[NSString stringWithFormat:@"%@", bookModel.intrylsh]]) {
            isAlreadyStay = YES;
            if (![ischecked isEqualToString:@"yes"]) {
                [grouSetArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    if ([ischecked isEqualToString:@"yes"] && isAlreadyStay == NO) {
        [grouSetArray addObject:bookModel];
    }
    NSLog(@"count==%d,%@",grouSetArray.count,grouSetArray);
    if (grouSetArray.count>0) {
        checkTitleBar.sendMsgNumLable.text = [NSString stringWithFormat:@"(%d)",grouSetArray.count];
        checkTitleBar.loadToPhoneNumLable.text = [NSString stringWithFormat:@"(%d)",grouSetArray.count];
        [self.checkTitleBar setHidden:NO];
    }
    else
    {
        [self.checkTitleBar setHidden:YES];
    }
    [newbooklist_tb reloadData];
}
- (void)closeCheckTitleBar
{
    [self.checkTitleBar setHidden:YES];
}
- (void)loadAllMemberToPhoto
{
    [self doLoadToPhone:grouSetArray];
    
}
- (void)sendMessageAllMember
{
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<grouSetArray.count; i++) {
        ztOAABModel *oneBook = (ztOAABModel *)[grouSetArray objectAtIndex:i];
        if (![oneBook.stryddh isEqualToString:@""]) {
            [phoneArray addObject:oneBook.stryddh];
        }
        
    }
    [self sendSMS:@"" recipientList:phoneArray];
}
//取消选择
- (void)cancelCheckedAll
{
    for (int i = 0; i <allData.count; i++) {
        ztOAABModel *modelBook = [allData objectAtIndex:i];
        modelBook.isCheckedUp = NO;
    }
    [grouSetArray removeAllObjects];
    [self.checkTitleBar setHidden:YES];
    [newbooklist_tb reloadData];
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
