//
//  ztOAContactsListCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAContactsListCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation ztOAContactsListCell
@synthesize backImg,contactName,contactPhoneNum,selecteBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        backImg = [[UIImageView alloc] initWithFrame:self.frame];
        [backImg.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [backImg.layer setBorderWidth:1];
        
        backImg.backgroundColor = [UIColor whiteColor];
        self.backgroundView= backImg;
        
        selecteBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, (self.height-20)/2-2, 25, 25)];
        [selecteBtn setBackgroundImage:[UIImage imageNamed:@"contact_select_off"] forState:UIControlStateNormal];
        [selecteBtn setBackgroundImage:[UIImage imageNamed:@"contact_select_on"] forState:UIControlStateSelected];
        [self.contentView addSubview:selecteBtn];
        
        contactName =[[UIButton alloc] initWithFrame:CGRectMake(self.width/10+20, 0, self.width*3/10+1, self.height)];
        [contactName setTitle:@"" forState:UIControlStateNormal];
        
        [contactName.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [contactName.layer setBorderWidth:1];
        [contactName setBackgroundImage:[UIImage imageNamed:@"oa_selectbtn_on"] forState:UIControlStateHighlighted];
        [contactName.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [contactName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:contactName];
        
        contactPhoneNum =[[UIButton alloc] initWithFrame:CGRectMake(self.width*2/5+20, 0, self.width*3/5-20, self.height)];
        
        [contactPhoneNum.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [contactPhoneNum.layer setBorderWidth:1];
        contactPhoneNum.backgroundColor = [UIColor clearColor];
        [contactPhoneNum.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [contactPhoneNum setTitle:@"" forState:UIControlStateNormal];
        [contactPhoneNum setBackgroundImage:[UIImage imageNamed:@"oa_selectbtn_on"] forState:UIControlStateHighlighted];
        [contactPhoneNum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:contactPhoneNum];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
