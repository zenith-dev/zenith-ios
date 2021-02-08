//
//  ztOADocSearchListViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-12.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADocSearchListViewController.h"

@interface ztOADocSearchListViewController ()
{
    NSString *dataDic;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据数组
    
    MJRefreshHeaderView *header_doc;
    MJRefreshFooterView *footer_doc;
    
    NSString            *docSearchName;//查询标题
    NSString            *docSearchStartTime;//开始时间
    NSString            *docSearchEndTime;//结束时间
    NSString            *docSearchCompany;//查询单位
    NSString            *docSearchDateNum;//查询期号
    NSString            *docSearchOffcial;//查询公文字
    NSString            *docTypeSearchStr;//选中类型，收文：001；发文：002
    NSString            *docYearSearchStr; //选中年号
    NSString            *isWhichSearch;//1类型；2年号;3筛选
    NIDropDown          *typeDropDown;
    NIDropDown          *yearDropDown;
}
@property(nonatomic,strong)UIImageView  *searchInfoBar;
@property(nonatomic,strong)UISearchBar  *searchField;
@property(nonatomic,strong)UIButton     *searchCheckBtn;
@property(nonatomic,strong)UITableView              *docListTable;//列表信息
@property(nonatomic,strong)NSMutableArray           *arrayYears;//年号数组
@property(nonatomic,strong)NSMutableArray           *arrayTypes;//类型数据
@property(nonatomic,strong)UIButton                 *typeSearchBtn;
@property(nonatomic,strong)UIButton                 *yearSearchBtn;

@end

@implementation ztOADocSearchListViewController
@synthesize docListTable;
@synthesize arrayYears,arrayTypes,searchInfoBar,searchField,searchCheckBtn;
@synthesize yearSearchBtn,typeSearchBtn;
- (id)init
{
    self = [super init];
    if (self) {
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        
        docSearchName  = @"";
        docSearchStartTime = @"";
        docSearchEndTime = @"";
        docSearchCompany = @"";
        docSearchDateNum = @"";
        docSearchOffcial = @"";
        docTypeSearchStr     = @"";//默认
        docYearSearchStr       = @"";
        isWhichSearch = @"1";
        
        //初始化年号／类型
        NSDate* nowDate = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:nowDate];
        int nowYear = [dd year];
        
        self.arrayYears = [[NSMutableArray alloc] init];
        [arrayYears addObject:@"全部年号"];
        for (int i = nowYear-4;i <= nowYear;i++)
        {
            [arrayYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.arrayTypes = [[NSMutableArray alloc] initWithObjects:@"全部类型",@"收文",@"发文", nil];
        
    }
    return self;
}
- (void)viewGoBack
{
    [yearDropDown removeFromSuperview];
    [typeDropDown removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self];//注意
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightButton:@"查询" Sel:@selector(filterSearchAtion:)];
    
    [self.rightBtn setHidden:NO];
    [self.rightBtnLab setText:@""];
    [self.rightBtn setImage:[UIImage imageNamed:@"filterBtnImage"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(filterSearchAtion:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    
    self.docListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchInfoBar.bottom, self.view.width, self.view.height-self.searchInfoBar.bottom) style:UITableViewStylePlain];
    self.docListTable.separatorStyle = UITableViewCellSelectionStyleNone;
    docListTable.delegate = self;
    docListTable.dataSource = self;
    [self.view addSubview:docListTable];
    //清除本地筛选数据
    [self cleanLocalFilterData];
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    addN(@selector(filterSearchInfoBack:), @"FILTERSEARCHDONE");
    // 下拉刷新
    [self addHeader];
    // 上拉加载更多
    [self addFooter];
}
- (void)cleanLocalFilterData
{
    //保存筛选数据到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:@"docSearchName"];
    [userDefaults setObject:nil forKey:@"docSearchOffcial"];
    [userDefaults setObject:nil forKey:@"docSearchDateNum"];
    [userDefaults setObject:nil forKey:@"docSearchCompany"];
    [userDefaults setObject:nil forKey:@"docSearchStartTime"];
    [userDefaults setObject:nil forKey:@"docSearchEndTime"];
    [userDefaults synchronize];
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [docListTable setContentOffset:CGPointMake(0,0) animated:animated];
}
- (void)filterSearchInfoBack:(NSNotification *)notify
{
    NSDictionary *dic = (NSDictionary *)[notify userInfo];
    docSearchName = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchName"]];
    docSearchOffcial = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchOffcial"]];
    docSearchDateNum = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchDateNum"]];
    docSearchCompany = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchCompany"]];
    docSearchStartTime = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchStartTime"]];
    docSearchEndTime = [ NSString stringWithFormat:@"%@",[dic objectForKey:@"docSearchEndTime"]];
    //保存筛选数据到本地
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:docSearchName forKey:@"docSearchName"];
    [userDefaults setObject:docSearchOffcial forKey:@"docSearchOffcial"];
    [userDefaults setObject:docSearchDateNum forKey:@"docSearchDateNum"];
    [userDefaults setObject:docSearchCompany forKey:@"docSearchCompany"];
    [userDefaults setObject:docSearchStartTime forKey:@"docSearchStartTime"];
    [userDefaults setObject:docSearchEndTime forKey:@"docSearchEndTime"];
    [userDefaults synchronize];
    [self reflashView];

}
#pragma mark - 刷新列表
- (void)reflashView
{
    isLoadFinish = NO;
    iRecentPageIndex=1;
    [dataListArray removeAllObjects];
    [self searchData];
    
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.docListTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self searchData];
    };
    footer_doc=footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.docListTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self reflashView];
    };
    [header beginRefreshing];
    header_doc = header;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.docListTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 搜索
