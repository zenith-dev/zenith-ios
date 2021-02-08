//
//  LBAddStatistViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 18/3/24.
//  Copyright © 2018年 熊佳佳. All rights reserved.
//

#import "LBAddStatistViewController.h"
#import "UITextViewPlaceHolder.h"
#import "CTextField.h"
@interface LBAddStatistViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)CTextField *strryxm_tf;//姓名
@property (nonatomic,strong)CTextField *strdezw_tf;//单位职务
@property (nonatomic,strong)CTextField *dtmrsjs_tf;//任职时间
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UITextViewPlaceHolder *strsjgzqk_tv;//传达上级工作部署情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlslzfwqk_tv;//落实同级党委党风廉政建设和反腐败工作任务情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlzfwjdqk_tv;//在分管范围内开展党风廉政建设和反腐败工作监督检查的情况
@property (nonatomic,strong)UITextViewPlaceHolder *stryt_tv;//约谈下级党员领导干部情况
@property (nonatomic,strong)UITextViewPlaceHolder *strzdlzqk_tv;//指导分管部门制定党风廉政建设防控措施、制度及解决问题的情况
@property (nonatomic,strong)UITextViewPlaceHolder *strlzjwqk_tv;//对党员干部廉政教育的情况
@property (nonatomic,strong)UITextViewPlaceHolder *strqt_tv;//其他
@end

@implementation LBAddStatistViewController
@synthesize strryxm_tf,strdezw_tf,dtmrsjs_tf,strsjgzqk_tv,strlslzfwqk_tv,strlzfwjdqk_tv,stryt_tv,strzdlzqk_tv,strlzjwqk_tv,strqt_tv,datePicker;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"添加" image:nil sel:@selector(addSEL:)];
     NSString *strryxm= [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"strryxm"];
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
    strryxm_tf.text=strryxm;
    strryxm_tf.placeholder=@"请输入姓名";
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
    strdezw_tf.placeholder=@"请输入单位及职务";
    strdezw_tf.text=@"市农委";
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
    dtmrsjs_tf.delegate=self;
    dtmrsjs_tf.placeholder=@"请选择任职时间(非必填)";
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
    titlelb.text=@"传达上级工作部署情况:";
    [bgvivew addSubview:titlelb];
    strsjgzqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strsjgzqk_tv.font=bfont;
    strsjgzqk_tv.placeholder=@"请输入传达上级工作部署情况";
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
    titlelb.text=@"落实同级党委党风廉政建设和反腐败工作任务情况:";
    [bgvivew addSubview:titlelb];
    strlslzfwqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlslzfwqk_tv.font=bfont;
    strlslzfwqk_tv.placeholder=@"请输入任务情况";
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
    titlelb.text=@"在分管范围内开展党风廉政建设和反腐败工作监督检查的情况:";
    [bgvivew addSubview:titlelb];
    strlzfwjdqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlzfwjdqk_tv.font=bfont;
    strlzfwjdqk_tv.placeholder=@"请输入检查情况";
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
    titlelb.text=@"约谈下级党员领导干部情况:";
    [bgvivew addSubview:titlelb];
    stryt_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    stryt_tv.font=bfont;
    stryt_tv.placeholder=@"请输入约谈情况";
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
    titlelb.text=@"指导分管部门制定党风廉政建设防控措施、制度及解决问题的情况:";
    [bgvivew addSubview:titlelb];
    strzdlzqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strzdlzqk_tv.font=bfont;
    strzdlzqk_tv.placeholder=@"请输入解决问题的情况";
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
    titlelb.text=@"对党员干部廉政教育的情况:";
    [bgvivew addSubview:titlelb];
    strlzjwqk_tv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(titlelb.right+5, titlelb.top,bgvivew.width-(titlelb.right+10), titlelb.height)];
    strlzjwqk_tv.font=bfont;
    strlzjwqk_tv.placeholder=@"请输入教育的情况";
    ViewBorderRadius(strlzjwqk_tv, 4, 1, [SingleObj defaultManager].lineColor);
    [bgvivew addSubview:strlzjwqk_tv];
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
    // Do any additional setup after loading the view.
}
#pragma mark---------添加------
-(void)addSEL:(UIButton*)sender{
    if ([Tools isBlankString:strryxm_tf.text]) {
        [Tools showMsgBox:@"请输入姓名"];
        return;
    }
    NSString *strryxm= [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"strryxm"];
    NSString *intlrrylsh= [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"][@"intrylsh"];
    NSDictionary *pardic=@{@"strryxm":strryxm_tf.text,
                           @"strlrryxm":strryxm,
                           @"intlrrylsh":intlrrylsh,
                           @"dtmrzsj":dtmrsjs_tf.text,
                           @"strdwzw":strdezw_tf.text,
                           @"strsjgzqk":strsjgzqk_tv.text,
                           @"strlslzfwqk":strlslzfwqk_tv.text,
                           @"strlzfwjdqk":strlzfwjdqk_tv.text,
                           @"stryt":stryt_tv.text,
                           @"strzdlzqk":strzdlzqk_tv.text,
                           @"strlzjwqk":strlzjwqk_tv.text,
                           @"strqt":strqt_tv.text};
    [SHNetWork saveTjb:pardic completionBlock:^(id rep, NSString *emsg) {
        if ([[rep objectForKey:@"flag"] intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
        }
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==dtmrsjs_tf) {
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker.datePickerMode=UIDatePickerModeDate;
            datePicker.maximumDate=[NSDate date];
        }
        textField.inputView = datePicker;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [okbt setTitleColor:RGBCOLOR(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        [okbt bk_addEventHandler:^(id sender) {
            [textField resignFirstResponder];
            NSDate *date=[datePicker date];
            NSString *datestr=[Tools dateToStr:date andFormat:@"yyyy-MM-dd"];
            textField.text=datestr;
        } forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:RGBCOLOR(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt bk_addEventHandler:^(id sender) {
            [textField resignFirstResponder];
        } forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
}

-(void)gogo{
    if (self.callback) {
        self.callback(YES);
    }
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
