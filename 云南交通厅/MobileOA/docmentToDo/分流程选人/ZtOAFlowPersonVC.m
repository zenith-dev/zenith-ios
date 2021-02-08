//
//  ZtOAFlowPersonVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/9.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ZtOAFlowPersonVC.h"
#import "AddUserInfo.h"
#import "AddUnitInfo.h"
#import "AddressBookCell.h"
@interface ZtOAFlowPersonVC ()<UITableViewDelegate,UITableViewDataSource,longPressUpDelegate>
{
    NSMutableArray  *allData;//所有节点
    NSString *strnextgzrylx;
    int level;
    NSMutableArray *lshArr;
    NSString        *lastTitle;
    
}
@property (nonatomic,strong)UITableView *flow_tb;
@property (nonatomic,strong)NSMutableArray      *dwNameArr;
@end

@implementation ZtOAFlowPersonVC
@synthesize selectary,processOpr,flow_tb,dwNameArr;
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
    level = 0;
    lastTitle=@"";
    
    lshArr = [[NSMutableArray alloc] init];
    [self rightButton:@"确定" image:nil sel:@selector(okSEL:)];
    flow_tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    flow_tb.delegate=self;
    flow_tb.dataSource=self;
    [self.view addSubview:flow_tb];
    allData=[[NSMutableArray alloc]init];
    [self getFlclzdxxx];
    // Do any additional setup after loading the view.
}
#pragma mark------------确定选择---------------
-(void)okSEL:(UIButton*)sender
{
    NSString *zrdxdx=[NSString stringWithFormat:@"%@",[processOpr objectForKey:@"zRdxdx"]?:@""];//责任人对象是否多选 1是单选 2是多选
    if ([zrdxdx intValue]==1&&selectary.count>1) {
        [self showMessage:@"只能选择一个处理人"];
        return;
    }
    self.callback(selectary,self.storeDict);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--------------递归遍历NSDictionary-------------
- (NSString *)stringFormDict:(NSDictionary*)dict
 {
     NSMutableString *str = [NSMutableString string];
     NSArray *keys = [dict allKeys];
     for (NSString *key in keys) {
         if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
             id obj = [dict objectForKey:key];
             [str appendFormat:@"\n%@: %@",key,[self stringFormDict:obj]];
         }else if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]){
             [str appendFormat:@"\n%@:",key];
             for (id obj in [dict objectForKey:key]) {
                 [str appendFormat:@"\n%@",[self stringFormDict:obj]];
             }
         }else{
             [str appendFormat:@"\n%@: %@",key,[dict objectForKey:key]];
         }
     }
     return str;

 }



