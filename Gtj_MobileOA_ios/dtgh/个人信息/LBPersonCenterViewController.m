//
//  LBPersonCenterViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBPersonCenterViewController.h"
#import "UIImageView+WebCache.h"
#import "SHbsTableViewCell.h"
#import "LBIdeaViewController.h"
#import "LBAboutUsViewController.h"
#import "AppDelegate.h"
@interface LBPersonCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * lbpersontb;
    NSMutableArray *personary;
    NSString *strwjdz;
    
}
@end

@implementation LBPersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    personary=[[NSMutableArray alloc]initWithObjects:@"个人信息",@"意见反馈",@"版本更新",@"关于",@"退出登录", nil];
    [self initview];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-----------界面初始化-----------------
-(void)initview
{
    lbpersontb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    lbpersontb.showsVerticalScrollIndicator=NO;
    lbpersontb.dataSource=self;
    lbpersontb.delegate=self;
    lbpersontb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbpersontb];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    //header.lastUpdatedTimeLabel.hidden = YES;
    lbpersontb.mj_header=header;
    }
-(void)loadNewData
{
  [lbpersontb.mj_header endRefreshing];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return personary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    
     NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (indexPath.row==0) {
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    }
    NSString *str=[personary objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"退出登录"]) {
        UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-10, 0)];
        [headerview setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:headerview];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UIButton *loginoutbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        loginoutbtn.frame=CGRectMake(20, 20, kScreenWidth-40, 40);
        ViewRadius(loginoutbtn, 2);
        [loginoutbtn setTitle:str forState:0];
        [loginoutbtn bootstrapNoborderStyle:[SingleObj defaultManager].mainColor titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [loginoutbtn addTarget:self action:@selector(loginoutSEL:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:loginoutbtn];
        headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview), YH(loginoutbtn)+10);
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
        return cell;
    }
    else
    {
        UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-10, 0)];
        [headerview setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:headerview];
        if ([str isEqualToString:@"个人信息"]) {
            UIImageView *bgimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
            [bgimageview setImage:PNGIMAGE(@"centerbg")];
            [headerview addSubview:bgimageview];
            //头像
            UIImageView *hdimgeview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 60, 60)];
            [hdimgeview setImage:PNGIMAGE(@"logo")];
            ViewRadius(hdimgeview, H(hdimgeview)/2.0);
            [headerview addSubview:hdimgeview];
            UIButton *hdbtn=[UIButton buttonWithType:UIButtonTypeCustom];
            hdbtn.frame=hdimgeview.frame;
            [hdbtn addTarget:self action:@selector(turntoInfo:) forControlEvents:UIControlEventTouchUpInside];
            [headerview addSubview:hdbtn];
            //名称
            UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(XW(hdimgeview)+5, Y(hdimgeview), 150, 30)];
            namelb.font=Font(16);
            namelb.adjustsFontSizeToFitWidth=YES;
            namelb.text=[NSString stringWithFormat:@"姓名:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"]];
            [headerview addSubview:namelb];
            //tel
            UILabel *tellb=[[UILabel alloc]initWithFrame:CGRectMake(X(namelb), YH(namelb), 180, H(namelb))];
            tellb.font=Font(14);
            tellb.text=[NSString stringWithFormat:@"部门:%@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strcsjc"]];
            [headerview addSubview:tellb];
            
            UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(bgimageview), kScreenWidth, 1)];
            [oneline setBackgroundColor:RGBCOLOR(220, 220, 220)];
            [headerview addSubview:oneline];
            
            UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(oneline), kScreenWidth, 10)];
            [lb setBackgroundColor:RGBCOLOR(237, 237, 237)];
            [headerview addSubview:lb];
            headerview.frame=CGRectMake(X(headerview), Y(headerview), kScreenWidth, YH(lb));
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 44)];
            namelb.text=str;
            namelb.font=Font(14);
            [headerview addSubview:namelb];
            
            headerview.frame=CGRectMake(X(headerview), Y(headerview), kScreenWidth, YH(namelb));
            UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(headerview)-1, kScreenWidth, 1)];
            [oneline setBackgroundColor:RGBCOLOR(220, 220, 220)];
            [headerview addSubview:oneline];
        }
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str=[personary objectAtIndex:indexPath.row];
    if ([str isEqualToString:@"意见反馈"]) {
        LBIdeaViewController *lbideal=[[LBIdeaViewController alloc]init];
        lbideal.title=str;
        [self.navigationController pushViewController:lbideal animated:YES];
    }
    else if ([str isEqualToString:@"版本更新"])
    {
        [self searchVersion];
    }
    else if ([str isEqualToString:@"关于"])
    {
        LBAboutUsViewController *lbaboutUs=[[LBAboutUsViewController alloc]init];
        lbaboutUs.title=str;
        [self.navigationController pushViewController:lbaboutUs animated:YES];
    }
}

#pragma mark------------------更新最新版本-------------
-(void)searchVersion
{
    [SVProgressHUD showWithStatus:@"检测中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork searchNewVersioncompletionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            [SVProgressHUD dismiss];
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *versionary=[rep objectForKey:@"data"];
                for (NSDictionary *versiondic in versionary) {
                    NSString *sysversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
                    if ([[versiondic objectForKey:@"intsclx"] integerValue]==2) {
                        //判断版本是否相同
                        strwjdz=[versiondic objectForKey:@"strwjdz"];
                        if (![sysversion isEqualToString:[versiondic objectForKey:@"strbbbh"]]) {
                            dispatch_async(dispatch_get_main_queue(), ^{//回到主线程
                                UIAlertView  *updateUIAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"版本更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                                [updateUIAlertView show];
                            });
                        }
                    }
                }
            }
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1){
        if (alertView.tag==1958) {
            [[AppDelegate Share] showLogin];
        }
        else
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",strwjdz]]];
        }

    }
    
}
-(void)loginoutSEL:(UIButton*)sender
{
    UIAlertView *alerview=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您是否要退出程序" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerview.tag=1958;
    [alerview show];
}
#pragma mark------------进入个人信息页面 ---------
-(void)turntoInfo:(UIButton*)sender
{
    

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
