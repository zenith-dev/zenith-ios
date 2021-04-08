//
//  ThePortalDetailVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ThePortalDetailVC.h"

@interface ThePortalDetailVC ()<WKNavigationDelegate>
{
    MBProgressHUD *hud;
}
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *timelb;
@property (nonatomic,strong)WKWebView *connetWeb;//内容
@property (nonatomic,strong)NSString *htmlStr;
@end

@implementation ThePortalDetailVC
@synthesize news_id,titlelb,htmlStr,timelb,connetWeb;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",news_id);
    [self getContent];
    // Do any additional setup after loading the view.
}

#pragma mark-----------------详情--------------------
-(void)getContent{
    [self newworkGetall:[NSString stringWithFormat:@"getIosContent.ashx?id=%@",news_id] parameter:nil progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            //处理获取connet内容
            NSString *connetstr=@"\"content\":\"";
            NSRange range = [rep rangeOfString:connetstr];
            //截取最后一个字符串的位置
            NSString *temp1 = [[rep componentsSeparatedByString:@"\""] lastObject];
            NSRange range1 = [rep rangeOfString:temp1];
            NSString *bstr=[rep substringWithRange:NSMakeRange(range.location+range.length,range1.location-(range.location+range.length+1))];
            htmlStr =bstr;
            NSLog(@"%@",bstr);
            NSString *jsonStr =[rep stringByReplacingOccurrencesOfString:bstr withString:@""];
            NSDictionary *jsondic=[jsonStr mj_JSONObject];
            NSLog(@"%@=====",jsondic);
            [self initview:jsondic];
        }
    }];
}
#pragma mark-------------初始化界面---------------------
-(void)initview:(NSDictionary*)dic{
    titlelb =[[UILabel alloc]initWithFrame:CGRectMake(15, 64+10, kScreenWidth-30, 18)];
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.font=BoldFont(16);
    titlelb.numberOfLines=0;
    titlelb.text=dic[@"data"][0][@"title"];
    [self.view addSubview:titlelb];
    CGSize btsize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=btsize.height;
    timelb =[[UILabel alloc]initWithFrame:CGRectMake(15, titlelb.bottom+5, titlelb.width, 20)];
    timelb.text=dic[@"data"][1][@"date"];
    timelb.font=Font(13);
    timelb.textAlignment=NSTextAlignmentCenter;
    timelb.textColor=[UIColor grayColor];
    [self.view addSubview:timelb];
    
    connetWeb =[[WKWebView alloc]initWithFrame:CGRectMake(5, timelb.bottom+5, kScreenWidth-10, kScreenHeight-timelb.bottom-10)];
    //[connetWeb setDelegate:self];
    [connetWeb setNavigationDelegate:self];
    connetWeb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:connetWeb];
    [connetWeb loadHTMLString:htmlStr baseURL:nil];
}
//-(void)webViewDidStartLoad:(UIWebView *)webView
//{
//   hud=[self progressWaitingWithMessage:@"加载中..."];
//}
//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//     [hud hide:YES];
//}
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    hud=[self progressWaitingWithMessage:@"加载中..."];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [hud hide:YES];
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
