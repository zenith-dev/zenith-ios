//
//  ztOAPublicationSearchResultViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAPublicationSearchResultViewController.h"
#import "ztOAPublicatiinDetailInfoViewController.h"
@interface ztOAPublicationSearchResultViewController ()
{
    NSString *dataDic;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据数组
    
    MJRefreshHeaderView *header_t;
    MJRefreshFooterView *footer_t;
    
    NSString            *publicSearchStr;//选中刊物目录标题
    NSString            *publicSearchNumStr;//选中刊物目录编号
    NSString            *yearSearchStr; //选中年份
    NSString            *isPublicOrYearSearch;//1刊物；2年份
    
    FilePlugin *filePlugin;
}
@property(nonatomic,strong)UITableView          *infoTable;//列表信息
@property(nonatomic,strong)UIButton             *publicSearchBtn;//根据刊物查询
@property(nonatomic,strong)UIButton             *yearSearchBtn;//根据年号查询
@property(nonatomic,strong)NSMutableArray       *arrayYears;//年号数组
@property(nonatomic,strong)NSMutableArray       *pulicDicArray;//刊物目录数据
@property (nonatomic,strong) UIViewController   *viewController;

@end

@implementation ztOAPublicationSearchResultViewController
@synthesize infoTable;
@synthesize publicSearchBtn,yearSearchBtn;
@synthesize arrayYears,pulicDicArray;
@synthesize viewController = _viewController;
- (id)init
{
    self = [super init];
    if (self) {
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        publicSearchNumStr  = @"";
        publicSearchStr     = @"";
        yearSearchStr       = @"";
        isPublicOrYearSearch = @"1";
        filePlugin = [FilePlugin alloc];
        filePlugin.delegate = self;
        
        //初始化年份
        NSDate* nowDate = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:nowDate];
        int nowYear = [dd year];
        
        self.arrayYears = [[NSMutableArray alloc] init];
        NSLog(@"%d",nowYear);
        for (int i = nowYear-4;i <= nowYear;i++)
        {
            [arrayYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *leftBtnImg = [UIImage imageNamed:@"common_btn_left"];
    UIImage *hlLeftBtnImg = [UIImage imageNamed:@"common_btn_left_hl"];
    UIImage *rightBtnImg = [UIImage imageNamed:@"common_btn_right"];
    UIImage *hlRightBtnImg = [UIImage imageNamed:@"common_btn_right_hl"];
    NSInteger leftCapWidth = leftBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = leftBtnImg.size.height * 0.5f;
    leftBtnImg = [leftBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    hlLeftBtnImg = [hlLeftBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    rightBtnImg = [rightBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    hlRightBtnImg = [hlRightBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    self.publicSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publicSearchBtn.frame = CGRectMake(0, 64, self.view.width/2, 44);
    [publicSearchBtn setBackgroundImage:leftBtnImg forState:UIControlStateNormal];
    [publicSearchBtn setBackgroundImage:hlLeftBtnImg forState:UIControlStateHighlighted];
    publicSearchBtn.backgroundColor = [UIColor clearColor];
    [publicSearchBtn setTitle:@"信息刊物" forState:UIControlStateNormal];
    [publicSearchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [publicSearchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [publicSearchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.view addSubview:publicSearchBtn];
    
    UIImageView *upAndDownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(publicSearchBtn.width-40, 12, 20, 20)];
    [upAndDownIcon setImage:[UIImage imageNamed:@"selectIcon"]];
    [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
    
    self.yearSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yearSearchBtn.frame = CGRectMake(self.view.width/2, 64, self.view.width/2, 44);
    [yearSearchBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [yearSearchBtn setBackgroundImage:hlRightBtnImg forState:UIControlStateHighlighted];
    yearSearchBtn.backgroundColor = [UIColor clearColor];
    [yearSearchBtn setTitle:@"年号" forState:UIControlStateNormal];
    [yearSearchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [yearSearchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [yearSearchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [yearSearchBtn addTarget:self action:@selector(yearSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yearSearchBtn];
    
    upAndDownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(yearSearchBtn.width-40, 12, 20, 20)];
    [upAndDownIcon setImage:[UIImage imageNamed:@"selectIcon"]];
    [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
    [yearSearchBtn addSubview:upAndDownIcon];
    
    self.infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, self.view.width, self.view.height-64-44) style:UITableViewStylePlain];
    self.infoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    infoTable.delegate = self;
    infoTable.dataSource = self;
    [self.view addSubview:infoTable];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    addN(@selector(publicSearchInfoBack:), @"PUBLICSEARCHDONE");
    addN(@selector(yearSearchInfoBack:), @"YEARSEARCHDONE");
    
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [infoTable setContentOffset:CGPointMake(0,0) animated:animated];
}

- (void)publicSearchInfoBack:(NSNotification *)notify
{
    NSDictionary *dic = (NSDictionary *)[notify userInfo];
    if ([[dic objectForKey:@"row"] isEqualToString:@"0"]) {
        publicSearchNumStr = @"";
        publicSearchStr =@"";
        [publicSearchBtn setTitle:@"所属刊物" forState:UIControlStateNormal];
    }
    else{
        publicSearchNumStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"dic"] objectForKey:@"intkwbh"]];
        publicSearchStr = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"dic"] objectForKey:@"strkwmc"]];
        [publicSearchBtn setTitle:[[dic objectForKey:@"dic"] objectForKey:@"strkwmc" ] forState:UIControlStateNormal];
    }
    [self reflashView];

}
- (void)yearSearchInfoBack:(NSNotification *)notify
{
    NSDictionary *dic = (NSDictionary *)[notify userInfo];
    if ([[dic objectForKey:@"name"] isEqualToString:@"所有"]) {
        yearSearchStr =@"";
        [yearSearchBtn setTitle:@"年号" forState:UIControlStateNormal];
    }
    else{
        yearSearchStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
        [yearSearchBtn setTitle:yearSearchStr forState:UIControlStateNormal];
    }
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
    footer.scrollView = self.infoTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self searchData];
    };
    footer_t=footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.infoTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self reflashView];
    };
    [header beginRefreshing];
    header_t = header;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.infoTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - 搜索刊物
- (void)searchData
{
    NSDictionary *publicSearchDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[ztOAGlobalVariable sharedInstance].intdwlsh,@"intdwlsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",@"15",@"intkwlb",yearSearchStr,@"intkwnh",nil];
    [self showWaitView];
    [ztOAService searchPublicationDirectoryList:publicSearchDic Success:^(id result)
     {
         [self closeWaitView];
         NSDictionary *dicData = [result objectFromJSONData];
         NSLog(@"dic==%@",dicData);
         if (dicData!=NULL && [[[dicData objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
             if (((NSMutableArray *)[[dicData objectForKey:@"root"]objectForKey:@"kwlb"]).count>0) {
                 
                 iRecentPageIndex++;
                 if ([[[dicData objectForKey:@"root"]objectForKey:@"kw"] isKindOfClass:[NSDictionary class]]) {
                     [dataListArray addObject:[[dicData objectForKey:@"root"]objectForKey:@"kwlb"] ];
                 }
                 else{
                     [dataListArray addObjectsFromArray:(NSMutableArray *)[[dicData objectForKey:@"root"]objectForKey:@"kwlb"]];
                 }
                 if (iRecentPageIndex>[[[dicData objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                     isLoadFinish=YES;
                 }
                 
             }
             [infoTable reloadData];
             [header_t endRefreshing];
             [footer_t endRefreshing];
         }         
         
     }Failed:^(NSError *error){
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
         [self closeWaitView];
         [header_t endRefreshing];
         [footer_t endRefreshing];
     }];

}
#pragma mark -tableview delegate-
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (infoTable==tableView) {
        if (indexPath.row<dataListArray.count) {
            static NSString *cellId = @"SearchList";
            ztOAPublicListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if(!cell){
                cell = [[ztOAPublicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
                [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
                [cell setSelectedBackgroundView:selectView];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            cell.name.text = [NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"chrkwbt"]];
            cell.publicDate.text =[ztOASmartTime intervalSinceNow:[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dtmkwfbrq"]]];
            if ([publicSearchStr isEqualToString:@""]) {
                cell.detailInfo.text = [NSString stringWithFormat:@"%@－%@期",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"intkwnh"],[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"intkwqh"]];
            }
            else{
                cell.detailInfo.text = [NSString stringWithFormat:@"%@ | %@－%@期",publicSearchStr,[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"intkwnh"],[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"intkwqh"]];
            }
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
    if (infoTable==tableView) {
        return 60;
    }
    else    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (infoTable == tableView) {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *fileObj = [dataListArray objectAtIndex:indexPath.row];
            NSDictionary *publicDic = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"intkwlsh"]],@"intkwlsh", nil] ;
            [self showWaitView];
            [ztOAService getPublicDetailDirectory:publicDic Success:^(id result){
                [self closeWaitView];
                NSDictionary *resultDataDic = [result objectFromJSONData];
                NSLog(@"%@",resultDataDic);
                
                ztOANoticeDetialViewController *publicVC = [[ztOANoticeDetialViewController alloc] initWithType:@"3" Data:[[resultDataDic objectForKey:@"root"] objectForKey:@"kwxx"]];
                 publicVC.title=@"刊物详情";
                [self.navigationController pushViewController:publicVC animated:YES];
            } Failed:^(NSError *error){
                [self closeWaitView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
            
        }
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (infoTable==tableView) {
        return dataListArray.count;
    }
    else return 0;
}
#pragma mark --------------DropDownList-----------------

- (void)publicSearchAction:(id)sender
{
    isPublicOrYearSearch = @"1";
    //获取刊物目录
    if (pulicDicArray.count==0) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",nil];
        [self showWaitView];
        [ztOAService getPublicationDirectory:dic Success:^(id result){
            [self closeWaitView];
            NSDictionary *resultDic = [result objectFromJSONData];
            NSLog(@"%@",resultDic);
            if (resultDic!=NULL && [[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                self.pulicDicArray = [[NSMutableArray alloc] init];
                if ([[[resultDic objectForKey:@"root"] objectForKey:@"kw"] isKindOfClass:[NSDictionary class]]) {
                    [pulicDicArray addObject:[[resultDic objectForKey:@"root"] objectForKey:@"kw"]];
                }
                else
                {
                    [pulicDicArray addObjectsFromArray:[[resultDic objectForKey:@"root"] objectForKey:@"kw"]];
                }
                if (pulicDicArray.count!=0) {
                    ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"请选择所属刊物" listArray:pulicDicArray whichType:@"4"];
                    [self.navigationController pushViewController:listVC animated:YES];
                }
            }
            
        } Failed:^(NSError *error){
            [self closeWaitView];
        }];
    }
    else{
        ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"请选择所属刊物" listArray:pulicDicArray whichType:@"4"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}
- (void)yearSearchAction:(id)sender
{
    isPublicOrYearSearch = @"2";
    ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"请选择年号" listArray:arrayYears whichType:@"5"];
    [self.navigationController pushViewController:listVC animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==infoTable) {
        if (infoTable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
