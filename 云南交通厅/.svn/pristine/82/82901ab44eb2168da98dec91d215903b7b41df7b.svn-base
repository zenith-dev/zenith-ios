//
//  LbzbCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/2.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "LbzbCell.h"
#import "GTMBase64.h"
@interface LbzbCell ()
@property (nonatomic,strong)UILabel *buleLinelb;
@property (nonatomic,strong)UIImageView *circleImg;
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UILabel *connetlb;//
@property (nonatomic,strong)UILabel *subnamelb;//
@property (nonatomic,strong)UIImageView *qpimgview;
@property (nonatomic,strong)UILabel *onellb;
@property (nonatomic,strong)UILabel *stetlb;//状态

@end


@implementation LbzbCell
@synthesize buleLinelb,circleImg,namelb,connetlb,subnamelb,onellb,qpimgview,stetlb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        buleLinelb =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 2, 44)];
        [buleLinelb setBackgroundColor:UIColorFromRGB(0x3b79ea)];
        [self.contentView addSubview:buleLinelb];
        circleImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [circleImg setImage:PNGIMAGE(@"process_pointImg")];
        [self.contentView addSubview:circleImg];
        circleImg.centerX=buleLinelb.centerX;
        
        namelb =[[UILabel alloc]initWithFrame:CGRectMake(circleImg.right+10, 10, kScreenWidth-(circleImg.right+10), 21)];
        namelb.font=Font(14);
        namelb.textColor=[UIColor grayColor];
        [self.contentView addSubview:namelb];
        circleImg.centerY=namelb.centerY;
        
        stetlb =[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, namelb.bottom, namelb.width, 20)];
        stetlb.font=Font(14);
        stetlb.textColor=[UIColor blueColor];
        [self.contentView addSubview:stetlb];
        
        
        
        connetlb =[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, stetlb.bottom+5, namelb.width, 36)];
        connetlb.font=BoldFont(16);
        connetlb.textColor=[UIColor blueColor];
        connetlb.numberOfLines=0;
        [self.contentView addSubview:connetlb];
        
        qpimgview =[[UIImageView alloc]initWithFrame:CGRectMake(connetlb.left, connetlb.bottom+5, namelb.width, 80)];
        qpimgview.clipsToBounds=YES;
        qpimgview.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:qpimgview];
        
        subnamelb =[[UILabel alloc]initWithFrame:CGRectMake(connetlb.left, qpimgview.bottom+5, connetlb.width-10, 21)];
        subnamelb.font=Font(14);
        subnamelb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:subnamelb];
        
        onellb =[[UILabel alloc]initWithFrame:CGRectMake(subnamelb.left, subnamelb.bottom+5, kScreenWidth-subnamelb.left, 0.5)];
        [onellb setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:onellb];
        self.contentView.height=onellb.bottom;
    }
    return self;

}
-(void)setLbzbdic:(NSDictionary *)lbzbdic
{
    _lbzbdic=lbzbdic;
    namelb.text=[NSString stringWithFormat:@"%@ %@ %@",[lbzbdic[@"strczrxm"] length]==0?lbzbdic[@"strzrrmc"]:lbzbdic[@"strczrxm"],[lbzbdic[@"dtmfssj"] length]>16?[lbzbdic[@"dtmfssj"] substringWithRange:NSMakeRange(5, 11)]:@"",lbzbdic[@"strgzrwmc"]];
    stetlb.height=0;
    connetlb.height=stetlb.bottom;
    if ([lbzbdic[@"clbz"] isKindOfClass:[NSString class]]||lbzbdic[@"clbz"]==nil) {
        if ([lbzbdic[@"clbz"] intValue]==1||lbzbdic[@"clbz"]==nil||[lbzbdic[@"clbz"] isEqualToString:@""]) {
            connetlb.text=[NSString stringWithFormat:@"%@",lbzbdic[@"stryjnr"]];
             [connetlb setTextColor:[UIColor blackColor]];
        }else
        {
            connetlb.text=@"处理中...";
            [connetlb setTextColor:[UIColor redColor]];
        }
    }else
    {
        if ([lbzbdic[@"clbz"] intValue]==1||lbzbdic[@"clbz"]==nil) {
            connetlb.text=[NSString stringWithFormat:@"%@",lbzbdic[@"stryjnr"]];
              [connetlb setTextColor:[UIColor blackColor]];
        }else
        {
            [connetlb setTextColor:[UIColor redColor]];
            connetlb.text=@"处理中...";
        }
    }
    if ([connetlb.text length]>0) {
        CGSize connetsize=[connetlb.text boundingRectWithSize:CGSizeMake(connetlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:connetlb.font} context:nil].size;
        connetlb.height=connetsize.height>36?connetsize.height:36;
    }
    qpimgview.top=connetlb.bottom+5;
    if ([lbzbdic[@"imgtz"] length]>0) {
        NSData *filecontent = [GTMBase64 decodeString:lbzbdic[@"imgtz"]];
        UIImage *image = [UIImage imageWithData:filecontent];
        [qpimgview setImage:image];
        qpimgview.height=ScaleBI(80);
        qpimgview.userInteractionEnabled=YES;
        [qpimgview bk_whenTapped:^{
            //1.创建图片浏览器
            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
            //传递数据给浏览器
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = image;
            photo.srcImageView = qpimgview; //设置来源哪一个UIImageView
            brower.photos = @[photo];
            //3.设置默认显示的图片索引
            brower.currentPhotoIndex = 0;
            //4.显示浏览器
            [brower show];
        }];
    }
    else
    {
        qpimgview.height=0;
    }
    subnamelb.top=qpimgview.bottom+5;
    subnamelb.text=[NSString stringWithFormat:@"%@ %@",lbzbdic[@"strczrxm"],[lbzbdic[@"dtmbjsj"] length]>16?[lbzbdic[@"dtmbjsj"] substringWithRange:NSMakeRange(5, 11)]:@""];
    onellb.top=subnamelb.bottom+5;
    self.contentView.height=onellb.bottom;
    buleLinelb.height=self.contentView.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
