//
//  ztOATreeViewNode.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-28.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOATreeViewNode : NSObject
@property (nonatomic) NSUInteger nodeLevel;//级数
@property (nonatomic) BOOL isExpanded;//是否展开
@property (nonatomic)   BOOL isSelected;//是否选中
@property (nonatomic, strong) id nodeObject;//显示的数据
@property (nonatomic) BOOL haveChildNodFlag;//是否有子级目录
@property (nonatomic, strong) NSMutableArray *nodeChildren;//下级数据
@property (nonatomic, strong) NSDictionary   *infoDic;//数据包
@property (nonatomic, strong) NSString   *manType;//数据类型：机构:2;or人员:1
@end
