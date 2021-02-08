//
//  LBUnitChooseViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 16/4/22.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBUnitChooseViewController.h"
#import "LBUnitChooseTableViewCell.h"
#import "UnitModel.h"
#import "RyModel.h"
#import "QCheckBox.h"
#import "LBForwardingViewController.h"
@interface LBUnitChooseViewController ()<UITableViewDataSource,UITableViewDelegate,QCheckBoxDelegate>
@property(nonatomic,strong)NSMutableArray *unitary;//单位数据
@end

@implementation LBUnitChooseViewController
@synthesize unitTb,unitary,chrdwccbm,selcetAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"确定" image:nil sel:@selector(OKSEL:)];
    [SVProgressHUD showWithStatus:@"加载中..."];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    unitTb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [unitTb.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadNewData{
    [SHNetWork getDepartmentAndPeople:chrdwccbm completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                unitary=[[NSMutableArray alloc]init];
                NSMutableArray *ryarys=[[NSMutableArray alloc]initWithArray:rep[@"data"][@"rylist"]];
                NSMutableArray *unitarys=[[NSMutableArray alloc]initWithArray:rep[@"data"][@"dwlist"]];
                for (NSDictionary *rydic in ryarys) {
                    RyModel *rymodel=[RyModel mj_objectWithKeyValues:rydic];
                    rymodel.isCheck=NO;
                    for (RyModel *serymodel in selcetAry) {
                        if ([serymodel.intrylsh isEqualToString:rymodel.intrylsh]) {
                            rymodel.isCheck=YES;
                            break;
                        }
                    }
                    [unitary addObject:rymodel];
                }
                for (NSDictionary *unitdic in unitarys) {
                    UnitModel *unitmodel=[UnitModel mj_objectWithKeyValues:unitdic];
                    [unitary addObject:unitmodel];
                }
                [SVProgressHUD dismiss];
                [unitTb reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
        [unitTb.mj_header endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return unitary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *endCellIdentifier = @"LBUnitChooseTableViewCell";
    LBUnitChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:endCellIdentifier];
    if (cell == nil) {
        cell = [[LBUnitChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([unitary[indexPath.row] isKindOfClass:[UnitModel class]]) {
        cell.rycheckBox.hidden=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UnitModel *unitModel=unitary[indexPath.row];
        cell.textLabel.text=unitModel.strdwjc;
        cell.textLabel.font=Font(14);
    }
    else
    {
        cell.rycheckBox.hidden=NO;
        RyModel *rymodel=unitary[indexPath.row];
        cell.rycheckBox.checked=rymodel.isCheck;
        cell.rycheckBox.tag=indexPath.row;
        [cell.rycheckBox setTitle:rymodel.strryxm forState:UIControlStateNormal];
        cell.rycheckBox.delegate=self;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([unitary[indexPath.row] isKindOfClass:[UnitModel class]]) {
        UnitModel *unitModel=unitary[indexPath.row];
        LBUnitChooseViewController *lbunitv=[[LBUnitChooseViewController alloc]init];
        lbunitv.chrdwccbm=unitModel.strdwccbm;
        lbunitv.title=@"选择人员";
        lbunitv.selcetAry=selcetAry;
        [self.navigationController pushViewController:lbunitv animated:YES];
    }
}
-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    RyModel *rymodel=unitary[checkbox.tag];
    if (checked==YES) {
        rymodel.isCheck=YES;
        [selcetAry addObject:rymodel];
    }
    else
    {
        rymodel.isCheck=NO;
        [selcetAry removeObject:rymodel];
    }
}
#pragma mark------------确定选择人员------------
-(void)OKSEL:(UIButton*)sender
{
    for (UIViewController *views in self.navigationController.viewControllers) {
        if ([views isKindOfClass:[LBForwardingViewController class]]) {
            LBForwardingViewController *lbforward=(LBForwardingViewController*)views;
            lbforward.selectryary=selcetAry;
            [self.navigationController popToViewController:lbforward animated:YES];
            break;
        }
    }
}
-(void)backPage
{
    if ([self.navigationController.viewControllers[self.navigationController.viewControllers.count-1] isKindOfClass:[LBUnitChooseViewController class]]) {
        LBUnitChooseViewController *unitchoose=self.navigationController.viewControllers[self.navigationController.viewControllers.count-1];
        unitchoose.selcetAry=selcetAry;
    }
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
