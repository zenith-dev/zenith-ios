//
//  LBNoticeViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBNoticeViewController.h"
#import "SHbsTableViewCell.h"
#import "LBNoticeDetailViewController.h"
#import "LBWorkViewController.h"
@interface LBNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger currentPage;
    NSMutableArray *noticeary;
    UITableView *noticetb;
    BOOL isfresh;
}
@end
#define pageRows 10
@implementation LBNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-----------界面初始化-----------------
-(void)initview
{
    noticetb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    noticetb.showsVerticalScrollIndicator=NO;
    noticetb.dataSource=self;
    noticetb.delegate=self;
    [noticetb setBackgroundColor:[SingleObj defaultManager].backColor];
    noticetb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:noticetb];
    [SVProgressHUD showWithStatus:@"加载中..."];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    noticetb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [noticetb.mj_header beginRefreshing];
}
-(void)loadNewData
{
    currentPage=1;
    [SHNetWork noticeList:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"stralldwlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                    noticetb.mj_footer=nil;
                }
                else
                {
                    [SVProgressHUD dismiss];
                    if (tempary.count==pageRows) {
                        __unsafe_unretained __typeof(self) weakSelf = self;
                        noticetb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                            [weakSelf loadMoreData];
                        }];
                    }
                    
                    noticeary=[[NSMutableArray alloc]initWithArray:tempary];
                    [noticetb reloadData];
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
        [noticetb.mj_header endRefreshing];
    }];
}
-(void)loadMoreData
{
    currentPage++;
    [SHNetWork noticeList:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"stralldwlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intCurrentPage:currentPage intPageRows:pageRows completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count<pageRows) {
                    noticetb.mj_footer=nil;
                }
                [noticeary addObjectsFromArray:tempary];
                [noticetb reloadData];
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
        [noticetb.mj_footer endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return noticeary.count;
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
    NSDictionary *dic =[noticeary objectAtIndex:indexPath.row];
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(10,10, kScreenWidth-20, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    //公文字号:
    UIImageView *lgimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    lgimg.contentMode=UIViewContentModeScaleAspectFit;
    [lgimg setImage:PNGIMAGE(@"notice-ico")];
    ViewRadius(lgimg, H(lgimg)/2.0);
    [headerview addSubview:lgimg];
    UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lgimg)+5, lgimg.center.y-10, W(headerview)-(XW(lgimg)+10), 20)];
    gwzhlb.font=Font(14);
    NSMutableString *btstr=[NSMutableString string];
    NSMutableString *bts=[NSMutableString string];
    if ([[dic objectForKey:@"strckbz"] isEqualToString:@"未读"]) {
        UIImageView *newimg=[[UIImageView alloc]initWithFrame:CGRectMake(XW(lgimg), 0, 15, 15)];
        [newimg setImage:PNGIMAGE(@"icon_new")];
        newimg.center=CGPointMake(XW(lgimg), Y(lgimg)+5);
        [headerview addSubview:newimg];
    }
    if (![Tools isBlankString:[dic objectForKey:@"strzd"]]) {
        [bts appendFormat:@"%@",[dic objectForKey:@"strzd"]];
    }
    [btstr appendFormat:@"%@",bts];
    [btstr appendFormat:@"%@",[dic objectForKey:@"strtzbt"]];
    if (![Tools isBlankString:bts]) {
        [gwzhlb setAttributedText:[Tools renderText:btstr targetStr:bts andColor:[UIColor redColor]]];
    }
    else
    {
      gwzhlb.text=btstr;
    }
    gwzhlb.numberOfLines=0;
    gwzhlb.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize gwzhSizeFont =[btstr boundingRectWithSize:CGSizeMake(W(gwzhlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
    gwzhlb.frame=CGRectMake(X(gwzhlb), Y(gwzhlb), W(gwzhlb), gwzhSizeFont.height);
    [headerview addSubview:gwzhlb];
    //发送人
    UILabel *gzrwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(gwzhlb), YH(gwzhlb), W(headerview)/2-5+20, 20)];
    gzrwlb.font=Font(12);
    gzrwlb.adjustsFontSizeToFitWidth=YES;
    
    gzrwlb.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"strqfr"]];
    gzrwlb.textColor=[SingleObj defaultManager].emailColor;
    [headerview addSubview:gzrwlb];
    //发文时间
    UILabel *fwlxlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gzrwlb), Y(gzrwlb), W(headerview)-(XW(gzrwlb)+10), H(gzrwlb))];
    fwlxlb.textAlignment=NSTextAlignmentRight;
    fwlxlb.font=Font(12);
    fwlxlb.textColor=[SingleObj defaultManager].emailColor;
    fwlxlb.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"dtmdjsj"]];
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
    NSDictionary *dic =[noticeary objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"strckbz"] isEqualToString:@"未读"]) {
        isfresh=YES;
        NSMutableDictionary *noticdic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        [noticdic setObject:@"已读" forKey:@"strckbz"];
        [noticeary replaceObjectAtIndex:indexPath.row withObject:noticdic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    LBNoticeDetailViewController *lbnoticedetail=[[LBNoticeDetailViewController alloc]init];
    lbnoticedetail.title=@"通知详情";
    lbnoticedetail.lbNoticDetail=dic;
    [self.navigationController pushViewController:lbnoticedetail animated:YES];
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
