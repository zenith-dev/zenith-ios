//
//  SKGRaphicVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "SKGRaphicVC.h"
#import "SKGraphicView.h"
@interface SKGRaphicVC ()
@property (nonatomic,strong)SKGraphicView *drwview ;
@end
static UIButton *selectBtn;
@implementation SKGRaphicVC
@synthesize drwview;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"保存" image:nil sel:@selector(okSEL)];
    drwview = [[SKGraphicView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-ScaleBI(80))];
    drwview.backgroundColor = [UIColor whiteColor];
    drwview.color = [UIColor blackColor];
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"lineWidth"]>0) {
       drwview.lineWidth = [[NSUserDefaults standardUserDefaults] floatForKey:@"lineWidth"];
    }
    else
    {
        drwview.lineWidth = 10;
    }
    [self.view addSubview:drwview];
    [self toolsviewgo];
    // Do any additional setup after loading the view.
}

#pragma mark---------工具栏------------
-(void)toolsviewgo{
    UIView *toolsview=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-ScaleBI(80), kScreenWidth, ScaleBI(80))];
    UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    undoBtn.frame = CGRectMake(0, 0, ScaleBI(40), ScaleBI(40));
    [undoBtn setImage:PNGIMAGE(@"撤销") forState:UIControlStateNormal];
    [undoBtn addTarget:self action:@selector(undoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:undoBtn];
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    clearBtn.frame = CGRectMake(0, ScaleBI(40), ScaleBI(40), ScaleBI(40));
    [clearBtn setImage:PNGIMAGE(@"删除") forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:clearBtn];
    NSArray *colorAry=@[UIColorFromRGB(0x000000),UIColorFromRGB(0x404040),UIColorFromRGB(0x800000),UIColorFromRGB(0xf80000),UIColorFromRGB(0x008000),UIColorFromRGB(0x00fd00),UIColorFromRGB(0x000080),UIColorFromRGB(0x0000f8),UIColorFromRGB(0x800040),UIColorFromRGB(0xfa007d),UIColorFromRGB(0x400080),UIColorFromRGB(0x7e00fb),UIColorFromRGB(0x402000),UIColorFromRGB(0x7d3f00)];
    float colorbtnwith=ScaleBI(40);
    for (int i=0; i<colorAry.count; i++) {
        UIButton *colorbtn=[[UIButton alloc]initWithFrame:CGRectMake((i/2)*ScaleBI(40)+ScaleBI(40), i%2==0?0:ScaleBI(40), ScaleBI(40), ScaleBI(40))];
        colorbtn.tag=i;
        if (i==0) {
            selectBtn=colorbtn;
            ViewBorderRadius(colorbtn, 0, 4, [UIColor whiteColor]);
        }
        [colorbtn bk_addEventHandler:^(UIButton *sender) {
            if (selectBtn!=sender) {
                drwview.color = colorAry[sender.tag];
                ViewBorderRadius(selectBtn, 0, 0, [UIColor whiteColor]);
                selectBtn=sender;
                ViewBorderRadius(sender, 0, 4, [UIColor whiteColor]);
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
        [colorbtn setBackgroundColor:colorAry[i]];
        [toolsview addSubview:colorbtn];
        colorbtnwith=colorbtn.right;
    }
    UIButton *addBtn=[[UIButton alloc]initWithFrame:CGRectMake(colorbtnwith, 0, ScaleBI(30), ScaleBI(30))];
    ViewBorderRadius(addBtn, 0, 1, RGBCOLOR(220, 220, 220));
    [addBtn setImage:PNGIMAGE(@"jhh") forState:UIControlStateNormal];
    [addBtn bk_addEventHandler:^(id sender) {
        self.withlb.text=[NSString stringWithFormat:@"%@",@(++drwview.lineWidth)];
        [[NSUserDefaults standardUserDefaults] setFloat:drwview.lineWidth forKey:@"lineWidth"];
    } forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:addBtn];
    self.withlb =[[UILabel alloc]initWithFrame:CGRectMake(addBtn.left, addBtn.bottom, ScaleBI(30), ScaleBI(20))];
    self.withlb.font=Font(13);
    self.withlb.textAlignment=NSTextAlignmentCenter;
    self.withlb.text=[NSString stringWithFormat:@"%@",@(drwview.lineWidth)];
    [toolsview addSubview:self.withlb];
    
    UIButton *jhBtn=[[UIButton alloc]initWithFrame:CGRectMake(colorbtnwith, self.withlb.bottom, ScaleBI(30), ScaleBI(30))];
    ViewBorderRadius(jhBtn, 0, 1, RGBCOLOR(220, 220, 220));
    [jhBtn setImage:PNGIMAGE(@"jh") forState:UIControlStateNormal];
    [jhBtn bk_addEventHandler:^(id sender) {
        if (drwview.lineWidth>1) {
            self.withlb.text=[NSString stringWithFormat:@"%@",@(--drwview.lineWidth)];
             [[NSUserDefaults standardUserDefaults] setFloat:drwview.lineWidth forKey:@"lineWidth"];
            
            
        }
    } forControlEvents:UIControlEventTouchUpInside];
    [toolsview addSubview:jhBtn];
    [self.view addSubview:toolsview];
}
-(void)undoBtnEvent
{
    [drwview undoBtnEvent];
}

-(void)clearBtnEvent
{
    [drwview clearBtnEvent];
}

-(void)okSEL{
    UIImage *getImge=[drwview getDrawingImg];
    if (getImge==nil) {
        [self showMessage:@"您还没有签批！请您签批"];
        return;
    }
    if (self.callback) {
        self.callback(getImge);
        
    }
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
