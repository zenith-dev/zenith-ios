//
//  PopView.h
//  Arfa
//
//  Created by 熊佳佳 on 16/8/24.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  定义block
 *
 *  @param isSuccess isSuccess description
 */
typedef void (^CallBack)(int selectrow,NSString *key);

@interface PopView : UIView
/**
 *  修改数据调用更新
 */
@property(nonatomic, copy) CallBack callback;
@property (nonatomic,strong)NSArray *sourceary;//数据源
@property (nonatomic,strong)NSString *key;//类型
@property (nonatomic,strong)NSString *titles;//标题
@property(assign,nonatomic)NSInteger selectRowIndex;
@property (nonatomic,assign)BOOL isHide;
- (id)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)show;
- (void)hidden;
@end
