//
//  ztOAPersonalCollectViewController.m
//  OAMobileIOS
//
//  Created by 熊 on 16-10-9.
//  Copyright (c) 2016年 bear. All rights reserved.
//

#import "ztOAPersonalCollectViewController.h"
#import "ZwxxCell.h"
#import "LeaderDetailVC.h"
@interface ztOAPersonalCollectViewController ()
{
    NSString *i_type;//type:1收藏的公文
    NSString *titleName;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据列表
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NIDropDown          *dropView;
    NSArray             *dropTypeArray;
}
@property(nonatomic,strong)UITableView  *collectTable;
@property(nonatomic,strong)UIButton     *deleteToTrashBtn;
@end

@implementation ztOAPersonalCollectViewController
@synthesize collectTable;
@synthesize deleteToTrashBtn;
- (id)initWithType:(NSString *)whichType withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        i_type =whichType;
        self.title = title;
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        dropTypeArray = [NSArray arrayWithObjects:@"公文",@"政委信息", nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightButton:@"公文" Sel:@selector(openDropView:)];
    //type:1公文
    self.collectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.collectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    collectTable.delegate = self;
    collectTable.dataSource = self;
    [self.view addSubview:collectTable];
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
    addN(@selector(reflashCollectView), @"reflashEmailTable");
}
#pragma mark----------------下拉刷新--------------
-(void)addHeader{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = collectTable;
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
    footer.scrollView = collectTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self reflashCollectView];
    };
    _footer=footer;
}
#pragma mark - 刷新列表
- (void)reflashView
{
    isLoadFinish = NO;
    iRecentPageIndex=1;
    [self reflashCollectView];
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
#pragma mark-加载数据
- (void)reflashCollectView
{
    //获取公文列表
    if ([i_type isEqualToString:@"公文"]) {
        NSDictionary *dataDic=@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"intCurrentPage":[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intPageRows":@"10",@"queryTermXML":@""};
        [self showWaitView];
        [ztOAService getgwscjList:dataDic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             NSLog(@"list=%@",[dic JSONString]);
             if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
                 //刷新获取数据成功显示前先清楚旧数据
                 if (iRecentPageIndex==1) {
                     [dataListArray removeAllObjects];
                 }
                 if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]).count>0) {
                     iRecentPageIndex++;
                     if ([[[dic objectForKey:@"root"]objectForKey:@"document"] isKindOfClass:[NSDictionary class]]) {
                         [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"document"]];
                     }
                     else
                     {
                         [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]];
                     }
                     if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                         isLoadFinish=YES;
                     }
                 }
                 [collectTable reloadData];
                 [_header endRefreshing];
                 [_footer endRefreshing];
             }
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
    else if ([i_type isEqualToString:@"政务"]) {
        NSDictionary *dataDic=@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"intCurrentPage":[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intPageRows":@"10",@"queryTermXML":@""};
        [self showWaitView];
        [ztOAService getxxscjList:dataDic Success:^(id result) {
            [self closeWaitView];
            NSDictionary *dic = [result objectFromJSONData];
            NSLog(@"list=%@",[dic JSONString]);
            if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
            {
                if (iRecentPageIndex==1) {
                    dataListArray=[[NSMutableArray alloc]init];
                }
                if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"zxxx"]).count>0)
                {
                    iRecentPageIndex++;
                    if ([[[dic objectForKey:@"root"]objectForKey:@"zxxx"] isKindOfClass:[NSDictionary class]]) {
                        [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"zxxx"]];
                    }
                    else
                    {
                        [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"zxxx"]];
                    }
                    if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                        isLoadFinish=YES;
                    }
                    [collectTable reloadData];
                }
            }
            [_header endRefreshing];
            [_footer endRefreshing];
        } Failed:^(NSError *error) {
            
        }];
    }
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //公文
    if ([i_type isEqualToString:@"公文"]) {
        NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
        static NSString *cellID = @"ztOAOfficeDocListCell";
        ztOAOfficeDocListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"ztOAOfficeDocListCell" owner:self options:nil][0];
        }
        cell.i_type=@"5";
        cell.modedic=rowdic;
        return cell;
    }
    //政务信息
    else if ([i_type isEqualToString:@"政务"])
    {
        static NSString *cellID = @"LeaderShipCell";
        ZwxxCell *cell = (ZwxxCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[ZwxxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.zwscItemdic=dataListArray[indexPath.row];
        return cell;
    }else
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([i_type isEqualToString:@"公文"]) {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else
    {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.height;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataListArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //公文
    if([i_type isEqualToString:@"公文"])
    {
        //查询公文信息
        ztOAOfficialDocSendAndReceiveViewController *searchDetailVC = [[ztOAOfficialDocSendAndReceiveViewController alloc] initWithData:[dataListArray objectAtIndex:indexPath.row] isOnSearch:YES];
        searchDetailVC.title=@"公文详情";
        [self.navigationController pushViewController:searchDetailVC animated:YES];
    }
    else if ([i_type isEqualToString:@"政务"])
    {
        NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
        
        NSDictionary *informDic =@{@"intxxbslsh":[NSString stringWithFormat:@"%@",rowdic[@"intxxbslsh"]],@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh};
        LeaderDetailVC *leader=[[LeaderDetailVC alloc]init];
        leader.title=@"政务信息详情";
        leader.i_type=1;
        leader.infodic=informDic;;
        [self.navigationController pushViewController:leader animated:YES];
    }
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [collectTable setContentOffset:CGPointMake(0,0) animated:animated];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==collectTable) {
        if (collectTable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
- (void)openDropView:(id)sender
{
    if(dropView == nil) {
        CGFloat f = 44*dropTypeArray.count;
        dropView = [[NIDropDown alloc]showDropDown:sender height:&f arr:dropTypeArray];
        dropView.delegate = self;
    }
    else {
        [dropView hideDropDown:sender];
        dropView = nil;
    }
}
#pragma mark - DropDowndelegate-
- (void)niDropDownDelegateMethod: (NIDropDown *)sender index:(int)index{
    //date = self.rightBtnLab.text;
    dropView = nil;
    if (index == 0) {
        i_type =@"公文";
        self.rightBtnLab.text = @"公文";
    }
    else if (index == 1) {
       i_type =@"政务";
        self.rightBtnLab.text = @"政务";
    }
    [self reflashView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
