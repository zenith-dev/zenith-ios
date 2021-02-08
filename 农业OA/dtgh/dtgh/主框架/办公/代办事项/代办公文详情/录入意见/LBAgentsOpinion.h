//
//  LBAgentsOpinion.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/18.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OpinionDelegate<NSObject>
-(void)updates;
@end
@interface LBAgentsOpinion : UIView
@property(nonatomic,strong)NSDictionary *opintondic;
@property(nonatomic,assign)id<OpinionDelegate> opinionDelegate;
@property(nonatomic,strong)NSMutableDictionary *savedic;//保存信息用
@property (nonatomic,strong)UINavigationController *nav;
- (id)initWithFrame:(CGRect)frame opiniontitle:(NSString*)opiniontitle;
- (void)show;
- (void)hidden;
@end
