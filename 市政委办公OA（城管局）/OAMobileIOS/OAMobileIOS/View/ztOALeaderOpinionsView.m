//
//  ztOALeaderOpinionsView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-7-4.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOALeaderOpinionsView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ztOALeaderOpinionsView
@synthesize leaderOpinionLabel,leaderNameLable,sendTimeLable,backImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, self.width, self.height-2)];
        backImage.backgroundColor = [UIColor clearColor];
        [backImage.layer setBorderWidth:1];
        [backImage.layer setBorderColor:[MF_ColorFromRGB(234, 234, 234) CGColor]];
        [self addSubview:backImage];
        
        //sendTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.width-100-10, 0, 100, 19)];
        //sendTimeLable.text =@"";
        //sendTimeLable.textColor = [UIColor blackColor];
        //sendTimeLable.backgroundColor = [UIColor clearColor];
        //sendTimeLable.font = [UIFont systemFontOfSize:14.0f];
        //sendTimeLable.textAlignment = NSTextAlignmentRight;
        //[self addSubview:sendTimeLable];
        
        leaderOpinionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, self.width-20, 15)];
        leaderOpinionLabel.text =@"";
        leaderOpinionLabel.textColor = [UIColor blackColor];
        [leaderOpinionLabel setNumberOfLines:0];
        [leaderOpinionLabel setLineBreakMode:NSLineBreakByCharWrapping];
        leaderOpinionLabel.backgroundColor = [UIColor clearColor];
        leaderOpinionLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:leaderOpinionLabel];
        
        leaderNameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, leaderOpinionLabel.bottom, self.width-20, 15)];
        leaderNameLable.text =@"";
        leaderNameLable.textColor = [UIColor blackColor];
        leaderNameLable.textAlignment = NSTextAlignmentRight;
        leaderNameLable.font = [UIFont systemFontOfSize:12.0f];
        leaderNameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:leaderNameLable];
        
    }
    return self;
}

@end
