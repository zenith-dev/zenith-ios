//
//  ReviceMailInfoVC.m
//  dtgh
//
//  Created by 熊佳佳 on 16/11/29.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "ReviceMailInfoVC.h"
#import "UnderLineLabel.h"
#import "LBLoadFileViewController.h"
@interface ReviceMailInfoVC ()
{
    NSArray *fjlst;
}
@property (nonatomic,strong)UITextView *reviceTv;
@property (nonatomic,strong)UIScrollView *reviceScr;
@end

@implementation ReviceMailInfoVC
@synthesize reviceScr,msgboxdic,reviceTv;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"回复" image:nil sel:@selector(reviceSEL)];
    reviceScr =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:reviceScr];
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self initview];
    // Do any additional setup after loading the view.
}
#pragma mark-----------------初始化界面---------------------
-(void)initview
{
    UIView *iview=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
    [iview setBackgroundColor:[UIColor whiteColor]];
    [reviceScr addSubview:iview];
    UIImageView *btimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    [btimg setImage:PNGIMAGE(@"mail-ico")];
    [iview addSubview:btimg];
    
    NSMutableString *btstr=[NSMutableString string];
    NSString *bt=@"标题:";
    [btstr appendFormat:@"%@",bt];
    [btstr appendFormat:@"%@",[msgboxdic objectForKey:@"strtzbt"]];
    UILabel *btstrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(btimg)+5, Y(btimg), W(iview)-(XW(btimg)+5), H(btimg))];
    btstrlb.font=Font(16);
    btstrlb.numberOfLines=0;
    btstrlb.textColor=[UIColor blackColor];
    btstrlb.lineBreakMode=NSLineBreakByCharWrapping;
    btstrlb.attributedText=[Tools renderText:btstr targetStr:bt andColor:[SingleObj defaultManager].mainColor];
    CGSize btstrFont =[btstr boundingRectWithSize:CGSizeMake(W(btstrlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(16)} context:nil].size;
    // CGSize btstrFont=[btstr sizeWithFont:Font(16) constrainedToSize:CGSizeMake(W(btstrlb), 500) lineBreakMode:NSLineBreakByCharWrapping];
    btstrlb.frame=CGRectMake(X(btstrlb), Y(btstrlb), btstrFont.width, H(btimg)>btstrFont.height?H(btimg):btstrFont.height);
    [iview addSubview:btstrlb];
    
    //横线
    UIImageView *twoline=[[UIImageView alloc]initWithFrame:CGRectMake(X(btimg), YH(btstrlb)+4, W(iview)-2*X(btimg), 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [iview addSubview:twoline];
    //发送人
    UIImageView *fsimg=[[UIImageView alloc]initWithFrame:CGRectMake(X(twoline), YH(twoline)+5, W(btimg), H(btimg))];
    [fsimg setImage:PNGIMAGE(@"mail-ico")];
    [iview addSubview:fsimg];
    UILabel *fsstrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(fsimg)+5, Y(fsimg), 120, H(fsimg))];
    fsstrlb.font=Font(16);
    fsstrlb.text=@"回复人:";
    fsstrlb.textColor=[SingleObj defaultManager].mainColor;
    [iview addSubview:fsstrlb];
    
    UILabel *fsstrlbs=[[UILabel alloc]initWithFrame:CGRectMake(X(fsimg), YH(fsimg)+5, W(iview)-X(fsimg)*2, 20)];
    fsstrlbs.text=[msgboxdic objectForKey:@"strryxm"];
    fsstrlbs.font=Font(14);
    fsstrlbs.textColor=[UIColor blackColor];
    [iview addSubview:fsstrlbs];
    //横线
    UIImageView *threeline=[[UIImageView alloc]initWithFrame:CGRectMake(X(fsstrlbs), YH(fsstrlbs)+4, W(fsstrlbs), 1)];
    [threeline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [iview addSubview:threeline];
    //时间
    UIImageView *sjimg=[[UIImageView alloc]initWithFrame:CGRectMake(X(threeline), YH(threeline)+5, W(btimg), H(btimg))];
    [sjimg setImage:PNGIMAGE(@"mail-ico")];
    [iview addSubview:sjimg];
    UILabel *sjstrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(sjimg)+5, Y(sjimg), 120, H(sjimg))];
    sjstrlb.font=Font(16);
    sjstrlb.text=@"时间:";
    sjstrlb.textColor=[SingleObj defaultManager].mainColor;
    [iview addSubview:sjstrlb];
    
    UILabel *sjstrlbs=[[UILabel alloc]initWithFrame:CGRectMake(X(fsimg), YH(sjimg)+5, W(iview)-X(sjimg)*2, 20)];
    sjstrlbs.text=[NSString stringWithFormat:@"%@",[Tools dateToStr:[Tools strToDate:[msgboxdic objectForKey:@"dtmdjsj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy-MM-dd HH:mm"]];
    sjstrlbs.font=Font(14);
    sjstrlbs.textColor=[UIColor blackColor];
    [iview addSubview:sjstrlbs];
    
    
    //横线
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(X(btimg), YH(sjstrlbs)+4, W(iview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [iview addSubview:oneline];
    //内容
    UIImageView *connetimg=[[UIImageView alloc]initWithFrame:CGRectMake(X(oneline), YH(oneline)+5, W(btimg), H(btimg))];
    [connetimg setImage:PNGIMAGE(@"mail-ico")];
    [iview addSubview:connetimg];
    UILabel *nrstrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(connetimg)+5, Y(connetimg), 120, H(connetimg))];
    nrstrlb.font=Font(16);
    nrstrlb.text=@"内容:";
    nrstrlb.textColor=[SingleObj defaultManager].mainColor;
    [iview addSubview:nrstrlb];
    reviceTv =[[UITextView alloc]initWithFrame:CGRectMake(X(connetimg), YH(connetimg)+5, W(iview)-X(connetimg)*2, 90)];
    reviceTv.text=[msgboxdic objectForKey:@"strzw"];
    
    reviceTv.font=Font(14);
    
    reviceTv.textColor=[UIColor blackColor];
    [iview addSubview:reviceTv];
    
    //横线
    UIImageView *fourline=[[UIImageView alloc]initWithFrame:CGRectMake(X(sjstrlbs), YH(reviceTv)+4, W(sjstrlbs), 1)];
    [fourline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [iview addSubview:fourline];
    //附件列表
    UIImageView *fjimg=[[UIImageView alloc]initWithFrame:CGRectMake(X(fourline), YH(fourline)+5, W(btimg), H(btimg))];
    [fjimg setImage:PNGIMAGE(@"mail-ico")];
    [iview addSubview:fjimg];
    UILabel *fjstrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(fjimg)+5, Y(fjimg), 120, H(fjimg))];
    fjstrlb.font=Font(16);
    fjstrlb.text=@"附件列表:";
    fjstrlb.textColor=[SingleObj defaultManager].mainColor;
    [iview addSubview:fjstrlb];
    //横线
    UIImageView *fiveline=[[UIImageView alloc]initWithFrame:CGRectMake(X(fourline), YH(fjstrlb)+4, W(fourline), 1)];
    [fiveline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [iview addSubview:fiveline];
    float highfj=YH(fiveline)+5;
    fjlst=[[NSArray alloc]initWithArray:[msgboxdic objectForKey:@"fjlist"]];
    for (int i=0; i<fjlst.count; i++) {
        UnderLineLabel *lffilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(X(sjstrlbs), highfj,  W(sjstrlbs), 20)];
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
        [iview addSubview:lffilezlb];
        highfj+=lffileFontSize.height+5;
    }
    iview.frame=CGRectMake(X(iview), Y(iview), W(iview), highfj+10);
    [reviceScr setContentSize:CGSizeMake(kScreenWidth, YH(iview))];
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
#pragma mark-------------回复--------
-(void)reviceSEL{
    if (reviceTv.text.length==0) {
        [Tools showMsgBox:@"请输入回复内容"];
        return;
    }
    NSDictionary *userInfodic=[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString *intrylsh =userInfodic[@"intrylsh"];
    NSString *strryxm  =userInfodic[@"strryxm"];
    NSString *strcsjc  =userInfodic[@"strcsjc"];
    NSString *intcsdwlsh =userInfodic[@"intcsdwlsh"];
    NSString *intdwlsh =userInfodic[@"intdwlsh"];
    NSString *strdwjc =userInfodic[@"strdwjc"];
    NSDictionary *dic=@{@"strtzbt":[msgboxdic objectForKey:@"strtzbt"],@"strzw":reviceTv.text,@"intjslshlst":msgboxdic[@"intrylsh"],@"strxmlst":msgboxdic[@"strryxm"],@"intrylsh":intrylsh,@"strryxm":strryxm,@"strcsjc":strcsjc,@"intcsdwlsh":intcsdwlsh,@"intdwlsh":intdwlsh,@"strdwjc":strdwjc};
    [SVProgressHUD showWithStatus:@"回复中..."];
    [SHNetWork reviceMailInfo:dic completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                
                [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
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
-(void)gogo{
    [self.navigationController popViewControllerAnimated:YES];
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
