//
//  LBCommonTableViewCell.m
//  dtgh
//
//  Created by 熊佳佳 on 16/6/12.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBCommonTableViewCell.h"

@implementation LBCommonTableViewCell
@synthesize commonlb,editbtn,delebtn;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        commonlb=[[UILabel alloc]initWithFrame:CGRectMake(8, 4, kScreenWidth-88, 36)];
        commonlb.font=Font(14);
        commonlb.numberOfLines=0;
        [self.contentView addSubview:commonlb];
        editbtn =[UIButton buttonWithType:UIButtonTypeSystem];
        [editbtn setTitle:@"编辑" forState:0];
        editbtn.frame=CGRectMake(commonlb.mj_w+commonlb.mj_x, 0, 40, 40);
        [editbtn bootstrapNoborderStyle:[UIColor whiteColor] titleColor:[UIColor blackColor] andbtnFont:Font(12)];
        [self addSubview:editbtn];
        delebtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [delebtn setTitle:@"删除" forState:0];
        delebtn.frame=CGRectMake(editbtn.mj_w+editbtn.mj_x, 0, 40, 40);
        [delebtn bootstrapNoborderStyle:[UIColor whiteColor] titleColor:[UIColor redColor] andbtnFont:Font(12)];
         [self addSubview:delebtn];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
