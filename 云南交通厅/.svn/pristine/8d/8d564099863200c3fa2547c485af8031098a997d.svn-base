//
//  MyCollectVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/15.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "MyCollectVC.h"
#import "DocToDoModel.h"
#import "DocMentCell.h"
#import "DocMentModel.h"
#import "SdMkCell.h"
#import "GwlzxxDetailVC.h"
@interface MyCollectVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *listary;
@property (nonatomic,strong)UIButton *gwxqBtn;
@property (nonatomic,strong)UIButton *cllcBtn;
@property (nonatomic,strong)UILabel *slidLabel;
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UITableView *yjtb;//邮件
@property (nonatomic,strong)UITableView *gwtb;//公文列表
@property (nonatomic,strong)NSArray *gwAry;//公文列表
@property (nonatomic,strong)NSArray *yjAry;//邮件


@end

@implementation MyCollectVC
@synthesize listary,gwxqBtn,cllcBtn,slidLabel,tableScrollView,yjtb,gwtb,gwAry,yjAry;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"清除" image:nil sel:@selector(clearSEL)];
    gwAry=[[NSUserDefaults standardUserDefaults] objectForKey:@"gwsc"];
    [self initview];
    // Do any additional setup after loading the view.
}
-(void)clearSEL{
    NSMutableArray *tempary=[[NSMutableArray alloc]init];
    [[NSUserDefaults standardUserDefaults]setObject:tempary forKey:@"gwsc"];
     gwAry=tempary;
    [gwtb reloadData];
}
-(void)initview{
    UIView *tabView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    tabView.backgroundColor = UIColorFromRGB(0xE7E7E7);
    gwxqBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    gwxqBtn.frame=CGRectMake(0, 0, tabView.width/2.0, 40);
    gwxqBtn.titleLabel.font=Font(16);
    gwxqBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [gwxqBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gwxqBtn bk_addEventHandler:^(id sender) {
        [self swipScr:gwxqBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [gwxqBtn setTitle:@"公文" forState:UIControlStateNormal];
    [tabView addSubview:gwxqBtn];
    //cllcBtn
    cllcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cllcBtn.frame = CGRectMake(gwxqBtn.right,gwxqBtn.top,gwxqBtn.width,gwxqBtn.height);
    cllcBtn.titleLabel.font=Font(16);
    cllcBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [cllcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cllcBtn setTitle:@"邮件" forState:UIControlStateNormal];
    [cllcBtn bk_addEventHandler:^(id sender) {
        [self swipScr:cllcBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:cllcBtn];
    
    
    slidLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,38,gwxqBtn.width-20,2)];
    slidLabel.backgroundColor = SingObj.mainColor;
    [tabView addSubview:slidLabel];
    slidLabel.centerX=gwxqBtn.centerX;
    [self.view addSubview:tabView];
    
    tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,tabView.bottom,kScreenWidth,kScreenHeight-tabView.bottom)];
    tableScrollView.pagingEnabled = YES;
    tableScrollView.clipsToBounds = NO;
    tableScrollView.backgroundColor = [UIColor whiteColor];
    tableScrollView.contentSize = CGSizeMake(tableScrollView.frame.size.width * 2, tableScrollView.frame.size.height);
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.scrollsToTop = NO;
    tableScrollView.delegate = self;
    [tableScrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:tableScrollView];
    //公文信息列表
    gwtb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tableScrollView.height) style:UITableViewStyleGrouped];
    [gwtb setBackgroundColor:[UIColor whiteColor]];
    gwtb.separatorStyle=UITableViewCellSeparatorStyleNone;
    gwtb.delegate=self;
    gwtb.dataSource=self;
    [tableScrollView addSubview:gwtb];
    
    
    yjtb =[[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableScrollView.height) style:UITableViewStyleGrouped];
    [yjtb setBackgroundColor:[UIColor whiteColor]];
    yjtb.separatorStyle=UITableViewCellSeparatorStyleNone;
    yjtb.delegate=self;
    yjtb.dataSource=self;
    [tableScrollView addSubview:yjtb];
}
#pragma mark---------------滑动-------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tableScrollView.frame.size.width;
    int page = floor((self.tableScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page==0) {
        [self swipScr:gwxqBtn];
    }else if (page==1)
    {
        [self swipScr:cllcBtn];
    }
}

-(void)swipScr:(UIButton*)sender
{
    int pagenum=0;
    if (sender==cllcBtn) {
        pagenum=1;
    }else if (gwxqBtn==sender)
    {
        pagenum=0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        slidLabel.centerX=sender.centerX;
        [tableScrollView setContentOffset:CGPointMake(kScreenWidth*pagenum, 0)];
    }];
}
#pragma mark-------------------办理过程----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==gwtb) {
        return gwAry.count;
    }else
    {
        return yjAry.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==gwtb) {
        NSDictionary *gwdic=gwAry[indexPath.row];
        DocToDoModel *doctodomodel=[DocToDoModel mj_objectWithKeyValues:gwdic];
        static NSString *identifier = @"NoticeCell";
        DocMentCell *cell = (DocMentCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[DocMentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        cell.doctodoModel=doctodomodel;
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
    NSString *tltestr=@"公文信息";
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GwlzxxDetailVC *gwlxxdetail=[[GwlzxxDetailVC alloc]initWithTitle:tltestr];
    NSDictionary *gwdic=gwAry[indexPath.row];
    DocToDoModel *sdmkModel=[DocToDoModel mj_objectWithKeyValues:gwdic];
    gwlxxdetail.intgwlzlsh=[NSString stringWithFormat:@"%@",sdmkModel.intgwlzlsh];
    gwlxxdetail.intgwlsh=[NSString stringWithFormat:@"%@",sdmkModel.intgwlsh];
    gwlxxdetail.doctodomodel=sdmkModel;
    gwlxxdetail.ngrqstr=[NSString stringWithFormat:@"%@",sdmkModel.dtmfssj.length>16?[sdmkModel.dtmfssj substringToIndex:16]:@""];
    if ([sdmkModel.chrlzlx isEqualToString:@"发文"]) {
        gwlxxdetail.type=@"014";
        gwlxxdetail.gwlx=@"1";
    }
    else if([sdmkModel.chrlzlx isEqualToString:@"收文"])
    {
        gwlxxdetail.type=@"016";
        gwlxxdetail.gwlx=@"0";
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
