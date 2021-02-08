//
//  LBTransferred.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/25.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBTransferredDelegate<NSObject>
-(void)transferredupdata;
@end
@interface LBTransferred : UIView
@property(nonatomic,assign)id<LBTransferredDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *savedic;//保存信息用
- (id)initWithFrame:(CGRect)frame transferred:(NSString*)transferred savedic:(NSMutableDictionary*)savedic;
- (void)show;
- (void)hidden;
@end
