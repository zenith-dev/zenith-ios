//
//  LBBackOffice.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/27.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBBackOfficeDelegate<NSObject>
-(void)backofficeupdata;
@end
@interface LBBackOffice : UIView
@property(nonatomic,strong)NSMutableDictionary *savedic;//保存信息用
@property(nonatomic,strong)NSDictionary *backofficedic;//退办信息
@property(nonatomic,assign)id<LBBackOfficeDelegate> delegate;
- (id)initWithFrame:(CGRect)frame backOffice:(NSString*)backOffice;
- (void)show;
- (void)hidden;
@end
