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
#import "HomePageCell.h"
#import "ZtOASummaryVC.h"
@interface ztOANewMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSString *i_DocNum;//待办公文数量
    NSString *i_InformNum;//通知数量
    NSString *i_EmailNum;//通知数量
    NSString *i_ggNum;//公告数量
    
    int     i_allPages;
    NSMutableArray    *viewInfoArray;
}
@property(nonatomic,strong)UIScrollView     *mainView;
@property(nonatomic,strong)UIImageView      *titleView;
@property(nonatomic,strong)UIButton         *userHeadImgBtn;
@property(nonatomic,strong)UILabel          *titleLable;

@property(nonatomic,strong)UICollectionView *homepageCollection;
@property(nonatomic,strong)NSArray *itemArray;

@end

@implementation ztOANewMainViewController
@synthesize mainView,titleView,userHeadImgBtn,titleLable,itemArray,homepageCollection;


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
    self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 150)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    titleView.image = [UIImage imageNamed:@"banner"];
    titleView.userInteractionEnabled = YES;
    [self.view addSubview:titleView];
    
    UIImageView *logoimg=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 68, 32)];
    [logoimg setImage:PNGIMAGE(@"logo")];
    logoimg.userInteractionEnabled=YES;
    [titleView addSubview:logoimg];
    
    UIButton *logbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logbtn.frame=logoimg.frame;[logbtn addTarget:self action:@selector(goPersnalCenter) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:logbtn];

    
    UILabel *timelb=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-118, logoimg.top, 110, 60)];
    
    timelb.textAlignment=NSTextAlignmentCenter;
    timelb.font=Font(14);
    timelb.numberOfLines=0;
    timelb.text=[NSString stringWithFormat:@"%@\n%@\n%@",[self gettime],[self getChineseCalendarWithDate:[NSDate new]],[self getWeek]];
    [titleView addSubview:timelb];
    self.userHeadImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userHeadImgBtn.frame = CGRectMake(20, 20, 80, 80);
    [userHeadImgBtn setImage:[UIImage imageNamed:@"headView_titleBar_userImg_normal"] forState:UIControlStateNormal] ;
    [userHeadImgBtn.layer setCornerRadius:40];
    [userHeadImgBtn setClipsToBounds:YES];
    userHeadImgBtn.backgroundColor = [UIColor clearColor];
    [self.userHeadImgBtn addTarget:self action:@selector(goPersnalCenter) forControlEvents:UIControlEventTouchUpInside];
   // [titleView addSubview:userHeadImgBtn];
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, self.view.width-120, 20)];
    self.titleLable.text = [NSString stringWithFormat:@"欢迎您，%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.font = [UIFont systemFontOfSize:15.0f];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = [UIColor blackColor];
    //[titleView addSubview:titleLable];
    itemArray =@[@{@"icon":@"ico01",@"bgColor":UIColorFromRGB(0xff9a00),@"title":@"待办公文"},
                 @{@"icon":@"ico02",@"bgColor":UIColorFromRGB(0x00529e),@"title":@"通知公告"},
                 @{@"icon":@"ico05",@"bgColor":UIColorFromRGB(0xc49e00),@"title":@"会议纪要"},
                 @{@"icon":@"ico06",@"bgColor":UIColorFromRGB(0x0086e1),@"title":@"通讯录"},
                 @{@"icon":@"ico03",@"bgColor":UIColorFromRGB(0x68c746),@"title":@"公文查询"},
                 @{@"icon":@"ico04",@"bgColor":UIColorFromRGB(0x00aed8),@"title":@"资源共享"}];
    float iconw=(kScreenWidth-((3+1)*20))/3.0;
    float iconh=iconw+15;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(iconw, iconh);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    homepageCollection= [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleView.bottom, kScreenWidth, kScreenHeight-titleView.bottom) collectionViewLayout:layout];
    [homepageCollection registerClass:[HomePageCell class]forCellWithReuseIdentifier:@"cell"];
    homepageCollection.backgroundColor = [UIColor whiteColor];
    homepageCollection.delegate = self;
    homepageCollection.dataSource = self;
    [self.view addSubview:homepageCollection];
    
    UIImageView *twxt=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 225, 50)];
    twxt.contentMode=UIViewContentModeScaleAspectFit;
    [twxt setImage:PNGIMAGE(@"text")];
    twxt.bottom=kScreenHeight-30;
    twxt.centerX=kScreenWidth/2.0;
    [self.view addSubview:twxt];
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
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return itemArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    HomePageCell *cell = (HomePageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    ViewRadius(cell, 4);
    NSDictionary *celldic=itemArray[indexPath.row];
    [cell setBackgroundColor:celldic[@"bgColor"]];
    [cell.iconImageView setImage:PNGIMAGE(celldic[@"icon"])];
    cell.titlelb.text=celldic[@"title"];
    cell.numlb.hidden=YES;
    if ([celldic[@"title"] isEqualToString:@"待办公文"]&&[i_DocNum intValue]!=0) {
        cell.numlb.text=i_DocNum;
        cell.numlb.hidden=NO;
    }
    if ([celldic[@"title"] isEqualToString:@"通知公告"]&&[i_ggNum intValue]!=0) {
        cell.numlb.text=i_ggNum;
        cell.numlb.hidden=NO;
    }
    if ([celldic[@"title"] isEqualToString:@"邮件系统"]&&[i_EmailNum intValue]!=0) {
        cell.numlb.text=i_EmailNum;
        cell.numlb.hidden=NO;
    }
    return cell;
}




