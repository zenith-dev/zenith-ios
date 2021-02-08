//
//  CslwLstVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/9/8.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "CslwLstVC.h"
#import "CTextField.h"
#import "SdmkModel.h"
#import "SdMkCell.h"
@interface CslwLstVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,assign)int numpage;
@property (nonatomic,strong)NSMutableArray *listAry;
@property (nonatomic,strong)UITableView *sdTable;
@property (nonatomic,strong) CTextField *mysearchBar;
@end

@implementation CslwLstVC
@synthesize searchBarStr,listAry,mysearchBar,sdTable,numpage;
- (void)viewDidLoad {
    [super viewDidLoad];
    searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt></root>"] ;
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
    NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
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
}
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt></root>"] ;
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
         searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt></root>",mysearchBar.text];
    }else
    {
        searchBarStr=[NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt></root>"] ;        [self showMessage:@"请输入公文标题进行查询"];
        return;
    }
    numpage=1;
    [self searchList];
}
#pragma mark---------搜索-----------------------
-(void)searchList{
    NSDictionary *dataDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh", @(numpage),@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
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
        SdMkCell *cell = (SdMkCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[SdMkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        if ([listAry[indexPath.row] isKindOfClass:[DocMentModel class]]) {
            cell.docmentModel=listAry[indexPath.row];
        }else if ([listAry[indexPath.row] isKindOfClass:[SdmkModel class]])
        {
            cell.sdmkModel=listAry[indexPath.row];
        }
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showMessage:@"请在PC端进行来文登记"];
    
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
