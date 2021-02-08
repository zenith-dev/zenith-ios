//
//  LBIdeaViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/12/4.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBIdeaViewController.h"
#import "UITextViewPlaceHolder.h"
#import "CTextField.h"
@interface LBIdeaViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UITextViewPlaceHolder *textvplace;
    UIScrollView *scrollview;
}

@end

@implementation LBIdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
-(void)initview
{
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40)];
    [self.view addSubview:scrollview];
    textvplace=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(5, 20, kScreenWidth-10, 150)];
    ViewBorderRadius(textvplace, 0, 1, RGBCOLOR(217, 217, 217));
    textvplace.font=Font(14);
    textvplace.placeholder=@"请输入您的建议";
    [scrollview addSubview:textvplace];
    
    UIButton *submitbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitbtn.frame=CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [submitbtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
    [submitbtn addTarget:self action:@selector(submitSEL:) forControlEvents:UIControlEventTouchUpInside];
    [submitbtn setTitle:@"提交" forState:0];
    [self.view addSubview:submitbtn];
}
#pragma mark-----------------意见反馈----------------
-(void)submitSEL:(UIButton*)sender
{
    if ([Tools isBlankString:textvplace.text]) {
        [Tools showMsgBox:@"请输入您的建议"];
        [textvplace becomeFirstResponder];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork feedback:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] strfknr:textvplace.text intlx:@"2" strbbh:[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"提交成功"];
                [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
            }else
            {
                [SVProgressHUD showInfoWithStatus:@"提交失败"];
            }
        }
    }];
}
-(void)gogo
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
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
