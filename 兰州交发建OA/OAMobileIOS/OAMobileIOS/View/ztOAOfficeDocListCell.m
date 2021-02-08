//
//  ztOAOfficeDocListCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-1-17.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAOfficeDocListCell.h"
#import "ztOASmartTime.h"
@implementation ztOAOfficeDocListCell
#pragma mark--------------Getter-----------
-(UIImageView*)iconImg
{
    if (!_iconImg) {
        _iconImg=[[UIImageView alloc]init];
    }
    return _iconImg;
}
-(UILabel*)docName
{
    if (!_docName) {
        _docName=[[UILabel alloc]init];
        _docName.numberOfLines=0;
        _docName.font=Font(15);
        [_docName setBackgroundColor:[UIColor clearColor]];
        _docName.textColor=[UIColor blackColor];
    }
    return _docName;
}
-(UILabel*)detailInfo
{
    if (!_detailInfo) {
        _detailInfo=[[UILabel alloc]init];
        _detailInfo.font=Font(14);
        _detailInfo.backgroundColor=[UIColor clearColor];
        _detailInfo.textColor=[UIColor grayColor];
        _detailInfo.adjustsFontSizeToFitWidth=YES;
    }
    return _detailInfo;
}
-(UILabel*)docSendTime
{
    if (!_docSendTime) {
        _docSendTime=[[UILabel alloc]init];
        _docSendTime.font=Font(12);
        [_docSendTime setBackgroundColor:[UIColor clearColor]];
        [_docSendTime setTextAlignment:NSTextAlignmentRight];
        [_docSendTime setTextColor:[UIColor grayColor]];
    }
    return _docSendTime;
}
-(UILabel*)line
{
    if (!_line) {
        _line=[[UILabel alloc]init];
        _line.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    }
    return _line;
}
-(void)setModedic:(NSDictionary *)modedic
{
    _modedic=modedic;
    self.iconImg.frame=CGRectMake(5, 0, 30, 30);
    if ([[modedic objectForKey:@"chrlzlx"] isEqualToString:@"发文"]) {
        [self.iconImg setImage:PNGIMAGE(@"sendDoc_Icon3")];
    }
    else
    {
        [self.iconImg setImage:PNGIMAGE(@"reciveDoc_Icon1")];
    }
    self.docName.frame = CGRectMake(self.iconImg.right+5, 2, kScreenWidth-self.iconImg.right-5, 20);
    self.docName.text = [NSString stringWithFormat:@"%@",[modedic objectForKey:@"chrgwbt"]?:@""];
    if ([[modedic objectForKey:@"chrhjcd"] isEqualToString:@"加急"]) {
        self.docName.textColor=[UIColor redColor];
    }
    //发送时间
    self.docSendTime.frame = CGRectMake(kScreenWidth-120-10+40, YH(self.docName)+5, 80, 15);
    self. docSendTime.text=[ztOASmartTime sjFromStr:[modedic objectForKey:@"dtmfssj"]];
    CGSize docFontSize=[self.docSendTime.text sizeWithAttributes:@{NSFontAttributeName:Font(12)}];
    self.docSendTime.frame=CGRectMake(kScreenWidth-docFontSize.width-5, Y(self.docSendTime), docFontSize.width, H(self.docSendTime));
    self.detailInfo.frame =CGRectMake(self.iconImg.right+5, YH(self.docName)+5, self.width-self.iconImg.right-5-(docFontSize.width+5), 15);
    if ([self.i_type isEqualToString:@"1"]) {
        self.detailInfo.text =[NSString stringWithFormat:@"%@|%@",[modedic objectForKey:@"chrfsrxm"],[modedic objectForKey:@"chrgzrwmc"]?:@""];
    }
    else if([self.i_type isEqualToString:@"5"])
    {
        self.detailInfo.text = [NSString stringWithFormat:@"%@[%@]%@号|%@",[modedic objectForKey:@"chrgwz"],[modedic objectForKey:@"intgwnh"],[modedic objectForKey:@"intgwqh"],[modedic objectForKey:@"chrlwdwmc"]?:@""];
    }

    self.line.frame=CGRectMake(0, YH(self.docSendTime)+5, kScreenWidth, 0.5);
    self.frame=CGRectMake(X(self), Y(self), kScreenWidth, YH(self.line));
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib
{
    [self addSubview:self.docName];
    [self addSubview:self.docSendTime];
    [self addSubview:self.detailInfo];
    [self addSubview:self.iconImg];
    [self addSubview:self.line];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
