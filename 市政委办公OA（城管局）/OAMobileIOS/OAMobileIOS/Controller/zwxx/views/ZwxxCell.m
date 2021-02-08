//
//  ZwxxCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ZwxxCell.h"

@interface ZwxxCell ()
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UILabel *timelb;
@end

@implementation ZwxxCell
@synthesize titlelb,namelb,timelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imgeview=[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 40, 40)];
        [imgeview setImage:PNGIMAGE(@"kw_icon")];
        [self.contentView addSubview:imgeview];
        
        titlelb=[[UILabel alloc]initWithFrame:CGRectMake(imgeview.right+5, 5, kScreenWidth-(imgeview.right+10), 23)];
        
        titlelb.font=Font(15);
        titlelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:titlelb];
        namelb =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, titlelb.bottom, titlelb.width/2.0, 20)];
        namelb.font=Font(13);
        namelb.textColor=[UIColor grayColor];
        [self.contentView addSubview:namelb];
        
        timelb=[[UILabel alloc]initWithFrame:CGRectMake(namelb.right, namelb.top, namelb.width, namelb.height)];
        timelb.font=Font(13);
        timelb.textColor=[UIColor grayColor];
        timelb.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:timelb];
        
        UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, imgeview.bottom+8, kScreenWidth, 0.5)];
        onelb.backgroundColor=UIColorFromRGB(0xc7c7cd);
        [self.contentView addSubview:onelb];
        self.contentView.height=onelb.bottom;
    }
    return self;
}
-(void)setZwxxItemdic:(NSDictionary *)zwxxItemdic
{
    _zwxxItemdic=zwxxItemdic;
    titlelb.text=zwxxItemdic[@"strkwbt"];
    namelb.text=zwxxItemdic[@"strdwjc"];
    timelb.text=zwxxItemdic[@"dtmbssj"]? [zwxxItemdic[@"dtmbssj"] substringToIndex:16]:@"";
}
-(void)setZwscItemdic:(NSDictionary *)zwscItemdic
{
    _zwscItemdic=zwscItemdic;
    titlelb.text=zwscItemdic[@"chrxxbt"];
    namelb.text=zwscItemdic[@"chrdwjc"];
    timelb.text=zwscItemdic[@"dtmcyrq"]? [zwscItemdic[@"dtmcyrq"] substringToIndex:16]:@"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
