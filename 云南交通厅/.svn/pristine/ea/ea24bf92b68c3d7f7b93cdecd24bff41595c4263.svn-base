//
//  MsgUserCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/6.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "MsgUserCell.h"
@interface MsgUserCell()
@property (strong,nonatomic)UIImageView *headImg;
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UILabel *subnamelb;
@end
@implementation MsgUserCell
@synthesize headImg,namelb,subnamelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headImg =[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 40, 40)];
        [headImg setImage:PNGIMAGE(@"默认头像")];
        [self.contentView addSubview:headImg];
        namelb =[[UILabel alloc]initWithFrame:CGRectMake(headImg.right+10, headImg.top, kScreenWidth-(headImg.right+20), 20)];
        namelb.font=Font(16);
        namelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:namelb];
        subnamelb =[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, namelb.bottom, namelb.width, 20)];
        subnamelb.font=Font(14);
        subnamelb.textColor=[UIColor blackColor];
        [self.contentView addSubview:subnamelb];
        self.contentView.height=headImg.bottom+8;
    }
    return self;
}
-(void)setMsguserModel:(MsgUserModel *)msguserModel
{
    _msguserModel=msguserModel;
    namelb.text=msguserModel.strxm;
    subnamelb.text=msguserModel.strdw;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
