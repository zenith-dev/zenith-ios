//
//  PlanningDocVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "PlanningDocVC.h"
#import "PlanModel.h"
#import "PlanDocCell.h"
#import "PlanListVC.h"
@interface PlanningDocVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *planndoctb;
@property (nonatomic,strong)NSMutableArray *showlist;
@property (nonatomic,strong)NSMutableArray *planlist;
@end

@implementation PlanningDocVC
@synthesize planndoctb,planlist,showlist;
- (void)viewDidLoad {
    [super viewDidLoad];
    planlist =[[NSMutableArray alloc]init];
    showlist =[[NSMutableArray alloc]init];
    PlanModel *oneplan=[[PlanModel alloc]init];
    oneplan.fllx =@"1";
    oneplan.strmlccbm=@"";
    oneplan.strmlmc=@"院内资料";
    oneplan.isOpen=YES;
    oneplan.nodeint=0;
    oneplan.childlst=[[NSMutableArray alloc]init];
    [planlist addObject:oneplan];
    [self getdatanode:oneplan];
    PlanModel *twoplan=[[PlanModel alloc]init];
    twoplan.fllx =@"0";
    twoplan.strmlccbm=@"";
    twoplan.strmlmc=@"个人文档";
    twoplan.isOpen=YES;
    twoplan.nodeint=0;
    twoplan.childlst=[[NSMutableArray alloc]init];
    [planlist addObject:twoplan];
    planndoctb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    planndoctb.delegate=self;
    planndoctb.dataSource=self;
    [self.view addSubview:planndoctb];
    // Do any additional setup after loading the view.
}
-(void)reloadlist:(NSMutableArray*)plist{
    for (PlanModel *rootplan in plist) {
        [showlist addObject:rootplan];
        if (rootplan.isOpen==YES&&rootplan.childlst.count>0) {
            [self reloadlist:rootplan.childlst];
        }
    }
    [planndoctb reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showlist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PlanDocCell";
    PlanModel *planmodel=showlist[indexPath.row];
    PlanDocCell *cell = (PlanDocCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[PlanDocCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.planmodel=planmodel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     PlanModel *planmodel=showlist[indexPath.row];
    if (planmodel.isOpen==YES&&planmodel.childlst.count==0) {
        [self getdatanode:planmodel];
    }else
    {
        planmodel.isOpen=!planmodel.isOpen;
        [showlist removeAllObjects];
        [self reloadlist:planlist];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----------------------数据请求------------------
-(void)getdatanode:(PlanModel*)planmodel{
    NSDictionary *informDic=@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"strmlccbm":planmodel.strmlccbm,@"strlx":planmodel.fllx};
    [self network:@"ggservices" requestMethod:@"getGrwdml" requestHasParams:@"true" parameter:informDic progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSLog(@"%@",[rep mj_JSONString]);
            if ([rep[@"root"] intValue]==0) {
                if ([rep[@"wdml"] isKindOfClass:[NSArray class]]) {
                    NSArray *scopary=rep[@"wdml"];
                    NSMutableArray *nodelst=[[NSMutableArray alloc]init];
                    for (NSDictionary *scopdic in scopary) {
                        PlanModel *scopplan=[[PlanModel alloc]init];
                        scopplan.intmllx=scopdic[@"intmllx"];
                        scopplan.strmlccbm=scopdic[@"strmlccbm"];
                        scopplan.strmlmc=scopdic[@"strmlmc"];
                        scopplan.intwdmllsh=scopdic[@"intwdmllsh"];
                        scopplan.isOpen=planmodel.isOpen;
                        scopplan.nodeint=planmodel.nodeint+1;
                        scopplan.fllx=planmodel.fllx;
                        [nodelst addObject:scopplan];
                    }
                    planmodel.childlst=nodelst;
                    [showlist removeAllObjects];
                    [self reloadlist:planlist];
                }else if([rep[@"wdml"] isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *scopdic=rep[@"wdml"];
                    NSMutableArray *nodelst=[[NSMutableArray alloc]init];
                    PlanModel *scopplan=[[PlanModel alloc]init];
                    scopplan.intmllx=scopdic[@"intmllx"];
                    scopplan.strmlccbm=scopdic[@"strmlccbm"];
                    scopplan.strmlmc=scopdic[@"strmlmc"];
                    scopplan.intwdmllsh=scopdic[@"intwdmllsh"];
                    scopplan.isOpen=planmodel.isOpen;
                    scopplan.nodeint=planmodel.nodeint+1;
                    scopplan.fllx=planmodel.fllx;
                    [nodelst addObject:scopplan];
                    planmodel.childlst=nodelst;
                    [showlist removeAllObjects];
                    [self reloadlist:planlist];
                }
                else
                {
                    PlanListVC *planlstvc=[[PlanListVC alloc]initWithTitle:@"规划文档"];
                    planlstvc.planmodel=planmodel;
                    [self.navigationController pushViewController:planlstvc animated:YES];
                }
            }
        }
    }];
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
