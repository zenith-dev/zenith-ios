//
//  LBStatisticsCell.m
//  dtgh
//
//  Created by 熊佳佳 on 18/3/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LBStatisticsCell.h"
@interface LBStatisticsCell()
@property (nonatomic,strong)UIImageView *logImg;
@property (nonatomic,strong)UILabel *xmlb;
@property (nonatomic,strong)UILabel *dwlb;
@property (nonatomic,strong)UILabel *zwlb;
@property (nonatomic,strong)UILabel *sjlb;
@property (nonatomic,strong)UILabel *onelb;
@end


@implementation LBStatisticsCell
@synthesize xmlb,logImg,dwlb,zwlb,sjlb,onelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        logImg =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self.contentView addSubview:logImg];
        xmlb =[[UILabel alloc]initWithFrame:CGRectMake(logImg.right+5, 5, kScreenWidth-(logImg.right+10), 21)];
        xmlb.font=Font(16);
        [self.contentView addSubview:xmlb];
        sjlb =[[UILabel alloc]initWithFrame:CGRectMake(xmlb.left, xmlb.bottom+5, xmlb.width, 21)];
        sjlb.font=Font(13);
        sjlb.textColor=[UIColor grayColor];
        [self.contentView addSubview:sjlb];
        onelb =[[UILabel alloc]initWithFrame:CGRectMake(0, sjlb.bottom+5, kScreenWidth, .5)];
        [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [self.contentView addSubview:onelb];
        self.contentView.height=onelb.bottom;
        logImg.centerY=self.contentView.height/2.0;
    }
    return self;
}
-(void)setStatisticsDic:(NSDictionary *)statisticsDic
{
    _statisticsDic=statisticsDic;
    [logImg setImage:PNGIMAGE(@"icon_table")];
    xmlb.text=[NSString stringWithFormat:@"姓名:%@  单位及职务:%@",statisticsDic[@"strryxm"],statisticsDic[@"strdwzw"]];
    sjlb.text=[NSString stringWithFormat:@"填表时间:%@",statisticsDic[@"dtmtbsj"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
