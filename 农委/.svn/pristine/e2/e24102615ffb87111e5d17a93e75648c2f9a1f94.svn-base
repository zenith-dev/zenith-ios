
//
//  LBTransferred.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/25.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBTransferred.h"
#import "UITextViewPlaceHolder.h"
#import "QRadioButton.h"
#import "AppDelegate.h"
@interface LBTransferred()<UITextViewDelegate,QRadioButtonDelegate,UIAlertViewDelegate>
{
    UIView *view_userContact;
    UITextViewPlaceHolder *opininViews;
    UILabel *lbs;
    NSString *intgwgdbz;
}
@end
@implementation LBTransferred
- (id)initWithFrame:(CGRect)frame transferred:(NSString*)transferred savedic:(NSMutableDictionary*)savedic
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
        couponlb.text=transferred;
        couponlb.textColor=[SingleObj defaultManager].mainColor;
        couponlb.font=Font(16);
        [view_userContact addSubview:couponlb];
        //横线
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(couponlb)+5, W(couponlb), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].mainColor];
        [view_userContact addSubview:oneline];
        float g=YH(couponlb)+5;
        NSLog(@"%@",[[savedic objectForKey:@"strlzlx"] substringToIndex:3]);
        if (![[[savedic objectForKey:@"strlzlx"] substringToIndex:3] isEqualToString:@"001"]) {
            NSString *zdswlwstr=@"指定受文单位数:";
            float highline=YH(oneline)+5;
            if ([[savedic objectForKey:@"intgwjhnum"] intValue]==0) {
                UILabel *xmlb=[[UILabel alloc]initWithFrame:CGRectMake(5, highline, W(view_userContact)-10, 20)];
                xmlb.textColor=[UIColor redColor];
                xmlb.font=Font(14);
                xmlb.text=@"注：该公文未指定受文单位";
                [view_userContact addSubview:xmlb];
                highline+=20;
            }
            //指定受文单位数
            UILabel *zdswlws=[[UILabel alloc]initWithFrame:CGRectMake(5, highline, [zdswlwstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 20)];
            zdswlws.textColor=[SingleObj defaultManager].mainColor;
            zdswlws.text=zdswlwstr;
            zdswlws.font=Font(14);
            [view_userContact addSubview:zdswlws];
            lbs=[[UILabel alloc]initWithFrame:CGRectMake(XW(zdswlws)+5, Y(zdswlws), 200, H(zdswlws))];
            lbs.font=Font(14);
            lbs.adjustsFontSizeToFitWidth=YES;
            [view_userContact addSubview:lbs];
            g=YH(lbs);
            g+=5;
        }
      
        //是否归档
        NSString *sfgdstr=@"是否归档:";
        UILabel *sfgdlb=[[UILabel alloc]initWithFrame:CGRectMake(5, g, [sfgdstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 20)];
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
        
        opininViews=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(5, YH(sfgdlb)+5, W(oneline)-10, 80)];
        opininViews.font=Font(14);
        opininViews.placeholder=@"请输入意见";
        opininViews.delegate=self;
        [opininViews setBackgroundColor:[UIColor clearColor]];
        [view_userContact addSubview:opininViews];
        ViewBorderRadius(opininViews, 4, 1, [SingleObj defaultManager].mainColor);
        
        UIButton *savebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        savebtn.frame=CGRectMake(5, YH(opininViews)+10, W(view_userContact)/2.0-10, 40);
        [savebtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [savebtn addTarget:self action:@selector(saveOpiniViews:) forControlEvents:UIControlEventTouchUpInside];
        [savebtn setTitle:@"保存" forState:0];
        ViewRadius(savebtn, 4);
        [view_userContact addSubview:savebtn];
        
        UIButton *canclebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        canclebtn.frame=CGRectMake(XW(savebtn)+10, Y(savebtn), W(savebtn), H(savebtn));
        ViewRadius(canclebtn, 4);
        [canclebtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [canclebtn addTarget:self action:@selector(cancleOpiniViews:) forControlEvents:UIControlEventTouchUpInside];
        [canclebtn setTitle:@"取消" forState:0];
        [view_userContact addSubview:canclebtn];
        view_userContact.frame=CGRectMake(X(view_userContact), Y(view_userContact), W(view_userContact), YH(canclebtn)+20);
        view_userContact.center=CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    }
    return self;
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
#pragma mark------------保存----------------
-(void)saveOpiniViews:(UIButton*)sender
{
    if ([[_savedic objectForKey:@"intgwjhnum"] intValue]==0&&![[[_savedic objectForKey:@"strlzlx"] substringToIndex:3] isEqualToString:@"001"]) {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"未指定受文单位，确定要办结吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertview show];
    }else
    {
        if ([Tools isBlankString:opininViews.text]) {
            [SVProgressHUD showInfoWithStatus:@"请输入意见"];
            return;
        }
        [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork setbjopt:[_savedic objectForKey:@"intbzjllsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] intrylsh:[_savedic objectForKey:@"intrylsh"] strryxm:[_savedic objectForKey:@"strryxm"] strdwjc:[_savedic objectForKey:@"strdwjc"] stryjnr:opininViews.text intgwgdbz:intgwgdbz completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",[rep JSONString]);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD showSuccessWithStatus:@"处理成功!"];
                    [self hidden];
                    [self.delegate transferredupdata];
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
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if ([Tools isBlankString:opininViews.text]) {
            [SVProgressHUD showInfoWithStatus:@"请输入意见"];
            return;
        }
        [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork setbjopt:[_savedic objectForKey:@"intbzjllsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] intrylsh:[_savedic objectForKey:@"intrylsh"] strryxm:[_savedic objectForKey:@"strryxm"] strdwjc:[_savedic objectForKey:@"strdwjc"] stryjnr:opininViews.text intgwgdbz:intgwgdbz completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",[rep JSONString]);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD showSuccessWithStatus:@"处理成功!"];
                    [self hidden];
                    [self.delegate transferredupdata];
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
-(void)setSavedic:(NSMutableDictionary *)savedic
{
    _savedic=savedic;
    if (_savedic) {
        lbs.text=[[_savedic objectForKey:@"intgwjhnum"] stringValue];
    }
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([groupId isEqualToString:@"msg"]) {
        if (radio.tag==1000) {
            intgwgdbz=@"intgwgdbz";
        }
        else
        {
            intgwgdbz=@"";
        }
    }

}
@end
