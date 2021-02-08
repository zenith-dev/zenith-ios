//
//  ztOAPreviewViewController.m
//  OAMobileIOS
//
//  Created by ran chen on 14-6-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPreviewViewController.h"

@interface ztOAPreviewViewController ()
@property(nonatomic, strong)QLPreviewController *previewer;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *URL;
@end

@implementation ztOAPreviewViewController
@synthesize URL, title, previewer;

- (id)initWithURL:(NSString *)aURL andFileName:(NSString *)aFileName;
{
    self = [super init];
    if (self) {
        self.URL = aURL;
        self.title = aFileName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.appTitle.font = [UIFont systemFontOfSize:15];
   // //self.appTitle.text = self.title;
    [self.leftBtn setHidden:NO];
    
    //将QLPreviewControler的view加载到本VC的subview上。避免IOS7部分特性
    self.previewer = [[QLPreviewController alloc] init];
    [previewer setDataSource:self];
    [previewer setDelegate:self];
    [previewer setCurrentPreviewItemIndex:0];
    [previewer.view setFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    [self.view addSubview:previewer.view];
}

#pragma mark QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.URL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
