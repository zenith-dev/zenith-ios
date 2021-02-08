//
//  PlanlistDetailVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "PlanlistDetailVC.h"

@interface PlanlistDetailVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *fsjslb;//时间
@property (nonatomic,strong)UILabel *fbrlb;//人
@property (nonatomic,strong)UILabel *onelb;
@property (nonatomic,strong)NSDictionary *detaildic;
@property (nonatomic,strong)UIWebView *connetWeb;//内容
@property (nonatomic,strong)NSString *noticeContextStr;
@property (nonatomic,strong)UIScrollView *noticeScr;//滑动
@property (nonatomic,strong)NSMutableArray *fjary;//附件列表
@property (nonatomic,strong)UITableView *fjtb;//附件列表
@property (nonatomic,strong)NSString *curFjPath;
@end

@implementation PlanlistDetailVC
@synthesize titlelb,fsjslb,fbrlb,onelb,connetWeb,detaildic,noticeScr,noticeContextStr,fjary,fjtb,planlistdocmodel;
- (void)viewDidLoad {
    [super viewDidLoad];
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(15, 64+10, kScreenWidth-30, 18)];
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.font=BoldFont(16);
    titlelb.numberOfLines=0;
    [self.view addSubview:titlelb];
    fsjslb =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, titlelb.bottom+5, titlelb.width,18)];
    fsjslb.textAlignment=NSTextAlignmentCenter;
    fsjslb.font=Font(14);
    fsjslb.textColor=[UIColor grayColor];
    [self.view addSubview:fsjslb];
    fbrlb =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, fbrlb.bottom+5, titlelb.width, 18)];
    fbrlb.textAlignment=NSTextAlignmentCenter;
    fbrlb.font=Font(14);
    fbrlb.textColor=[UIColor grayColor];
    [self.view addSubview:fbrlb];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, fbrlb.bottom+5, kScreenWidth, 0.5)];
    [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
    [self.view addSubview:onelb];
    [self getNoticeDetailInfo];
    // Do any additional setup after loading the view.
}
#pragma mark--------------获取公告详情-----------
-(void)getNoticeDetailInfo{
    NSDictionary *informDic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",planlistdocmodel.intwdwjlsh,@"intwdwjlsh",nil];
    [self network:@"ggservices" requestMethod:@"getGrwdxx" requestHasParams:@"true" parameter:informDic progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            detaildic =[[NSDictionary alloc]initWithDictionary:rep[@"wdwj"]];
            titlelb.text=detaildic[@"strwdbt"];
            CGSize btsize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
            titlelb.height=btsize.height;
            fsjslb.top=titlelb.bottom+5;
            fsjslb.text=[NSString stringWithFormat:@"%@  %@",detaildic[@"dtmfbrq"],detaildic[@"strmlmc"]];
            onelb.top=fsjslb.bottom+5;
            if ([detaildic[@"strsm"] length]>0) {
                noticeContextStr =[NSString stringWithFormat:@"<html><head><meta name=\"format-detection\" content=\"telephone=no,email=no,date=no,address=no\"></head><body>   %@</body></html>",detaildic[@"strsm"]];
            }
            else
            {
                noticeContextStr=[NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\"></head><body><p style=\"font-size: 1.5em\">空白</p></body></html>"];
            }
            fjary = [[NSMutableArray alloc] init];
            if ([[detaildic objectForKey:@"wdfj"] isKindOfClass:[NSDictionary class]]) {
                [fjary addObject:[detaildic objectForKey:@"wdfj"]];
            }
            else
            {
                fjary = [detaildic objectForKey:@"wdfj"];
            }
            [self getConnet];
        }
    }];
}
-(void)getConnet{
    noticeScr =[[UIScrollView alloc]initWithFrame:CGRectMake(0, onelb.bottom, kScreenWidth, kScreenHeight-onelb.bottom)];
    noticeScr.backgroundColor = [UIColor clearColor];
    noticeScr.directionalLockEnabled = YES;
    noticeScr.showsHorizontalScrollIndicator = NO;
    noticeScr.showsVerticalScrollIndicator = NO;
    [self.view addSubview:noticeScr];
    connetWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, noticeScr.width, noticeScr.height-180)];
    [connetWeb setDelegate:self];
    connetWeb.backgroundColor = [UIColor clearColor];
    //[connetWeb setScalesPageToFit:YES];
    [noticeScr addSubview:connetWeb];
    [connetWeb loadHTMLString:noticeContextStr baseURL:nil];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight=[connetWeb.scrollView contentSize].height;
    connetWeb.height=webViewHeight;
    [noticeScr setContentSize:CGSizeMake(noticeScr.width, connetWeb.bottom)];
    if (fjary.count!=0) {
        DealFjVC *dealfjvc=[[DealFjVC alloc]initWithFrame:CGRectMake(0, connetWeb.bottom, kScreenWidth, 30+fjary.count*44) fjAry:fjary type1:8 controller:self];
        [noticeScr addSubview:dealfjvc];
        [noticeScr setContentSize:CGSizeMake(noticeScr.width, dealfjvc.bottom+10)];
    }
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
