//
//  ztOAZdcyVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOAZdcyVC.h"
#import "ztOAAddressBookItemCell.h"

@interface ztOAZdcyVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray  *allData;//所有节点
    NSString        *lastTitle;
    NSString        *ryzTitle;
    int level;
    ztOAABModel     *longPressABModel;//长按cell数据
}
@property (nonatomic,strong)UITableView *zdcy_tb;//
@property (nonatomic,strong)NSMutableArray *zdcy_list;//指定列表
@property (nonatomic,strong)NSMutableArray      *dwNameArr;

@property (nonatomic,strong)NSMutableArray      *lshArr;
@end

@implementation ztOAZdcyVC
@synthesize zdcy_tb,zdcy_list,dwNameArr,lshArr,selectary,currentCompanylsh,processOpr;
-(id)init:(NSString*)title selectAry:(NSMutableArray*)selectAry storeDict:(NSMutableDictionary*)storeDict;
{
    self=[super init];
    if (self) {
        self.title=title;
        selectary=selectAry;
        self.storeDict=storeDict;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"确定" Sel:@selector(okSEL:)];
    level = 0;
    lastTitle = @"";
    ryzTitle = @"";
    dwNameArr=[[NSMutableArray alloc] init];
    allData= [[NSMutableArray alloc] init];
    lshArr = [[NSMutableArray alloc] init];
    zdcy_tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    zdcy_tb.delegate=self;
    zdcy_tb.dataSource=self;
    [self.view addSubview:zdcy_tb];
    addN(@selector(checkedInsertAddressBook:), @"CELLCHECHEDUP");
    [self loadDataWithCompanyLsh:currentCompanylsh andLoadType:0 andLevel:0];
    // Do any additional setup after loading the view.
}
- (void)selectedPersonCallback:(void (^)(NSMutableArray * selectAry,NSMutableDictionary *storeDict))callback {
    self.callback = callback;
}
/**
 *  通过单位流水号获取信息
 *
 */
- (void)loadDataWithCompanyLsh:(NSString *)aLsh andLoadType:(int)aType andLevel:(int)aLevel{
    //已有数据，无需重新请求
    for (NSString *key in [ self.storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh] isEqualToString:key]) {
            [self replaceLshWithLsh:aLsh];
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[ self.storeDict objectForKey:key]];
            [zdcy_tb reloadData];
            return;
        }
    }
    //数据没保存或者没有数据
    [self showWaitView];
    NSDictionary *sendData = @{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"strryxm":[ztOAGlobalVariable sharedInstance].username,@"intcsdwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"dwccbm":[ztOAGlobalVariable sharedInstance].dwccbm,@"intact":processOpr[@"intact"],@"intlcczlsh":processOpr[@"intlcczlsh"],@"intbzjllsh":processOpr[@"intlcczlsh"],@"xtDwlsh":aLsh};
    [ztOAService getZdcydxxx:sendData Success:^(id result) {
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
        [self.storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh]];
        [zdcy_tb reloadData];
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
        allData = [NSMutableArray arrayWithArray:[self.storeDict objectForKey:[NSString stringWithFormat:@"level%d&lsh%@", level, lsh]]];
        lastTitle = level > 0? [[dwNameArr objectAtIndex:level - 1] objectForKey:[NSString stringWithFormat:@"level%d", level - 1]] : @"";
        [zdcy_tb reloadData];
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
    //cell.delegate = self;
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
    for (int i = 0;i<selectary.count;i++) {
        ztOAABModel *model = [selectary objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@",model.intrylsh] isEqualToString:[NSString stringWithFormat:@"%@", bookModel.intrylsh]]) {
            isAlreadyStay = YES;
            if (![ischecked isEqualToString:@"yes"]) {
                [selectary removeObjectAtIndex:i];
                break;
            }
        }
    }
    if ([ischecked isEqualToString:@"yes"] && isAlreadyStay == NO) {
        [selectary addObject:bookModel];
    }
    NSLog(@"count==%d,%@",selectary.count,selectary);
    [zdcy_tb reloadData];
}
#pragma mark------------确定选择---------------
-(void)okSEL:(UIButton*)sender
{
    self.callback(selectary,self.storeDict);
    [self.navigationController popViewControllerAnimated:YES];
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
