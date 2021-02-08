//
//  LBOpinionCzViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/19.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBOpinionCzViewController.h"
#import "QRadioButton.h"
#import "QCheckBox.h"
#import "CTextField.h"
#import "UITextViewPlaceHolder.h"
#import "LBChoosePersonViewController.h"
@interface LBOpinionCzViewController ()<QRadioButtonDelegate,UITextFieldDelegate,ChooseLxPersonDelegate>
{
    UITextViewPlaceHolder *zjrytv;//转交意见
    UILabel *rylb;
    UIDatePicker *datePicker;
    UIView *dealviews;
    UIView *typeviews;
    NSString *strsmsset;//短信提示
    NSString *intjxlz;//继续流转
    NSString *strsfyqfsyjbz;//返回要求
    QRadioButton *needbackqr;
    QRadioButton *needbackqr1;
    NSString *dtmyqhfsj;//回复时间
    CTextField *rttimefd;
    NSString *strisscbz;//转交类型
    NSString *strdbbz;//是否督办
    NSString *zjyjstr;//转交意见
    NSString *lcxx;//内部流程
    NSMutableString *strjsdwdzlst;//单位地址，多个逗号分隔
    NSMutableString *strjsdwmclst;//接收单位名称串，以","隔开,传入
    NSMutableArray *qcheckary;
    UIScrollView *mainscr;
    float hight;
}
@property(nonatomic,strong)NSMutableArray *getselectary;
@end

@implementation LBOpinionCzViewController
@synthesize getselectary;
- (void)viewDidLoad {
    [super viewDidLoad];
    qcheckary=[[NSMutableArray alloc]init];
    [self rightButton:@"提交" image:nil sel:@selector(submitSEL)];
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self getGwhsDw];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark------------------已选单位人员---------------
-(void)getGwhsDw
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getGwhsDw:[_savedic objectForKey:@"intgwlzlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                getselectary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                [SVProgressHUD dismiss];
                  [self initview];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
    }];
}
#pragma mark--------------------初始化界面---------------
-(void)initview
{
    mainscr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:mainscr];
    //短信提示
    UIView *msgpromptView=[[UIView alloc]initWithFrame:CGRectMake(5, 20, W(mainscr)-10, 40)];
    [msgpromptView setBackgroundColor:[UIColor whiteColor]];
    NSString *msgstr=@"短信提示:";
    UILabel *msglb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msgpromptView))];
    msglb.text=msgstr;
    msglb.font=Font(14);
    msglb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:msglb];
    QRadioButton *msgqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr.tag=1000;
   
    [msgqr setTitle:@"是" forState:0];
    msgqr.frame=CGRectMake(XW(msglb)+5, 0, 60,H(msglb));
    [msgpromptView addSubview:msgqr];
    
    QRadioButton *msgqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr1.tag=1001;
    msgqr1.checked=YES;
    [msgqr1 setTitle:@"否" forState:0];
    msgqr1.frame=CGRectMake(XW(msgqr)+10, 0, W(msgqr),H(msglb));
    [msgpromptView addSubview:msgqr1];
    //line
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(msglb), W(msgpromptView), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:oneline];
    
    
    
//    UILabel *circulationlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(oneline), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
//    circulationlb.text=@"继续流转:";
//    circulationlb.font=Font(14);
//    circulationlb.textColor=[SingleObj defaultManager].mainColor;
//    [msgpromptView addSubview:circulationlb];
//    QRadioButton *circulationqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"circulation"];
//    circulationqr.tag=1000;
//    circulationqr.checked=YES;
//    [circulationqr setTitle:@"是" forState:0];
//    circulationqr.frame=CGRectMake(XW(circulationlb)+5, Y(circulationlb), 60,H(circulationlb));
//    [msgpromptView addSubview:circulationqr];
//    
//    QRadioButton *circulationqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"circulation"];
//    [circulationqr1 setTitle:@"否" forState:0];
//    circulationqr1.tag=1001;
//    circulationqr1.frame=CGRectMake(XW(circulationqr)+10, Y(circulationlb), 60,H(circulationlb));
//    [msgpromptView addSubview:circulationqr1];
//    //line
//    UILabel *twoline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(circulationlb), W(msgpromptView), 1)];
//    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
//    [msgpromptView addSubview:twoline];
   
