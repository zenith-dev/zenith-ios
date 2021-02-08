//
//  ztOAPersnalCenterCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-9-15.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPersnalCenterCell.h"

@implementation ztOAPersnalCenterCell
@synthesize iconImg,nameLabel,detailInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
        iconImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconImg];
        NSString *s =@"移动电话";
       CGSize ssize =[s sizeWithAttributes:@{NSFontAttributeName:Font(15)}];
        
        nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 15, ssize.width, 20)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setText:@""];
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:nameLabel];
        
        detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right+5, 15, self.width-nameLabel.right-15, 20)];
         detailInfo.adjustsFontSizeToFitWidth=YES;
        [detailInfo setBackgroundColor:[UIColor clearColor]];
        [detailInfo setTextAlignment:NSTextAlignmentRight];
        [detailInfo setTextColor:BACKCOLOR];
        [detailInfo setText:@""];
        [detailInfo setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *breakLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, 320, 1) ];
        breakLine.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:breakLine];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
