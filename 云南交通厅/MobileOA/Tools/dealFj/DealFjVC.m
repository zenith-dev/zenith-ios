//
//  DealFjVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "DealFjVC.h"
#import "FjCell.h"
#import "GTMBase64.h"
#import <QuickLook/QuickLook.h>
#import "AFAppDotNetAPIClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFAppDotNetAPIClient.h"
#import "NSDictionary+util.h"
#import "NSArray+util.h"
#import "LinkURLVC.h"
#define  LOGINPATH @"ZTMobileGateway/oaAjaxServlet"
@interface DealFjVC ()<UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString *curFjPath;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic,strong)NSString *fjlshstr;
@end

@implementation DealFjVC
@synthesize fjary,fjtb,type,fjlshstr;
- (id)initWithFrame:(CGRect)frame fjAry:(NSMutableArray*)ary type1:(int)type1 controller:(UIViewController*)contro{
    self=[super initWithFrame:frame];//(CGRect) frame = (origin = (x = 0, y = 194.5), size = (width = 414, height = 74))
    if (self) {
       
        fjary =[[NSMutableArray alloc]init];
        NSMutableArray *zszwgary=[[NSMutableArray alloc]init];
        NSMutableArray *fjgary=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in ary) {
            if ([dic[@"fjlx"] isEqualToString:@"正式正文稿"] ||[dic[@"fjlx"] isEqualToString:@"正文稿"]) {
                [zszwgary addObject:dic];
            }else
            {
                [fjgary addObject:dic];
            }
        }
        [fjary addObject:zszwgary];
        [fjary addObject:fjgary];
        type=type1;
        self.controller=contro;
        long tableHeight = zszwgary.count*44+(fjgary.count>0?(30+fjgary.count*66):fjgary.count*66);
        fjtb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tableHeight) style:UITableViewStyleGrouped];
        [fjtb setScrollEnabled:NO];
        fjtb.separatorStyle=UITableViewCellSeparatorStyleNone;
        fjtb.delegate=self;
        fjtb.dataSource=self;
        [self addSubview:fjtb];
        self.height=fjtb.bottom;
        [fjtb reloadData];
    }
    return self;
    // Do any additional setup after loading the view.
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return fjary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1&&[fjary[section] count]>0) {
        return 30;
    }else
    {
       return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1&&[fjary[section] count]>0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width-20, 30)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = type==8?@"文件列表：":@"附件：";
        if(type==666){
            label.text = @"反馈报告";
        }else if(type==888){
            label.text = @"答复附件";
        }
        [headView addSubview:label];
        return headView;
    }
    else
    {
        UIView *views=[[UIView alloc]init];
        return views;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *ary=fjary[section];
    return [ary count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SearchList";
    FjCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[FjCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.ctrone=self.ctrone;
    if (indexPath.section==0) {
        cell.zwgDic=fjary[indexPath.section][indexPath.row];
        [cell.gglb bk_addEventHandler:^(id sender) {
            NSDictionary *tzDic1=fjary[indexPath.section][indexPath.row];
            [self gotoGaiGao:tzDic1];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        cell.tzDic=fjary[indexPath.section][indexPath.row];
        [cell.gglb bk_addEventHandler:^(id sender) {
             NSDictionary *tzDic1=fjary[indexPath.section][indexPath.row];
            [self gotoGaiGao:tzDic1];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tzDic1=fjary[indexPath.section][indexPath.row];
    NSString *fjmc1=tzDic1[@"strfjmc"];
    NSRange range1 = [fjmc1 rangeOfString:@"."];
    NSString *extfilename1=[fjmc1 substringFromIndex:range1.location];//得到文件扩展名
    //判断是否书生文件
    NSLog(@"后缀名%@",extfilename1);
    if ([extfilename1 isEqualToString:@".sep"]||[extfilename1 isEqualToString:@".gd"]) {
        NSDictionary *pardic;
        if (self.type==2) {
            pardic =@{@"inttzfjlsh":tzDic1[@"inttzfjlsh"],@"docname":fjmc1,@"gdfrom":@"0"};
        }else if (self.type==3)
        {
             pardic =@{@"intfjlsh":tzDic1[@"intfjlsh"],@"docname":fjmc1,@"gdfrom":@"0"};
        }
        else if (self.type==4)
        {
            pardic =@{@"intfjlsh":tzDic1[@"intfjlsh"],@"docname":fjmc1,@"gdfrom":@"1"};
        }else if (self.type==8)
        {
            pardic =@{@"intfjlsh":tzDic1[@"intwdfjlsh"],@"docname":fjmc1,@"gdfrom":@"2"};
        }
        [self networkall:@"SsGdServices" requestMethod:@"uploadFile" requestHasParams:@"yes" parameter:pardic progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([rep[@"root"][@"result"] intValue]==1) {
                    NSDictionary *urdic=rep[@"root"];
                    LinkURLVC *linkUrl=[[LinkURLVC alloc]initWithTitle:fjmc1];
                    linkUrl.urlstr=[NSString stringWithFormat:@"%@/Sep4DisplayFun?docId=%@&docName=%@",urdic[@"docurl"],urdic[@"docId"],fjmc1];
                    [self.controller.navigationController pushViewController:linkUrl animated:YES];
                }
            }
        }];
        return;
    }
    if (self.type==1) {//公告
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSDictionary *tzDic=fjary[indexPath.section][indexPath.row];
        NSString *fjmc=tzDic[@"strfjmc"];
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        [self networkall:@"ggServices" requestMethod:@"getGgfj" requestHasParams:@"yes" parameter:@{@"strfjlsh":tzDic[@"intggfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
                if ([extfilename isEqualToString:@".txt"]) {
                    NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                    NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                    NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                    NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                    [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
                } else{
                    [filecontent writeToFile:filePath atomically:YES];
                }
                if ([fileManage fileExistsAtPath:filePath]) {
                    [self filePath:filePath pageX:@"0" pageY:@"64"];
                }
            }
        }];
    }
    else if (self.type==2) {//通知附件
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSDictionary *tzDic=fjary[indexPath.section][indexPath.row];
        NSString *fjmc=tzDic[@"strfjmc"];
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        [self networkall:@"tzServices" requestMethod:@"getTzfj" requestHasParams:@"yes" parameter:@{@"inttzfjlsh":tzDic[@"inttzfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
                if ([extfilename isEqualToString:@".txt"]) {
                    NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                    NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                    NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                    NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                    [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
                } else{
                    [filecontent writeToFile:filePath atomically:YES];
                }
                if ([fileManage fileExistsAtPath:filePath]) {
                    [self filePath:filePath pageX:@"0" pageY:@"64"];
                }
            }
        }];
    }
    else if (self.type==3)//公文附件
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSDictionary *tzDic=fjary[indexPath.section][indexPath.row];
        NSString *fjmc=tzDic[@"strfjmc"];
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        [self networkall:@"document" requestMethod:@"getGwfj" requestHasParams:@"yes" parameter:@{@"intfjlsh":tzDic[@"intfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
                if ([extfilename isEqualToString:@".txt"]) {
                    NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                    NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                    NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                    NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                    [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
                } else{
                    [filecontent writeToFile:filePath atomically:YES];
                }
                if ([fileManage fileExistsAtPath:filePath]) {
                    
//                    if (indexPath.section==0&&![tzDic1[@"fjlx"] isEqualToString:@"正式正文稿"]) {
//                        self.fjlshstr=[NSString stringWithFormat:@"%@",tzDic[@"intfjlsh"]];
//                        [[NSNotificationCenter defaultCenter]postNotificationName:@"WPSDocumentNotification" object:filePath userInfo:@{@"fileName":fjmc}];
//                    }
//                    else
//                    {
//                        [self filePath:filePath pageX:@"0" pageY:@"64"];
//                    }
                     [self filePath:filePath pageX:@"0" pageY:@"64"];
                }
            }
        }];
    }else if(type==4)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSDictionary *tzDic=fjary[indexPath.section][indexPath.row];
        NSString *fjmc=tzDic[@"strfjmc"];
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        [self networkall:@"document" requestMethod:@"getLsGwfj" requestHasParams:@"yes" parameter:@{@"intfjlsh":tzDic[@"intfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
                if ([extfilename isEqualToString:@".txt"]) {
                    NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                    NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                    NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                    NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                    [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
                } else{
                    [filecontent writeToFile:filePath atomically:YES];
                }
                if ([fileManage fileExistsAtPath:filePath]) {
                    [self filePath:filePath pageX:@"0" pageY:@"64"];
                }
            }
        }];
    }
    else if(self.type==8){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSDictionary *tzDic=fjary[indexPath.section][indexPath.row];
        NSString *fjmc=tzDic[@"strfjmc"];
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        [self networkall:@"ggservices" requestMethod:@"getGrwdfj" requestHasParams:@"yes" parameter:@{@"intwdfjlsh":tzDic[@"intwdfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
                if ([extfilename isEqualToString:@".txt"]) {
                    NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                    NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                    NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                    NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                    [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
                } else{
                    [filecontent writeToFile:filePath atomically:YES];
                }
                if ([fileManage fileExistsAtPath:filePath]) {
                    [self filePath:filePath pageX:@"0" pageY:@"64"];
                }
            }
        }];
    }
}
#pragma mark--------------进入改稿---------
-(void)gotoGaiGao:(NSDictionary*)tzDic
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *fjmc=tzDic[@"strfjmc"];
    NSRange range = [fjmc rangeOfString:@"."];
    NSString *tempFjmc = [fjmc substringToIndex:range.location];
    NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
    //保存在本地的文件命名格式为：文件名_流水号.后缀
    fjmc = [NSString stringWithFormat:@"%@%@", tempFjmc, extfilename];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
    self.curFjPath = filePath;
    [self networkall:@"document" requestMethod:@"getGwfj" requestHasParams:@"yes" parameter:@{@"intfjlsh":tzDic[@"intfjlsh"]} progresHudText:@"下载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSString *content = [[[rep objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
            NSData *filecontent = [GTMBase64 decodeString:content];
            //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
            if ([extfilename isEqualToString:@".txt"]) {
                NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                [dataStr writeToFile:filePath atomically:YES encoding:finalEncoding error:nil];
            } else{
                [filecontent writeToFile:filePath atomically:YES];
            }
            if ([fileManage fileExistsAtPath:filePath]) {
                fjlshstr=[NSString stringWithFormat:@"%@",tzDic[@"intfjlsh"]];
                [[NSUserDefaults standardUserDefaults]setObject:fjlshstr forKey:@"fjlshstr"];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"WPSDocumentNotification" object:filePath userInfo:@{@"fileName":fjmc}];
            }
        }
    }];
}
- (void) filePath:(NSString*)filePath pageX:(NSString*)pageX pageY:(NSString*)pageY{
    NSString *moviePath = filePath;
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    self.documentController = [UIDocumentInteractionController  interactionControllerWithURL:url];
    CGRect navRect = self.controller.view.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    navRect.origin = CGPointMake([pageX floatValue],[pageY floatValue]);
    self.documentController.delegate =self;
    //[self.documentController presentOptionsMenuFromRect:navRect inView:self.controller.view animated:YES];
    [self.documentController presentPreviewAnimated:YES];
}
#pragma mark QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.curFjPath];
}

#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller

{
    return self.controller;
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    
    return self.controller.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller

{
    return self.controller.view.frame;
}
// 点击预览窗口的“Done”(完成)按钮时调用
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
{
    //对于错误信息
    NSError *error;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //删除下载的临时文件
    if (![fileMgr removeItemAtPath:self.curFjPath error:&error]){
        NSLog(@"删除文件时错误: %@", [error localizedDescription]);
    }
}

//关闭应用选择窗口时调用方法 （用户没用选择第三方程序打开附件）
- (void) documentInteractionControllerDidDismissOpenInMenu: (UIDocumentInteractionController *) controller{
    //对于错误信息
    NSError *error;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //删除下载的临时文件
    if (![fileMgr removeItemAtPath:self.curFjPath error:&error]){
        NSLog(@"删除文件时错误: %@", [error localizedDescription]);
    }
}

//使用第三方软件打开文件之后
- (void) documentInteractionController: (UIDocumentInteractionController *) controller didEndSendingToApplication: (NSString *) application{
    //对于错误信息
    NSError *error;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //删除下载的临时文件
    if (![fileMgr removeItemAtPath:self.curFjPath error:&error]){
        NSLog(@"删除文件时错误: %@", [error localizedDescription]);
    }
}
-(MBProgressHUD*)progressWaitingWithMessage:(NSString*)message{
    if (!message) {
        return nil;
    }
    UIView *views=self.controller?self.controller.view:self;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:views animated:YES];
    hud.minShowTime=0.5;
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.labelText=message;
    return hud;
}
-(void)networkall:(NSString*)requestClass requestMethod:(NSString*)requestMethod requestHasParams:(NSString*)requestHasParams parameter:(NSDictionary*)paramterdic progresHudText:(NSString*)hudText completionBlock:(void (^)(id rep))completionBlock
{
    if ([Tools IsNetwork]) {
        MBProgressHUD *hud=[self progressWaitingWithMessage:hudText];
        [[AFAppDotNetAPIClient setRequestClass:requestClass requestMethod:requestMethod requestHasParams:requestHasParams] POST:[NSString stringWithFormat:@"http://%@:%@/%@",SingObj.serviceIp,SingObj.servicePort,LOGINPATH] parameters:paramterdic success:^(AFHTTPRequestOperation * operation, id responseObject) {
            [hud hide:YES];
            NSLog(@"%@",[responseObject mj_JSONString]);
            responseObject=[responseObject killNull];
            completionBlock(responseObject);
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            [hud hide:YES];
            [self showMessage:@"网络不稳定，请重试"];
            completionBlock(nil);
        }];
    }
    else
    {
        [Tools showMsgBox:NotWrok];
        completionBlock(nil);
    }
}
-(void)showMessage:(NSString*)message{
     UIView *views=self.controller?self.controller.view:self;
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:views animated:YES];
    hud.mode=MBProgressHUDModeCustomView;
    hud.animationType=MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(kScreenWidth/4, 24);
    hud.margin = 15;
    hud.labelText=message;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}
-(BOOL)updateGwfj:(NSData*)fileData
{
    NSString *fjnr =[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><imgfjnr>%@</imgfjnr><intdwlsh>%@</intdwlsh><intcsdwlsh>%@</intcsdwlsh><intrylsh>%@</intrylsh><intgwlsh>%@</intgwlsh><chrryxm>%@</chrryxm><chripdz>%@</chripdz></root>",[GTMBase64 stringByEncodingData:fileData],@(SingObj.unitInfo.intdwlsh),@(SingObj.unitInfo.intdwlsh_child),@(SingObj.userInfo.intrylsh),[NSString stringWithFormat:@"%@",self.intgwlzlsh],SingObj.userInfo.username,[YYBSingObj defaultManager].deviceId];

    NSDictionary *dic=@{@"intfjlsh":[[NSUserDefaults standardUserDefaults]objectForKey:@"fjlshstr"],@"queryTermXML":fjnr};
    [self networkall:@"document" requestMethod:@"updateGwfj" requestHasParams:@"yes" parameter:dic progresHudText:@"上传修改文稿" completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"root"][@"result"] intValue]==0) {
                if (self.callback) {
                    [self showMessage:@"上传成功!"];
                    [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0]; 
                }
            }
        }
        else
        {
            UIAlertView *alertview=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"网络链接不稳定，是否重新上传改稿" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    [self updateGwfj:fileData];
                }
            }];
            [alertview show];
        }
    }];
    return YES;
}
-(void)gogo{
    self.callback(YES);
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
