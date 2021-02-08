//
//  ztOATreeTableCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-28.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOATreeViewNode.h"
@protocol expandNodesAddDelegate
-(void)addnodeChildren:(ztOATreeViewNode *)currentNode hasLoadData:(BOOL)hasLoadData;
@end

@interface ztOATreeTableCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (nonatomic)   BOOL isExpanded;//是否展开

@property (strong, nonatomic) UILabel       *cellLabel;//名字
@property (strong, nonatomic) UIImageView   *cellIconImage;//图标
@property (strong, nonatomic) UIImageView   *cellSelectedIcon;//图标
@property (strong, nonatomic) UIImageView   *cellBackImage;//背景
@property (strong, strong) ztOATreeViewNode *treeNode;//子目录
@property(nonatomic,assign) id<expandNodesAddDelegate> delegate;

- (void)addGestureTouchUp:(BOOL)isCan;//是否添加展开收起手势
- (void)expand:(id)sender;
- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage;
- (void)setTheSelectedIconImage:(UIImage *)imageName;
@end
