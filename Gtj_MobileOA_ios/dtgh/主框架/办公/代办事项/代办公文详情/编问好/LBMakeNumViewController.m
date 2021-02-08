//
//  LBMakeNumViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBMakeNumViewController.h"
#import "LBrightImageButton.h"
#import "CTextField.h"
#import "LBpopView.h"
@interface LBMakeNumViewController ()<LBpopDelegate>
{
    LBpopView *popView;
    UILabel *dqwhzlb;
    NSArray *gezary;//公文字
    NSInteger gezaryindex;
    NSArray *nhary;//年号
    NSInteger nharyindex;
    NSMutableArray *remainqhlist;//预留期号
    NSInteger ylqhindex;
    LBrightImageButton *gwzgbtn;
    LBrightImageButton *nhbtn;
    UILabel *dqxhlb;
    CTextField *srqhtf;
    NSDictionary *makenumdic;
    LBrightImageButton *ylqhbtn;
}
@end
@implementation LBMakeNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gezaryindex=0;
    nharyindex=0;
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self rightButton:@"确定" image:nil sel:@selector(oksel:)];
    [self initView];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork queryBwhpage:[_savedic objectForKey:@"intbzjllsh"] intgwlsh:[_savedic objectForKey:@"intgwlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] completionBlock:^(id rep, NSString *emsg) {
        NSLog(@"%@",[rep JSONString]);
        makenumdic=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
        if ([[rep objectForKey:@"flag"] intValue]==0) {
             dqwhzlb.text=[[rep objectForKey:@"data"] objectForKey:@"strgwz"];
            [SVProgressHUD dismiss];
            gezary=[[NSArray alloc]initWithArray:[[rep objectForKey:@"data"] objectForKey:@"lstgwz"]];
            nhary=[[NSArray alloc]initWithArray:[[rep objectForKey:@"data"] objectForKey:@"nhlst"]];
            if (gezary.count>0&&nhary.count>0) {
                [gwzgbtn addTarget:self action:@selector(choosegwzSEL:) forControlEvents:UIControlEventTouchUpInside];
              NSString *n = [Tools dateToStr:[NSDate date] andFormat:@"yyyy"];
                [gwzgbtn setTitle:[[gezary objectAtIndex:gezaryindex] objectForKey:@"strgwz"] forState:0];
                
                [nhbtn addTarget:self action:@selector(choosenhSEL:) forControlEvents:UIControlEventTouchUpInside];
                for (int i=0; i<nhary.count; i++) {
                    NSDictionary *nhtz=[nhary objectAtIndex:i];
                    if ([n intValue] ==[[nhtz objectForKey:@"nh"] intValue]) {
                        nharyindex=i;
                        break;
                    }
                }
                [nhbtn setTitle:[[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"] stringValue] forState:0];
                [self queryWh:[[gezary objectAtIndex:gezaryindex] objectForKey:@"intwzbh"] strcurnh:[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)queryWh:(NSString*)strwzbh strcurnh:(NSString*)strcurnh
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork queryWh:strwzbh strcurnh:strcurnh intdwlsh:[_savedic objectForKey:@"intdwlsh"] completionBlock:^(id rep, NSString *emsg) {
        NSLog(@"%@",[rep JSONString]);
        if ([[rep objectForKey:@"flag"] intValue]==0) {
            [SVProgressHUD dismiss];
            dqxhlb.text=[[rep objectForKey:@"data"] objectForKey:@"strcurgwqh"];
            remainqhlist =[[NSMutableArray alloc]initWithObjects:@{@"":@"strgwz",@"":@"intgwqh"}, nil];
            [remainqhlist addObjectsFromArray:[[rep objectForKey:@"data"] objectForKey:@"remainqhlist"]];
            if (remainqhlist.count>0) {
                ylqhbtn.userInteractionEnabled=YES;
                [ylqhbtn setTitle:[[remainqhlist objectAtIndex:ylqhindex] objectForKey:@"intgwqh"] forState:0];
                [ylqhbtn addTarget:self action:@selector(chooseylqhSEL:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                ylqhbtn.userInteractionEnabled=NO;
              [ylqhbtn setTitle:@"当前没有预留期号" forState:UIControlStateNormal];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
        }
    }];
}
#pragma mark-----------------------选择公文字号---------------
-(void)choosegwzSEL:(UIButton*)sender
{
    if (!popView) {
        popView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    popView.popType=@"gwzh";
    popView.selectRowIndex=gezaryindex;
    popView.delegate=self;
    popView.popArray=gezary;
    popView.popTitle=@"请选择公文字号";
    [popView show];

}
#pragma mark------------------选择年号-----------------------
-(void)choosenhSEL:(UIButton*)sender
{
    if (!popView) {
        popView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    popView.popType=@"nh";
    popView.selectRowIndex=nharyindex;
    popView.delegate=self;
    popView.popArray=nhary;
    popView.popTitle=@"请选择年号";
    [popView show];
}
#pragma mark--------------------预留期号--------------------
-(void)chooseylqhSEL:(UIButton*)sender
{
    if (!popView) {
        popView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    popView.popType=@"ylqh";
    popView.selectRowIndex=ylqhindex;
    popView.delegate=self;
    popView.popArray=remainqhlist;
    popView.popTitle=@"请选择预留期号";
    [popView show];
}
#pragma mark------------------popViewdelegate----------------
-(void)getIndexRow:(int)indexrow warranty:(id)warranty
{
    if ([warranty isEqualToString:@"gwzh"]) {
        if (indexrow!=gezaryindex) {
            gezaryindex=indexrow;
            [gwzgbtn setTitle:[[gezary objectAtIndex:gezaryindex] objectForKey:@"strgwz"] forState:0];
            [self queryWh:[[gezary objectAtIndex:gezaryindex] objectForKey:@"intwzbh"] strcurnh:[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"]];
        }
       
    }
    else if ([warranty isEqualToString:@"nh"])
    {
        if (indexrow!=nharyindex) {
            nharyindex=indexrow;
            [nhbtn setTitle:[[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"] stringValue] forState:0];
            [self queryWh:[[gezary objectAtIndex:gezaryindex] objectForKey:@"intwzbh"] strcurnh:[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"]];
        }
        
    }else if ([warranty isEqualToString:@"ylqh"])
    {
        ylqhindex=indexrow;
        [ylqhbtn setTitle:[[remainqhlist objectAtIndex:ylqhindex] objectForKey:@"intgwqh"] forState:0];
    
    }
}
-(void)oksel:(UIButton*)sender
{
   
    if (![Tools isBlankString:srqhtf.text]) {
        if ([srqhtf.text intValue]<[dqxhlb.text intValue]) {
            [Tools showMsgBox:@"输入期号不能小于当前期号"];
            return;
        }
    }
    
    NSLog(@"%@",remainqhlist.count==0?[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"]:[[remainqhlist objectAtIndex:ylqhindex] objectForKey:@"intgwqh"]);
     [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork setBwh:[_savedic objectForKey:@"intgwlsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] strgwz:[[gezary objectAtIndex:gezaryindex] objectForKey:@"strgwz"] intgwnh:[[nhary objectAtIndex:nharyindex] objectForKey:@"nh"] intgwqh:[Tools isBlankString:srqhtf.text]?(ylqhindex==0?dqxhlb.text:[[remainqhlist objectAtIndex:ylqhindex] objectForKey:@"intgwqh"]) :srqhtf.text  strusegwz:[makenumdic objectForKey:@"strusegwz"] intusewzbh:[makenumdic objectForKey:@"intusewzbh"] intusegwnh:[makenumdic objectForKey:@"intusegwnh"] intusegwqh:[makenumdic objectForKey:@"intusegwqh"] completionBlock:^(id rep, NSString *emsg) {
        NSLog(@"%@",[rep JSONString]);
        if ([[rep objectForKey:@"flag"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
        }
    }];
}
-(void)gogo{
    [self.navigationController popViewControllerAnimated:YES];
    [self.detailContorller getSwBumphInfo];
}
#pragma mark-------------初始化界面------------------
-(void)initView
{
    UIScrollView *mainscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:mainscr];
    UIView *msgpromptView=[[UIView alloc]initWithFrame:CGRectMake(5, 20, W(mainscr)-10, 40)];
    [msgpromptView setBackgroundColor:[UIColor whiteColor]];
    [mainscr addSubview:msgpromptView];
    //当前公文号：
    UILabel *msglb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [@"当前公文号:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    msglb.text=@"当前公文号:";
    msglb.font=Font(14);
    msglb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:msglb];
   dqwhzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(msglb)+5, Y(msglb), W(msgpromptView)-(XW(msglb)+10), H(msglb))];
    dqwhzlb.font=BoldFont(14);
    [msgpromptView addSubview:dqwhzlb];
    //line
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(msglb), W(msgpromptView), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:oneline];
    //公文字
    UILabel *gwzlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(oneline),   [@"公文文字:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    gwzlb.text=@"公 文 字:";
    gwzlb.font=Font(14);
    gwzlb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:gwzlb];
    gwzgbtn=[[LBrightImageButton alloc]initWithFrame:CGRectMake(XW(gwzlb)+5, Y(gwzlb)+5, W(dqwhzlb), H(gwzlb)-10)];
    ViewBorderRadius(gwzgbtn, 2, 1, [SingleObj defaultManager].lineColor);
    [gwzgbtn setImage:PNGIMAGE(@"turnopen") forState:0];
    [gwzgbtn setTitleColor:[UIColor blackColor] forState:0];
    gwzgbtn.titleLabel.font=Font(14);
    [gwzgbtn setTitle:@"XX" forState:UIControlStateNormal];
    [msgpromptView addSubview:gwzgbtn];
    //line
    UILabel *twoline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(gwzlb), W(msgpromptView), 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:twoline];
    //年号
    UILabel *nhlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(twoline),   [@"年号:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    nhlb.text=@"年号:";
    nhlb.font=Font(14);
    nhlb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:nhlb];
    nhbtn=[[LBrightImageButton alloc]initWithFrame:CGRectMake(X(gwzgbtn), Y(nhlb)+5, W(dqwhzlb), H(gwzgbtn))];
     ViewBorderRadius(nhbtn, 2, 1, [SingleObj defaultManager].lineColor);
    [nhbtn setImage:PNGIMAGE(@"turnopen") forState:0];
    nhbtn.titleLabel.font=Font(14);
    [nhbtn setTitleColor:[UIColor blackColor] forState:0];
    [nhbtn setTitle:@"XX" forState:UIControlStateNormal];
    [msgpromptView addSubview:nhbtn];
    //line
    UILabel *nhline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(nhlb), W(msgpromptView), 1)];
    [nhline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:nhline];
    
    //当前期号
    UILabel *dqqhlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(nhline),   [@"当前期号:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    dqqhlb.text=@"当前期号:";
    dqqhlb.font=Font(14);
    dqqhlb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:dqqhlb];
    dqxhlb=[[UILabel alloc]initWithFrame:CGRectMake(X(gwzgbtn)+10, Y(dqqhlb)+5, W(nhbtn), H(nhbtn))];
    dqxhlb.textColor=[UIColor blackColor];
    dqxhlb.font=Font(14);

    [msgpromptView addSubview:dqxhlb];
    //line
    UILabel *dqqhline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(dqqhlb), W(msgpromptView), 1)];
    [dqqhline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:dqqhline];
    
    //预留期号
    UILabel *ylqhlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(dqqhline),   [@"预留期号:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    ylqhlb.text=@"预留期号:";
    ylqhlb.font=Font(14);
    ylqhlb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:ylqhlb];
    ylqhbtn=[[LBrightImageButton alloc]initWithFrame:CGRectMake(X(gwzgbtn), Y(ylqhlb)+5, W(nhbtn), H(nhbtn))];
    ylqhbtn.titleLabel.font=Font(14);
     ViewBorderRadius(ylqhbtn, 2, 1, [SingleObj defaultManager].lineColor);
    [ylqhbtn setTitleColor:[UIColor blackColor] forState:0];
   
    [ylqhbtn setImage:PNGIMAGE(@"turnopen") forState:0];
    [msgpromptView addSubview:ylqhbtn];
    //line
    UILabel *ylqhline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(ylqhlb), W(msgpromptView), 1)];
    [ylqhline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:ylqhline];
    
    //输入期号
    UILabel *srqhlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(ylqhline),   [@"输入期号:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    srqhlb.text=@"输入期号:";
    srqhlb.font=Font(14);
    srqhlb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:srqhlb];
    srqhtf=[[CTextField alloc]initWithFrame:CGRectMake(X(gwzgbtn), Y(srqhlb)+5, W(ylqhbtn), H(nhbtn))];
    srqhtf.font=Font(14);
    srqhtf.keyboardType=UIKeyboardTypeNumberPad;
    srqhtf.placeholder=@"请输入期号";
    ViewBorderRadius(srqhtf, 2, 1, [SingleObj defaultManager].lineColor);
    [msgpromptView addSubview:srqhtf];
    //line
    UILabel *srqhline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(srqhlb), W(msgpromptView), 1)];
    [srqhline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:srqhline];
    
    msgpromptView.frame=CGRectMake(X(msgpromptView), Y(msgpromptView), W(msgpromptView), YH(srqhline)+5);
    [mainscr setContentSize:CGSizeMake(W(mainscr), YH(msgpromptView))];
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
