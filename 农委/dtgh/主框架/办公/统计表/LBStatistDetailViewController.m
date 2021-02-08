//
//  LBStatistDetailViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 18/3/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LBStatistDetailViewController.h"
#import "UITextViewPlaceHolder.h"
#import "CTextField.h"
@interface LBStatistDetailViewController ()
@property (nonatomic,strong)NSDictionary *getTjInfo;
@property (nonatomic,strong)CTextField *strryxm_tf;//姓名
@property (nonatomic,strong)CTextField *strdezw_tf;//单位职务
@property (nonatomic,strong)CTextField *dtmrsjs_tf;//任职时间
@property (nonatomic,strong)UITextViewPlaceHolder *strsjgzqk_tv;//传达上级工作部署情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlslzfwqk_tv;//落实同级党委党风廉政建设和反腐败工作任务情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlzfwjdqk_tv;//在分管范围内开展党风廉政建设和反腐败工作监督检查的情况
@property (nonatomic,strong)UITextViewPlaceHolder *stryt_tv;//约谈下级党员领导干部情况
@property (nonatomic,strong)UITextViewPlaceHolder *strzdlzqk_tv;//指导分管部门制定党风廉政建设防控措施、制度及解决问题的情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlzjwqk_tv;//对党员干部廉政教育的情况
@property (nonatomic,strong)UITextViewPlaceHolder *strqt_tv;//其他

@property (nonatomic,strong)UITextViewPlaceHolder *strbfzy_tv;//充分
@end

@implementation LBStatistDetailViewController
@synthesize inttjblsh,getTjInfo,strryxm_tf,strdezw_tf,dtmrsjs_tf,strsjgzqk_tv,strlslzfwqk_tv,strlzfwjdqk_tv,stryt_tv,strzdlzqk_tv,strlzjwqk_tv,strqt_tv,strbfzy_tv;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getTjbxx:inttjblsh completionBlock:^(id rep, NSString *emsg) {
        [SVProgressHUD dismiss];
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                getTjInfo=[rep objectForKey:@"data"];
                strryxm_tf.text=getTjInfo[@"strryxm"];
                strdezw_tf.text=getTjInfo[@"strdwzw"];
                dtmrsjs_tf.text=getTjInfo[@"dtmrzsj"];
                strsjgzqk_tv.text=getTjInfo[@"strsjgzqk"];
                strlslzfwqk_tv.text=getTjInfo[@"strlslzfwqk"];
                strlzfwjdqk_tv.text=getTjInfo[@"strlzfwjdqk"];
                stryt_tv.text=getTjInfo[@"stryt"];
                strzdlzqk_tv.text=getTjInfo[@"strzdlzqk"];
                strlzjwqk_tv.text=getTjInfo[@"strlzjwqk"];
                strbfzy_tv.text =getTjInfo[@"strbfzy"];
                strqt_tv.text=getTjInfo[@"strqt"];
            }
        }
    }];
    // Do any additional setup after loading the view.
}
#pragma makr----------初始化界面------
-(void)initview{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    UIView *bgvivew=[[UIView alloc]initWithFrame:CGRectMake(5, 5, scroll.width-10, 10)];
    [scroll addSubview:bgvivew];
    UIFont *bfont=Font(14);
    NSString *bt=@"指定接收人:";
    CGSize bsize=[bt sizeWithAttributes:@{NSFontAttributeName:bfont}];
    //姓名
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, bsize.width, 30)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"姓名:";
    [bgvivew addSubview:titlelb];
    strryxm_tf=[[CTextField alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strryxm_tf.font=bfont;
    strryxm_tf.userInteractionEnabled=NO;
    ViewBorderRadius(strryxm_tf, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strryxm_tf];
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    //单位及职务
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 30)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"单位及职务:";
    [bgvivew addSubview:titlelb];
    strdezw_tf=[[CTextField alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strdezw_tf.font=bfont;
    ViewBorderRadius(strdezw_tf, 4, 1, [SingleObj defaultManager].lineColor);
    strdezw_tf.userInteractionEnabled=NO;
    [bgvivew addSubview:strdezw_tf];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    //任职时间
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 30)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"任职时间:";
    [bgvivew addSubview:titlelb];
    dtmrsjs_tf=[[CTextField alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    dtmrsjs_tf.font=bfont;
    dtmrsjs_tf.userInteractionEnabled=NO;
    ViewBorderRadius(dtmrsjs_tf, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:dtmrsjs_tf];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    //传达上级工作部署情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 60)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"把政治建设摆在首位:";
    [bgvivew addSubview:titlelb];
    strsjgzqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strsjgzqk_tv.font=bfont;
    strsjgzqk_tv.editable=NO;
    ViewBorderRadius(strsjgzqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strsjgzqk_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    //落实同级党委党风廉政建设和反腐败工作任务情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 90)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"大力营造良好政治生态:";
    [bgvivew addSubview:titlelb];
    strlslzfwqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlslzfwqk_tv.font=bfont;
    strlslzfwqk_tv.editable=NO;
    ViewBorderRadius(strlslzfwqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strlslzfwqk_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    //在分管范围内开展党风廉政建设和反腐败工作监督检查的情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 110)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"树立正确选人用人导向:";
    [bgvivew addSubview:titlelb];
    strlzfwjdqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlzfwjdqk_tv.font=bfont;
    strlzfwjdqk_tv.editable=NO;
    ViewBorderRadius(strlzfwjdqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strlzfwjdqk_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    
    //约谈下级党员领导干部情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 70)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"强化党内监督:";
    [bgvivew addSubview:titlelb];
    stryt_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    stryt_tv.font=bfont;
    stryt_tv.editable=NO;
    ViewBorderRadius(stryt_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:stryt_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    //指导分管部门制定党风廉政建设防控措施、制度及解决问题的情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 110)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"持之以恒正风肃纪:";
    [bgvivew addSubview:titlelb];
    strzdlzqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strzdlzqk_tv.font=bfont;
    strzdlzqk_tv.editable=NO;
    ViewBorderRadius(strzdlzqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strzdlzqk_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    //对党员干部廉政教育的情况
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 70)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"坚决惩治腐败:";
    [bgvivew addSubview:titlelb];
    strlzjwqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlzjwqk_tv.font=bfont;
    strlzjwqk_tv.editable=NO;
    ViewBorderRadius(strlzjwqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strlzjwqk_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    //充分发挥领导干部示范表率作用
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 70)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"充分发挥领导干部示范表率作用:";
    [bgvivew addSubview:titlelb];
    strbfzy_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strbfzy_tv.font=bfont;
    strbfzy_tv.editable=NO;
    ViewBorderRadius(strbfzy_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strbfzy_tv];
    onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, titlelb.bottom,bgvivew.width, 0.5)];
    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
    [bgvivew addSubview:onelb];
    
    //其他
    titlelb=[[UILabel alloc]initWithFrame:CGRectMake(titlelb.left,onelb.bottom+5, titlelb.width, 70)];
    titlelb.numberOfLines=0;
    titlelb.font=bfont;
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.text=@"其他:";
    [bgvivew addSubview:titlelb];
    strqt_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strqt_tv.font=bfont;
    strqt_tv.placeholder=@"请输入其他";
    ViewBorderRadius(strqt_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strqt_tv];
    bgvivew.height=titlelb.bottom+10;

    
    [scroll setContentSize:CGSizeMake(scroll.width, bgvivew.bottom+10)];
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
