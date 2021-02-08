//
//  PlanListVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "PlanListVC.h"
#import "CTextField.h"
#import "PlanListCCell.h"
#import "PlanListDocModel.h"
#import "PlanlistDetailVC.h"
@interface PlanListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *planlisttb;
@property (nonatomic,strong)NSMutableArray *planlst;
@property (nonatomic,strong) CTextField *mysearchBar;
@property (nonatomic,assign)int numpage;
@property (nonatomic,strong)NSString *searchBarStr;
@end

@implementation PlanListVC
@synthesize  planmodel,planlisttb,planlst,mysearchBar,numpage,searchBarStr;
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strwdbt></strwdbt><intwdmllsh>%@</intwdmllsh><strgxbz></strgxbz></root>",planmodel.intwdmllsh];
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
    planlisttb =[[UITableView alloc]initWithFrame:CGRectMake(0, mysearchBar.bottom, kScreenWidth, kScreenHeight-mysearchBar.bottom)];
    planlisttb.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    planlisttb.separatorStyle=UITableViewCellSeparatorStyleNone;
    planlisttb.dataSource=self;
    planlisttb.delegate=self;
    [self.view addSubview:planlisttb];
    __unsafe_unretained __typeof(self) weakSelf = self;
    planlisttb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        numpage=1;
        [weakSelf getGrWdList:YES];
    }];
    planlisttb.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        numpage++;
        [weakSelf getGrWdList:YES];
    }];
    numpage=1;
    [self getGrWdList:NO];
    // Do any additional setup after loading the view.
}
-(void)getGrWdList:(BOOL)isfresh{
      NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcslsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
    [self network:@"ggservices" requestMethod:@"getGrWdList" requestHasParams:@"true" parameter:dataDic progresHudText:isfresh==YES?nil:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSLog(@"%@",[rep mj_JSONString]);
            if ([rep[@"grwd"] isKindOfClass:[NSDictionary class]]) {
                PlanListDocModel *noticeModel=[PlanListDocModel mj_objectWithKeyValues:rep[@"grwd"]];
                if (numpage==1) {
                    planlst =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                    [planlisttb.mj_header endRefreshing];
                }else
                {
                    [planlst addObject:noticeModel];
                    [planlisttb.mj_footer endRefreshing];
                }
                [planlisttb reloadData];
                planlisttb.mj_footer.state=MJRefreshStateNoMoreData;
            }else if ([rep[@"grwd"] isKindOfClass:[NSArray class]]){
                NSArray *noticeary=[PlanListDocModel mj_objectArrayWithKeyValuesArray:rep[@"grwd"]];
                if (numpage==1) {
                    planlst =[[NSMutableArray alloc]initWithArray:noticeary];
                    [planlisttb.mj_header endRefreshing];
                }else
                {
                    [planlst addObjectsFromArray:noticeary];
                    [planlisttb.mj_footer endRefreshing];
                }
                [planlisttb reloadData];
                if (noticeary.count<10) {
                    planlisttb.mj_footer.state=MJRefreshStateNoMoreData;
                }else
                {
                    planlisttb.mj_footer.state=MJRefreshStateIdle;
                }
            }
        }
    }];
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strwdbt></strwdbt><intwdmllsh>%@</intwdmllsh><strgxbz></strgxbz></root>",planmodel.intwdmllsh];
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
    searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strwdbt>%@</strwdbt><intwdmllsh>%@</intwdmllsh><strgxbz></strgxbz></root>",mysearchBar.text,planmodel.intwdmllsh];
    }else
    {
         searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strwdbt></strwdbt><intwdmllsh>%@</intwdmllsh><strgxbz></strgxbz></root>",planmodel.intwdmllsh];
    }
    numpage=1;
    [self searchList];
}
#pragma mark---------搜索-----------------------
-(void)searchList{
    NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcslsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
    [self network:@"ggservices" requestMethod:@"getGrWdList" requestHasParams:@"true" parameter:dataDic progresHudText:@"搜索中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"grwd"] isKindOfClass:[NSDictionary class]]) {
                PlanListDocModel *noticeModel=[PlanListDocModel mj_objectWithKeyValues:rep[@"grwd"]];
                planlst =[[NSMutableArray alloc]initWithObjects:noticeModel, nil];
                [planlisttb.mj_header endRefreshing];
                [planlisttb reloadData];
                planlisttb.mj_footer.state=MJRefreshStateNoMoreData;
            }else if ([rep[@"grwd"] isKindOfClass:[NSArray class]]){
                NSArray *noticeary=[PlanListDocModel mj_objectArrayWithKeyValuesArray:rep[@"grwd"]];
                planlst =[[NSMutableArray alloc]initWithArray:noticeary];
                [planlisttb.mj_header endRefreshing];
                [planlisttb reloadData];
                if (noticeary.count<10) {
                    planlisttb.mj_footer.state=MJRefreshStateNoMoreData;
                }else
                {
                    planlisttb.mj_footer.state=MJRefreshStateIdle;
                }
            }else
            {
                [self showMessage:@"暂无数据"];
            }
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return planlst.count;
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
    PlanListCCell *cell = (PlanListCCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[PlanListCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.planmodel=planlst[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlanlistDetailVC *planlstdetailvc=[[PlanlistDetailVC alloc]initWithTitle:@"文档详情"];
    planlstdetailvc.planlistdocmodel=planlst[indexPath.row];
    [self.navigationController pushViewController:planlstdetailvc animated:YES];
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
