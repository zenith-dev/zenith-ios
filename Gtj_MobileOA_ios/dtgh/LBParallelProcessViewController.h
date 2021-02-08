//
//  LBParallelProcessViewController.h
//  dtgh
//
//  Created by zenith on 2019/1/29.
//  Copyright © 2019年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBBaseViewController.h"
#import "MyLayout.h"
#import "LBPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LBParallelProcessViewController : LBBaseViewController
@property(nonatomic,assign)int lint;
@property (nonatomic,assign)int bzlcint;
@property(nonatomic,strong)NSMutableDictionary *savedic;
@property(nonatomic,strong)LBPersonModel* personModel;
@end

NS_ASSUME_NONNULL_END
