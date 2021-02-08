//
//  SdMkCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/2.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "SdMkCell.h"
@interface SdMkCell()
@property (nonatomic,strong)UILabel *titlelb;//标题
@property (nonatomic,strong)UILabel *subtitle;//副标题
@property (nonatomic,strong)UILabel *timelb;//时间
@property (nonatomic,strong)UIImageView *ggimg;
@property (nonatomic,strong)UILabel *onelb;
@property (nonatomic,strong)UILabel *bjbzlb;
@end


@implementation SdMkCell
@synthesize ggimg,titlelb,subtitle,timelb,onelb,bjbzlb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ggimg =[[UIImageView alloc]initWithFrame:CGRectMake(8,10, 15, 15)];
        [ggimg setImage:PNGIMAGE(@"fk")];
        [self.contentView addSubview:ggimg];
        
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(ggimg.right+5, 10, kScreenWidth-(ggimg.right+13), 22)];
        titlelb.font=Font(15);
        titlelb.numberOfLines=0;
        titlelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:titlelb];
        
        
        bjbzlb =[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.top, 60, 20)];
        bjbzlb.right=kScreenWidth-5;
        bjbzlb.font=Font(15);
        bjbzlb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:bjbzlb];
        
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
-(void)setSdmkModel:(SdmkModel *)sdmkModel
{
    _sdmkModel=sdmkModel;
    titlelb.text=sdmkModel.chrgwbt;
    CGSize titlsize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlsize.height>22?titlsize.height:22;
    timelb.top=subtitle.top=titlelb.bottom+5;
    onelb.top=timelb.bottom+5;
    self.contentView.height=onelb.bottom;
    subtitle.text=[NSString stringWithFormat:@"%@|%@",sdmkModel.chrzwr,sdmkModel.chrzwcs];
    timelb.text=[NSString stringWithFormat:@"%@",sdmkModel.dtmfssj.length>10?[sdmkModel.dtmfssj substringToIndex:10]:@""];
}
-(void)setDocmentModel:(DocMentModel *)docmentModel
{
    _docmentModel=docmentModel;
    titlelb.text=docmentModel.chrgwbt;
    
    if (self.isshow==YES&&docmentModel.strbjbz==0) {//个人公文
        titlelb.width=kScreenWidth-(ggimg.right+10)-60;
        bjbzlb.text=@"处理中";
        bjbzlb.textColor=[UIColor redColor];
    }
    else
    {
        titlelb.width=kScreenWidth-(ggimg.right+10);
        bjbzlb.text=@"";
        bjbzlb.textColor=[UIColor blackColor];
    }

    CGSize titlsize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlsize.height>22?titlsize.height:22;
    timelb.top=subtitle.top=titlelb.bottom+5;
    onelb.top=timelb.bottom+5;
    self.contentView.height=onelb.bottom;
    subtitle.text=[NSString stringWithFormat:@"%@[%@]%@号|%@",docmentModel.chrgwz,@(docmentModel.intgwnh),@(docmentModel.intgwqh),docmentModel.chrlwdwmc?:@""];
    
    
    if (docmentModel.chrlzlx!=nil) {
        if ([docmentModel.chrlzlx isEqualToString:@"收文"]) {
            timelb.text=[NSString stringWithFormat:@"%@",docmentModel.dtmfssj.length>16?[docmentModel.dtmfssj substringToIndex:16]:@""];
        }else
        {
            timelb.text=[NSString stringWithFormat:@"%@",docmentModel.dtmfssj.length>16?[docmentModel.dtmfssj substringToIndex:16]:@""];
        }
    }
    else
    {
         timelb.text=[NSString stringWithFormat:@"%@",docmentModel.dtmrq.length>16?[docmentModel.dtmrq substringToIndex:16]:@""];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
