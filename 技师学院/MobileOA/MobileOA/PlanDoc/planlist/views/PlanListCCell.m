//
//  PlanListCCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "PlanListCCell.h"
@interface PlanListCCell()
@property (nonatomic,strong)UILabel *titlelb;//标题
@property (nonatomic,strong)UILabel *subtitle;//副标题
@property (nonatomic,strong)UILabel *timelb;//时间
@property (nonatomic,strong)UIImageView *ggimg;
@property (nonatomic,strong)UILabel *onelb;
@end

@implementation PlanListCCell
@synthesize titlelb,subtitle,timelb,ggimg,onelb;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ggimg =[[UIImageView alloc]initWithFrame:CGRectMake(8,10, 32, 32)];
        [ggimg setImage:PNGIMAGE(@"kw_icon")];
        [self.contentView addSubview:ggimg];
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(ggimg.right+5, 10, kScreenWidth-(ggimg.right+13), 22)];
        titlelb.font=Font(15);
        titlelb.numberOfLines=0;
        titlelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:titlelb];
        ggimg.centerY=titlelb.centerY;
        
        subtitle =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, titlelb.bottom+5, titlelb.width/2.0+40, 18)];
        subtitle.textColor=[UIColor grayColor];
        subtitle.font=Font(13);
        [self.contentView addSubview:subtitle];
        
        timelb =[[UILabel alloc]initWithFrame:CGRectMake(subtitle.right, subtitle.top, subtitle.width-80, subtitle.height)];
        timelb.textColor=[UIColor grayColor];
        timelb.font=Font(13);
        timelb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:timelb];
        
        onelb =[[UILabel alloc]initWithFrame:CGRectMake(0, timelb.bottom+5, kScreenWidth, .5)];
        [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [self.contentView addSubview:onelb];
        self.contentView.height=onelb.bottom;
    }
    return self;
}
-(void)setPlanmodel:(PlanListDocModel *)planmodel
{
    _planmodel=planmodel;
    titlelb.text=planmodel.strwdbt;
    CGSize titlsize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlsize.height>22?titlsize.height:22;
    timelb.top=subtitle.top=titlelb.bottom+5;
    onelb.top=timelb.bottom+5;
    self.contentView.height=onelb.bottom;
    subtitle.text=[NSString stringWithFormat:@"%@|%@",planmodel.strdjrxm,planmodel.strdwjc];
    timelb.text=[NSString stringWithFormat:@"%@",planmodel.dtmfbrq.length>10?[planmodel.dtmfbrq substringToIndex:10]:@""];
    ggimg.centerY=self.contentView.height/2.0;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
