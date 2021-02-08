//
//  ztOADocSearchBtnBarView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-12.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADocSearchBtnBarView.h"

@implementation ztOADocSearchBtnBarView
@synthesize typeLabel,yearLabel,filterLabel;
@synthesize typeSearchBtn,yearSearchBtn,filterSearchBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.height-20)/2, 40, 20)];
        typeLabel.textAlignment = NSTextAlignmentCenter;
        typeLabel.font = [UIFont systemFontOfSize:12.0f];
        typeLabel.text = @"类型：";
        typeLabel.textColor = [UIColor blackColor];
        typeLabel.backgroundColor = [UIColor clearColor];
        //[self addSubview:typeLabel];
        
        typeSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeSearchBtn.frame = CGRectMake(10, 0, 70+40, self.height);
        //[typeSearchBtn setBackgroundImage:[UIImage imageNamed:@"searchListBtn"] forState:UIControlStateNormal];
        typeSearchBtn.backgroundColor = [UIColor clearColor];
        [typeSearchBtn setTitle:@"全部类型" forState:UIControlStateNormal];
        [typeSearchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [typeSearchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:typeSearchBtn];
        UIImageView *upAndDownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(typeSearchBtn.width-40, 12, 20, 20)];
        [upAndDownIcon setImage:[UIImage imageNamed:@"selectIcon"]];
        [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
        [typeSearchBtn addSubview:upAndDownIcon];
        
        yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeSearchBtn.right+7, (self.height-20)/2, 40, 20)];
        yearLabel.textAlignment = NSTextAlignmentCenter;
        yearLabel.font = [UIFont systemFontOfSize:12.0f];
        yearLabel.text = @"年号：";
        yearLabel.textColor = [UIColor blackColor];
        yearLabel.backgroundColor = [UIColor clearColor];
        //[self addSubview:yearLabel];
        
        yearSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        yearSearchBtn.frame = CGRectMake(typeSearchBtn.right+7, 0, 70+40, self.height);
        //[yearSearchBtn setBackgroundImage:[UIImage imageNamed:@"searchListBtn"] forState:UIControlStateNormal];
        yearSearchBtn.backgroundColor = [UIColor clearColor];
        [yearSearchBtn setTitle:@"全部年号" forState:UIControlStateNormal];
        [yearSearchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [yearSearchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:yearSearchBtn];
        upAndDownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(yearSearchBtn.width-40, 12, 20, 20)];
        [upAndDownIcon setImage:[UIImage imageNamed:@"selectIcon"]];
        [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
        [yearSearchBtn addSubview:upAndDownIcon];
        
        filterLabel = [[UILabel alloc] initWithFrame:CGRectMake(yearSearchBtn.right+7, (self.height-20)/2, 40, 20)];
        filterLabel.textAlignment = NSTextAlignmentCenter;
        filterLabel.font = [UIFont systemFontOfSize:12.0f];
        filterLabel.text = @"筛选：";
        filterLabel.textColor = [UIColor blackColor];
        filterLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:filterLabel];
        
        filterSearchBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        filterSearchBtn.frame = CGRectMake(filterLabel.right, (self.height-30)/2, 30, 30);
        filterSearchBtn.backgroundColor = [UIColor clearColor];
        [filterSearchBtn setBackgroundImage:[UIImage imageNamed:@"filterBtnImage"] forState:UIControlStateNormal];
        [self addSubview:filterSearchBtn];
        
    }
    return self;
}


@end
