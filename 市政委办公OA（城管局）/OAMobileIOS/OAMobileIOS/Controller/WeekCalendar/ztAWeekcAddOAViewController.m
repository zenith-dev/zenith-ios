//
//  ztAWeekcAddOAViewController.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztAWeekcAddOAViewController.h"
#import "ztOATextField.h"
#import "ztWeekCalendarOAViewController.h"
@interface ztAWeekcAddOAViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIDatePicker  *datePicker;
    UIDatePicker  *datePicker2;
    UIDatePicker  *datePicker3;
}
@property(nonatomic,strong)ztOATextField *rqtf;//日期
@property(nonatomic,strong)ztOATextField *kssjtf;//开始时间
@property(nonatomic,strong)ztOATextField *jssjtf;//结束时间
@property(nonatomic,strong)UITextView *nrtv;//内容
@property(nonatomic, strong) UILabel  *textViewPlaceHolderLab;
@property(nonatomic,strong)UIButton *savebtn;//保存按钮
@end

@implementation ztAWeekcAddOAViewController
#pragma mark----------------Getter-------------
-(ztOATextField*)rqtf
{
    if (!_rqtf) {
        _rqtf=[[ztOATextField alloc]init];
        _rqtf.font=Font(14);
        _rqtf.delegate=self;
        _rqtf.placeholder=@"请选择日期";
        ViewBorderRadius(_rqtf, 2, 1, MF_ColorFromRGB(220, 220, 220));
    }
    return _rqtf;
}
-(ztOATextField*)kssjtf
{
    if (!_kssjtf) {
        _kssjtf=[[ztOATextField alloc]init];
        _kssjtf.font=Font(14);
        _kssjtf.delegate=self;
        _kssjtf.placeholder=@"请选择开始时间";
        ViewBorderRadius(_kssjtf, 2, 1, MF_ColorFromRGB(220, 220, 220));
    }
    return _kssjtf;
}
-(ztOATextField*)jssjtf
{
    if (!_jssjtf) {
        _jssjtf=[[ztOATextField alloc]init];
        _jssjtf.font=Font(14);
        _jssjtf.delegate=self;
        _jssjtf.placeholder=@"请选择结束时间";
        ViewBorderRadius(_jssjtf, 2, 1, MF_ColorFromRGB(220, 220, 220));
    }
    return _jssjtf;
}
-(UITextView*)nrtv
{
    if (!_nrtv) {
        _nrtv=[[UITextView alloc]init];
        _nrtv.font=Font(14);
        _nrtv.delegate=self;
        ViewBorderRadius(_nrtv, 4, 1, MF_ColorFromRGB(220, 220, 220));
    }
    return _nrtv;
}
-(UIButton*)savebtn
{
    if (!_savebtn) {
        _savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_savebtn setTitle:@"保 存" forState:UIControlStateNormal];
        _savebtn.titleLabel.font=Font(14);
        [_savebtn addTarget:self action:@selector(saveSEL:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _savebtn;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initview];
    // Do any additional setup after loading the view.
}
#pragma mark--------------initview------------
-(void)initview
{
    UIScrollView *src=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    NSString *strriq=@"日期:";
    UILabel *rq=[[UILabel alloc]initWithFrame:CGRectMake(5, 15,[strriq sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 30)];
    rq.text=@"日期:";
    rq.font=Font(14);
    [src addSubview:rq];
    self.rqtf.frame=CGRectMake(rq.right+5,rq.top , self.view.width-rq.right-10, rq.height);
    [src addSubview:self.rqtf];
    self.rqtf.text=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:self.strrq andFormat:@"yyyy年MM月dd日"] andFormat:@"yyyy-MM-dd"];
    UIImageView *al=[[UIImageView alloc]initWithFrame:CGRectMake(self.rqtf.width-30, (self.rqtf.height-24)/2.0, 24, 24)];
    [al setImage:PNGIMAGE(@"icon_arrow_down")];
    [self.rqtf addSubview:al];
    
    //时间
    UILabel *js=[[UILabel alloc]initWithFrame:CGRectMake(X(rq), rq.bottom+10, rq.width, rq.height)];
    js.text=@"时间:";
    js.font=Font(14);
    [src addSubview:js];
    
    self.kssjtf.frame=CGRectMake(js.right+5, js.top, (self.view.width-js.right-10-30)/2.0, js.height);
    [src addSubview:self.kssjtf];
    self.kssjtf.text=@"09:00";
    UILabel *zlb=[[UILabel alloc]initWithFrame:CGRectMake(self.kssjtf.right, js.top, 30, js.height)];
    zlb.textAlignment=NSTextAlignmentCenter;
    zlb.font=Font(14);
    zlb.text=@"至";
    [src addSubview:zlb];
    self.jssjtf.frame=CGRectMake(zlb.right, js.top, self.kssjtf.width, self.kssjtf.height);
    [src addSubview:self.jssjtf];
    
    //内容
    UILabel *nr=[[UILabel alloc]initWithFrame:CGRectMake(X(js), js.bottom+10, js.width, js.height)];
    nr.text=@"内容:";
    nr.font=Font(14);
    [src addSubview:nr];
    self.nrtv.frame=CGRectMake(nr.right+5, nr.top, self.rqtf.width, 90);
    [src addSubview:self.nrtv];
    [self.view addSubview:src];
    self.textViewPlaceHolderLab = [[UILabel alloc] initWithFrame:CGRectMake( 8, 6, 240, 20)];
    [self.textViewPlaceHolderLab setTextColor:[UIColor lightGrayColor]];
    [self.textViewPlaceHolderLab setBackgroundColor:[UIColor clearColor]];
    [self.textViewPlaceHolderLab setFont:[UIFont systemFontOfSize:14]];
    [self.textViewPlaceHolderLab setTextAlignment:NSTextAlignmentLeft];
    [self.textViewPlaceHolderLab setText:@"请输入日程内容（250字以内）"];
    [self.nrtv addSubview:self.textViewPlaceHolderLab];
    self.savebtn.frame=CGRectMake(20, self.nrtv.bottom+30, self.view.width-40, 30);
    [self.savebtn bootstrapNoborderStyle:MF_ColorFromRGB(72, 171, 68) titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
    ViewRadius(self.savebtn, 4);
    [src addSubview:self.savebtn];
    
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text == nil || [textView.text isEqualToString:@""]) {
        [self.textViewPlaceHolderLab setHidden:NO];
    } else{
        [self.textViewPlaceHolderLab setHidden:YES];
    }
}

