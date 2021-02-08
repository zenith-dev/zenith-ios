//
//  ztOAOpenVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOAOpenVC.h"

@interface ztOAOpenVC ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate>
@property(nonatomic, strong)NSString *URL;
@property(nonatomic,retain)UIDocumentInteractionController *docController;
@property(nonatomic, strong)UIWebView *webview;
@end
@implementation ztOAOpenVC
@synthesize webview;
- (id)initWithURL:(NSString *)aURL andFileName:(NSString *)aFileName;
{
    self = [super init];
    if (self) {
        self.URL = aURL;
        self.title = aFileName;
    }
    return self;
}
- (void)open{
    _docController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.URL]];
    _docController.delegate =self;//设置代理
    CGRect navRect =self.navigationController.navigationBar.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    [_docController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self open];
    webview =[[UIWebView alloc]initWithFrame:self.view.bounds];
    webview.delegate=self;
    webview.scalesPageToFit=YES;
    webview.scrollView.bounces = false;
    [self.view addSubview:webview];
    
    NSURL *url=[NSURL fileURLWithPath:self.URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 服务器的响应对象,服务器接收到请求返回给客户端的
    NSURLResponse *respnose = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respnose error:NULL];
    NSLog(@"%@", respnose.MIMEType);
    NSString *mimeType=respnose.MIMEType;
    [webview loadData:data MIMEType:mimeType textEncodingName:@"UTF8" baseURL:url];
    // Do any additional setup after loading the view.
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此文档格式错误打不开请到电脑端查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return  self.view.frame;
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