- (void)searchData
{
    //获取查询公文列表
    NSString *dic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2></root>",
                         [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",docSearchName]],
                         [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",docSearchOffcial]],
                         docYearSearchStr,
                         [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",docSearchDateNum]],
                         docTypeSearchStr,
                         [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",docSearchCompany]],
                         @"",
                         @"",
                         docSearchStartTime,
                         docSearchEndTime];
    NSLog(@"searchdic==%@",dic);        
    
    NSDictionary *searchDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",dic,@"queryTermXML",nil];
    [self showWaitView];
    [ztOAService searchOfficeDocList:searchDic Success:^(id result)
     {
         [self closeWaitView];
         NSDictionary *dic = [result objectFromJSONData];
         NSLog(@"list=%@",dic);
         if ([[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
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
             [docListTable reloadData];
             [footer_doc endRefreshing];
             [header_doc endRefreshing];
         }
     }Failed:^(NSError *error){
         [self closeWaitView];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
     }];
    
}
#pragma mark -tableview delegate-
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (docListTable==tableView) {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
            static NSString *cellID = @"officeDocCellIdentifier";
            ztOAOfficeDocListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"ztOAOfficeDocListCell" owner:self options:nil][0];
            }
            //cell.i_type=i_type;
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
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (docListTable==tableView) {
        return 60;
    }
    else    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (docListTable == tableView) {
        if (indexPath.row<dataListArray.count) {
            //查询公文信息
            ztOAOfficialDocSendAndReceiveViewController *searchDetailVC = [[ztOAOfficialDocSendAndReceiveViewController alloc] initWithData:[dataListArray objectAtIndex:indexPath.row] isOnSearch:YES];
            searchDetailVC.title=@"公文信息";
            [self.navigationController pushViewController:searchDetailVC animated:YES];
            
        }
        else
        {
            [self searchData];
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (docListTable==tableView) {
        return dataListArray.count;
    }
    else return 0;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==docListTable) {
        if (docListTable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
#pragma mark --------------actionSearch----------------

- (void)typeSearchAction:(id)sender
{
    if(yearDropDown!=nil)
    {
        [yearDropDown hideDropDown:yearSearchBtn];
        yearDropDown = nil;
    }
    if(typeDropDown == nil) {
        isWhichSearch=@"1";
        CGFloat f = 44*arrayTypes.count;
        typeDropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:arrayTypes];
        typeDropDown.delegate = self;
    }
    else {
        [typeDropDown hideDropDown:sender];
        typeDropDown = nil;
    }

}
- (void)yearSearchAction:(id)sender
{
    if(typeDropDown!=nil)
    {
        [typeDropDown hideDropDown:typeSearchBtn];
        typeDropDown = nil;
    }
    if(yearDropDown == nil) {
        isWhichSearch=@"2";
        CGFloat f = 44*arrayYears.count;
        yearDropDown = [[NIDropDown alloc]showDropDown:sender height:&f arr:arrayYears];
        yearDropDown.delegate = self;
    }
    else {
        [yearDropDown hideDropDown:sender];
        yearDropDown = nil;
    }
}
#pragma mark - DropDowndelegate-
- (void)niDropDownDelegateMethod: (NIDropDown *)sender index:(int)index{
    //date = self.rightBtnLab.text;
    
    if ([isWhichSearch isEqualToString:@"1"]) {
        [typeDropDown hideDropDown:typeSearchBtn];
        typeDropDown = nil;
        if (index==0) {
            docTypeSearchStr =@"";
        }
        else{
            if (index==1) {
                docTypeSearchStr = @"001";
            }
            else
            {
                docTypeSearchStr = @"002";
            }
        }
        [self reflashView];
    
    }
    else if ([isWhichSearch isEqualToString:@"2"])
    {
        [yearDropDown hideDropDown:yearSearchBtn];
        yearDropDown = nil;
        if (index==0) {
            docYearSearchStr =@"";
        }
        else{
            docYearSearchStr = [NSString stringWithFormat:@"%@",[arrayYears objectAtIndex:index]];
        }
        [self reflashView];
    }
    
}

- (void)filterSearchAtion:(id)sender
{
    if(yearDropDown!=nil)
    {
        [yearDropDown removeFromSuperview];
        yearDropDown = nil;
    }
    if(typeDropDown!=nil)
    {
        [typeDropDown removeFromSuperview];
        typeDropDown = nil;
    }
    isWhichSearch = @"3";
    ztOADocFilterSearchViewController *filterVC = [[ztOADocFilterSearchViewController alloc] init];
    [self.navigationController pushViewController:filterVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
