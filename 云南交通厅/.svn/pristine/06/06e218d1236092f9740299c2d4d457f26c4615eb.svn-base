//
//  RePassWordVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/14.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "RePassWordVC.h"

@interface RePassWordVC ()
@property(nonatomic,strong)UIScrollView *rpScr;
@property(nonatomic,strong)UITextField *oldpdtf;
@property(nonatomic,strong)UITextField *newpdtf;
@property(nonatomic,strong)UITextField *rnewpdtf;
@end

@implementation RePassWordVC
@synthesize rpScr,oldpdtf,newpdtf,rnewpdtf;
- (void)viewDidLoad {
    [super viewDidLoad];
      rpScr=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
     [self.view addSubview:rpScr];
     [self.view setBackgroundColor:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1.00]];
    [self initview];
    // Do any additional setup after loading the view.
}
#pragma mark-----------初始化界面--------------
-(void)initview
{
    UIFont *bfont=Font(15);
    UIColor *bColor=[UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1.00];
    NSString *str=@"确认密码";
    CGSize strsize=[str sizeWithAttributes:@{NSFontAttributeName:bfont}];
    UIView *oldview=[[UIView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, ScaleBI(50))];
    [oldview setBackgroundColor:[UIColor whiteColor]];
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, oldview.width, 0.5)];
    [onelb setBackgroundColor:[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00]];
    [oldview addSubview:onelb];
    UILabel *oldlb=[[UILabel alloc]initWithFrame:CGRectMake(15, onelb.bottom, strsize.width, oldview.height-1)];
    oldlb.font=bfont;
    oldlb.text=@"旧密码";
    oldlb.textColor=bColor;
    [oldview addSubview:oldlb];
    oldpdtf=[[UITextField alloc]initWithFrame:CGRectMake(oldlb.right+15, 0, oldview.width-oldlb.right-30, oldlb.height)];
    oldpdtf.font=bfont;
    [oldpdtf setSecureTextEntry:YES];
    oldpdtf.clearButtonMode=UITextFieldViewModeWhileEditing;
    oldpdtf.placeholder=@"请输入旧密码";
    [oldview addSubview:oldpdtf];
    [rpScr addSubview:oldview];
    UILabel *one1lb=[[UILabel alloc]initWithFrame:CGRectMake(0, oldlb.bottom, oldview.width, 0.5)];
    [one1lb setBackgroundColor:[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00]];
    [oldview addSubview:one1lb];
    
    UIView *newview=[[UIView alloc]initWithFrame:CGRectMake(0, oldview.bottom+15, oldview.width, ScaleBI(50)*2)];
    [newview setBackgroundColor:[UIColor whiteColor]];
    [rpScr addSubview:newview];
    UILabel *one2lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, newview.width, 0.5)];
    [one2lb setBackgroundColor:[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00]];
    [newview addSubview:one2lb];
    UILabel *newlb=[[UILabel alloc]initWithFrame:CGRectMake(15, one2lb.bottom, strsize.width, ScaleBI(50))];
    newlb.font=bfont;
    newlb.text=@"新密码";
    newlb.textColor=bColor;
    [newview addSubview:newlb];
    newpdtf=[[UITextField alloc]initWithFrame:CGRectMake(newlb.right+15, 0, oldpdtf.width, newlb.height)];
    newpdtf.font=bfont;
    [newpdtf setSecureTextEntry:YES];
    newpdtf.clearButtonMode=UITextFieldViewModeWhileEditing;
    newpdtf.placeholder=@"请输入新密码";
    [newview addSubview:newpdtf];
    UILabel *one3lb=[[UILabel alloc]initWithFrame:CGRectMake(0, newlb.bottom, newview.width, 0.5)];
    [one3lb setBackgroundColor:[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00]];
    [newview addSubview:one3lb];
    
    UILabel *rnewlb=[[UILabel alloc]initWithFrame:CGRectMake(15, one3lb.bottom, strsize.width, ScaleBI(50))];
    rnewlb.font=bfont;
    rnewlb.text=@"确认密码";
    rnewlb.textColor=bColor;
    [newview addSubview:rnewlb];
    rnewpdtf=[[UITextField alloc]initWithFrame:CGRectMake(rnewlb.right+15, rnewlb.top, oldpdtf.width, rnewlb.height)];
    rnewpdtf.font=bfont;
    [rnewpdtf setSecureTextEntry:YES];
    rnewpdtf.clearButtonMode=UITextFieldViewModeWhileEditing;
    rnewpdtf.placeholder=@"请输入确认密码";
    [newview addSubview:rnewpdtf];
    
    UILabel *one4lb=[[UILabel alloc]initWithFrame:CGRectMake(0, rnewlb.bottom, newview.width, 0.5)];
    [one4lb setBackgroundColor:[UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1.00]];
    [newview addSubview:one4lb];
    newview.height=one4lb.bottom;
    [rpScr addSubview:newview];
    UIButton *savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    savebtn.frame=CGRectMake(40, newview.bottom+30, newview.width-80, 45);
    [savebtn bootstrapNoborderStyle:[UIColor colorWithRed:0.188 green:0.498 blue:0.816 alpha:1.00] titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
    ViewRadius(savebtn, 4);
    [savebtn addTarget:self action:@selector(saveSEL:) forControlEvents:UIControlEventTouchUpInside];
    [savebtn setTitle:@"提交" forState:0];
    [rpScr addSubview:savebtn];
    [rpScr setContentSize:CGSizeMake(kScreenWidth, savebtn.bottom)];
}
#pragma mark-----------------保存
-(void)saveSEL:(UIButton*)sender{

    if ([Tools isBlankString:oldpdtf.text]) {
        [self showMessage:@"请输入旧密码"];
        return;
    }
    else if ([Tools isBlankString:newpdtf.text])
    {
        [self showMessage:@"请输入新密码"];
        return;
    }
    else if ([Tools isBlankString:rnewpdtf.text])
    {
        [self showMessage:@"请输入确认密码"];
        return;
    }
    else if (![newpdtf.text isEqualToString:rnewpdtf.text])
    {
        [self showMessage:@"确认密码错误"];
        return;
    }
    else if ([newpdtf.text isEqualToString:oldpdtf.text])
    {
        [self showMessage:@"旧密码与新密码一致"];
        return;
    }
    NSDictionary *repdic=@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"password":newpdtf.text,@"oldpassword":oldpdtf.text};
    
    [self networkall:@"usercenter" requestMethod:@"updatePassword" requestHasParams:@"true" parameter:repdic progresHudText:@"修改中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"root"][@"result"] intValue]==0) {
                [self showMessage:@"修改成功"];
                 [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
            }
            else if ([rep[@"root"][@"result"] intValue]==4)
            {
                [self showMessage:@"原始密码错误"];
            }
            else if ([rep[@"root"][@"result"] intValue]==-1)
            {
                [self showMessage:@"修改密码异常"];
            }
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
