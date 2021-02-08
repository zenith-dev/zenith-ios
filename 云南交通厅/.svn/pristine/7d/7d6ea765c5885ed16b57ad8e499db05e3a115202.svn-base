//
//  AddressBookCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/30.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "AddressBookCell.h"
@interface AddressBookCell()
@property (nonatomic,strong)UIImageView *cellIcon;
@property (nonatomic,strong)UILabel *namelb;
@property (nonatomic,strong)UIImageView *icondownImg;
@property (nonatomic,strong)UIButton *selectBtn;
@end
@implementation AddressBookCell
@synthesize cellIcon,namelb,icondownImg,selectBtn;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellIcon =[[UIImageView alloc]initWithFrame:CGRectMake(20,10, 24, 24)];
        [self.contentView addSubview:cellIcon];
        namelb =[[UILabel alloc]initWithFrame:CGRectMake(cellIcon.right+10, 5, kScreenWidth-(cellIcon.right+15+44), 34)];
        namelb.font=Font(16);
        namelb.numberOfLines=2;
        namelb.adjustsFontSizeToFitWidth=YES;
        [self.contentView addSubview:namelb];
        icondownImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 24, 24)];
        [icondownImg setImage:PNGIMAGE(@"icon_arrow_down")];
        icondownImg.left=kScreenWidth-34;
        [self.contentView addSubview:icondownImg];
        
        selectBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 2, 40, 40)];
        selectBtn.right=kScreenWidth-10;
        [selectBtn addTarget:self action:@selector(checkedUp:) forControlEvents:UIControlEventTouchUpInside];
         [selectBtn setImage:[UIImage imageNamed:@"uncheck_icon"] forState:UIControlStateNormal];
        [selectBtn setImage:PNGIMAGE(@"check_icon") forState:UIControlStateSelected];
        [self.contentView addSubview:selectBtn];
    }
    return self;
}
-(void)setAddUnitInfo:(AddUnitInfo *)addUnitInfo
{
    _addUnitInfo=addUnitInfo;
    [cellIcon setImage:PNGIMAGE(@"add_Group")];
    namelb.text=addUnitInfo.strdwjc;
    icondownImg.hidden=NO;
    selectBtn.hidden=YES;
}
-(void)setAddUserInfo:(AddUserInfo *)addUserInfo
{
    _addUserInfo=addUserInfo;
    [cellIcon setImage:PNGIMAGE(@"Add_person")];
    namelb.text=addUserInfo.strryxm;
    icondownImg.hidden=YES;
    selectBtn.hidden=NO;
    selectBtn.selected=addUserInfo.selectFlg;
}
-(void)checkedUp:(UIButton*)sender
{
    sender.selected=!sender.selected;
    _addUserInfo.selectFlg=sender.selected;
    if ([(id)_delegate respondsToSelector:@selector(longPressUpLateAction)]) {
        [_delegate longPressUpLateAction];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