- (BOOL)textView: (UITextView *)textview shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textview resignFirstResponder];
    }
    return YES;
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
#pragma mark textfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField==self.rqtf) {
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        }
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePicker.date=[ztOASmartTime strToDate1:[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:self.strrq andFormat:@"yyyy年MM月dd日"] andFormat:@"yyyy-MM-dd"] andFormat:@"yyyy-MM-dd"];
        textField.inputView = datePicker;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        if (textField==self.rqtf) {
            okbt.tag=1000;
        }
        else if(textField==self.kssjtf)
        {
            okbt.tag=1001;
        }
        else if (textField==self.jssjtf)
        {
            okbt.tag=1002;
        }
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt addTarget:self action:@selector(pickercancelSEL:) forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
    else if (textField==self.kssjtf)
    {
        if (!datePicker2) {
            datePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker2.backgroundColor=[UIColor lightGrayColor];
            [datePicker2 sizeToFit];
            datePicker2.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker2.datePickerMode=UIDatePickerModeTime;
        }
        if (self.kssjtf.text.length>0) {
            datePicker2.date=[ztOASmartTime strToDate1:self.kssjtf.text andFormat:@"HH:mm"];
        }
        else
        {
            datePicker2.date=[ztOASmartTime strToDate1:@"09:00" andFormat:@"HH:mm"];
        }
        if (self.jssjtf.text.length>0) {
            datePicker2.maximumDate=[ztOASmartTime strToDate1:self.jssjtf.text andFormat:@"HH:mm"];
        }
        textField.inputView = datePicker2;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        if (textField==self.rqtf) {
            okbt.tag=1000;
        }
        else if(textField==self.kssjtf)
        {
            okbt.tag=1001;
        }
        else if (textField==self.jssjtf)
        {
            okbt.tag=1002;
        }
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt addTarget:self action:@selector(pickercancelSEL:) forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }else if (textField==self.jssjtf)
    {
        if (!datePicker3) {
            datePicker3 = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker3.backgroundColor=[UIColor lightGrayColor];
            [datePicker3 sizeToFit];
            datePicker3.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker3.datePickerMode=UIDatePickerModeTime;
        }
        if (self.jssjtf.text.length>0) {
            datePicker3.date=[ztOASmartTime strToDate1:self.jssjtf.text andFormat:@"HH:mm"];
        }
        else
        {
            datePicker3.date=[ztOASmartTime strToDate1:@"18:00" andFormat:@"HH:mm"];
        }
        if (self.kssjtf.text.length>0) {
            datePicker3.minimumDate=[ztOASmartTime strToDate1:self.kssjtf.text andFormat:@"HH:mm"];
        }
        textField.inputView = datePicker3;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        okbt.tag=1002;
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
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
    if (obj.tag==1000) {
        [self.rqtf resignFirstResponder];
        NSDate *date=[datePicker date];
        self.rqtf.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
    }
    else if (obj.tag==1001)
    {
        [self.kssjtf resignFirstResponder];
        NSDate *date=[datePicker2 date];
        self.kssjtf.text=[ztOASmartTime dateToStr:date andFormat:@"HH:mm"];
    }
    else if (obj.tag==1002)
    {
        [self.jssjtf resignFirstResponder];
        NSDate *date=[datePicker3 date];
        self.jssjtf.text=[ztOASmartTime dateToStr:date andFormat:@"HH:mm"];
    }
}
-(void)pickercancelSEL:(id)obj
{
    [self.rqtf resignFirstResponder];
    [self.kssjtf resignFirstResponder];
    [self.jssjtf resignFirstResponder];
}
#pragma mark------------------保存--------------
-(void)saveSEL:(UIButton*)sender
{
    if (self.rqtf.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择日期"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (self.kssjtf.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择开始时间"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if (self.nrtv.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入日程内容"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *searchDic= [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",self.rqtf.text,self.kssjtf.text],@"dtmkssj",[NSString stringWithFormat:@"%@ %@",self.rqtf.text,self.jssjtf.text],@"dtmjssj",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",self.nrtv.text?:@"" ]],@"rcnr",[self.ldxx objectForKey:@"chrldxm"],@"chrldxm",[self.ldxx objectForKey:@"intldid"],@"intldid",[ztOAGlobalVariable sharedInstance].username,@"chrlrrxm",[ztOAGlobalVariable sharedInstance].intrylsh,@"intlrrid",nil];
    [self showWaitView];
    [ztOAService addRcxx:searchDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *resultInfo = [result objectFromJSONData];
        NSLog(@"list=%@",[resultInfo JSONString]);
        if ((resultInfo!=nil) && [[[resultInfo objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交成功！"];
            [alert addButtonWithTitle:@"确定" handler:^(void){
                for (id viewControllers in self.navigationController.viewControllers) {
                    if ([viewControllers isKindOfClass:[ztWeekCalendarOAViewController class]]) {
                        ztWeekCalendarOAViewController *vi=(ztWeekCalendarOAViewController*)viewControllers;
                        [vi updata];
                        [self.navigationController popToViewController:vi animated:YES];
                    }
                }
            }];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

        
    } Failed:^(NSError *error) {
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
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
