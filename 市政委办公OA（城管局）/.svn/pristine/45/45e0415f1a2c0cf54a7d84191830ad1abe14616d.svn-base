//
//  ztOAOpenDocumentViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-8.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAOpenDocumentViewController.h"

@interface ztOAOpenDocumentViewController ()
{
    NSString *I_type;
    NSString *docUrl;
    NSString *docName;
    UIWebView *web_view;
    UIDocumentInteractionController *documentController;
}
@end

@implementation ztOAOpenDocumentViewController

- (id)initWithSource:(NSDictionary *)dataSource
{
    self = [super init];
    if (self) {
        I_type = @"1";
        docUrl = [NSString stringWithFormat:@"%@",[dataSource objectForKey:@"fjPath"]];
        NSLog(@"%@",docUrl);
        docName = [NSString stringWithFormat:@"%@",[dataSource objectForKey:@"strfjmc"]];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        I_type = @"1";
    }
    return self;
}

- (void)previewDocument
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"doc"];
    if (url) {
        // Initialize Document Interaction Controller
        documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        //Configure Document Interaction Controller
        [documentController setDelegate:self];
        
        // Preview DOC
        [documentController presentPreviewAnimated:YES];
    }
}
- (void)openDocument
{
     NSURL *url = [[NSBundle mainBundle] URLForResource:@"example" withExtension:@"doc"];
//    if (docUrl!=nil && ![docUrl isEqualToString:@""]) {
    if (url)
    {
        documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        
        //Configure Document Interaction Controller
        [documentController setDelegate:self];
        
        // Preview DOC
        [documentController presentOpenInMenuFromRect:CGRectMake(0, 64, self.view.width, self.view.height-64) inView:self.view animated:YES];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
   // //self.appTitle.text = @"文档名称";
    if ([I_type isEqualToString:@"1"]) {
        [self openDocument];
    }
   else if([I_type isEqualToString:@"2"]) {
       //webview打开
       web_view = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
       [web_view setDelegate:self];
       [web_view setScalesPageToFit:YES];
       [self.view addSubview:web_view];
      // //self.appTitle.text = docName;
       [self loadDocument:docUrl inView:web_view];
   }
    
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

- (void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
    //NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    //注意这里，是fileURLWithPath,而不是URLWithString,打开本地的用前者，打开网络的用后者
    NSURL *url = [NSURL URLWithString:docUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
