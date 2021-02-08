//
//  ztOAFeedbackViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-3.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAFeedbackViewController.h"
#define  TEXT_FILED_HEIGHT 28

@interface ztOAFeedbackViewController ()
@property(nonatomic, strong) UITextView     *suggestionTextView;
@property(nonatomic, strong) UITextField    *contactTextFiled;
@property(nonatomic, strong) UILabel        *textViewPlaceHolderLab;
@end

@implementation ztOAFeedbackViewController
@synthesize suggestionTextView, contactTextFiled, textViewPlaceHolderLab;

- (id)init
{
    self = [super init ];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightButton:@"提交" imagen:nil imageh:nil sel:@selector(doSend:)];
     contactTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, 64+10, kScreenWidth-20, TEXT_FILED_HEIGHT)];
    contactTextFiled.delegate = self;
    [contactTextFiled setFont:[UIFont systemFontOfSize:15]];
    [contactTextFiled setReturnKeyType:UIReturnKeyDone];
    [contactTextFiled setTextAlignment:NSTextAlignmentLeft];
    [contactTextFiled setBorderStyle:UITextBorderStyleRoundedRect];
    [contactTextFiled setPlaceholder:@"请输入您的邮箱地址"];
    [self.view addSubview:contactTextFiled];
    
    self.suggestionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, YH(contactTextFiled)+20, self.view.width-20, 80)];
    [suggestionTextView becomeFirstResponder];
    [suggestionTextView setDelegate:self];
    [suggestionTextView setReturnKeyType:UIReturnKeyDone];
    [suggestionTextView setFont:[UIFont systemFontOfSize:15]];
    [suggestionTextView setBackgroundColor:[UIColor clearColor]];
    ViewBorderRadius(suggestionTextView, 4, 1, MF_ColorFromRGB(230, 230, 230));
    [self.view addSubview:suggestionTextView];
    
    self.textViewPlaceHolderLab = [[UILabel alloc] initWithFrame:CGRectMake( 8, 6, 240, 20)];
    [textViewPlaceHolderLab setTextColor:[UIColor lightGrayColor]];
    [textViewPlaceHolderLab setBackgroundColor:[UIColor clearColor]];
    [textViewPlaceHolderLab setFont:[UIFont systemFontOfSize:15]];
    [textViewPlaceHolderLab setTextAlignment:NSTextAlignmentLeft];
    [textViewPlaceHolderLab setText:@"请在此输入您要提的建议或意见"];
    [suggestionTextView addSubview:textViewPlaceHolderLab];
    
}
#pragma mark UITextFiled Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark UITextView Delegate Method
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
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

- (void)doSend:(id)sender{
    if (suggestionTextView.text == nil || [suggestionTextView.text isEqualToString:@""]) {
        UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"请输入反馈信息！"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    } else if (contactTextFiled.text == nil || [contactTextFiled.text isEqualToString:@""]){
        UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"请输入您的邮箱！"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
    } else{
        if (![self isValidateRegularExpression:contactTextFiled.text]) {
            UIAlertView *alert = [UIAlertView alertWithTitle:@"提示" message:@"对不起，您输入的邮箱格式错误，请检查后重新输入！"];
            [alert addButtonWithTitle:@"确定"];
            [alert show];
        } else{
            [suggestionTextView resignFirstResponder];
            [contactTextFiled resignFirstResponder];
            //发送操作
        }
    }
}

//检查邮箱格式
- (BOOL)isValidateRegularExpression:(NSString *)strDestination

{
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    
    return [predicate evaluateWithObject:strDestination];
    
}
//检查手机号格式
-(BOOL) isValidateMobile:(NSString *)mobile
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
