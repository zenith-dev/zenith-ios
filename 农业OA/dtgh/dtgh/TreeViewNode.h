//
//  TreeViewNode.h
//  The Projects
//
//  Created by Ahmed Karim on 1/12/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic,strong)NSString *intlsh;//流水号
@property (nonatomic, strong) NSString *strdwccbm;
@property (nonatomic, strong) NSString *rymc;//人员名称
@property (nonatomic, assign) BOOL check;//是否选中
@property (nonatomic, strong) NSMutableArray *nodeChildren;

@end
