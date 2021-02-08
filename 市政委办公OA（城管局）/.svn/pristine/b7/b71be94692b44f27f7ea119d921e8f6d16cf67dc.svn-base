//
//  ztOASImpleView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASImpleView.h"
@implementation ztOASImpleView
@synthesize docName,writer,writeTime,docLink,signOneImgView,signTwoImgView;
@synthesize oneBigImgViewBtn,oneWriteImgViewBtn,twoBigImgViewBtn,twoWriteImgViewBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.docName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-20, 30)];
        docName.text =@"文档名称:";
        docName.backgroundColor = [UIColor clearColor];
        [self addSubview:docName];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, docName.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        self.writer = [[UILabel alloc] initWithFrame:CGRectMake(10, docName.bottom, self.width-20, 40)];
        writer.text =@"作者:";
        writer.backgroundColor = [UIColor clearColor];
        [self addSubview:writer];
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, writer.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        self.writeTime = [[UILabel alloc] initWithFrame:CGRectMake(10, writer.bottom, self.width-20, 40)];
        writeTime.text =@"创建时间:";
        writeTime.backgroundColor = [UIColor clearColor];
        [self addSubview:writeTime];
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, writeTime.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, writeTime.bottom, 60, 40)];
        label.text =@"文档:";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        
        self.docLink = [[ztOAUnderLineLabel alloc] initWithFrame:CGRectMake(70, writeTime.bottom+5, self.width-80, 30)];
        [docLink setBackgroundColor:[UIColor clearColor]];
        [docLink setFont:[UIFont systemFontOfSize:15]];
        [docLink setTextColor:[UIColor blueColor]];
        docLink.highlightedColor = [UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000];
        docLink.shouldUnderline = YES;
        [docLink setText:@"文档附件"];
        [docLink setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:docLink];
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, label.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, docLink.bottom+20, 80, 40)];
        label.text =@"签字示范1:";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.signOneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(label.right, docLink.bottom+20, 170, 100)];
        [self.signOneImgView setUserInteractionEnabled:YES];
        self.signOneImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:signOneImgView];
        
        self.oneBigImgViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(signOneImgView.right+10, docLink.bottom+10, 25, 25)];
        oneBigImgViewBtn.backgroundColor = [UIColor clearColor];
        [oneBigImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgBig_logo"] forState:UIControlStateNormal];
        [oneBigImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgBig_on_logo"] forState:UIControlStateHighlighted];
        [self addSubview:oneBigImgViewBtn];
        
        self.oneWriteImgViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(signOneImgView.right+10, docLink.bottom+10+25+10, 25, 25)];
        oneWriteImgViewBtn.backgroundColor = [UIColor clearColor];
        [oneWriteImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgWrite_logo"] forState:UIControlStateNormal];
        [oneWriteImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgWrite_on_logo"] forState:UIControlStateHighlighted];
        [self addSubview:oneWriteImgViewBtn];
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, signOneImgView.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, signOneImgView.bottom+20, 80, 40)];
        label.text =@"签字示范2:";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.signTwoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(label.right, signOneImgView.bottom+20, 170, 100)];
        [self.signTwoImgView setUserInteractionEnabled:YES];
        self.signTwoImgView.backgroundColor = [UIColor clearColor];
        [self addSubview:signTwoImgView];
        
        self.twoBigImgViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(signTwoImgView.right+10, signOneImgView.bottom+10, 25, 25)];
        twoBigImgViewBtn.backgroundColor = [UIColor clearColor];
        [twoBigImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgBig_logo"] forState:UIControlStateNormal];
        [twoBigImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgBig_on_logo"] forState:UIControlStateHighlighted];
        [self addSubview:twoBigImgViewBtn];
        
        self.twoWriteImgViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(signOneImgView.right+10, signOneImgView.bottom+10+25+10, 25, 25)];
        twoWriteImgViewBtn.backgroundColor = [UIColor clearColor];
        [twoWriteImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgWrite_logo"] forState:UIControlStateNormal];
        [twoWriteImgViewBtn setBackgroundImage:[UIImage imageNamed:@"signImgWrite_on_logo"] forState:UIControlStateHighlighted];
        [self addSubview:twoWriteImgViewBtn];
        
        oneBigImgViewBtn.tag = 100;
        oneWriteImgViewBtn.tag = 101;
        twoBigImgViewBtn.tag = 200;
        twoWriteImgViewBtn.tag = 201;
        
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, signTwoImgView.bottom, self.width, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
    }
    return self;
}

@end
