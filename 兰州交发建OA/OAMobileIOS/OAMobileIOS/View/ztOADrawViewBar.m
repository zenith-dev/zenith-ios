//
//  ztOADrawViewBar.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOADrawViewBar.h"
#import <QuartzCore/QuartzCore.h>
#define BTN_HEIGHT 30.0f
#define BTN_Y   5
#define GOBACK_BTN_WIDTH 60.0f
#define SAVE_BTN_WIDTH 40.0f
#define ERASER_BTN_WIDTH 40.0f
#define DELETE_BTN_WIDTH 40.0f
#define WIDTH_BTN_WIDTH 30.0f
#define COLOR_BTN_WIDTH 30.0f
#define PRE_BTN_WIDTH 30.0f
#define NEXT_BTN_WIDTH 30.0f
#define HELP_BTN_WIDTH 30.0f

@implementation ztOADrawViewBar
@synthesize backBtn,loadSignImgBtn,eraserBtn,saveBtn,widthChangeBtn,colorChangeBtn,barTitle,barBackImg,preDrawBtn,nextDrawBtn,helpInBtn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        barBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        barBackImg.backgroundColor = [UIColor grayColor];
        barBackImg.alpha = 0.5;
        [self addSubview:barBackImg];
        
        UIImage *imageH = [UIImage imageNamed:@"Reader-Button-H.png"];
		UIImage *imageN = [UIImage imageNamed:@"Reader-Button-N.png"];
        
        NSInteger leftCapWidth = imageH.size.width * 0.5f;
        NSInteger topCapHeight = imageH.size.height * 0.5f;
        imageN = [imageN stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        imageH = [imageH stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
        
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(5, BTN_Y, GOBACK_BTN_WIDTH, BTN_HEIGHT);
		[backBtn setTitle:@"返回" forState:UIControlStateNormal];
		[backBtn setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[backBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [backBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
		[backBtn setBackgroundImage:imageN forState:UIControlStateNormal];
		backBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		backBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:backBtn];
        
        loadSignImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loadSignImgBtn.frame = CGRectMake(5+backBtn.right, BTN_Y, DELETE_BTN_WIDTH, BTN_HEIGHT);
		[loadSignImgBtn setTitle:@"导入" forState:UIControlStateNormal];
		[loadSignImgBtn setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[loadSignImgBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [loadSignImgBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
		[loadSignImgBtn setBackgroundImage:imageN forState:UIControlStateNormal];
		loadSignImgBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		loadSignImgBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:loadSignImgBtn];
        
        eraserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        eraserBtn.frame = CGRectMake(5+loadSignImgBtn.right, BTN_Y, ERASER_BTN_WIDTH, BTN_HEIGHT);
		[eraserBtn setTitle:@"擦除" forState:UIControlStateNormal];
		[eraserBtn setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[eraserBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [eraserBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
		[eraserBtn setBackgroundImage:imageN forState:UIControlStateNormal];
		eraserBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		eraserBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:eraserBtn];
        
        saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(5+eraserBtn.right, BTN_Y, SAVE_BTN_WIDTH, BTN_HEIGHT);
		[saveBtn setTitle:@"保存" forState:UIControlStateNormal];
		[saveBtn setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[saveBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [saveBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
		[saveBtn setBackgroundImage:imageN forState:UIControlStateNormal];
		saveBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		saveBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:saveBtn];
        
        
        helpInBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        helpInBtn.frame = CGRectMake(self.width-HELP_BTN_WIDTH-5, BTN_Y, HELP_BTN_WIDTH, BTN_HEIGHT);
        [helpInBtn setBackgroundImage:[UIImage imageNamed:@"help_on_btn"] forState:UIControlStateHighlighted];
		[helpInBtn setBackgroundImage:[UIImage imageNamed:@"help_btn"] forState:UIControlStateNormal];
		[self addSubview:helpInBtn];
        
        widthChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        widthChangeBtn.frame = CGRectMake(helpInBtn.left-10-WIDTH_BTN_WIDTH, BTN_Y, WIDTH_BTN_WIDTH, BTN_HEIGHT);
		[widthChangeBtn setTitle:@"" forState:UIControlStateNormal];
		[widthChangeBtn setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateNormal];
		[widthChangeBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [widthChangeBtn setBackgroundImage:imageH forState:UIControlStateHighlighted];
		[widthChangeBtn setBackgroundImage:imageN forState:UIControlStateNormal];
		widthChangeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		widthChangeBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:widthChangeBtn];
        
        colorChangeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        colorChangeBtn.frame = CGRectMake(widthChangeBtn.left-10-COLOR_BTN_WIDTH, BTN_Y, COLOR_BTN_WIDTH, BTN_HEIGHT);
        [colorChangeBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [colorChangeBtn.layer setBorderWidth:3];
        [colorChangeBtn.layer setCornerRadius:5];
		[colorChangeBtn setBackgroundImage:nil forState:UIControlStateNormal];
		colorChangeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		colorChangeBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:colorChangeBtn];
        
        nextDrawBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        nextDrawBtn.frame = CGRectMake(colorChangeBtn.left-10-NEXT_BTN_WIDTH, BTN_Y, NEXT_BTN_WIDTH, BTN_HEIGHT);
        [nextDrawBtn setBackgroundImage:[UIImage imageNamed:@"next_on_btn"] forState:UIControlStateHighlighted];
		[nextDrawBtn setBackgroundImage:[UIImage imageNamed:@"next_btn"] forState:UIControlStateNormal];
		nextDrawBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		nextDrawBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:nextDrawBtn];
        
        preDrawBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        preDrawBtn.frame = CGRectMake(nextDrawBtn.left-5-PRE_BTN_WIDTH, BTN_Y, PRE_BTN_WIDTH, BTN_HEIGHT);
        [preDrawBtn setBackgroundImage:[UIImage imageNamed:@"undo_on_btn"] forState:UIControlStateHighlighted];
		[preDrawBtn setBackgroundImage:[UIImage imageNamed:@"undo_btn"] forState:UIControlStateNormal];
		preDrawBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
		preDrawBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:preDrawBtn];
        
        barTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.width-40)/2, 5, 40, 30)];
        barTitle.text = @"画板";
        barTitle.backgroundColor = [UIColor clearColor];
        barTitle.font = [UIFont systemFontOfSize:17.0f];
        [barTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:barTitle];
    }
    return self;
}
@end
