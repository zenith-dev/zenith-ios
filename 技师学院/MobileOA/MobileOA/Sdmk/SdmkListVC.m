//
//  SdmkListVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/1.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "SdmkListVC.h"
#import "SdmkModel.h"
#import "CTextField.h"
#import "SdMkCell.h"
#import "GwlzxxDetailVC.h"
#import "DocMentModel.h"
#import "DocToDoModel.h"
#import "DocMentCell.h"
@interface SdmkListVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)int numpage;
@property (nonatomic,strong)NSMutableArray *listAry;
@property (nonatomic,strong)UITableView *sdTable;
@property (nonatomic,strong) CTextField *mysearchBar;
@end

@implementation SdmkListVC
@synthesize  type,numpage,searchBarStr,listAry,sdTable,mysearchBar,searchDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]) {
       searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt><chrgwlb>%@</chrgwlb></root>",type] ;
    }
    listAry=[[NSMutableArray alloc]init];
    mysearchBar=[[CTextField alloc]initWithFrame:CGRectMake(5, 64+5, kScreenWidth-10-45, 35)];
    ViewBorderRadius(mysearchBar, 0, 1, RGBCOLOR(220, 220, 220));
    mysearchBar.delegate=self;
    mysearchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    mysearchBar.keyboardType=UIBarStyleDefault;
    mysearchBar.placeholder=@"请输入公文标题";
    mysearchBar.font=Font(14);
    [self.view addSubview:mysearchBar];
    
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(mysearchBar.right, mysearchBar.top, 45, mysearchBar.height)];
    [searchBtn setImage:PNGIMAGE(@"search") forState:UIControlStateNormal];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, 0, searchBtn.width, 1);
    bottomBorder.backgroundColor = RGBCOLOR(220, 220, 220).CGColor;
    [searchBtn.layer addSublayer:bottomBorder];
    
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0, searchBtn.height-1, searchBtn.width, 1);
    bottomBorder1.backgroundColor = RGBCOLOR(220, 220, 220).CGColor;
    [searchBtn.layer addSublayer:bottomBorder1];
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(searchBtn.width, 0, 1, searchBtn.height);
    bottomBorder2.backgroundColor = RGBCOLOR(220, 220, 220).CGColor;
    [searchBtn.layer addSublayer:bottomBorder2];
    [searchBtn bk_addEventHandler:^(id sender) {
        [self searchBtnClick];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    sdTable =[[UITableView alloc]initWithFrame:CGRectMake(0, mysearchBar.bottom, kScreenWidth, kScreenHeight-mysearchBar.bottom)];
    sdTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    sdTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    sdTable.dataSource=self;
    sdTable.delegate=self;
    [self.view addSubview:sdTable];
    __unsafe_unretained __typeof(self) weakSelf = self;
    sdTable.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        numpage=1;
        [weakSelf getSdmkcxList:YES];
    }];
    sdTable.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        numpage++;
        [weakSelf getSdmkcxList:YES];
    }];
    numpage=1;
    [self getSdmkcxList:NO];
    // Do any additional setup after loading the view.
}
#pragma mark-------加载数据------------
-(void)getSdmkcxList:(BOOL)isfresh{
    
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"])
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getSdmkcxList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    SdmkModel *noticeModel=[SdmkModel mj_objectWithKeyValues:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[SdmkModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }
            }
        }];
    }else if ([type isEqualToString:@"014"]){//查询公文列表
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getGwcxList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocMentModel *noticeModel=[DocMentModel mj_objectWithKeyValues:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocMentModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }
            }
        }];
    }else if ([type isEqualToString:@"015"]){//历史库查询列表
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys: @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getlsgwList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocMentModel *noticeModel=[DocMentModel mj_objectWithKeyValues:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocMentModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }
            }
        }];
    }else if ([type isEqualToString:@"017"])
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getGrGwList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocToDoModel *noticeModel=[DocToDoModel mj_objectWithKeyValues:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocToDoModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [sdTable.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [sdTable.mj_footer endRefreshing];
                    }
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }
            }
        }];
        
    }
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]) {
        searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt><chrgwlb>%@</chrgwlb></root>",type];

    }else if ([type isEqualToString:@"014"]||[type isEqualToString:@"015"])
    {
        searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2></root>",
                        @"",searchDic[@"chrgwz"],searchDic[@"intgwnh"],searchDic[@"intgwqh"],searchDic[@"chrgwlb"],searchDic[@"chrlwdwmc"],@"",@"",searchDic[@"dtmdjsj1"],searchDic[@"dtmdjsj2"]];
    }
    return  YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBtnClick];//搜索
}
//执行搜索操作
- (void)searchBtnClick
{
    [mysearchBar resignFirstResponder];
    if (mysearchBar.text.length!=0) {
        if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]){
             searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><chrgwlb>%@</chrgwlb></root>",mysearchBar.text,type];
        }
        else if ([type isEqualToString:@"014"]||[type isEqualToString:@"015"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2><gwlx>%@</gwlx></root>",
                            mysearchBar.text,searchDic[@"chrgwz"]?:@"",searchDic[@"intgwnh"]?:@"",searchDic[@"intgwqh"]?:@"",searchDic[@"chrgwlb"]?:@"",searchDic[@"chrlwdwmc"]?:@"",@"",@"",searchDic[@"dtmdjsj1"]?:@"",searchDic[@"dtmdjsj2"]?:@"",searchDic[@"gwlx"]?:@""];
        }
        else if([type isEqualToString:@"017"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt></root>",
                            mysearchBar.text];
        }
    }else
    {
        if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]) {
            searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt><chrgwlb>%@</chrgwlb></root>",type];
        }
        else if ([type isEqualToString:@"014"]||[type isEqualToString:@"015"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2><gwlx>%@</gwlx></root>",
                            @"",searchDic[@"chrgwz"]?:@"",searchDic[@"intgwnh"]?:@"",searchDic[@"intgwqh"]?:@"",searchDic[@"chrgwlb"]?:@"",searchDic[@"chrlwdwmc"]?:@"",@"",@"",searchDic[@"dtmdjsj1"],searchDic[@"dtmdjsj2"]?:@"",searchDic[@"gwlx"]?:@""];
        }
        else if ([type isEqualToString:@"017"])
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt></strgwbt></root>"];
        }
        [self showMessage:@"请输入公文标题进行查询"];
        return;
    }
    numpage=1;
    [self searchList];
}
#pragma mark---------搜索-----------------------
-(void)searchList{
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]) {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getSdmkcxList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    SdmkModel *noticeModel=[SdmkModel mj_objectWithKeyValues:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[SdmkModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    [self showMessage:@"暂无数据"];
                }
            }
        }];
    }else if ([type isEqualToString:@"014"])
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getGwcxList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocMentModel *noticeModel=[DocMentModel mj_objectWithKeyValues:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocMentModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    [self showMessage:@"暂无数据"];
                }
            }
        }];
    }else if ([type isEqualToString:@"015"]){
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys: @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getlsgwList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocMentModel *noticeModel=[DocMentModel mj_objectWithKeyValues:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocMentModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    [self showMessage:@"暂无数据"];
                }
            }
        }];
    }else if ([type isEqualToString:@"017"])
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];

        [self network:@"document" requestMethod:@"getGrGwList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"document"] isKindOfClass:[NSDictionary class]]) {
                    DocToDoModel *noticeModel=[DocToDoModel mj_objectWithKeyValues:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"document"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[DocToDoModel mj_objectArrayWithKeyValuesArray:rep[@"document"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [sdTable.mj_header endRefreshing];
                    [sdTable reloadData];
                    if (noticeary.count<10) {
                        sdTable.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        sdTable.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    [self showMessage:@"暂无数据"];
                }
            }
        }];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([listAry[indexPath.row] isKindOfClass:[DocToDoModel class]])
    {
        static NSString *identifier = @"NoticeCell";
        DocMentCell *cell = (DocMentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[DocMentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        cell.doctodoModel2=listAry[indexPath.row];
        return cell;
    }else
    {
        static NSString *identifier = @"NoticeCell";
        SdMkCell *cell = (SdMkCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[SdMkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        if ([searchDic[@"gwlx"] isEqualToString:@"1"]&&[self.type isEqualToString:@"014"]) {
            cell.isshow=YES;
        }
        if ([listAry[indexPath.row] isKindOfClass:[DocMentModel class]]) {
            cell.docmentModel=listAry[indexPath.row];
        }else if ([listAry[indexPath.row] isKindOfClass:[SdmkModel class]])
        {
            cell.sdmkModel=listAry[indexPath.row];
        }
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tltestr=@"公文信息";
    if ([type isEqualToString:@"010"]) {
        tltestr=@"签报件信息";
    }else if ([type isEqualToString:@"011"])
    {
         tltestr=@"便函信息";
    }
    else if([type isEqualToString:@"012"])
    {
        tltestr=@"信访信息";
    }
    else if ([type isEqualToString:@"013"])
    {
        tltestr=@"电话处理单信息";
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GwlzxxDetailVC *gwlxxdetail=[[GwlzxxDetailVC alloc]initWithTitle:tltestr];
    gwlxxdetail.type=type;
    if ([listAry[indexPath.row] isKindOfClass:[SdmkModel class]]) {
        SdmkModel *sdmkModel=listAry[indexPath.row];
        gwlxxdetail.intgwlzlsh=[NSString stringWithFormat:@"%@",@(sdmkModel.intgwlzlsh)];
        gwlxxdetail.intgwlsh=[NSString stringWithFormat:@"%@",@(sdmkModel.intgwlsh)];
        
        gwlxxdetail.sdmkmodel=sdmkModel;
        gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",sdmkModel.dtmfssj.length>16?[sdmkModel.dtmfssj substringToIndex:16]:@""];
    }else if ([listAry[indexPath.row] isKindOfClass:[DocToDoModel class]])
    {
        DocToDoModel *sdmkModel=listAry[indexPath.row];
        gwlxxdetail.intgwlzlsh=[NSString stringWithFormat:@"%@",sdmkModel.intgwlzlsh];
        gwlxxdetail.intgwlsh=[NSString stringWithFormat:@"%@",sdmkModel.intgwlsh];
        gwlxxdetail.doctodomodel=sdmkModel;
        gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",sdmkModel.dtmfssj.length>16?[sdmkModel.dtmfssj substringToIndex:16]:@""];
        if ([sdmkModel.chrlzlx isEqualToString:@"发文"]) {
            gwlxxdetail.type=@"016";
            gwlxxdetail.gwlx=@"0";
        }
        else if([sdmkModel.chrlzlx isEqualToString:@"收文"])
        {
            gwlxxdetail.type=@"014";
            gwlxxdetail.gwlx=@"1";
        }
        else if([sdmkModel.chrlzlx isEqualToString:@"便函"])
        {
            gwlxxdetail.type=@"011";
        }
        else if([sdmkModel.chrlzlx isEqualToString:@"电话记录单"])
        {
            gwlxxdetail.type=@"013";
        }
        else if([sdmkModel.chrlzlx isEqualToString:@"签报件"])
        {
             gwlxxdetail.type=@"010";
        }
        else if([sdmkModel.chrlzlx isEqualToString:@"信访"])
        {
             gwlxxdetail.type=@"012";
        }
    }
    else if ([listAry[indexPath.row] isKindOfClass:[DocMentModel class]])
    {
        DocMentModel *docment=listAry[indexPath.row];
        gwlxxdetail.intgwlsh=[NSString stringWithFormat:@"%@",@(docment.intgwlsh)];
        if ([type isEqualToString:@"015"]) {
            gwlxxdetail.intgwlzlsh=[NSString stringWithFormat:@"%@",@(docment.intgwlsh)];
            gwlxxdetail.docmentModel=docment;
        }else if ([type isEqualToString:@"014"])
        {
            
             gwlxxdetail.intgwlzlsh=[NSString stringWithFormat:@"%@",@(docment.intgwlzlsh)];
        }
        gwlxxdetail.gwlx=[searchDic[@"chrgwlb"] isEqualToString:@"001"]?@"1":@"0";
        if (docment.chrlzlx!=nil) {
            if ([docment.chrlzlx isEqualToString:@"发文"]) {
                gwlxxdetail.type=@"016";
                gwlxxdetail.gwlx=@"0";
                gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",docment.dtmfssj.length>16?[docment.dtmfssj substringToIndex:16]:@""];
            }else
            {
                gwlxxdetail.type=@"014";
                gwlxxdetail.gwlx=@"1";
                gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",docment.dtmfssj.length>16?[docment.dtmfssj substringToIndex:16]:@""];
            }
        }else
        {
             gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",docment.dtmrq.length>16?[docment.dtmrq substringToIndex:16]:@""];
        }
    }
    [self.navigationController pushViewController:gwlxxdetail animated:YES];
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
