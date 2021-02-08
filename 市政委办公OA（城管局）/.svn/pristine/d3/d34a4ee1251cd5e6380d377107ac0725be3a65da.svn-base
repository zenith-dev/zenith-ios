//
//  ztOAFjDetailCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-31.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAFjDetailCell.h"

@implementation ztOAFjDetailCell
@synthesize fileNameLable,fileSimpleImg,fileDeleteBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        //backImg.backgroundColor = [UIColor clearColor];
        //[self.contentView addSubview:backImg];
        
        self.backgroundColor = [UIColor clearColor];
        fileSimpleImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 40, 40)];
        fileSimpleImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:fileSimpleImg];
        
        fileNameLable = [[UILabel alloc] initWithFrame:CGRectMake(60, (self.height-20)/2, self.width-60-10-40, 20)];
        fileNameLable.backgroundColor = [UIColor clearColor];
        fileNameLable.textAlignment = NSTextAlignmentLeft;
        fileNameLable.font = [UIFont systemFontOfSize:14.0f];
        fileNameLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:fileNameLable];
        
        fileDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fileDeleteBtn.frame = CGRectMake(fileNameLable.right+10, (self.height-24)/2, 24, 24);
        [fileDeleteBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [fileDeleteBtn setImage:[UIImage imageNamed:@"close_on"] forState:UIControlStateHighlighted];
        fileDeleteBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:fileDeleteBtn];
        
        UIImageView *breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        breakLine.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:breakLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
 
@end
