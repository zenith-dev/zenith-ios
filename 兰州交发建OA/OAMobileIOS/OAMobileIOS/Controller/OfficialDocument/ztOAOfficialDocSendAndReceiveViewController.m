//
//  ztOAOfficialDocSendAndReceiveViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAOfficialDocSendAndReceiveViewController.h"
#import "ztOAOpenDocumentViewController.h"
#import "ZtOAFlowPersonVC.h"
#import "ztOAZdcyVC.h"

@interface ztOAOfficialDocSendAndReceiveViewController ()
{
    UIButton *conerightBtn;
    NSString        *type;//type:1发文处理；2收文处理
    NSString        *docTitleStr;
    NSString        *docTextNumStr;
    NSString        *docThemeStr;
    NSString        *companyNameStr;
    NSString        *djrStr;
    NSString        *docLimitTimeStr;
    NSMutableArray  *docBagArray;
    NSMutableArray  *processInfoArray;
    NSString *mimeType;//文件类型
    NSMutableArray  *opinionListArray;
    NSMutableArray  *nextStepListArray;//下步任务数组
    NSMutableArray *getpsersonArray;//选择人员信息
    NSMutableArray  *responsibleManArray;//下步责任人数据
    
    NSString        *i_Intgwlzlsh;//公文流转流水号
    
    BOOL            closeFlag;
    BOOL            isSearchFlag;
    BOOL            canSave;//提交按钮开启标志
    BOOL            isDirecReturn;//是否是直接返回，不需要选择下步处理人
    NSDictionary    *baseInfoDic;
    NSDictionary    *detailInfoDic;
    
    NSDictionary    *nextStepDic;//选定的下步任务数据
    NSDictionary    *responsibleManDic;//选定的处理人数据
    NSDictionary    *opinionSelectedDic;//选定的处理意见数据
    NSString        *opinionNameStr;//选定处理意见文字
    
    NSString        *i_ZRdxdx;//责人对象多选
    
    NSString        *i_type;
    NSMutableArray  *dataInfoArray;
    
    float           kOFFSET_FOR_KEYBOARD;//键盘高度
    float           titleHeight;//标题高度
    float           leaderOpinionHeight0;//第一条领导意见框高度
    float           leaderOpinionHeight1;//第二条领导意见框高度
    BOOL            showWebViewYes;//显示正文：yes；隐藏：no
    BOOL            openWebViewTag;//默认打开正文：yes；默认不打开，只显示正文文稿（同附件样式）：no
    NSString        *zhengwenFJName;//正文附件名称
    NSString        *zhengwenFJLsh;//正文附件流水号
    NSString        *zhengwenPath;//正文保存路径
    float           height_webview;//webview高度
    NSMutableArray  *isExpandArray;//办理过程展开标志数组
    
    NSMutableArray  *ldpsyjArray;//领导批示意见
    NSData *filedata;
}
@property(nonatomic,strong)UIButton*deleteAtionBtn;
@property(nonatomic,strong)NSMutableDictionary *storeDicts;
@property(nonatomic,strong)UIScrollView     *mainScrollView;
@property(nonatomic,strong)UITableView      *docInfoView;//文件信息图表
@property(nonatomic,strong)UITableView      *processInfoList;//流程监控表
@property(nonatomic,strong)UIButton         *InfoMessageBtn;//doc文件信息按钮
@property(nonatomic,strong)UIButton         *processMonitorBtn;//流程监控按钮
@property(nonatomic,strong)UITextView       *opinionField;//处理意见可编写
@property(nonatomic,strong)UILabel          *chargeWayField;//下步任务
@property(nonatomic,strong)UILabel          *responsibleManField;//下步处理人
@property(nonatomic,strong)UIActionSheet    *opinionSheet;//意见列表
//@property(nonatomic,strong)UIActionSheet    *waySheet;//任务方式列表

@property(nonatomic,strong)UITableView      *docDetailInfoTable;//收发文信息表

@property(nonatomic,strong)UITableView      *alertViewListTable;//弹出框列表
//@property(nonatomic,strong)CXAlertView      *cxAlertView;//弹出框
@property(nonatomic,strong)UIView           *alertViewBack;//弹出框
@property(nonatomic,strong)UILabel          *alertTitleLable;//弹出框标题
@property(nonatomic,strong)UIButton         *alertBackBtn;//弹出框按钮

@property(nonatomic,strong)UIButton         *sendAndSaveBtn;//提交按钮
@property(nonatomic,strong)UIWebView        *docWebView;//正文稿图

@property (nonatomic,strong)NDHTMLtoPDF     *PDFCreator;
@end

