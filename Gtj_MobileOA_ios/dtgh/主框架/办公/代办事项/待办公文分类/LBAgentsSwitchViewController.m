//
//  LBAgentsSwitchViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/12.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgentsSwitchViewController.h"
#import "SUNSlideSwitchView.h"
#import "LBAgentsDetailViewController.h"
#import "LBAgetntsListViewController.h"
@interface LBAgentsSwitchViewController ()<UIScrollViewDelegate>
{
    SUNSlideSwitchView *slideSwitchView;
    NSDictionary *agetsDetaildic;//公文详情信息
    NSMutableArray *leaveary;
    NSMutableArray *tableList_arr;
    UIScrollView *slideScr;
    UIImageView *onelineview;
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;
    UIView  *tabView;
}
@end
static UIButton *checkBtn;
@implementation LBAgentsSwitchViewController
@synthesize intgwlzlsh;

- (void)viewDidLoad {
    [super viewDidLoad];
    leaveary=[[NSMutableArray alloc]initWithObjects:[self.lstdic objectForKey:@"strgzrwmc"],@"办理过程", nil];
    tableList_arr=[[NSMutableArray alloc]init];
    [self getSwBumphInfo];
    // Do any additional setup after loading the view from its nib.
}
-(void)update
{
    [self getSwBumphInfo];
}
#pragma mark-------------部门详情接口---------------------
-(void)getSwBumphInfo
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork getSwBumphInfo:intgwlzlsh intbzjllsh:self.intbzjllsh completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                agetsDetaildic=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                [self getHandleOpinion];
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
#pragma mark----------------------------处理意见---------------------
-(void)getHandleOpinion
{
    [SHNetWork getHandleOpinion:intgwlzlsh completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                LBAgentsDetailViewController *lbagetsDetail=[[LBAgentsDetailViewController alloc]init];
                lbagetsDetail.detaildic=agetsDetaildic;
                lbagetsDetail.isshow=self.isshow;
                lbagetsDetail.optionary=[rep objectForKey:@"data"];
                lbagetsDetail.lstdic=self.lstdic;
                lbagetsDetail.intbzjllsh=self.intbzjllsh;
                lbagetsDetail.nav=self.navigationController;
                lbagetsDetail.title =[leaveary objectAtIndex:0];
                [tableList_arr addObject:lbagetsDetail];
                
                LBAgetntsListViewController *lbagetslst=[[LBAgetntsListViewController alloc]init];
                lbagetslst.title=[leaveary objectAtIndex:1];
                lbagetslst.intgwlzlsh=intgwlzlsh;
                [tableList_arr addObject:lbagetslst];
                [self initsunslideview];
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
#pragma mark----------------------------启动滑竿----------------------
-(void)initsunslideview
{
    tabView = [[UIView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,41)];
    tabView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabView];
    float xOffset=10;
    onelineview=[[UIImageView alloc]init];
    [onelineview setBackgroundColor:[SingleObj defaultManager].mainColor];
    [tabView addSubview:onelineview];
    UILabel *onelienlb=[[UILabel alloc]initWithFrame:CGRectMake(0, H(tabView)-1, W(tabView), 1)];
    [onelienlb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [tabView addSubview:onelienlb];
    
    for (int i = 0; i < [tableList_arr count]; i++) {
        UIViewController *vc = tableList_arr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize textSize =[vc.title sizeWithAttributes:@{NSFontAttributeName:Font(17)}];
        //设置按钮尺寸
        [button setFrame:CGRectMake(xOffset,0,
                                    textSize.width, 39)];
        //计算下一个tab的x偏移量
        xOffset += textSize.width + 15;
        [button setTag:i+100];
        if (i == 0) {
            button.selected = YES;
            checkBtn=button;
            onelineview.frame = CGRectMake(0, YH(button), textSize.width, 1);
            onelineview.center=CGPointMake(button.center.x,onelineview.center.y);
        }
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = Font(17);
        [button setTitleColor:[Tools colorWithHexString:@"868686"] forState:UIControlStateNormal];
        [button setTitleColor:[SingleObj defaultManager].mainColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabView addSubview:button];
    }
    slideScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, YH(tabView), kScreenWidth, kScreenHeight-(YH(tabView)))];
    slideScr.pagingEnabled = YES;
    slideScr.clipsToBounds = NO;
    slideScr.backgroundColor = [UIColor whiteColor];
    slideScr.contentSize = CGSizeMake(kScreenWidth * 2, slideScr.frame.size.height);
    slideScr.showsHorizontalScrollIndicator = NO;
    slideScr.showsVerticalScrollIndicator = NO;
    slideScr.scrollsToTop = NO;
    slideScr.delegate = self;
    [slideScr setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:slideScr];
    for (int i=0; i<[tableList_arr count]; i++) {
        UIViewController *listVC = [tableList_arr objectAtIndex:i];
        listVC.view.frame = CGRectMake(0+kScreenWidth*i, 0,
                                       kScreenWidth, YH(slideScr));
        [slideScr addSubview:listVC.view];
    }
}
#pragma mark----------------selectNameButton-------
-(void)selectNameButton:(UIButton*)sender
{
    if (sender!=checkBtn) {
        sender.selected=YES;
        checkBtn.selected=NO;
        checkBtn=sender;
        onelineview.frame=CGRectMake(X(onelineview), Y(onelineview), sender.frame.size.width, H(onelineview));
        [UIView animateWithDuration:.25 animations:^{
             onelineview.center=CGPointMake(sender.center.x,onelineview.center.y);
        } completion:^(BOOL finished) {
            [slideScr setContentOffset:CGPointMake((sender.tag - 100)*kScreenWidth, 0) animated:NO];
            if (sender.tag==101) {
                LBAgetntsListViewController*lbagetlsit =(LBAgetntsListViewController*) [tableList_arr objectAtIndex:sender.tag-100];
                [lbagetlsit updata];
            }
        }];
    }
}
#pragma mark 主视图逻辑方法

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == slideScr) {
        _userContentOffsetX = scrollView.contentOffset.x;
    }
}

//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == slideScr) {//主视图滑动
        //判断用户是否左滚动还是右滚动
        if (_userContentOffsetX < scrollView.contentOffset.x) {
            _isLeftScroll = YES;
        }
        else {
            _isLeftScroll = NO;
        }
    }
}

//减速停止了时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == slideScr) {
        //调整顶部滑条按钮状态
        int tag = (int)scrollView.contentOffset.x/kScreenWidth+100;
        UIButton *button = (UIButton *)[tabView viewWithTag:tag];
        [self selectNameButton:button];
    }
}

-(void)backPage
{
     [slideScr setContentOffset:CGPointMake(0, 0) animated:NO];
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
