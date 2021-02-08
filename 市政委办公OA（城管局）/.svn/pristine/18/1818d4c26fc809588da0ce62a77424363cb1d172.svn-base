//
//  YwzGnWdVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "YwzGnWdVC.h"
#import "MJRefresh.h"
#import "YwzGnWdCell.h"
#import "ztOANoticeDetialViewController.h"
@interface YwzGnWdVC ()<UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
}
@property (nonatomic,strong)UITableView *ywzgnwdTable;
@property (nonatomic,strong)NSMutableArray *gnwdary;
@end

@implementation YwzGnWdVC
@synthesize gnwdary,ywzgnwdTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    gnwdary=[[NSMutableArray alloc]init];
    ywzgnwdTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    ywzgnwdTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    ywzgnwdTable.dataSource=self;
    ywzgnwdTable.delegate=self;
    [self.view addSubview:ywzgnwdTable];
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    addN(@selector(reflashView), @"reflashTable");
    // Do any additional setup after loading the view.
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [ywzgnwdTable setContentOffset:CGPointMake(0,0) animated:animated];
}
#pragma mark----------------下拉刷新--------------
-(void)addHeader{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = ywzgnwdTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self reflashView];
    };
    [header beginRefreshing];
    _header=header;
}
#pragma mark--------------上啦加载更多-------------
-(void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = ywzgnwdTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self initWithData];
    };
    _footer=footer;
}
#pragma mark - 刷新列表
- (void)reflashView
{
    isLoadFinish = NO;
    iRecentPageIndex=1;
    [self initWithData];
}
#pragma mark---------------数据加载--------------
-(void)initWithData{
    NSDictionary *dataDic=@{@"strccbm":self.strccbm,@"intCurrentPage":[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intPageRows":@"10"};
    [self showWaitView];
    [ztOAService getYwzdGnWd:dataDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
        {
            if (iRecentPageIndex==1) {
                gnwdary=[[NSMutableArray alloc]init];
            }
            if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"wzxx"]).count>0)
            {
                iRecentPageIndex++;
                if ([[[dic objectForKey:@"root"]objectForKey:@"wzxx"] isKindOfClass:[NSDictionary class]]) {
                    [gnwdary addObject:[[dic objectForKey:@"root"]objectForKey:@"wzxx"]];
                }
                else
                {
                    [gnwdary addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"wzxx"]];
                }
                if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                    isLoadFinish=YES;
                }
                [ywzgnwdTable reloadData];
            }
        }
        [_header endRefreshing];
        [_footer endRefreshing];
    } Failed:^(NSError *error) {
        
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==ywzgnwdTable) {
        if (ywzgnwdTable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gnwdary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YwzGnWdCell";
    YwzGnWdCell *cell = (YwzGnWdCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YwzGnWdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.gndic=gnwdary[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowdic=[gnwdary objectAtIndex:indexPath.row];
    
    NSDictionary *publicDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[rowdic objectForKey:@"intxxzxwzlsh"]],@"intxxwzlsh", nil];
    [self showWaitView];
    [ztOAService getBmzlXx:publicDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *resultDataDic = [result objectFromJSONData];
        NSLog(@"%@",resultDataDic);
        ztOANoticeDetialViewController *publicVC = [[ztOANoticeDetialViewController alloc] initWithType:@"4" Data:[[resultDataDic objectForKey:@"root"] objectForKey:@"wzxx"]];
        publicVC.title=@"业务详情";
        [self.navigationController pushViewController:publicVC animated:YES];
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

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
