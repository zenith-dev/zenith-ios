//
//  LBForwardingViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 16/3/29.
//  Copyright © 2016年 熊佳佳. All rights reserved.
//

#import "LBForwardingViewController.h"
#import "QCheckBox.h"
#import "UITextViewPlaceHolder.h"
#import "LBUnitChooseViewController.h"
#import "RyModel.h"
#import "UnderLineLabel.h"
#import "LBLoadFileViewController.h"

@interface LBForwardingViewController ()<QCheckBoxDelegate>
@property (nonatomic,strong)UITextField *titletf;//标题
@property (nonatomic,strong)UITextView *conenttv;//内容
@property (nonatomic,strong)UITextView *jsrlb;
@property (nonatomic,strong)NSString *strxxjbz;
@property (nonatomic,strong)NSArray *fjlst;
@property (nonatomic,strong)UIView *bgview;
@end

@implementation LBForwardingViewController
@synthesize forwardScr,titletf,conenttv,jsrlb,msgboxdic,strxxjbz,bgview,fjlst;
#pragma mark-----------选择人员----------
-(void)setSelectryary:(NSMutableArray *)selectryary
{
    _selectryary=selectryary;
    NSMutableString *rymc=[NSMutableString string];
    for (RyModel *rydic in selectryary) {
        [rymc appendFormat:@"%@,",rydic.strryxm];
    }
    if (jsrlb!=nil) {
        if (selectryary.count!=0) {
            NSString *s = [rymc substringToIndex:rymc.length-1];
            jsrlb.text=s;
            jsrlb.textColor=[UIColor blueColor];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectryary=[[NSMutableArray alloc]init];
    [self rightButton:@"转发" image:nil sel:@selector(zfSEL:)];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--------------初始化界面---------
-(void)initview{
    [self.view setBackgroundColor:[SingleObj defaultManager].lineColor];
    bgview=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
    ViewRadius(bgview, 4);
    [bgview setBackgroundColor:[UIColor whiteColor]];
     NSString *bt=@"指定接收人:";
     UIFont *bfont=Font(14);
     CGSize bsize=[bt sizeWithAttributes:@{NSFontAttributeName:bfont}];
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, bsize.width, 30)];
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"标题:";
    [bgview addSubview:titlelb];
    titletf=[[UITextField alloc]initWithFrame:CGRectMake(XW(titlelb), X(titlelb), W(bgview)-(XW(titlelb)+10), H(titlelb))];
    titletf.font=bfont;
    titletf.placeholder=@"请输入标题";
    titletf.text=[msgboxdic objectForKey:@"strtzbt"];
    [bgview addSubview:titletf];
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(titlelb), W(bgview), 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgview addSubview:onelb];
    
    UILabel *highlb=[[UILabel alloc]initWithFrame:CGRectMake(X(titlelb), YH(onelb),bsize.width , H(titlelb))];
    highlb.font=bfont;
    highlb.textColor=[SingleObj defaultManager].mainColor;
    highlb.text=@"高优先级:";
    [bgview addSubview:highlb];
    QCheckBox *hgibx=[[QCheckBox alloc]initWithDelegate:self];
    hgibx.frame=CGRectMake(X(titletf), Y(highlb), 100, H(highlb));
    [bgview addSubview:hgibx];
    hgibx.checked=YES;
    
    UILabel *one1lb=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(highlb), W(bgview), 0.5)];
    [one1lb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgview addSubview:one1lb];
    
    UILabel *connetlb=[[UILabel alloc]initWithFrame:CGRectMake(10, YH(one1lb), bsize.width, 30)];
    connetlb.font=bfont;
    connetlb.textColor=[SingleObj defaultManager].mainColor;
    connetlb.text=@"内容:";
    [bgview addSubview:connetlb];

    conenttv=[[UITextView alloc]initWithFrame:CGRectMake(X(titletf), Y(connetlb)+10, W(titletf), 120)];
    conenttv.font=bfont;
    ViewBorderRadius(conenttv, 4, 1, [SingleObj defaultManager].lineColor);
    conenttv.text=[msgboxdic objectForKey:@"strzw"];
    [bgview addSubview:conenttv];
    
    UILabel *one2lb=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(conenttv)+10, W(bgview), 0.5)];
    [one2lb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgview addSubview:one2lb];
    
    UILabel *fjstrlb=[[UILabel alloc]initWithFrame:CGRectMake(10, Y(one2lb)+5, 120, 20)];
    fjstrlb.font=Font(16);
    fjstrlb.text=@"附件列表:";
    fjstrlb.textColor=[SingleObj defaultManager].mainColor;
    [bgview addSubview:fjstrlb];
    //横线
    UIImageView *fiveline=[[UIImageView alloc]initWithFrame:CGRectMake(X(one2lb), YH(fjstrlb)+4, W(one2lb), 1)];
    [fiveline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgview addSubview:fiveline];
    float highfj=YH(fiveline)+5;
    fjlst=[[NSArray alloc]initWithArray:[msgboxdic objectForKey:@"fjlist"]];
    for (int i=0; i<fjlst.count; i++) {
        UnderLineLabel *lffilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(10, highfj,  conenttv.mj_w, 20)];
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
        [bgview addSubview:lffilezlb];
        highfj+=lffileFontSize.height+5;
    }
    one2lb=[[UILabel alloc]initWithFrame:CGRectMake(0, highfj+10, W(bgview), 0.5)];
    [one2lb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgview addSubview:one2lb];
    
    
    UILabel *zdry=[[UILabel alloc]initWithFrame:CGRectMake(X(titlelb), YH(one2lb),bsize.width , H(titlelb))];
    zdry.font=bfont;
    zdry.textColor=[SingleObj defaultManager].mainColor;
    zdry.text=@"指定接收人:";
    [bgview addSubview:zdry];
    jsrlb =[[UITextView alloc]initWithFrame:CGRectMake(X(titletf), Y(zdry), W(titletf), 60)];
    jsrlb.font=bfont;
    jsrlb.textColor=RGBCOLOR(220, 220, 220);
    jsrlb.text=@"请选择接收人";
    jsrlb.userInteractionEnabled=YES;
    jsrlb.editable=NO;
    [jsrlb bk_whenTapped:^{
        LBUnitChooseViewController *lbunit=[[LBUnitChooseViewController alloc]init];
        lbunit.title=@"选择人员";
        lbunit.selcetAry=self.selectryary;
        [self.navigationController pushViewController:lbunit animated:YES];
    }];
    [bgview addSubview:jsrlb];
     bgview.frame=CGRectMake(X(bgview), Y(bgview), W(bgview), YH(jsrlb));
    [forwardScr addSubview:bgview];
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
-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    if (checked) {
        strxxjbz=@"1";
    }
    else
    {
        strxxjbz=@"0";
    }
}
#pragma mark-------------转发---------
-(void)zfSEL:(UIButton*)sender
{
    if ([Tools isBlankString:titletf.text]) {
        [Tools showMsgBox:@"请填写标题"];
        return;
    }
    else if ([Tools isBlankString:conenttv.text])
    {
        [Tools showMsgBox:@"请填写内容"];
        return;
    }
    else if (self.selectryary.count==0)
    {
        [Tools showMsgBox:@"请指定接收人"];
        return;
    }
    [SVProgressHUD showWithStatus:@"转发中..." maskType:SVProgressHUDMaskTypeClear];
    NSString *strbzlst=[[NSString alloc]init];
    NSString *intjslshlst=[[NSString alloc]init];
    NSString *intcsdwlsh=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"];
    NSString *strcsjc=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strcsjc"];
    NSString *rbtzfs=@"radiobutton";
    NSString *strryxm =[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"];
    NSString *intrylsh=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"];
    NSString *strxmlst=[[NSString alloc]init];
    NSString *intdwlsh =[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"];
    NSString *strdwjc=[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwjc"];
    NSString *inttzfs=@"1";
    NSString *strhhbz =@"0";    for (RyModel *dic in self.selectryary) {
        strbzlst =[strbzlst stringByAppendingString:@"1,"];
        intjslshlst =[intjslshlst stringByAppendingString:[NSString stringWithFormat:@"%@,",dic.intrylsh]];
        strxmlst=[strxmlst stringByAppendingString:[NSString stringWithFormat:@"%@,",dic.strryxm]];
    }
    strbzlst=[strbzlst substringToIndex:strbzlst.length-1];
    intjslshlst=[intjslshlst substringToIndex:intjslshlst.length-1];
    strxmlst=[strxmlst substringToIndex:strxmlst.length-1];
    [SVProgressHUD showWithStatus:@"转发中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork sendMail:strbzlst intjslshlst:intjslshlst intcsdwlsh:intcsdwlsh strxxjbz:strxxjbz strzw:conenttv.text strcsjc:strcsjc rbtzfs:rbtzfs strryxm:strryxm intrylsh:intrylsh strxmlst:strxmlst intdwlsh:intdwlsh strtzbt:titletf.text strdwjc:strdwjc inttzfs:inttzfs strhhbz:strhhbz isZf:@"1" inttzlsh_pre:self.inttzlsh_pre completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
               
                [SVProgressHUD showSuccessWithStatus:@"转发成功"];
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
