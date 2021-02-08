//
//  ztOASendEmailAddPicView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-8-8.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASendEmailAddPicView.h"
#define Pic_Width 53
#define Pic_Space_width 18
#define lable_height 15
#define Pic_Space_height 18+53
#define titltbar_height  40

@implementation ztOASendEmailAddPicView
@synthesize tilteBG;
@synthesize imgAddPic1;
@synthesize imgAddPic2;
@synthesize imgAddPic3;
@synthesize imgAddPic4;
@synthesize imgAddPic5;
@synthesize imgAddPic6;
@synthesize imgAddPic7;
@synthesize imgAddPic8;

@synthesize btnDel1;
@synthesize btnDel2;
@synthesize btnDel3;
@synthesize btnDel4;
@synthesize btnDel5;
@synthesize btnDel6;
@synthesize btnDel7;
@synthesize btnDel8;

@synthesize lblAddPic1;
@synthesize lblAddPic2;
@synthesize lblAddPic3;
@synthesize lblAddPic4;
@synthesize lblAddPic5;
@synthesize lblAddPic6;
@synthesize lblAddPic7;
@synthesize lblAddPic8;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        
        tilteBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        tilteBG.frame = CGRectMake(0, 0, frame.size.width, 40);
        tilteBG.backgroundColor = BACKCOLOR;
        [self addSubview:tilteBG];
        
        UIImage *imgsmallBack = [UIImage imageNamed:@"sendEmail_addPicbtn"];
        imgAddPic1 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width, 9+titltbar_height, Pic_Width, Pic_Width)];
        imgAddPic1.image = imgsmallBack;
        imgAddPic1.tag = 50;
        imgAddPic1.userInteractionEnabled = YES;
        [self addSubview:imgAddPic1];
        
        imgAddPic2 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 2 + Pic_Width, 9+titltbar_height, Pic_Width, Pic_Width)];
        imgAddPic2.image = imgsmallBack;
        imgAddPic2.tag = 51;
        imgAddPic2.userInteractionEnabled = YES;
        [self addSubview:imgAddPic2];
        
        imgAddPic3 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 3 + Pic_Width * 2, 9+titltbar_height, Pic_Width, Pic_Width)];
        imgAddPic3.image = imgsmallBack;
        imgAddPic3.tag = 52;
        imgAddPic3.userInteractionEnabled = YES;
        [self addSubview:imgAddPic3];
        
        imgAddPic4 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 4 + Pic_Width * 3, 9+titltbar_height, Pic_Width, Pic_Width)];
        imgAddPic4.image = imgsmallBack;
        imgAddPic4.tag = 53;
        imgAddPic4.userInteractionEnabled = YES;
        [self addSubview:imgAddPic4];
        
        imgAddPic5 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width, 9+titltbar_height+Pic_Space_height, Pic_Width, Pic_Width)];
        imgAddPic5.image = imgsmallBack;
        imgAddPic5.tag = 50;
        imgAddPic5.userInteractionEnabled = YES;
        [self addSubview:imgAddPic5];
        
        imgAddPic6 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 2 + Pic_Width, 9+titltbar_height+Pic_Space_height, Pic_Width, Pic_Width)];
        imgAddPic6.image = imgsmallBack;
        imgAddPic6.tag = 51;
        imgAddPic6.userInteractionEnabled = YES;
        [self addSubview:imgAddPic6];
        
        imgAddPic7 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 3 + Pic_Width * 2, 9+titltbar_height+Pic_Space_height, Pic_Width, Pic_Width)];
        imgAddPic7.image = imgsmallBack;
        imgAddPic7.tag = 52;
        imgAddPic7.userInteractionEnabled = YES;
        [self addSubview:imgAddPic7];
        
        imgAddPic8 = [[UIImageView alloc]initWithFrame:CGRectMake(Pic_Space_width * 4 + Pic_Width * 3, 9+titltbar_height+Pic_Space_height, Pic_Width, Pic_Width)];
        imgAddPic8.image = imgsmallBack;
        imgAddPic8.tag = 53;
        imgAddPic8.userInteractionEnabled = YES;
        [self addSubview:imgAddPic8];
        
        btnDel1 = [[UIButton alloc]initWithFrame:CGRectMake((Pic_Width + Pic_Space_width) * 1 - 15, 4+titltbar_height, 18, 18)];
        [btnDel1 setImage:[UIImage imageNamed:@"oa_select_off"] forState:UIControlStateNormal];
        [btnDel1 setHidden:YES];
        [self addSubview:btnDel1];
        
        btnDel2 = [[UIButton alloc]initWithFrame:CGRectMake((Pic_Width + Pic_Space_width) * 2 - 15, 4+titltbar_height, 18, 18)];
        [btnDel2 setImage:[UIImage imageNamed:@"oa_select_off"] forState:UIControlStateNormal];
        [btnDel2 setHidden:YES];
        [self addSubview:btnDel2];
        
        btnDel3 = [[UIButton alloc]initWithFrame:CGRectMake((Pic_Width + Pic_Space_width) * 3 - 15, 4+titltbar_height, 18, 18)];
        [btnDel3 setImage:[UIImage imageNamed:@"oa_select_off"] forState:UIControlStateNormal];
        [btnDel3 setHidden:YES];
        [self addSubview:btnDel3];
        
        btnDel4 = [[UIButton alloc]initWithFrame:CGRectMake((Pic_Width + Pic_Space_width) * 4 - 15, 4+titltbar_height, 18, 18)];
        [btnDel4 setImage:[UIImage imageNamed:@"oa_select_off"] forState:UIControlStateNormal];
        [btnDel4 setHidden:YES];
        [self addSubview:btnDel4];
        
        btnDel5 = [[UIButton alloc]initWithFrame:CGRectMake((Pic_Width + Pic_Space_width) * 5 - 15, 4+titltbar_height, 18, 18)];
        [btnDel5 setImage:[UIImage imageNamed:@"oa_select_off"] forState:UIControlStateNormal];
        [btnDel5 setHidden:YES];
        [self addSubview:btnDel5];
        
    }
    return self;
}


@end
