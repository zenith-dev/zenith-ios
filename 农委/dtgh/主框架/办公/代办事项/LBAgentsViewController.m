//
//  LBAgentsViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgentsViewController.h"
#import "SHbsTableViewCell.h"
#import "LBAgentsSwitchViewController.h"
@interface LBAgentsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *agentstb;
    NSMutableArray *agentsary;//数据列表
    NSInteger currentPage;
    BOOL isfresh;
}
@end
#define pageRows 10
@implementation LBAgentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-----------界面初始化-----------------
-(void)initview
{
    agentstb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    agentstb.dataSource=self;
    [agentstb setBackgroundColor:[SingleObj defaultManager].backColor];
    agentstb.delegate=self;
    agentstb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:agentstb];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    agentstb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [agentstb.mj_header beginRefreshing];
}
-(void)updata
{
    [agentstb.mj_header beginRefreshing];
}
-(void)loadNewData
{
    currentPage=1;
    [SHNetWork getWaitTaskView:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                    agentstb.mj_footer=nil;
                    agentsary=[[NSMutableArray alloc]init];
                    [agentstb reloadData];
                }
                else
                {
                    if (tempary.count==pageRows) {
                        __unsafe_unretained __typeof(self) weakSelf = self;
                        agentstb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf loadMoreData];
                        }];
                    }
                    agentsary=[[NSMutableArray alloc]initWithArray:tempary];
                    [agentstb reloadData];
                    [SVProgressHUD dismiss];
                }
                
               
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
        [agentstb.mj_header endRefreshing];
    }];
    
}
-(void)loadMoreData
{
    currentPage++;
    [SHNetWork getWaitTaskView:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count<pageRows) {
                    agentstb.mj_footer=nil;
                }
                [agentsary addObjectsFromArray:tempary];
                [agentstb reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
        [agentstb.mj_footer endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return agentsary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setBackgroundColor:[SingleObj defaultManager].backColor];
    }
    NSDictionary *dic =[agentsary objectAtIndex:indexPath.row];
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(10,10, kScreenWidth-20, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    //公文字号:
    UIImageView *lgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    lgimg.contentMode=UIViewContentModeScaleAspectFit;
    [lgimg setImage:PNGIMAGE(@"do-ico")];
    ViewRadius(lgimg, H(lgimg)/2.0);
    [headerview addSubview:lgimg];
    if ([[dic objectForKey:@"strckbz"] isEqualToString:@"未读"]) {
        UIImageView *newimg=[[UIImageView alloc]initWithFrame:CGRectMake(XW(lgimg), 0, 15, 15)];
        [newimg setImage:PNGIMAGE(@"icon_new")];
        newimg.center=CGPointMake(XW(lgimg), Y(lgimg)+5);
        [headerview addSubview:newimg];
    }
    UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lgimg)+5, Y(lgimg), W(headerview)-(XW(lgimg)+10), 30)];
    gwzhlb.textColor=[SingleObj defaultManager].origColor;
    gwzhlb.font=Font(14);
    gwzhlb.text=[NSString stringWithFormat:@"工作任务：%@",[dic objectForKey:@"strgzrwmc"]];
    [headerview addSubview:gwzhlb];
    //横线
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(X(lgimg), YH(gwzhlb)+4, W(headerview)-10, 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:oneline];
    //正文
    UILabel *strgwzlb=[[UILabel alloc]initWithFrame:CGRectMake(X(oneline), YH(oneline)+5, W(oneline), 21)];
    NSMutableString *gwzstr=[NSMutableString string];
    
    if (![Tools isBlankString:[dic objectForKey:@"strlzlxmc"]])
    {
        [gwzstr appendFormat:@"【%@】",[dic objectForKey:@"strlzlxmc"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"strgwbt"]]) {
        [gwzstr appendFormat:@"%@",[dic objectForKey:@"strgwbt"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"strgwz"]]) {
        [gwzstr appendFormat:@"(%@",[dic objectForKey:@"strgwz"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"intgwnh"]]) {
        [gwzstr appendFormat:@"〔%@〕",[dic objectForKey:@"intgwnh"]];
    }
    if (![Tools isBlankString:[dic objectForKey:@"intgwqh"]])
    {
        [gwzstr appendFormat:@"%@号)",[dic objectForKey:@"intgwqh"]];
    }
    strgwzlb.text=gwzstr;
    strgwzlb.numberOfLines=0;
    strgwzlb.font=Font(16);
    strgwzlb.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize contentFontSize =[strgwzlb.text boundingRectWithSize:CGSizeMake(W(strgwzlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(16)} context:nil].size;
    //CGSize contentFontSize=[strgwzlb.text sizeWithFont:Font(16) constrainedToSize:CGSizeMake(W(strgwzlb), 500) lineBreakMode:NSLineBreakByCharWrapping];
    strgwzlb.frame=CGRectMake(X(strgwzlb), Y(strgwzlb), W(strgwzlb),contentFontSize.height);
    [headerview addSubview:strgwzlb];
    //横线
    UIImageView *twoline=[[UIImageView alloc]initWithFrame:CGRectMake(X(lgimg), YH(strgwzlb)+4, W(headerview)-10, 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:twoline];
    //来文单位
    UILabel *gzrwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(twoline), YH(twoline)+4, W(headerview)/2-5+20, 20)];
    gzrwlb.font=Font(12);
    gzrwlb.adjustsFontSizeToFitWidth=YES;
    gzrwlb.textColor=[SingleObj defaultManager].subtitleColor;
    gzrwlb.text=[NSString stringWithFormat:@"%@：%@",[[dic objectForKey:@"strlzlx"] isEqualToString:@"001"]?@"来文单位":@"起草部门",[dic objectForKey:@"strfwdwmc"]];
    [headerview addSubview:gzrwlb];
    //发文时间
    UILabel *fwlxlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gzrwlb), Y(gzrwlb), W(headerview)-(XW(gzrwlb)+10), H(gzrwlb))];
    fwlxlb.textAlignment=NSTextAlignmentRight;
    fwlxlb.font=Font(12);
    fwlxlb.textColor=[SingleObj defaultManager].subtitleColor;
    ;
    fwlxlb.text=[NSString stringWithFormat:@"%@",[Tools dateToStr:[Tools strToDate:[dic objectForKey:@"dtmfssj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"MM-dd HH:mm"]];
    [headerview addSubview:fwlxlb];
    
    UIImageView *threeline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(gzrwlb)+9, W(headerview), 1)];
    [threeline setBackgroundColor:[SingleObj defaultManager].boderlineColor];
    [headerview addSubview:threeline];
    headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview), YH(threeline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LBAgentsSwitchViewController *lbagentsdetail=[[LBAgentsSwitchViewController alloc]init];
    NSDictionary *dic =[agentsary objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"strckbz"] isEqualToString:@"未读"]) {
        isfresh=YES;
        NSMutableDictionary *noticdic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        [noticdic setObject:@"已读" forKey:@"strckbz"];
        [agentsary replaceObjectAtIndex:indexPath.row withObject:noticdic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    lbagentsdetail.lstdic=dic;
    lbagentsdetail.intgwlzlsh=[dic objectForKey:@"intgwlzlsh"];
    lbagentsdetail.intbzjllsh=[dic objectForKey:@"intbzjllsh"];
    lbagentsdetail.title=@"公文办理";
    [self.navigationController pushViewController:lbagentsdetail animated:YES];
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
