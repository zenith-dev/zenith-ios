//
//  ztggOAViewController.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/2.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztggListOAViewController.h"
#import "ztggOATableViewCell.h"
#import "ztOANoticeDetialViewController.h"
@interface ztggListOAViewController ()
{
    NSString *i_type;//type:1待办公文；2最新通知；3邮件系统；4公告列表;5公文搜索
    NSString *titleName;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据列表
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NSMutableArray      *selectedDic;
    NSString            *searchBarStr;
    NSMutableArray *ggLshArray;
}
@property(nonatomic,strong)UITableView  *table;
@property(nonatomic,strong)NSString     *i_QueryTermXML;
@property(nonatomic,strong)UIImageView  *searchInfoBar;
@property(nonatomic,strong)UISearchBar  *searchField;
@property(nonatomic,strong)UIButton     *searchCheckBtn;
@property (retain, nonatomic) NSMutableArray *items;
@end

@implementation ztggListOAViewController
@synthesize searchCheckBtn,searchInfoBar,searchField;
- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        self.items = [[NSMutableArray alloc] init];
        selectedDic = [[NSMutableArray alloc] init];
        ggLshArray = [[NSMutableArray alloc] init];
        self.i_QueryTermXML = @"";
        searchBarStr = @"";
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchInfoBar= [[UIImageView alloc] initWithFrame:CGRectMake(10,64,self.view.width-20-40, 40)];
     searchInfoBar.backgroundColor = [UIColor clearColor];
    [searchInfoBar setUserInteractionEnabled:YES];
    searchInfoBar.image = [UIImage imageNamed:@"searchKuang_Img"];
    self.searchField = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, self.searchInfoBar.width-10, 20)];
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
    self.searchField.placeholder = @"输入公告标题";
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchField.keyboardType = UIKeyboardTypeDefault;
    self.searchCheckBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchInfoBar.right, 64+5 , 45, 30)];
    [searchCheckBtn addTarget:self action:@selector(searchCheckAtion) forControlEvents:UIControlEventTouchUpInside];
    [searchCheckBtn setBackgroundColor:BACKCOLOR];
    [searchCheckBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchCheckBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:searchCheckBtn];
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchInfoBar.bottom, self.view.width, self.view.height-self.searchInfoBar.bottom) style:UITableViewStylePlain];
    self.table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.table.dataSource=self;
    self.table.delegate=self;
    [self.view addSubview:self.table];
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
    [self.table setContentOffset:CGPointMake(0,0) animated:animated];
}
#pragma mark----------------下拉刷新--------------
-(void)addHeader{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.table;
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
    footer.scrollView = self.table;
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
    NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
    [self showWaitView];
    [ztOAService searchNoticeList:dataDic Success:^(id result) {
         [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
         if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
         {
             if (iRecentPageIndex==1) {
                 [dataListArray removeAllObjects];
             }
              if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"gg"]).count>0)
              {
                  iRecentPageIndex++;
                  if ([[[dic objectForKey:@"root"]objectForKey:@"gg"] isKindOfClass:[NSDictionary class]]) {
                      [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"gg"]];
                  }
                  else
                  {
                      [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"gg"]];
                  }
                  if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                      isLoadFinish=YES;
                  }
                  [self.table reloadData];
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
     searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strggbt>%@</strggbt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><tzckbz>%@</tzckbz></root>",
                    [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                    @"",
                    @"",
                    @""];
    [self reflashView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
    if (scrollView==self.table) {
        if (self.table.contentOffset.y>0) {
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataListArray.count!=0) {
        return dataListArray.count;
    }
    else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<dataListArray.count) {
        NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
        static NSString *cellID = @"ztggOATableViewCell";
        ztggOATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[NSBundle mainBundle] loadNibNamed:@"ztggOATableViewCell" owner:self options:nil][0];
        }
        cell.ggdic=rowdic;
        return cell;
    }
    else
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSMutableDictionary *rowdic= [[NSMutableDictionary alloc]initWithDictionary:[dataListArray objectAtIndex:indexPath.row]];
    if ([[rowdic objectForKey:@"strcdbz"] intValue]==0) {
        [rowdic setObject:@"1" forKey:@"strcdbz"];
        [dataListArray replaceObjectAtIndex:indexPath.row withObject:rowdic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    NSDictionary *informDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"intgglsh"],@"intgglsh",nil];
    [self showWaitView];
    [ztOAService getNoticeDetailInfo:informDic Success:^(id result)
     {
         [self closeWaitView];
         NSDictionary *dic = [result objectFromJSONData];
         if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
             ztOANoticeDetialViewController *informVC = [[ztOANoticeDetialViewController alloc] initWithType:@"2" Data:[[dic objectForKey:@"root"] objectForKey:@"gg"]];
              informVC.title=@"公告详情";
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
