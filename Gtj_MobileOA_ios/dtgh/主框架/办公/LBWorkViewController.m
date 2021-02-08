//
//  LBWorkViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBWorkViewController.h"
#import "SHRunPageScroll.h"
#import "SHbsTableViewCell.h"
#import "LBPersonCenterViewController.h"
#import "LBNoticeViewController.h"
#import "LBAgentsViewController.h"
#import "LBCheckViewController.h"
#import "LBMsgBoxViewController.h"
#import "LBMyTravelViewController.h"
#import "LBMoreViewController.h"
#import "LBNoticeDetailViewController.h"
@interface LBWorkViewController ()<UITableViewDataSource,UITableViewDelegate,SHRunScrollDelegate>
{
    UITableView *lbworktb;
    NSString *strwjdz;
    SHRunPageScroll *shrunpage;
    NSMutableArray * homePageBannerAry;
    NSMutableArray *homePageList;
    NSDictionary *homedic;
}
@end

@implementation LBWorkViewController
#define kPerRowCount 3
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:nil image:@"infoMsg" sel:@selector(infoMsgSEL:)];
    homePageBannerAry=[[NSMutableArray alloc]initWithObjects:@"1.jpg",@"2.jpg", nil];
   // homePageList=[[NSMutableArray alloc]initWithObjects:@"通知",@"待办事项",@"公文查询",@"邮件",@"政务信息", nil];
    homePageList=[[NSMutableArray alloc]initWithObjects:@"通知",@"待办事项",@"公文查询", nil];
    [self searchVersion];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark------------------更新最新版本-------------
-(void)searchVersion
{
    [SHNetWork searchNewVersioncompletionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                if (![[rep objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    return;
                }
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
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",strwjdz]]];
    }
}
-(void)updata{
    [lbworktb.mj_header beginRefreshing];
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
#pragma mark-----------------进入个人信息页面------------
-(void)infoMsgSEL:(UIButton*)sender
{
    LBPersonCenterViewController *lbperson=[[LBPersonCenterViewController alloc]init];
    lbperson.title=@"个人信息";
    [self.navigationController pushViewController:lbperson animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-10, 0)];
    //banner滚动器
    shrunpage=[[SHRunPageScroll alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenWidth*0.4)];
    shrunpage.shrunpagescrolldelegate=self;
    shrunpage.scrollImagearray=homePageBannerAry;
    [shrunpage scrolladdimage:homePageBannerAry];
    [headerview addSubview:shrunpage];
    NSString *newsstr;
    if ([[homedic objectForKey:@"newnotice"] isKindOfClass:[NSDictionary class]]) {
        //最新消息
      newsstr=[NSString stringWithFormat:@"[最新消息]%@",homedic==nil?@"":[[homedic objectForKey:@"newnotice"] objectForKey:@"strtzbt"]];
    }else{
        newsstr=@"[最新消息]";
    }
    UIView *msgview=[self getmsgView:newsstr];
    msgview.frame=CGRectMake(0, YH(shrunpage)+5, W(msgview), H(msgview));
    [headerview addSubview:msgview];
    long rowCount = [self rowCountWithItemsCount:homePageList.count];
    float cellhightv=120;
    UIView *views=[[UIView alloc]initWithFrame:CGRectMake(0, YH(msgview)+5, kScreenWidth, cellhightv*rowCount)];
    //添加按钮
    float k=0;
    float xk=0;
    
    for (int i=0; i<homePageList.count; i++) {
        UIView *btn;
        if (homedic==nil) {
            btn= [self getviews:[homePageList objectAtIndex:i] title:[homePageList objectAtIndex:i] nums:@"0" tg:1000+i sel:@selector(turntoSEL:)];
        }
        else
        {
            if ([[homePageList objectAtIndex:i] isEqualToString:@"通知"]) {
                btn= [self getviews:[homePageList objectAtIndex:i] title:[homePageList objectAtIndex:i] nums:[homedic objectForKey:@"noticenum"] tg:1000+i sel:@selector(turntoSEL:)];
            }else if ([[homePageList objectAtIndex:i] isEqualToString:@"邮件"])
            {
                btn= [self getviews:[homePageList objectAtIndex:i] title:[homePageList objectAtIndex:i] nums:[homedic objectForKey:@"mailnum"] tg:1000+i sel:@selector(turntoSEL:)];
            }else if ([[homePageList objectAtIndex:i] isEqualToString:@"待办事项"])
            {
                btn= [self getviews:[homePageList objectAtIndex:i] title:[homePageList objectAtIndex:i] nums:[homedic objectForKey:@"tasknum"] tg:1000+i sel:@selector(turntoSEL:)];
            }else
            {
                btn= [self getviews:[homePageList objectAtIndex:i] title:[homePageList objectAtIndex:i] nums:@"0" tg:1000+i sel:@selector(turntoSEL:)];
            }
        }
        if (i!=0&&i%kPerRowCount==0) {
            k+=125;
            xk=0;
        }
        btn.frame=CGRectMake(xk*(kScreenWidth/3.0), k, kScreenWidth/3.0, cellhightv);
        xk++;
        [views addSubview:btn];
    }
    [headerview addSubview:views];
    headerview.frame=CGRectMake(0, 0, kScreenWidth, YH(views));
    [cell addSubview:headerview];
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark----------------加载消息----------------------
-(UIView *)getmsgView:(NSString *)msg
{
    UIView *msgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 22)];
    UIImageView *noticeImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 17, 17)];
    [noticeImg setImage:PNGIMAGE(@"noticeico")];
    [msgview addSubview:noticeImg];
    
    UILabel *msglb=[[UILabel alloc]initWithFrame:CGRectMake(XW(noticeImg)+8,0, kScreenWidth-(10*2+21), 21)];
    msglb.text=msg;
    msglb.font=Font(14);
    [msgview addSubview:msglb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(msglb)+1, kScreenWidth, 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgview addSubview:oneline];
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame=CGRectMake(0, 0, W(msgview), H(msgview));
    [bt addTarget:self action:@selector(gotoNoticeDetail:) forControlEvents:UIControlEventTouchUpInside];
    [msgview addSubview:bt];
    return msgview;
}
-(void)gotoNoticeDetail:(UIButton*)sender
{
    if ([[homedic objectForKey:@"newnotice"] isKindOfClass:[NSDictionary class]]) {
        LBNoticeDetailViewController *lbnoticedetail=[[LBNoticeDetailViewController alloc]init];
        lbnoticedetail.title=@"通知详情";
        lbnoticedetail.lbNoticDetail=[homedic objectForKey:@"newnotice"];
        [self.navigationController pushViewController:lbnoticedetail animated:YES];
    }
}
#pragma mark----------------加载某个模块------------------
-(UIView*)getviews :(NSString*)imgurl title:(NSString*)title nums:(NSString*)nums tg:(NSInteger)tag sel:(SEL)sel
{
    UIView *homegridview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3.0,120)];
    UIImageView *logoview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    logoview.center=CGPointMake(homegridview.center.x, 45+10);
    [logoview setImage:PNGIMAGE(imgurl)];
    [homegridview addSubview:logoview];
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(logoview)+5, W(homegridview)-10, 18)];
    titlelb.text=title;
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.adjustsFontSizeToFitWidth=YES;
    titlelb.font=Font(13);
    [homegridview addSubview:titlelb];
    if ([nums intValue]>0) {
        UILabel *numlb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        numlb.text=nums;
        CGSize numszie=[numlb.text sizeWithAttributes:@{NSFontAttributeName:BoldFont(12)}];
        numlb.frame=CGRectMake(0, 0, numszie.width+10>18?numszie.width+10:18, 18);
        [numlb setBackgroundColor:[UIColor redColor]];
        ViewRadius(numlb, H(numlb)/2.0);
        numlb.textColor=[UIColor whiteColor];
        numlb.textAlignment=NSTextAlignmentCenter;
        numlb.font=BoldFont(12);
        
        numlb.center=CGPointMake(XW(logoview)-12, 22);
        [homegridview addSubview:numlb];
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, W(homegridview), H(homegridview));
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.tag=tag;
    [homegridview addSubview:btn];
    return homegridview;
}

