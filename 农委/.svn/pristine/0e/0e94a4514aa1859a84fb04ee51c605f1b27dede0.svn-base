//
//  LBStatisticsViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 18/3/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LBStatisticsViewController.h"
#import "LBStatisticsCell.h"
#import "LBStatistDetailViewController.h"
#import "LBAddStatistViewController.h"
@interface LBStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *statist_tb;
@property (nonatomic,strong)NSMutableArray *statistAry;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,strong)NSString *strryxm;
@end
#define pageRows 10
@implementation LBStatisticsViewController
@synthesize statist_tb,statistAry,currentPage,strryxm;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSString *tjbgn= [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"tjbgn"];
    if([tjbgn containsString:@"统计表新增"]){
        [self rightButton:@"添加" image:nil sel:@selector(AddSEL:)];
    }
    strryxm=@"";
    statistAry=[[NSMutableArray alloc]init];
    statist_tb=[[UITableView alloc]initWithFrame:self.view.bounds];
    statist_tb.showsVerticalScrollIndicator=NO;
    statist_tb.dataSource=self;
    statist_tb.delegate=self;
    statist_tb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:statist_tb];
    [SVProgressHUD showWithStatus:@"加载中..."];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    statist_tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [statist_tb.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}
#pragma mark-----------数据加载------
-(void)loadNewData{
    currentPage=1;
    [SHNetWork getTjb:@"" strryxm:strryxm dtmfbsj1:@"" dtmfbsj2:@"" intCurrentPage:@(currentPage) intPageRows:@(pageRows) completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    if (tempary.count==pageRows) {
                        __unsafe_unretained __typeof(self) weakSelf = self;
                        statist_tb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf loadMoreData];
                        }];
                    }
                     statistAry=[[NSMutableArray alloc]initWithArray:tempary];
                    [statist_tb reloadData];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
        [statist_tb.mj_header endRefreshing];
    }];
}

-(void)loadMoreData
{
    currentPage++;
    [SHNetWork getTjb:@"" strryxm:strryxm dtmfbsj1:@"" dtmfbsj2:@"" intCurrentPage:@(currentPage) intPageRows:@(pageRows) completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count<pageRows) {
                    statist_tb.mj_footer=nil;
                }
                [statistAry addObjectsFromArray:tempary];
                [statist_tb reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
        [statist_tb.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return statistAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    LBStatisticsCell *cell = (LBStatisticsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LBStatisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic =[statistAry objectAtIndex:indexPath.row];
    cell.statisticsDic=dic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[statistAry objectAtIndex:indexPath.row];
    LBStatistDetailViewController *statisedetial=[[LBStatistDetailViewController alloc]init];
    statisedetial.title=@"统计表详情";
    statisedetial.inttjblsh=[NSString stringWithFormat:@"%@",dic[@"inttjblsh"]];
    [self.navigationController pushViewController:statisedetial animated:YES];
}
#pragma mark-------------统计表添加--------
-(void)AddSEL:(UIButton*)sender{
    LBAddStatistViewController *lbaddstatist=[[LBAddStatistViewController alloc]init];
    lbaddstatist.title=@"添加统计表";
    lbaddstatist.callback= ^(BOOL issu){
        if (issu) {
            [statist_tb.mj_header beginRefreshing];
        }
    };
    [self.navigationController pushViewController:lbaddstatist animated:YES];
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
