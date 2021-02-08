//
//  LinkURLVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "LinkURLVC.h"

@interface LinkURLVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webview;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation LinkURLVC
@synthesize urlstr,webview,hud;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *urlRequest;
    if(urlstr){//显示前一个页面传递的url地址
        NSString *pathStr= [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    }
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    webview.delegate=self;
    webview.scalesPageToFit=YES;
    [webview loadRequest:urlRequest];
    [self.view addSubview:webview];
    
    // Do any additional setup after loading the view.
}
#pragma mark uiwebdelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
     hud=[self progressWaitingWithMessage:@"加载中...."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //NSLog(@"加载结束");
    [hud hide:YES];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hud hide:YES];
    [self showMessage:@"加载出错:请检查服务端是否正常!"];
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
