//
//  LBBaseViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBBaseViewController.h"
#import "BBFlashCtntLabel.h"
@interface LBBaseViewController ()

@end

@implementation LBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftbtn= [[UIButton alloc] initWithFrame:CGRectMake(0,20, 55, 44)];
    [leftbtn setImage:PNGIMAGE(@"btn-back") forState:UIControlStateNormal];
    [leftbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [leftbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    leftbtn.titleLabel.font = Font(16);
    leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftbtn addTarget:self action:@selector(backPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    if (self.ishide==NO) {
        self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftbtn],negativeSpacer];
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
    // Do any additional setup after loading the view from its nib.
}
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel
{
    UIButton *rightbtn= [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-45,20, 45, 44)];
    if(image){
        [rightbtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    }
    if(title){
        [rightbtn setTitle:title forState:UIControlStateNormal];
        [rightbtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        if (image) {
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            [rightbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        }else{
            [rightbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        }
        rightbtn.titleLabel.font = Font(15);
        rightbtn.frame=CGRectMake(X(rightbtn), Y(rightbtn), [title sizeWithAttributes:@{NSFontAttributeName:Font(15)}].width+10, H(rightbtn));
    }
    rightbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightbtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    self.navigationItem.rightBarButtonItems=@[negativeSpacer, [[UIBarButtonItem alloc]initWithCustomView:rightbtn]];
    return rightbtn;
}
-(void)backPage
{
    [SVProgressHUD dismiss];
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
