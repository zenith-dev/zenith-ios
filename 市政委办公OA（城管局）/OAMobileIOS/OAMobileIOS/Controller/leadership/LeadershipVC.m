//
//  LeadershipVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/28.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "LeadershipVC.h"
#import "MJRefresh.h"
#import "LeaderShipCell.h"
#import "LeaderDetailVC.h"
@interface LeadershipVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSString            *searchBarStr;
}
@property(nonatomic,strong)UIImageView *searchInfoBar;
@property(nonatomic,strong)UISearchBar *searchField;
@property(nonatomic,strong)UIButton *searchCheckBtn;
@property(nonatomic,strong)UITableView *leadertable;
@property(nonatomic,strong)NSMutableArray *dataListArray;//领导列表
@end

@implementation LeadershipVC
@synthesize searchInfoBar,searchField,searchCheckBtn,leadertable,dataListArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    dataListArray=[[NSMutableArray alloc]init];
    searchInfoBar= [[UIImageView alloc] initWithFrame:CGRectMake(10,64,self.view.width-20-40, 40)];
    searchInfoBar.backgroundColor = [UIColor clearColor];
    [searchInfoBar setUserInteractionEnabled:YES];
    searchInfoBar.image = [UIImage imageNamed:@"searchKuang_Img"];
    searchField = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, self.searchInfoBar.width-10, 20)];
    self.searchField.delegate = self;
    self.searchField.barStyle = UIBarStyleDefault;
    //适配ios7.0系统
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([searchField respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
//            [[[[self.searchField.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            if (@available(iOS 13.0, *)) {
                [[self.searchField.subviews objectAtIndex:0].subviews objectAtIndex:0].hidden = YES;
            } else {
                [[[self.searchField.subviews objectAtIndex:0].subviews objectAtIndex:0]removeFromSuperview];
            }
        }
        else
        {
            //iOS7.0
            [self.searchField setBarTintColor:[UIColor clearColor]];
        }
        [self.searchInfoBar addSubview:self.searchField];
        [self.view addSubview:searchInfoBar];
    }
    else
    {
        //iOS7.0以下
        [[self.searchField.subviews objectAtIndex:0] removeFromSuperview];
        self.searchField.frame = CGRectMake(5,44 , self.view.width-20-40+5, 40);
        [self.view addSubview:self.searchField];
    }
    searchField.placeholder = @"输入领导讲话标题";
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchCheckBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchInfoBar.right, 64+5 , 45, 30)];
    [searchCheckBtn addTarget:self action:@selector(searchCheckAtion) forControlEvents:UIControlEventTouchUpInside];
    [searchCheckBtn setBackgroundColor:BACKCOLOR];
    [searchCheckBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchCheckBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:searchCheckBtn];
    leadertable = [[UITableView alloc] initWithFrame:CGRectMake(0, searchInfoBar.bottom, self.view.width, self.view.height-self.searchInfoBar.bottom) style:UITableViewStyleGrouped];
    leadertable.separatorStyle=UITableViewCellSeparatorStyleNone;
    leadertable.dataSource=self;
    leadertable.delegate=self;
    [self.view addSubview:leadertable];
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
    [leadertable setContentOffset:CGPointMake(0,0) animated:animated];
}
#pragma mark----------------下拉刷新--------------
-(void)addHeader{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = leadertable;
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
    footer.scrollView = leadertable;
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
    searchBarStr =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strzt>%@</strzt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><strflmc>%@</strflmc></root>",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",self.searchKey?:@"" ]],self.searchDic[@"dtmfbsj1"],self.searchDic[@"dtmfbsj2"], [self UnicodeToISO88591:self.searchDic[@"strflmc"]]];
    NSDictionary *dataDic=@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"intCurrentPage":[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intPageRows":@"10",@"queryTermXML":searchBarStr,@"strwzyddw":[ztOAGlobalVariable sharedInstance].alldwlsh};
    [self showWaitView];
    [ztOAService getWzglList:dataDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
        {
            if (iRecentPageIndex==1) {
                dataListArray=[[NSMutableArray alloc]init];
            }
            if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"wzgl"]).count>0)
            {
                iRecentPageIndex++;
                if ([[[dic objectForKey:@"root"]objectForKey:@"wzgl"] isKindOfClass:[NSDictionary class]]) {
                    [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"wzgl"]];
                }
                else
                {
                    [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"wzgl"]];
                }
                if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                    isLoadFinish=YES;
                }
                [leadertable reloadData];
            }
        }
        [_header endRefreshing];
        [_footer endRefreshing];
    } Failed:^(NSError *error) {
        
    }];
}
#pragma mark----------------搜索按钮---------------
//执行搜索操作
- (void)searchBtnClick
{
    [searchField resignFirstResponder];
    self.searchKey=searchField.text?:@"";
    [self reflashView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
    if (scrollView==leadertable) {
        if (leadertable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self.searchField resignFirstResponder];
    [self searchBtnClick];//搜索
}
- (void)searchCheckAtion
{
    [self.searchField resignFirstResponder];
    [self searchBtnClick];//搜索
    
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
    return dataListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LeaderShipCell";
    LeaderShipCell *cell = (LeaderShipCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[LeaderShipCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.leaderItemdic=dataListArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
    NSDictionary *informDic =@{@"intxxzxwzlsh":[NSString stringWithFormat:@"%@",rowdic[@"intxxzxwzlsh"]],@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh};
    
    LeaderDetailVC *leader=[[LeaderDetailVC alloc]init];
    leader.title=@"领导讲话详情";
    leader.infodic=informDic;
    leader.i_type=0;
    [self.navigationController pushViewController:leader animated:YES];
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
