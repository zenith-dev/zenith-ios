//
//  ztOAWcTableViewCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOAWcTableViewCell.h"

@implementation ztOAWcTableViewCell
#pragma mark---------------Getter--------------
-(UILabel*)weeklb
{
    if (!_weeklb) {
        _weeklb=[[UILabel alloc]init];
        _weeklb.font=Font(16);
        _weeklb.textColor=[UIColor blackColor];
    }
    return _weeklb;
}
-(UILabel*)rqlb
{
    if (!_rqlb) {
        _rqlb=[[UILabel alloc]init];
        _rqlb.font=Font(13);
        _rqlb.textColor=[UIColor grayColor];
    }
    return _rqlb;
}
-(UILabel*)onelinelb
{
    if (!_onelinelb) {
        _onelinelb =[[UILabel alloc]init];
        [_onelinelb setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
    }
    return _onelinelb;
}
-(UIImageView*)icon_arrowview
{
    if (!_icon_arrowview) {
        _icon_arrowview=[[UIImageView alloc]init];
        _icon_arrowview.frame=CGRectMake(self.width-30, (40-24)/2.0, 24, 24);
    }
    return _icon_arrowview;
}

-(UIButton*)addrcBtn
{
    if (!_addrcBtn) {
        _addrcBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addrcBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _addrcBtn.titleLabel.font=Font(14);
        [_addrcBtn setTitle:@"新增日程" forState:UIControlStateNormal];
    }
    return _addrcBtn;
}
- (void)awakeFromNib {
    // Initialization code
    self.weeklb.frame=CGRectMake(5, 5, 60, 25);
    [self addSubview:self.weeklb];
    self.rqlb.frame=CGRectMake(self.weeklb.left, self.weeklb.bottom, 120, 20);
    [self addSubview:self.rqlb];
    [self addSubview:self.addrcBtn];
    [self addSubview:self.icon_arrowview];
    [self addSubview:self.onelinelb];
}
-(void)setWeekdic:(NSDictionary *)weekdic
{
    _weekdic=weekdic;
//    self.weeklb.text=[weekdic objectForKey:@"weekstr"];
//    self.rqlb.text=[weekdic objectForKey:@"rqstr"];
//    
//    if (self.dataary.count>0) {
//        self.addrcBtn.frame=CGRectMake(self.width-30-75, self.icon_arrowview.top, 70, 24);
//        self.icon_arrowview.hidden=NO;
//    }
//    else
//    {
//         self.addrcBtn.frame=CGRectMake(self.width-75, self.icon_arrowview.top, 70, 24);
//        self.icon_arrowview.hidden=YES;
//    }
//    [self.addrcBtn bootStrapBG:MF_ColorFromRGB(235, 235, 235) forState:UIControlStateHighlighted];
//    float hightcell=self.rqlb.bottom;
//    if ([[weekdic objectForKey:@"isopen"] boolValue]) {
//        [self.icon_arrowview setImage:PNGIMAGE(@"icon_arrow_down")];
//         
//
//    }
//    else
//    {
//        [self.icon_arrowview setImage:PNGIMAGE(@"icon_arrow_up")];
//    }
//    self.onelinelb.frame=CGRectMake(0, hightcell+5, self.width, 1);
//    self.frame=CGRectMake(X(self), Y(self), self.width, YH(self.onelinelb));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