//    UILabel *needbacklb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(twoline), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(circulationlb))];
//    needbacklb.text=@"要求返回:";
//    needbacklb.font=Font(14);
//    needbacklb.textColor=[SingleObj defaultManager].mainColor;
//    [msgpromptView addSubview:needbacklb];
//    
//    needbackqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"needback"];
//    [needbackqr setTitle:@"要求" forState:0];
//    needbackqr.tag=1000;
//    
//    needbackqr.frame=CGRectMake(XW(needbacklb)+5, Y(needbacklb), 60,H(needbacklb));
//    [msgpromptView addSubview:needbackqr];
//    
//    needbackqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"needback"];
//    [needbackqr1 setTitle:@"不要求" forState:0];
//    needbackqr1.tag=1001;
//    
//    needbackqr1.frame=CGRectMake(XW(needbackqr)+10, Y(needbacklb), 70,H(needbacklb));
//    [msgpromptView addSubview:needbackqr1];
    //line
//    UILabel *threeline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(needbacklb), W(msgpromptView), 1)];
//    [threeline setBackgroundColor:[SingleObj defaultManager].lineColor];
//    [msgpromptView addSubview:threeline];
    msgpromptView.frame=CGRectMake(X(msgpromptView), Y(msgpromptView), W(msgpromptView), YH(oneline));
    [mainscr addSubview:msgpromptView];
    
