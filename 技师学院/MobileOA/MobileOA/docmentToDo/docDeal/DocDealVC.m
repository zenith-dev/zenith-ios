//
//  DocDealVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/8.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "DocDealVC.h"
#import "LbzbCell.h"
#import "DealFjVC.h"
#import "UITextViewPlaceHolder.h"
#import "DocDealModel.h"
#import "PopView.h"
#import "ZtOAFlowPersonVC.h"
#import "AddUserInfo.h"
#import "ZtOAZdcyVC.h"
#import "ZtOAPopView.h"
#import "SKGRaphicVC.h"
#import "MultitaskingVC.h"
#import "NSData+Base64.h"
#import "MultRwModel.h"
#import "GTMBase64.h"
@interface DocDealVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
//界面控件创建======begin=======
@property (nonatomic,strong)UIButton *gwxqBtn;
@property (nonatomic,strong)UIButton *cllcBtn;
@property (nonatomic,strong)UILabel *slidLabel;
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UITableView *lzbztb;//流转步骤
@property (nonatomic,strong)DealFjVC *dealfjvc;//文件

@property (nonatomic,strong)NSMutableArray *lbzbary;//流转步骤列表
@property (nonatomic,strong)UITableView *gwlztb;//公文流转列表
@property (nonatomic,strong)UITextViewPlaceHolder *clyjtv;//处理意见
//===========end===================
@property (nonatomic,strong)NSDictionary *gwDic;//公文信息
@property (nonatomic,strong)NSMutableArray *docAry;//公文流转列表
@property (nonatomic,strong)NSMutableArray *dbxxArray;//督办信息
@property (nonatomic,strong)NSMutableArray *fjAry;//附件列表
@property (nonatomic,strong)NSMutableArray *ldpsyjArray;//领导批示
@property (nonatomic,strong)NSMutableArray *opinionAry;//处理意见

@property (nonatomic,strong)NSMutableArray *nextStepListArray;//下步任务列表
@property (nonatomic,strong)DocDealModel *docDealModel;
@property(nonatomic,strong)NSMutableDictionary *storeDicts;
@property (nonatomic,assign)BOOL issxqp;//是否可以手写签批
@property (nonatomic,assign) BOOL isryxz;
@property (nonatomic,strong)UIButton *conerightBtn;
@property (nonatomic,strong)NSString *type;
//=============================多任务======
@property (nonatomic,strong)NSMutableArray *multRwselectRylst;
@property (nonatomic,assign)BOOL ctrone;

@end

