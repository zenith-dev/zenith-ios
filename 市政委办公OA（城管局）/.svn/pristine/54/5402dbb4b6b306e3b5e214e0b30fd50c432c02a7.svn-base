//
//  ZtOAPopView.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/10/25.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ZtOAPopView.h"
#import "CTextField.h"
#import "BlocksKit.h"
#import "ztOASmartTime.h"
@interface ZtOAPopView()<UITextFieldDelegate>
@property (nonatomic,strong) UIDatePicker  *datePicker;
@property (nonatomic,strong)CTextField *timetf;
@property (nonatomic,strong)UITextView *xxtv;
@property (nonatomic,strong)UIView *view_userContact;
@end
@implementation ZtOAPopView
@synthesize view_userContact,timetf,xxtv,datePicker;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=MF_ColorFromRGBA(0, 0, 0, 0.4);
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=frame;
        [closeBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        view_userContact=[[UIView alloc]initWithFrame:CGRectMake(20, -300, kScreenWidth-40, 256)];
        view_userContact.backgroundColor=[UIColor whiteColor];
        view_userContact.layer.masksToBounds = YES;
        view_userContact.layer.cornerRadius =10;
        [self addSubview:view_userContact];
        UILabel *setlb=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 21)];
        setlb.text=@"督办信息设置";
        setlb.font=Font(14);
        [view_userContact addSubview:setlb];
        UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, setlb.bottom+5, view_userContact.width, 0.5)];
        [onelb setBackgroundColor:[UIColor lightGrayColor]];
        [view_userContact addSubview:onelb];
        
        UILabel *timelb=[[UILabel alloc]initWithFrame:CGRectMake(setlb.left, onelb.bottom+5, 65, 40)];
        timelb.text=@"督办时间";
        timelb.font=Font(13);
        [view_userContact addSubview:timelb];
        
        timetf =[[CTextField alloc]initWithFrame:CGRectMake(timelb.right+10, timelb.top, view_userContact.width-(timelb.right+10+20), timelb.height)];
        timetf.font=Font(13);
        timetf.delegate=self;
        ViewBorderRadius(timetf, 3, 1, MF_ColorFromRGB(220, 220, 220));
        timetf.placeholder=@"请选择督办时间";
        [view_userContact addSubview:timetf];
        
        timelb=[[UILabel alloc]initWithFrame:CGRectMake(setlb.left, timetf.bottom+15, 65, 40)];
        timelb.text=@"督办信息";
        timelb.font=Font(13);
        [view_userContact addSubview:timelb];
        
        xxtv =[[UITextView alloc]initWithFrame:CGRectMake(timetf.left, timelb.top, timetf.width, 80)];
        ViewBorderRadius(xxtv, 3, 1, MF_ColorFromRGB(220, 220, 220));
        [view_userContact addSubview:xxtv];
        
        UIButton *okbtn=[[UIButton alloc]initWithFrame:CGRectMake(30, xxtv.bottom+30, view_userContact.width-60, 40)];
        [okbtn bootstrapNoborderStyle:[UIColor colorWithRed:0.231 green:0.475 blue:0.914 alpha:1.00] titleColor:[UIColor whiteColor] andbtnFont:Font(13)];
        [okbtn setTitle:@"暂 存" forState:UIControlStateNormal];
        [view_userContact addSubview:okbtn];
        [okbtn  addTarget:self action:@selector(oksel) forControlEvents:UIControlEventTouchUpInside];
        view_userContact.height=okbtn.bottom+20;
    }
    return self;
}
#pragma mark-----------取消按钮-------------
-(void)closeButtonClicked{
    [self hidden];
}
#pragma mark------------显示视图------------------
-(void)show:(UIView*)subview;
{
    [subview addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                         view_userContact.top=(kScreenHeight-view_userContact.height)/2.0+20;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark------------隐藏显示------------------
- (void)hidden
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view_userContact.top= -H(view_userContact);
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         
                     }];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!datePicker) {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
        datePicker.backgroundColor=[UIColor lightGrayColor];
        [datePicker sizeToFit];
        datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    datePicker.datePickerMode=UIDatePickerModeDate;
    textField.inputView = datePicker;
    datePicker.minimumDate=[NSDate date];
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
    [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
    [okbt setTitle:@"确定" forState:UIControlStateNormal];
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
#pragma mark 选择开始时间
-(void)pickerStartDoneClicked:(UIButton*)obj{
    [timetf resignFirstResponder];
    NSDate *date=[datePicker date];
    timetf.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
}
-(void)pickercancelSEL:(id)obj
{
    [timetf resignFirstResponder];
}
-(void)oksel{
    if (timetf.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择督办时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else if (xxtv.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入督办信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.callback) {
        self.callback(@{@"time":timetf.text,@"xx":xxtv.text});
    }
    [self hidden];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