@implementation ztOAOfficialDocSendAndReceiveViewController
@synthesize mainScrollView,docInfoView,processInfoList,InfoMessageBtn,processMonitorBtn,opinionField,chargeWayField,responsibleManField;
@synthesize docDetailInfoTable;
@synthesize opinionSheet;
@synthesize alertViewListTable,alertViewBack,alertBackBtn,alertTitleLable;
@synthesize sendAndSaveBtn;
@synthesize docWebView;
@synthesize PDFCreator,storeDicts;
//isOnSearch:yes公文查询,no公文处理
- (id)initWithData:(NSDictionary *)intDataDic isOnSearch:(BOOL)isOnSearch
{
    self = [super init];
    if (self) {
        canSave = NO;//默认不开启
        isDirecReturn = NO;
        closeFlag = YES;//yes用户不能操作；no可操作
        nextStepDic = nil;//下步任务数据
        baseInfoDic = intDataDic;//公文基本信息
        isSearchFlag = isOnSearch;//公文查询标志
        opinionNameStr = @"";//意见
        i_ZRdxdx = @"1";//默认单选
        showWebViewYes = NO;
        openWebViewTag = NO;
        
        height_webview= 10;
        leaderOpinionHeight0 = 0;
        leaderOpinionHeight1 = 0;
        i_Intgwlzlsh = [intDataDic objectForKey:@"intgwlzlsh"];
        if ([[intDataDic objectForKey:@"chrlzlx"] isEqualToString:@"发文"])
        {
            type=@"1";
        }
        else
        {
            type=@"2";
        }
        
        docTitleStr =[NSString stringWithFormat:@"%@",[intDataDic objectForKey:@"chrgwbt"]?:@""];
        docTextNumStr = [NSString stringWithFormat:@"%@〔%@〕%@号",[intDataDic  objectForKey:@"chrgwz"],[intDataDic objectForKey:@"intgwnh"],[intDataDic objectForKey:@"intgwqh"]];
        
        companyNameStr = [NSString stringWithFormat:@"%@",[intDataDic objectForKey:@"chrlwdwmc"]?:@""];
        
       
        docLimitTimeStr = [NSString stringWithFormat:@"%@",[intDataDic objectForKey:@"dtmblsx"]?:@""];
        
        //计算标题高度
        CGSize maximumLabelSizeContext = CGSizeMake(self.view.width-40,MAXFLOAT);
        CGSize expectedLabelSizeContext= [docTitleStr sizeWithFont:[UIFont systemFontOfSize:16]
                                                 constrainedToSize:maximumLabelSizeContext
                                                     lineBreakMode:NSLineBreakByWordWrapping];
        titleHeight = expectedLabelSizeContext.height;
        processInfoArray= [[NSMutableArray alloc] init];
        docBagArray = [[NSMutableArray alloc] init];
        nextStepListArray = [[NSMutableArray alloc] init];
        opinionListArray = [[NSMutableArray alloc] init];
        isExpandArray = [[NSMutableArray alloc] init];
        ldpsyjArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    storeDicts=[[NSMutableDictionary alloc]init];
    getpsersonArray=[[NSMutableArray alloc]init];
    conerightBtn=[self rightButton:nil imagen:@"btn_fav_no_n" imageh:nil sel:@selector(collectDocAction)];
    [conerightBtn setImage:PNGIMAGE(@"btn_fav_yes_n") forState:UIControlStateSelected];
    
    //监测本地收藏
    [self searchLocalCollect];
    
    UIImage *leftBtnImg = [UIImage imageNamed:@"tab_White_Left"];
    UIImage *hlLeftBtnImg = [UIImage imageNamed:@"tab_blue_Left"];
    UIImage *rightBtnImg = [UIImage imageNamed:@"tab_White_Right"];
    UIImage *hlRightBtnImg = [UIImage imageNamed:@"tab_blue_Right"];
    //切换查看按钮
    self.InfoMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,64+44-29-5, (self.view.width-10)/2, 29)];
    [InfoMessageBtn setUserInteractionEnabled:YES];
    [InfoMessageBtn setTitle:[NSString stringWithFormat:@"%@信息",[type isEqualToString:@"1"]?@"发文":@"收文"]  forState:UIControlStateNormal];
    [InfoMessageBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [InfoMessageBtn addTarget:self action:@selector(showDocInfo) forControlEvents:UIControlEventTouchUpInside];
    [InfoMessageBtn setBackgroundColor:[UIColor clearColor]];
    [InfoMessageBtn setBackgroundImage:hlLeftBtnImg forState:UIControlStateSelected];
    [InfoMessageBtn setBackgroundImage:leftBtnImg forState:UIControlStateNormal];
    [InfoMessageBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [InfoMessageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [InfoMessageBtn setSelected:YES];
    [self.view addSubview:InfoMessageBtn];
    
    self.processMonitorBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2, 64+44-29-5, (self.view.width-10)/2, 29)];
    [processMonitorBtn setUserInteractionEnabled:YES];
    [processMonitorBtn setTitle:@"办理过程" forState:UIControlStateNormal];
    [processMonitorBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [processMonitorBtn addTarget:self action:@selector(showProssInfo) forControlEvents:UIControlEventTouchUpInside];
    [processMonitorBtn setBackgroundColor:[UIColor clearColor]];
    [processMonitorBtn setBackgroundImage:hlRightBtnImg forState:UIControlStateSelected];
    [processMonitorBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [processMonitorBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [processMonitorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.view addSubview:processMonitorBtn];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.InfoMessageBtn.bottom, self.view.width, self.view.height-self.InfoMessageBtn.bottom)];
    [self.mainScrollView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView setPagingEnabled:YES];
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.mainScrollView setContentSize:CGSizeMake(self.view.width*2, self.view.height-self.InfoMessageBtn.bottom)];
    mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    //文件信息表
    self.docInfoView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, mainScrollView.height-45) style:UITableViewStylePlain];
    self.docInfoView.separatorStyle = UITableViewCellSelectionStyleNone;
    docInfoView.delegate = self;
    docInfoView.dataSource = self;
    [self.mainScrollView addSubview:docInfoView];
    
    UIImage *sendBtnImg = [UIImage imageNamed:@"color_02"];
    NSInteger leftSendCapWidth = sendBtnImg.size.width * 0.5f;
    NSInteger topSendCapHeight = sendBtnImg.size.height * 0.5f;
    sendBtnImg = [sendBtnImg stretchableImageWithLeftCapWidth:leftSendCapWidth topCapHeight:topSendCapHeight];
    
    self.sendAndSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendAndSaveBtn.backgroundColor = [UIColor clearColor];
    [sendAndSaveBtn setBackgroundImage:sendBtnImg forState:UIControlStateNormal];
    [sendAndSaveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sendAndSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendAndSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [sendAndSaveBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [sendAndSaveBtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    sendAndSaveBtn.frame = CGRectMake(20, docInfoView.bottom+5, self.view.width-40, 35);
    [sendAndSaveBtn setHidden:YES];
    [self.mainScrollView addSubview:sendAndSaveBtn];
    
    //流程监控表
    self.processInfoList = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width,0, self.view.width,mainScrollView.height) style:UITableViewStylePlain];
    self.processInfoList.separatorStyle = UITableViewCellSelectionStyleNone;
    processInfoList.delegate = self;
    processInfoList.dataSource = self;
    [self.mainScrollView addSubview:processInfoList];
    
    //处理意见选择
    self.opinionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"同意",@"已阅", nil];
    [opinionSheet setFrame:CGRectMake(0, self.view.size.height-260, 320, 260)];
    opinionSheet.delegate = self;
    opinionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    self.alertViewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    alertViewBack.backgroundColor = [UIColor clearColor];
    UIImageView *blackImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertViewBack.width, alertViewBack.height)];
    blackImg.backgroundColor = [UIColor blackColor];
    blackImg.alpha = 0.6;
    [alertViewBack addSubview:blackImg];
    UIImageView *TitleImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 70, alertViewBack.width-40, 30)];
    TitleImg.backgroundColor = BACKCOLOR;
    [alertViewBack addSubview:TitleImg];
    
    
    //弹出框列表
    self.alertViewListTable = [[UITableView alloc] initWithFrame:CGRectMake(20, 100, alertViewBack.width-40, alertViewBack.height-180) style:UITableViewStylePlain];
    self.alertViewListTable.separatorStyle = UITableViewCellSelectionStyleNone;
    alertViewListTable.delegate = self;
    alertViewListTable.dataSource = self;
    
    [alertViewBack addSubview:alertViewListTable];
    
    self.alertBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alertBackBtn.frame = CGRectMake(30, 70, 30, 30);
    [alertBackBtn setImage:[UIImage imageNamed:@"back_btn_n"] forState:UIControlStateNormal];
    [alertBackBtn setImage:[UIImage imageNamed:@"back_btn_h"] forState:UIControlStateHighlighted];
    [alertBackBtn addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [alertBackBtn setBackgroundColor:[UIColor clearColor]];
    [alertViewBack addSubview:alertBackBtn];
    
    self.alertTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(30+30, 75, alertViewBack.width-40-(30+10)*2, 20)];
    alertTitleLable.textColor = [UIColor whiteColor];
    alertTitleLable.textAlignment = NSTextAlignmentCenter;
    alertTitleLable.backgroundColor = [UIColor clearColor];
    alertTitleLable.text = @"请选择";
    [alertViewBack addSubview:alertTitleLable];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopAtion) forControlEvents:UIControlEventTouchUpInside];
    
    addN(@selector(selectNextStepWay:), @"NEXTSTEPWAY");
    addN(@selector(selectDoneResponsibleMan:), @"RESPONSIBLEMAN");
    addN(@selector(selectDoneOpinion:), @"OPINIONSELECT");
    addN(@selector(selectDoneTreeResponsibleMan:), @"TREERESPONCHOOSE");
    [self loadDocInfoData];
}
- (void)docViewGoBack
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];//注意
    NSError *error;
    // 创建文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //删除下载的临时文件
    if (![fileMgr removeItemAtPath:zhengwenPath error:&error]){
        NSLog(@"删除正文稿文件时错误: %@", [error localizedDescription]);
    }
    if ([fileMgr removeItemAtPath:[self UrlFromPathOfDocuments:@"/blocksDemo.pdf"] error:&error]) {
        NSLog(@"删除pdf文件时错误: %@", [error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-获取数据
- (void)loadDocInfoData
{
    [self showWaitView];
    if (isSearchFlag==YES) {
        //获取公文基本信息及流转信息(查询功能)
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:i_Intgwlzlsh,@"intgwlzlsh", nil];
        [ztOAService getOfficeDocDetailInfo:dic Success:^(id result){
            [self closeWaitView];
            NSDictionary *dicData = [result objectFromJSONData];
            //NSLog(@"%@",dicData);
            if ([[dicData objectForKey:@"gw"] objectForKey:@"result"] !=NULL && [[[dicData objectForKey:@"gw"] objectForKey:@"result"] intValue]==0) {
                detailInfoDic = dicData;
                
                if ([[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]!=NULL && ![[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]] isEqualToString:@""]) {
                   djrStr = [NSString stringWithFormat:@"%@",[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]objectForKey:@"strjsrxm"]?:@""];
                    //附件数组
                    NSMutableArray *fjArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"fj"] ;
                    if ([fjArray isKindOfClass:[NSDictionary class]]) {
                        [docBagArray addObject:fjArray];
                    }else
                    {
                        docBagArray = fjArray;
                    }
                    //显示正文处理
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OPENDOCINWEBVIEW"]==nil) {
                    }
                    else
                    {
                    
                    }
                    //lzbz，流转步骤
                    NSMutableArray *lzbzArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lzbz"] ;
                    
                    if (lzbzArray!=NULL &&[lzbzArray isKindOfClass:[NSMutableArray class]]) {
                        processInfoArray = lzbzArray;
                    }
                    else if (lzbzArray!=NULL &&[lzbzArray isKindOfClass:[NSDictionary class]]){
                        [processInfoArray addObject:[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lzbz"]];
                    }
                    //办理过程展开收起标志数组初始化
                    for (int j=0; j<processInfoArray.count; j++) {
                        [isExpandArray addObject:@"2"];
                    }
                    //领导批示意见
                    if ([[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"]!=NULL) {
                        if ([[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"] isKindOfClass:[NSMutableArray class]]) {
                            ldpsyjArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"];
                        }
                        else if([[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"] isKindOfClass:[NSDictionary class]])
                        {
                            [ldpsyjArray addObject:[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"]];
                        }
                        //计算意见高度
                        if (ldpsyjArray.count>0) {
                            NSString *opinion0 = [NSString stringWithFormat:@"%@",[[ldpsyjArray objectAtIndex:0] objectForKey:@"ldpsyjnr"]];
                            CGSize maximumLabelSizeContext0 = CGSizeMake(self.view.width-70,MAXFLOAT);
                            CGSize expectedLabelSizeContext0= [opinion0 sizeWithFont:[UIFont systemFontOfSize:14]
                                                                   constrainedToSize:maximumLabelSizeContext0
                                                                       lineBreakMode:NSLineBreakByWordWrapping];
                            leaderOpinionHeight0 =expectedLabelSizeContext0.height+20;
                        }
                        
                        if (ldpsyjArray.count>1) {
                            NSString *opinion1 = [NSString stringWithFormat:@"%@",[[ldpsyjArray objectAtIndex:1] objectForKey:@"ldpsyjnr"]];
                            CGSize maximumLabelSizeContext1 = CGSizeMake(self.view.width-70,MAXFLOAT);
                            CGSize expectedLabelSizeContext1= [opinion1 sizeWithFont:[UIFont systemFontOfSize:14]
                                                                   constrainedToSize:maximumLabelSizeContext1
                                                                       lineBreakMode:NSLineBreakByWordWrapping];
                            leaderOpinionHeight1 =expectedLabelSizeContext1.height+20;
                        }
                    }
                    
                    [processInfoList reloadData];
                    [docInfoView reloadData];
                    
                }
                
            }
            canSave = NO;
            
        } Failed:^(NSError *error){
            [self closeWaitView];
            canSave = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }];
        [sendAndSaveBtn setHidden:YES];
        self.docInfoView.frame = CGRectMake(0, 0, self.view.width, mainScrollView.height);
    }
    //获取公文基本信息及流转处理信息（处理功能）
    else
    {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",[baseInfoDic objectForKey:@"intbzjllsh"],@"intbzjllsh", nil];
        
        [ztOAService getOfficeDocLzclInfo:dic Success:^(id result){
            [self closeWaitView];
            NSDictionary *dicData = [result objectFromJSONData];
            NSLog(@"dic==5%@",dicData);
            if ( [[dicData objectForKey:@"gw"] objectForKey:@"result"] !=NULL && [[[dicData objectForKey:@"gw"] objectForKey:@"result"] intValue]==0) {
                detailInfoDic = dicData;
                if ([[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]!=NULL && ![[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]] isEqualToString:@""]) {
                    //附件数组
                    NSMutableArray *fjArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"fj"] ;
                    if ([fjArray isKindOfClass:[NSDictionary class]]) {
                        [docBagArray addObject:fjArray];
                    }else
                    {
                        docBagArray = fjArray;
                    }
                    //显示正文处理
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OPENDOCINWEBVIEW"]==nil) {
                    }
                    else
                    {
                    }
                    //clyj,处理意见
                    NSMutableArray *opinionArr = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"clyj"] ;
                    if ([opinionArr isKindOfClass:[NSDictionary class]]) {
                        [opinionListArray addObject:opinionArr];
                        opinionSelectedDic = (NSDictionary *)opinionArr;
                    }
                    else if([opinionArr isKindOfClass:[NSMutableArray class]])
                    {
                        opinionListArray = opinionArr;
                        opinionSelectedDic = [opinionListArray objectAtIndex:0];
                    }
                    else
                    {
                        opinionListArray= nil;
                        opinionSelectedDic = nil;
                    }
                     djrStr = [NSString stringWithFormat:@"%@",[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"]objectForKey:@"strjsrxm"]?:@""];
                    //lzbz，流转步骤
                    NSMutableArray *lzbzArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lzbz"] ;
                    
                    if (lzbzArray!=NULL &&[lzbzArray isKindOfClass:[NSMutableArray class]]) {
                        processInfoArray = lzbzArray;
                    }
                    else if (lzbzArray!=NULL &&[lzbzArray isKindOfClass:[NSDictionary class]]){
                        [processInfoArray addObject:[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lzbz"]];
                    }
                    //办理过程展开收起标志数组初始化
                    for (int j=0; j<processInfoArray.count; j++) {
                        [isExpandArray addObject:@"2"];
                    }
                    //领导批示意见
                    if ([[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"]!=NULL) {
                        if ([[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"] isKindOfClass:[NSMutableArray class]]) {
                            ldpsyjArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"];
                        }
                        else if([[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"] isKindOfClass:[NSDictionary class]])
                        {
                            [ldpsyjArray addObject:[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"ldpsyj"]];
                        }
                        //计算意见高度
                        if (ldpsyjArray.count>0) {
                            NSString *opinion0 = [NSString stringWithFormat:@"%@",[[ldpsyjArray objectAtIndex:0] objectForKey:@"ldpsyjnr"]];
                            CGSize maximumLabelSizeContext0 = CGSizeMake(self.view.width-70,MAXFLOAT);
                            CGSize expectedLabelSizeContext0= [opinion0 sizeWithFont:[UIFont systemFontOfSize:14]
                                                                   constrainedToSize:maximumLabelSizeContext0
                                                                       lineBreakMode:NSLineBreakByWordWrapping];
                            leaderOpinionHeight0 =expectedLabelSizeContext0.height+20;
                        }
                        
                        if (ldpsyjArray.count>1) {
                            NSString *opinion1 = [NSString stringWithFormat:@"%@",[[ldpsyjArray objectAtIndex:1] objectForKey:@"ldpsyjnr"]];
                            CGSize maximumLabelSizeContext1 = CGSizeMake(self.view.width-70,MAXFLOAT);
                            CGSize expectedLabelSizeContext1= [opinion1 sizeWithFont:[UIFont systemFontOfSize:14]
                                                                   constrainedToSize:maximumLabelSizeContext1
                                                                       lineBreakMode:NSLineBreakByWordWrapping];
                            leaderOpinionHeight1 =expectedLabelSizeContext1.height+20;
                        }
                    }
                    
                    //<!-- lccz:流转操作 -->
                    NSString *str =([[[[detailInfoDic objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"]isEqual:[NSNull null]]?@"":[[[detailInfoDic objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"])?:@"";
                    
                    //intact=35时直接返回，intact=128时传阅结束
                    
                    if ( [str isKindOfClass:[NSDictionary class]] || [str isKindOfClass:[NSArray class]]) {
                        canSave = YES;
                        [sendAndSaveBtn setHidden:NO];
                        [nextStepListArray removeAllObjects];
                        
                        if ([[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"] isKindOfClass:[NSDictionary class]]) {
                            [nextStepListArray addObject:[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"]];
                            nextStepDic =[[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"];
                            //直接返回
                            if ([[nextStepDic objectForKey:@"intact"] intValue]==35 ||
                                [[nextStepDic objectForKey:@"intact"] intValue]==128 ||
                                [[nextStepDic objectForKey:@"zRdxdx"] intValue]==3) {
                                NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",@""],@"1",@""];
                                responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",@"",@"content",nil];
                                
                                isDirecReturn = YES;
                            }
                            closeFlag = NO;
                            
                            [sendAndSaveBtn setTitle:[NSString stringWithFormat:@"%@",[nextStepDic objectForKey:@"stryjmc"]?:@"提交"] forState:UIControlStateNormal];
                            
                        }else
                        {
                            nextStepListArray = [[[dicData objectForKey:@"gw"] objectForKey:@"gwgs"] objectForKey:@"lccz"];
                        }
                        
                    }else
                    {
                        canSave = NO;
                        [sendAndSaveBtn setHidden:YES];
                        self.docInfoView.frame = CGRectMake(0, 0, self.view.width, mainScrollView.height);
                    }
                    
                    [processInfoList reloadData];
                    [docInfoView reloadData];
                }
                else
                {
                    canSave = NO;
                    [sendAndSaveBtn setHidden:YES];
                    self.docInfoView.frame = CGRectMake(0, 0, self.view.width, mainScrollView.height);
                }
            }
            
        } Failed:^(NSError *error){
            [self closeWaitView];
            [conerightBtn setHidden:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            canSave = NO;
            [sendAndSaveBtn setHidden:YES];
            self.docInfoView.frame = CGRectMake(0, 0, self.view.width, mainScrollView.height);
        }];
        
    }
    
}
- (void)goToTopAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    if ([InfoMessageBtn isSelected]) {
        [docInfoView setContentOffset:CGPointMake(0,0) animated:animated];
    }
    else if ([processMonitorBtn isSelected])
    {
        [processInfoList setContentOffset:CGPointMake(0,0) animated:animated];
    }
}
- (void)closeAlertView
{
    [alertViewBack removeFromSuperview];
}
#pragma mark - actionsheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == opinionSheet)
    {
        switch (buttonIndex) {
            case 0:
            {
                [self.opinionField setText:@"同意"];
            }
                break;
            case 1:
            {
                [self.opinionField setText:@"已阅"];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 打开附件
- (void)openDocumentView:(id)sender
{
    NSDictionary *fjDic = [docBagArray objectAtIndex:((ztOAUnderLineLabel *)sender).tag];
    ztOAOpenDocumentViewController *docVC = [[ztOAOpenDocumentViewController alloc] initWithSource:fjDic];
    [self.navigationController pushViewController:docVC animated:YES];
}
#pragma mark-显示文件信息
- (void)showDocInfo
{
    if (![InfoMessageBtn isSelected]) {
        [InfoMessageBtn setSelected:YES];
        [processMonitorBtn setSelected:NO];
        [mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}
#pragma mark-显示流程监控
- (void)showProssInfo
{
    if (![processMonitorBtn isSelected]) {
        [processMonitorBtn setSelected:YES];
        [InfoMessageBtn setSelected:NO];
        [mainScrollView setContentOffset:CGPointMake(self.view.width, 0)];
    }
}

#pragma mark-/////////处理意见选择/////////
- (void)selectOpinion
{
    [opinionField resignFirstResponder];
    opinionNameStr = opinionField.text?:@"";
    //默认意见
    dataInfoArray = nil;
    //获取常用语
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",@"",@"intdwlsh",@"",@"chrnrbz", nil];
    [self showWaitView];
    [ztOAService getPersonCyyList:dic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        //NSLog(@"%@",dataDic);
        if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            if (dataDic!=NULL &&[(NSString *)[[dataDic objectForKey:@"root"] objectForKey:@"message"] isEqualToString:@"查询成功"]) {
                if ([[[dataDic objectForKey:@"root"] objectForKey:@"cyynr"] isKindOfClass:[NSDictionary class]]) {
                    dataInfoArray = [[NSMutableArray alloc] initWithObjects:[[dataDic objectForKey:@"root"] objectForKey:@"cyynr"], nil];
                }
                else{
                    dataInfoArray = [[dataDic objectForKey:@"root"] objectForKey:@"cyynr"];
                }
                ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"常用语选择" listArray:dataInfoArray whichType:@"1"];
                listVC.title=@"常用语选择";
                [self.navigationController pushViewController:listVC animated:YES];
                
                return ;
            }
        }
        dataInfoArray = [[NSMutableArray alloc] initWithObjects:@"同意",@"不同意",@"已阅", nil];
        /*
         i_type = @"1";
         [alertViewListTable reloadData];
         [self.view addSubview:alertViewBack];
         */
        ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"常用语选择" listArray:dataInfoArray whichType:@"1"];
        [self.navigationController pushViewController:listVC animated:YES];
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        dataInfoArray = [[NSMutableArray alloc] initWithObjects:@"同意",@"不同意",@"已阅", nil];
        /*
         i_type = @"1";
         [alertViewListTable reloadData];
         [self.view addSubview:alertViewBack];
         */
        ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"常用语选择" listArray:dataInfoArray whichType:@"1"];
        [self.navigationController pushViewController:listVC animated:YES];
        
    }];
}
#pragma mark - 处理意见选择处理
- (void)selectDoneOpinion:(NSNotification *)notify
{
    NSString *str =[NSString stringWithFormat:@"%@",([[notify userInfo] isEqual:[NSNull null]]?@"":[notify userInfo] )?:@"" ];
    opinionField.text = str;
    opinionNameStr = str;
    [docInfoView reloadData];
}
#pragma mark- /////////下步任务选择/////////
- (void)selectChargeWay
{
    [opinionField resignFirstResponder];
    opinionNameStr = opinionField.text?:@"";
    ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"请选择下步任务" listArray:nextStepListArray whichType:@"2"];
    listVC.title=@"请选择下步任务";
    [self.navigationController pushViewController:listVC animated:YES];
}
#pragma mark - 下步任务处理
- (void)selectNextStepWay:(NSNotification *)notify
{
    nextStepDic = (NSDictionary *)[notify userInfo];
    NSString *str =([[nextStepDic objectForKey:@"zrobj"] isEqual:[NSNull null]]?@"":[nextStepDic objectForKey:@"zrobj"])?:@"";
    responsibleManArray=[[NSMutableArray alloc]init];
    if ( ([str isKindOfClass:[NSDictionary class]] || [str isKindOfClass:[NSArray class]] ) && [[nextStepDic objectForKey:@"zRdxlx"] intValue]!=2)
    {
        closeFlag = NO;
        if ([str isKindOfClass:[NSDictionary class]]) {
            [responsibleManArray addObject:str];
        }
        else
        {
            responsibleManArray = (NSMutableArray *)str;
        }
    }
    else
    {
        closeFlag = NO;
    }
    responsibleManDic = nil;
    if (([[nextStepDic objectForKey:@"intact"] intValue]==35 ||
         [[nextStepDic objectForKey:@"intact"] intValue]==128 ||
         [[nextStepDic objectForKey:@"zRdxdx"] intValue]==3)) {
        isDirecReturn = YES;
        NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",@""],@"1",@""];
        responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",@"",@"content",nil];
        [docInfoView reloadData];
    }
    else
    {
        isDirecReturn = NO;
        [docInfoView reloadData];
    }
    
}

#pragma mark-/////////下步处理人选择/////////
- (void)selectResponsibleMan
{
    [opinionField resignFirstResponder];
    opinionNameStr = opinionField.text?:@"";
    i_ZRdxdx = [NSString stringWithFormat:@"%@",[nextStepDic objectForKey:@"zRdxdx"]?:@""];
    int intact =[nextStepDic[@"intact"] intValue];
    if (intact==60) {//分流程功能
        ZtOAFlowPersonVC *flowperson=[[ZtOAFlowPersonVC alloc]init:@"请选择下步处理人" selectAry:getpsersonArray storeDict:storeDicts];
        flowperson.storeDict=storeDicts;
        flowperson.processOpr=nextStepDic;
        [flowperson selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict) {
            getpsersonArray =selectAry;
            storeDicts=storeDict;
             NSMutableString *zrobj=[[NSMutableString alloc]init];
            NSMutableString *tempcontent=[[NSMutableString alloc]init];
            NSMutableString *tempintnewrylshlst=[[NSMutableString alloc]init];
            NSMutableString *tempintlcdylshlst=[[NSMutableString alloc]init];
            NSMutableString *tempintbzlst=[[NSMutableString alloc]init];
             NSMutableString *tempintbcbhlst=[[NSMutableString alloc]init];
            NSMutableString *tempstrzrrlxLst=[[NSMutableString alloc]init];
            NSString *xml;
            NSMutableString *tempintgzlclshlst=[[NSMutableString alloc]init];
            for (ztOAABModel *oamodel  in selectAry) {
                [tempcontent appendFormat:@"%@,",oamodel.strxm];
                [tempstrzrrlxLst appendFormat:@"%@,",storeDicts[@"strzrrlxLst"]];
                [tempintlcdylshlst appendFormat:@"0,"];
                [tempintnewrylshlst appendFormat:@"%@,",oamodel.intrylsh];
                
                [tempintbzlst appendFormat:@"%@,",storeDicts[@"intbzlst"]];
                 [tempintbcbhlst appendFormat:@"%@,",storeDicts[@"intbcbhlst"]];
                 [tempintgzlclshlst appendFormat:@"%@,", storeDicts[@"intgzlclshlst"]];
                [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",oamodel.intrylsh,[nextStepDic objectForKey:@"zRdxlx"],  [self UnicodeToISO88591:oamodel.strxm]]];
            }
            NSString *intnewrylshlst=@"";
            NSString *content=@"";
            NSString *intlcdylshlst=@"";
             NSString *intbzlst=@"";
             NSString *intbcbhlst=@"";
            NSString *strzrrlxLst=@"";
             NSString *intgzlclshlst=@"";
            if (selectAry.count>0) {
                intgzlclshlst =[tempintgzlclshlst substringToIndex:tempintgzlclshlst.length-1];
                strzrrlxLst=[tempstrzrrlxLst substringToIndex:tempstrzrrlxLst.length-1];
                intbcbhlst=[tempintbcbhlst substringToIndex:tempintbcbhlst.length-1];
                intbzlst=[tempintbzlst substringToIndex:tempintbzlst.length-1];
                intlcdylshlst=[tempintlcdylshlst substringToIndex:tempintlcdylshlst.length-1];
                intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                content =[tempcontent substringToIndex:tempcontent.length-1];
            }
            xml= [NSString stringWithFormat:@"%@<intnextgzrylsh>%@</intnextgzrylsh><intnextgzlclsh>%@</intnextgzlclsh><strzrrlxLst>%@</strzrrlxLst><strnextgzrylx>%@</strnextgzrylx><intrylshlst>%@</intrylshlst><intlcdylshlst>%@</intlcdylshlst><strlzlxlst>%@</strlzlxlst><strwcbz>%@</strwcbz><strbwcbzLst></strbwcbzLst><intbzlst>%@</intbzlst><intgzlclshlst>%@</intgzlclshlst><intbcbhlst>%@</intbcbhlst>",zrobj,storeDicts[@"intnextgzrylsh"]?:@"",nextStepDic[@"intnextgzlclsh"],strzrrlxLst,storeDicts[@"strnextgzrylx"],intnewrylshlst,intlcdylshlst,intlcdylshlst,storeDicts[@"strwcbz"],intbzlst,intgzlclshlst,intbcbhlst];
            responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
            [docInfoView reloadData];
        }];
         [self.navigationController pushViewController:flowperson animated:YES];
    }
    else if (intact==96||intact==127||intact==22){//指定内部人员
        ztOAZdcyVC *ztoazdcy=[[ztOAZdcyVC alloc]init:@"请选择下步处理人" selectAry:getpsersonArray storeDict:storeDicts];
        ztoazdcy.storeDict=storeDicts;
        ztoazdcy.processOpr=nextStepDic;
        ztoazdcy.currentCompanylsh=[ztOAGlobalVariable sharedInstance].intdwlsh;
        [ztoazdcy selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict) {
            getpsersonArray =selectAry;
            storeDicts=storeDict;
            NSMutableString *tempcontent=[[NSMutableString alloc]init];
            NSMutableString *tempintnewrylshlst=[[NSMutableString alloc]init];
            NSString *xml;
            if (intact==96) {
                 NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (ztOAABModel *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strxm];
                    [tempintnewrylshlst appendFormat:@"%@,",oamodel.intrylsh];
                     [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",oamodel.intrylsh,[nextStepDic objectForKey:@"zRdxlx"],[self UnicodeToISO88591:oamodel.strxm]]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                    
                }
                xml= [NSString stringWithFormat:@"%@<intrylsh>%@</intrylsh><intcsdwlsh>%@</intcsdwlsh><intdwlsh>%@</intdwlsh><intcxlx>0</intcxlx><intzdrylsh>%@</intzdrylsh><intgwlsh>%@</intgwlsh><intlx>2</intlx><intgwlzlsh>%@</intgwlzlsh><intczrylsh>%@</intczrylsh><intnewrylshlst>%@</intnewrylshlst>",zrobj,[ztOAGlobalVariable sharedInstance].intrylsh,[ztOAGlobalVariable sharedInstance].intdwlsh_child,[ztOAGlobalVariable sharedInstance].intdwlsh,[ztOAGlobalVariable sharedInstance].intrylsh,[baseInfoDic objectForKey:@"intgwlsh"],[baseInfoDic objectForKey:@"intgwlzlsh"],[ztOAGlobalVariable sharedInstance].intrylsh,intnewrylshlst];
                responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [docInfoView reloadData];
            }else if (intact==127)
            {
                
                NSMutableString *tempintbzjllshlst=[[NSMutableString alloc]init];
                  NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (ztOAABModel *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strxm];
                    [tempintnewrylshlst appendFormat:@"%@,",oamodel.intrylsh];
                    [tempintbzjllshlst appendFormat:@"-1,"];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",oamodel.intrylsh,[nextStepDic objectForKey:@"zRdxlx"],[self UnicodeToISO88591:oamodel.strxm]]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                NSString *intbzjllshlst=@"";
              
                
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                    intbzjllshlst=[tempintbzjllshlst substringToIndex:tempintbzjllshlst.length-1];
                    
                }
                xml= [NSString stringWithFormat:@"%@<strzrrxmlst>%@</strzrrxmlst><intbzjllshlst>%@</intbzjllshlst><intzrrlshlst>%@</intzrrlshlst><intnextgzlclsh>%@</intnextgzlclsh><intact>%@</intact><intgzlclsh>%@</intgzlclsh><strczrxm>%@</strczrxm><intgwlzlsh>%@</intgwlzlsh><strlclxbm>%@</strlclxbm><intczrylsh>%@</intczrylsh><islz></islz>",zrobj,content,intbzjllshlst,intnewrylshlst,nextStepDic[@"intnextgzlclsh"],nextStepDic[@"intact"],nextStepDic[@"intgzlclsh"],[ztOAGlobalVariable sharedInstance].username,[baseInfoDic objectForKey:@"intgwlzlsh"],baseInfoDic[@"strlclxbm"]?:@"",[ztOAGlobalVariable sharedInstance].intrylsh];
                responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [docInfoView reloadData];
            }else if (intact==22){
                
                NSMutableString *tempintbzjllshlst=[[NSMutableString alloc]init];
                 NSMutableString *zrobj=[[NSMutableString alloc]init];
                for (ztOAABModel *oamodel  in selectAry) {
                    [tempcontent appendFormat:@"%@,",oamodel.strxm];
                    [tempintnewrylshlst appendFormat:@"%@,",oamodel.intrylsh];
                    [tempintbzjllshlst appendFormat:@"0,"];
                    [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",oamodel.intrylsh,[nextStepDic objectForKey:@"zRdxlx"],oamodel.strxm]];
                }
                NSString *intnewrylshlst=@"";
                NSString *content=@"";
                NSString *intbzjllshlst=@"";
                if (selectAry.count>0) {
                    intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
                    content =[tempcontent substringToIndex:tempcontent.length-1];
                    intbzjllshlst=[tempintbzjllshlst substringToIndex:tempintbzjllshlst.length-1];
                    
                }
                xml= [NSString stringWithFormat:@"%@<intcxlxlst>%@</intcxlxlst><intpkvaluelst>%@</intpkvaluelst><intgwlsh>%@</intgwlsh><intfbfw>0</intfbfw><intgwlzlsh>%@</intgwlzlsh>",zrobj,intbzjllshlst,intnewrylshlst,[baseInfoDic objectForKey:@"intgwlsh"],[baseInfoDic objectForKey:@"intgwlzlsh"]];
                responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
                [docInfoView reloadData];
            }
            
        }];
        [self.navigationController pushViewController:ztoazdcy animated:YES];
    }else
    {
    if (responsibleManArray.count==0) {
        NSString *dwlshlx = [NSString stringWithFormat:@"%@",[nextStepDic objectForKey:@"intclfs"]?:@""];
        NSString *dwlshString;
        if ([dwlshlx isEqualToString:@"1"] || [dwlshlx isEqualToString:@"3"]) {
            dwlshString = [ztOAGlobalVariable sharedInstance].intdwlsh_child;//处室流水号
        }
        else
        {
            dwlshString = [ztOAGlobalVariable sharedInstance].intdwlsh;//单位流水号
        }
        ztOANewDocTableViewController *newDocTableView = [[ztOANewDocTableViewController alloc]
                                                          initWithTitleName:@"下步处理人"
                                                          data:nil
                                                          strcxlx:[nextStepDic objectForKey:@"zRdxlx"]
                                                          multiSelectFlag:i_ZRdxdx withCompanylsh:dwlshString isMail:NO];
        [self.navigationController pushViewController:newDocTableView animated:YES];
    }
    else{
        ztOASimpleInfoListViewController *listVC = [[ztOASimpleInfoListViewController alloc] initWithTitle:@"请选择下步处理人" listArray:responsibleManArray whichType:@"3"];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    }
}
#pragma mark - 简单下步处理人处理
- (void)selectDoneResponsibleMan:(NSNotification *)notify
{
    NSDictionary *notifyDic = (NSDictionary *)[notify userInfo];
    NSString *xml= [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"zrrlsh"]],@"1",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",[notifyDic  objectForKey:@"content"]]]];
    responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",[notifyDic objectForKey:@"content"],@"content",nil];
    [docInfoView reloadData];
}
#pragma mark - 树形下步处理人处理
- (void)selectDoneTreeResponsibleMan:(NSNotification *)notify
{
    responsibleManDic = (NSDictionary *)[notify userInfo];
    NSLog(@"执行一次");
    [docInfoView reloadData];
}
#pragma mark-提交公文流转
- (void)doSave
{
    if (opinionField.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请填写处理意见！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([chargeWayField.text isEqualToString:@"请选择"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择下步任务！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ( isDirecReturn==NO && [responsibleManField.text isEqualToString:@"请选择"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择处理人！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //提交流转数据
    NSString *dic;
    if (opinionSelectedDic==nil) {
        dic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><lccz><czmc>%@</czmc>%@<dx>%@</dx><mrcs>%@</mrcs></lccz></root>",
            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",(nextStepDic==nil?@"":[nextStepDic objectForKey:@"stryjmc"])?:@""]],
               [responsibleManDic objectForKey:@"xml"],
            [self UnicodeToISO88591:@"否"],
            [self UnicodeToISO88591:(nextStepDic==nil?@"":[nextStepDic objectForKey:@"mrcs"])?:@""]];
    }
    else
    {
        dic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><clyj><yjlx>%@</yjlx><yjmc>%@</yjmc><yjnr>%@</yjnr><mrcs>%@</mrcs></clyj><lccz><czmc>%@</czmc>%@<dx>%@</dx><mrcs>%@</mrcs></lccz></root>",
               (opinionSelectedDic==nil?@"":[opinionSelectedDic objectForKey:@"intyjlx"])?:@"",
               [self UnicodeToISO88591:(opinionSelectedDic==nil?@"":[opinionSelectedDic objectForKey:@"stryjmc"])?:@""],
               [self UnicodeToISO88591:(opinionField.text)?:@""],
               [self UnicodeToISO88591:(opinionSelectedDic==nil?@"":[opinionSelectedDic objectForKey:@"mrcs"])?:@""],
               [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",(nextStepDic==nil?@"":[nextStepDic objectForKey:@"stryjmc"])?:@""]],
               [responsibleManDic objectForKey:@"xml"],
               [self UnicodeToISO88591:@"否"],
               [self UnicodeToISO88591:(nextStepDic==nil?@"":[nextStepDic objectForKey:@"mrcs"])?:@""]];
    }
    NSLog(@"dic==%@",[dic JSONString]);
    NSDictionary *lzDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",dic,@"queryTermXML",nil];
    [self showWaitView];
    [ztOAService saveOfficeDocFlowInfo:lzDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *resultInfo = [result objectFromJSONData];
        if ((resultInfo!=nil) && [[[resultInfo objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            AudioServicesPlaySystemSound((unsigned long)1303);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交成功！"];
            [alert addButtonWithTitle:@"确定" handler:^(void){
                postN(@"reflashTable");
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"提交失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark-返回
- (void)doBack
{
    [self back];
}

#pragma mark -textview delegate-
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [docInfoView setContentOffset:CGPointMake(0,0) animated:NO];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (opinionField==textView) {
        //move the main view, so that the keyboard does not hide it.
        if (self.view.frame.origin.y>=0) {
            float leaderHeight_t = 0;
            if (ldpsyjArray.count==0) {
                leaderHeight_t=0;
            }
            else
            {
                leaderHeight_t =leaderOpinionHeight0+leaderOpinionHeight1 +20;
            }
            if (openWebViewTag==YES) {
                if (showWebViewYes ==YES) {
                    if (docBagArray.count<=1) {
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+height_webview+30+leaderHeight_t)) animated:NO];
                    }
                    else
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+((docBagArray.count-1)*44+20)+height_webview+30+leaderHeight_t)) animated:NO];
                }
                else
                {//
                    if (docBagArray.count<=1) {
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+40+leaderHeight_t)) animated:NO];
                    }
                    else
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+((docBagArray.count-1)*44+20)+40+leaderHeight_t)) animated:NO];
                }
            }
            else
            {
                if (docBagArray.count>0) {
                    if (docBagArray.count==1) {
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+44+20+leaderHeight_t)) animated:NO];
                    }
                    else
                        [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+((docBagArray.count-1)*44+20)+44+20+leaderHeight_t)) animated:NO];
                }
                else
                {
                    [docInfoView setContentOffset:CGPointMake(0,(titleHeight+20*3+50+leaderHeight_t)) animated:NO];
                }
                
            }
            
            
            [opinionField becomeFirstResponder];
        }
    }
}

#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //流程表
    if (processInfoList==tableView)
    {
        NSString *cellID = [NSString stringWithFormat:@"processCellIdentifier%d",indexPath.row];
        
        ztOAProcessDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[ztOAProcessDetailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if (indexPath.row<processInfoArray.count)
        {
            NSDictionary *bzdic=processInfoArray[indexPath.row];
            NSLog(@"%@",processInfoArray[indexPath.row]);
            if ([[NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"strfsrxm"]?:@""] isEqualToString:@""] ||[[NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"dtmfssj"]?:@""] isEqualToString:@""] ) {
                //发送人和发送时间其中有一个无数据只显示任务，否则显示：某某 于某时间 送xx任务
                NSString *renwu = [NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"strgzrwmc"]?:@""];
                cell.sendInfoLabel.text = [renwu isEqualToString:@""]?@"暂无任务":renwu;
            }
            else
            {
                cell.sendInfoLabel.text = [NSString stringWithFormat:@"%@  于%@  送%@",
                                           [NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"strfsrxm"]?:@""],
                                           [ztOASmartTime timeFromStr:[NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"dtmfssj"]?:@""]],
                                           [NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"strgzrwmc"]?:@""]];
            }//不显示
            NSString *dealInfoSting = @"";
            if ([[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"strczrxm"]!=NULL && ![[[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"strczrxm"] isEqualToString:@""]) {
                dealInfoSting = [dealInfoSting stringByAppendingString:[NSString stringWithFormat:@"%@",[[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"strczrxm"]]];
            }
            if ([[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"strgzrwmc"]!=NULL && ![[[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"strgzrwmc"] isEqualToString:@""]) {
                dealInfoSting = [dealInfoSting stringByAppendingString:@"  "];
                dealInfoSting = [dealInfoSting stringByAppendingString:[NSString stringWithFormat:@"%@",[[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"strgzrwmc"]]];
            }
            else
            {
                dealInfoSting = [dealInfoSting stringByAppendingString:@"  "];
                dealInfoSting = [dealInfoSting stringByAppendingString:@"暂无任务"];
            }
            
            //操作信息：操作人  操作时间   操作任务
            cell.dealInfoLabel.text =dealInfoSting;
            if ([[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"dtmfssj"]!=NULL && ![[[processInfoArray objectAtIndex:indexPath.row] objectForKey:@"dtmfssj"] isEqualToString:@""]) {
                cell.sendTimeLabel.text =[ztOASmartTime timeFromStr:[NSString stringWithFormat:@"%@",[[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"dtmfssj"]]];
            }
            //处理意见
            cell.opinionLabel.text =[[NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"stryjnr"]] isEqualToString:@""]?@"暂无意见":[NSString stringWithFormat:@"%@", [[processInfoArray objectAtIndex:indexPath.row]objectForKey:@"stryjnr"]];
            
            //计算意见高度
            CGSize maximumLabelSizeContext = CGSizeMake(cell.width-40-10,MAXFLOAT);
            CGSize expectedLabelSizeContext= [cell.opinionLabel.text sizeWithFont:[UIFont systemFontOfSize:12]
                                                                constrainedToSize:maximumLabelSizeContext
                                                                    lineBreakMode:NSLineBreakByWordWrapping];
            
            cell.openOrCloseBtn.tag = indexPath.row +1000;
            [cell.openOrCloseBtn addTarget:self action:@selector(btnTouchUp:) forControlEvents:UIControlEventTouchUpInside];
            cell.zrzlb.text=[NSString stringWithFormat:@"%@ %@ %@ ",bzdic[@"strzrrzw"],bzdic[@"strzrrmc"],[ztOASmartTime timeFromStr:bzdic[@"dtmbjsj"]]];
            [cell setSize:CGSizeMake(cell.width, 118)];
            if(expectedLabelSizeContext.height>15)
            {
                [cell.openOrCloseBtn setHidden:NO];
                if ([(NSString *)[isExpandArray objectAtIndex:indexPath.row] isEqualToString:@"2"]) {
                    [cell.opinionLabel setFrame:CGRectMake(20+10, cell.dealInfoLabel.bottom+10, cell.width-40-10, 20)];
                    cell.zrzlb.top=cell.opinionLabel.bottom+10;
                    [cell.openOrCloseBtn setOrigin:CGPointMake(20, cell.zrzlb.bottom)];
                    [cell.blueLineImg setSize:CGSizeMake(1, cell.openOrCloseBtn.bottom)];
                    [cell.breakLine setOrigin:CGPointMake(20, cell.openOrCloseBtn.bottom-1)];
                    //收起
                    [cell setSize:CGSizeMake(cell.width, cell.openOrCloseBtn.bottom)];
                }
                else
                {//展开
                    cell.opinionLabel.numberOfLines = 0;
                    cell.opinionLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    [cell.opinionLabel sizeToFit];
                    cell.opinionLabel.height=expectedLabelSizeContext.height;
                    cell.zrzlb.top=cell.opinionLabel.bottom+10;
                    [cell.openOrCloseBtn setOrigin:CGPointMake(20, cell.zrzlb.bottom)];
                    [cell setSize:CGSizeMake(cell.width, cell.openOrCloseBtn.bottom)];
                    [cell.blueLineImg setSize:CGSizeMake(1, cell.openOrCloseBtn.bottom)];
                    [cell.breakLine setOrigin:CGPointMake(20, cell.openOrCloseBtn.bottom-1)];
                   
                }
            }
            else
            {
                [cell.openOrCloseBtn setHidden:YES];
                [cell.opinionLabel setFrame:CGRectMake(20+10, cell.dealInfoLabel.bottom+10, cell.width-40-10, 20)];
                cell.zrzlb.top=cell.opinionLabel.bottom;
                [cell.openOrCloseBtn setOrigin:CGPointMake(20, cell.zrzlb.bottom)];
                [cell.blueLineImg setSize:CGSizeMake(1, cell.zrzlb.bottom)];
                [cell.breakLine setOrigin:CGPointMake(20, cell.zrzlb.bottom-1)];
                //收起
                [cell setSize:CGSizeMake(cell.width, cell.zrzlb.bottom)];
            }
            
            return cell;
        }
    }
    //文件信息表
    else if (docInfoView == tableView)
    {
        static NSString *cellId = @"baseInfo";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row==0)
        {
            NSString *titleLable = docTitleStr?:@"";
            NSString *iconImgNameStr;
            NSString *warnString=@"";
            NSString *zihaoLable=@"";
            NSString *companyLab=@"";
            NSString *djrlb=@"";
            NSString *labStr;
            NSString *timeLab;
            warnString=[NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"sgcsts"]?:@""];
            if ([type isEqualToString:@"1"]) {
                //发文
                zihaoLable=[NSString stringWithFormat:@"公文字号：%@",docTextNumStr?:@""];
                labStr = @"拟  稿  人：";
                timeLab= [NSString stringWithFormat:@"拟稿日期：%@",[ztOASmartTime dateFromStr:[baseInfoDic objectForKey:@"dtmfssj"]?:@""]];
                companyLab= [NSString stringWithFormat:@"%@%@  %@",labStr,companyNameStr?:@"",[NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"chrfsrxm"]?:@""]];//部门名称  拟稿人
            }else  {
                //收文
                zihaoLable=[NSString stringWithFormat:@"来文字号：%@",docTextNumStr?:@""];
                labStr = @"来文单位：";
                timeLab= [NSString stringWithFormat:@"来文日期：%@",[ztOASmartTime dateFromStr:[baseInfoDic objectForKey:@"dtmfssj"]?:@""]];
                if (djrStr.length>0) {
                    djrlb =[NSString stringWithFormat:@"登记人：%@",djrStr?:@""];
                }
                companyLab= [NSString stringWithFormat:@"%@%@",labStr,companyNameStr?:@""];//部门名称
            }
            NSString *stateLab = [NSString stringWithFormat:@"缓急程度：%@",[[[detailInfoDic objectForKey:@"gw"] objectForKey:@"gwgs"]objectForKey:@"strbzhjcd"]?:@""];
            //NSString *secretHighLab =[NSString stringWithFormat:@"密     级：%@",[baseInfoDic objectForKey:@"chrmj"]?:@""];
            
            ztOADocDealInfoTitleView *titleView = [[ztOADocDealInfoTitleView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, titleHeight+20*3+50) withHeight:titleHeight withTitleStr:titleLable withWarnStr:warnString withWarnImage:iconImgNameStr infoArray:[NSMutableArray arrayWithObjects:zihaoLable,companyLab,timeLab,stateLab,djrlb,nil]];
            if (isSearchFlag==YES) {
                //查询不显示
                [titleView.warnLable setHidden:YES];
                [titleView.warnLedImg setHidden:YES];
            }
            [cell addSubview:titleView];
            cell.height=titleView.bottom+5;
        }
        else if (indexPath.row==1)
        {
            if (1==2) {
                //正文(webview加载)
                UIButton *closeOrOpenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                closeOrOpenBtn.backgroundColor = [UIColor clearColor];
                closeOrOpenBtn.frame = CGRectMake(0, 0, 80, 30);
                [closeOrOpenBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [closeOrOpenBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
                [closeOrOpenBtn setBackgroundImage:[UIImage imageNamed:@"whiteBtn120_60"] forState:UIControlStateNormal];
                [closeOrOpenBtn addTarget:self action:@selector(openOrCloseAction) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:closeOrOpenBtn];
                
                
                if (showWebViewYes ==YES)
                {
                    [closeOrOpenBtn setTitle:@"隐藏正文" forState:UIControlStateNormal];
                    [cell addSubview:docWebView];
                }
                else
                {
                    [closeOrOpenBtn setTitle:@"显示正文" forState:UIControlStateNormal];
                    
                }
            }
            else
            {
                if (docBagArray.count>0) {
                    NSMutableArray *fjArray = [[NSMutableArray alloc] init];
                    [fjArray addObject:[docBagArray firstObject]];
                    //正文文稿
                    NSMutableDictionary *gwfjxx = [[NSMutableDictionary alloc] init];
                    [gwfjxx setValue:[baseInfoDic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];
                    [gwfjxx setValue:[baseInfoDic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
                    [gwfjxx setValue:[ztOAGlobalVariable sharedInstance].intrylsh forKey:@"intrylsh"];
                    [gwfjxx setValue:[ztOAGlobalVariable sharedInstance].username forKey:@"strryxm"];
                    
                    ZMOFjView *fjView ;
                    fjView.delegate = self;
                    [fjView.fjTableView setScrollEnabled:NO];
                    fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, 0, tableView.width-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet" andMethod:@"getGwfj" andClass:@"document" andFjlshKey:@"intfjlsh" typeShow:@"1" andFjlshKeyStr:@"intfjlsh"];
                    
                    fjView.viewController = self;
                    
                    [cell addSubview:fjView];
                }
            }
            
        }
        else if (indexPath.row==2)
        {
            if (docBagArray.count>1) {
                NSMutableArray *fjArray = [[NSMutableArray alloc] init];
                for (int i=1; i<docBagArray.count; i++) {
                    [fjArray addObject:[docBagArray objectAtIndex:i]];
                }
                //附件
                NSMutableDictionary *gwfjxx = [[NSMutableDictionary alloc] init];
                [gwfjxx setValue:[baseInfoDic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];
                [gwfjxx setValue:[baseInfoDic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
                [gwfjxx setValue:[ztOAGlobalVariable sharedInstance].intrylsh forKey:@"intrylsh"];
                [gwfjxx setValue:[ztOAGlobalVariable sharedInstance].username forKey:@"strryxm"];
                
                ZMOFjView *fjView ;
                fjView.delegate = self;
                [fjView.fjTableView setScrollEnabled:NO];
                fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, 0, tableView.width-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet" andMethod:@"getGwfj" andClass:@"document" andFjlshKey:@"intfjlsh" typeShow:@"2" andFjlshKeyStr:@"intfjlsh"];
                
                fjView.viewController = self;
                
                [cell addSubview:fjView];
            }
            
        }
        else if (indexPath.row==3)
        {
            if (ldpsyjArray.count>0) {
                //领导意见(显示1～2条)
                UILabel *leaderOpinionLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
                leaderOpinionLable.text = @"领导批示:";
                leaderOpinionLable.backgroundColor= [UIColor clearColor];
                leaderOpinionLable.textColor = [UIColor blackColor];
                leaderOpinionLable.textAlignment = NSTextAlignmentLeft;
                leaderOpinionLable.font = [UIFont systemFontOfSize:15.0f];
                [cell addSubview:leaderOpinionLable];
                
                NSDictionary *opinionDicIndex0 = [ldpsyjArray objectAtIndex:0];
                ztOALeaderOpinionsView *leaderOpinionView = [[ztOALeaderOpinionsView alloc] initWithFrame:CGRectMake(20, 20, tableView.width-30, leaderOpinionHeight0)];
                leaderOpinionView.leaderNameLable.text = [NSString stringWithFormat:@"%@  %@",[opinionDicIndex0 objectForKey:@"ldxm"],[ztOASmartTime dateFromStr:[NSString stringWithFormat:@"%@",[opinionDicIndex0 objectForKey:@"clsj"]]]];
                leaderOpinionView.leaderOpinionLabel.text =[NSString stringWithFormat:@"%@",[opinionDicIndex0 objectForKey:@"ldpsyjnr"]];
                leaderOpinionView.leaderOpinionLabel.numberOfLines = 0;
                leaderOpinionView.leaderOpinionLabel.lineBreakMode = NSLineBreakByCharWrapping;
                [leaderOpinionView.leaderOpinionLabel sizeToFit];
                [leaderOpinionView.leaderNameLable setOrigin:CGPointMake(10, leaderOpinionView.leaderOpinionLabel.bottom)];
                
                [cell setSize:CGSizeMake(cell.width, leaderOpinionHeight0+20)];
                [cell addSubview:leaderOpinionView];
                
                if (ldpsyjArray.count>1) {
                    NSDictionary *opinionDicIndex1 = [ldpsyjArray objectAtIndex:1];
                    ztOALeaderOpinionsView *leaderOpinionView1 = [[ztOALeaderOpinionsView alloc] initWithFrame:CGRectMake(20, leaderOpinionHeight0+20, tableView.width-30, leaderOpinionHeight1)];
                    leaderOpinionView1.leaderNameLable.text = [NSString stringWithFormat:@"%@  %@",[opinionDicIndex1 objectForKey:@"ldxm"],[ztOASmartTime dateFromStr:[NSString stringWithFormat:@"%@",[opinionDicIndex1 objectForKey:@"clsj"]]]];
                    leaderOpinionView1.leaderOpinionLabel.text =[NSString stringWithFormat:@"%@",[opinionDicIndex1 objectForKey:@"ldpsyjnr"]];
                    leaderOpinionView1.leaderOpinionLabel.numberOfLines = 0;
                    leaderOpinionView1.leaderOpinionLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    [leaderOpinionView1.leaderOpinionLabel sizeToFit];
                    [leaderOpinionView1.leaderNameLable setOrigin:CGPointMake(10, leaderOpinionView1.leaderOpinionLabel.bottom)];
                    
                    [cell setSize:CGSizeMake(cell.width, leaderOpinionHeight1+leaderOpinionHeight0+20)];
                    [cell addSubview:leaderOpinionView1];
                }
            }
            
        }
        else if (indexPath.row==4)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
            label.text =@"处理意见:";
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:15.0f];
            [cell addSubview:label];
            
            UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, tableView.width-40, 50)];
            [backImg setBackgroundColor:[UIColor clearColor]];
            [backImg.layer setBorderWidth:1];
            [backImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
            [backImg setUserInteractionEnabled:YES];
            [cell addSubview:backImg];
            
            //处理意见输入框
            if (self.opinionField==nil) {
                self.opinionField = [[UITextView alloc] initWithFrame:CGRectMake(2, 5, backImg.width-40-4, 40)];
                opinionField.delegate = self;
                opinionField.returnKeyType = UIReturnKeyDone;
                [opinionField setFont:[UIFont systemFontOfSize:12.0f]];
                [opinionField setKeyboardType:UIKeyboardTypeDefault];
                opinionField.backgroundColor = [UIColor clearColor];
                //opinionSelectedDic
                if ([opinionNameStr isEqualToString:@""]) {
                    [opinionField setText:@""];
                }
                else
                {
                    [opinionField setText:[NSString stringWithFormat:@"%@",opinionNameStr]];
                }
            }
            UIButton *upAndDownIcon = [[UIButton alloc] initWithFrame:CGRectMake(opinionField.right+2, 1, 40, 28+20)];
            [upAndDownIcon setImage:[UIImage imageNamed:@"upAndDown_big_btn"] forState:UIControlStateNormal];
            [upAndDownIcon addTarget:self action:@selector(selectOpinion) forControlEvents:UIControlEventTouchUpInside];
            [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
            
            [backImg addSubview:opinionField];
            //[backImg addSubview:opinionbtn];
            [backImg addSubview:upAndDownIcon];
        }
        else if (indexPath.row==5)
        {
            //下步任务
            if (nextStepListArray.count!=1)
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                label.text =@"下步任务:";
                label.textAlignment = NSTextAlignmentLeft;
                label.textColor = [UIColor blackColor];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:15.0f];
                [cell addSubview:label];
                
                UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, tableView.width-40, 30)];
                [backImg setBackgroundColor:[UIColor clearColor]];
                [backImg.layer setBorderWidth:1];
                [backImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
                [backImg setUserInteractionEnabled:YES];
                [cell addSubview:backImg];
                
                if (self.chargeWayField) {
                    self.chargeWayField = nil;
                }
                self.chargeWayField = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, backImg.width-40-10, 20)];
                [chargeWayField setFont:[UIFont systemFontOfSize:14.0f]];
                [chargeWayField setUserInteractionEnabled:YES];
                chargeWayField.backgroundColor = [UIColor clearColor];
                //设置下步任务显示
                if (nextStepDic==nil) {
                    [chargeWayField setText:@"请选择"];
                }
                else
                {
                    [chargeWayField setText:[NSString stringWithFormat:@"%@",[nextStepDic objectForKey:@"stryjmc"] ]];
                }
                
                [chargeWayField setTextAlignment:NSTextAlignmentLeft];
                [backImg addSubview:chargeWayField];
                //只有一条数据默认显示且不让操作
                if (nextStepListArray.count!=1) {
                    UIButton *upAndDownIcon = [[UIButton alloc] initWithFrame:CGRectMake(chargeWayField.right+5, 1, 40, 28)];
                    [upAndDownIcon setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn.png"] forState:UIControlStateNormal];
                    [upAndDownIcon addTarget:self action:@selector(selectChargeWay) forControlEvents:UIControlEventTouchUpInside];
                    [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
                    [backImg addSubview:upAndDownIcon];
                    
                    UITapGestureRecognizer *tapGestureUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectChargeWay)];
                    tapGestureUp.numberOfTapsRequired = 1;
                    [chargeWayField addGestureRecognizer:tapGestureUp];
                }
            }
            
        }
        else if (indexPath.row==6)
        {
            if (closeFlag==NO) {
                //下步处理人
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
                label.text =@"下步处理人:";
                label.textAlignment = NSTextAlignmentLeft;
                label.textColor = [UIColor blackColor];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:15.0f];
                [cell addSubview:label];
                
                UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, tableView.width-40, 30)];
                [backImg setBackgroundColor:[UIColor clearColor]];
                [backImg.layer setBorderWidth:1];
                [backImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
                [backImg setUserInteractionEnabled:YES];
                [cell addSubview:backImg];
                
                if (self.responsibleManField) {
                    self.responsibleManField = nil;
                }
                self.responsibleManField = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, backImg.width-40-10, 20)];
                [responsibleManField setFont:[UIFont systemFontOfSize:14.0f]];
                [responsibleManField setUserInteractionEnabled:YES];
                responsibleManField.backgroundColor = [UIColor clearColor];
                //设置责任人姓名
                if (responsibleManDic==nil) {
                    [responsibleManField setText:@"请选择"];
                }
                else
                {
                    [responsibleManField setText:[NSString stringWithFormat:@"%@",[responsibleManDic objectForKey:@"content"] ]];
                }
                [responsibleManField setTextAlignment:NSTextAlignmentLeft];;
                
                UIButton *upAndDownIcon = [[UIButton alloc] initWithFrame:CGRectMake(responsibleManField.right+5, 1, 40, 28)];
                [upAndDownIcon setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn.png"] forState:UIControlStateNormal];
                [upAndDownIcon addTarget:self action:@selector(selectResponsibleMan) forControlEvents:UIControlEventTouchUpInside];
                [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
                
                [backImg addSubview:responsibleManField];
                [backImg addSubview:upAndDownIcon];
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectResponsibleMan)];
                tapGesture.numberOfTapsRequired = 1;
                [responsibleManField addGestureRecognizer:tapGesture];
            }
            else
            {
                //直接返回
                [self.responsibleManField removeFromSuperview];
                self.responsibleManField = nil;
            }
        }
        return cell;
    }
    else if (tableView == alertViewListTable)
    {
        static NSString *cellId = @"infocell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, cell.width, cell.height-10)];
        lab.backgroundColor = [UIColor clearColor];
        [lab setTextColor:[UIColor blackColor]];
        //type:1:处理意见;2,下步任务；3，下步处理人；
        if ([i_type isEqualToString:@"1"])
        {
            lab.text = [NSString stringWithFormat:@"%@",[dataInfoArray objectAtIndex:indexPath.row] ];
        }
        else if ([i_type isEqualToString:@"2"]) {
            lab.text = [NSString stringWithFormat:@"%@",[[dataInfoArray objectAtIndex:indexPath.row] objectForKey:@"stryjmc"]];
        }
        else if ([i_type isEqualToString:@"3"])
        {
            lab.text = [NSString stringWithFormat:@"%@",[[dataInfoArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
        }
        lab.textAlignment = NSTextAlignmentLeft;
        lab.font = [UIFont boldSystemFontOfSize:14.0f];
        [cell addSubview:lab];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.height-1, cell.width,1)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (docInfoView == tableView) {
        if (indexPath.row==0) {
           UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.height;
        }
        else if (indexPath.row==1)
        {
            if (openWebViewTag==YES) {
                if (showWebViewYes==YES) {
                    return height_webview+30;
                }
                else
                {
                    return 40;
                }
            }
            else
            {
                if (docBagArray.count<1) {
                    return 0;
                }
                else     return 44+20;
            }
            
        }
        else if (indexPath.row == 2)
        {
            if (docBagArray.count<=1) {
                return 0;
            }
            else     return ((docBagArray.count-1)*44+20);
        }
        else if (indexPath.row == 3)
        {
            if (ldpsyjArray.count==0) {
                return 0;
            }
            else
            {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }
        }
        else if (indexPath.row == 5)
        {
            if (nextStepListArray.count!=1)
            {
                return 80;
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 80;
        }
    }
    else if (processInfoList == tableView)
    {
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else  return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (processInfoList==tableView)
    {
        return processInfoArray.count;
    }
    else if (docInfoView == tableView)
    {
        if (isSearchFlag == YES || canSave==NO) {
            return 4;
        }
        else   {
            if (isDirecReturn==YES) {
                return 6;
            }
            else   return 7;
        }
    }
    else if (alertViewListTable == tableView)
    {
        return dataInfoArray.count;
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (processInfoList==tableView)
    {
    }
    if (alertViewListTable == tableView) {
        if ([i_type isEqualToString:@"1"])
        {
            //postNWithInfos(@"OPINIONSELECT", nil, [dataInfoArray objectAtIndex:indexPath.row]);
            [self selectDoneOpinion:[dataInfoArray objectAtIndex:indexPath.row]];
        }
        else if ([i_type isEqualToString:@"2"]) {
            //postNWithInfos(@"NEXTSTEPWAY", nil, [dataInfoArray objectAtIndex:indexPath.row]);
            [self selectNextStepWay:[dataInfoArray objectAtIndex:indexPath.row]];
        }
        else if ([i_type isEqualToString:@"3"])
        {
            //postNWithInfos(@"RESPONSIBLEMAN", nil, [dataInfoArray objectAtIndex:indexPath.row]);
            [self selectDoneResponsibleMan:[dataInfoArray objectAtIndex:indexPath.row]];
        }
        
        //[self.cxAlertView dismiss];
        [alertViewBack removeFromSuperview];
    }
}
#pragma mark-ZMOFjDelegate
-(void)FileUploadOver:(id)result
{
    NSDictionary *dic = [result objectFromJSONData];
    NSString *msg;
    if ([[dic objectForKey:@"root"] objectForKey:@"result"]) {
        msg = @"上传成功！";
    }
    else
    {
        msg = @"上传失败！";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)transferredupdata:(NSString *)content
{
    opinionField.text=content;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[opinionField resignFirstResponder];
    opinionNameStr = opinionField.text?:@"";
    if ([InfoMessageBtn isSelected]) {
        if (docInfoView.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
    else if ([processMonitorBtn isSelected])
    {
        if (processInfoList.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (mainScrollView==scrollView) {
        if (mainScrollView.contentOffset.x>0) {
            [InfoMessageBtn setSelected:NO];
            [processMonitorBtn setSelected:YES];
        }
        else
        {
            [processMonitorBtn setSelected:NO];
            [InfoMessageBtn setSelected:YES];
        }
        
    }
}
#pragma mark - 正文稿-
-(void)getFileData:(NSString *)intfjlsh fjName:(NSString *)fjName aFjType:(NSString *)aFjType
{
    NSString *tempDirectory  = NSTemporaryDirectory();
    NSFileManager *fileManage = [NSFileManager defaultManager];
    zhengwenFJName = fjName;
    zhengwenFJLsh = intfjlsh;
    if (![zhengwenFJName isEqual:[NSNull null]]) {
        //保存在本地的文件命名格式为：文件名_流水号.后缀
        NSRange range = [zhengwenFJName rangeOfString:@"."];
        NSString *tempFjmc = [zhengwenFJName substringToIndex:range.location];
        NSString *extfilename=[zhengwenFJName substringFromIndex:range.location];//得到文件扩展名
        zhengwenFJName = [NSString stringWithFormat:@"%@_%@%@", tempFjmc, zhengwenFJLsh, extfilename];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", tempDirectory, zhengwenFJName];
        zhengwenPath = filePath;
        //查看正文稿时每次都需要下载，避免正文稿内容更改后本地取不到最新数据
        if (!([aFjType isEqualToString:@"正文稿"] || [aFjType isEqualToString:@"正式正文稿"]) && [fileManage fileExistsAtPath:filePath isDirectory:NO]) {
            return;
        }
        [UIViewHelp showProgressDialog:@"正在下载附件，请稍后"];
        [ztOAHttpRequest sendUrl:[NSString stringWithFormat:@"http://%@:%@%@", [ztOAGlobalVariable sharedInstance].serviceIp, [ztOAGlobalVariable sharedInstance].servicePort, @"/ZTMobileGateway/oaAjaxServlet"] sendParams:[NSDictionary dictionaryWithObjectsAndKeys:intfjlsh,@"intfjlsh", nil] sendClass:@"document" sendMethod:@"getGwfj" sendHasParams:@"yes" completionBlock:^(id result) {
            [UIViewHelp dismissProgressDialog];
            //NSLog(@"**%@",result);
            NSString *content = [[[[result objectFromJSONString] objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"content"];
            NSData *filecontent = [GTMBase64 decodeString:content];
            //如果附件格式为文本文档，保存时需要进行两次转码，避免中文乱码现象
            if ([extfilename isEqualToString:@".txt"]) {
                NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                NSString *tempStr = [[NSString alloc] initWithData:filecontent encoding:firstEncoding];
                NSStringEncoding finalEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16);
                NSData *data = [tempStr dataUsingEncoding:finalEncoding];
                
                
                
                NSString *dataStr = [[NSString alloc] initWithData:data encoding:finalEncoding];
                [dataStr writeToFile:zhengwenPath atomically:YES encoding:finalEncoding error:nil];
            } else{
                
                BOOL err =[filecontent writeToFile:zhengwenPath atomically:YES];
                NSLog(@"%hhd",err);
            }
            
            
            if([fileManage fileExistsAtPath:zhengwenPath]){
                if (self.docWebView!=nil) {
                    docWebView=nil;
                }
                self.docWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 29 ,self.view.width-20, height_webview)];
                self.docWebView.delegate = self;
                docWebView.backgroundColor = [UIColor clearColor];
                [docWebView setScalesPageToFit:YES];
                showWebViewYes = YES;
                NSURL *url=[NSURL fileURLWithPath:zhengwenPath];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                // 服务器的响应对象,服务器接收到请求返回给客户端的
                NSURLResponse *respnose = nil;
                filedata = [NSURLConnection sendSynchronousRequest:request returningResponse:&respnose error:NULL];
                NSLog(@"%@", respnose.MIMEType);
                mimeType=respnose.MIMEType;
                [docWebView loadData:filedata MIMEType:mimeType textEncodingName:@"UTF8" baseURL:url];
            }
            [docInfoView reloadData];
        } andFailedBlock:^(NSError *error) {
            [UIViewHelp dismissProgressDialog];
            [UIViewHelp alertTitle:@"温馨提示" alertMessage:@"网络异常，请稍后再试"];
        }];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    height_webview = webView.height;
    [webView.scrollView setScrollEnabled:NO];
    [docInfoView reloadData];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"此文档格式错误打不开请到电脑端查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertview show];
}
- (void)openOrCloseAction
{
    showWebViewYes = !showWebViewYes;
    [docInfoView reloadData];
}
-(void)btnTouchUp:(id)sender
{
    UIButton *tempBtn = (UIButton *)sender;
    int iTag = tempBtn.tag - 1000;
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:iTag inSection:0];
    
    if ([(NSString *)[isExpandArray objectAtIndex:iTag] isEqualToString:@"2"]) {
        [isExpandArray replaceObjectAtIndex:iTag withObject:@"1"];
        [processInfoList reloadRowsAtIndexPaths:[NSArray arrayWithObject:scrollIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [isExpandArray replaceObjectAtIndex:iTag withObject:@"2"];
        [processInfoList reloadRowsAtIndexPaths:[NSArray arrayWithObject:scrollIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [processInfoList scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
#pragma mark - pdf-
//pdf转换
- (void)changeToPDFFile
{
    [self showWaitViewWithTitle:@"文件处理中，请稍后..."];
    //非pdf文件，先转换
    self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:[NSURL fileURLWithPath:zhengwenPath] pathForPDF:[self UrlFromPathOfDocuments:@"/blocksDemo.pdf"]  pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF)
                       {
                           NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath];
                           NSLog(@"%@",result);
                           [self closeWaitView];
                           
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"文件转换成功,可以安心打开了！"];
                           [alert addButtonWithTitle:@"打开" handler:^{
                               NSString *phrase = nil;
                               ReaderDocument *document = [ReaderDocument withDocumentFilePath:[@"~/Documents/blocksDemo.pdf" stringByExpandingTildeInPath] password:phrase];
                               if (document != nil) // Must have a valid ReaderDocument object in order to proceed
                               {
                                   ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
                                   
                                   readerViewController.delegate = self; // Set the ReaderViewController delegate to self
                                   
                                   [self.navigationController pushViewController:readerViewController animated:YES];
                               }
                               else
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                   [alert show];
                               }
                               
                           }];
                           [alert addButtonWithTitle:@"取消" handler:^{}];
                           [alert show];
                           
                       } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
                           NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
                           NSLog(@"%@",result);
                           [self closeWaitView];
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"转换失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                           [alert show];
                       }];
}

#pragma mark ReaderViewControllerDelegate methods
- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要提交文件？"];
    [alert addButtonWithTitle:@"是的" handler:^(void){
        //pdf文件上传
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [alert addButtonWithTitle:@"取消" handler:^(void){
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    [alert show];
}
//收藏操作
- (void)collectDocAction
{
    NSString *messageStr = @"";
    if ([conerightBtn isSelected]) {
        messageStr = @"是否要取消收藏？";
    }
    else
    {
        messageStr = @"是否要收藏？";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:messageStr];
    [alert addButtonWithTitle:@"是的" handler:^(void){
        //本地数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSMutableArray *allCollectInfoArray = [[NSMutableArray alloc] init];
        if ([userDefaults objectForKey:@"localDocCollectArray"]!=nil) {
            [allCollectInfoArray addObjectsFromArray:[userDefaults objectForKey:@"localDocCollectArray"]];
        }
        //收藏
        if (![conerightBtn isSelected]) {
            [allCollectInfoArray addObject:baseInfoDic];
            
        }
        //取消收藏
        else
        {
            for (int i = 0; i<allCollectInfoArray.count; i++) {
                NSDictionary *oneCollectDic = [allCollectInfoArray objectAtIndex:i];
                if ([[NSString stringWithFormat:@"%@",[oneCollectDic objectForKey:@"intgwlzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"intgwlzlsh"]]]) {
                    [allCollectInfoArray removeObject:oneCollectDic];
                    break;
                }
            }
        }
        [userDefaults setObject:allCollectInfoArray forKey:@"localDocCollectArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        conerightBtn.selected = !conerightBtn.selected;
    }];
    [alert addButtonWithTitle:@"取消" handler:^(void){
        
    }];
    [alert show];
}
//监测本地是否已收藏
- (void)searchLocalCollect
{
    //本地数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allCollectInfoArray = [[NSMutableArray alloc] init];
    if ([userDefaults objectForKey:@"localDocCollectArray"]!=nil) {
        [allCollectInfoArray addObjectsFromArray:[userDefaults objectForKey:@"localDocCollectArray"]];
    }
    [conerightBtn setSelected:NO];
    for (int i = 0; i<allCollectInfoArray.count; i++) {
        NSDictionary *oneCollectDic = [allCollectInfoArray objectAtIndex:i];
        
        if ([[NSString stringWithFormat:@"%@",[oneCollectDic objectForKey:@"intgwlzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"intgwlzlsh"]]]) {
            [conerightBtn setSelected:YES];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}
@end
