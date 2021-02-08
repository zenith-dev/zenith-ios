//
//  LBCheckViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBCheckViewController.h"
#import "SHbsTableViewCell.h"
#import "LBAgentsSwitchViewController.h"
@interface LBCheckViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UITableView *agentstb;
    NSInteger currentPage;
    NSMutableArray *agentsary;//数据列表
    
    NSString *keywordsstr;
    UISearchDisplayController *mySearchDisplayController;
    UISearchBar *mySearchBar;
    NSMutableArray *searchlstary;
}
@end
#define pageRows 10
@implementation LBCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-----------界面初始化-----------------
-(void)initview
{
    keywordsstr=@"";
    mySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    mySearchBar.delegate=self;
    //mySearchBar.returnKeyType=UIReturnKeySearch;
    mySearchBar.keyboardType=UIBarStyleDefault;
    mySearchBar.placeholder=@"请输入关键字";
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    
    agentstb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    agentstb.dataSource=self;
    [agentstb setBackgroundColor:[SingleObj defaultManager].backColor];
    [agentstb setTableHeaderView:mySearchBar];
    agentstb.contentOffset = CGPointMake(0, CGRectGetHeight(mySearchBar.bounds));
    agentstb.delegate=self;
    agentstb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:agentstb];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    agentstb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData:NO];
    }];
    // 马上进入刷新状态
    [agentstb.mj_header beginRefreshing];
}
-(void)loadNewData:(BOOL)search
{
    if (search==NO) {
        keywordsstr=@"";
    }
    currentPage=1;
    [SHNetWork getArchives:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] strjsid:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strjsid"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] strgwbt:keywordsstr intCurrentPage:currentPage intPageRows:search?20:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0&&search==NO)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                    agentstb.mj_footer=nil;
                }
                [SVProgressHUD dismiss];
                if (search) {
                    searchlstary=[[NSMutableArray alloc]initWithArray:tempary];
                    [mySearchDisplayController.searchResultsTableView reloadData];
                    
                }else
                {
                    if (tempary.count==pageRows) {
                        __unsafe_unretained __typeof(self) weakSelf = self;
                        agentstb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf loadMoreData];
                        }];
                    }
                    agentsary=[[NSMutableArray alloc]initWithArray:tempary];
                    [agentstb reloadData];
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
        [agentstb.mj_header endRefreshing];
    }];
}
-(void)loadMoreData
{
    currentPage++;
    [SHNetWork getArchives:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] strjsid:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strjsid"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] strgwbt:keywordsstr intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count<pageRows) {
                    agentstb.mj_footer=nil;
                }
                [agentsary addObjectsFromArray:tempary];
                [agentstb reloadData];
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
        [agentstb.mj_footer endRefreshing];
    }];
}
- (void)scrollTableViewToSearchBarAnimated:(BOOL)animated
{
    [agentstb scrollRectToVisible:mySearchBar.frame animated:animated];
}
#pragma mark-------------------------searchBardelegate--------------------
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length!=0) {
        keywordsstr=searchBar.text;
        [self loadNewData:YES];
    }
    [searchBar resignFirstResponder];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    keywordsstr= searchString;
    [self loadNewData:YES];
    return NO;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption

