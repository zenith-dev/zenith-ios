//
//  LBCommonVC.m
//  dtgh
//
//  Created by 熊佳佳 on 16/6/12.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBCommonVC.h"
#import "LBCommonTableViewCell.h"
@interface LBCommonVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray *commonAry;//常用数组
@property (nonatomic,assign)NSInteger pagesize;
@property (nonatomic,assign)NSInteger pagenow;
@end
@implementation LBCommonVC
@synthesize commonTb,commonAry,pagesize,pagenow;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"添加" image:nil sel:@selector(addSEL:)];
    pagesize=10;
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    commonTb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [commonTb.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark---------------加载数据-------------
-(void)loadNewData{
    pagenow=1;
    [SHNetWork everydayLanguageApi:@(pagesize) currentPage:@(pagenow )completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                commonAry=[[NSMutableArray alloc]initWithArray:rep[@"data"]];
                if (commonAry.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无数据"];
                }
                else if (commonAry.count<pagesize)
                {
                    [commonTb.mj_footer resetNoMoreData];
                    //commonTb.mj_footer=nil;
                }else if(commonAry.count==pagesize) {
                    __unsafe_unretained __typeof(self) weakSelf = self;
                    commonTb.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [weakSelf loadNewDatamore];
                    }];
                }
                [commonTb reloadData];
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
        [commonTb.mj_header endRefreshing];
    }];
}
-(void)loadNewDatamore{
    pagenow++;
    [SHNetWork everydayLanguageApi:@(pagesize) currentPage:@(pagenow )completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                if ([rep[@"data"] count]<pagesize) {
                     [commonTb.mj_footer resetNoMoreData];
                }
                [commonAry addObjectsFromArray:rep[@"data"]];
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
        [commonTb.mj_footer endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commonAry.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"LBCommonTableViewCell";
    LBCommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LBCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.commonlb.text=commonAry[indexPath.row][@"strps"];
    CGSize cellsize=[commonAry[indexPath.row][@"strps"] boundingRectWithSize:CGSizeMake(cell.commonlb.mj_w, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics  attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
    [cell.commonlb setMj_h:cellsize.height>36?cellsize.height:36];
    cell.editbtn.tag=indexPath.row;
    [cell.editbtn bk_addEventHandler:^(UIButton *sender) {
        NSDictionary *dic=commonAry[sender.tag];
        UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
        textView.text=dic[@"strps"];
        UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"修改常用语" message:nil];
        [alertView bk_addButtonWithTitle:@"确定" handler:^{
            if (![Tools isBlankString:textView.text]) {
                [self updateLanguage:textView.text intpscyylsh:dic[@"intpscyylsh"]];
            }else
            {
                [Tools showMsgBox:@"常用语不能为空"];
            }
        }];
        [alertView bk_addButtonWithTitle:@"取消" handler:^{
            
        }];
        [alertView setValue: textView forKey:@"accessoryView"];
        [alertView show];
    } forControlEvents:UIControlEventTouchUpInside];
    cell.delebtn.tag=indexPath.row;
    [cell.delebtn bk_addEventHandler:^(UIButton *sender) {
        NSDictionary *dic=commonAry[sender.tag];
        [SVProgressHUD showWithStatus:@"删除中..."];
        [SHNetWork deleteLanguage:dic[@"strps"] intpscyylsh:dic[@"intpscyylsh"] completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",rep);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [commonTb.mj_header beginRefreshing];
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
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    [cell setMj_h:(cell.commonlb.mj_h+cell.commonlb.mj_x+4)];
    [cell.editbtn setMj_h:cell.mj_h];
    [cell.delebtn setMj_h:cell.mj_h];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ComMon" object:nil userInfo:commonAry[indexPath.row][@"strps"]];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-----------添加常用语-----------
-(void)addSEL:(UIButton*)sender
{
    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"添加常用语" message:nil];
    [alertView bk_addButtonWithTitle:@"确定" handler:^{
        if (![Tools isBlankString:textView.text]) {
            [self addLanguage:textView.text];
        }
    }];
    [alertView bk_addButtonWithTitle:@"取消" handler:^{
        
    }];
   [alertView setValue: textView forKey:@"accessoryView"];
    [alertView show];
}
-(void)addLanguage :(NSString*)strps
{
    NSLog(@"%@",strps);
    [SVProgressHUD showWithStatus:@"添加中..."];
    [SHNetWork addLanguage:strps completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                 [commonTb.mj_header beginRefreshing];
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
    }];
}
#pragma mark-----------修改常用语----------
-(void)updateLanguage:(NSString*)strps intpscyylsh:(NSString*)intpscyylsh
{
    NSLog(@"%@",strps);
    [SVProgressHUD showWithStatus:@"修改中..."];
    [SHNetWork updateLanguage:strps intpscyylsh:intpscyylsh
              completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [commonTb.mj_header beginRefreshing];
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
