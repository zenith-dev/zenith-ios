//
//  LBBackOffice.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/27.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBackOffice.h"
#import "UITextViewPlaceHolder.h"
#import "QRadioButton.h"
#import "AppDelegate.h"
@interface LBBackOffice()<UITextViewDelegate,QRadioButtonDelegate>
{
    UIView *view_userContact;
    UITextViewPlaceHolder *opininViews;
    NSString *intgwgdbz;
    UILabel *tbrlb;//退办人
    UILabel *worklb;//工作任务
    NSString *strsmsset;//否（为1时代表发送短信提醒）
}
@end
@implementation LBBackOffice
- (id)initWithFrame:(CGRect)frame backOffice:(NSString*)backOffice
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //监听键盘高度的变换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.6);
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=frame;
        [closeBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        view_userContact=[[UIView alloc]initWithFrame:CGRectMake(15, -300, kScreenWidth-30, 160)];
        self.hidden=YES;
        ViewRadius(view_userContact, 10);
        view_userContact.backgroundColor=[UIColor whiteColor];
        [self addSubview:view_userContact];
        UILabel *couponlb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, W(view_userContact), 50)];
        couponlb.textAlignment=NSTextAlignmentCenter;
        couponlb.text=backOffice;
        couponlb.textColor=[SingleObj defaultManager].mainColor;
        couponlb.font=Font(16);
        [view_userContact addSubview:couponlb];
        //横线
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(couponlb)+5, W(couponlb), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].mainColor];
        [view_userContact addSubview:oneline];
        //短信提示
        NSString *sfgdstr=@"短信提示:";
        UILabel *sfgdlb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(oneline)+5, [sfgdstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 20)];
        sfgdlb.textColor=[SingleObj defaultManager].mainColor;
        sfgdlb.text=sfgdstr;
        sfgdlb.font=Font(14);
        [view_userContact addSubview:sfgdlb];
        
        QRadioButton *msgqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
        msgqr.tag=1000;
        
        [msgqr setTitle:@"是" forState:0];
        msgqr.frame=CGRectMake(XW(sfgdlb)+5, Y(sfgdlb), 60,H(sfgdlb));
        [view_userContact addSubview:msgqr];
        
        QRadioButton *msgqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
        msgqr1.tag=1001;
        msgqr1.checked=YES;
        [msgqr1 setTitle:@"否" forState:0];
        msgqr1.frame=CGRectMake(XW(msgqr)+10, Y(msgqr), W(msgqr),H(sfgdlb));
        [view_userContact addSubview:msgqr1];
        //将退办给某人
        NSString *jtbgstr=@"将退办给:";
        UILabel *tbg=[[UILabel alloc]initWithFrame:CGRectMake(X(sfgdlb), YH(sfgdlb), [jtbgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(sfgdlb))];
        tbg.textColor=[SingleObj defaultManager].mainColor;
        tbg.text=jtbgstr;
        tbg.font=Font(14);
        [view_userContact addSubview:tbg];
        tbrlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(tbg)+5, Y(tbg), W(view_userContact)-(W(tbg)+2*X(tbg)), H(tbg))];
        tbrlb.font=Font(14);
        tbrlb.textColor=[UIColor blackColor];
        [view_userContact addSubview:tbrlb];
        //工作任务
        NSString *gozwstr=@"工作任务:";
        UILabel *gozwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(tbg), YH(tbg), [gozwstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(tbg))];
        gozwlb.textColor=[SingleObj defaultManager].mainColor;
        gozwlb.text=gozwstr;
        gozwlb.font=Font(14);
        [view_userContact addSubview:gozwlb];
        worklb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gozwlb)+5, Y(gozwlb), W(view_userContact)-(W(tbg)+2*X(tbg)), H(tbg))];
        worklb.font=Font(14);
        worklb.textColor=[UIColor blackColor];
        [view_userContact addSubview:worklb];
        
        opininViews=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(5, YH(gozwlb)+5, W(oneline)-10, 80)];
        opininViews.font=Font(14);
        opininViews.placeholder=@"请输入录入退回原因";
        opininViews.delegate=self;
        [opininViews setBackgroundColor:[UIColor clearColor]];
        [view_userContact addSubview:opininViews];
        ViewBorderRadius(opininViews, 4, 1, [SingleObj defaultManager].mainColor);
        
        UIButton *savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        savebtn.frame=CGRectMake(5, YH(opininViews)+10, W(view_userContact)/2.0-10, 40);
        [savebtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [savebtn addTarget:self action:@selector(saveOpiniViews:) forControlEvents:UIControlEventTouchUpInside];
        [savebtn setTitle:@"退办" forState:0];
        ViewRadius(savebtn, 4);
        [view_userContact addSubview:savebtn];
        
        UIButton *canclebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        canclebtn.frame=CGRectMake(XW(savebtn)+10, Y(savebtn), W(savebtn), H(savebtn));
        ViewRadius(canclebtn, 4);
        [canclebtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [canclebtn addTarget:self action:@selector(cancleOpiniViews:) forControlEvents:UIControlEventTouchUpInside];
        [canclebtn setTitle:@"退出" forState:0];
        [view_userContact addSubview:canclebtn];
        view_userContact.frame=CGRectMake(X(view_userContact), Y(view_userContact), W(view_userContact), YH(canclebtn)+20);
        view_userContact.center=CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    }
    return self;
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([groupId isEqualToString:@"msg"]) {
        if (radio.tag==1000) {
            strsmsset=@"1";
        }
        else
        {
            strsmsset=@"0";
        }
    }
    
}
#pragma mark Responding to keyboard events
-(void) keyboardWillShow:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float keyBoardHeight=keyboardRect.size.height;
    [UIView animateWithDuration:0.35 animations:^{
        [view_userContact setCenter:CGPointMake(view_userContact.center.x, kScreenHeight-keyBoardHeight-view_userContact.frame.size.height/2)];
    }];
    
}
-(void) keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.35 animations:^{
        view_userContact.center=CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    }completion:^(BOOL finished) {
    }];
}
-(void)setBackofficedic:(NSDictionary *)backofficedic
{
    _backofficedic=backofficedic;
    if (_backofficedic) {
        tbrlb.text=[_backofficedic objectForKey:@"strczrxm"];
        worklb.text=[_backofficedic objectForKey:@"strgzrwmc"];
    }
}
#pragma mark------------保存----------------
-(void)saveOpiniViews:(UIButton*)sender
{
    if ([Tools isBlankString:opininViews.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入录入退回原因"];
        return;
    }
    [SVProgressHUD showWithStatus:@"退办中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork gwhtopt:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] stryjnr:opininViews.text strczrxm:[_savedic objectForKey:@"strczrxm"] intgwlsh:[_savedic objectForKey:@"intgwlsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] strsmsset:strsmsset completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"处理成功!"];
                [self hidden];
                [self.delegate backofficeupdata];
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
#pragma mark------------取消-----------------
-(void)cancleOpiniViews:(UIButton*)sender
{
    [self hidden];
}
-(void)closeButtonClicked
{
    [self endEditing:YES];
}
-(void)show
{
   [[AppDelegate Share].window addSubview:self];
    self.hidden=NO;
}
-(void)hidden
{
    [self endEditing:YES];
    self.hidden = YES;
}
@end
