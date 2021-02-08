//
//  MeetCell.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/5.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "MeetCell.h"
@interface MeetCell()
@property (nonatomic,strong)UIImageView *iconimg;//icon图标
@property (nonatomic,strong)UILabel *titlb;//标题
@property (nonatomic,strong)UILabel *fbrlb;//发布人
@property (nonatomic,strong)UILabel *fbsjlb;//发布时间

@end
@implementation MeetCell
@synthesize iconimg,titlb,fbrlb,fbsjlb;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconimg =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 22, 22)];
        [iconimg setImage:PNGIMAGE(@"icon_tz")];
        [self.contentView addSubview:iconimg];
        
        titlb =[[UILabel alloc]initWithFrame:CGRectMake(iconimg.right+5, iconimg.top, kScreenWidth-iconimg.right-10, 21)];
        titlb.font=Font(15);
        titlb.numberOfLines=0;
        [self.contentView addSubview:titlb];
        
        fbrlb=[[UILabel alloc]initWithFrame:CGRectMake(titlb.left, titlb.bottom+5, titlb.width/2, titlb.height)];
        fbrlb.font=Font(13);
        fbrlb.textColor=[UIColor grayColor];
        [self.contentView addSubview:fbrlb];
        fbsjlb=[[UILabel alloc]initWithFrame:CGRectMake(fbrlb.right, fbrlb.top, fbrlb.width, fbrlb.height)];
        fbsjlb.font=Font(13);
        fbsjlb.textAlignment=NSTextAlignmentLeft;
        fbsjlb.textColor=[UIColor grayColor];
        [self.contentView addSubview:fbsjlb];
        
    }
    return self;
    
}
-(void)setMeetdic:(NSDictionary *)meetdic
{
    _meetdic=meetdic;
    titlb.text=meetdic[@"strhymc"];
    CGSize titls=[titlb.text boundingRectWithSize:CGSizeMake(titlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titlb.font} context:nil].size;
    titlb.height=titls.height>21?titls.height:titlb.height;
    fbrlb.top=titlb.bottom+5;
    fbrlb.text=meetdic[@"strlxr"];
    fbsjlb.text=[meetdic[@"dtmsqsj"] substringToIndex:16];
    self.contentView.height=fbsjlb.bottom+5;
    iconimg.centerY=self.contentView.height/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