#pragma mark--------------获取人员列表-------------
-(void)getFlclzdxxx
{
    //已有数据，无需重新请求
    for (NSString *key in [self.storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", 0, @"0"] isEqualToString:key]) {
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[ self.storeDict objectForKey:key]];
            [flow_tb reloadData];
            return;
        }
    }
    [self networkall:@"document" requestMethod:@"getFlclzdxxx" requestHasParams:@"true" parameter:@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"strryxm":SingObj.userInfo.username,@"intbzjllsh":processOpr[@"intbzjllsh"],@"intcsdwlsh":@(SingObj.unitInfo.intdwlsh_child),@"xtDwlsh":@(SingObj.unitInfo.intdwlsh),@"dwccbm":@(SingObj.unitInfo.dwccbm),@"intnextgzlclsh":processOpr[@"intnextgzlclsh"],@"intlcczlsh":processOpr[@"intlcczlsh"]} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSDictionary *resultDict = rep;
            NSString* res = [self stringFormDict:resultDict];
            NSLog(@"结果==%@",res);
            if([resultDict[@"root"][@"flcxx"][@"strxsry"]intValue]==0){
                strnextgzrylx=[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strnextgzrylx"];
                NSArray *userInfoData = [[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strzdryc"] objectForKey:@"ryinfo"];
                if ([userInfoData isKindOfClass:[NSDictionary class]]) {
                    AddUserInfo *userInfo=[AddUserInfo mj_objectWithKeyValues:userInfoData];
                    [allData addObject:userInfo];
                }else if ([userInfoData isKindOfClass:[NSArray class]])
                {
                    NSArray *userary=[AddUserInfo mj_objectArrayWithKeyValuesArray:userInfoData];
                    [allData addObjectsFromArray:userary];
                }
                NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
                [self.storeDict setObject:strnextgzrylx?:@"" forKey:@"strnextgzrylx"];
                [self.storeDict setObject:[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"intnextgzrylsh"] forKey:@"intnextgzrylsh"];
                
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"strzrrlxLst"] forKey:@"strzrrlxLst"];
                
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intgzlclshlst"] forKey:@"intgzlclshlst"];
                
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbzlst"] forKey:@"intbzlst"];
                
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbcbhlst"] forKey:@"intbcbhlst"];
                [self.storeDict setObject:[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strwcbz"] forKey:@"strwcbz"];
                [self.storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", 0, @"0"]];
                [flow_tb reloadData];
            }else{
                NSArray *unitinfoData = [[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strzdryc"] objectForKey:@"unitinfo"];
                strnextgzrylx=[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strnextgzrylx"];
                if ([unitinfoData isKindOfClass:[NSDictionary class]]) {
                    AddUnitInfo *userInfo=[AddUnitInfo mj_objectWithKeyValues:unitinfoData];
                    [allData addObject:userInfo];
                }else if ([unitinfoData isKindOfClass:[NSArray class]])
                {
                    NSArray *userary=[AddUnitInfo mj_objectArrayWithKeyValuesArray:unitinfoData];
                    [allData addObjectsFromArray:userary];
                }
                [self.storeDict setObject:allData forKey:[NSString stringWithFormat:@"level%d&lsh%@", 0, @"2016100178"]];
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbzlst"] forKey:@"intbzlst"];
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intgzlclshlst"] forKey:@"intgzlclshlst"];
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbcbhlst"] forKey:@"intbcbhlst"];
                [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"strzrrlxLst"] forKey:@"strzrrlxLst"];
                [self.storeDict setObject:strnextgzrylx?:@"" forKey:@"strnextgzrylx"];
                
                [self replaceLshWithLsh:@"2016100178"];
                [flow_tb reloadData];
            }
        }
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (level == 0) {
        return 0.01;
    }
    return 44;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addressId";
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if(([allData[indexPath.row] isKindOfClass:[AddUserInfo class]]))
    {
        AddUserInfo *auserInfo=allData[indexPath.row];
        cell.addUserInfo=auserInfo;
    }
    else if([allData[indexPath.row] isKindOfClass:[AddUnitInfo class]])
    {
        AddUnitInfo *aunit=allData[indexPath.row];
        cell.addUnitInfo=aunit;
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
    }
    
}
/**
 *  通过单位流水号获取信息
 *
 */
- (void)loadDataWithCompanyLsh:(NSString *)aLsh andLoadType:(int)aType andLevel:(int)aLevel{
    //已有数据，无需重新请求
    for (NSString *key in [self.storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh] isEqualToString:key]) {
            [self replaceLshWithLsh:aLsh];
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[ self.storeDict objectForKey:key]];
            [flow_tb reloadData];
            return;
        }
    }
    
    [self networkall:@"document" requestMethod:@"getZdcydxxx" requestHasParams:@"true" parameter:@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"strryxm":SingObj.userInfo.username,@"intcsdwlsh":@(SingObj.unitInfo.intdwlsh_child),@"dwccbm":@(SingObj.unitInfo.dwccbm),@"intact":processOpr[@"intact"],@"intlcczlsh":processOpr[@"intlcczlsh"],@"intbzjllsh":processOpr[@"intlcczlsh"],@"xtDwlsh":aLsh} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSDictionary *resultDict=rep;
            allData =[[NSMutableArray alloc]init];
            if ([[[resultDict objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
                [self replaceLshWithLsh:aLsh];
                NSArray *unitInfoData = [rep[@"root"] objectForKey:@"unitinfo"];
                NSArray *userInfoData = [rep[@"root"] objectForKey:@"userinfo"];
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
            NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
            [self.storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh]];
            [flow_tb reloadData];
        }
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


-(void)longPressUpLateAction
{
    selectary=[[NSMutableArray alloc]init];
    NSArray *allV=[self.storeDict allValues];
    for (id addBook in allV) {
        if ([addBook isKindOfClass:[NSArray class]]) {
            for (id addinfo in addBook) {
                if ([addinfo isKindOfClass:[AddUserInfo class]]) {
                    AddUserInfo *adduser=(AddUserInfo*)addinfo;
                    if (adduser.selectFlg==YES) {
                        [selectary addObject:adduser];
                    }
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
        [flow_tb reloadData];
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
- (void)selectedPersonCallback:(void (^)(NSMutableArray * selectAry,NSMutableDictionary *storeDict))callback {
    self.callback = callback;
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