- (NSInteger)rowCountWithItemsCount:(NSInteger)count
{
    NSInteger rowCount=count/kPerRowCount;
    if (count%kPerRowCount!=0) {
        rowCount++;
    }
    return rowCount;
}
#pragma mark--------------banner广告点击----------
-(void)turntoImg:(UIButton *)sender
{
    
    
}
#pragma mark-------------进入到模块---------------
-(void)turntoSEL:(UIButton*)sender
{
    NSString *titlestr=[homePageList objectAtIndex:sender.tag-1000];
    if (sender.tag==1000) {
        LBNoticeViewController *lbnoticview=[[LBNoticeViewController alloc]init];
        lbnoticview.title=titlestr;
        [self.navigationController pushViewController:lbnoticview animated:YES];
    }else if (sender.tag==1001)
    {
        LBAgentsViewController *lbnoticview=[[LBAgentsViewController alloc]init];
        lbnoticview.title=titlestr;
        [self.navigationController pushViewController:lbnoticview animated:YES];
        
    }else if (sender.tag==1002)
    {
        LBCheckViewController *lbnoticview=[[LBCheckViewController alloc]init];
        lbnoticview.title=titlestr;
        [self.navigationController pushViewController:lbnoticview animated:YES];
    }else if (sender.tag==1003)
    {
        LBMsgBoxViewController *lbnoticview=[[LBMsgBoxViewController alloc]init];
        lbnoticview.title=[NSString stringWithFormat:@"%@（暂不支持附件改稿上传）",titlestr];
        [self.navigationController pushViewController:lbnoticview animated:YES];
    }else if (sender.tag==1004)
    {
        LBMyTravelViewController *lbnoticview=[[LBMyTravelViewController alloc]init];
        lbnoticview.title=titlestr;
        [self.navigationController pushViewController:lbnoticview animated:YES];
    }else if (sender.tag==1005)
    {
        LBMoreViewController *lbnoticview=[[LBMoreViewController alloc]init];
        lbnoticview.title=titlestr;
        [self.navigationController pushViewController:lbnoticview animated:YES];
    }
    
}
#pragma mark-----------界面初始化-----------------
-(void)initview
{
    lbworktb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    lbworktb.showsVerticalScrollIndicator=NO;
    lbworktb.dataSource=self;
    lbworktb.delegate=self;
    lbworktb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbworktb];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    lbworktb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [SVProgressHUD showWithStatus:@"加载中...." maskType:SVProgressHUDMaskTypeClear];
    // 马上进入刷新状态
    [lbworktb.mj_header beginRefreshing];
}
#pragma mark------------------加载数据---------------
-(void)loadNewData{
    
    [SHNetWork home:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"stralldwlsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([rep isKindOfClass:[NSDictionary class]]) {
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD dismiss];
                    homedic=[[NSDictionary alloc]initWithDictionary:rep];
                    [lbworktb reloadData];
                }
                
                else
                {
                    [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
                }
            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
        [lbworktb.mj_header endRefreshing];
    }];
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
