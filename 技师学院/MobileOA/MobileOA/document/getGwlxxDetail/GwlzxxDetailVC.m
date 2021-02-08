//
//  GwlzxxDetailVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/2.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "GwlzxxDetailVC.h"
#import "DealFjVC.h"
#import "LbzbCell.h"
@interface GwlzxxDetailVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UILabel *slidLabel;
@property (nonatomic,strong)UIButton *gwxqBtn;//公文详情
@property (nonatomic,strong)UIButton *cllcBtn;//处理详情
@property (nonatomic,strong)NSMutableArray *fjary;
@property (nonatomic,strong)UITableView *lzbztb;//流转步骤
@property (nonatomic,strong)NSMutableArray *lbzbary;//流转步骤列表
@property (nonatomic,strong)UIButton *conerightBtn;
@end

@implementation GwlzxxDetailVC
@synthesize intgwlzlsh,slidLabel,gwxqBtn,cllcBtn,tableScrollView,fjary,type,ngrqstr,lzbztb,lbzbary,gwlx,docmentModel,conerightBtn,doctodomodel,sdmkmodel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    conerightBtn=[self rightButton:nil imagen:@"btn_fav_no_n" imageh:nil sel:@selector(collectDocAction:)];
    [conerightBtn setImage:PNGIMAGE(@"btn_fav_yes_n") forState:UIControlStateSelected];
    NSMutableArray *gwscAry=[[NSUserDefaults standardUserDefaults]objectForKey:@"gwsc"];
    if (doctodomodel!=nil) {
        for (NSDictionary *docd in gwscAry) {
            if ([[docd mj_JSONString] isEqualToString:[doctodomodel mj_JSONString]]) {
                conerightBtn.selected=YES;
                break;
            }
        }
    }else if (sdmkmodel!=nil)
    {
        for (NSDictionary *docd in gwscAry) {
            if ([[docd mj_JSONString] isEqualToString:[sdmkmodel mj_JSONString]]) {
                conerightBtn.selected=YES;
                break;
            }
        }
    }
    if ([type isEqualToString:@"015"]) {
        conerightBtn.hidden=YES;
    }
    [self getGwlzxx];
    
    // Do any additional setup after loading the view.
}
#pragma mark-------------收藏-------------
-(void)collectDocAction:(UIButton*)sender
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gwsc"]);
    NSArray *gwscAry=[[NSUserDefaults standardUserDefaults]objectForKey:@"gwsc"];
    NSMutableArray *newsearchRecordArray = [NSMutableArray arrayWithArray:gwscAry];
    sender.selected=!sender.selected;
    if (sender.selected==YES) {
        if (doctodomodel!=nil) {
             [newsearchRecordArray addObject:[doctodomodel mj_keyValues]];
        }
       else if(sdmkmodel!=nil)
       {
           [newsearchRecordArray addObject:[sdmkmodel mj_keyValues]];
       }
        [self showMessage:@"收藏成功！"];
    }
    else
    {
        if (doctodomodel!=nil) {
            [newsearchRecordArray removeObject:[doctodomodel mj_keyValues]];
        }else if (sdmkmodel!=nil)
        {
           [newsearchRecordArray removeObject:[sdmkmodel mj_keyValues]];
        }
        [self showMessage:@"取消收藏"];
    }
    NSArray *tempary=[[NSArray alloc]initWithArray:newsearchRecordArray];
    [[NSUserDefaults standardUserDefaults]setObject:tempary forKey:@"gwsc"];
}
#pragma mark------------公文详情 ---------------
-(void)getGwlzxx{
    //历史库查询
    if ([type isEqualToString:@"015"]) {
        [self networkall:@"document" requestMethod:@"getLsGwlzxx" requestHasParams:@"true" parameter:@{@"intgwlsh":intgwlzlsh,@"gwlx":gwlx} progresHudText:@"加载中..." completionBlock:^(id rep) {
            if ([rep[@"gw"][@"result"] intValue]==0) {
                if ([rep[@"gw"][@"gwgs"] isKindOfClass:[NSDictionary class]]) {
                    [self getinfoViews:rep[@"gw"][@"gwgs"]];
                }else
                {
                    [self showMessage:@"数据错误"];
                }
            }
        }];
    }else if([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"013"]||[type isEqualToString:@"014"]||[type isEqualToString:@"017"]||[type isEqualToString:@"016"])
    {
        [self networkall:@"document" requestMethod:@"getGwlzxx" requestHasParams:@"true" parameter:@{@"intgwlzlsh":intgwlzlsh} progresHudText:@"加载中..." completionBlock:^(id rep) {
            if ([rep[@"gw"][@"result"] intValue]==0) {
                [self getinfoViews:rep[@"gw"][@"gwgs"]];
            }
        }];
    }
}
#pragma mark----------------初始化界面-----------------------
-(void)getinfoViews:(NSDictionary *)gwxxDic{
    
    fjary=[[NSMutableArray alloc]init];
    if ([gwxxDic[@"fj"] isKindOfClass:[NSDictionary class]]) {
        [fjary addObject:gwxxDic[@"fj"]];
    }else if ([gwxxDic[@"fj"] isKindOfClass:[NSArray class]])
    {
        [fjary addObjectsFromArray:gwxxDic[@"fj"]];
    }
    UIView *tabView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    tabView.backgroundColor = UIColorFromRGB(0xE7E7E7);
    gwxqBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    gwxqBtn.frame=CGRectMake(0, 0, tabView.width/2.0, 40);
    gwxqBtn.titleLabel.font=Font(16);
    gwxqBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [gwxqBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gwxqBtn bk_addEventHandler:^(id sender) {
         [self swipScr:gwxqBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    if ([type isEqualToString:@"010"]) {
        [gwxqBtn setTitle:@"签报件信息" forState:UIControlStateNormal];
    }else if ([type isEqualToString:@"011"])
    {
         [gwxqBtn setTitle:@"便函信息" forState:UIControlStateNormal];
    }
    else if([type isEqualToString:@"012"])
    {
        [gwxqBtn setTitle:@"信访信息" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"013"])
    {
        [gwxqBtn setTitle:@"电话处理单信息" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"014"])
    {
        [gwxqBtn setTitle:@"收文信息" forState:UIControlStateNormal];
    }
    else if ([type isEqualToString:@"016"])
    {
        [gwxqBtn setTitle:@"发文信息" forState:UIControlStateNormal];
    }
    else if([type isEqualToString:@"015"]||[type isEqualToString:@"017"])
    {
        [gwxqBtn setTitle:[gwlx isEqualToString:@"1"]?@"收文信息":@"发文信息" forState:UIControlStateNormal];
    }
    [tabView addSubview:gwxqBtn];
    //cllcBtn
    cllcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cllcBtn.frame = CGRectMake(gwxqBtn.right,gwxqBtn.top,gwxqBtn.width,gwxqBtn.height);
    cllcBtn.titleLabel.font=Font(16);
    cllcBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [cllcBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cllcBtn setTitle:@"办理过程" forState:UIControlStateNormal];
    [cllcBtn bk_addEventHandler:^(id sender) {
        [self swipScr:cllcBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:cllcBtn];
    
    
    slidLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,38,gwxqBtn.width-20,2)];
    slidLabel.backgroundColor = SingObj.mainColor;
    [tabView addSubview:slidLabel];
    slidLabel.centerX=gwxqBtn.centerX;
    [self.view addSubview:tabView];
    
    tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,tabView.bottom,kScreenWidth,kScreenHeight-tabView.bottom)];
    tableScrollView.pagingEnabled = YES;
    tableScrollView.clipsToBounds = NO;
    tableScrollView.backgroundColor = [UIColor whiteColor];
    tableScrollView.contentSize = CGSizeMake(tableScrollView.frame.size.width * 2, tableScrollView.frame.size.height);
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.scrollsToTop = NO;
    tableScrollView.delegate = self;
    [tableScrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:tableScrollView];
   //公文信息
    UIScrollView *gwxxsrc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tableScrollView.height)];
    gwxxsrc.showsVerticalScrollIndicator = YES;
    [gwxxsrc setBackgroundColor:[UIColor whiteColor]];
    gwxxsrc.showsVerticalScrollIndicator = NO;
    [tableScrollView addSubview:gwxxsrc];
    
    //标题
    UILabel *titleb=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, gwxxsrc.width-30, 20)];
    titleb.font=Font(17);
    titleb.numberOfLines=0;
    titleb.textAlignment=NSTextAlignmentCenter;
    if ([type isEqualToString:@"015"]) {
        titleb.text=docmentModel.chrgwbt;
    }
    else{
        titleb.text=gwxxDic[@"strgwbt"];
    }
    if([type isEqualToString:@"017"])
    {
        type=[gwlx isEqualToString:@"0"]?@"014":@"016";
    }
    CGSize titlsize=[titleb.text boundingRectWithSize:CGSizeMake(titleb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titleb.font} context:nil].size;
    titleb.height=titlsize.height>22?titlsize.height:22;
    [gwxxsrc addSubview:titleb];
    //公文字号
    UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(15, titleb.bottom+5, titleb.width, 18)];
    gwzhlb.font=Font(13);
    if ([type isEqualToString:@"012"]) {
        if ([gwxxDic[@"swbz"] isKindOfClass:[NSDictionary class]]) {
            gwzhlb.text=[NSString stringWithFormat:@"[%@]%@号",gwxxDic[@"swbz"][@"intzbnh"],gwxxDic[@"swbz"][@"intzbqh"]];
            
        }
    }
    else if([type isEqualToString:@"011"])
    {
        if ([gwxxDic[@"fwbz"] isKindOfClass:[NSDictionary class]]) {
            gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",gwxxDic[@"fwbz"][@"strgwz"],gwxxDic[@"fwbz"][@"intgwnh"],gwxxDic[@"fwbz"][@"intgwqh"]];
            
        }
    }else if ([type isEqualToString:@"014"]||[type isEqualToString:@"016"]){
        if ([gwlx isEqualToString:@"1"]) {
            if ([gwxxDic[@"swbz"] isKindOfClass:[NSDictionary class]]) {
                gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",gwxxDic[@"swbz"][@"strgwz"],gwxxDic[@"swbz"][@"intzbnh"],gwxxDic[@"swbz"][@"intzbqh"]];
            }
        }else if ([gwlx isEqualToString:@"0"]){
            if ([gwxxDic[@"fwbz"] isKindOfClass:[NSDictionary class]]) {
                gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",gwxxDic[@"fwbz"][@"strgwz"],gwxxDic[@"fwbz"][@"intgwnh"],gwxxDic[@"fwbz"][@"intgwqh"]];
            }
        }
    }else if ([type isEqualToString:@"015"])
    {
        gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",docmentModel.chrgwz,@(docmentModel.intgwnh),@(docmentModel.intgwqh)];
    }
    else
    {
        gwzhlb.text=[NSString stringWithFormat:@"[%@]号",self.intgwlsh];
    }
    gwzhlb.textAlignment=NSTextAlignmentCenter;
    [gwxxsrc addSubview:gwzhlb];
    float hightH=gwzhlb.bottom+15;
    //缓急程度
    if ([type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"014"]||[type isEqualToString:@"016"]) {
        UILabel *hjcdlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        hjcdlb.font=Font(15);
        hjcdlb.textColor=[UIColor grayColor];
        hjcdlb.text=@"缓急程度：";
        [gwxxsrc addSubview:hjcdlb];
        UILabel *hjcdvlb=[[UILabel alloc]initWithFrame:CGRectMake(hjcdlb.right+3, hjcdlb.top, gwzhlb.width-(hjcdlb.right+8), hjcdlb.height)];
        hjcdvlb.font=Font(15);
        hjcdvlb.text=gwxxDic[@"strbzhjcd"];
        [gwxxsrc addSubview:hjcdvlb];
        hightH=hjcdvlb.bottom+8;
    }
    //成文日期
    if (([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"016"])&&[gwxxDic[@"dtmbjsj"] length]>0) {
        UILabel *cwrqlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        cwrqlb.font=Font(15);
        cwrqlb.textColor=[UIColor grayColor];
        cwrqlb.text=@"成文日期：";
        [gwxxsrc addSubview:cwrqlb];
        UILabel *cwrqvlb=[[UILabel alloc]initWithFrame:CGRectMake(cwrqlb.right+3, cwrqlb.top, gwzhlb.width-(cwrqlb.right+8), cwrqlb.height)];
        cwrqvlb.font=Font(15);
        cwrqvlb.text=[NSString stringWithFormat:@"%@",[gwxxDic[@"dtmbjsj"] length]>16?[gwxxDic[@"dtmbjsj"] substringToIndex:16]:@""];
        [gwxxsrc addSubview:cwrqvlb];
        hightH=cwrqvlb.bottom+8;
    }
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"016"]) {
        //拟稿人
        UILabel *ngrlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        ngrlb.font=Font(15);
        ngrlb.textColor=[UIColor grayColor];
        ngrlb.text=@"拟 稿 人：";
        [gwxxsrc addSubview:ngrlb];
        UILabel *ngrvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngrlb.right+3, ngrlb.top, gwzhlb.width-(ngrlb.right+8), ngrlb.height)];
        ngrvlb.font=Font(15);
        ngrvlb.text=gwxxDic[@"strcbrmc"];
        [gwxxsrc addSubview:ngrvlb];
        hightH=ngrvlb.bottom+8;
    }
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"016"]) {
        //拟稿部门
        UILabel *ngbmlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        ngbmlb.font=Font(15);
        ngbmlb.textColor=[UIColor grayColor];
        ngbmlb.text=@"拟稿部门：";
        [gwxxsrc addSubview:ngbmlb];
        UILabel *ngbmvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngbmlb.right+3, ngbmlb.top, gwzhlb.width-(ngbmlb.right+8), ngbmlb.height)];
        ngbmvlb.font=Font(15);
        ngbmvlb.text=gwxxDic[@"strcbcsmc"];
        [gwxxsrc addSubview:ngbmvlb];
        hightH=ngbmvlb.bottom+8;
    }
    if ([type isEqualToString:@"010"]) {
        //会签处室
        UILabel *hqcslb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        hqcslb.font=Font(15);
        hqcslb.textColor=[UIColor grayColor];
        hqcslb.text=@"会签处室：";
        [gwxxsrc addSubview:hqcslb];
        UILabel *hqcsvlb=[[UILabel alloc]initWithFrame:CGRectMake(hqcslb.right+3, hqcslb.top, gwzhlb.width-(hqcslb.right+8), hqcslb.height)];
        hqcsvlb.font=Font(15);
        hqcsvlb.text=gwxxDic[@"strhqcs"];
        [gwxxsrc addSubview:hqcsvlb];
        hightH=hqcsvlb.bottom+8;
    }
    if (([type isEqualToString:@"011"]||[type isEqualToString:@"016"])&&gwxxDic[@"strzsdw"]!=nil) {
        //主送单位
        UILabel *zsdwlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        zsdwlb.font=Font(15);
        zsdwlb.textColor=[UIColor grayColor];
        zsdwlb.text=@"主送单位：";
        [gwxxsrc addSubview:zsdwlb];
        UILabel *zsdwvlb=[[UILabel alloc]initWithFrame:CGRectMake(zsdwlb.right+3, zsdwlb.top, gwzhlb.width-(zsdwlb.right+8), zsdwlb.height)];
        zsdwvlb.font=Font(15);
        zsdwvlb.text=[NSString stringWithFormat:@"%@",gwxxDic[@"strzsdw"]];
        zsdwvlb.numberOfLines=0;
        CGSize szdwsize=[zsdwvlb.text boundingRectWithSize:CGSizeMake(zsdwvlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:zsdwvlb.font} context:nil].size;
        zsdwvlb.height=szdwsize.height>18?szdwsize.height:18;
        [gwxxsrc addSubview:zsdwvlb];
        hightH=zsdwvlb.bottom+8;
    }
    if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"016"]) {
        //拟稿日期
        UILabel *ngrqlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        ngrqlb.font=Font(15);
        ngrqlb.textColor=[UIColor grayColor];
        ngrqlb.text=@"拟稿日期：";
        [gwxxsrc addSubview:ngrqlb];
        UILabel *ngrqvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngrqlb.right+3, ngrqlb.top, gwzhlb.width-(ngrqlb.right+8), ngrqlb.height)];
        ngrqvlb.font=Font(15);
        ngrqvlb.text=ngrqstr;
        [gwxxsrc addSubview:ngrqvlb];
        hightH=ngrqvlb.bottom+8;
    }
    //来文单位
    if ([type isEqualToString:@"014"]) {
        UILabel *lwdwlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        lwdwlb.font=Font(15);
        lwdwlb.textColor=[UIColor grayColor];
        lwdwlb.text=@"来文单位：";
        [gwxxsrc addSubview:lwdwlb];
        UILabel *lwdwvlb=[[UILabel alloc]initWithFrame:CGRectMake(lwdwlb.right+3, lwdwlb.top, gwzhlb.width-(lwdwlb.right+8), lwdwlb.height)];
        lwdwvlb.font=Font(15);
        if ([gwxxDic[@"strlwdwmc"] isKindOfClass:[NSDictionary class]]) {
            lwdwvlb.text=gwxxDic[@"strlwdwmc"][@"content"];
        }
        else if([gwxxDic[@"strlwdwmc"] isKindOfClass:[NSString class]])
        {
            lwdwvlb.text=gwxxDic[@"strlwdwmc"];
        }
        else if ([gwxxDic[@"strlwdwmc"] isKindOfClass:[NSNumber class]]) {
            lwdwvlb.text=[NSString stringWithFormat:@"%@",gwxxDic[@"strlwdwmc"]];
        }
        CGSize lwdwsize=[lwdwvlb.text boundingRectWithSize:CGSizeMake(lwdwvlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lwdwvlb.font} context:nil].size;
        lwdwvlb.height=lwdwsize.height>18?lwdwsize.height:18;
        [gwxxsrc addSubview:lwdwvlb];
        hightH=lwdwvlb.bottom+8;
    }
    //来文日期
    if ([type isEqualToString:@"014"]||[type isEqualToString:@"015"]) {
        UILabel *lwrqlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
        lwrqlb.font=Font(15);
        lwrqlb.textColor=[UIColor grayColor];
        lwrqlb.text=@"来文日期：";
        [gwxxsrc addSubview:lwrqlb];
        UILabel *lwrqvlb=[[UILabel alloc]initWithFrame:CGRectMake(lwrqlb.right+3, lwrqlb.top, gwzhlb.width-(lwrqlb.right+8), lwrqlb.height)];
        lwrqvlb.font=Font(15);
        if (![type isEqualToString:@"015"]&&![type isEqualToString:@"014"]) {
            lwrqvlb.text=gwxxDic[@"dtmrq"];
        }else
        {
             lwrqvlb.text=ngrqstr;
        }
        [gwxxsrc addSubview:lwrqvlb];
        hightH=lwrqvlb.bottom+8;
    }
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, hightH+10, kScreenWidth, 0.5)];
    [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
    [gwxxsrc addSubview:onelb];
    [gwxxsrc setContentSize:CGSizeMake(gwxxsrc.width, onelb.bottom+10)];
    //附件
    if (fjary.count!=0) {
        DealFjVC *dealfjvc=[[DealFjVC alloc]initWithFrame:CGRectMake(0, onelb.bottom, kScreenWidth, 30+fjary.count*44) fjAry:fjary type1:[type isEqualToString:@"015"]?4:3 controller:self];
        [gwxxsrc addSubview:dealfjvc];
        [gwxxsrc setContentSize:CGSizeMake(gwxxsrc.width, dealfjvc.bottom+10)];
    }
    //流转步骤
    lbzbary =[[NSMutableArray alloc]init];
    if ([gwxxDic[@"lzbz"] isKindOfClass:[NSDictionary class]]) {
        [lbzbary addObject:gwxxDic[@"lzbz"]];
    }else if([gwxxDic[@"lzbz"] isKindOfClass:[NSArray class]])
    {
        [lbzbary addObjectsFromArray:gwxxDic[@"lzbz"]];
    }
    lzbztb =[[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableScrollView.height) style:UITableViewStylePlain];
    [lzbztb setBackgroundColor:[UIColor whiteColor]];
    lzbztb.separatorStyle=UITableViewCellSeparatorStyleNone;
    lzbztb.delegate=self;
    lzbztb.dataSource=self;
    [tableScrollView addSubview:lzbztb];
}
#pragma mark---------------滑动-------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tableScrollView.frame.size.width;
    int page = floor((self.tableScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page==0) {
        [self swipScr:gwxqBtn];
    }else if (page==1)
    {
        [self swipScr:cllcBtn];
    }
}

-(void)swipScr:(UIButton*)sender
{
    int pagenum=0;
    if (sender==cllcBtn) {
        pagenum=1;
    }else if (gwxqBtn==sender)
    {
        pagenum=0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        slidLabel.centerX=sender.centerX;
        [tableScrollView setContentOffset:CGPointMake(kScreenWidth*pagenum, 0)];
    }];
}
#pragma mark-------------------办理过程----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lbzbary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoticeCell";
    LbzbCell *cell = (LbzbCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[LbzbCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    cell.lbzbdic=lbzbary[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)backPage
{
    [tableScrollView setContentOffset:CGPointMake(0, 0)];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
