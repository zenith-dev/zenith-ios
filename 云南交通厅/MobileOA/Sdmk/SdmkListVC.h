//
//  SdmkListVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/1.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface SdmkListVC : BaseViewController
@property (nonatomic,strong)NSString *type;//签报件查询:010 信访查询：012 电话单处理:013 便函查询:011  014  公文查询 015 历史库查询 017个人公文 018 处室来文列表 020督办
@property (nonatomic,strong) NSString *searchBarStr;//搜索字符串
@property (nonatomic,strong)NSDictionary *searchDic;

@end
