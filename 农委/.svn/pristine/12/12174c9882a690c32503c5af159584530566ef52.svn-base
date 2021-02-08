//
//  LBLoadFileViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/16.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBLoadFileViewController.h"
#import <QuickLook/QuickLook.h>
@interface LBLoadFileViewController ()<UIWebViewDelegate,UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>
{
    UIWebView *showUrlClicked;
    
}
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@end

@implementation LBLoadFileViewController
@synthesize shopurl;
- (void)viewDidLoad {
    [super viewDidLoad];
    showUrlClicked=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [showUrlClicked setBackgroundColor:[UIColor whiteColor]];
    [showUrlClicked.scrollView setBackgroundColor:[UIColor whiteColor]];

    NSRange range = [self.title rangeOfString:@"."options:NSBackwardsSearch];
    NSString *suffix=[self.title substringFromIndex:range.length+range.location];
    NSLog(@"%@",suffix);
    NSURL *url = [[NSURL alloc]initWithString:shopurl];
    showUrlClicked.scalesPageToFit=YES;
    showUrlClicked.opaque = NO;
    [self.view addSubview:showUrlClicked];
    showUrlClicked.delegate=self;
    if ([suffix isEqualToString:@"docx"]||[suffix isEqualToString:@"doc"]) {
        //NSData *data = [NSData dataWithContentsOfURL:url];
       // [showUrlClicked loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.wordprocessingml.document" textEncodingName:@"UTF-8" baseURL:url];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [showUrlClicked loadRequest:request];
    }
    else if ([suffix isEqualToString:@"pptx"]||[suffix isEqualToString:@"ppt"])
    {
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        [showUrlClicked loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.presentationml.presentation" textEncodingName:@"UTF-8" baseURL:url];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [showUrlClicked loadRequest:request];
    }
    else if ([suffix isEqualToString:@"xlsx"]||[suffix isEqualToString:@"xls"])
    {
        //NSData *data = [NSData dataWithContentsOfURL:url];
       // [showUrlClicked loadData:data MIMEType:@"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" textEncodingName:@"UTF-8" baseURL:url];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [showUrlClicked loadRequest:request];
    }
    else if([suffix isEqualToString:@"cebx"]||[suffix isEqualToString:@"ceb"]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSString *fjmc=self.title;
        NSRange range = [self.title rangeOfString:@"."options:NSBackwardsSearch];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:shopurl]];
        [data writeToFile:filePath atomically:YES];
        NSURL *url = [NSURL fileURLWithPath:filePath];
       if([fileManage fileExistsAtPath:filePath]){
        _documentController = [UIDocumentInteractionController
                                          interactionControllerWithURL:url];
        [_documentController setDelegate:self];
        [_documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
       }
    }
    else
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSString *fjmc=self.title;
        NSRange range = [self.title rangeOfString:@"."options:NSBackwardsSearch];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        NSData *data = [NSData dataWithContentsOfURL:[[NSURL alloc]initWithString:shopurl]];
        [data writeToFile:filePath atomically:YES];
        if([fileManage fileExistsAtPath:filePath]){
            NSURL *url = [NSURL fileURLWithPath:filePath];
            self.documentController = [UIDocumentInteractionController  interactionControllerWithURL:url];
            self.documentController.delegate = self;
            [self.documentController presentPreviewAnimated:YES];
        }
    }
    // Do any additional setup after loading the view.
}
#pragma mark QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:shopurl];
}
#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller

{
    return self;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller

{
    return self.view.bounds;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    [SVProgressHUD showWithStatus:@"加载中..."];
    showUrlClicked.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight+44);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad");
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    showUrlClicked.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [Tools showMsgBox:[error localizedDescription]];
    [SVProgressHUD dismiss];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSString *curUrl= [url absoluteString];
        if ([curUrl rangeOfString:@"http://"].location!=NSNotFound) {
            LBLoadFileViewController *showUrlClickedone=[[LBLoadFileViewController alloc]init];
            showUrlClickedone.shopurl=curUrl;
            [self.navigationController pushViewController:showUrlClickedone animated:YES];
        }
        if ([curUrl rangeOfString:@"tel:"].location!=NSNotFound) {
            curUrl=[curUrl stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
            NSString *number = [NSString stringWithFormat:@"telprompt://%@",curUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }
        return NO;
    }
    return  YES;
}


-(void)backPage
{
    [SVProgressHUD dismiss];
    
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
