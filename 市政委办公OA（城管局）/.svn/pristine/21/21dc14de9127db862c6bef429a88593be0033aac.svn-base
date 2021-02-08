//
//  ztOADownloadViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-1-9.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADownloadViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFDownloadRequestOperation.h"

#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]
#define MUSICFile [DocumentsDirectory stringByAppendingPathComponent:@"MUSIC0812081644047585.mp3"]
@interface ztOADownloadViewController ()

@end

@implementation ztOADownloadViewController

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
    
   // //self.appTitle.text = @"下载";
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
}

- (void)downloadRequest
{
    NSString *urlStr = @"http://rm.sina.com.cn/wm/VZ200812081642529246VK/music/MUSIC0812081644047585.mp3";
    //http://wenku.baidu.com/view/026e3ed649649b6648d747f7.html
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:MUSICFile shouldResume:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Successfully downloaded file to %@", MUSICFile);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        
        //self.progressView.progress = percentDone;
        //self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",percentDone*100];
        
        //self.currentSizeLabel.text = [NSString stringWithFormat:@"CUR : %lli M",totalBytesReadForFile/1024/1024];
        //self.totalSizeLabel.text = [NSString stringWithFormat:@"TOTAL : %lli M",totalBytesExpectedToReadForFile/1024/1024];
        
        NSLog(@"------%f",percentDone);
        NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
        NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
        NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
        NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
        NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
    }];
    [operation start];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
