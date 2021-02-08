//
//  ztOAFjSimpelCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-16.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAFjSimpelCell.h"

@implementation ztOAFjSimpelCell
@synthesize iconImg,fjName,lineBreak,backImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, self.width-5,self.height-4)];
        backImage.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [backImage setHidden:YES];
        [self.contentView addSubview:backImage];
        
        iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 40,40)];
        iconImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconImg];
        
        fjName = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, (self.height-20)/2, self.width-iconImg.right-20, 20)];
        fjName.backgroundColor = [UIColor clearColor];
        //fjName.font = [UIFont systemFontOfSize:12.0f];
        [fjName setFont:[UIFont systemFontOfSize:12]];
        fjName.textColor = [UIColor blackColor];
        [self.contentView addSubview:fjName];
        
        lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:lineBreak];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
