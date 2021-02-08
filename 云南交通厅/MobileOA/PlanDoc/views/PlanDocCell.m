//
//  PlanDocCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/4/12.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "PlanDocCell.h"
@interface PlanDocCell()
@property (nonatomic,strong)UILabel *titlelb;//标题
@property (nonatomic,strong)UIImageView *logoimg;
@property (nonatomic,strong)UILabel *hline;
@end
@implementation PlanDocCell
@synthesize titlelb,logoimg,hline;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(8, 8, kScreenWidth-16, 28)];
        titlelb.font=Font(16);
        [self.contentView addSubview:titlelb];
       
        hline =[[UILabel alloc]initWithFrame:CGRectMake(2, 0, 2, 44)];
        [hline setBackgroundColor:UIColorFromRGB(0x2daae8)];
        [self.contentView addSubview:hline];
        self.contentView.height=44;
        logoimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self.contentView addSubview:logoimg];
    }
    return self;
}
-(void)setPlanmodel:(PlanModel *)planmodel
{
    _planmodel=planmodel;
    titlelb.text=planmodel.strmlmc;
    logoimg.left=planmodel.nodeint*10+8;
    if (planmodel.childlst.count!=0||planmodel.nodeint==0) {
        hline.hidden=YES;
        [logoimg setImage:PNGIMAGE(@"glp")];
        logoimg.width=logoimg.height=24;
        titlelb.left=logoimg.right+5;
    }
    else
    {
        [logoimg setImage:PNGIMAGE(@"dians")];
        logoimg.width=logoimg.height=8;
        hline.hidden=NO;
        titlelb.left=logoimg.right+5+16;
    }
    hline.centerX=logoimg.centerX;
    
    titlelb.width=kScreenWidth-(titlelb.left);
    logoimg.centerY=titlelb.centerY;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
