//
//  NoticeCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/28.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "NoticeCell.h"
@interface NoticeCell()
@property (nonatomic,strong)UIImageView *ggimg;
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *jclb;
@property (nonatomic,strong)UILabel *sjlb;
@property (nonatomic,strong)UILabel *onelb;
@end
@implementation NoticeCell
@synthesize ggimg,titlelb,jclb,sjlb,onelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ggimg =[[UIImageView alloc]initWithFrame:CGRectMake(5,10, 22, 22)];
        [ggimg setImage:PNGIMAGE(@"icon_tz")];
        [self.contentView addSubview:ggimg];
        
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(ggimg.right+5, 10, kScreenWidth-(ggimg.right+10), 22)];
        titlelb.font=Font(15);
        titlelb.numberOfLines=0;
        titlelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:titlelb];
        
        jclb =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, titlelb.bottom+5, titlelb.width/2.0+40, 18)];
        jclb.textColor=[UIColor grayColor];
        jclb.font=Font(13);
        [self.contentView addSubview:jclb];
        
        sjlb =[[UILabel alloc]initWithFrame:CGRectMake(jclb.right, jclb.top, jclb.width-80, jclb.height)];
        sjlb.textColor=[UIColor grayColor];
        sjlb.font=Font(13);
        sjlb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:sjlb];
        onelb =[[UILabel alloc]initWithFrame:CGRectMake(0, sjlb.bottom+5, kScreenWidth, .5)];
        [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [self.contentView addSubview:onelb];
        self.contentView.height=onelb.bottom;
    }
    return self;
}
-(void)setNoticeModel:(NoticeModel *)noticeModel
{
    _noticeModel=noticeModel;
    titlelb.text=[NSString stringWithFormat:@"%@",noticeModel.strggbt];
    if (noticeModel.strcdbz==0) {
        titlelb.textColor=[UIColor blueColor];
    }else{
        titlelb.textColor=[UIColor blackColor];
    }
    jclb.text=[NSString stringWithFormat:@"%@|%@",noticeModel.strryxm,noticeModel.strdwjc];
    sjlb.text=[NSString stringWithFormat:@"%@",noticeModel.dtmfbrq.length<16?@"":[noticeModel.dtmfbrq substringToIndex:16]];
}
-(void)setZtModel:(TzModel *)ztModel
{
    _ztModel=ztModel;
    titlelb.text=[NSString stringWithFormat:@"%@",ztModel.strtzbt];
    jclb.text=[NSString stringWithFormat:@"%@|%@",ztModel.strryxm,ztModel.strdwjc];
    if (ztModel.strckbz==0) {
        titlelb.textColor=[UIColor blueColor];
    }else{
        titlelb.textColor=[UIColor blackColor];
    }
    sjlb.text=[NSString stringWithFormat:@"%@",ztModel.dtmdjsj.length<16?@"":[ztModel.dtmdjsj substringToIndex:16]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
