//
//  ztOAMainDocViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAMainDocViewController.h"

@interface ztOAMainDocViewController ()
@property(nonatomic,strong)UIButton *simpleTextbutton;
@property(nonatomic,strong)UIButton *PDFReadbutton;
@end

@implementation ztOAMainDocViewController
@synthesize simpleTextbutton,PDFReadbutton;
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
   // //self.appTitle.text = @"电子签批";
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    
    self.simpleTextbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.simpleTextbutton setBackgroundImage:[UIImage imageNamed:@"docBtn"] forState:UIControlStateNormal];
    self.simpleTextbutton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [self.simpleTextbutton addTarget:self action:@selector(simpleViewShow) forControlEvents:UIControlEventTouchUpInside];
    self.simpleTextbutton.frame = CGRectMake(50, 64+50, self.view.width-100, 40);
    [self.simpleTextbutton setTitle:@"simpleSignView" forState:UIControlStateNormal];
    [self.simpleTextbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:simpleTextbutton];
    
    self.PDFReadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
     self.PDFReadbutton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [self.PDFReadbutton setBackgroundImage:[UIImage imageNamed:@"docBtn"] forState:UIControlStateNormal];
    [self.PDFReadbutton setTitle:@"PDFReadView" forState:UIControlStateNormal];
    [self.PDFReadbutton addTarget:self action:@selector(pdfViewShow) forControlEvents:UIControlEventTouchUpInside];
    self.PDFReadbutton.frame = CGRectMake(50, simpleTextbutton.bottom+50, self.view.width-100, 40);
    [self.PDFReadbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:PDFReadbutton];
}
- (void)simpleViewShow
{
    [self.navigationController pushViewController:[[ztOASimpleDocShowViewController alloc] init] animated:YES];
}

- (void)pdfViewShow
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    //NDA
    NSString *filename = @"/nda.pdf";
    NSString *documentFilePath = [self UrlFromPathOfDocuments:filename];
    NSString *ndaPath = [[NSBundle mainBundle] pathForResource:@"nda" ofType:@"pdf"];
    if( [[NSFileManager defaultManager] fileExistsAtPath:documentFilePath]==NO ) {
        [[NSFileManager defaultManager] copyItemAtPath:ndaPath toPath:documentFilePath error:nil];
    }
    
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
#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [viewController.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
