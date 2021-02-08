//
//  LBUnitChooseTableViewCell.m
//  dtgh
//
//  Created by 熊佳佳 on 16/4/25.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBUnitChooseTableViewCell.h"

@implementation LBUnitChooseTableViewCell
@synthesize rycheckBox;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        rycheckBox=[[QCheckBox alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-10, 44)];
        [rycheckBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rycheckBox.titleLabel.font=Font(14);
        [self addSubview:rycheckBox];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
