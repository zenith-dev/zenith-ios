//
//  ztOANewDocTableViewCell.m
//  OAMobileIOS
//
//  Created by ran chen on 14-5-15.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOANewDocTableViewCell.h"

@implementation ztOANewDocTableViewCell
@synthesize imageView, title;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:imageView];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(40,5, self.width-40-40, 30)];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView  addSubview:title];
    }
    return self;
}

- (void)setCellImageView:(UIImage *)aImage{
    [self.imageView setImage:aImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
