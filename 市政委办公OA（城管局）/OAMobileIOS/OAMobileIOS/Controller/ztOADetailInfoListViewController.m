//
//  ztOADetailInfoListViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOADetailInfoListViewController.h"
#import "ztOANoticeDetialViewController.h"
#import "ztOAOfficialDocSendAndReceiveViewController.h"
@interface ztOADetailInfoListViewController ()
{
    NSString *i_type;//type:1待办公文；2最新通知；3邮件系统；4公告列表;5公文搜索
    NSString *titleName;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据列表
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;

    NSString            *searchBarStr;
}
@property(nonatomic,strong)UITableView  *table;
@property(nonatomic,strong)UIImageView  *searchInfoBar;
@property(nonatomic,strong)UISearchBar  *searchField;
@property(nonatomic,strong)UIButton     *searchCheckBtn;

@end

@implementation ztOADetailInfoListViewController
@synthesize table;
@synthesize searchInfoBar,searchCheckBtn,searchField;
- (id)initWithType:(NSString *)whichType withTitle:(NSString *)title queryTerm:(NSString *)queryTermXML
{
    self = [super init];
    if (self) {
        i_type =whichType;
        self.title = title;
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        searchBarStr = queryTermXML;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //公文搜索结果列表不显示搜索框
    if ([i_type isEqualToString:@"5"]||[i_type isEqualToString:@"1"]||[i_type isEqualToString:@"4"]||[i_type isEqualToString:@"6"]) {
        NSString *placeholderStr = @"";
        //type:1待办公文；2最新通知；3邮件系统；4个人公告;5公文搜索 6历史库查询
        switch ([i_type intValue]) {
            case 1:
                placeholderStr =@"输入公文标题";
                break;
            case 2:
                placeholderStr =@"输入通知标题";
                break;
            case 4:
                placeholderStr =@"输入公文标题";
                break;
            case 3:
                placeholderStr =@"输入邮件标题";
                break;
            case 5:
                placeholderStr =@"输入公文标题";
                break;
            case 6:
                placeholderStr =@"输入公文标题";
                break;
            default:
                placeholderStr=@"输入文字";
                break;
        }
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
//                [[[[self.searchField.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
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
        self.searchField.placeholder = placeholderStr;
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
    }
    else
    {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    }
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    addN(@selector(reflashView), @"reflashTable");
}

- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self initWithData];
    };
    _footer=footer;
}
- (void)addHeader
{
     MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self reflashView];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
