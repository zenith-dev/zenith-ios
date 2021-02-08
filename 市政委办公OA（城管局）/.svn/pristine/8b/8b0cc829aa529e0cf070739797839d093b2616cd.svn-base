//
//  ztOASendEmailFjDetailView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-24.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASendEmailFjDetailView.h"

@implementation ztOASendEmailFjDetailView
@synthesize buttonTitleBar,getPhotosBtn,getCameraBtn,fjTable;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        buttonTitleBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        buttonTitleBar.frame = CGRectMake(0, 0, frame.size.width, 40);
        buttonTitleBar.backgroundColor = BACKCOLOR;
        [self addSubview:buttonTitleBar];
        
        getPhotosBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        getPhotosBtn.frame = CGRectMake(50, 5, 35, 30);
        [getPhotosBtn setImage:[UIImage imageNamed:@"picture_off"] forState:UIControlStateNormal];
        [getPhotosBtn setImage:[UIImage imageNamed:@"picture_on"] forState:UIControlStateHighlighted];
        getPhotosBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:getPhotosBtn];
        
        getCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        getCameraBtn.frame = CGRectMake(50*2+40, 5, 35, 30);
        [getCameraBtn setImage:[UIImage imageNamed:@"camera_Off"] forState:UIControlStateNormal];
        [getCameraBtn setImage:[UIImage imageNamed:@"camera_On"] forState:UIControlStateHighlighted];
        getCameraBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:getCameraBtn];
        
        fjTable = [[UITableView alloc]initWithFrame:CGRectMake(0, buttonTitleBar.bottom, frame.size.width,frame.size.height-buttonTitleBar.bottom) style:UITableViewStylePlain];
        fjTable.backgroundColor = [UIColor clearColor];
        [self addSubview:fjTable];
        
        
    }
    return self;
}

@end
