//
//  ztggOATableViewCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/3.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztggOATableViewCell.h"
#import "ztOASmartTime.h"
@implementation ztggOATableViewCell
#pragma mark------------Getter-----------
-(UIImageView*)ggimg
{
    if (!_ggimg) {
        _ggimg=[[UIImageView alloc]init];
    }
    return _ggimg;
}
-(UILabel*)btlb
{
    if (!_btlb) {
        _btlb=[[UILabel alloc]init];
        _btlb.font=Font(15);
        _btlb.numberOfLines=0;
        _btlb.textColor=[UIColor blackColor];
    }
    return _btlb;
}
-(UILabel*)timelb
{
    if (!_timelb) {
        _timelb=[[UILabel alloc]init];
        _timelb.font=Font(13);
        _timelb.textColor=[UIColor grayColor];
        _timelb.textAlignment=NSTextAlignmentRight;
    }
    return _timelb;
}
-(UILabel*)onelinelb
{
    if (!_onelinelb) {
        _onelinelb=[[UILabel alloc]init];
        [_onelinelb setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
    }
    return _onelinelb;
}

- (void)awakeFromNib {
    [self addSubview:self.ggimg];
    [self addSubview:self.btlb];
    [self addSubview:self.timelb];
    [self addSubview:self.onelinelb];
    // Initialization code
}
-(void)setGgdic:(NSDictionary *)ggdic
{
    _ggdic=ggdic;
    self.ggimg.frame=CGRectMake(5, 5, 22, 22);
    [self.ggimg setImage:PNGIMAGE(@"icon_tz")];
    float btw=self.width-self.ggimg.right-5;
    NSString *btstr=[NSString stringWithFormat:@"%@",[ggdic objectForKey:@"strggbt"]];
    CGSize fontsize =[btstr sizeWithFont:Font(15) constrainedToSize:CGSizeMake(btw, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    self.btlb.text=btstr;
    if ([[ggdic objectForKey:@"strcdbz"]intValue]==0) {
        self.btlb.textColor=[UIColor blueColor];
    }
    else
    {
        self.btlb.textColor=[UIColor blackColor];
    }
    self.btlb.frame=CGRectMake(self.ggimg.right+5, self.ggimg.top, btw, self.ggimg.height>fontsize.height?self.ggimg.height:fontsize.height);
    self.timelb.frame=CGRectMake(5, self.btlb.bottom, self.width-10, 18);
    self.timelb.text=[ztOASmartTime sjFromStr:[ggdic objectForKey:@"dtmfbrq"]];
    self.onelinelb.frame=CGRectMake(0, self.timelb.bottom, self.width, 0.5);
    self.frame=CGRectMake(X(self), Y(self), self.width, self.onelinelb.bottom);    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
