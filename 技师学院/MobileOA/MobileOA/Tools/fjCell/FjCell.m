//
//  FjCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "FjCell.h"
@interface FjCell()
@property (nonatomic,strong)UIImageView *logoImg;//附件图片
@property (nonatomic,strong)UILabel *fjNamelb;//附件名称

@end
@implementation FjCell
@synthesize logoImg,fjNamelb,gglb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgImgeview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, kScreenWidth-20, 44-4)];
        bgImgeview.backgroundColor = RGBCOLOR(234, 234, 234);
        [self.contentView addSubview:bgImgeview];
        logoImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];
        [self.contentView addSubview:logoImg];
        fjNamelb =[[UILabel alloc]initWithFrame:CGRectMake(logoImg.right+5, 2, bgImgeview.width-(logoImg.right+10), 40)];
        fjNamelb.numberOfLines=2;
        fjNamelb.font=Font(13);
        [self.contentView addSubview:fjNamelb];
        

        gglb =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        gglb.hidden=YES;
        gglb.imageView.clipsToBounds=YES;
        gglb.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [gglb setImage:PNGIMAGE(@"db_gg") forState:UIControlStateNormal];
        [self addSubview:gglb];
        gglb.centerY=44/2;
    }
    return self;
}
-(void)setTzDic:(NSDictionary *)tzDic
{
    _tzDic=tzDic;
    NSString *fileNameStr =@"";
    fileNameStr =  [NSString stringWithFormat:@"%@", [tzDic objectForKey:@"strfjmc"] ];
    NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
    NSString *fileType = [array lastObject];
    NSString *iconImgName= @"";
    if ([fileType isEqualToString:@"doc"]||[fileType isEqualToString:@"docx"]) {
        iconImgName = @"file_ic_word1";
    }
    else if ([fileType isEqualToString:@"txt"]){
        iconImgName = @"file_ic_txt";
    }
    else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
        iconImgName = @"file_ic_img";
    }
    else if ([fileType isEqualToString:@"xls"]||[fileType isEqualToString:@"xlsx"]){
        iconImgName = @"file_ic_xls1";
    }
    else if ([fileType isEqualToString:@"pdf"]){
        iconImgName = @"file_ic_pdf";
    }
    else {
        iconImgName = @"file_ic_x";
    }
    fjNamelb.text = fileNameStr;
    [logoImg setImage:[UIImage imageNamed:iconImgName]];
}
-(void)setZwgDic:(NSDictionary *)zwgDic
{
    _zwgDic=zwgDic;
    if ([zwgDic[@"fjlx"] isEqualToString:@"正文稿"]&&self.ctrone==YES) {
        gglb.hidden=YES;
        fjNamelb.width=  kScreenWidth-20-(logoImg.right+10)-50;
        gglb.left=fjNamelb.right;
    }
    else
    {
        fjNamelb.width= kScreenWidth-20-(logoImg.right+10);
        gglb.hidden=YES;
        gglb.left=fjNamelb.right;
    }
    NSString *fileNameStr =@"";
    fileNameStr =  [NSString stringWithFormat:@"%@", [zwgDic objectForKey:@"strfjmc"] ];
    NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
    NSString *fileType = [array lastObject];
    NSString *iconImgName= @"";
    if ([fileType isEqualToString:@"doc"]||[fileType isEqualToString:@"docx"]) {
        iconImgName = @"file_ic_word1";
    }
    else if ([fileType isEqualToString:@"txt"]){
        iconImgName = @"file_ic_txt";
    }
    else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
        iconImgName = @"file_ic_img";
    }
    else if ([fileType isEqualToString:@"xls"]||[fileType isEqualToString:@"xlsx"]){
        iconImgName = @"file_ic_xls1";
    }
    else if ([fileType isEqualToString:@"pdf"]){
        iconImgName = @"file_ic_pdf";
    }
    else {
        iconImgName = @"file_ic_x";
    }
    fjNamelb.text =[NSString stringWithFormat:@"%@(%@)",fileNameStr,zwgDic[@"fjlx"]];
    [logoImg setImage:[UIImage imageNamed:iconImgName]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
