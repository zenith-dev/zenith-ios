//
//  ztOANewMainViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-4-21.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOANewMainViewController.h"
#import "ztOAGlobalVariable.h"
#import "ztOADetailInfoListViewController.h"
#import "ztOAPublicationSearchViewController.h"
#import "ztOAOfficialDocSearchViewController.h"
#import "CXAlertView.h"
#import "ztOAMainDocViewController.h"
#import "ztggListOAViewController.h"
#import "ztWeekCalendarOAViewController.h"
#import "ztOANewBookListVC.h"
#import "ztMeetVC.h"
#import "LeaderSearchVC.h"
#import "HomePageCell.h"
#import "ZwxxVC.h"
#import "YwzdCsVC.h"
#import <PgyUpdate/PgyUpdateManager.h>
@interface ztOANewMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *i_DocNum;//待办公文数量
    NSString *i_EmailNum;//通知数量
    NSString *i_ggNum;//公告数量

}
@property(nonatomic,strong)UIImageView      *titleView;
@property(nonatomic,strong)UIButton         *userHeadImgBtn;
@property(nonatomic,strong)UILabel          *titleLable;
@property(nonatomic,strong)UICollectionView *homepageCollection;
@property(nonatomic,strong)NSArray *itemArray;
@end

@implementation ztOANewMainViewController
@synthesize titleView,userHeadImgBtn,titleLable,homepageCollection,itemArray;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    if ([self isLogin]) {
        [self initWithData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightButton:nil imagen:@"loading_setting_btn_off" imageh:nil sel:@selector(toSettingCenter)];
    //初始化界面
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 120)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    titleView.image = [UIImage imageNamed:@"headView_titleBar_Img.jpg"];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    UIButton *bgbtn=[[UIButton alloc]initWithFrame:self.titleView.bounds];
    [bgbtn setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:bgbtn];
    [bgbtn addTarget:self action:@selector(goPersnalCenter) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:bgbtn];
    
    
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
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kScreenWidth-15, 20)];
    self.titleLable.text = [NSString stringWithFormat:@"欢迎您，%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = [UIFont systemFontOfSize:15.0f];
    titleLable.textAlignment = NSTextAlignmentRight;
    titleLable.textColor = [UIColor blackColor];
    titleLable.bottom=titleView.height-20;
    [titleView addSubview:titleLable];
    itemArray =@[@{@"icon":@"icon_gg",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"最新公告"},@{@"icon":@"icon_gw",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"公文查询"},@{@"icon":@"icon_dp",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"待办公文"},@{@"icon":@"icon_gw",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"个人公文"},@{@"icon":@"icon_gw",@"bgColor":UIColorFromRGB(0x18b6f7),@"title":@"历史库查询"},@{@"icon":@"icon_sq",@"bgColor":UIColorFromRGB(0x1ff687b),@"title":@"领导讲话"},@{@"icon":@"icon_qz",@"bgColor":UIColorFromRGB(0xfaaa21),@"title":@"政务信息"},@{@"icon":@"icon_td",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"信息刊物"},@{@"icon":@"icon_gwb",@"bgColor":UIColorFromRGB(0xfaaa21),@"title":@"业务指导"},@{@"icon":@"icon_txl",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"通讯录"},@{@"icon":@"icon_yj",@"bgColor":UIColorFromRGB(0xfaaa21),@"title":@"邮件系统"},@{@"icon":@"icon-sc",@"bgColor":UIColorFromRGB(0x83bd07),@"title":@"我的收藏"}];
    float iconw=(kScreenWidth-((3+1)*5))/3.0;
    float iconh=((self.view.height-titleView.bottom)-((4+1)*5))/4.0;
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
    if ([celldic[@"title"] isEqualToString:@"最新公告"]&&[i_ggNum intValue]!=0) {
        cell.numlb.text=i_ggNum;
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
    if ([title isEqualToString:@"最新公告"]) {
        ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"2" withTitle:@"通知公告" queryTerm:@""];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if ([title isEqualToString:@"公文查询"])
    {
        ztOAOfficialDocSearchViewController *searchDocVC =[[ztOAOfficialDocSearchViewController alloc]init];
        searchDocVC.title=title;
        [self.navigationController pushViewController:searchDocVC animated:YES];
    }else if ([title isEqualToString:@"待办公文"])
    {
        NSString  *searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"1" withTitle:@"待办公文" queryTerm:searchBarStr];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if ([title isEqualToString:@"个人公文"])
    {
        
        NSString  *searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?> <root><strgwbt></strgwbt></root>"];
        ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"4" withTitle:title queryTerm:searchBarStr];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if ([title isEqualToString:@"历史库查询"])
    {
        ztOAOfficialDocSearchViewController *searchDocVC =[[ztOAOfficialDocSearchViewController alloc]init];
        searchDocVC.title=title;
        searchDocVC.i_type=1;
        [self.navigationController pushViewController:searchDocVC animated:YES];
    }else if ([title isEqualToString:@"领导讲话"])
    {
        LeaderSearchVC *leadership=[[LeaderSearchVC alloc]init];
        leadership.title=@"领导讲话查询";
        [self.navigationController pushViewController:leadership animated:YES];
    }else if ([title isEqualToString:@"政务信息"])
    {
        ZwxxVC *zwxxvc=[[ZwxxVC alloc]init];
        zwxxvc.title=title;
        [self.navigationController pushViewController:zwxxvc animated:YES];
    }else if ([title isEqualToString:@"信息刊物"])
    {
        //刊物
        ztOAPublicationSearchResultViewController *resultVC = [[ztOAPublicationSearchResultViewController alloc] init];
        resultVC.title=title;
        [self.navigationController pushViewController:resultVC animated:YES];

    }else if ([title isEqualToString:@"业务指导"])
    {
        YwzdCsVC *yezdcs=[[YwzdCsVC alloc]init];
        yezdcs.title=title;
        [self.navigationController pushViewController:yezdcs animated:YES];
    }else if ([title isEqualToString:@"通讯录"])
    {
        ztOANewBookListVC *vc=[[ztOANewBookListVC alloc]init];
        vc.currentCompanylsh=@"";
        vc.title=@"通讯录";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"邮件系统"])
    {
        //邮件系统
        ztOAEmailListViewController *listVC = [[ztOAEmailListViewController alloc] initWithTitle:@"内部邮件"];
        [self.navigationController pushViewController:listVC animated:YES];
        
    }else if ([title isEqualToString:@"我的收藏"])
    {
        //我的收藏
        ztOAPersonalCollectViewController *collectVC = [[ztOAPersonalCollectViewController alloc] initWithType:@"公文" withTitle:@"我的收藏"];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    
    
    
}
- (void)reflashHeadImage
{
    //判断
    [userHeadImgBtn setImage:[UIImage imageNamed:@"headView_titleBar_userImg_normal"] forState:UIControlStateNormal] ;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"]!=nil) {
        NSString *imageLocalName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"]?:@"";
        if ([imageLocalName isEqualToString:[ztOAGlobalVariable sharedInstance].userHeadPicName]) {
            
            NSString *imagePath = [self UrlFromPathOfDocuments:[NSString stringWithFormat:@"/headImage_tt0711/%@",imageLocalName]];
            UIImage* headImage = [UIImage imageWithContentsOfFile:imagePath];
            if (headImage!=nil) {
                [userHeadImgBtn setImage:headImage forState:UIControlStateNormal] ;
            }
        }
        else
        {
            [self downloadHeadImage];
        }
    }
    else
    {
        [self downloadHeadImage];
    }
}



