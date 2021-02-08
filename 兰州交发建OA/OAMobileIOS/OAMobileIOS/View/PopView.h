//
//  PopView.h
//  Arfa
//
//  Created by 熊佳佳 on 16/8/24.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopViewDelegate<NSObject>
-(void)getIndexRow:(int)selectrow key:(NSString*)key;
@end
@interface PopView : UIView
@property (nonatomic,strong)NSArray *sourceary;//数据源
@property (nonatomic,strong)NSString *key;//类型
@property (nonatomic,strong)NSString *titles;//标题
@property(assign,nonatomic)NSInteger selectRowIndex;
@property (nonatomic,retain)id<PopViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)show;
- (void)hidden;
@end
