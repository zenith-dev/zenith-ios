//
//  NoticeVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/28.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "NoticeGGVC.h"
#import "NoticeModel.h"
#import "TzModel.h"
#import "NoticeCell.h"
#import "CTextField.h"
#import "NoticeDetailVC.h"
@interface NoticeGGVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign)int pagenum;
@property (nonatomic,strong) NSString *searchBarStr;
@property (nonatomic,strong) UITableView *notictb;
@property (nonatomic,strong) CTextField *mysearchBar;
@property (nonatomic,strong) NSMutableArray *listAry;//数据列表
@end

@implementation NoticeGGVC
@synthesize pagenum,searchBarStr,listAry,notictb,mysearchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBarStr=@"";
    listAry=[[NSMutableArray alloc]init];
    mysearchBar=[[CTextField alloc]initWithFrame:CGRectMake(5, 64+5, kScreenWidth-10-45, 35)];
    ViewBorderRadius(mysearchBar, 0, 1, RGBCOLOR(220, 220, 220));
    mysearchBar.delegate=self;
    mysearchBar.clearButtonMode=UITextFieldViewModeWhileEditing;
    mysearchBar.keyboardType=UIBarStyleDefault;
    mysearchBar.placeholder=@"请输入搜索关键字";
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
    notictb =[[UITableView alloc]initWithFrame:CGRectMake(0, mysearchBar.bottom, kScreenWidth, kScreenHeight-mysearchBar.bottom)];
    notictb.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    notictb.separatorStyle=UITableViewCellSeparatorStyleNone;
    notictb.dataSource=self;
    notictb.delegate=self;
    [self.view addSubview:notictb];
    __unsafe_unretained __typeof(self) weakSelf = self;
    notictb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pagenum=1;
        [weakSelf getlist:YES];
    }];
    notictb.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pagenum++;
        [weakSelf getlist:YES];
    }];
    pagenum=1;
    [self getlist:NO];
    // Do any additional setup after loading the view.
}
- (void)getlist:(BOOL)isfresh{
    if (self.type==1) {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(pagenum),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"ggservices" requestMethod:@"getGgList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"gg"] isKindOfClass:[NSDictionary class]]) {
                    NoticeModel *noticeModel=[NoticeModel mj_objectWithKeyValues:rep[@"gg"]];
                    if (pagenum==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [notictb.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [notictb.mj_footer endRefreshing];
                    }
                    [notictb reloadData];
                    notictb.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"gg"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[NoticeModel mj_objectArrayWithKeyValuesArray:rep[@"gg"]];
                    if (pagenum==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [notictb.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [notictb.mj_footer endRefreshing];
                    }
                    [notictb reloadData];
                    if (noticeary.count<10) {
                        notictb.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        notictb.mj_footer.state=MJRefreshStateIdle;
                    }
                }
            }
        }];
    }
    else if (self.type==2)
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(pagenum),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"tzServices" requestMethod:@"getTzList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"notice"] isKindOfClass:[NSDictionary class]]) {
                    TzModel *noticeModel=[TzModel mj_objectWithKeyValues:rep[@"notice"]];
                    if (pagenum==1) {
                        listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                        [notictb.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObject:noticeModel];
                        [notictb.mj_footer endRefreshing];
                    }
                    [notictb reloadData];
                    notictb.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"notice"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[TzModel mj_objectArrayWithKeyValuesArray:rep[@"notice"]];
                    if (pagenum==1) {
                        listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                        [notictb.mj_header endRefreshing];
                    }else
                    {
                        [listAry addObjectsFromArray:noticeary];
                        [notictb.mj_footer endRefreshing];
                    }
                    [notictb reloadData];
                    if (noticeary.count<10) {
                        notictb.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        notictb.mj_footer.state=MJRefreshStateIdle;
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
    searchBarStr=@"";
    return  YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBtnClick];//搜索
}
#pragma mark----------------搜索按钮---------------
//执行搜索操作
- (void)searchBtnClick
{
    [mysearchBar resignFirstResponder];
    if (mysearchBar.text.length!=0) {
        if (self.type==1) {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strggbt>%@</strggbt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><tzckbz>%@</tzckbz></root>",
                            mysearchBar.text,
                            @"",
                            @"",
                            @""];
        }else if(self.type==2)
        {
            searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt>%@</strtzbt><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><tzckbz>%@</tzckbz></root>",
                             mysearchBar.text,
                            @"",
                            @"",
                            @""];
        }
    }else
    {
        searchBarStr=@"";
        [self showMessage:@"请输入标题关键字进行查询"];
        return;
    }
    pagenum=1;
    [self searchList];
}
#pragma mark---------搜索-----------------------
-(void)searchList{
    if (self.type==1) {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(pagenum),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"ggservices" requestMethod:@"getGgList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"gg"] isKindOfClass:[NSDictionary class]]) {
                    NoticeModel *noticeModel=[NoticeModel mj_objectWithKeyValues:rep[@"gg"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [notictb.mj_header endRefreshing];
                    [notictb reloadData];
                    notictb.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"gg"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[NoticeModel mj_objectArrayWithKeyValuesArray:rep[@"gg"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [notictb.mj_header endRefreshing];
                    [notictb reloadData];
                    if (noticeary.count<10) {
                        notictb.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        notictb.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    listAry =[[NSMutableArray alloc]init];
                    [notictb reloadData];
                    [self showMessage:@"暂无数据"];
                }
            }
        }];
    }
    else if (self.type==2)
    {
        NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(pagenum),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
        [self network:@"tzServices" requestMethod:@"getTzList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"notice"] isKindOfClass:[NSDictionary class]]) {
                    TzModel *noticeModel=[TzModel mj_objectWithKeyValues:rep[@"notice"]];
                    listAry =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [notictb.mj_header endRefreshing];
                    [notictb reloadData];
                    notictb.mj_footer.state=MJRefreshStateNoMoreData;
                }else if ([rep[@"notice"] isKindOfClass:[NSArray class]]){
                    NSArray *noticeary=[TzModel mj_objectArrayWithKeyValuesArray:rep[@"notice"]];
                    listAry =[[NSMutableArray alloc]initWithArray:noticeary];
                    [notictb.mj_header endRefreshing];
                    [notictb reloadData];
                    if (noticeary.count<10) {
                        notictb.mj_footer.state=MJRefreshStateNoMoreData;
                    }else
                    {
                        notictb.mj_footer.state=MJRefreshStateIdle;
                    }
                }else
                {
                    [self showMessage:@"暂无数据"];
                    listAry =[[NSMutableArray alloc]init];
                    [notictb reloadData];
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
    if (self.type==1) {
        static NSString *identifier = @"NoticeCell";
        NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        cell.noticeModel=listAry[indexPath.row];
        return cell;
    }else if (self.type==2)
    {
        static NSString *identifier = @"NoticeCell";
        NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[NoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        cell.ztModel=listAry[indexPath.row];
        return cell;
    }
    else
    {
        static NSString *identifier = @"NoticeCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type==1) {
        NoticeModel *noticeModel=listAry[indexPath.row];
        NoticeDetailVC  *noticeDetailvc=[[NoticeDetailVC alloc]initWithTitle:@"公告详情"];
        noticeDetailvc.type=self.type;
        noticeDetailvc.intgglsh=[NSString stringWithFormat:@"%@",@(noticeModel.intgglsh)];
        [self.navigationController pushViewController:noticeDetailvc animated:YES];
        noticeDetailvc.callback=^(BOOL issu){
            if (noticeModel.strcdbz==0) {
                noticeModel.strcdbz=1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.callback) {
                    self.callback(YES);
                }
            }
        };
    }else if (self.type==2)
    {
       TzModel *ztModel=listAry[indexPath.row];
        NoticeDetailVC  *noticeDetailvc=[[NoticeDetailVC alloc]initWithTitle:@"通知详情"];
        noticeDetailvc.type=self.type;
        if (ztModel.strckbz==0) {
            noticeDetailvc.callback=^(BOOL issu){
                ztModel.strckbz=1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.callback) {
                    self.callback(YES);
                }
            };
        }
        noticeDetailvc.intgglsh=[NSString stringWithFormat:@"%@",@(ztModel.inttzlsh)];
        [self.navigationController pushViewController:noticeDetailvc animated:YES];
    }
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