//        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                break;
            case MJRefreshStatePulling:
                break;
            case MJRefreshStateRefreshing:
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.table reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self reflashView];
}
#pragma mark - 刷新列表
- (void)reflashView
{
    isLoadFinish = NO;
    iRecentPageIndex=1;
    [self initWithData];
}
#pragma mark-加载数据
- (void)initWithData
{
    //获取待办公文列表
    if ([i_type isEqualToString:@"1"] || [i_type isEqualToString:@"5"]) {
        NSDictionary *dataDic;
        if ([i_type isEqualToString:@"1"]) {
            dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
            [self showWaitView];
            [ztOAService getOfficeDocList:dataDic Success:^(id result)
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
                     [table reloadData];
                     [_header endRefreshing];
                     [_footer endRefreshing];
                 }
             }Failed:^(NSError *error){
                 [self closeWaitView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
        else
        {
            //查询公文列表
            dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
            [self showWaitView];
            [ztOAService searchOfficeDocList:dataDic Success:^(id result)
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
                     [table reloadData];
                    
                 }
                 [_header endRefreshing];
                 [_footer endRefreshing];
             }Failed:^(NSError *error){
                 [self closeWaitView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
        
    }
    //最新通知
    else if ([i_type isEqualToString:@"2"]) {
        NSDictionary *InformDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self showWaitView];
        [ztOAService getInformList:InformDic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             NSLog(@"list=%@",[dic JSONString]);
             if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
                 //刷新获取数据成功显示前先清楚旧数据
                 if (iRecentPageIndex==1) {
                     [dataListArray removeAllObjects];
                 }
                 if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"notice"]).count>0) {
                     
                     iRecentPageIndex++;
                     if ([[[dic objectForKey:@"root"]objectForKey:@"notice"] isKindOfClass:[NSDictionary class]]) {
                         [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"notice"]];
                     }
                     else
                     {
                         [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"notice"]];
                     }
                     if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                         isLoadFinish=YES;
                     }
                 }
                 [_header endRefreshing];
                 [_footer endRefreshing];
                 [table reloadData];
             }
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
        
    }//个人公告
    else if ([i_type isEqualToString:@"4"])
    {
        NSDictionary *informDic =@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"intcsdwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intdwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh,@"intCurrentPage":[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intPageRows":@"10",@"queryTermXML":searchBarStr};
        [self showWaitView];
        [ztOAService getGrGwcxList:informDic Success:^(id result)
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
                 [table reloadData];
                 [_header endRefreshing];
                 [_footer endRefreshing];
             }
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }//公文历史库
    else if ([i_type isEqualToString:@"6"]){
       NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self showWaitView];
        [ztOAService getlsgwList:dataDic Success:^(id result)
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
                 [table reloadData];
                 
             }
             [_header endRefreshing];
             [_footer endRefreshing];
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
}
//执行搜索操作
- (void)searchBtnClick
{
    [searchField resignFirstResponder];
    if (searchField.text.length==0) {
        searchBarStr = @"";
    }
    else
    {
        //公文
        if ([i_type isEqualToString:@"1"]) {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",
                            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            @"",
                            @"",
                            @"",
                            @"",
                            @"",
                            @"",
                            @"",
                            @"",
                            @"",
                            @""];
        }
        //通知
        else if ([i_type isEqualToString:@"2"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt>%@</strtzbt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><tzckbz>%@</tzckbz></root>",
                            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            @"",
                            @"",
                            @""];
        }
        //邮件
        else if ([i_type isEqualToString:@"3"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt>%@</strtzbt><strryxm>%@</strryxm><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><querytype>%@</querytype></root>",
                            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            @"",
                            @"",
                            @"",
                            @"0"];
        }
        else if ([i_type isEqualToString:@"5"])
        {
           searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2></root>",
                              [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            [self.searchDic objectForKey:@"chrgwz"],
                            [self.searchDic objectForKey:@"intgwnh"],
                             [self.searchDic objectForKey:@"intgwqh"],
                             [self.searchDic objectForKey:@"chrgwlb"],
                             [self.searchDic objectForKey:@"chrlwdwmc"],
                             @"",
                             @"",
                             [self.searchDic objectForKey:@"dtmdjsj1"] ,
                             [self.searchDic objectForKey:@"dtmdjsj2"]];
        }else if ([i_type isEqualToString:@"6"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2></root>",
                            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            [self.searchDic objectForKey:@"chrgwz"],
                            [self.searchDic objectForKey:@"intgwqh"],
                            [self.searchDic objectForKey:@"chrgwlb"],
                            [self.searchDic objectForKey:@"chrlwdwmc"],
                            @"",
                            @"",
                            [self.searchDic objectForKey:@"dtmdjsj1"] ,
                            [self.searchDic objectForKey:@"dtmdjsj2"]];
        }
        else if ([i_type isEqualToString:@"4"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> <root><strgwbt>%@</strgwbt></root>",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@""]]];
        }
    }
    [self reflashView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
    if (scrollView==table) {
        if (table.contentOffset.y>0) {
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
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //待办公文
    if ([i_type isEqualToString:@"1"] || [i_type isEqualToString:@"5"]||[i_type isEqualToString:@"4"]||[i_type isEqualToString:@"6"]) {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
            static NSString *cellID = @"officeDocCellIdentifier";
            ztOAOfficeDocListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"ztOAOfficeDocListCell" owner:self options:nil][0];
            }
            cell.i_type=i_type;
            cell.modedic=rowdic;
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
    //最新通知
    if ([i_type isEqualToString:@"2"]) {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
            static NSString *cellID = @"ztOANoticeCell";
            ztOANoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[ztOANoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            //置顶
            if ([[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strzdbz"] intValue]==1) {
                cell.zhidingIconImg.frame =CGRectMake(cell.iconImg.right+5, 10, 35,20);
                cell.noticeName.frame=CGRectMake(cell.zhidingIconImg.right+5, 10, cell.width-cell.zhidingIconImg.right-5, 20);
                [cell.contentView addSubview:cell.zhidingIconImg];
            }
            cell.iconImg.image = nil;
            cell.noticeName.text = [NSString stringWithFormat:@"%@",rowdic[@"strtzbt"]];
            cell.detailInfo.text =[NSString stringWithFormat:@"%@ | %@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strryxm"],[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strdwjc"]];
            cell.noticeTime.text =[ztOASmartTime intervalSinceNow:[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dtmdjsj"]]];
            [cell.readCount setHidden:YES];
            [cell.readImg setHidden:YES];
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

    else{
        if (indexPath.section==0) {
            static NSString *cellId = @"ceshi";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [[cell.contentView subviews] each:^(id sender) {
                [(UIView *)sender removeFromSuperview];
            }];
            cell.selectionStyle =UITableViewCellSelectionStyleGray;
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
            lab.backgroundColor = [UIColor clearColor];
            [lab setTextColor:[UIColor blackColor]];
            lab.text = @"";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:14.0f];
            [cell addSubview:lab];
            return cell;
        }else{
            static NSString *cellId = @"lookingForMore";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [[cell.contentView subviews] each:^(id sender) {
                [(UIView *)sender removeFromSuperview];
            }];
            cell.backgroundColor = MF_ColorFromRGB(0, 116, 241);
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
            lab.backgroundColor = [UIColor clearColor];
            [lab setTextColor:[UIColor whiteColor]];
            lab.text = @"";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:14.0f];
            [cell addSubview:lab];
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //待办公文
    if([i_type isEqualToString:@"1"] || [i_type isEqualToString:@"5"]||[i_type isEqualToString:@"4"]||[i_type isEqualToString:@"6"])
    {
        if (indexPath.row<dataListArray.count) {
            if ([i_type isEqualToString:@"1"]) {
                //公文流转
                NSDictionary *modedic =[dataListArray objectAtIndex:indexPath.row];
                ztOAOfficialDocSendAndReceiveViewController *docVC = [[ztOAOfficialDocSendAndReceiveViewController alloc] initWithData:modedic isOnSearch:NO];
                if ([[modedic objectForKey:@"chrlzlx"] isEqualToString:@"发文"]) {
                   docVC.title=@"发文处理";
                }
                else
                {
                    docVC.title=@"收文处理";
                }
                [self.navigationController pushViewController:docVC animated:YES];
            }
            else
            {
                //查询公文信息
                ztOAOfficialDocSendAndReceiveViewController *searchDetailVC = [[ztOAOfficialDocSendAndReceiveViewController alloc] initWithData:[dataListArray objectAtIndex:indexPath.row] isOnSearch:YES];
                searchDetailVC.title=@"公文详情";
                [self.navigationController pushViewController:searchDetailVC animated:YES];
            }
        }
    }
    //最新通知
    else if([i_type isEqualToString:@"2"])
    {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *informDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"inttzlsh"],@"inttzlsh",nil];
            [self showWaitView];
            [ztOAService getInformDetailInfo:informDic Success:^(id result)
             {
                 [self closeWaitView];
                 NSDictionary *dic = [result objectFromJSONData];
                 if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                     ztOANoticeDetialViewController *informVC = [[ztOANoticeDetialViewController alloc] initWithType:@"1" Data:[[dic objectForKey:@"root"] objectForKey:@"notice"]];
                     [self.navigationController pushViewController:informVC animated:YES];
                 }
                 
             }Failed:^(NSError *error)
             {
                 [self closeWaitView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
    }

}

- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [table setContentOffset:CGPointMake(0,0) animated:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
