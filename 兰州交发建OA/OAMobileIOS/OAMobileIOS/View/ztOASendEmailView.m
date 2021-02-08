//
//  ztOASendEmailView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-24.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASendEmailView.h"

@implementation ztOASendEmailView
@synthesize pepoleLabel,pepoleInfoLabel,addPepoleBtn,titleLabel,titleInfoField,contextLabel,contextInfoView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //收件人
        pepoleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 20)];
        pepoleLabel.text =@"收件人：";
        pepoleLabel.textColor = [UIColor grayColor];
        pepoleLabel.textAlignment = NSTextAlignmentLeft;
        pepoleLabel.backgroundColor = [UIColor clearColor];
        pepoleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        pepoleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 17, self.frame.size.width-80-10-40, 18)];
        pepoleInfoLabel.textAlignment = NSTextAlignmentLeft;
        pepoleInfoLabel.textColor = [UIColor blackColor];
        [pepoleInfoLabel setBackgroundColor:[UIColor whiteColor]];
        [pepoleInfoLabel setFont:[UIFont systemFontOfSize:13.0f]];
        
        addPepoleBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addPepoleBtn.frame = CGRectMake(pepoleInfoLabel.right+5, 10, 30, 30);
        addPepoleBtn.backgroundColor = [UIColor clearColor];
        
        UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40-1, self.frame.size.width, 1)];
        lineImg.backgroundColor =MF_ColorFromRGB(234, 234, 234);
        
        [self addSubview:pepoleLabel];
        [self addSubview:pepoleInfoLabel];
        [self addSubview:addPepoleBtn];
        [self addSubview:lineImg];
        //标题
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+5, 80, 20)];
        titleLabel.text =@"标   题：";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        titleInfoField = [[UITextField alloc] initWithFrame:CGRectMake(80, 47+5, self.frame.size.width-80-10, 18)];
        [titleInfoField setFont:[UIFont systemFontOfSize:13.0f]];
        titleInfoField.returnKeyType = UIReturnKeyNext;
        [titleInfoField setKeyboardType:UIKeyboardTypeDefault];
        titleInfoField.backgroundColor = [UIColor whiteColor];
        
        lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40+29+5, self.frame.size.width, 1)];
        lineImg.backgroundColor =MF_ColorFromRGB(234, 234, 234);
        
        [self addSubview:titleLabel];
        [self addSubview:titleInfoField];
        [self addSubview:lineImg];
        //内容
        //contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30+20, 70, 20)];
        //contextLabel.text =@"内  容：";
        //contextLabel.textAlignment = NSTextAlignmentLeft;
        //contextLabel.textColor = [UIColor grayColor];
        //contextLabel.backgroundColor = [UIColor clearColor];
        //contextLabel.font = [UIFont systemFontOfSize:15.0f];
        
        //UIImageView *contextBackImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_text"]];
        //contextBackImg.frame =CGRectMake(75, 30+20+5, self.frame.size.width-70-10, 100);
        
        
        contextInfoView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40+30+5, self.frame.size.width-20, 100-5)];
        [contextInfoView setFont:[UIFont systemFontOfSize:12.0f]];
        contextInfoView.returnKeyType = UIKeyboardTypeDefault;
        [contextInfoView setKeyboardType:UIKeyboardTypeDefault];
        contextInfoView.backgroundColor = [UIColor clearColor];
        
        //[self addSubview:contextBackImg];
        //[self addSubview:contextLabel];
        [self addSubview:contextInfoView];
        
    }
    return self;
}



@end
