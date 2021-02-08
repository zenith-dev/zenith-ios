//
//  FilePlugin.m
//  OAMobile_ios5_ipad
//
//  Created by 陈 也 on 12-5-23.
//  Copyright (c) 2012年 zt.com. All rights reserved.
//

#import "FilePlugin.h"
#import "UIViewHelp.h"
#import "JSONKit.h"
#import "ztOAOpenVC.h"
#import "ztOAPreviewViewController.h"
#import "ztOALowVersionPreviewViewController.h"
#import "ztOAHttpRequest.h"

@implementation FilePlugin

@synthesize FjOpenPath;
@synthesize fjName;
@synthesize fileRealName;
@synthesize controller;
@synthesize curFjPath;
@synthesize viewController;
@synthesize delegate = _delegate;

- (void) fjmc:(NSString*)fjmc
     blnvalue:(NSString*)blnvalue
     strClass:(NSString*)strClass
    strMethod:(NSString*)strMethod
        pageX:(NSString*)pageX
        pageY:(NSString*)pageY
     isChange:(NSString*)isChange
      withUrl:(NSString *)aUrl andPort:(NSString *)aPort andPath:(NSString *)aPath
 withSendDict:(NSDictionary *)aDict fjType:(NSString *)aFjType{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManage = [NSFileManager defaultManager];

    if (![fjmc isEqual:[NSNull null]]) {
        NSRange range = [fjmc rangeOfString:@"."];
        NSString *tempFjmc = [fjmc substringToIndex:range.location];
        self.fileRealName = tempFjmc;
        NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
        
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        fjmc = [NSString stringWithFormat:@"%@_%@%@", tempFjmc, [[aDict allValues] objectAtIndex:0], extfilename];
        self.fjName = fjmc;
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fjmc];
        self.curFjPath = filePath;
        
        //若查看的文件为附件，则不需要再次下载，直接打开存在的文件
        if (!([aFjType isEqualToString:@"正文稿"] || [aFjType isEqualToString:@"正式正文稿"]) && [fileManage fileExistsAtPath:filePath isDirectory:NO]) {
            [self openQuickLookVC];
            return;
        }
        
        //查看正文稿时每次都需要下载，避免正文稿内容更改后本地取不到最新数据
        [UIViewHelp showProgressDialog:@"正在下载附件，请稍后"];
        [ztOAHttpRequest sendUrl:[NSString stringWithFormat:@"http://%@:%@%@", aUrl, aPort, aPath] sendParams:aDict sendClass:strClass sendMethod:strMethod sendHasParams:@"yes" completionBlock:^(id result) {
            [UIViewHelp dismissProgressDialog];
            NSString *content = [[[[result objectFromJSONString] objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
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
            //若文件已经写入
            if([fileManage fileExistsAtPath:filePath]){
                if([isChange isEqualToString:@"yes"]){
                    [self filePath:filePath pageX:pageX pageY:pageY];
                }else{
                    if ([extfilename isEqualToString:@".pdf"]||[extfilename isEqualToString:@".PDF"]) {
                        NSURL *url = [NSURL fileURLWithPath:filePath];
                        self.controller = [UIDocumentInteractionController  interactionControllerWithURL:url];
                        self.controller.delegate =self;
                        CGRect navRect = viewController.view.frame;
                        navRect.size = CGSizeMake(50.0f,20.0f);
                        navRect.origin = CGPointMake([pageX floatValue],[pageY floatValue]);
                        [self.controller presentPreviewAnimated:YES];
                        [self.controller presentOpenInMenuFromRect:navRect inView:viewController.view animated:YES];
                    }else
                    {
                        [self openQuickLookVC];
                    }
                }
            }
        } andFailedBlock:^(NSError *error) {
            [UIViewHelp dismissProgressDialog];
            [UIViewHelp alertTitle:@"温馨提示" alertMessage:@"网络异常，请稍后再试"];
        }];
        
    } else{
        [UIViewHelp showProgressDialog:@"数据错误"];
        [self performBlock:^(id sender) {
            [UIViewHelp dismissProgressDialog];
        } afterDelay:2];
    }

}

- (void) filePath:(NSString*)filePath pageX:(NSString*)pageX pageY:(NSString*)pageY{
    NSString *moviePath = filePath;
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    
    self.controller = [UIDocumentInteractionController  interactionControllerWithURL:url];
    self.controller.delegate =self;
    
    CGRect navRect = viewController.view.frame;
    navRect.size = CGSizeMake(50.0f,20.0f);
    navRect.origin = CGPointMake([pageX floatValue],[pageY floatValue]);
    [self.controller presentOptionsMenuFromRect:navRect inView:viewController.view animated:YES];
}
//新的文件预览方式
- (void)openQuickLookVC{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [self filePath:self.curFjPath pageX:@"0" pageY:@"64"];
    } else{
        ztOALowVersionPreviewViewController *previewer = [[ztOALowVersionPreviewViewController alloc] initWithURL:self.curFjPath];
        [previewer setDataSource:self];
        [previewer setCurrentPreviewItemIndex:0];
        [viewController.navigationController pushViewController:previewer animated:YES];
    }
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
    return viewController;
    
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller

{
    
    return viewController.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller

{
    
    return viewController.view.frame;
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
    
    //更改按钮-----
    [_delegate FileOpenBegin];
}

//上传
//- (void) fjmc:(NSString*)fjmc
//      strClass:(NSString*)strClass
//     strMethod:(NSString*)strMethod
//       withUrl:(NSString *)aUrl andPort:(NSString *)aPort andPath:(NSString *)aPath
//   andSendDict:(NSDictionary *)aSendDict{
//    NSString *str = self.FjOpenPath;
//    str = [str stringByAppendingString:@"/"];
//    str = [str stringByAppendingString:self.fjName];
//    NSData *tempData = [[NSData alloc] initWithContentsOfFile:str];
//    NSString *tempData2 = [[NSString alloc] initWithData:[GTMBase64 encodeData:tempData] encoding:NSUTF8StringEncoding];
//    
//    NSRange range = [fjmc rangeOfString:@"."];
//	
//	NSString *extfilename=[fjmc substringFromIndex:range.location];//得到文件扩展名
//
//    NSString *strQueryTermXML = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"<root>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"<strfjmc>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:fjmc];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"</strfjmc>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"<imgfjnr>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:tempData2];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"</imgfjnr>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"<strkzm>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:extfilename];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"</strkzm>"];
//    strQueryTermXML = [strQueryTermXML stringByAppendingString:@"</root>"];
//    
//    NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:aSendDict];
//    [sendDict setObject:strQueryTermXML forKey:@"queryTermXML"];
//    
//    //上传成功
//    [_delegate FileUploadOver:result];
//}


/*
 **打开预览窗口
 **废弃,现在使用QuickLook的方式预览
- (void) filePath:(NSString*)filePath{
    NSString *moviePath = filePath;
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    
    self.controller = [UIDocumentInteractionController  interactionControllerWithURL:url];
    self.controller.delegate =self;
    [self.controller presentPreviewAnimated:YES];
}
 */



/*
 **遍历其他APP内文件
 **非越狱无效！！！！！！！
//使用第三方软件打开文件之前
- (void) documentInteractionController: (UIDocumentInteractionController *) controller willBeginSendingToApplication: (NSString *) application{
	
	NSString * AppName=@"";//应用名称
	
	//self.FjOpenPath= [[NSUserDefaults standardUserDefaults] stringForKey:application];
	
	//if(self.FjOpenPath==nil||[self.FjOpenPath isEqualToString:@""]){ //如果文件路径为空 
    if([application isEqualToString:@"com.apple.Pages"]){
        AppName=@"Pages.app/";
    }
    if([application isEqualToString:@"com.bytesquared.office2ipad"]){
        AppName=@"Office² HD.app/";
    }
    NSString * current_path=@"var/mobile/Applications/";  //73463CEC-BB9D-45A8-9C9E-69E3430757FC/
    self.FjOpenPath=[self FindRootAppPath:current_path  FindForApp:AppName];
	
	if([application isEqualToString:@"com.apple.Pages"]){
		self.FjOpenPath=[self.FjOpenPath stringByAppendingPathComponent:@"Documents"];
	}
	
	if([application isEqualToString:@"com.bytesquared.office2ipad"]){
		self.FjOpenPath=[self.FjOpenPath stringByAppendingPathComponent:@"Documents/Inbox"];
	}
	//}
    
	//保存当前打开应用的路径
	//[[NSUserDefaults standardUserDefaults] setObject:self.FjOpenPath forKey:application];
    //	NSLog(self.FjOpenPath);
	
}

//循环根目录查找应用程序路径  
-(NSString *)FindRootAppPath:(NSString *)current_path FindForApp:(NSString *) appname{
	//  NSLog(@"appname = %@ current_path=%@",appname,current_path);			
	
	NSFileManager *filemanager = [NSFileManager defaultManager];
	NSError *error;
	NSString * returnPath=@"";
	NSArray *mainPath = [filemanager contentsOfDirectoryAtPath:current_path error:&error];
	//	NSMutableArray *paths = [[NSMutableArray alloc]initWithCapacity:100];
	NSString *filePath; 
	int i = 0;
	if ([mainPath count]>0) {
		while((filePath = [mainPath objectAtIndex:i++])) {
			BOOL isDir = NO;
			[filemanager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",current_path,filePath] isDirectory:&isDir];
			if (isDir) {
				filePath = [filePath stringByAppendingString:@"/"];
				
				NSString * newPath=[current_path stringByAppendingString:filePath];
				returnPath=[self FindFjAppPath:newPath AppForName:appname];
				//如果返回路径为true
				if([returnPath isEqualToString:@"true"]){
					return newPath;
					
				}
				
			}	
			//[paths addObject:filePath];
			if (i>=[mainPath count]) {
				break;
			}
		}
	}		
    
	return returnPath;
}


//循环子目录查找应用程序路径 
-(NSString *)FindFjAppPath:(NSString *)current_path AppForName:(NSString *)appname{
	
	NSFileManager *filemanager = [NSFileManager defaultManager];  //创建文件管理对象
	NSError *error;
    NSString * returnPath=@"false";
	//得到目录数组
	NSArray *mainPath = [filemanager contentsOfDirectoryAtPath:current_path error:&error];
    //	NSMutableArray *paths = [[NSMutableArray alloc]initWithCapacity:100];
	NSString *filePath; 
	int i = 0;
	if ([mainPath count]>0) { //如果数组中有数据
		while((filePath = [mainPath objectAtIndex:i++])) {
			BOOL isDir = NO;
			[filemanager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",current_path,filePath] isDirectory:&isDir];
			if (isDir) {
				filePath = [filePath stringByAppendingString:@"/"];
				//NSLog(@"filePath = %@ current_path=%@",filePath,current_path);	
				
				if([filePath isEqualToString:appname]){//如果当前应用目录＝＝
                    return @"true";
				}
                
                
			}	
			//[paths addObject:filePath];
			if (i>=[mainPath count]) {
				break;
			}
 		}
	}	
	return returnPath;	
    //	self.showPaths = paths;
	//[paths release];
	//return @"";
}

//循环子目录查找应用程序路径 
-(void)deleteFjAppPath:(NSString *)current_path{
	
	NSFileManager *filemanager = [NSFileManager defaultManager];  //创建文件管理对象
	NSError *error;
	//得到目录数组
	NSArray *mainPath = [filemanager contentsOfDirectoryAtPath:current_path error:&error];
    //	NSMutableArray *paths = [[NSMutableArray alloc]initWithCapacity:100];
	NSString *filePath; 
    NSString *filepatht;
	int i = 0;
	if ([mainPath count]>0) { //如果数组中有数据
		while((filePath = [mainPath objectAtIndex:i++])) {
            
            if([filePath hasPrefix:@"ztfj_"]){//如果当前应用目录＝＝
                filepatht = [[NSString alloc] initWithFormat:@"%@/%@",current_path,filePath];
                    
                if ([filemanager removeItemAtPath:filepatht error:&error] != YES){
                    NSLog(@"删除文件时错误: %@", [error localizedDescription]);
                }
            }
                
			if (i>=[mainPath count]) {
				break;
			}
 		}
	}
}
*/

//- (void)dealloc
//{
//    if(self.FjOpenPath){
//        [self deleteFjAppPath:self.FjOpenPath];
//    }
//}

@end
