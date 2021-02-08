//
//  ztOAAddressBookItemCell.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-15.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAAddressBookItemCell.h"

@implementation ztOAAddressBookItemCell
@synthesize name,companyName,checkedBtn,ABookCell,isChecked,cellIcon,upImg;
@synthesize delegate= _delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        cellIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 7, 30, 30)];
        cellIcon.backgroundColor = [UIColor clearColor];
        cellIcon.image = [UIImage imageNamed:@"treeIcon_02"];
        [self.contentView  addSubview:cellIcon];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, self.width-50-60, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:name];
        [name setUserInteractionEnabled:YES];
        UILongPressGestureRecognizer *tapGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGest:)];
        tapGest.minimumPressDuration = 1.0;
        [name addGestureRecognizer:tapGest];
        
        companyName = [[UILabel alloc] initWithFrame:CGRectMake(35, 30, self.width-50-60, 12)];
        companyName.backgroundColor = [UIColor clearColor];
        companyName.textAlignment = NSTextAlignmentLeft;
        companyName.textColor = [UIColor grayColor];
        companyName.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:companyName];
        [companyName addGestureRecognizer:tapGest];
        
        checkedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkedBtn addTarget:self action:@selector(checkedUp:) forControlEvents:UIControlEventTouchUpInside];
        checkedBtn.backgroundColor = [UIColor clearColor];
        checkedBtn.frame = CGRectMake(name.right+5, 2, 40, 40);
        [self.contentView addSubview:checkedBtn];
        
        upImg = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-15,12, 20, 20)];
        upImg.hidden=YES;
        upImg.right=kScreenWidth-15;
        [upImg setImage:[UIImage imageNamed:@"icon_arrow_down"]];
        [self.contentView addSubview:upImg];
        
        ABookCell = [[ztOAABModel alloc] init];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, self.width-20, 1)];
        line.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    if (checked) {
        [self.checkedBtn setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkedBtn setImage:[UIImage imageNamed:@"uncheck_icon"] forState:UIControlStateNormal];
    }
    self.isChecked = checked;
    self.ABookCell.isCheckedUp = checked;
}
- (void)checkedUp:(id)sender
{
    self.isChecked = !self.isChecked;
    if (self.isChecked ) {
        [self.checkedBtn setImage:[UIImage imageNamed:@"check_icon"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkedBtn setImage:[UIImage imageNamed:@"uncheck_icon"] forState:UIControlStateNormal];
    }
    self.ABookCell.isCheckedUp = self.isChecked ;
    
    NSString *str = @"";
    if (self.isChecked==YES) {
        str = @"yes";
    }
    else
    {
        str = @"no";
    }
    NSDictionary *bookDic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"ischecked",self.ABookCell.intrylsh,@"intrylsh",self.ABookCell.strxm,@"strxm",self.ABookCell.strdw,@"strdw",self.ABookCell.strzw,@"strzw",self.ABookCell.strbgdh,@"strbgdh",self.ABookCell.stryddh,@"stryddh",self.ABookCell.intdwpxh,@"intdwpxh",self.ABookCell.intrypxh,@"intrypxh",nil];
    postNWithInfos(@"CELLCHECHEDUP",nil, bookDic);
    
}
- (void)longPressGest:(UILongPressGestureRecognizer *)gesture
{
    if ([gesture state]==UIGestureRecognizerStateEnded) {
        if ([(id)_delegate respondsToSelector:@selector(longPressUpLateAction:)]) {
            [_delegate longPressUpLateAction:self.ABookCell];
        }
    }
    
    
}
@end
