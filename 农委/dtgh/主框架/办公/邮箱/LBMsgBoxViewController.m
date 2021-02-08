//
//  LBMsgBoxViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBMsgBoxViewController.h"
#import "SHbsTableViewCell.h"
#import "LBMsgBoxDetailViewController.h"
#import "LBWorkViewController.h"
@interface LBMsgBoxViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *agentstb;
    NSInteger currentPage;
    NSMutableArray *agentsary;//数据列表
    BOOL isfresh;
}
@end
#define pageRows 10
@implementation LBMsgBoxViewController

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
-(void)loadNewData
{
    currentPage=1;
    [SHNetWork getReceiveMailList:@"0" intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                     agentstb.mj_footer=nil;
                }
                else
                {
                    if (tempary.count==pageRows) {
                        __unsafe_unretained __typeof(self) weakSelf = self;
                        agentstb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf loadMoreData];
                        }];
                    }
                    [SVProgressHUD dismiss];
                    agentsary=[[NSMutableArray alloc]initWithArray:tempary];
                    [agentstb reloadData];
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
    [SHNetWork getReceiveMailList:@"0" intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
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
        [agentstb.mj_header endRefreshing];
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
    int isread=[[dic objectForKey:@"strczbz"] intValue];
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(10,10, kScreenWidth-20, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    //公文字号:
    UIImageView *lgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    lgimg.contentMode=UIViewContentModeScaleAspectFit;
    if (isread==0) {
       [lgimg setImage:PNGIMAGE(@"maillist-ico")];
    }
    else
    {
        [lgimg setImage:PNGIMAGE(@"maillist-icogrey")];
    }
    ViewRadius(lgimg, H(lgimg)/2.0);
    [headerview addSubview:lgimg];
    UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lgimg)+5, lgimg.center.y-10, W(headerview)-(XW(lgimg)+10), 20)];
    gwzhlb.font=Font(14);
    gwzhlb.text=[dic objectForKey:@"strtzbt"];
    if (isread==0) {
        gwzhlb.textColor=[UIColor blackColor];
    }
    else
    {
        gwzhlb.textColor=[SingleObj defaultManager].subtitleColor;
    }
    gwzhlb.numberOfLines=0;
    CGSize gwzhSizeFont =[[dic objectForKey:@"strtzbt"] boundingRectWithSize:CGSizeMake(W(gwzhlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
    //CGSize gwzhSizeFont =[[dic objectForKey:@"strtzbt"] sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(gwzhlb), 500) lineBreakMode:NSLineBreakByWordWrapping];
    gwzhlb.frame=CGRectMake(X(gwzhlb), Y(gwzhlb), W(gwzhlb), gwzhSizeFont.height);
    [headerview addSubview:gwzhlb];

    //发送人
    UILabel *gzrwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(gwzhlb), YH(gwzhlb), W(headerview)/2-5+20, 20)];
    gzrwlb.font=Font(12);
    gzrwlb.adjustsFontSizeToFitWidth=YES;
    
    gzrwlb.text=[NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"strcsjc"],[dic objectForKey:@"strryxm"]];
    if (isread==0) {
       gzrwlb.textColor=[SingleObj defaultManager].emailColor;
    }else
    {
        gzrwlb.textColor=[SingleObj defaultManager].subtitleColor;
    }
    [headerview addSubview:gzrwlb];
    //发文时间
    UILabel *fwlxlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gzrwlb), Y(gzrwlb), W(headerview)-(XW(gzrwlb)+10), H(gzrwlb))];
    fwlxlb.textAlignment=NSTextAlignmentRight;
    fwlxlb.font=Font(12);
    if (isread==0) {
        fwlxlb.textColor=[SingleObj defaultManager].emailColor;
    }else
    {
        fwlxlb.textColor=[SingleObj defaultManager].subtitleColor;
    }
    fwlxlb.text=[NSString stringWithFormat:@"%@",[Tools dateToStr:[Tools strToDate:[dic objectForKey:@"dtmdjsj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy-MM-dd"]];
    [headerview addSubview:fwlxlb];
    
    UIImageView *threeline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(gzrwlb)+5, W(headerview), 1)];
    [threeline setBackgroundColor:[SingleObj defaultManager].boderlineColor];
    [headerview addSubview:threeline];
    headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview), YH(threeline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic =[agentsary objectAtIndex:indexPath.row];
    int isread=[[dic objectForKey:@"strczbz"] intValue];
    if (isread==0) {
        isfresh=YES;
        NSMutableDictionary *agdic=[NSMutableDictionary dictionaryWithDictionary:dic];
        [agdic setObject:@"1" forKey:@"strczbz"];
        [agentsary replaceObjectAtIndex:indexPath.row withObject:agdic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    LBMsgBoxDetailViewController *lbmsgboxdetail=[[LBMsgBoxDetailViewController alloc]init];
    lbmsgboxdetail.title=@"邮件详情";
    lbmsgboxdetail.emailInfodic=dic;
    [self.navigationController pushViewController:lbmsgboxdetail animated:YES];
}
-(void)backPage
{
    if (isfresh==YES) {
        for (id views in self.navigationController.viewControllers) {
            if ([views isKindOfClass:[LBWorkViewController class]]) {
                LBWorkViewController *lbwork=(LBWorkViewController*)views;
                [lbwork updata];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
