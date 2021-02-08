//
//  ztOAYearBoxView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAYearBoxView.h"

@implementation ztOAYearBoxView
@synthesize delegate = _delegate;
@synthesize boxDataValueSource;
- (id)initWithFrame:(CGRect)frame itemHight:(int)height_t
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        iItem_Height = height_t;
        
        tableBox = [[UITableView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        tableBox.dataSource = self;
        tableBox.delegate = self;
        [self addSubview:tableBox];
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.boxDataValueSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"boxCell";
    UITableViewCell *cell = [tableBox dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    //添加内容
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return iItem_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([(id)_delegate respondsToSelector:@selector(changeBoxValue:) ])
    {
        [_delegate changeBoxValue:[NSString stringWithFormat:@"%@",[self.boxDataValueSource objectAtIndex:indexPath.row]]];
        
    }
    
}
@end
