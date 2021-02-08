
//
//  ThePortalCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ThePortalCell.h"
@interface ThePortalCell()
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *timelb;
@end


@implementation ThePortalCell
@synthesize titlelb,timelb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titlelb =[[UILabel alloc]initWithFrame:CGRectMake(8, 5, kScreenWidth-10, 20)];
        titlelb.font=Font(15);
        titlelb.numberOfLines=0;
        [self.contentView addSubview:titlelb];
        timelb =[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left, titlelb.bottom+8, titlelb.width, 20)];
        timelb.font=Font(13);
        timelb.textColor=[UIColor grayColor];
        [self.contentView addSubview:timelb];
        self.contentView.height=timelb.bottom+5;
        
    }
    return self;
}
-(void)setThePortaldic:(NSDictionary *)thePortaldic
{
    _thePortaldic=thePortaldic;
    
    titlelb.text=thePortaldic[@"title"];
    CGSize titlesize=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlesize.height>20?titlesize.height:20;
    timelb.top=titlelb.bottom+8;
    timelb.text=thePortaldic[@"add_time"];
    self.contentView.height=timelb.bottom+5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