#pragma mark------ 获取未读数据--------
- (void)initWithData
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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
        }
        
        int iconint=[[UIApplication sharedApplication] applicationIconBadgeNumber]+[i_DocNum intValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:iconint];
        
    } Failed:^(NSError *error){
        i_DocNum=@"";
    }];
    //公告未读条数
    NSDictionary *ggDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",nil];
    [ztOAService getggNum:ggDic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if (([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            
            i_ggNum=@"";
        }
        else
        {
            i_ggNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
        }
        int iconint=[[UIApplication sharedApplication] applicationIconBadgeNumber]+[i_ggNum intValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:iconint];
    } Failed:^(NSError *error){
        //[self closeWaitView];
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
        }
        int iconint=[[UIApplication sharedApplication] applicationIconBadgeNumber]+[i_EmailNum intValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:iconint];
    } Failed:^(NSError *error){
        //[self closeWaitView];
        i_EmailNum=@"";
    }];
    
}
//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *celldic=itemArray[indexPath.row];
    NSString *title=celldic[@"title"];
    if ([title isEqualToString:@"待办公文"]) {
        //待办公文
        NSString  *searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @"",
                                   @""];
        ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"1" withTitle:@"待办公文" queryTerm:searchBarStr];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if ([title isEqualToString:@"资源共享"])
    {
        ztOAPublicationSearchResultViewController *resultVC = [[ztOAPublicationSearchResultViewController alloc] init];
        resultVC.title=@"资源共享";
        [self.navigationController pushViewController:resultVC animated:YES];
    }else if ([title isEqualToString:@"通知公告"])
    {
        ztggListOAViewController *listVC=[[ztggListOAViewController alloc]initWithTitle:@"通知公告"];
        [self.navigationController pushViewController:listVC animated:YES];
    }else if ([title isEqualToString:@"通讯录"])
    {
        //彭水的
        ztOANewBookListVC *vc=[[ztOANewBookListVC alloc]init];
        vc.currentCompanylsh=@"";
        vc.title=@"通讯录";
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"公文查询"])
    {
        ztOAOfficialDocSearchViewController *searchDocVC =[[ztOAOfficialDocSearchViewController alloc]init];
        searchDocVC.title=@"公文查询";
        [self.navigationController pushViewController:searchDocVC animated:YES];
    }else if ([title isEqualToString:@"会议纪要"])
    {
        ZtOASummaryVC *searchDocVC =[[ZtOASummaryVC alloc]init];
        searchDocVC.title=title;
        [self.navigationController pushViewController:searchDocVC animated:YES];
    }
    else if ([title isEqualToString:@"内部邮件"])
    {
        //邮件系统
        ztOAEmailListViewController *listVC = [[ztOAEmailListViewController alloc] initWithTitle:@"内部邮件"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
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
-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%d_%d_%d  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@年%@%@",y_str,m_str,d_str];
    
    return chineseCal_str;  
}
-(NSString*)gettime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
    NSLog(@"%@",currentDateStr);
}
- (NSString*)getWeek
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSLog(@"星期:%@", [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]]);
    return [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:[comps weekday] - 1]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

