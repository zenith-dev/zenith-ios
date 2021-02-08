//
//  LBAgentsOpinion.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/18.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgentsOpinion.h"
#import "UITextViewPlaceHolder.h"
#import "AppDelegate.h"
#import "LBCommonVC.h"
@interface LBAgentsOpinion()<UITextViewDelegate>
{
    UIView *view_userContact;
    UITextViewPlaceHolder *opininViews;
}
@end
@implementation LBAgentsOpinion
- (id)initWithFrame:(CGRect)frame opiniontitle:(NSString*)opiniontitle
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
        couponlb.text=opiniontitle;
        couponlb.textColor=[SingleObj defaultManager].mainColor;
        couponlb.font=Font(16);
        [view_userContact addSubview:couponlb];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"常用语"];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:strRange];
        UIButton *bt=[[UIButton alloc]initWithFrame:CGRectMake( W(view_userContact)-60, YH(couponlb), 60, 20)];
        bt.titleLabel.font=Font(14);
        [bt setAttributedTitle:str forState:UIControlStateNormal];
        [bt bk_addEventHandler:^(id sender) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(common:) name:@"ComMon" object:nil];
            LBCommonVC *lbcommonvc=[[LBCommonVC alloc]init];
            lbcommonvc.title=@"常用语";
            [self.nav pushViewController:lbcommonvc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        [view_userContact addSubview:bt];
        //横线
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(bt)+5, W(couponlb), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].mainColor];
        [view_userContact addSubview:oneline];
        
        
        opininViews=[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(5, YH(oneline)+5, W(oneline)-10, 80)];
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
#pragma mark--------------登录成功-----------
-(void)common:(NSNotification *)notification
{
    id obj=[notification userInfo];
    NSLog(@"%@",obj);
    opininViews.text=[NSString stringWithFormat:@"%@%@",opininViews.text==nil?@"":opininViews.text,obj];
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
    if ([Tools isBlankString:opininViews.text]) {
         [SVProgressHUD showInfoWithStatus:@"请输入意见"];
        return;
    }
    [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork saveOpinion:[_savedic objectForKey:@"intclyjlsh"] intact:[_savedic objectForKey:@"intact"] intgwlsh:[_savedic objectForKey:@"intgwlsh"] chrlrryxm:[_savedic objectForKey:@"chrlrryxm"] intyjbh:[_savedic objectForKey:@"intyjbh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] chryjnr:opininViews.text intlrrylsh:[_savedic objectForKey:@"intlrrylsh"] intrylsh:[_savedic objectForKey:@"intrylsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                 [SVProgressHUD showSuccessWithStatus:@"意见处理成功!"];
                [self hidden];
                [self.opinionDelegate updates];
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
    [[self.nav.viewControllers lastObject].view addSubview:self];
    self.hidden=NO;
}
-(void)hidden
{
    [self endEditing:YES];
    self.hidden = YES;
}
-(void)setOpintondic:(NSDictionary *)opintondic
{
    _opintondic=opintondic;
    if ([_opintondic allKeys].count>0) {
        [_savedic setObject:[_opintondic objectForKey:@"intrylsh"] forKey:@"intrylsh"];
        opininViews.text=[_opintondic objectForKey:@"stryjnr"];
    }
}
@end
