//
//  ztOAYearBoxView.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ztOAYearBoxDelegate

-(void)changeBoxValue:(NSString *)value;

@end

@interface ztOAYearBoxView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableBox;
    int         iItem_Height;
}
@property(nonatomic,strong)NSMutableArray *boxDataValueSource;

@property(nonatomic,strong)id <ztOAYearBoxDelegate> delegate;
-(id)initWithFrame:(CGRect)frame itemHight:(int)height_t;
@end
