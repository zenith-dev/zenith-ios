//
//  CharCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/7.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "CharCell.h"
@interface CharCell ()
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UILabel *nrlb;
@property (nonatomic,strong)UILabel *timelb;
@property (nonatomic,strong)UILabel *namelb;

@end


@implementation CharCell
@synthesize headImg,nrlb,timelb,namelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *bstr=@"2016-11-04 11:07:23";
        CGSize bsize=[bstr sizeWithAttributes:@{NSFontAttributeName:Font(13)}];
        headImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 40, 40)];
        [headImg setImage:PNGIMAGE(@"默认头像")];
        [self.contentView addSubview:headImg];
        
        timelb=[[UILabel alloc]initWithFrame:CGRectMake(0, headImg.top, bsize.width+5,20)];
        timelb.font=Font(13);
        timelb.textAlignment=NSTextAlignmentRight;
        timelb.right=kScreenWidth-8;
        timelb.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:timelb];
        
        nrlb =[[UILabel alloc]initWithFrame:CGRectMake(headImg.right+8, headImg.top, kScreenWidth-(headImg.right+8+bsize.width+10), 20)];
        nrlb.font=Font(15);
        nrlb.numberOfLines=0;
        [self.contentView addSubview:nrlb];
        
        namelb =[[UILabel alloc]initWithFrame:CGRectMake(timelb.left, nrlb.bottom, timelb.width, 20)];
        namelb.font=Font(13);
        namelb.textAlignment=NSTextAlignmentRight;
        namelb.textColor=UIColorFromRGB(0x666666);
        [self.contentView addSubview:namelb];
        
        self.contentView.height=namelb.bottom+8;
    }
    return self;
}
-(void)setCharModel:(CharModel *)charModel
{
    _charModel=charModel;
    nrlb.text=charModel.strnr;
    CGSize nrsize=[nrlb.text boundingRectWithSize:CGSizeMake(nrlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:nrlb.font} context:nil].size;
    nrlb.height=nrsize.height>20?nrsize.height:20;
    timelb.text=charModel.dtmfssj;
    namelb.top=nrlb.bottom;
    namelb.text=charModel.strjsrxm;
    self.contentView.height=namelb.bottom+8;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