//    dealviews=[[UIView alloc]initWithFrame:CGRectMake(X(msgpromptView), YH(msgpromptView), W(msgpromptView), 10)];
//    [dealviews setBackgroundColor:[UIColor whiteColor]];
//    [mainscr addSubview:dealviews];
//    
//    UILabel *rttimelb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(needbacklb))];
//    rttimelb.text=@"回复时间:";
//    rttimelb.font=Font(14);
//    rttimelb.textColor=[SingleObj defaultManager].mainColor;
//    [dealviews addSubview:rttimelb];
//    rttimefd=[[CTextField alloc]initWithFrame:CGRectMake(XW(rttimelb)+5, Y(rttimelb)+5, 100, 30)];
//    ViewBorderRadius(rttimefd, 2, 1, [SingleObj defaultManager].lineColor);
//    rttimefd.delegate=self;
//    rttimefd.placeholder=@"选择回复时间";
//    rttimefd.font=Font(14);
//    [dealviews addSubview:rttimefd];
//    //line
//    UILabel *fourline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(rttimelb), W(msgpromptView), 1)];
//    [fourline setBackgroundColor:[SingleObj defaultManager].lineColor];
//    [dealviews addSubview:fourline];
//    dealviews.frame=CGRectMake(X(dealviews), Y(dealviews), W(dealviews), YH(fourline));
//
    intjxlz=@"1";
    typeviews=[[UIView alloc]initWithFrame:CGRectMake(X(msgpromptView), YH(msgpromptView), W(msgpromptView), 10)];
    [typeviews setBackgroundColor:[UIColor whiteColor]];
    [mainscr addSubview:typeviews];
    UILabel *typelb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msglb))];
    typelb.text=@"转交类型:";
    typelb.font=Font(14);
    typelb.textColor=[SingleObj defaultManager].mainColor;
    [typeviews addSubview:typelb];
    QRadioButton *typeqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"type"];
    typeqr.tag=1000;
    
    [typeqr setTitle:@"纸件" forState:0];
    typeqr.frame=CGRectMake(XW(typelb)+5, Y(typelb), 60,H(typelb));
    [typeviews addSubview:typeqr];
    
    QRadioButton *typeqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"type"];
    typeqr1.tag=1001;
    typeqr1.checked=YES;
    [typeqr1 setTitle:@"电子件" forState:0];
    typeqr1.frame=CGRectMake(XW(typeqr)+10, Y(typelb), 70,H(typelb));
    [typeviews addSubview:typeqr1];
    //line
    UILabel *fiveline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(typelb), W(msgpromptView), 1)];
    [fiveline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [typeviews addSubview:fiveline];
    
    UILabel *dblb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(fiveline), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(typelb))];
    dblb.text=@"是否督办:";
    dblb.font=Font(14);
    dblb.textColor=[SingleObj defaultManager].mainColor;
    [typeviews addSubview:dblb];
    QRadioButton *dbqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"db"];
    [dbqr setTitle:@"督办" forState:0];
    dbqr.tag=1000;
    dbqr.frame=CGRectMake(XW(dblb)+5, Y(dblb), 60,H(dblb));
    [typeviews addSubview:dbqr];
    
    QRadioButton *dbqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"db"];
    [dbqr1 setTitle:@"不督办" forState:0];
    dbqr1.tag=1001;
    dbqr1.checked=YES;
    dbqr1.frame=CGRectMake(XW(dbqr)+10, Y(dblb), 70,H(typelb));
    [typeviews addSubview:dbqr1];
    
    //line
    UILabel *seaveline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(dblb), W(msgpromptView), 1)];
    [seaveline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [typeviews addSubview:seaveline];
    
    
//    UILabel *nblclb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(seaveline), [@"交出内部流程:" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(typelb))];
//    nblclb.text=@"交出内部流程:";
//    nblclb.font=Font(14);
//    nblclb.textColor=[SingleObj defaultManager].mainColor;
//    [typeviews addSubview:nblclb];
//    QRadioButton *rblcqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"rblc"];
//    [rblcqr setTitle:@"交出" forState:0];
//    rblcqr.tag=1000;
//    rblcqr.frame=CGRectMake(XW(nblclb)+5, Y(nblclb), 60,H(nblclb));
//    [typeviews addSubview:rblcqr];
//    
//    QRadioButton *rblcqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"rblc"];
//    [rblcqr1 setTitle:@"不交出" forState:0];
//    rblcqr1.tag=1001;
//    rblcqr1.checked=YES;
//    rblcqr1.frame=CGRectMake(XW(rblcqr)+10, Y(nblclb), 70,H(nblclb));
//    [typeviews addSubview:rblcqr1];
//    
//    //line
//    UILabel *line11=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(nblclb), W(msgpromptView), 1)];
//    [line11 setBackgroundColor:[SingleObj defaultManager].lineColor];
//    [typeviews addSubview:line11];
    lcxx=@"0";
    UILabel *zjyjlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(seaveline), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    zjyjlb.text=@"转交意见:";
    zjyjlb.font=Font(14);
    zjyjlb.textColor=[SingleObj defaultManager].mainColor;
    [typeviews addSubview:zjyjlb];
    zjrytv=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(XW(zjyjlb)+5, Y(zjyjlb)+5, W(msgpromptView)-(XW(zjyjlb)+10), 70)];
    zjrytv.placeholder=@"请输入转交意见";
    zjrytv.font=Font(14);
    ViewBorderRadius(zjrytv, 2, 1, [SingleObj defaultManager].mainColor);
    [typeviews addSubview:zjrytv];
    
    //line
    UILabel *eightline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(zjrytv)+5, W(msgpromptView), 1)];
    [eightline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [typeviews addSubview:eightline];
    //选择人员
    UILabel *xzrylb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(eightline), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    xzrylb.text=@"选择单位:";
    xzrylb.font=Font(14);
    xzrylb.textColor=[SingleObj defaultManager].mainColor;
    [typeviews addSubview:xzrylb];
    NSString *str=@"请点击选择单位";
    UIButton *buttons=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttons setTitle:str forState:UIControlStateNormal];
    buttons.titleLabel.numberOfLines=3;
    buttons.frame=CGRectMake(X(xzrylb), YH(xzrylb), W(msgpromptView)-2*X(xzrylb), [str sizeWithAttributes:@{NSFontAttributeName:Font(14)}].height+15);
    buttons.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [buttons addTarget:self action:@selector(chooseSEL:) forControlEvents:UIControlEventTouchUpInside];
    [buttons setTitleColor:[UIColor blackColor] forState:0];
    buttons.titleLabel.font=Font(14);
    [typeviews addSubview:buttons];
    [typeviews addSubview:zjrytv];
    hight=0;
    if (getselectary.count>0) {
        //line
        UILabel *eight1line=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(buttons)+5, W(msgpromptView), 1)];
        [eight1line setBackgroundColor:[SingleObj defaultManager].lineColor];
        [typeviews addSubview:eight1line];
        hight+=1;
        //已选择人员
        UILabel *yxzrylb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(eight1line), [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
        yxzrylb.text=@"已选单位:";
        yxzrylb.font=Font(14);
        yxzrylb.textColor=[SingleObj defaultManager].mainColor;
        [typeviews addSubview:yxzrylb];
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(XW(yxzrylb)+5, Y(yxzrylb), W(typeviews)-(XW(yxzrylb)+10), H(yxzrylb))];
        lb.font=Font(14);
        lb.numberOfLines=0;
        [typeviews addSubview:lb];
        NSMutableString *getselestring=[NSMutableString string];
        for (NSDictionary *getselecdic in getselectary) {
            [getselestring appendFormat:@"%@,",[getselecdic objectForKey:@"strdwjc"]];
        }
        NSString *getseelestr=[getselestring substringToIndex:getselestring.length-1];
        lb.text=getseelestr;
        CGSize lbsize=[lb.text sizeWithFont:lb.font constrainedToSize:CGSizeMake(W(lb), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        lb.frame=CGRectMake(X(lb), Y(lb), W(lb), lbsize.height>40?lbsize.height:40);
        hight+=H(lb);
    }
    typeviews.frame=CGRectMake(X(typeviews), Y(typeviews), W(typeviews), hight+YH(buttons));
    [mainscr setContentSize:CGSizeMake(W(mainscr), YH(typeviews)+20)];
    needbackqr1.checked=YES;
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    
    if ([groupId isEqualToString:@"msg"]) {//短信提示
        if (radio.checked) {
            if (radio.tag==1000) {
               strsmsset=@"1";
            }
            else if (radio.tag==1001)
            {
                 strsmsset=@"0";
            }
        }
    }else if ([groupId isEqualToString:@"circulation"]) {//公文流转
        if (radio.checked) {
            if (radio.tag==1000) {
                intjxlz=@"1";
                needbackqr1.userInteractionEnabled=YES;
            }
            else if (radio.tag==1001)
            {
                 intjxlz=@"0";
                needbackqr.checked=YES;
                needbackqr1.userInteractionEnabled=NO;
            }
        }

    }
    else if ([groupId isEqualToString:@"needback"]) {//要求返回
        if (radio.tag==1000) {
            dealviews.hidden=NO;
            typeviews.frame=CGRectMake(X(typeviews), YH(dealviews), W(typeviews), H(typeviews));
            strsfyqfsyjbz=@"1";
        }
        else if (radio.tag==1001)
        {
            dealviews.hidden=YES;
            typeviews.frame=CGRectMake(X(typeviews), Y(dealviews), W(typeviews), H(typeviews));
            strsfyqfsyjbz=@"0";
        }
    }
    else if ([groupId isEqualToString:@"type"]) {//转交类型
        if (radio.tag==1000) {
            strisscbz=@"0";
        }
        else if (radio.tag==1001)
        {
            strisscbz=@"2";
        }
    }else if ([groupId isEqualToString:@"db"]) {//督办
        if (radio.tag==1000) {
            strdbbz=@"1";
        }
        else if (radio.tag==1001)
        {
            strdbbz=@"0";
        }
    }else if ([groupId isEqualToString:@"rblc"])//交出内部流程
    {
        if (radio.checked) {
            if (radio.tag==1000) {
                lcxx=@"1";
            }
            else if (radio.tag==1001)
            {
                lcxx=@"0";
            }
        }
    }

}
#pragma mark textfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField==rttimefd) {
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker.datePickerMode=UIDatePickerModeDate;
            datePicker.minimumDate=[NSDate date];
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
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:RGBCOLOR(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt addTarget:self action:@selector(pickercancelSEL:) forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
#pragma mark 选择开始时间
-(void)pickerStartDoneClicked:(UIButton*)obj{
    NSLog(@"%@",obj);
    [rttimefd resignFirstResponder];
    NSDate *date=[datePicker date];
    dtmyqhfsj=[Tools dateToStr:date andFormat:@"yyyy-MM-dd"];
    rttimefd.text=[Tools dateToStr:date andFormat:@"yyyy-MM-dd"];
}
-(void)pickercancelSEL:(id)obj
{
    NSLog(@"%@",obj);
    [rttimefd resignFirstResponder];
}

#pragma mark----------------------选择人员信息---------------
-(void)chooseSEL:(UIButton*)sender
{   
    LBChoosePersonViewController *lbChoosePerson=[[LBChoosePersonViewController alloc]init];
    lbChoosePerson.title=@"选择单位信息";
    lbChoosePerson.delegate=self;
    lbChoosePerson.lbs=sender;
    lbChoosePerson.type=@"部门";
    lbChoosePerson.gupid=@"单选";
    lbChoosePerson.qcheckary=nil;
    [self.navigationController pushViewController:lbChoosePerson animated:YES];
}
-(void)setZrrValue:(NSMutableArray *)value andid:(id)lbs andGupID:(NSString *)gupid
{
    qcheckary=[[NSMutableArray alloc]initWithArray:value];
    for (NSDictionary *dic in value) {
        for (NSDictionary *selectdic in getselectary) {
            if ([[selectdic objectForKey:@"strdwccbm"] intValue]==[[dic objectForKey:@"strdwccbm"] intValue]) {
                [qcheckary removeObject:dic];
            }
        }
    }
    UIButton *buttons=(UIButton*)lbs;
    if ([gupid isEqualToString:@"单选"]) {
        NSMutableString *zrrText=[NSMutableString string];
        strjsdwdzlst=[NSMutableString string];
        for (int i=0; i<qcheckary.count; i++) {
            [zrrText appendFormat:@"%@,",[[qcheckary objectAtIndex:i] objectForKey:@"strdwjc"]];
            [strjsdwdzlst appendFormat:@"%@,",[[qcheckary objectAtIndex:i] objectForKey:@"strdz"]];
        }
        if (qcheckary.count!=0) {
            zrrText=[zrrText substringToIndex:zrrText.length-1];
            strjsdwdzlst=[strjsdwdzlst substringToIndex:strjsdwdzlst.length-1];
        }
        buttons.frame=CGRectMake(X(buttons), Y(buttons), W(buttons), H(buttons));
        strjsdwmclst=zrrText;
        [buttons setTitle:zrrText forState:0];
        typeviews.frame=CGRectMake(X(typeviews), Y(typeviews), W(typeviews), hight+YH(buttons)+10);
        [mainscr setContentSize:CGSizeMake(W(mainscr), YH(typeviews)+20)];
    }
}
#pragma mark-----------------提交----------------------
-(void)submitSEL{
    
    if (zjrytv.text.length==0) {
        [Tools showMsgBox:@"请输入转交意见"];
        return;
    }else if ([Tools isBlankString:strjsdwmclst])
    {
        [Tools showMsgBox:@"请选择单位"];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork swConference:[_savedic objectForKey:@"intbzjllsh"] intfsdwlsh:[_savedic objectForKey:@"intfsdwlsh"] intfwdwlsh:[_savedic objectForKey:@"intfwdwlsh"] strfsrdwmc:[_savedic objectForKey:@"strfsrdwmc"] intxtsessionlsh:[_savedic objectForKey:@"intxtsessionlsh"] strjsdwmclst:strjsdwmclst intjxlz:intjxlz strmjlst:[_savedic objectForKey:@"strmjlst"] strczrxm:[_savedic objectForKey:@"strczrxm"] strjsdwdzlst:strjsdwdzlst strsmsset:strsmsset strsfyqfsyjbz:@"1" dtmyqhfsj:dtmyqhfsj.length==0?@"":dtmyqhfsj strisscbz:strisscbz strdbbz:strdbbz lcxx:lcxx strfsdwyj:zjrytv.text completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                 [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"提交失败"];
            }
            
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }];
}
-(void)gogo
{
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
