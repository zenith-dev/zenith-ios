//
//  LBNoticeDetailViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/12/3.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBNoticeDetailViewController.h"
#import "UnderLineLabel.h"
#import "LBLoadFileViewController.h"
@interface LBNoticeDetailViewController ()<UIWebViewDelegate>
{
    NSArray *fjlst;
    UIWebView *nrwb;
    float shight;
    UIView *views;
}
@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;

@end

@implementation LBNoticeDetailViewController
@synthesize mainScroll;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self noticeDetails];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark---------------------数据加载中------------
-(void)noticeDetails
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork noticeDetails:[_lbNoticDetail objectForKey:@"inttzlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] strryxm:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                //[SVProgressHUD dismiss];
                [self initview:[rep objectForKey:@"data"]];
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
-(void)initview:(NSDictionary*)noticedic
{
    UIView *fzview=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 10)];
    [fzview setBackgroundColor:[UIColor whiteColor]];
    [mainScroll addSubview:fzview];
    //标题
    UILabel *btlb=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, W(fzview)-20, 40)];
    btlb.font=BoldFont(17);
    btlb.textColor=[UIColor blackColor];
    btlb.textAlignment=NSTextAlignmentCenter;
    btlb.text=[noticedic objectForKey:@"strtzbt"];
    btlb.numberOfLines=0;
    btlb.lineBreakMode=NSLineBreakByCharWrapping;
    CGSize btsizeFont =[btlb.text boundingRectWithSize:CGSizeMake(W(btlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:BoldFont(17)} context:nil].size;
    btlb.frame=CGRectMake(X(btlb), Y(btlb), W(btlb), btsizeFont.height);
    [fzview addSubview:btlb];
    //时间
    UILabel *sjlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(btlb)+20, W(btlb)/2.0, 20)];
    sjlb.font=Font(14);
    sjlb.textColor=[SingleObj defaultManager].mainColor;
    sjlb.text=[noticedic objectForKey:@"strryxm"];
    [fzview addSubview:sjlb];
    //发布人
    UILabel *fblb=[[UILabel alloc]initWithFrame:CGRectMake(XW(sjlb), Y(sjlb), W(sjlb), H(sjlb))];
    fblb.font=Font(14);
    fblb.textAlignment=NSTextAlignmentRight;
    fblb.textColor=[SingleObj defaultManager].mainColor;
    fblb.text=[Tools dateToStr:[Tools strToDate:[noticedic objectForKey:@"dtmdjsj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy-MM-dd"];
    
    [fzview addSubview:fblb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(sjlb)+10, W(fzview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].backColor];
    [fzview addSubview:oneline];
    //内容
    nrwb=[[UIWebView alloc]initWithFrame:CGRectMake(0, YH(oneline)+10, W(fzview), 30)];
    nrwb.scrollView.scrollEnabled = YES;
    NSMutableAttributedString *attstr=[Tools attributedStringWithHtml:[noticedic objectForKey:@"strzw"]];
    CGRect nrsizeFont = [attstr boundingRectWithSize:CGSizeMake(W(nrwb), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    nrwb.frame=CGRectMake(X(nrwb), Y(nrwb), W(nrwb), nrsizeFont.size.height+200);
    [fzview addSubview:nrwb];
    float fjhigh=YH(nrwb);

    
    if ([[noticedic objectForKey:@"fjList"] count]>0) {
        float fjh=0;
        views=[[UIView alloc]initWithFrame:CGRectMake(0, fjhigh, W(fzview), 10)];
        [views setBackgroundColor:[UIColor whiteColor]];
        [fzview addSubview:views];
        //横线
        UIImageView *fourline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(fzview), 1)];
        [fourline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [views addSubview:fourline];
        fjh+=1;
        //附件列表
        UILabel *fjstrlb=[[UILabel alloc]initWithFrame:CGRectMake(5, fjh, 120, 20)];
        fjstrlb.font=Font(16);
        fjstrlb.text=@"附件列表:";
        fjstrlb.textColor=[SingleObj defaultManager].mainColor;
        [views addSubview:fjstrlb];
        fjh+=H(fjstrlb);
        //横线
        UIImageView *fiveline=[[UIImageView alloc]initWithFrame:CGRectMake(X(fourline), YH(fjstrlb)+4, W(fourline), 1)];
        [fiveline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [views addSubview:fiveline];
        fjh+=5;
        fjlst=[[NSArray alloc]initWithArray:[noticedic objectForKey:@"fjList"]];
        for (int i=0; i<fjlst.count; i++) {
            UnderLineLabel *lffilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(X(fjstrlb), fjh,  W(fzview)-10, 20)];
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
            [views addSubview:lffilezlb];
            fjh+=lffileFontSize.height+5;
        }
        views.frame=CGRectMake(X(views), Y(views), W(views), fjh);
        fjhigh+=fjh;
    }
    fzview.frame=CGRectMake(X(fzview), Y(fzview), W(fzview), fjhigh+30);
    shight=YH(fzview)-H(nrwb);
    [mainScroll setContentSize:CGSizeMake(W(mainScroll), shight)];
    NSURL *url = [NSURL URLWithString:[noticedic objectForKey:@"tempUrl"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [nrwb loadRequest:request];
    nrwb.delegate=self;
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
#pragma mark uiwebdelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //[SVProgressHUD showWithStatus:@"加载中..."];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    float sizeHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    float sizeWidth = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] floatValue];
    webView.frame=CGRectMake(X(webView), Y(webView), W(webView), sizeHeight);
    webView.scrollView.contentSize=CGSizeMake(sizeWidth, sizeHeight);
    views.frame=CGRectMake(X(views), YH(webView), W(views), H(views));
    [mainScroll setContentSize:CGSizeMake(W(mainScroll), shight+sizeHeight)];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [Tools showMsgBox:@"加载出错:请联系管理人员"];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        NSString *curUrl= [url absoluteString];
        if ([curUrl rangeOfString:@"http://"].location!=NSNotFound) {
            LBLoadFileViewController *showUrlClicked=[[LBLoadFileViewController alloc]init];
            showUrlClicked.shopurl=curUrl;
            [self.navigationController pushViewController:showUrlClicked animated:YES];
        }
        if ([curUrl rangeOfString:@"tel:"].location!=NSNotFound) {
            curUrl=[curUrl stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
            NSString *number = [NSString stringWithFormat:@"telprompt://%@",curUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }
        return NO;
    }
    return  YES;
}
#pragma mark------------------
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
