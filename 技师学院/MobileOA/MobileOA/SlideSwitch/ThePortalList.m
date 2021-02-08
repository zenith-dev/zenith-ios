//
//  ThePortalList.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/12.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ThePortalList.h"
#import "ThePortalCell.h"
#import "ThePortalDetailVC.h"
@interface ThePortalList ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)int numpage;
@property (nonatomic,strong)NSMutableArray *thportlst;
@end

@implementation ThePortalList
@synthesize theportTb,numpage,thportlst;
- (void)viewDidLoad {
    [super viewDidLoad];
    thportlst=[[NSMutableArray alloc]init];
    theportTb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, kScreenHeight-64-44-150) style:UITableViewStyleGrouped];
    theportTb.delegate=self;
    theportTb.dataSource=self;
    [self.view addSubview:theportTb];
    __unsafe_unretained __typeof(self) weakSelf = self;
    theportTb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        numpage=1;
        [weakSelf getNewsListByChannelid];
    }];
    theportTb.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        numpage++;
        [weakSelf getNewsListByChannelid];
    }];
    // Do any additional setup after loading the view.
}
-(void)getDatas:(BOOL)isup{
    if (isup==YES) {
        [theportTb.mj_header beginRefreshing];
    }else
    {
        if (thportlst.count>0) {
            
            
        }else
        {
            [theportTb.mj_header beginRefreshing];
        }
    }
    
}
#pragma mark---------------加载数据------------------
-(void)getNewsListByChannelid{
    
    NSDictionary *dataDic= @{@"channelid":self.channelid,@"category_id":self.category_id,@"pageIndex":@(numpage)};
    [self newworkGet:@"getNewsListByChannelid.ashx" parameter:dataDic progresHudText:nil completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"ds"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *thedic=rep[@"ds"];
                if (numpage==1) {
                    thportlst =[[NSMutableArray alloc]initWithObjects:thedic, nil];
                    [theportTb.mj_header endRefreshing];
                }else
                {
                    [thportlst addObject:thedic];
                    [theportTb.mj_footer endRefreshing];
                }
                [theportTb reloadData];
                theportTb.mj_footer.state=MJRefreshStateNoMoreData;
            }else if ([rep[@"ds"] isKindOfClass:[NSArray class]]){
                NSArray *noticeary=rep[@"ds"];
                if (numpage==1) {
                    thportlst =[[NSMutableArray alloc]initWithArray:noticeary];
                    [theportTb.mj_header endRefreshing];
                }else
                {
                    [thportlst addObjectsFromArray:noticeary];
                    [theportTb.mj_footer endRefreshing];
                }
                [theportTb reloadData];
                if (noticeary.count<1) {
                    theportTb.mj_footer.state=MJRefreshStateNoMoreData;
                }else
                {
                    theportTb.mj_footer.state=MJRefreshStateIdle;
                }
            }
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return thportlst.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeCell";
    ThePortalCell *cell = (ThePortalCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[ThePortalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.thePortaldic=thportlst[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThePortalDetailVC *thePortal=[[ThePortalDetailVC alloc]initWithTitle:@"新闻详情"];
    NSDictionary *thePortaldic=thportlst[indexPath.row];
    thePortal.news_id=[NSString stringWithFormat:@"%@",thePortaldic[@"id"]];
    [self.navs pushViewController:thePortal animated:YES];
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