@implementation DocDealVC
@synthesize intbzjllsh,doctodoModel,docAry,fjAry,gwxqBtn,cllcBtn,slidLabel,tableScrollView,lzbztb,lbzbary,gwlztb,gwDic,dbxxArray,ldpsyjArray,clyjtv,nextStepListArray,docDealModel,storeDicts,opinionAry,issxqp,type,conerightBtn,multRwselectRylst,dealfjvc,ctrone;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpFile:) name:@"UpFile" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpFile" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    multRwselectRylst=[[NSMutableArray alloc]init];
    conerightBtn=[self rightButton:nil imagen:@"btn_fav_no_n" imageh:nil sel:@selector(collectDocAction:)];
    [conerightBtn setImage:PNGIMAGE(@"btn_fav_yes_n") forState:UIControlStateSelected];
    NSMutableArray *gwscAry=[[NSUserDefaults standardUserDefaults]objectForKey:@"gwsc"];
    for (NSDictionary *docd in gwscAry) {
        if ([[docd mj_JSONString] isEqualToString:[doctodoModel mj_JSONString]]) {
            conerightBtn.selected=YES;
            break;
        }
    }
    issxqp=YES;
    docDealModel=[[DocDealModel alloc]init];
    docDealModel.xbryAry=[[NSMutableArray alloc]init];
    [self getGwlzclxx];
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
        [newsearchRecordArray addObject:[doctodoModel mj_keyValues]];
        [self showMessage:@"收藏成功！"];
    }
    else
    {
        [newsearchRecordArray removeObject:[doctodoModel mj_keyValues]];
        [self showMessage:@"取消收藏"];
    }
    NSArray *tempary=[[NSArray alloc]initWithArray:newsearchRecordArray];
    [[NSUserDefaults standardUserDefaults]setObject:tempary forKey:@"gwsc"];
}
#pragma mark-----------------获取公文基本信息及流转处理-------
-(void)getGwlzclxx{
    [self networkall:@"document" requestMethod:@"getGwlzclxx" requestHasParams:@"true" parameter:@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"intcsdwlsh":@(SingObj.unitInfo.intdwlsh_child),@"intbzjllsh":doctodoModel.intbzjllsh} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if (rep[@"gw"][@"result"]!=nil&&[rep[@"gw"][@"result"]intValue]==0) {
                if ([rep[@"gw"][@"gwgs"] isKindOfClass:[NSDictionary class]]) {
                    [self getinfoViews:rep[@"gw"][@"gwgs"]];
                }
                else
                {
                    [self showMessage:@"获取数据错误"];
                }
            }
        }
    }];
}
#pragma mark----------------初始化界面-------------------
-(void)getinfoViews:(NSDictionary *)gwxxDic
{
    gwDic =[[NSDictionary alloc]initWithDictionary:gwxxDic];
    ldpsyjArray=[[NSMutableArray alloc]init];
    if ([gwxxDic[@"ldpsyj"] isKindOfClass:[NSDictionary class]]) {
        [ldpsyjArray addObject:gwxxDic[@"ldpsyj"]];
    }else if ([gwxxDic[@"ldpsyj"] isKindOfClass:[NSArray class]])
    {
        [ldpsyjArray addObjectsFromArray:gwxxDic[@"ldpsyj"]];
    }
    dbxxArray=[[NSMutableArray alloc]init];
    if ([gwxxDic[@"dbxx"] isKindOfClass:[NSDictionary class]]) {
        [dbxxArray addObject:gwxxDic[@"dbxx"]];
    }else if ([gwxxDic[@"dbxx"] isKindOfClass:[NSArray class]])
    {
        [dbxxArray addObjectsFromArray:gwxxDic[@"dbxx"]];
    }
    fjAry=[[NSMutableArray alloc]init];
    if ([gwxxDic[@"fj"] isKindOfClass:[NSDictionary class]]) {
        [fjAry addObject:gwxxDic[@"fj"]];
    }else if ([gwxxDic[@"fj"] isKindOfClass:[NSArray class]])
    {
        [fjAry addObjectsFromArray:gwxxDic[@"fj"]];
    }
    if ([gwxxDic[@"clyj"] isKindOfClass:[NSDictionary class]]) {
        docDealModel.opinionSelectedDic =gwxxDic[@"clyj"];
    }else if([gwxxDic[@"clyj"] isKindOfClass:[NSArray class]])
    {
        docDealModel.opinionSelectedDic =gwxxDic[@"clyj"][0];
    }
    else{
        docDealModel.opinionSelectedDic=nil;
    }
    nextStepListArray=[[NSMutableArray alloc]init];
    if ([gwxxDic[@"lccz"] isKindOfClass:[NSDictionary class]]) {
        [nextStepListArray addObject:gwxxDic[@"lccz"]];
    }else if ([gwxxDic[@"lccz"] isKindOfClass:[NSArray class]])
    {
        [nextStepListArray addObjectsFromArray:gwxxDic[@"lccz"]];
    }
    for (NSDictionary *dic in nextStepListArray) {
        if ([dic[@"stryjmc"] isEqualToString:@"改稿"]) {
            ctrone=YES;
            [nextStepListArray removeObject:dic];
            break;
        }
    }
    for (NSDictionary *dic in nextStepListArray) {
        if ([dic[@"strqtkzbz"] intValue]==4&&(35==[dic[@"intact"] intValue]||61==[dic[@"intact"] intValue])) {
            [nextStepListArray removeAllObjects];
            [nextStepListArray addObject:dic];
            break;
        }
    }
    docDealModel.xbrwAry=nextStepListArray;
    docAry =[[NSMutableArray alloc]init];
    [docAry addObject:@"基础信息"];
    [docAry addObject:@"督办信息"];
    [docAry addObject:@"附件信息"];
    [docAry addObject:@"领导批示"];
    [docAry addObject:@"处理意见"];
    [docAry addObject:@"下步任务"];
    [docAry addObject:@"下步处理人"];
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
    [gwxqBtn setTitle:[NSString stringWithFormat:@"%@信息",doctodoModel.chrlzlx] forState:UIControlStateNormal];
    if ([doctodoModel.chrlzlx isEqualToString:@"签报件"]) {
        type=@"010";
    }else if ([doctodoModel.chrlzlx isEqualToString:@"便函"])
    {
        type=@"011";
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"信访"])
    {
        type=@"012";
    }
    else if ([doctodoModel.chrlzlx isEqualToString:@"电话处理单"])
    {
        type=@"013";
    }
    else if([doctodoModel.chrlzlx isEqualToString:@"收文"])
    {
         type=@"014";
    }
    else if ([doctodoModel.chrlzlx isEqualToString:@"发文"])
    {
        type=@"015";
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
    //公文信息列表
    gwlztb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tableScrollView.height) style:UITableViewStylePlain];
    [gwlztb setBackgroundColor:[UIColor whiteColor]];
    gwlztb.separatorStyle=UITableViewCellSeparatorStyleNone;
    gwlztb.delegate=self;
    gwlztb.dataSource=self;
    [tableScrollView addSubview:gwlztb];
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    UIButton *okbtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 45)];
    [okbtn bootstrapNoborderStyle:UIColorFromRGB(0x1296db) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    ViewRadius(okbtn, 4);
    [okbtn setTitle:@"提交" forState:UIControlStateNormal];
    [okbtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    okbtn.bottom=footView.height-10;
    [footView addSubview:okbtn];
    [gwlztb setTableFooterView:footView];
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
    if (tableView==lzbztb) {
        return lbzbary.count;
    }else
    {
        return docAry.count;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==lzbztb) {
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
    }else
    {
        static NSString *cellId = @"baseInfo";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] bk_each:^(UIView *sender) {
            if ([sender isKindOfClass:[DealFjVC class]]) {
                [[NSNotificationCenter defaultCenter] removeObserver:sender name:@"UpFile" object:nil];
            }
            NSLog(@"s=====s");
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([docAry[indexPath.row] isEqualToString:@"基础信息"]) {
            //标题
            UILabel *titleb=[[UILabel alloc]initWithFrame:CGRectMake(15, 20, kScreenWidth-30, 20)];
            titleb.font=Font(17);
            titleb.numberOfLines=0;
            titleb.textAlignment=NSTextAlignmentCenter;
            titleb.text=doctodoModel.chrgwbt;
            CGSize titlsize=[titleb.text boundingRectWithSize:CGSizeMake(titleb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:titleb.font} context:nil].size;
            titleb.height=titlsize.height>22?titlsize.height:22;
            [cell.contentView addSubview:titleb];
            //公文字号
            UILabel *gwzhlb=[[UILabel alloc]initWithFrame:CGRectMake(15, titleb.bottom+5, titleb.width, 18)];
            gwzhlb.font=Font(13);
            gwzhlb.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:gwzhlb];
            if ([doctodoModel.chrlzlx isEqualToString:@"收文"]) {
                if ([gwDic[@"swbz"] isKindOfClass:[NSDictionary class]]) {
                    gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",gwDic[@"swbz"][@"strgwz"],gwDic[@"swbz"][@"intzbnh"],gwDic[@"swbz"][@"intzbqh"]];
                }
            }else{
                if ([gwDic[@"fwbz"] isKindOfClass:[NSDictionary class]]) {
                    gwzhlb.text=[NSString stringWithFormat:@"%@[%@]%@号",gwDic[@"fwbz"][@"strgwz"],gwDic[@"fwbz"][@"intgwnh"],gwDic[@"fwbz"][@"intgwqh"]];
                }
            }
            float hightH=gwzhlb.bottom+15;
            //办理时限
            if ([doctodoModel.chrlzlx isEqualToString:@"收文"]) {
                UILabel *blxxlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                blxxlb.font=Font(15);
                blxxlb.textColor=[UIColor grayColor];
                blxxlb.text=@"办理时限：";
                [cell.contentView addSubview:blxxlb];
                UILabel *blxxvlb=[[UILabel alloc]initWithFrame:CGRectMake(blxxlb.right+3, blxxlb.top, gwzhlb.width-(blxxlb.right+8), blxxlb.height)];
                blxxvlb.font=Font(15);
                blxxvlb.textColor=UIColorFromRGB(0x008af4);
                blxxvlb.text=[NSString stringWithFormat:@"%@天",[gwDic objectForKey:@"sgcsts"]?:@""];
                [cell.contentView addSubview:blxxvlb];
                hightH=blxxvlb.bottom+8;
            }
            //缓急程度
            if ([type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"014"]||[type isEqualToString:@"015"]) {
                UILabel *hjcdlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                hjcdlb.font=Font(15);
                hjcdlb.textColor=[UIColor grayColor];
                hjcdlb.text=@"缓急程度：";
                [cell.contentView addSubview:hjcdlb];
                UILabel *hjcdvlb=[[UILabel alloc]initWithFrame:CGRectMake(hjcdlb.right+3, hjcdlb.top, gwzhlb.width-(hjcdlb.right+8), hjcdlb.height)];
                hjcdvlb.font=Font(15);
                hjcdvlb.text=gwDic[@"strbzhjcd"];
                [cell.contentView addSubview:hjcdvlb];
                hightH=hjcdvlb.bottom+8;
            }
            //密级
            if (doctodoModel.chrmj.length>0) {
                UILabel *mjlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                mjlb.font=Font(15);
                mjlb.textColor=[UIColor grayColor];
                mjlb.text=@"密    级：";
                [cell.contentView addSubview:mjlb];
                UILabel *mjvlb=[[UILabel alloc]initWithFrame:CGRectMake(mjlb.right+3, mjlb.top, gwzhlb.width-(mjlb.right+8), mjlb.height)];
                mjvlb.font=Font(15);
                mjvlb.text=doctodoModel.chrmj;
                [cell.contentView addSubview:mjvlb];
                hightH=mjvlb.bottom+8;
            }
            //拟稿人
            if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"015"]) {
                UILabel *ngrlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                ngrlb.font=Font(15);
                ngrlb.textColor=[UIColor grayColor];
                ngrlb.text=@"拟 稿 人：";
                [cell.contentView addSubview:ngrlb];
                UILabel *ngrvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngrlb.right+3, ngrlb.top, gwzhlb.width-(ngrlb.right+8), ngrlb.height)];
                ngrvlb.font=Font(15);
                ngrvlb.text=gwDic[@"strcbrmc"];
                [cell.contentView addSubview:ngrvlb];
                hightH=ngrvlb.bottom+8;
            }
            //拟稿部门
            if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"015"]) {
                
                UILabel *ngbmlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                ngbmlb.font=Font(15);
                ngbmlb.textColor=[UIColor grayColor];
                ngbmlb.text=@"拟稿部门：";
                [cell.contentView addSubview:ngbmlb];
                UILabel *ngbmvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngbmlb.right+3, ngbmlb.top, gwzhlb.width-(ngbmlb.right+8), ngbmlb.height)];
                ngbmvlb.font=Font(15);
                ngbmvlb.text=gwDic[@"strcbcsmc"];
                [cell.contentView addSubview:ngbmvlb];
                hightH=ngbmvlb.bottom+8;
            }
            if ([type isEqualToString:@"011"]) {
                //主送单位
                UILabel *zsdwlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                zsdwlb.font=Font(15);
                zsdwlb.textColor=[UIColor grayColor];
                zsdwlb.text=@"主送单位：";
                [cell.contentView addSubview:zsdwlb];
                UILabel *zsdwvlb=[[UILabel alloc]initWithFrame:CGRectMake(zsdwlb.right+3, zsdwlb.top, gwzhlb.width-(zsdwlb.right+8), zsdwlb.height)];
                zsdwvlb.font=Font(15);
                zsdwvlb.text=[NSString stringWithFormat:@"%@",gwDic[@"strzsdw"]?:@""];
                [cell.contentView addSubview:zsdwvlb];
                hightH=zsdwvlb.bottom+8;
            }
            //拟稿日期
            if ([type isEqualToString:@"010"]||[type isEqualToString:@"011"]||[type isEqualToString:@"012"]||[type isEqualToString:@"015"]) {
                UILabel *ngrqlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                ngrqlb.font=Font(15);
                ngrqlb.textColor=[UIColor grayColor];
                ngrqlb.text=@"拟稿日期：";
                [cell.contentView addSubview:ngrqlb];
                UILabel *ngrqvlb=[[UILabel alloc]initWithFrame:CGRectMake(ngrqlb.right+3, ngrqlb.top, gwzhlb.width-(ngrqlb.right+8), ngrqlb.height)];
                ngrqvlb.font=Font(15);
                ngrqvlb.text=doctodoModel.dtmfssj?:@"";
                [cell.contentView addSubview:ngrqvlb];
                hightH=ngrqvlb.bottom+8;
            }
            //来文单位
            if ([type isEqualToString:@"014"]) {
                UILabel *lwdwlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                lwdwlb.font=Font(15);
                lwdwlb.textColor=[UIColor grayColor];
                lwdwlb.text=@"来文单位：";
                [cell.contentView addSubview:lwdwlb];
                UILabel *lwdwvlb=[[UILabel alloc]initWithFrame:CGRectMake(lwdwlb.right+3, lwdwlb.top, gwzhlb.width-(lwdwlb.right+8), lwdwlb.height)];
                lwdwvlb.font=Font(15);
                if ([gwDic[@"strlwdwmc"] isKindOfClass:[NSDictionary class]]) {
                    lwdwvlb.text=gwDic[@"strlwdwmc"][@"content"];
                }
                else if ([gwDic[@"strlwdwmc"] isKindOfClass:[NSString class]]) {
                    lwdwvlb.text=gwDic[@"strlwdwmc"];
                }
                else if ([gwDic[@"strlwdwmc"] isKindOfClass:[NSNumber class]]) {
                    lwdwvlb.text=[NSString stringWithFormat:@"%@",gwDic[@"strlwdwmc"]];
                }
                [cell.contentView addSubview:lwdwvlb];
                hightH=lwdwvlb.bottom+8;
            }
            //来文日期
            if ([type isEqualToString:@"014"]) {
                UILabel *lwrqlb=[[UILabel alloc]initWithFrame:CGRectMake(15, hightH, 80, 18)];
                lwrqlb.font=Font(15);
                lwrqlb.textColor=[UIColor grayColor];
                lwrqlb.text=@"来文日期：";
                [cell.contentView addSubview:lwrqlb];
                UILabel *lwrqvlb=[[UILabel alloc]initWithFrame:CGRectMake(lwrqlb.right+3, lwrqlb.top, gwzhlb.width-(lwrqlb.right+8), lwrqlb.height)];
                lwrqvlb.font=Font(15);
                lwrqvlb.text=doctodoModel.dtmfssj?:@"";
                [cell.contentView addSubview:lwrqvlb];
                hightH=lwrqvlb.bottom+8;
            }
            UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, hightH+10, kScreenWidth, 0.5)];
            [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
            cell.contentView.height=onelb.bottom;
            [cell.contentView addSubview:onelb];
        }else if ([docAry[indexPath.row] isEqualToString:@"督办信息"]){
            if (dbxxArray.count>0) {
                UILabel *dbxx=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth, 21)];
                dbxx.font=Font(15);
                dbxx.text=@"督办信息:";
                [cell.contentView addSubview:dbxx];
                float dbhight=dbxx.bottom;
                for (NSDictionary *dbdic in dbxxArray) {
                    UILabel *xxlb=[[UILabel alloc]initWithFrame:CGRectMake(dbxx.left+10, dbhight, kScreenWidth-(dbxx.left+20), 20)];
                    xxlb.text=dbdic[@"strdbzt"];
                    xxlb.font=Font(13);
                    xxlb.textColor=[UIColor blueColor];
                    CGSize xxsize=[xxlb.text boundingRectWithSize:CGSizeMake(xxlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:Font(13)} context:nil].size;
                    xxlb.height=xxlb.height>xxsize.height?xxlb.height:xxsize.height;
                    [cell addSubview:xxlb];
                    UILabel *timelb=[[UILabel alloc]initWithFrame:CGRectMake(xxlb.left, xxlb.bottom, xxlb.width, 18)];
                    timelb.font=Font(12);
                    timelb.text=[NSString stringWithFormat:@"%@ 办理时限:%@",dbdic[@"strdbryxm"],dbdic[@"dtmdbsj"]];
                    timelb.textColor=[UIColor grayColor];
                    timelb.textAlignment=NSTextAlignmentRight;
                    [cell addSubview:timelb];
                    dbhight=timelb.bottom;
                }
                UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, dbhight+10, kScreenWidth, 0.5)];
                [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
                cell.contentView.height=onelb.bottom;
                [cell.contentView addSubview:onelb];
            }else
            {
                cell.contentView.height=0;
            }
        }
        else if ([docAry[indexPath.row] isEqualToString:@"附件信息"])
        {
            //附件
            if (fjAry.count!=0) {
                dealfjvc=[[DealFjVC alloc]initWithFrame:CGRectMake(0, 5, kScreenWidth, 30+fjAry.count*44) fjAry:fjAry type1:3 controller:self];
                dealfjvc.ctrone=ctrone;
                dealfjvc.callback=^(BOOL issu){
                    if (issu==YES) {
                        [self getGwlzclxx];
                    }
                };
                dealfjvc.intgwlzlsh=[NSString stringWithFormat:@"%@",doctodoModel.intgwlsh];
                [cell.contentView addSubview:dealfjvc];
                UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, dealfjvc.bottom+10, kScreenWidth, 0.5)];
                [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
                cell.contentView.height=onelb.bottom;
                [cell.contentView addSubview:onelb];
            }
        }
        else if ([docAry[indexPath.row] isEqualToString:@"领导批示"]){
            if (ldpsyjArray.count>0) {
                [cell.contentView setBackgroundColor:UIColorFromRGB(0xeaeaea)];
                UILabel *ldpsxx=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth, 21)];
                ldpsxx.font=Font(15);
                ldpsxx.text=@"领导批示:";
                float ldhight=ldpsxx.bottom;
                [cell.contentView addSubview:ldpsxx];
                for (int i=0; i<ldpsyjArray.count; i++) {
                    NSDictionary *ldpsdic=ldpsyjArray[i];
                    UILabel *ldyjlb=[[UILabel alloc]initWithFrame:CGRectMake(ldpsxx.left, ldhight, kScreenWidth-(ldpsxx.left+10), 20)];
                    ldyjlb.numberOfLines=0;
                    ldyjlb.font=Font(14);
                    ldyjlb.text=ldpsdic[@"ldpsyjnr"];
                    CGSize ldyjsize=[ldyjlb.text boundingRectWithSize:CGSizeMake(ldyjlb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:ldyjlb.font} context:nil].size;
                    ldyjlb.height=ldyjsize.height>20?ldyjsize.height:20;
                    [cell.contentView addSubview:ldyjlb];
                    float ldhight1=ldyjlb.bottom;
                    if ([ldpsdic[@"imgtz"] length]>0) {
                        UIImageView *qpimgview =[[UIImageView alloc]initWithFrame:CGRectMake(ldpsxx.left, ldyjlb.bottom+5, ldyjlb.width, 80)];
                        qpimgview.clipsToBounds=YES;
                        qpimgview.contentMode=UIViewContentModeScaleAspectFit;
                        qpimgview.userInteractionEnabled=YES;
                        
                        [cell addSubview:qpimgview];
                        NSData *filecontent = [GTMBase64 decodeString:ldpsdic[@"imgtz"]];
                        UIImage *image = [UIImage imageWithData:filecontent];
                        [qpimgview setImage:image];
                        qpimgview.height=ScaleBI(80);
                        ldhight1=qpimgview.bottom;
                        [qpimgview bk_whenTapped:^{
                            //1.创建图片浏览器
                            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
                            //传递数据给浏览器
                            MJPhoto *photo = [[MJPhoto alloc] init];
                            photo.image = image;
                            photo.srcImageView = qpimgview; //设置来源哪一个UIImageView
                            brower.photos = @[photo];
                            //3.设置默认显示的图片索引
                            brower.currentPhotoIndex = 0;
                            //4.显示浏览器
                            [brower show];
                        }];
                    }
                    UILabel *ldxmlb=[[UILabel alloc]initWithFrame:CGRectMake(ldpsxx.left+10, ldhight1, kScreenWidth-(ldpsxx.left+20), 15)];
                    ldxmlb.textAlignment=NSTextAlignmentRight;
                    ldxmlb.text=[NSString stringWithFormat:@"%@  %@",ldpsdic[@"ldxm"] ,[Tools dateFromStr:[NSString stringWithFormat:@"%@",ldpsdic[@"clsj"]]]];
                    ldxmlb.font=Font(13);
                    ldhight=ldxmlb.bottom;
                    [cell.contentView addSubview:ldxmlb];
                    
                    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(5, ldxmlb.bottom+5, kScreenWidth-5, 0.5)];
                    [onelb setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
                    [cell.contentView addSubview:onelb];
                    ldhight=onelb.bottom;
                }
                cell.contentView.height=ldhight;
                
            }else
            {
                cell.contentView.height=0;
            }
        }
        else if ([docAry[indexPath.row] isEqualToString:@"处理意见"])
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
            label.text =@"处理意见:";
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15.0f];
            [cell.contentView addSubview:label];
            UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, label.bottom, kScreenWidth-40, 50)];
            [bgImg setBackgroundColor:[UIColor clearColor]];
            [bgImg.layer setBorderWidth:1];
            [bgImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
            [bgImg setUserInteractionEnabled:YES];
            [cell.contentView addSubview:bgImg];
            
            clyjtv =[[UITextViewPlaceHolder alloc]initWithFrame:CGRectMake(2, 2, bgImg.width-44, 50-4)];
            clyjtv.placeholder=@"请输入或选择处理意见";
            clyjtv.delegate=self;
            clyjtv.returnKeyType=UIReturnKeyDone;
            clyjtv.font=Font(14);
            [bgImg addSubview:clyjtv];
            clyjtv.text=docDealModel.clyjStr;
            if (issxqp==YES) {
                clyjtv.width=bgImg.width-44-34;
                UIButton *sxqpBtn=[[UIButton alloc]initWithFrame:CGRectMake(clyjtv.right,0, 32, clyjtv.height)];
                [sxqpBtn setImage:PNGIMAGE(@"xie") forState:UIControlStateNormal];
                [sxqpBtn addTarget:self action:@selector(sxqpSEL) forControlEvents:UIControlEventTouchUpInside];
                [bgImg addSubview:sxqpBtn];
            }
            UIButton *selectyjbtn=[[UIButton alloc]initWithFrame:CGRectMake(issxqp==YES?clyjtv.right+34:clyjtv.right, clyjtv.top, 40, clyjtv.height)];
            [selectyjbtn setImage:PNGIMAGE(@"icon_arrow_down") forState:UIControlStateNormal];
            [bgImg addSubview:selectyjbtn];
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0, 0, 1, selectyjbtn.height);
            bottomBorder.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
            [selectyjbtn.layer addSublayer:bottomBorder];
            [selectyjbtn addTarget:self action:@selector(chooseyjSEL) forControlEvents:UIControlEventTouchUpInside];
            CGFloat highF=bgImg.bottom+5;
            if (docDealModel.dwImg!=nil) {
                UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, highF, kScreenWidth, 0.5)];
                [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
                cell.contentView.height=onelb.bottom;
                [cell.contentView addSubview:onelb];
                UILabel *lbs=[[UILabel alloc]initWithFrame:CGRectMake(20, bgImg.bottom+10, 100, 18)];
                lbs.font=Font(15);
                lbs.text=@"手写签批：";
                [cell.contentView addSubview:lbs];
                UIImageView *dwImgview=[[UIImageView alloc]initWithFrame:CGRectMake(0, lbs.bottom+5, docDealModel.dwImg.size.width*(80.0/docDealModel.dwImg.size.height),80)];
                dwImgview.image=docDealModel.dwImg;
                [cell.contentView addSubview:dwImgview];
                highF=dwImgview.bottom+5;
                dwImgview.centerX=kScreenWidth/2.0;
                UIButton *cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(dwImgview.right, dwImgview.top, 16, 16)];
                [cancleBtn setImage:PNGIMAGE(@"取消") forState:UIControlStateNormal];
                [cancleBtn addTarget:self action:@selector(cancelSEL) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:cancleBtn];
            }
            UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, highF, kScreenWidth, 0.5)];
            [onelb setBackgroundColor:RGBCOLOR(220, 220, 220)];
            cell.contentView.height=onelb.bottom;
            [cell.contentView addSubview:onelb];
        }else if ([docAry[indexPath.row] isEqualToString:@"下步任务"])
        {
            if (nextStepListArray.count>0) {
                UILabel *xblabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                xblabel.text =@"下步任务:";
                xblabel.textAlignment = NSTextAlignmentLeft;
                xblabel.textColor = [UIColor blackColor];
                xblabel.font = [UIFont systemFontOfSize:15.0f];
                [cell.contentView addSubview:xblabel];
                
                UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, xblabel.bottom, kScreenWidth-40, 40)];
                [bgImg setBackgroundColor:[UIColor clearColor]];
                [bgImg.layer setBorderWidth:1];
                [bgImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
                [bgImg setUserInteractionEnabled:YES];
                [cell.contentView addSubview:bgImg];
                
                UILabel *bxmclb=[[UILabel alloc]initWithFrame:CGRectMake(4, 0, bgImg.width-8, 40)];
                bxmclb.font=Font(14);
                bxmclb.text=@"===请选择===";
                [bgImg addSubview:bxmclb];
                if (nextStepListArray.count>0) {
                    bxmclb.width=bxmclb.width-40;
                    UIButton *selectNextSetpBtn = [[UIButton alloc] initWithFrame:CGRectMake(bxmclb.right, 1, 40, 38)];
                    [selectNextSetpBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                    [selectNextSetpBtn addTarget:self action:@selector(selectChargeWay) forControlEvents:UIControlEventTouchUpInside];
                    [selectNextSetpBtn setBackgroundColor:[UIColor clearColor]];
                    
                    CALayer *bottomBorder = [CALayer layer];
                    bottomBorder.frame = CGRectMake(0, 0, 1, selectNextSetpBtn.height);
                    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
                    [selectNextSetpBtn.layer addSublayer:bottomBorder];
                    [bgImg addSubview:selectNextSetpBtn];
                    bxmclb.userInteractionEnabled=YES;
                    [bxmclb bk_whenTapped:^{
                        [self selectChargeWay];
                    }];
                    if (docDealModel.xbrwmc.length!=0) {
                        bxmclb.text=docDealModel.xbrwmc;
                    }
                    if (nextStepListArray.count==1&&docDealModel.xbrwryxm.length==0) {
                        [self selectOneSetp];
                    }
                }
                cell.contentView.height=bgImg.bottom+10;
            }
            
            else
            {
                cell.contentView.height=0;
            }
        }
        else if ([docAry[indexPath.row] isEqualToString:@"下步处理人"])
        {
            if ([docDealModel.xbrwmc isEqualToString:@"快速办文"]||[docDealModel.xbrwmc isEqualToString:@"送会签"]||[docDealModel.xbrwmc isEqualToString:@"流程自定义"]||[docDealModel.xbrwmc isEqualToString:@"指定人员任务"]) {
                UILabel *daxbrylb=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, kScreenWidth-40, 30)];
                daxbrylb.font=Font(14);
                daxbrylb.numberOfLines=0;
                NSMutableString *multstr=[[NSMutableString alloc]init];
                for (MultRwModel *multrwModel in multRwselectRylst) {
                    NSString *rwstr=[NSString stringWithFormat:@"%@：%@\n\n\n",multrwModel.rwmc,multrwModel.xbrwryxm];
                    [multstr appendFormat:@"%@",rwstr];
                }
                daxbrylb.text=multstr;
                CGSize daxbrysize=[multstr boundingRectWithSize:CGSizeMake(daxbrylb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:daxbrylb.font} context:nil].size;
                daxbrylb.height=daxbrysize.height>21?daxbrysize.height:21;
                [cell.contentView addSubview:daxbrylb];
                cell.contentView.height=daxbrylb.bottom+10;
            }else
            {
                //选择下步任务之后打开选择人员
                if (docDealModel.isOpenRy==YES&&docDealModel.isDirecReturn==NO) {
                    UILabel *xbclrlb = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                    xbclrlb.text =@"下步处理人:";
                    xbclrlb.textAlignment = NSTextAlignmentLeft;
                    xbclrlb.textColor = [UIColor blackColor];
                    xbclrlb.font = [UIFont systemFontOfSize:15.0f];
                    [cell.contentView addSubview:xbclrlb];
                    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, xbclrlb.bottom, kScreenWidth-40, 40)];
                    [bgImg setBackgroundColor:[UIColor clearColor]];
                    [bgImg.layer setBorderWidth:1];
                    [bgImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
                    [bgImg setUserInteractionEnabled:YES];
                    [cell.contentView addSubview:bgImg];
                    UILabel *bxmclb=[[UILabel alloc]initWithFrame:CGRectMake(4, 0, bgImg.width-8, 40)];
                    bxmclb.font=Font(15);
                    bxmclb.text=@"===请选择===";
                    [bgImg addSubview:bxmclb];
                    NSDictionary *newStepDic=docDealModel.xbrwAry[docDealModel.xbrwnum];
                    int intact =[newStepDic[@"intact"] intValue];
                    if ((docDealModel.xbryAry.count>1||docDealModel.xbryAry.count==0)||(intact==96||intact==127||intact==22||intact==60)||self.isryxz==YES) {
                        bxmclb.width=bxmclb.width-40;
                        UIButton *selectNextSetpBtn = [[UIButton alloc] initWithFrame:CGRectMake(bxmclb.right, 1, 40, 38)];
                        [selectNextSetpBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                        [selectNextSetpBtn addTarget:self action:@selector(selectPerson) forControlEvents:UIControlEventTouchUpInside];
                        [selectNextSetpBtn setBackgroundColor:[UIColor clearColor]];
                        CALayer *bottomBorder = [CALayer layer];
                        bottomBorder.frame = CGRectMake(0, 0, 1, selectNextSetpBtn.height);
                        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
                        [selectNextSetpBtn.layer addSublayer:bottomBorder];
                        [bgImg addSubview:selectNextSetpBtn];
                        bxmclb.userInteractionEnabled=YES;
                        [bxmclb bk_whenTapped:^{
                            [self selectPerson];
                        }];
                        if (docDealModel.xbrwryxm.length!=0) {
                            bxmclb.text=docDealModel.xbrwryxm;
                        }
                    }else if (docDealModel.xbryAry.count==1) {
                        if (docDealModel.xbrwryxm.length!=0) {
                            bxmclb.text=docDealModel.xbrwryxm;
                        }
                    }
                    cell.contentView.height=bgImg.bottom+10;
                }else{
                    cell.contentView.height=0;
                }
                
            }
            
            
        }
        return cell;
    }
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
#pragma mark-----------UITextViewDelegate---------------
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView isKindOfClass:[UITextViewPlaceHolder class]]) {
        docDealModel.clyjStr=textView.text;
    }
}
#pragma mark------------选择处理意见--------------
-(void)chooseyjSEL{
    if (opinionAry) {
        PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择处理意见"];
        popview.sourceary=opinionAry;
        popview.key=@"Str";
        popview.isHide=YES;
        popview.selectRowIndex=0;
        popview.callback=^(int selectrow,NSString *key){
            docDealModel.clyjStr=[NSString stringWithFormat:@"%@%@",docDealModel.clyjStr?:@"",opinionAry[selectrow]];
            [gwlztb reloadData];
        };
        [popview show];
        return;
    }
    opinionAry=[[NSMutableArray alloc]init];
    [self networkall:@"userbindservices" requestMethod:@"selCyy" requestHasParams:@"true" parameter:@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"intdwlsh":@"",@"chrnrbz":@""} progresHudText:@"获取处理意见" completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"root"][@"result"] intValue]==0) {
                if ([rep[@"root"][@"cyynr"] isKindOfClass:[NSDictionary class]]) {
                    [opinionAry addObject:rep[@"root"][@"cyynr"]];
                }
                else{
                    opinionAry=[[NSMutableArray alloc]initWithArray:rep[@"root"][@"cyynr"]];
                }
                if (opinionAry.count==0) {
                    opinionAry=[[NSMutableArray alloc] initWithObjects:@"同意",@"不同意",@"已阅", nil];
                }
            }else
            {
                opinionAry=[[NSMutableArray alloc] initWithObjects:@"同意",@"不同意",@"已阅", nil];
            }
            PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择处理意见"];
            popview.sourceary=opinionAry;
            popview.key=@"Str";
            popview.isHide=YES;
            popview.selectRowIndex=0;
            popview.callback=^(int selectrow,NSString *key){
                docDealModel.clyjStr=[NSString stringWithFormat:@"%@%@",docDealModel.clyjStr?:@"",opinionAry[selectrow]];
                [gwlztb reloadData];
            };
            [popview show];
        }
    }];
}
#pragma mark------------只有一步的时候选择---------------
-(void)selectOneSetp{
    NSLog(@"选择下一步");
    docDealModel.xbrwrynum=0;
    docDealModel.xbrwryxm=[NSMutableString stringWithString:@""];
    docDealModel.xbryAry=[[NSMutableArray alloc]init];
    storeDicts =[[NSMutableDictionary alloc]init];
    docDealModel.xbrwnum=0;
    NSDictionary *newStepDic=docDealModel.xbrwAry[0];
    docDealModel.xbrwmc =newStepDic[@"stryjmc"];
    NSMutableArray *tempxbryAry=[[NSMutableArray alloc]init];
    if (![newStepDic[@"zrobj"] isEqual:[NSNull null]]) {
        if ([newStepDic[@"zrobj"] isKindOfClass:[NSDictionary class]]) {
            [tempxbryAry addObject:newStepDic[@"zrobj"]];
            
        }else if ([newStepDic[@"zrobj"] isKindOfClass:[NSArray class]]){
            tempxbryAry =[[NSMutableArray alloc]initWithArray:newStepDic[@"zrobj"]];
            
        }
        docDealModel.isOpenRy=YES;
    }
    docDealModel.xbryAry=tempxbryAry;
    if (tempxbryAry.count==0) {
        self.isryxz=YES;
    }
    int intact =[newStepDic[@"intact"] intValue];
    if (docDealModel.xbryAry.count==1&&!(intact==96||intact==127||intact==22||intact==60)){
        NSDictionary *notifyDic=docDealModel.xbryAry[0];
        NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"zrrlsh"]],@"1",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"content"]]];
        docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",[notifyDic objectForKey:@"content"],@"content",nil];
        docDealModel.xbrwryxm =notifyDic[@"content"];
    }
    if (([[newStepDic objectForKey:@"intact"] intValue]==35 ||
         [[newStepDic objectForKey:@"intact"] intValue]==128 ||
         [[newStepDic objectForKey:@"zRdxdx"] intValue]==3)) {
        NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",@""],@"1",@""];
        docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",@"",@"content",nil];
        docDealModel.isDirecReturn=YES;
    }
    else
    {
        docDealModel.isDirecReturn=NO;
    }
}
#pragma mark--------------选择下一步--------------
-(void)selectChargeWay{
    NSLog(@"选择下一步");
    docDealModel.xbrwrynum=0;
    docDealModel.xbrwryxm=[NSMutableString stringWithString:@""];
    docDealModel.xbryAry=[[NSMutableArray alloc]init];
    storeDicts =[[NSMutableDictionary alloc]init];
    PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择下步任务"];
    popview.sourceary=docDealModel.xbrwAry;
    popview.key=@"stryjmc";
    popview.selectRowIndex=docDealModel.xbrwnum;
    popview.callback=^(int selectrow,NSString *key){
        docDealModel.xbrwnum=selectrow;
        NSDictionary *newStepDic=docDealModel.xbrwAry[selectrow];
       docDealModel.xbrwmc =newStepDic[@"stryjmc"];
       NSMutableArray *tempxbryAry=[[NSMutableArray alloc]init];
       if (![newStepDic[@"zrobj"] isEqual:[NSNull null]]) {
            if ([newStepDic[@"zrobj"] isKindOfClass:[NSDictionary class]]) {
                [tempxbryAry addObject:newStepDic[@"zrobj"]];
                
            }else if ([newStepDic[@"zrobj"] isKindOfClass:[NSArray class]]){
                tempxbryAry =[[NSMutableArray alloc]initWithArray:newStepDic[@"zrobj"]];
                
            }
           docDealModel.isOpenRy=YES;
        }
        if (tempxbryAry.count==0) {
            self.isryxz=YES;
        }
        else
        {
            self.isryxz=NO;
        }
        int intact =[newStepDic[@"intact"] intValue];
        if (!(intact==96||intact==127||intact==22||intact==60)) {
            docDealModel.xbryAry=tempxbryAry;
            if (docDealModel.xbryAry.count==1){
                NSDictionary *notifyDic=docDealModel.xbryAry[0];
                NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"zrrlsh"]],@"1",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"content"]]];
                docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",[notifyDic objectForKey:@"content"],@"content",nil];
                docDealModel.xbrwryxm =notifyDic[@"content"];
            }
        }
        if (([[newStepDic objectForKey:@"intact"] intValue]==35 ||
             [[newStepDic objectForKey:@"intact"] intValue]==128 ||
             [[newStepDic objectForKey:@"zRdxdx"] intValue]==3)) {
            NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",@""],@"1",@""];
           docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",@"",@"content",nil];
            docDealModel.isDirecReturn=YES;
        }
        else
        {
             docDealModel.isDirecReturn=NO;
        }
        //多任务流程
        if ([docDealModel.xbrwmc isEqualToString:@"快速办文"]||[docDealModel.xbrwmc isEqualToString:@"送会签"]||[docDealModel.xbrwmc isEqualToString:@"流程自定义"]||[docDealModel.xbrwmc isEqualToString:@"指定人员任务"])
        {
            MultitaskingVC *multitask=[[MultitaskingVC alloc]initWithTitle:docDealModel.xbrwmc];
            multitask.intlcczlsh=[NSString stringWithFormat:@"%@",newStepDic[@"intlcczlsh"]];
            multitask.processOpr=newStepDic;
            multitask.responsibleManDic=docDealModel.responsibleManDic;
            multitask.multRwselectRylst=multRwselectRylst;
            multitask.callback=^(NSMutableArray*multrylst,NSDictionary*responsibleMan){
                docDealModel.responsibleManDic=responsibleMan;
                multRwselectRylst=multrylst;
                [gwlztb reloadData];
            };
            [self.navigationController pushViewController:multitask animated:YES];
        }
        [gwlztb reloadData];
    };
    [popview show];
}
#pragma mark---------------选择下步人员----------
-(void)selectPerson{
    NSLog(@"选择下步人员");
    [clyjtv resignFirstResponder];
    NSDictionary *newStepDic=docDealModel.xbrwAry[docDealModel.xbrwnum];
    NSString *zrdxdx=[NSString stringWithFormat:@"%@",[newStepDic objectForKey:@"zRdxdx"]?:@""];//责任人对象是否多选 1是单选 2是多选
    int intact =[newStepDic[@"intact"] intValue];
    if (intact==60) {//分流程功能
        ZtOAFlowPersonVC *flowperson=[[ZtOAFlowPersonVC alloc]init:@"请选择下步处理人" selectAry:docDealModel.xbryAry storeDict:storeDicts];
        flowperson.storeDict=storeDicts;
        flowperson.processOpr=newStepDic;
        [flowperson selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict) {
            docDealModel.xbryAry =selectAry;
            storeDicts=storeDict;
            NSMutableString *zrobj=[[NSMutableString alloc]init];
            NSMutableString *tempcontent=[[NSMutableString alloc]init];
            NSMutableString *tempintnewrylshlst=[[NSMutableString alloc]init];
            NSMutableString *tempintlcdylshlst=[[NSMutableString alloc]init];
            NSMutableString *tempintbzlst=[[NSMutableString alloc]init];
            NSMutableString *tempintbcbhlst=[[NSMutableString alloc]init];
            NSMutableString *tempstrzrrlxLst=[[NSMutableString alloc]init];
            NSMutableString *tempintgzlclshlst=[[NSMutableString alloc]init];
            NSString *xml;
            for (AddUserInfo *oamodel  in selectAry) {
                [tempcontent appendFormat:@"%@,",oamodel.strryxm];
                [tempstrzrrlxLst appendFormat:@"%@,",storeDicts[@"strzrrlxLst"]];
                [tempintlcdylshlst appendFormat:@"0,"];
                [tempintnewrylshlst appendFormat:@"%@,",@(oamodel.intrylsh)];
                
                [tempintbzlst appendFormat:@"%@,",storeDicts[@"intbzlst"]];
                [tempintbcbhlst appendFormat:@"%@,",storeDicts[@"intbcbhlst"]];
                
                [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[newStepDic objectForKey:@"zRdxlx"], oamodel.strryxm]];
                [tempintgzlclshlst appendFormat:@"%@,", storeDicts[@"intgzlclshlst"]];
            }
            NSString *intnewrylshlst=@"";
            NSString *content=@"";
            NSString *intlcdylshlst=@"";
            NSString *intbzlst=@"";
            NSString *intbcbhlst=@"";
            NSString *strzrrlxLst=@"";
            NSString *intgzlclshlst=@"";
            if (selectAry.count>0) {
                strzrrlxLst=[tempstrzrrlxLst substringToIndex:tempstrzrrlxLst.length-1];
                intbcbhlst=[tempintbcbhlst substringToIndex:tempintbcbhlst.length-1];
                intbzlst=[tempintbzlst substringToIndex:tempintbzlst.length-1];
                intlcdylshlst=[tempintlcdylshlst substringToIndex:tempintlcdylshlst.length-1];
                intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                content =[tempcontent substringToIndex:tempcontent.length-1];
                intgzlclshlst =[tempintgzlclshlst substringToIndex:tempintgzlclshlst.length-1];
            }
            docDealModel.xbrwryxm=[NSMutableString stringWithString:content];
            xml= [NSString stringWithFormat:@"%@<intnextgzrylsh>%@</intnextgzrylsh><intnextgzlclsh>%@</intnextgzlclsh><strzrrlxLst>%@</strzrrlxLst><strnextgzrylx>%@</strnextgzrylx><intrylshlst>%@</intrylshlst><intlcdylshlst>%@</intlcdylshlst><strlzlxlst>%@</strlzlxlst><strwcbz>%@</strwcbz><strbwcbzLst></strbwcbzLst><intbzlst>%@</intbzlst><intgzlclshlst>%@</intgzlclshlst><intbcbhlst>%@</intbcbhlst>",zrobj,storeDicts[@"intnextgzrylsh"]?:@"",newStepDic[@"intnextgzlclsh"],strzrrlxLst,storeDicts[@"strnextgzrylx"],intnewrylshlst,intlcdylshlst,intlcdylshlst,storeDicts[@"strwcbz"],intbzlst,intgzlclshlst,intbcbhlst];
            docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
            [gwlztb reloadData];
        }];
        [self.navigationController pushViewController:flowperson animated:YES];
    }
    else if (intact==96||intact==127||intact==22){//指定内部人员
        ZtOAZdcyVC *ztoazdcy=[[ZtOAZdcyVC alloc]init:@"请选择下步处理人" selectAry:docDealModel.xbryAry storeDict:storeDicts];
        ztoazdcy.storeDict=storeDicts;
        ztoazdcy.isdx=zrdxdx;
        ztoazdcy.processOpr=newStepDic;
        ztoazdcy.currentCompanylsh=[NSString stringWithFormat:@"%@",@(SingObj.unitInfo.intdwlsh)];
        [ztoazdcy selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict) {
            docDealModel.xbryAry =selectAry;
            storeDicts=storeDict;
            NSMutableString *tempcontent=[[NSMutableString alloc]init];
            NSMutableString *tempintnewrylshlst=[[NSMutableString alloc]init];
            NSString *xml;
            if (intact==96) {
                NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (AddUserInfo *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strryxm];
                    [tempintnewrylshlst appendFormat:@"%@,",@(oamodel.intrylsh)];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[newStepDic objectForKey:@"zRdxlx"],oamodel.strryxm]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                }
                docDealModel.xbrwryxm=[NSMutableString stringWithString:content];
                xml= [NSString stringWithFormat:@"%@<intrylsh>%@</intrylsh><intcsdwlsh>%@</intcsdwlsh><intdwlsh>%@</intdwlsh><intcxlx>0</intcxlx><intzdrylsh>%@</intzdrylsh><intgwlsh>%@</intgwlsh><intlx>2</intlx><intgwlzlsh>%@</intgwlzlsh><intczrylsh>%@</intczrylsh><intnewrylshlst>%@</intnewrylshlst>",zrobj,@(SingObj.userInfo.intrylsh),@(SingObj.unitInfo.intdwlsh_child),@(SingObj.unitInfo.intdwlsh),@(SingObj.userInfo.intrylsh),[gwDic objectForKey:@"intgwlsh"],[gwDic objectForKey:@"intgwlzlsh"],@(SingObj.userInfo.intrylsh),intnewrylshlst];
                docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [gwlztb reloadData];
            }else if (intact==127)
            {
                
                NSMutableString *tempintbzjllshlst=[[NSMutableString alloc]init];
                NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (AddUserInfo *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strryxm];
                    [tempintnewrylshlst appendFormat:@"%@,",@(oamodel.intrylsh)];
                    [tempintbzjllshlst appendFormat:@"-1,"];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[newStepDic objectForKey:@"zRdxlx"],oamodel.strryxm]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                NSString *intbzjllshlst=@"";
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                    intbzjllshlst=[tempintbzjllshlst substringToIndex:tempintbzjllshlst.length-1];
                    
                }
                xml= [NSString stringWithFormat:@"%@<strzrrxmlst>%@</strzrrxmlst><intbzjllshlst>%@</intbzjllshlst><intzrrlshlst>%@</intzrrlshlst><intnextgzlclsh>%@</intnextgzlclsh><intact>%@</intact><intgzlclsh>%@</intgzlclsh><strczrxm>%@</strczrxm><intgwlzlsh>%@</intgwlzlsh><strlclxbm>%@</strlclxbm><intczrylsh>%@</intczrylsh><islz></islz>",zrobj,content,intbzjllshlst,intnewrylshlst,newStepDic[@"intnextgzlclsh"],newStepDic[@"intact"],newStepDic[@"intgzlclsh"],SingObj.userInfo.username,[gwDic objectForKey:@"intgwlzlsh"],gwDic[@"strlclxbm"]?:@"",@(SingObj.userInfo.intrylsh)];
                 docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [gwlztb reloadData];
            }else if (intact==22){
                
                NSMutableString *tempintbzjllshlst=[[NSMutableString alloc]init];
                NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (AddUserInfo *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strryxm];
                    [tempintnewrylshlst appendFormat:@"%@,",@(oamodel.intrylsh)];
                    [tempintbzjllshlst appendFormat:@"0,"];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[newStepDic objectForKey:@"zRdxlx"],oamodel.strryxm]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                NSString *intbzjllshlst=@"";
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                    intbzjllshlst=[tempintbzjllshlst substringToIndex:tempintbzjllshlst.length-1];
                    
                }
                docDealModel.xbrwryxm=[NSMutableString stringWithString:content];
                xml= [NSString stringWithFormat:@"%@<intcxlxlst>%@</intcxlxlst><intpkvaluelst>%@</intpkvaluelst><intgwlsh>%@</intgwlsh><intfbfw>0</intfbfw><intgwlzlsh>%@</intgwlzlsh>",zrobj,intbzjllshlst,intnewrylshlst,[gwDic objectForKey:@"intgwlsh"],[gwDic objectForKey:@"intgwlzlsh"]];
                docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [gwlztb reloadData];
            }
        }];
        [self.navigationController pushViewController:ztoazdcy animated:YES];
    }
    else
    {
        if (self.isryxz==YES) {
            NSString *dwlshlx = [NSString stringWithFormat:@"%@",[newStepDic objectForKey:@"intclfs"]?:@""];
            NSString *dwlshString;
            if ([dwlshlx isEqualToString:@"1"] || [dwlshlx isEqualToString:@"3"]) {
                dwlshString =[NSString stringWithFormat:@"%@",@(SingObj.unitInfo.intdwlsh_child)];//处室流水号
            }
            else
            {
                dwlshString =[NSString stringWithFormat:@"%@",@(SingObj.unitInfo.intdwlsh)];//单位流水号
            }
            ZtOAZdcyVC *ztoazdcy=[[ZtOAZdcyVC alloc]init:@"请选择下步处理人" selectAry:docDealModel.xbryAry storeDict:storeDicts];
            ztoazdcy.storeDict=storeDicts;
            ztoazdcy.isdx=zrdxdx;
            ztoazdcy.processOpr=newStepDic;
            ztoazdcy.currentCompanylsh=dwlshString;
            [ztoazdcy selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict){
                docDealModel.xbryAry =selectAry;
                storeDicts=storeDict;
                NSMutableArray *pepoleInfoArray = [[NSMutableArray alloc] init];//写信人员数据
                NSMutableString *tempcontent=[[NSMutableString alloc]init];
                NSString *content=@"";
                NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (AddUserInfo *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strryxm];
                    NSDictionary *oneManDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"chrbz", @(oamodel.intrylsh), @"lsh", oamodel.strryxm, @"name", nil];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[newStepDic objectForKey:@"zRdxlx"],oamodel.strryxm]];
                    [pepoleInfoArray addObject:oneManDic];
                }
                if (selectAry.count>0) {
                     content =[tempcontent substringToIndex:tempcontent.length-1];
                }
                docDealModel.xbrwryxm=[NSMutableString stringWithString:content];
                docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:zrobj,@"xml",content,@"content",pepoleInfoArray,@"arrayInfo",nil];
                [gwlztb reloadData];
            }];
            [self.navigationController pushViewController:ztoazdcy animated:YES];
        }else
        {
         PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择人员"];
            popview.sourceary=docDealModel.xbryAry;
            popview.key=@"content";
            popview.selectRowIndex=docDealModel.xbrwrynum;
            popview.callback=^(int selectrow,NSString *key){
                NSDictionary *notifyDic=docDealModel.xbryAry[selectrow];
                docDealModel.xbrwrynum=selectrow;
                docDealModel.xbrwryxm =docDealModel.xbryAry[selectrow][@"content"];
                NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"zrrlsh"]],@"1",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"content"]]];
                docDealModel.responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",[notifyDic objectForKey:@"content"],@"content",nil];
                [gwlztb reloadData];
            };
            [popview show];
        }
    }
}
#pragma mark------------------提交公文------------
-(void)doSave{
    //多任务流程
    BOOL ismultrw=NO;
    if ([docDealModel.xbrwmc isEqualToString:@"快速办文"]||[docDealModel.xbrwmc isEqualToString:@"送会签"]||[docDealModel.xbrwmc isEqualToString:@"流程自定义"]||[docDealModel.xbrwmc isEqualToString:@"指定人员任务"]){
        ismultrw=YES;
    }
    if (docDealModel.xbrwmc.length==0)
    {
        [self showMessage:@"请选择下步任务"];
        return;
    }else if (docDealModel.isDirecReturn==NO&&docDealModel.xbrwryxm.length==0&&ismultrw==NO)
    {
        [self showMessage:@"请选择下步人员"];
        return;
    }
    else if (ismultrw==YES&&docDealModel.opinionSelectedDic==nil)
    {
        [self showMessage:@"请选择下步任务任人员"];
        return;
    }
    NSDictionary *newStepDic=docDealModel.xbrwAry[docDealModel.xbrwnum];
    //NSString *zrdxdx=[NSString stringWithFormat:@"%@",[newStepDic objectForKey:@"zRdxdx"]?:@""];//责任人对象是否多选 1是单选 2是多选
    NSString *zrdxdx=@"1";
    if ([newStepDic[@"intact"] intValue]==112) {
        ZtOAPopView *ztoapop=[[ZtOAPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        ztoapop.callback=^(NSDictionary*dic){
            NSString*intlcbh=gwDic[@"gw"][@"gwgs"][@"intlcbh"];
            NSString*intgwlsh=[gwDic objectForKey:@"intgwlsh"];
            NSString*intgwlzlsh=gwDic[@"intgwlzlsh"];
            NSString*intbzjllsh1=[NSString stringWithFormat:@"%@",[gwDic objectForKey:@"intbzjllsh"]];
            NSString *strdbryxm=SingObj.userInfo.username;
            NSString *intrylsh=[NSString stringWithFormat:@"%@",@(SingObj.userInfo.intrylsh)];
            NSString *strdbzt=dic[@"xx"];
            NSString *dtmblsx=dic[@"time"];
            NSString *intact=newStepDic[@"intact"];
            NSString * xml= [NSString stringWithFormat:@"<intlcbh>%@</intlcbh><intgwlsh>%@</intgwlsh><intgwlzlsh>%@</intgwlzlsh><intbzjllsh>%@</intbzjllsh><strdbryxm>%@</strdbryxm><intrylsh>%@</intrylsh><strdbzt>%@</strdbzt><dtmblsx>%@</dtmblsx><intact>%@</intact>",intlcbh,intgwlsh,intgwlzlsh,intbzjllsh1,strdbryxm,intrylsh,strdbzt,dtmblsx,intact];
            NSString *str1 = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><lccz><czmc>%@</czmc>%@<dx>%@</dx><mrcs>%@</mrcs></lccz></root>",
                              [newStepDic objectForKey:@"stryjmc"]?:@"",
                              xml,
                              [zrdxdx intValue]==1?@"否":@"是",
                              [newStepDic objectForKey:@"mrcs"]?:@""];
            NSDictionary *lzDic= [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",@(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh",str1,@"queryTermXML",nil];
            
            [self network:@"document" requestMethod:@"setGwlz" requestHasParams:@"true" parameter:lzDic progresHudText:@"提交中..." completionBlock:^(id rep) {
                if (rep!=nil) {
                    [self showMessage:@"提交成功！"];
                   [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                }
            }];
        };
        [ztoapop show:self.view];
        return;
    }else{
        //提交流转数据
        NSString *strdic;
        NSString *base64Str=@"";
        if (docDealModel.dwImg!=nil) {
            NSData *data = UIImageJPEGRepresentation(docDealModel.dwImg, 0.5);
            base64Str = [data base64EncodedString];
        }
        if (docDealModel.opinionSelectedDic==nil) {
            strdic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><lccz><czmc>%@</czmc>%@<dx>%@</dx><mrcs>%@</mrcs></lccz><imgtz>%@</imgtz></root>",
                   [newStepDic objectForKey:@"stryjmc"]?:@"",
                      
                   [docDealModel.responsibleManDic objectForKey:@"xml"],
                      [zrdxdx intValue]==1?@"否":@"是",
                  [newStepDic objectForKey:@"mrcs"]?:@"",
                      base64Str];
        }
        else
        {
            strdic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><clyj><yjlx>%@</yjlx><yjmc>%@</yjmc><yjnr>%@</yjnr><mrcs>%@</mrcs></clyj><lccz><czmc>%@</czmc>%@<dx>%@</dx><mrcs>%@</mrcs></lccz><imgtz>%@</imgtz></root>",
                   [docDealModel.opinionSelectedDic objectForKey:@"intyjlx"]?:@"",
                   [docDealModel.opinionSelectedDic objectForKey:@"stryjmc"]?:@"",
                   docDealModel.clyjStr?:@"",
                   [docDealModel.opinionSelectedDic objectForKey:@"mrcs"],
                   [newStepDic objectForKey:@"stryjmc"]?:@"",
                   [docDealModel.responsibleManDic objectForKey:@"xml"],
                    [zrdxdx intValue]==1?@"否":@"是",
                   [newStepDic objectForKey:@"mrcs"],base64Str];
        }
        NSLog(@"dic==%@",[strdic mj_JSONString]);
        NSDictionary *lzdic=@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"intcsdwlsh":@(SingObj.unitInfo.intdwlsh_child),@"queryTermXML":strdic};
        [self networkall:@"document" requestMethod:@"setGwlz" requestHasParams:@"true" parameter:lzdic progresHudText:@"提交中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                if ([[[rep objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                    [self showMessage:@"提交成功！"];
                     [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                }
            }
        }];
    }
}
#pragma mark-------------获取手写签批-------------
-(void)sxqpSEL{
    SKGRaphicVC *skgraphic=[[SKGRaphicVC alloc]initWithTitle:@"手写签批"];
    skgraphic.callback=^(UIImage *dwimage){
        docDealModel.dwImg=dwimage;
        [gwlztb reloadData];
    };
    [self.navigationController pushViewController:skgraphic animated:YES];
    
}
#pragma mark-------------上传文件-------
-(void)UpFile:(NSNotification *)notification
{
    NSDictionary *fileInfo=notification.userInfo;
    UIAlertView *alertview=[UIAlertView bk_showAlertViewWithTitle:@"温馨提示" message:@"是否上传改稿" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            [dealfjvc updateGwfj:fileInfo[@"fileData"]];
        }
    }];
    [alertview show];
}
-(void)cancelSEL{
    docDealModel.dwImg=nil;
    [gwlztb reloadData];
}
-(void)gogo{
    if (self.callback) {
        self.callback(YES);
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
