//
//  ztOAButton.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-5.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation ztOAButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
-(void)setBtnColor:(UIColor *)btnColor
{
    [self.layer setBorderWidth:1];
    [self.layer setCornerRadius:5];
    [self.layer setBorderColor:[btnColor CGColor]];
}

@end
