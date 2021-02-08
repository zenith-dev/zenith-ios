//
//  ZMOFjView.h
//  libztmobileoaapi
//
//  Created by 陈 也 on 14-3-4.
//  Copyright (c) 2014年 陈 也. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilePlugin.h"
#import "ztOAFjSimpelCell.h"

@protocol ZMOFjDelegate <NSObject>
@optional
- (void)ZMOFjUploadOver:(id)result;
@end

@interface ZMOFjView : UIView<UITableViewDelegate,UITableViewDataSource,FilePluginDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UITableView *fjTableView;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) id <ZMOFjDelegate> delegate;

- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)fjArray
               isGg:(BOOL)isGg
               jbxx:(NSDictionary *)jbxx
            withUrl:(NSString *)aUrl
            andPort:(NSString *)aPort
            andPath:(NSString *)aPath
          andMethod:(NSString *)aMethod
           andClass:(NSString *)aClass
        andFjlshKey:(NSString *)aFjlshKey
           typeShow:(NSString *)typeShow
     andFjlshKeyStr:(NSString *)fjlshKeyStr;

@end
