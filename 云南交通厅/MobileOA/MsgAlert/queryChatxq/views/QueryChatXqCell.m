//
//  QueryChatXqCell.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/7.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "QueryChatXqCell.h"
@interface QueryChatXqCell()
@property (nonatomic,strong)UIImageView *headImg;
@property (nonatomic,strong)UIImageView *bgImg;
@property (nonatomic,strong)UILabel *titlelb;
@property (nonatomic,strong)UILabel *timelb;
@end
@implementation QueryChatXqCell
@synthesize timelb,titlelb,headImg,bgImg,tempTime;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSString *bstr=@"2016-11-04 11:07:23";
        NSString *bname=@"建设银行:";
        CGSize bsize=[bstr sizeWithAttributes:@{NSFontAttributeName:Font(13)}];
        CGSize bsize1=[bname sizeWithAttributes:@{NSFontAttributeName:Font(15)}];
        timelb =[[UILabel alloc]initWithFrame:CGRectMake(80, 10, bsize.width+10, 26)];
        timelb.centerX=kScreenWidth/2.0;
        timelb.textAlignment=NSTextAlignmentCenter;
        timelb.font=Font(13);
        [timelb setBackgroundColor:RGBACOLOR(200, 200, 200, 0.8)];
        timelb.textColor=[UIColor  whiteColor];
        [self.contentView addSubview:timelb];
        ViewRadius(timelb, timelb.height/2.0);
        
        bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, timelb.top+5, Scale5BI(205), Scale5BI(30))];
        [self.contentView addSubview:bgImg];
        headImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, timelb.bottom+15, 45, 45)];
        [headImg setImage:PNGIMAGE(@"默认头像")];
        ViewRadius(headImg, headImg.height/2.0);
        bgImg.centerY=headImg.centerY;
        [self.contentView addSubview:headImg];
        
        titlelb=[[UILabel alloc]initWithFrame:CGRectMake(10,(bgImg.height-bsize1.height)/2.0, bgImg.width-20, bsize1.height)];
        titlelb.font=Font(15);
        titlelb.numberOfLines=0;
        [bgImg addSubview:titlelb];
    }
    return self;
}
-(void)setQcxqModel:(QcXqModel *)qcxqModel
{
    _qcxqModel=qcxqModel;
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:[self.fristTime substringToIndex:self.fristTime.length-2]];
    NSDate *endD = [date dateFromString:[qcxqModel.dtmfssj substringToIndex:qcxqModel.dtmfssj.length-2]];
    NSLog(@"%@===========%@",self.fristTime,qcxqModel.dtmfssj);
    NSLog(@"%@===========%@",startD,endD);
    if ([Tools nowDate:startD fromDate:endD]>5*60||[Tools nowDate:startD fromDate:endD]==0) {
        timelb.text=[qcxqModel.dtmfssj substringToIndex:16];
        timelb.height=26;
    }else
    {
        timelb.text=@"";
        timelb.height=0;
    }
    headImg.top=timelb.bottom+15;
    bgImg.centerY=headImg.centerY;
    if ([qcxqModel.intfsrlsh longValue]==SingObj.userInfo.intrylsh) {//发送人
        headImg.right=(kScreenWidth-15);
        titlelb.text=qcxqModel.strnr;
        titlelb.textColor=[UIColor whiteColor];
        CGSize contensize=[titlelb.text sizeWithFont:titlelb.font constrainedToSize:CGSizeMake(titlelb.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        titlelb.height=contensize.height;
        titlelb.width=contensize.width>40?contensize.width:40;
        titlelb.left=10;
        bgImg.width=(titlelb.width+20)>60?(titlelb.width+20):60;
        bgImg.height=titlelb.bottom+titlelb.top;
        UIImage *image=[UIImage imageNamed:@"对话框右"];
        CGFloat top = 11; // 顶端盖高度
        CGFloat bottom = 11 ; // 底端盖高度
        CGFloat left = 15; // 左端盖宽度
        CGFloat right = 21; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [bgImg setImage:image];
         bgImg.right=(headImg.left-7);
        self.contentView.height=bgImg.bottom+10;
    }else
    {
        UIColor *bcolor=[UIColor colorWithRed:0.373 green:0.373 blue:0.373 alpha:1.00];
        headImg.left=15;
        titlelb.text=qcxqModel.strnr;
        CGSize contensize=[titlelb.text sizeWithFont:titlelb.font constrainedToSize:CGSizeMake(titlelb.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        titlelb.height=contensize.height;
        titlelb.width=contensize.width>40?contensize.width:40;
        titlelb.left=10;
        titlelb.textColor=bcolor;
        bgImg.width=(titlelb.width+20)>60?(titlelb.width+20):60;
        bgImg.height=titlelb.bottom+titlelb.top;
        UIImage *image=[UIImage imageNamed:@"对话框左"];
        CGFloat top = 11; // 顶端盖高度
        CGFloat bottom = 11 ; // 底端盖高度
        CGFloat left =21; // 左端盖宽度
        CGFloat right =15; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [bgImg setImage:image];
        bgImg.left=(headImg.right+7);
        self.contentView.height=bgImg.bottom+10;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
