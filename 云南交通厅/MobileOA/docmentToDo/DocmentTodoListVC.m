//
//  DocmentTodoListVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "DocmentTodoListVC.h"
#import "CTextField.h"
#import "DocToDoModel.h"
#import "DocMentCell.h"
#import "DocDealVC.h"
@interface DocmentTodoListVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)int numpage;
@property (nonatomic,strong)NSMutableArray *listAry;
@property (nonatomic,strong)UITableView *sdTable;
@property (nonatomic,strong) CTextField *mysearchBar;
@end

@implementation DocmentTodoListVC
@synthesize  type,searchBarStr,numpage,listAry,sdTable,mysearchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([type isEqualToString:@"016"]) {
        searchBarStr=@"";
       // searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
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
    
    if ([type isEqualToString:@"016"])
    {//查询公文列表
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getDclgwList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
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
                else
                {
                    if (numpage==1) {
                        listAry =[[NSMutableArray alloc]init];
                        [sdTable.mj_header endRefreshing];
                        [sdTable reloadData];
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
    if ([type isEqualToString:@"016"])
    {
        searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
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
        if ([type isEqualToString:@"016"]){
            searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",mysearchBar.text,@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        }
    }else{
         if ([type isEqualToString:@"016"])
         {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        }
        [self showMessage:@"请输入公文标题进行查询"];
        return;
    }
    numpage=1;
    [self searchList];
}
#pragma mark---------搜索-----------------------
-(void)searchList{
    if ([type isEqualToString:@"016"])
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"document" requestMethod:@"getDclgwList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
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
    static NSString *identifier = @"NoticeCell";
    DocMentCell *cell = (DocMentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DocMentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.doctodoModel=listAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DocDealVC *docdealvc=[[DocDealVC alloc]initWithTitle:@"公文信息"];
    docdealvc.doctodoModel=listAry[indexPath.row];
    docdealvc.callback=^(BOOL issu){
        if (issu) {
            [sdTable.mj_header beginRefreshing];
            if (self.callback) {
                self.callback(YES);
            }
        }
    };
    [self.navigationController pushViewController:docdealvc animated:YES];
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
