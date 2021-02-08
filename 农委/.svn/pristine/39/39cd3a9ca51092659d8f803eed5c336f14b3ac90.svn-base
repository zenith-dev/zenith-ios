//
//  LBZwDetailViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/12/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBZwDetailViewController.h"
#import "UnderLineLabel.h"
#import "LBLoadFileViewController.h"
@interface LBZwDetailViewController ()
{
    NSDictionary *detailInfo;//政务详情
    NSArray *fjlst;

}
@property (strong, nonatomic) IBOutlet UIScrollView *mainSrc;
@end

@implementation LBZwDetailViewController
@synthesize zwdetaildic,mainSrc;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryGovernDetails];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-------------政务详情--------------
-(void)queryGovernDetails
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork queryGovernDetails:[zwdetaildic objectForKey:@"intxxbslsh"] intsessionlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intsessionlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                detailInfo=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                [SVProgressHUD dismiss];
                [self initview:detailInfo];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
    }];
}
#pragma mark---------------政务界面----------------
-(void)initview:(NSDictionary*)noticedic
{
    UIView *fzview=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
    [fzview setBackgroundColor:[UIColor whiteColor]];
    [mainSrc addSubview:fzview];
    //标题
    UILabel *btlb=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, W(fzview)-20, 40)];
    btlb.font=BoldFont(17);
    btlb.textColor=[UIColor blackColor];
    btlb.textAlignment=NSTextAlignmentCenter;
    btlb.text=[noticedic objectForKey:@"strxxbt"];
    btlb.numberOfLines=0;
    btlb.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize btsizeFont =[btlb.text boundingRectWithSize:CGSizeMake(W(btlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
   // CGSize btsizeFont=[btlb.text sizeWithFont:BoldFont(17) constrainedToSize:CGSizeMake(W(btlb), 500) lineBreakMode:NSLineBreakByWordWrapping];
    btlb.frame=CGRectMake(X(btlb), Y(btlb), W(btlb), btsizeFont.height);
    [fzview addSubview:btlb];
    UILabel *sjlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(btlb)+20, W(btlb), 20)];
    sjlb.font=Font(14);
    sjlb.textColor=[SingleObj defaultManager].mainColor;
    sjlb.text=[NSString stringWithFormat:@"%@ %@    %@",[noticedic objectForKey:@"strdwjc"],[noticedic objectForKey:@"strbsrxm"],[Tools dateToStr:[Tools strToDate:[noticedic objectForKey:@"dtmbssj"] andFormat:@"yyyy-MM-dd HH:mm:ss.s"] andFormat:@"yyyy-MM-dd HH:mm"]];
    sjlb.adjustsFontSizeToFitWidth=YES;
    [fzview addSubview:sjlb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(sjlb)+10, W(fzview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].backColor];
    [fzview addSubview:oneline];
    
    //内容
    UILabel *nrlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(oneline)+10, W(btlb), 30)];
    //[nrlb setAttributedText:[Tools attributedStringWithHtml:[noticedic objectForKey:@"txtzw"]]];
    nrlb.text=[noticedic objectForKey:@"txtzw"];
    nrlb.font=Font(14);
    nrlb.textColor=[SingleObj defaultManager].titleColor;
    nrlb.numberOfLines=0;
    CGSize nrsizeFont =[nrlb.text boundingRectWithSize:CGSizeMake(W(nrlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
    //CGSize nrsizeFont=[nrlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(nrlb), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    nrlb.frame=CGRectMake(X(nrlb), Y(nrlb), W(nrlb), nrsizeFont.height);
    [fzview addSubview:nrlb];
    
    float fjhigh=YH(nrlb)+5;
    if ([[noticedic objectForKey:@"lstFj"] count]>0) {
        //横线
        UIImageView *fourline=[[UIImageView alloc]initWithFrame:CGRectMake(0, fjhigh, W(fzview), 1)];
        [fourline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [fzview addSubview:fourline];
        fjhigh+=1;
        //附件列表
        UILabel *fjstrlb=[[UILabel alloc]initWithFrame:CGRectMake(5, fjhigh+=5, 120, 20)];
        fjstrlb.font=Font(16);
        fjstrlb.text=@"附件列表:";
        fjstrlb.textColor=[SingleObj defaultManager].mainColor;
        [fzview addSubview:fjstrlb];
        fjhigh+=H(fjstrlb);
        
        //横线
        UIImageView *fiveline=[[UIImageView alloc]initWithFrame:CGRectMake(X(fourline), YH(fjstrlb)+4, W(fourline), 1)];
        [fiveline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [fzview addSubview:fiveline];
        fjhigh+=1;
        fjlst=[[NSArray alloc]initWithArray:[noticedic objectForKey:@"lstFj"]];
        for (int i=0; i<fjlst.count; i++) {
            UnderLineLabel *lffilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(X(fjstrlb), fjhigh+=5,  W(fzview)-10, 20)];
            lffilezlb.font=Font(14);
            lffilezlb.tag=1000+i;
            lffilezlb.shouldUnderline=YES;
            lffilezlb.text=[NSString stringWithFormat:@"%@",[[fjlst objectAtIndex:i] objectForKey:@"strfjmc"]];
            lffilezlb.numberOfLines=0;
            CGSize lffileFontSize =[lffilezlb.text boundingRectWithSize:CGSizeMake(W(lffilezlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
            lffilezlb.frame=CGRectMake(X(lffilezlb), Y(lffilezlb), W(lffilezlb), lffileFontSize.height);
            [lffilezlb setLineBreakMode:NSLineBreakByWordWrapping];
            NSMutableAttributedString *lineAttributed=[[NSMutableAttributedString alloc]initWithString:lffilezlb.text];
            [lineAttributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [lineAttributed length])];
            [lffilezlb setAttributedText:lineAttributed];
            [lffilezlb addTarget:self action:@selector(gotufile:)];
            [fzview addSubview:lffilezlb];
            fjhigh+=lffileFontSize.height+5;
        }
    }
    fzview.frame=CGRectMake(X(fzview), Y(fzview), W(fzview), fjhigh+30);
    
    [mainSrc setContentSize:CGSizeMake(W(mainSrc), YH(fzview))];
}
-(void)gotufile:(UIControl*)file
{
    NSDictionary *dic = [fjlst objectAtIndex:file.tag-1000];
    LBLoadFileViewController *lbloadfile=[[LBLoadFileViewController alloc]init];
    lbloadfile.title=[dic objectForKey:@"strfjmc"];
    NSRange range = [[dic objectForKey:@"strfjmc"] rangeOfString:@"."options:NSBackwardsSearch];
    NSString *suffix=[[dic objectForKey:@"strfjmc"] substringFromIndex:range.length+range.location];
    NSLog(@"%@",suffix);
    if (([suffix isEqualToString:@"docx"]||[suffix isEqualToString:@"pptx"]||[suffix isEqualToString:@"xlsx"])) {
        lbloadfile.isx=YES;
    }
    lbloadfile.shopurl=[dic objectForKey:@"url"];
    [[SingleObj defaultManager].rootnav pushViewController:lbloadfile animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