//获取头像
- (void)downloadHeadImage
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh", nil];
    [ztOAService downloadUserHeadImage:dic Success:^(id result){
        //[self closeWaitView];
        NSDictionary *dicData = [result objectFromJSONData];
        if ([[dicData objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            
            if ([[[dicData objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"]!=NULL) {
               
                NSString *fjName = [ztOAGlobalVariable sharedInstance].userHeadPicName;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                NSString *filePath = [documentsDirectory stringByAppendingString:@"/headImage_tt0711/"];
                filePath = [filePath stringByAppendingString:fjName];
                //清理图片
                NSFileManager *fileManage = [NSFileManager defaultManager];
                if (![fileManage fileExistsAtPath:[documentsDirectory stringByAppendingString:@"/headImage_tt0711/"]]) {
                    [fileManage createDirectoryAtPath:[documentsDirectory stringByAppendingString:@"/headImage_tt0711/"] withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSArray *files = [fileManage contentsOfDirectoryAtPath:[documentsDirectory stringByAppendingString:@"/headImage_tt0711/"] error:nil];
                for (NSString *fileName in files) {
                    [fileManage removeItemAtPath:[NSString stringWithFormat:@"%@/%@", [documentsDirectory stringByAppendingString:@"/headImage_tt0711/"], fileName] error:nil];
                }
                
                NSString *content = [[[dicData objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
                NSData *filecontent = [GTMBase64 decodeString:content];
                
                [filecontent writeToFile:filePath atomically:true];

                UIImage *image = [UIImage imageWithData:filecontent];
                if (image!=nil) {
                    [userHeadImgBtn setImage:image forState:UIControlStateNormal] ;
                    
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:fjName forKey:@"USERHEADIMAGENAME"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }                
            }
        }
        
    } Failed:^(NSError *error){
        
    }];
    
}
#pragma mark------ 获取未读数据--------
- (void)initWithData
{
    self.titleLable.text = [NSString stringWithFormat:@"欢迎您，%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    [self reflashHeadImage];//获取头像
    //待办公文
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh", [ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",nil];
    [ztOAService getOfficeDocNumber:dic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if ( ([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_DocNum=@"";
        }
        else
        {
            i_DocNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [homepageCollection reloadData];
        }
    } Failed:^(NSError *error){
        i_DocNum=@"";
    }];
    //通知未读条数
    NSDictionary *ggDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",nil];
    [ztOAService getInformNumber:ggDic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if (([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_ggNum=@"";
        }
        else
        {
            i_ggNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [homepageCollection reloadData];
        }
    } Failed:^(NSError *error){
        i_ggNum=@"";
    }];
    //邮件系统
    NSString *emailXml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt></strtzbt><strryxm></strryxm><dtmdjsj1></dtmdjsj1><dtmdjsj2></dtmdjsj2><querytype>2</querytype></root>";
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",emailXml,@"queryTermXML",nil];
    [ztOAService getEmailNumber:emailDic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if (([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_EmailNum=@"";
        }
        else
        {
            i_EmailNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [homepageCollection reloadData];
        }
    } Failed:^(NSError *error){
        //[self closeWaitView];
        i_EmailNum=@"";
    }];
}
//进入个人中心
- (void)goPersnalCenter{
    ztOAPersonalCenterViewController *userVC = [[ztOAPersonalCenterViewController alloc] init];
    userVC.title=@"个人中心";
    [self.navigationController pushViewController:userVC animated:YES];
}
//查看设置
- (void)toSettingCenter
{
    ztOASettingViewController *settingVC = [[ztOASettingViewController alloc] init];
    settingVC.title=@"设置";
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

