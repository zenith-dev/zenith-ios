//
//  ztOADetailContactInfoCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-25.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADetailContactInfoCell.h"

@implementation ztOADetailContactInfoCell
@synthesize name,detailInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        name= [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 15)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor blackColor]];
        [name setText:@""];
        [name setFont:[UIFont boldSystemFontOfSize:15]];
        [self.contentView addSubview:name];
        
        detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 320-10-110, 15)];
        [detailInfo setBackgroundColor:[UIColor clearColor]];
        [detailInfo setTextAlignment:NSTextAlignmentLeft];
        [detailInfo setTextColor:[UIColor blackColor]];
        [detailInfo setText:@""];
        [detailInfo setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 320, 1) ];
        breakLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:breakLine];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
