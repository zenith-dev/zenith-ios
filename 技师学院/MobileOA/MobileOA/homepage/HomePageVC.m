//
//  HomePageVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/23.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageCell.h"
#import "ztOASettingViewController.h"
#import "NoticeGGVC.h"
#import "AddressBookListVC.h"
#import "SdmkListVC.h"
#import "DocmentSearchVC.h"
#import "ThePortalNewsVC.h"
#import "MsgAlertVC.h"
#import "DocmentTodoListVC.h"
#import "PersonCenterVC.h"
#import "GTMBase64.h"
#import "PlanningDocVC.h"
@interface HomePageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *i_DocNum;//待办公文数量
    NSString *i_EmailNum;
    NSString *i_tzNum;//通知数量
    NSString *i_ggNum;//公告数量
    
}
@property(nonatomic,strong)UIImageView      *titleView;
@property(nonatomic,strong)UIImageView         *userHeadImgBtn;
@property(nonatomic,strong)UILabel          *titleLable;
@property(nonatomic,strong)UICollectionView *homepageCollection;
@property(nonatomic,strong)NSArray *itemArray;
@end

@implementation HomePageVC
@synthesize titleView,userHeadImgBtn,titleLable,homepageCollection,itemArray;
- (void)viewDidLoad {
    [super viewDidLoad];
        [self rightButton:nil image:@"设置" sel:@selector(toSettingCenter)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkVPN) name:@"HomePage" object:nil];
    //初始化界面
    self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, ScaleBI(120))];
    self.titleView.backgroundColor = [UIColor whiteColor];
    titleView.image = [UIImage imageNamed:@"headView_titleBar_Img"];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    
    userHeadImgBtn =[[UIImageView alloc]initWithFrame:CGRectMake(ScaleBI(20), 0, ScaleBI(80), ScaleBI(80))];
    [userHeadImgBtn setImage:PNGIMAGE(@"headView_titleBar_userImg_normal")];
    ViewRadius(userHeadImgBtn, userHeadImgBtn.height/2.0);
    if (SingObj.userInfo.userhaderImg!=nil) {
        [userHeadImgBtn setImage:SingObj.userInfo.userhaderImg];
    }
    userHeadImgBtn.userInteractionEnabled=YES;
    [userHeadImgBtn bk_whenTapped:^{
        [self goPersnalCenter];
    }];
    userHeadImgBtn.clipsToBounds=YES;
    userHeadImgBtn.contentMode=UIViewContentModeScaleAspectFill;
    userHeadImgBtn.centerY=titleView.height/2.0;
    [titleView addSubview:userHeadImgBtn];
    
    UILabel *datelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth-15, 20)];
    datelb.textAlignment=NSTextAlignmentRight;
    datelb.font = [UIFont systemFontOfSize:15.0f];
    [titleView addSubview:datelb];
    NSDate*date = [NSDate date];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents*comps;
    comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit|NSWeekdayOrdinalCalendarUnit)fromDate:date];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger weekday = [comps weekday];
    datelb.text=[NSString stringWithFormat:@"%@年%@月%@日 星期%@",@(year),@(month),@(day),weekday==1?@"日":weekday==2?@"一":weekday==3?@"二":weekday==4?@"三":weekday==5?@"四":weekday==6?@"五":@"六"];
    titleLable = [[UILabel alloc] initWithFrame:CGRectMake(userHeadImgBtn.right+15, 0 , kScreenWidth-15-userHeadImgBtn.right, 60)];
    titleLable.centerY=userHeadImgBtn.centerY;
    titleLable.text = [NSString stringWithFormat:@"欢迎您，\n%@",SingObj.userInfo.username];
    titleLable.numberOfLines=2;
    NSLog(@"%@",SingObj.userInfo.username);
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = [UIFont systemFontOfSize:15.0f];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = [UIColor blackColor];
    [titleView addSubview:titleLable];
    itemArray =@[@{@"icon":@"icon_dp",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"待办公文"},
                 @{@"icon":@"icon_gw",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"公文查询"},
                 @{@"icon":@"icon_td",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"签报件查询"},
                 @{@"icon":@"icon_gw",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"便函查询"},
                 @{@"icon":@"icon_qz",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"个人公文"},
                 @{@"icon":@"icon_sq",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"资料 文档"},
                 @{@"icon":@"icon_gg",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"通知公告"},
                 @{@"icon":@"icon_txl",@"bgColor":UIColorFromRGB(0xfaaa21),@"title":@"通讯录"},
//                 @{@"icon":@"icon_gwb",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"门户新闻"},
//                 @{@"icon":@"icon-sc",@"bgColor":UIColorFromRGB(0xfaaa21),@"title":@"历史库查询"},
//                 @{@"icon":@"icon_yj",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"消息提醒"},
                 @{@"icon":@"icon_telphone",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"电话处理单"}];
    float iconw=(kScreenWidth-((3+1)*5))/3.0;
    float iconh=((self.view.height-titleView.bottom)-((3+1)*5))/3.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(iconw, iconh);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    homepageCollection= [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleView.bottom, kScreenWidth, self.view.height-titleView.bottom) collectionViewLayout:layout];
    [homepageCollection registerClass:[HomePageCell class]forCellWithReuseIdentifier:@"cell"];
    homepageCollection.backgroundColor = [UIColor whiteColor];
    homepageCollection.delegate = self;
    homepageCollection.dataSource = self;
    [self.view addSubview:homepageCollection];
    [self initWithData];
    [self getGgNum];
    [self getTznum];
    [self downloadHeadImage];

}
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return itemArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HomePageCell *cell = (HomePageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSDictionary *celldic=itemArray[indexPath.row];
    [cell setBackgroundColor:celldic[@"bgColor"]];
    [cell.iconImageView setImage:PNGIMAGE(celldic[@"icon"])];
    cell.titlelb.text=celldic[@"title"];
    cell.numlb.hidden=YES;
    if ([celldic[@"title"] isEqualToString:@"公告"]&&[i_ggNum intValue]!=0) {
        cell.numlb.text=i_ggNum;
        cell.numlb.hidden=NO;
    }
    if ([celldic[@"title"] isEqualToString:@"通知公告"]&&[i_tzNum intValue]!=0) {
        cell.numlb.text=i_tzNum;
        cell.numlb.hidden=NO;
    }
    if ([celldic[@"title"] isEqualToString:@"待办公文"]&&[i_DocNum intValue]!=0) {
        cell.numlb.text=i_DocNum;
        cell.numlb.hidden=NO;
    }
    if ([celldic[@"title"] isEqualToString:@"邮件系统"]&&[i_EmailNum intValue]!=0) {
        cell.numlb.text=i_EmailNum;
        cell.numlb.hidden=NO;
    }
    return cell;
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *celldic=itemArray[indexPath.row];
    NSString *title=celldic[@"title"];
    if ([title isEqualToString:@"待办公文"]) {
        DocmentTodoListVC *docmentTodo=[[DocmentTodoListVC alloc]initWithTitle:title];
        docmentTodo.type=@"016";
        docmentTodo.callback=^(BOOL isSu){
            if (isSu==YES) {
                [self initWithData];
            }
        };
        [self.navigationController pushViewController:docmentTodo animated:YES];
    }else if ([title isEqualToString:@"公文查询"])
    {
        DocmentSearchVC *docomentsearcvc=[[DocmentSearchVC alloc]initWithTitle:title];
        docomentsearcvc.type=@"014";
        [self.navigationController pushViewController:docomentsearcvc animated:YES];
    }else if ([title isEqualToString:@"签报件查询"])
    {
        SdmkListVC *sdmklist=[[SdmkListVC alloc]initWithTitle:title];
        sdmklist.type=@"010";
        [self.navigationController pushViewController:sdmklist animated:YES];
    }else if ([title isEqualToString:@"便函查询"])
    {
        SdmkListVC *sdmklist=[[SdmkListVC alloc]initWithTitle:title];
        sdmklist.type=@"011";
        [self.navigationController pushViewController:sdmklist animated:YES];
    }else if ([title isEqualToString:@"信访查询"])
    {
        SdmkListVC *sdmklist=[[SdmkListVC alloc]initWithTitle:title];
        sdmklist.type=@"012";
        [self.navigationController pushViewController:sdmklist animated:YES];
    }else if ([title isEqualToString:@"通知公告"])
    {
        NoticeGGVC *noticevc=[[NoticeGGVC alloc]initWithTitle:title];
        noticevc.type=2;
        noticevc.callback=^(BOOL issu){
            if (issu==YES) {
                [self getTznum];
            }
        };
        [self.navigationController pushViewController:noticevc animated:YES];
    }else if ([title isEqualToString:@"公告"])
    {
        NoticeGGVC *noticevc=[[NoticeGGVC alloc]initWithTitle:title];
        noticevc.type=1;
        noticevc.callback=^(BOOL issu){
            if (issu==YES) {
                [self getGgNum];
            }
        };
        [self.navigationController pushViewController:noticevc animated:YES];
    }else if ([title isEqualToString:@"通讯录"])
    {
        AddressBookListVC *addressBookList=[[AddressBookListVC alloc]initWithTitle:title];
        addressBookList.currentCompanylsh=@"";
        [self.navigationController pushViewController:addressBookList animated:YES];
    }else if ([title isEqualToString:@"门户新闻"])
    {
        ThePortalNewsVC *theportalnews=[[ThePortalNewsVC alloc]initWithTitle:title];
        [self.navigationController pushViewController:theportalnews animated:YES];
    }else if ([title isEqualToString:@"历史库查询"])
    {
        DocmentSearchVC *docomentsearcvc=[[DocmentSearchVC alloc]initWithTitle:title];
        docomentsearcvc.type=@"015";
        [self.navigationController pushViewController:docomentsearcvc animated:YES];
        
    }else if ([title isEqualToString:@"消息提醒"])
    {
        MsgAlertVC *msgalert=[[MsgAlertVC alloc]initWithTitle:title];
        [self.navigationController pushViewController:msgalert animated:YES];        
    }else if ([title isEqualToString:@"电话处理单"])
    {
        SdmkListVC *sdmklist=[[SdmkListVC alloc]initWithTitle:title];
        sdmklist.type=@"013";
        [self.navigationController pushViewController:sdmklist animated:YES];
    }
    else if ([title isEqualToString:@"个人公文"])
    {
        SdmkListVC *sdmklist=[[SdmkListVC alloc]initWithTitle:title];
        sdmklist.type=@"017";
        [self.navigationController pushViewController:sdmklist animated:YES];
    }
    else if([title isEqualToString:@"资料 文档"]){
        PlanningDocVC *planndoc=[[PlanningDocVC alloc]initWithTitle:@"资料文档"];
        [self.navigationController pushViewController:planndoc animated:YES];
    }
}
#pragma mark------------进入个人中心---------
- (void)goPersnalCenter{
    PersonCenterVC *personCenterVC=[[PersonCenterVC alloc]initWithTitle:@"个人中心"];
    personCenterVC.callback=^(BOOL issu){
        if (issu==YES) {
            [self downloadHeadImage];
        }
    };
    personCenterVC.callbackGW=^(BOOL issu){
        if (issu==YES) {
            [self initWithData];
        }
    };
    personCenterVC.callbackGG=^(BOOL issu){
        if (issu==YES) {
            [self getTznum];
        }
    };
    [self.navigationController pushViewController:personCenterVC animated:YES];
}
//查看设置
- (void)toSettingCenter
{
    ztOASettingViewController *ztoaset=[[ztOASettingViewController alloc]initWithTitle:@"设置"];
    [self.navigationController pushViewController:ztoaset animated:YES];
}
#pragma mark------ 获取未读数据--------
- (void)initWithData
{
    //待办公文
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh", @(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh",nil];
    [self networkall:@"document" requestMethod:@"getDclgwNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_DocNum=@"";
        }else
        {
            i_DocNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [homepageCollection reloadData];
    }];
}
#pragma mark--------------公告未读条数-------------
-(void)getGgNum{
    
    //公告未读条数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",nil];
    [self networkall:@"ggservices" requestMethod:@"getGgNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_ggNum=@"";
        }else
        {
            i_ggNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [homepageCollection reloadData];
    }];
}
#pragma mark-----------通知的未读数量-------------
-(void)getTznum{
    //通知未读条数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",nil];
    [self networkall:@"tzServices" requestMethod:@"getTzNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_tzNum=@"";
        }else
        {
            i_tzNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [homepageCollection reloadData];
    }];

}


#pragma mark------------邮件未读条数-----------
-(void)getNbyjNum{
    //邮件未读条数
    NSString *emailXml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt></strtzbt><strryxm></strryxm><dtmdjsj1></dtmdjsj1><dtmdjsj2></dtmdjsj2><querytype>2</querytype></root>";
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",emailXml,@"queryTermXML",nil];
    [self networkall:@"nbyjServices" requestMethod:@"getNbyjNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_EmailNum=@"";
        }else
        {
            i_EmailNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [homepageCollection reloadData];
    }];
}
#pragma mark--------------获取头像-----------
//获取头像
- (void)downloadHeadImage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh", nil];
    [self network:@"usercenter" requestMethod:@"downloadRyxp" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep!=nil) {
            NSString *content = [[rep objectForKey:@"fj"] objectForKey:@"content"];
            NSData *filecontent = [GTMBase64 decodeString:content];
            UIImage *image = [UIImage imageWithData:filecontent];
            if (image) {
                SingObj.userInfo.userhaderImg=image;
                [userHeadImgBtn setImage:image] ;
            }
        }
    }];
}
-(void)linkVPN{
    
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
