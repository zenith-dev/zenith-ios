//
//  ztMeetVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/5.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztMeetVC.h"
#import "MJRefresh.h"
#import "MeetCell.h"
#import "ztMeetDetailVC.h"
@interface ztMeetVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
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
@property(nonatomic,strong)UITableView *meettable;
@property(nonatomic,strong)NSMutableArray *dataListArray;//会议列表
@end

@implementation ztMeetVC
@synthesize searchInfoBar,searchField,searchCheckBtn,meettable,dataListArray;
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
    searchField.placeholder = @"输入会议通知标题";
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
    meettable = [[UITableView alloc] initWithFrame:CGRectMake(0, searchInfoBar.bottom, self.view.width, self.view.height-self.searchInfoBar.bottom) style:UITableViewStyleGrouped];
    meettable.separatorStyle=UITableViewCellSeparatorStyleNone;
    meettable.dataSource=self;
    meettable.delegate=self;
    [self.view addSubview:meettable];
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
    [meettable setContentOffset:CGPointMake(0,0) animated:animated];
}
#pragma mark----------------下拉刷新--------------
-(void)addHeader{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = meettable;
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
    footer.scrollView = meettable;
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
    NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr.length!=0?searchBarStr:@"",@"queryTermXML",nil];
    [self showWaitView];
    [ztOAService getHyList:dataDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
        {
            if (iRecentPageIndex==1) {
                dataListArray=[[NSMutableArray alloc]init];
            }
            if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"meet"]).count>0)
            {
                iRecentPageIndex++;
                if ([[[dic objectForKey:@"root"]objectForKey:@"meet"] isKindOfClass:[NSDictionary class]]) {
                    [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"meet"]];
                }
                else
                {
                    [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"meet"]];
                }
                if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                    isLoadFinish=YES;
                }
                [meettable reloadData];
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
    searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strhybt>%@</strhybt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><strryxm>%@</strryxm></root>",
                    [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                    @"",
                    @"",
                    @""];
    [self reflashView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
    if (scrollView==meettable) {
        if (meettable.contentOffset.y>0) {
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
    return cell.contentView.size.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
    static NSString *cellID = @"MeetCell";
    MeetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[MeetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.meetdic=rowdic;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
    NSDictionary *informDic =@{@"inthylsh":[NSString stringWithFormat:@"%@",rowdic[@"inthylsh"]]};
    [self showWaitView];
    [ztOAService getdetailList:informDic Success:^(id result)
     {
         [self closeWaitView];
         NSDictionary *dic = [result objectFromJSONData];
         if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
             ztMeetDetailVC *informVC = [[ztMeetDetailVC alloc] init];
             informVC.title=@"公告详情";
             informVC.datadic=dic[@"root"][@"meet"];
             [self.navigationController pushViewController:informVC animated:YES];
         }
     }Failed:^(NSError *error)
     {
         [self closeWaitView];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
