//
//  ZtOAFlowPersonVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/9.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "MultFlowPersonVC.h"
#import "AddUserInfo.h"
#import "AddressBookCell.h"
@interface MultFlowPersonVC ()<UITableViewDelegate,UITableViewDataSource,longPressUpDelegate>
{
    NSMutableArray  *allData;//所有节点
    NSString *strnextgzrylx;
}
@property (nonatomic,strong)UITableView *flow_tb;
@end

@implementation MultFlowPersonVC
@synthesize selectary,processOpr,flow_tb;
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
    if (selectary.count==0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    self.callback(selectary,self.storeDict);
    [self.navigationController popViewControllerAnimated:YES];
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
        [self networkall:@"document" requestMethod:@"getKsbwFlclzdxxx" requestHasParams:@"true" parameter:@{@"intgzlclsh":self.intgzlclsh,@"intrylsh":@(SingObj.userInfo.intrylsh),@"strryxm":SingObj.userInfo.username,@"intbzjllsh":processOpr[@"intbzjllsh"],@"intcsdwlsh":@(SingObj.unitInfo.intdwlsh_child),@"xtDwlsh":@(SingObj.unitInfo.intdwlsh),@"dwccbm":@(SingObj.unitInfo.dwccbm),@"intnextgzlclsh":processOpr[@"intnextgzlclsh"],@"intlcczlsh":processOpr[@"intlcczlsh"]} progresHudText:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSDictionary *resultDict = rep;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allData.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
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
    cell.delegate=self;
    return cell;
}
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
