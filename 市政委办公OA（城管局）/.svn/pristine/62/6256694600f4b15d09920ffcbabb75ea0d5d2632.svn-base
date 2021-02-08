//
//  YwzdCsCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "YwzdCsCell.h"

@implementation YwzdCsCell
@synthesize titlelb;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.contentView.width-20, 40)];
        titlelb.numberOfLines=2;
        titlelb.textAlignment=NSTextAlignmentCenter;
        titlelb.font=Font(14);
        titlelb.textColor=[UIColor whiteColor];
        [self.contentView addSubview:titlelb];
        titlelb.centerY=self.height/2.0;
    }
    return self;
}
@end
