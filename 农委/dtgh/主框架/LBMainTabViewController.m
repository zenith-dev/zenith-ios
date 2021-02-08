//
//  LBMainTabViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBMainTabViewController.h"
#import "LBWorkViewController.h"
#import "LBLinkManViewController.h"
#import "LBMsgViewController.h"
#import "LBApplyViewController.h"
#import "BBFlashCtntLabel.h"
@interface LBMainTabViewController ()
{
    UIButton *workBtn;//首页
    UIButton *linkmanBtn;//抢广告位
    UIButton *msgBtn;//游戏
    UIButton *applyBtn;//个人中心
    UIButton *centbtn;
}
@end
@implementation LBMainTabViewController
@synthesize tabBarView;
static NSInteger indextap=0;
static UIButton *selectbtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    LBWorkViewController *lbwork=[[LBWorkViewController alloc]init];
    lbwork.mainNav=self.navigationController;
    
    LBLinkManViewController *lblinkman=[[LBLinkManViewController alloc]init];
    lblinkman.mainNav=self.navigationController;
    LBMsgViewController *lbmsg=[[LBMsgViewController alloc]init];
    lbmsg.mainNav=self.navigationController;
    
    LBApplyViewController *lbapply=[[LBApplyViewController alloc]init];
    lbapply.mainNav=self.navigationController;
    self.viewControllers=[[NSArray alloc]initWithObjects:lbwork,lblinkman,lbmsg, lbapply,nil];
    indextap=0;
    self.selectedIndex=indextap;
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    NSString *str=[NSString stringWithFormat:@"%@-%@",dic[@"strdwjc"],dic[@"strcsjc"]];
    self.title=str;
    if (self.title) {
        BBFlashCtntLabel *bbflashCtntlb=[[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        bbflashCtntlb.backgroundColor=[UIColor clearColor];
        bbflashCtntlb.leastInnerGap = 50.f;
        bbflashCtntlb.speed=BBFlashCtntSpeedSlow;
        bbflashCtntlb.text=self.title;
        bbflashCtntlb.font=BoldFont(18);
        bbflashCtntlb.textColor=[UIColor whiteColor];
        self.navigationItem.titleView=bbflashCtntlb;
    }
    [self cerateTabbarView];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark--------------设置选项卡的内容-------------
-(void)cerateTabbarView
{
    self.tabBar.hidden=YES;
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    [oneline setBackgroundColor:RGBCOLOR(230, 230, 230)];
    tabBarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenHeight-49, W(self.tabBar),49)];
    [tabBarView setBackgroundColor:RGBCOLOR(246, 246, 246)];
    tabBarView.userInteractionEnabled=YES;
    [tabBarView addSubview:oneline];
    
    workBtn=[self setImage:CGRectMake(0, 1, 64, 49) nomoralImage:@"home-s" selectImage:@"home" Withtitle:@"办公" :YES];
    workBtn.tag=0;
    
    [workBtn addTarget:self action:@selector(turnto:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:workBtn];
    selectbtn=workBtn;
    
    linkmanBtn=[self setImage:CGRectMake(0, 1, 64, 49) nomoralImage:@"av-s" selectImage:@"av" Withtitle:@"联系人" :NO];
    linkmanBtn.tag=1;
    
    [linkmanBtn addTarget:self action:@selector(turnto:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:linkmanBtn];
    
    msgBtn=[self setImage:CGRectMake(0, 1, 64, 49) nomoralImage:@"actv-s" selectImage:@"actv" Withtitle:@"消息" :NO];
    msgBtn.tag=2;
    
    [msgBtn addTarget:self action:@selector(turnto:) forControlEvents:UIControlEventTouchUpInside];
    [tabBarView addSubview:msgBtn];
    
    
    
    applyBtn=[self setImage:CGRectMake(0, 1, 64, 49) nomoralImage:@"me-s" selectImage:@"me" Withtitle:@"应用" :NO];
    [applyBtn addTarget:self action:@selector(turnto:) forControlEvents:UIControlEventTouchUpInside];
    applyBtn.tag=3;
    [tabBarView addSubview:applyBtn];
    
    workBtn.center=CGPointMake((kScreenWidth/4.0)*1/2.0, 24.5);
    linkmanBtn.center=CGPointMake((kScreenWidth/4.0)*2-((kScreenWidth/4.0)*1/2.0), 24.5);
    msgBtn.center=CGPointMake((kScreenWidth/4.0)*3-((kScreenWidth/4.0)*1/2.0), 24.5);
    applyBtn.center=CGPointMake((kScreenWidth/4.0)*4-((kScreenWidth/4.0)*1/2.0), 24.5);
    
    [self.view addSubview:tabBarView];
}
#pragma mark------------按钮按键-------------------------
-(void)turnto:(UIButton*)sender
{
    if (indextap!=sender.tag){
        if (sender.tag==0) {
            NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            NSString *str=[NSString stringWithFormat:@"%@-%@",dic[@"strdwjc"],dic[@"strcsjc"]];
            self.title=str;
        }
        else if (sender.tag==1)
        {
            self.title=@"联系人";
        }
        else if (sender.tag==2)
        {
            self.title=@"消息";
        }
        else if (sender.tag==3)
        {
            self.title=@"应用";
        }
        if (self.title) {
            BBFlashCtntLabel *bbflashCtntlb=[[BBFlashCtntLabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
            bbflashCtntlb.backgroundColor=[UIColor clearColor];
            bbflashCtntlb.leastInnerGap = 50.f;
            bbflashCtntlb.speed=BBFlashCtntSpeedSlow;
            bbflashCtntlb.text=self.title;
            bbflashCtntlb.font=BoldFont(18);
            bbflashCtntlb.textColor=[UIColor whiteColor];
            self.navigationItem.titleView=bbflashCtntlb;
        }
        
        
        [self setSelectedIndex:sender.tag];
        sender.selected=YES;
        selectbtn.selected=NO;
        selectbtn=sender;
        indextap=sender.tag;
    }
}
//工具栏设置图片 文字
- (UIButton*) setImage:(CGRect )rectfrom nomoralImage:(NSString*)nomoralimage selectImage:(NSString*)selectimage Withtitle: (NSString *)title :(BOOL)isflag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
    button.frame = rectfrom;//button的frame
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:Font(12)}];
    [button.imageView setContentMode:UIViewContentModeCenter];
    [button setImageEdgeInsets:UIEdgeInsetsMake(-15,0.0,0.0,-titleSize.width)];
    [button.imageView setImage:PNGIMAGE(nomoralimage)];
    [button setImage:PNGIMAGE(nomoralimage) forState:UIControlStateNormal];
    [button setImage:PNGIMAGE(selectimage) forState:UIControlStateSelected];
    [button.titleLabel setContentMode:UIViewContentModeCenter];
    [button.titleLabel setBackgroundColor:[UIColor clearColor]];
    [button.titleLabel setFont:Font(12)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(30.0,-button.imageView.image.size.width,0.0,0.0)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(135, 135, 135) forState:UIControlStateNormal];
    [button setTitleColor:[SingleObj defaultManager].mainColor forState:UIControlStateSelected];
    if (isflag) {
        button.selected=YES;
    }
    return button;
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
