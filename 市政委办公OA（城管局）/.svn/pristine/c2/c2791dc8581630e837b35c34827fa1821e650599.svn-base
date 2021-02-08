//
//  FilePlugin.h
//  OAMobile_ios5_ipad
//
//  Created by 陈 也 on 12-5-23.
//  Copyright (c) 2012年 zt.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "GTMBase64.h"
#import "UIViewHelp.h"
#import <QuickLook/QuickLook.h>

@protocol FilePluginDelegate <NSObject>
@optional
- (void)FileOpenBegin;
- (void)FileUploadOver:(id)result;
@end

@interface FilePlugin : UIView <UIDocumentInteractionControllerDelegate, QLPreviewControllerDataSource>{
    
}

@property (nonatomic, strong) NSString *FjOpenPath;
@property (nonatomic, strong) NSString *fjName;
@property (nonatomic, strong) NSString *curFjPath;
@property (nonatomic, strong) NSString *fileRealName;
@property (nonatomic, strong) UIDocumentInteractionController *controller;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) id <FilePluginDelegate> delegate;

- (void) fjmc:(NSString*)fjmc
     blnvalue:(NSString*)blnvalue
     strClass:(NSString*)strClass
    strMethod:(NSString*)strMethod
        pageX:(NSString*)pageX
        pageY:(NSString*)pageY
     isChange:(NSString*)isChange
      withUrl:(NSString *)aUrl andPort:(NSString *)aPort andPath:(NSString *)aPath
 withSendDict:(NSDictionary *)aDict fjType:(NSString *)aFjType;

//- (void) fjmc:(NSString*)fjmc
//      strClass:(NSString*)strClass
//     strMethod:(NSString*)strMethod
//       withUrl:(NSString *)aUrl
//       andPort:(NSString *)aPort
//       andPath:(NSString *)aPath
//   andSendDict:(NSDictionary *)aSendDict;

- (void) filePath:(NSString*)filePath pageX:(NSString*)pageX pageY:(NSString*)pageY;
//- (void) filePath:(NSString*)filePath;

//-(NSString *)FindRootAppPath:(NSString *)current_path FindForApp:(NSString *) appname;
//-(NSString *)FindFjAppPath:(NSString *)current_path AppForName:(NSString *)appname;
//-(void)deleteFjAppPath:(NSString *)current_path;

@end