//
//  ztWeekcUpdateViewController.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/9.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztWeekcUpdateViewController.h"
#import "ztOATextField.h"
#import "ztWeekCalendarOAViewController.h"
@interface ztWeekcUpdateViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIDatePicker  *datePicker;
    UIDatePicker  *datePicker2;
    BOOL isEnabled;//是否可以编辑
}
@property(nonatomic,strong)ztOATextField *rqtf;//日期
@property(nonatomic,strong)ztOATextField *kssjtf;//开始时间
@property(nonatomic,strong)ztOATextField *jssjtf;//结束时间
@property(nonatomic,strong)UITextView *nrtv;//内容
@property(nonatomic, strong) UILabel  *textViewPlaceHolderLab;
@property(nonatomic,strong)UIButton *delebtn;//删除按钮
@property(nonatomic,strong)UIButton *upbtn;//修改按钮
@property(nonatomic,strong)UIButton *canclebtn;//取消按钮

@end

@implementation ztWeekcUpdateViewController
#pragma mark----------------Getter-------------
-(ztOATextField*)rqtf
{
    if (!_rqtf) {
        _rqtf=[[ztOATextField alloc]init];
        _rqtf.font=Font(14);
        _rqtf.delegate=self;
        _rqtf.userInteractionEnabled=NO;
        _rqtf.backgroundColor=MF_ColorFromRGB(240, 240, 240);
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
-(UIButton*)delebtn
{
    if (!_delebtn) {
        _delebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _delebtn.frame=CGRectMake(0, 0, 60, 30);
        [_delebtn bootstrapNoborderStyle:[UIColor redColor] titleColor:[UIColor whiteColor] andbtnFont:Font(13)];
        [_delebtn addTarget:self action:@selector(deleSEL:) forControlEvents:UIControlEventTouchUpInside];
        [_delebtn setTitle:@"删除日程" forState:UIControlStateNormal];
    }
    return _delebtn;
}
-(UIButton*)upbtn
{
    if (!_upbtn) {
        _upbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _upbtn.frame=CGRectMake(0, 0, 60, 30);
        [_upbtn bootstrapNoborderStyle:MF_ColorFromRGB(71, 170, 69) titleColor:[UIColor whiteColor] andbtnFont:Font(13)];
        [_upbtn addTarget:self action:@selector(upSEL:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upbtn;
}
-(UIButton*)canclebtn
{
    if (!_canclebtn) {
        _canclebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _canclebtn.frame=CGRectMake(0, 0, 60, 30);
        [_canclebtn bootstrapNoborderStyle:MF_ColorFromRGB(242, 154, 39) titleColor:[UIColor whiteColor] andbtnFont:Font(13)];
        [_canclebtn addTarget:self action:@selector(cancleSEL:) forControlEvents:UIControlEventTouchUpInside];
        [_canclebtn setTitle:@"取  消" forState:UIControlStateNormal];
    }
    return _canclebtn;
}
#pragma mark--------------initview------------
-(void)initview
{
    isEnabled=NO;
    UIScrollView *src=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    NSString *strriq=@"日期:";
    UILabel *rq=[[UILabel alloc]initWithFrame:CGRectMake(5, 15,[strriq sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 30)];
    rq.text=@"日期:";
    rq.font=Font(14);
    [src addSubview:rq];
    self.rqtf.frame=CGRectMake(rq.right+5,rq.top , self.view.width-rq.right-10, rq.height);
    [src addSubview:self.rqtf];
    self.rqtf.text=self.strrq;
    //时间
    UILabel *js=[[UILabel alloc]initWithFrame:CGRectMake(X(rq), rq.bottom+10, rq.width, rq.height)];
    js.text=@"时间:";
    js.font=Font(14);
    [src addSubview:js];
    
    self.kssjtf.frame=CGRectMake(js.right+5, js.top, (self.view.width-js.right-10-30)/2.0, js.height);
    [src addSubview:self.kssjtf];
    
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
    //删除按钮
    if (isEnabled==NO) {
        self.delebtn.frame=CGRectMake(20, self.nrtv.bottom+20, (self.view.width-40-10)/2.0, 30);
        self.upbtn.frame=CGRectMake(self.delebtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        [self.upbtn setTitle:@"修  改" forState:UIControlStateNormal];
        self.canclebtn.hidden=YES;
        self.kssjtf.userInteractionEnabled=NO;
        self.jssjtf.userInteractionEnabled=NO;
        self.nrtv.userInteractionEnabled=NO;
        self.kssjtf.backgroundColor=MF_ColorFromRGB(240, 240, 240);
        self.jssjtf.backgroundColor=MF_ColorFromRGB(240, 240, 240);
        self.nrtv.backgroundColor=MF_ColorFromRGB(240, 240, 240);
    }
    else
    {
        self.delebtn.frame=CGRectMake(20, self.nrtv.bottom+20, (self.view.width-40-20)/3.0, 30);
         self.upbtn.frame=CGRectMake(self.delebtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        self.canclebtn.frame=CGRectMake(self.upbtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        [self.upbtn setTitle:@"保  存" forState:UIControlStateNormal];
        self.canclebtn.hidden=NO;
        self.kssjtf.userInteractionEnabled=YES;
        self.jssjtf.userInteractionEnabled=YES;
        self.nrtv.userInteractionEnabled=YES;
        self.kssjtf.backgroundColor=[UIColor whiteColor];
        self.jssjtf.backgroundColor=[UIColor whiteColor];
        self.nrtv.backgroundColor=[UIColor whiteColor];
        
    }
    [src addSubview:self.delebtn];
    [src addSubview:self.upbtn];
    [src addSubview:self.canclebtn];
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
    
    if (textField==self.kssjtf)
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
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker.datePickerMode=UIDatePickerModeTime;
        }
        if (self.jssjtf.text.length>0) {
            datePicker.date=[ztOASmartTime strToDate1:self.jssjtf.text andFormat:@"HH:mm"];
        }
        else
        {
            datePicker.date=[ztOASmartTime strToDate1:@"18:00" andFormat:@"HH:mm"];
        }
        if (self.kssjtf.text.length>0) {
            datePicker.minimumDate=[ztOASmartTime strToDate1:self.kssjtf.text andFormat:@"HH:mm"];
        }
        textField.inputView = datePicker;
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
    if (obj.tag==1001)
    {
        [self.kssjtf resignFirstResponder];
        NSDate *date=[datePicker2 date];
        self.kssjtf.text=[ztOASmartTime dateToStr:date andFormat:@"HH:mm"];
    }
    else if (obj.tag==1002)
    {
        [self.jssjtf resignFirstResponder];
        NSDate *date=[datePicker date];
        self.jssjtf.text=[ztOASmartTime dateToStr:date andFormat:@"HH:mm"];
    }
}
-(void)pickercancelSEL:(id)obj
{
    [self.rqtf resignFirstResponder];
    [self.kssjtf resignFirstResponder];
    [self.jssjtf resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    self.nrtv.text=[NSString stringWithFormat:@"%@",[self.weekxxdic objectForKey:@"chrrcnr"]];
    [self.textViewPlaceHolderLab setHidden:YES];
    self.kssjtf.text=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:[self.weekxxdic objectForKey:@"dtmkssj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"HH:mm"];
    self.jssjtf.text=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:[self.weekxxdic objectForKey:@"dtmjssj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"HH:mm"];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark-------------取消---------------
-(void)cancleSEL:(UIButton*)sender
{
    isEnabled=!isEnabled;
    //删除按钮
    if (isEnabled==NO) {
        self.delebtn.frame=CGRectMake(20, self.nrtv.bottom+20, (self.view.width-40-10)/2.0, 30);
        self.upbtn.frame=CGRectMake(self.delebtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        [self.upbtn setTitle:@"修  改" forState:UIControlStateNormal];
        self.canclebtn.hidden=YES;
        self.kssjtf.userInteractionEnabled=NO;
        self.jssjtf.userInteractionEnabled=NO;
        self.nrtv.userInteractionEnabled=NO;
        self.kssjtf.backgroundColor=MF_ColorFromRGB(240, 240, 240);
        self.jssjtf.backgroundColor=MF_ColorFromRGB(240, 240, 240);
        self.nrtv.backgroundColor=MF_ColorFromRGB(240, 240, 240);
    }
    else
    {
        self.delebtn.frame=CGRectMake(20, self.nrtv.bottom+20, (self.view.width-40-20)/3.0, 30);
        self.upbtn.frame=CGRectMake(self.delebtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        self.canclebtn.frame=CGRectMake(self.upbtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        [self.upbtn setTitle:@"保  存" forState:UIControlStateNormal];
        self.canclebtn.hidden=NO;
        self.kssjtf.userInteractionEnabled=YES;
        self.jssjtf.userInteractionEnabled=YES;
        self.nrtv.userInteractionEnabled=YES;
        self.kssjtf.backgroundColor=[UIColor whiteColor];
        self.jssjtf.backgroundColor=[UIColor whiteColor];
        self.nrtv.backgroundColor=[UIColor whiteColor];
    }

}
#pragma mark------------修改或保存----------
-(void)upSEL:(UIButton*)sender
{
    if (isEnabled==NO) {
        isEnabled=YES;
        self.delebtn.frame=CGRectMake(20, self.nrtv.bottom+20, (self.view.width-40-20)/3.0, 30);
        self.upbtn.frame=CGRectMake(self.delebtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        self.canclebtn.frame=CGRectMake(self.upbtn.right+10, self.delebtn.top, self.delebtn.width, self.delebtn.height);
        [self.upbtn setTitle:@"保  存" forState:UIControlStateNormal];
        self.canclebtn.hidden=NO;
        self.kssjtf.userInteractionEnabled=YES;
        self.jssjtf.userInteractionEnabled=YES;
        self.nrtv.userInteractionEnabled=YES;
        self.kssjtf.backgroundColor=[UIColor whiteColor];
        self.jssjtf.backgroundColor=[UIColor whiteColor];
        self.nrtv.backgroundColor=[UIColor whiteColor];
    }
    else
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
        NSDictionary *searchDic= [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",self.rqtf.text,self.kssjtf.text],@"dtmkssj",[NSString stringWithFormat:@"%@ %@",self.rqtf.text,self.jssjtf.text],@"dtmjssj",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",self.nrtv.text?:@"" ]],@"rcnr",[self.weekxxdic objectForKey:@"intrcid"],@"intrcxxlsh",nil];
        [self showWaitView];
        [ztOAService updateRcxx:searchDic Success:^(id result) {
            [self closeWaitView];
            NSDictionary *resultInfo = [result objectFromJSONData];
            NSLog(@"list=%@",[resultInfo JSONString]);
            if ((resultInfo!=nil) && [[[resultInfo objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"修改成功！"];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
        
        
    }

}
#pragma mark------------删除日程--------------
-(void)deleSEL:(UIButton*)sender
{
   
    NSDictionary *searchDic= [[NSDictionary alloc] initWithObjectsAndKeys:[self.weekxxdic objectForKey:@"intrcid"],@"intrcxxlsh",nil];
    [self showWaitView];
    [ztOAService deleteRcxx:searchDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *resultInfo = [result objectFromJSONData];
        NSLog(@"list=%@",[resultInfo JSONString]);
        if ((resultInfo!=nil) && [[[resultInfo objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除成功！"];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
