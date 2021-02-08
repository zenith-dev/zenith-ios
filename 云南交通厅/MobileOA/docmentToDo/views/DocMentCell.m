//
//  DocMentCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "DocMentCell.h"
@interface DocMentCell()
@property (nonatomic,strong)UIImageView *logImg;
@property (nonatomic,strong)UILabel *btlb;//标题
@property (nonatomic,strong)UILabel *bjbzlb;
@property (nonatomic,strong)UILabel *subtitllb;
@property (nonatomic,strong)UILabel *timelb;
@property (nonatomic,strong)UILabel *onelb;

@end

@implementation DocMentCell
@synthesize logImg,btlb,subtitllb,timelb,onelb,bjbzlb;

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
        btlb=[[UILabel alloc]initWithFrame:CGRectMake(logImg.right+5, logImg.top, kScreenWidth-(logImg.right+10), 20)];
        btlb.numberOfLines=0;
        btlb.font=Font(15);
        [self.contentView addSubview:btlb];
        bjbzlb =[[UILabel alloc]initWithFrame:CGRectMake(0, logImg.top, 60, 20)];
        bjbzlb.right=kScreenWidth-5;
        bjbzlb.font=Font(15);
        bjbzlb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:bjbzlb];
        
        
        subtitllb =[[UILabel alloc]initWithFrame:CGRectMake(btlb.left, btlb.bottom+5, btlb.width/2.0+40, 18)];
        subtitllb.textColor=[UIColor grayColor];
        subtitllb.font=Font(13);
        [self.contentView addSubview:subtitllb];
        
        timelb =[[UILabel alloc]initWithFrame:CGRectMake(subtitllb.right, subtitllb.top, subtitllb.width-80, subtitllb.height)];
        timelb.textColor=[UIColor grayColor];
        timelb.font=Font(13);
        timelb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:timelb];
        onelb =[[UILabel alloc]initWithFrame:CGRectMake(0, timelb.bottom+5, kScreenWidth, .5)];
        [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
        [self.contentView addSubview:onelb];
        self.contentView.height=onelb.bottom;
        logImg.centerY=self.contentView.height/2.0;
    }
    return self;
}
-(void)setDoctodoModel:(DocToDoModel *)doctodoModel
{
    _doctodoModel=doctodoModel;
//    bjbzlb.hidden=YES;
    if ([doctodoModel.chrlzlx isEqualToString:@"发文"]) {
        [logImg setImage:PNGIMAGE(@"sendDoc_Icon3")];
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"收文"])
    {
        [logImg setImage:PNGIMAGE(@"reciveDoc_Icon1")];
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"便函"])
    {
        [logImg setImage:PNGIMAGE(@"icon_bh")];
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"电话记录单"])
    {
        [logImg setImage:PNGIMAGE(@"icon_dh")];
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"签报件"])
    {
        [logImg setImage:PNGIMAGE(@"icon_qbj")];
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"信访"])
    {
        [logImg setImage:PNGIMAGE(@"icon_xf")];
    }else if([doctodoModel.chrlzlx isEqualToString:@"短信"]){
        [logImg setImage:PNGIMAGE(@"icon_dx")];
    }else if([doctodoModel.chrlzlx isEqualToString:@"督查反馈"]){
        [logImg setImage:PNGIMAGE(@"icon_dc")];
    }else if([doctodoModel.chrlzlx isEqualToString:@"政务热线签收"]){
        [logImg setImage:PNGIMAGE(@"icon_zwrx")];
    }else if([doctodoModel.chrlzlx isEqualToString:@"督查签收"]){
        [logImg setImage:PNGIMAGE(@"icon_dc")];
    }else if([doctodoModel.chrlzlx isEqualToString:@"政务热线答复"]){
        [logImg setImage:PNGIMAGE(@"icon_zwrx")];
    }
    if(![doctodoModel.chrhjcd isEqualToString:@"一般"]&&doctodoModel.chrhjcd.length!=0){
        bjbzlb.hidden=NO;
        bjbzlb.text=doctodoModel.chrhjcd;
        bjbzlb.textColor=[UIColor redColor];
    }else{
        bjbzlb.hidden=YES;
    }
    btlb.text = [NSString stringWithFormat:@"%@",doctodoModel.chrgwbt?:@""];
    CGSize titlsize=[btlb.text boundingRectWithSize:CGSizeMake(btlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:btlb.font} context:nil].size;
    btlb.height=titlsize.height>20?titlsize.height:20;
    timelb.top=subtitllb.top=btlb.bottom+5;
    if ([doctodoModel.chrckbz intValue]==0) {
        btlb.textColor=[UIColor blueColor];
    }else
    {
        btlb.textColor=[UIColor blackColor];
    }
    //发送时间
    timelb.text=[Tools sjFromStr:doctodoModel.dtmfssj];
    CGSize docFontSize=[timelb.text sizeWithAttributes:@{NSFontAttributeName:timelb.font}];
    timelb.left=kScreenWidth-docFontSize.width-5;
    timelb.width=docFontSize.width;
    subtitllb.top=btlb.bottom+5;
    subtitllb.width=kScreenWidth-logImg.right-5-(timelb.width+5);
    subtitllb.text =[NSString stringWithFormat:@"%@|%@",doctodoModel.chrfsrxm?:@"",doctodoModel.chrgzrwmc?:@""];
    if ([doctodoModel.chrgzrwmc containsString:@"批示"]) {
        subtitllb.textColor=[UIColor redColor];
    }else{
        subtitllb.textColor=[UIColor blueColor];
    }
    onelb.top=timelb.bottom+5;
    self.contentView.height=onelb.bottom;
}
-(void)setDoctodoModel2:(DocToDoModel *)doctodoModel2
{
    _doctodoModel2=doctodoModel2;
    bjbzlb.hidden=NO;
    if ([doctodoModel2.chrlzlx isEqualToString:@"发文"]) {
        [logImg setImage:PNGIMAGE(@"sendDoc_Icon3")];
    }
    else if([doctodoModel2.chrlzlx isEqualToString:@"收文"])
    {
        [logImg setImage:PNGIMAGE(@"reciveDoc_Icon1")];
    }
    else if([doctodoModel2.chrlzlx isEqualToString:@"便函"])
    {
        [logImg setImage:PNGIMAGE(@"icon_bh")];
    }
    else if([doctodoModel2.chrlzlx isEqualToString:@"电话记录单"])
    {
        [logImg setImage:PNGIMAGE(@"icon_dh")];
    }
    else if([doctodoModel2.chrlzlx isEqualToString:@"签报件"])
    {
        [logImg setImage:PNGIMAGE(@"icon_qbj")];
    }
    else if([doctodoModel2.chrlzlx isEqualToString:@"信访"])
    {
        [logImg setImage:PNGIMAGE(@"icon_xf")];
    }
    if (doctodoModel2.strbjbz==0) {
        btlb.width=kScreenWidth-(logImg.right+10)-60;
        bjbzlb.text=@"处理中";
        bjbzlb.textColor=[UIColor redColor];
    }else
    {
        btlb.width=kScreenWidth-(logImg.right+10);
        bjbzlb.text=@"";
        bjbzlb.textColor=[UIColor blackColor];
    }
    btlb.text = [NSString stringWithFormat:@"%@",doctodoModel2.chrgwbt?:@""];
    CGSize titlsize=[btlb.text boundingRectWithSize:CGSizeMake(btlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:btlb.font} context:nil].size;
    btlb.height=titlsize.height>20?titlsize.height:20;
    timelb.top=subtitllb.top=btlb.bottom+5;
    if ([doctodoModel2.chrhjcd  isEqualToString:@"加急"]) {
        btlb.textColor=[UIColor redColor];
    }else
    {
        btlb.textColor=[UIColor blackColor];
    }
    //发送时间
    timelb.text=[Tools sjFromStr1:doctodoModel2.dtmfssj];
    CGSize docFontSize=[timelb.text sizeWithAttributes:@{NSFontAttributeName:timelb.font}];
    timelb.left=kScreenWidth-docFontSize.width-5;
    timelb.width=docFontSize.width;
    subtitllb.top=btlb.bottom+5;
    subtitllb.width=kScreenWidth-logImg.right-5-(timelb.width+5);
    subtitllb.text =[NSString stringWithFormat:@"%@[%@]%@号",doctodoModel2.chrgwz,doctodoModel2.intgwnh?:@"",doctodoModel2.intgwqh?:@""];
    onelb.top=timelb.bottom+5;
    self.contentView.height=onelb.bottom;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
