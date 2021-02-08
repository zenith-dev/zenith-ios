//
//  LBAgetntsListViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/12.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgetntsListViewController.h"
#import "LBLoadFileViewController.h"
#import "SHbsTableViewCell.h"
@interface LBAgetntsListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *lbagetstb;
    NSMutableArray *blgcary;
}
@end
@implementation LBAgetntsListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)updata
{
    if (blgcary.count==0) {
         [lbagetstb.mj_header beginRefreshing];
    }
}
-(void)loadNewData
{
    [SHNetWork getHandleProcedure:self.intgwlzlsh completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无办理过程"];
                }
                else
                {
                    blgcary=[[NSMutableArray alloc]initWithArray:tempary];
                    lbagetstb.dataSource=self;
                    lbagetstb.delegate=self;
                    [lbagetstb reloadData];
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
        [lbagetstb.mj_header endRefreshing];
    }];

}
-(void)initview
{
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    lbagetstb=[[UITableView alloc]initWithFrame:CGRectMake(0,10,kScreenWidth, kScreenHeight-64-10)];
    lbagetstb.showsVerticalScrollIndicator=NO;
    
    lbagetstb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbagetstb];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    lbagetstb.mj_header=header;
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return blgcary.count;
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
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary *blbzDic=[blgcary objectAtIndex:indexPath.row];
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 0)];
    [headerview setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:headerview];
    int cellHeight = 0;//用于计算 整个行的高度
    UIFont     *font = [UIFont systemFontOfSize:13];
    UIColor    *color = [UIColor blackColor];
    
    //责任人
    UILabel  *lab_gzrw = [[UILabel alloc]initWithFrame:CGRectMake(5, 3, kScreenWidth/2.0-5, 20)];
    lab_gzrw.text = [NSString stringWithFormat:@"责任人:%@",[blbzDic objectForKey:@"strzrrmc"]];
    lab_gzrw.font = font;
    lab_gzrw.textColor = color;
    UILabel  *lab_bjsj = [[UILabel alloc]initWithFrame:CGRectMake(XW(lab_gzrw), 3, W(lab_gzrw), 20)];
    NSString *dtmbjsj = [blbzDic objectForKey:@"strczrxm"];
    lab_bjsj.text = [NSString stringWithFormat:@"操作人:%@",[Tools isBlankString:dtmbjsj]?@"":dtmbjsj];
    lab_bjsj.font = font;
    lab_bjsj.textColor = color;
    [headerview addSubview:lab_gzrw];
    [headerview addSubview:lab_bjsj];
    //发送时间
    UILabel  *lab_fssj = [[UILabel alloc]initWithFrame:CGRectMake(X(lab_gzrw), YH(lab_gzrw), W(lab_gzrw), H(lab_gzrw))];
    lab_fssj.font = font;
    lab_fssj.textColor = color;
    NSString *dtmkssj = [blbzDic objectForKey:@"dtmfssj"];
    lab_fssj.text = [NSString stringWithFormat:@"发送时间:%@",[Tools isBlankString:dtmkssj]?@"":[Tools dateToStr:[Tools strToDate:dtmkssj andFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] andFormat:@"yyyy-MM-dd HH:mm"]];
    lab_fssj.adjustsFontSizeToFitWidth=YES;

    //接收时间
    UILabel  *lab_jssj = [[UILabel alloc]initWithFrame:CGRectMake(XW(lab_fssj), Y(lab_fssj), W(lab_fssj), H(lab_fssj))];
    NSString *dtmjssj = [blbzDic objectForKey:@"dtmjssj"];
    lab_jssj.text = [NSString stringWithFormat:@"接收时间:%@",[Tools isBlankString:dtmjssj]?@"":[Tools dateToStr:[Tools strToDate:dtmjssj andFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] andFormat:@"yyyy-MM-dd HH:mm"]];
    lab_jssj.font = font;
    lab_jssj.adjustsFontSizeToFitWidth=YES;
    lab_jssj.textColor = color;
    [headerview addSubview:lab_fssj];
    [headerview addSubview:lab_jssj];
    
    //工作任务
    UILabel  *lab_zrr = [[UILabel alloc]initWithFrame:CGRectMake(X(lab_fssj), YH(lab_fssj), W(lab_fssj), H(lab_fssj))];
    lab_zrr.text = [NSString stringWithFormat:@"工作任务:%@",[Tools isBlankString:[blbzDic objectForKey:@"strgzrwmc"]]?@"":[blbzDic objectForKey:@"strgzrwmc"]];
    lab_zrr.font = font;
    lab_zrr.textColor = color;
    //办结时间
    UILabel  *lab_czr = [[UILabel alloc]initWithFrame:CGRectMake(XW(lab_zrr), Y(lab_zrr), W(lab_zrr), H(lab_zrr))];
    lab_czr.text = [NSString stringWithFormat:@"办结时间:%@",[Tools isBlankString:[blbzDic objectForKey:@"dtmbjsj"]]?@"":[blbzDic objectForKey:@"dtmbjsj"]];
    lab_czr.adjustsFontSizeToFitWidth=YES;
    lab_czr.font = font;
    lab_czr.textColor = color;
    [headerview addSubview:lab_zrr];
    [headerview addSubview:lab_czr];
    cellHeight = YH(lab_zrr);
    //横线
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, cellHeight+4, W(headerview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:oneline];
    headerview.frame=CGRectMake(0, 0, kScreenWidth, YH(oneline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