{
    // Return YES to cause the search result table view to be reloaded.
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==mySearchDisplayController.searchResultsTableView) {
        return searchlstary.count;
    }else
    {
        return  agentsary.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setBackgroundColor:[SingleObj defaultManager].backColor];
    }
    NSDictionary  *dic=nil;
    if (tableView==mySearchDisplayController.searchResultsTableView) {
        dic=[searchlstary objectAtIndex:indexPath.row];
    }
    else
    {
        dic=[agentsary objectAtIndex:indexPath.row];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(10,10, kScreenWidth-20, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    //公文字号:
    UIImageView *lgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    lgimg.contentMode=UIViewContentModeScaleAspectFit;
    [lgimg setImage:PNGIMAGE(@"do-ico")];
    ViewRadius(lgimg, H(lgimg)/2.0);
    [headerview addSubview:lgimg];
    UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lgimg)+5, Y(lgimg), W(headerview)-(XW(lgimg)+10), 30)];
    gwzhlb.textColor=[SingleObj defaultManager].origColor;
    gwzhlb.font=Font(14);
    gwzhlb.text=[NSString stringWithFormat:@"状态：%@",[[dic objectForKey:@"strbjbz"] intValue]==1?@"办结":@"未办结"];
    [headerview addSubview:gwzhlb];
    //横线
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(X(lgimg), YH(gwzhlb)+4, W(headerview)-10, 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:oneline];
    //正文
    UILabel *strgwzlb=[[UILabel alloc]initWithFrame:CGRectMake(X(oneline), YH(oneline)+5, W(oneline), 21)];
    NSMutableString *gwzstr=[NSMutableString string];
    
    if (![Tools isBlankString:[dic objectForKey:@"strlzlxmc"]])
    {
        [gwzstr appendFormat:@"【%@】",[dic objectForKey:@"strlzlxmc"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"strgwbt"]]) {
        [gwzstr appendFormat:@"%@",[dic objectForKey:@"strgwbt"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"strgwz"]]) {
        [gwzstr appendFormat:@"(%@",[dic objectForKey:@"strgwz"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"intgwnh"]]) {
        [gwzstr appendFormat:@"〔%@〕",[dic objectForKey:@"intgwnh"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"intgwqh"]])
    {
        [gwzstr appendFormat:@"%@号)",[dic objectForKey:@"intgwqh"]];
    }
    strgwzlb.text=gwzstr;
    strgwzlb.numberOfLines=0;
    strgwzlb.font=Font(16);
    strgwzlb.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize contentFontSize =[strgwzlb.text boundingRectWithSize:CGSizeMake(W(strgwzlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(16)} context:nil].size;
    
    //CGSize contentFontSize=[strgwzlb.text sizeWithFont:Font(16) constrainedToSize:CGSizeMake(W(strgwzlb), 500) lineBreakMode:NSLineBreakByCharWrapping];
    strgwzlb.frame=CGRectMake(X(strgwzlb), Y(strgwzlb), W(strgwzlb),contentFontSize.height);
    [headerview addSubview:strgwzlb];
    //横线
    UIImageView *twoline=[[UIImageView alloc]initWithFrame:CGRectMake(X(lgimg), YH(strgwzlb)+4, W(headerview)-10, 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:twoline];
    //来文单位
    UILabel *gzrwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(twoline), YH(twoline)+4, W(headerview)/2-5+20, 20)];
    gzrwlb.font=Font(12);
    gzrwlb.adjustsFontSizeToFitWidth=YES;
    gzrwlb.textColor=[SingleObj defaultManager].subtitleColor;
    gzrwlb.text=[NSString stringWithFormat:@"%@：%@",[[dic objectForKey:@"strlzlx"] isEqualToString:@"001"]?@"来文单位":@"起草部门",[dic objectForKey:@"strfwdwmc"]];
    [headerview addSubview:gzrwlb];
    //发文时间
    UILabel *fwlxlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gzrwlb), Y(gzrwlb), W(headerview)-(XW(gzrwlb)+10), H(gzrwlb))];
    fwlxlb.textAlignment=NSTextAlignmentRight;
    fwlxlb.font=Font(12);
    fwlxlb.textColor=[SingleObj defaultManager].subtitleColor;
    ;
    fwlxlb.text=[NSString stringWithFormat:@"%@",[Tools dateToStr:[Tools strToDate:[dic objectForKey:@"dtmdjsj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy-MM-dd"]];
    [headerview addSubview:fwlxlb];
    
    UIImageView *threeline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(gzrwlb)+9, W(headerview), 1)];
    [threeline setBackgroundColor:[SingleObj defaultManager].boderlineColor];
    [headerview addSubview:threeline];
    headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview), YH(threeline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary  *dic=nil;
    if (tableView==mySearchDisplayController.searchResultsTableView) {
        dic=[searchlstary objectAtIndex:indexPath.row];
    }
    else
    {
        dic=[agentsary objectAtIndex:indexPath.row];
    }
    LBAgentsSwitchViewController *lbagentsdetail=[[LBAgentsSwitchViewController alloc]init];
    NSMutableDictionary *gwdic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [gwdic setObject:@"公文详情" forKey:@"strgzrwmc"];
    lbagentsdetail.lstdic=gwdic;
    lbagentsdetail.isshow=YES;
    lbagentsdetail.intgwlzlsh=[dic objectForKey:@"intgwlzlsh"];
    lbagentsdetail.intbzjllsh=@"";
    lbagentsdetail.title=@"公文详情";
    [self.navigationController pushViewController:lbagentsdetail animated:YES];
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
