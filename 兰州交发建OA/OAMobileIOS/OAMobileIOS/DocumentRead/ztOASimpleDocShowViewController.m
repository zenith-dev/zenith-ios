//
//  ztOASimpleDocShowViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASimpleDocShowViewController.h"

@interface ztOASimpleDocShowViewController ()
@property(nonatomic,strong)ztOASImpleView *simpleView;
@end

@implementation ztOASimpleDocShowViewController
@synthesize simpleView;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSString *image1Path = [self UrlFromPathOfDocuments:@"/image/sign1.png"];
    UIImage* oneUIImage = [UIImage imageWithContentsOfFile:image1Path];
    NSString *image2Path = [self UrlFromPathOfDocuments:@"/image/sign2.png"];
    UIImage* twoUIImage = [UIImage imageWithContentsOfFile:image2Path];
    simpleView.signOneImgView.image = nil;
    simpleView.signTwoImgView.image = nil;
    simpleView.signOneImgView.image = oneUIImage;
    simpleView.signTwoImgView.image = twoUIImage;
}
- (void)docDetailView
{
    NSString *filename = @"/nda.pdf";
    NSString *documentFilePath = [self UrlFromPathOfDocuments:filename];
    NSString *ndaPath = [[NSBundle mainBundle] pathForResource:@"nda" ofType:@"pdf"];
    if( [[NSFileManager defaultManager] fileExistsAtPath:documentFilePath]==NO ) {
        [[NSFileManager defaultManager] copyItemAtPath:ndaPath toPath:documentFilePath error:nil];
    }
    
//    [self.navigationController pushViewController:[[ztOAOpenDocumentViewController alloc] initWithType:@"2" withDocUrl:documentFilePath withName:@"nda.pdf"] animated:YES];
    [self.navigationController pushViewController:[[ztOAPDFShowViewController alloc] init] animated:YES];
}
#pragma mark end
- (void)tapGesture:(id)sender
{
    UIButton *view = (UIButton *)sender;
    NSString *image1Path = [self UrlFromPathOfDocuments:@"/image/sign1.png"];
    NSString *image2Path = [self UrlFromPathOfDocuments:@"/image/sign2.png"];
    NSArray *signPicArray = [[NSArray alloc] initWithObjects:image1Path,image2Path, nil];
    if (view.tag == 100) {
        [self.navigationController pushViewController:[[ztOABigImgViewController alloc] initWithTitle:@"大图" selectedIndex:0 pictureArray:signPicArray currentType:2] animated:YES];
    }
    else if (view.tag == 100+1) {
        [self.navigationController pushViewController:[[ztOAHandWritingImageViewController alloc] initWithType:@"1" withOldImg:simpleView.signOneImgView.image] animated:YES];
    }
    else if (view.tag == 200) {
        [self.navigationController pushViewController:[[ztOABigImgViewController alloc] initWithTitle:@"大图" selectedIndex:1 pictureArray:signPicArray currentType:2] animated:YES];
    }
    else if (view.tag == 200+1) {
         [self.navigationController pushViewController:[[ztOAHandWritingImageViewController alloc] initWithType:@"2" withOldImg:simpleView.signTwoImgView.image] animated:YES];
    }
}
- (void)loadViewIn
{
    self.simpleView = [[ztOASImpleView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    simpleView.userInteractionEnabled = YES;
    simpleView.docName.text =@"文档名称: nda.pdf";
    simpleView.writer.text = @"作者: ";
    simpleView.writeTime.text = @"创建时间: ";
    [simpleView.docLink setText:@"nda.pdf"];
    [simpleView.docLink sizeToFit];
    [simpleView.docLink addTarget:self action:@selector(docDetailView)];
    NSString *image1Path = [self UrlFromPathOfDocuments:@"/image/sign1.png"];
    UIImage* oneUIImage = [UIImage imageWithContentsOfFile:image1Path];
    NSString *image2Path = [self UrlFromPathOfDocuments:@"/image/sign2.png"];
    UIImage* twoUIImage = [UIImage imageWithContentsOfFile:image2Path];
    
    simpleView.signOneImgView.image = nil;
    simpleView.signTwoImgView.image = nil;
    simpleView.signOneImgView.image = oneUIImage;
    simpleView.signTwoImgView.image = twoUIImage;
    
    [simpleView.oneBigImgViewBtn addTarget:self action:@selector(tapGesture:) forControlEvents:UIControlEventTouchUpInside];
    [simpleView.oneWriteImgViewBtn addTarget:self action:@selector(tapGesture:) forControlEvents:UIControlEventTouchUpInside];
    [simpleView.twoBigImgViewBtn addTarget:self action:@selector(tapGesture:) forControlEvents:UIControlEventTouchUpInside];
    [simpleView.twoWriteImgViewBtn addTarget:self action:@selector(tapGesture:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:simpleView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	////self.appTitle.text = @"simpleSignView";
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    [self loadViewIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
