//
//  ztOAEmailListCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-7-9.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAEmailListCell.h"

@implementation ztOAEmailListCell

@synthesize iconImg,noticeName,attachmentImg,noticeTime,readImg,readCount;
@synthesize detailInfo;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 24,24)];
        iconImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:iconImg];
         noticeName = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right+5, 10, self.width-iconImg.right-25, 20)];
        [noticeName setBackgroundColor:[UIColor clearColor]];
        [noticeName setTextAlignment:NSTextAlignmentLeft];
        [noticeName setTextColor:[UIColor blackColor]];
        [noticeName setText:@""];
        [noticeName setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:noticeName];
        
        attachmentImg = [[UIImageView alloc] initWithFrame:CGRectMake(noticeName.right, 10, 20,20)];
        attachmentImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:attachmentImg];
        
        noticeTime = [[UILabel alloc] initWithFrame:CGRectMake(self.width-110, 40, 100, 15)];
        [noticeTime setBackgroundColor:[UIColor clearColor]];
        [noticeTime setTextAlignment:NSTextAlignmentRight];
        [noticeTime setTextColor:[UIColor grayColor]];
        [noticeTime setText:@""];
        [noticeTime setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:noticeTime];
        
        detailInfo = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.right, 40, self.width-120-iconImg.right, 15)];
        [detailInfo setBackgroundColor:[UIColor clearColor]];
        [detailInfo setTextAlignment:NSTextAlignmentLeft];
        [detailInfo setTextColor:[UIColor grayColor]];
        [detailInfo setText:@""];
        [detailInfo setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:detailInfo];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(5, 60-1, self.width-10,1)];
        line.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:line];
    }
    return self;
}
- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
    [m_checkImageView setSize:CGSizeMake(29, 29)];
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}


- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if(editting==NO)
    {
        [m_checkImageView setHidden:YES];
    }
    else
    {
        [m_checkImageView setHidden:NO];
    }
	if (self.editing == editting)
	{
		return;
	}
	
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.backgroundView = [[UIView alloc] init];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Unselected"]];
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}
- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
		m_checkImageView.image = [UIImage imageNamed:@"Selected"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:0.5];
        } else{
            self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:0.5];
        }
	}
	else
	{
		m_checkImageView.image = [UIImage imageNamed:@"Unselected"];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            self.backgroundColor = [UIColor whiteColor];
        } else{
            self.backgroundView.backgroundColor = [UIColor whiteColor];
        }
		
	}
	m_checked = checked;
}

@end
