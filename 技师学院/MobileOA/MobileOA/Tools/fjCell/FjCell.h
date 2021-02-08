//
//  FjCell.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FjCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *tzDic;//通知
@property (nonatomic,strong)NSDictionary *zwgDic;//正文搞
@property (nonatomic,strong)UIButton *gglb;//改稿
@property (nonatomic,assign)BOOL ctrone;
@end
