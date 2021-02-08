//
//  ztOAPDFShowViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAPDFShowViewController.h"
@interface ztOAPDFShowViewController ()
{
    NSString *i_type;//文档类型
    NSArray *nameArray;
}
@property (nonatomic,strong) NDHTMLtoPDF    *PDFCreator;
@property (nonatomic,strong) UIWebView      *myWebView;
@property (nonatomic,strong) UIButton       *convertBtn;

@end

@implementation ztOAPDFShowViewController
@synthesize PDFCreator;
@synthesize myWebView;
@synthesize convertBtn;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.appTitle.text = @"PDFReadView";
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    nameArray = [[NSArray alloc] initWithObjects:@"doc",@"ppt",@"html",@"pdf", nil];
    
    for (int i = 0; i<nameArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"docBtn"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn addTarget:self action:@selector(buttonSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(20+i*60, 64+10, 40, 30);
        [btn setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [self.view addSubview:btn];
        if (btn.tag == 100) {
            [btn setSelected:YES];
        }
    }
    
    self.convertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.convertBtn setBackgroundImage:[UIImage imageNamed:@"docBtn"] forState:UIControlStateNormal];
    [convertBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    self.convertBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.convertBtn addTarget:self action:@selector(generatePDFUsingBlocks:) forControlEvents:UIControlEventTouchUpInside];
    self.convertBtn.frame = CGRectMake(20, 64+60, 120, 30);
    [self.convertBtn setTitle:@"pdf格式打开" forState:UIControlStateNormal];
    [self.convertBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:convertBtn];
    
    i_type = [nameArray objectAtIndex:0];
//    NSString *filename = [NSString stringWithFormat:@"/%@.%@",i_type,i_type];
//    NSString *documentFilePath = [self UrlFromPathOfDocuments:filename];
    NSString *ndaPath = [[NSBundle mainBundle] pathForResource:i_type ofType:i_type];
//    if( [[NSFileManager defaultManager] fileExistsAtPath:documentFilePath]==NO ) {
//        [[NSFileManager defaultManager] copyItemAtPath:ndaPath toPath:documentFilePath error:nil];
//    }
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, convertBtn.bottom+20, self.view.width, self.view.height-convertBtn.bottom-20)];
    [myWebView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [myWebView.layer setBorderWidth:1];
    self.myWebView.delegate = self;
    [myWebView setScalesPageToFit:YES];
    [self.view addSubview:myWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ndaPath]];
    [myWebView loadRequest:request];
}
- (IBAction)buttonSelect:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    for (int i = 0; i<nameArray.count; i++) {
        if (i!=(btn.tag-100)) {
            UIButton *otherBtn = (UIButton *)[self.view viewWithTag:100+i];
            [otherBtn setSelected:NO];
        }
    }
    i_type = [nameArray objectAtIndex:(btn.tag-100)];
//    NSString *filename = [NSString stringWithFormat:@"/%@.%@",type,type];
//    NSString *documentFilePath = [self UrlFromPathOfDocuments:filename];
    NSString *ndaPath = [[NSBundle mainBundle] pathForResource:i_type ofType:i_type];
//    if( [[NSFileManager defaultManager] fileExistsAtPath:documentFilePath]==NO ) {
//        [[NSFileManager defaultManager] copyItemAtPath:ndaPath toPath:documentFilePath error:nil];
//    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ndaPath]];
    [myWebView loadRequest:request];
}

- (IBAction)generatePDFUsingBlocks:(id)sender
{
    
    if ([i_type isEqualToString:@"pdf"]) {
        
        //pdf文件
        NSString *filename = [NSString stringWithFormat:@"/%@.%@",i_type,i_type];
        NSString *documentFilePath = [self UrlFromPathOfDocuments:filename];
        NSString *ndaPath = [[NSBundle mainBundle] pathForResource:i_type ofType:i_type];
        if( [[NSFileManager defaultManager] fileExistsAtPath:documentFilePath]==NO ) {
            [[NSFileManager defaultManager] copyItemAtPath:ndaPath toPath:documentFilePath error:nil];
        }
        
        NSString *phrase = nil;
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:documentFilePath password:phrase];
        if (document != nil) // Must have a valid ReaderDocument object in order to proceed
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            [self.navigationController pushViewController:readerViewController animated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        [self showWaitViewWithTitle:@"loading..."];
        //非pdf文件，先转换
        self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:myWebView.request.URL pathForPDF:[@"~/Documents/blocksDemo.pdf" stringByExpandingTildeInPath] pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF)
        {
            NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
            NSLog(@"%@",result);
            [self closeWaitView];
            
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"转换成功！"];
            [alert addButtonWithTitle:@"打开" handler:^{
                 NSString *phrase = nil;
                ReaderDocument *document = [ReaderDocument withDocumentFilePath:[@"~/Documents/blocksDemo.pdf" stringByExpandingTildeInPath] password:phrase];
                if (document != nil) // Must have a valid ReaderDocument object in order to proceed
                {
                    ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
                    
                    readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                    
                    [self.navigationController pushViewController:readerViewController animated:YES];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }

            }];
            [alert addButtonWithTitle:@"取消" handler:^{}];
            [alert show];
            
        } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
            NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
            NSLog(@"%@",result);
            [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"转换失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}
#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [viewController.navigationController popViewControllerAnimated:YES];
}
//- (IBAction)generatePDFUsingDelegate:(id)sender
//{
//    [self showWaitViewWithTitle:@"loading..."];
//
//    self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:[NSURL URLWithString:@"http://edition.cnn.com/2012/11/12/business/china-consumer-economy/index.html?hpt=hp_c1"]
//                                         pathForPDF:[@"~/Documents/delegateDemo.pdf" stringByExpandingTildeInPath]
//                                           delegate:self
//                                           pageSize:kPaperSizeA4
//                                            margins:UIEdgeInsetsMake(10, 5, 10, 5)];
//}

//#pragma mark NDHTMLtoPDFDelegate
//
//- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
//{
//    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
//    NSLog(@"%@",result);
//    NSURL *pptURL = [NSURL fileURLWithPath:htmlToPDF.PDFpath];
//    
//    //now merge whole pages to one PDF
//    [self MergeToOnePagePDF:pptURL];
//    [self closeWaitView];
//}
//
//- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
//{
//    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
//    NSLog(@"%@",result);
//    [self closeWaitView];
//}
//-(void)MergeToOnePagePDF:(NSURL *)pdfURL
//{
//    //单页
//    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
//    
//    int pageCount = CGPDFDocumentGetNumberOfPages(pdf);
//    CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdf, 1);
//    CGRect pageRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
//    float pageHeight = pageRect.size.height;
//    pageRect.size.height = pageRect.size.height * pageCount;
//    
//    NSMutableData* pdfData = [[NSMutableData alloc] init];
//    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfData);
//    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &pageRect, NULL);
//    
//    CGPDFContextBeginPage(pdfContext, NULL);
//    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
//    for (int i = 1; i <= pageCount; i++)
//    {
//        pageRef = CGPDFDocumentGetPage(pdf, i);
//        CGContextTranslateCTM(pdfContext, 0, -pageHeight);
//        CGContextDrawPDFPage(pdfContext, pageRef);
//    }
//    CGPDFContextEndPage(pdfContext);
//    CGPDFContextClose(pdfContext);
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *pdfFile = [documentsDirectory stringByAppendingPathComponent:@"destination.pdf"];
//    
//    [pdfData writeToFile: pdfFile atomically: NO];
//}


@end
