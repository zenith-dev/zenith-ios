//
//  ztOASendEmailViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-24.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASendEmailViewController.h"
#import "ztOASendEmailView.h"
@interface ztOASendEmailViewController ()
{
    NSString        *titleName;//邮件标题：回复、转发、写邮件
    NSDictionary    *baseInfoDic;//基本信息
    NSMutableArray  *SendToPepolesInfoArray;
    NSMutableArray  *i_FjArray;//附件数组
    float           kOFFSET_KEYBOARD;//键盘高度
    NSString        *i_intjslshlst;//接收人流水号串
    NSString        *i_strxmlst;//接收人名称串
    NSString        *i_strbzlst;//接收人类型标志串
    NSString        *i_sessionId;//sessionID
    UIImage         *currentImage;
    
    NSMutableArray         *seletedFlagArray;//人员弹出层选择标志位数组
}
@property(nonatomic,strong)ztOASendEmailView            *sendEmailView;
@property(nonatomic,strong)ztOASendEmailFjDetailView    *fjTableView;
@property(nonatomic,strong)UITableView                  *pepoleListView;
@property (nonatomic,strong)UIView                      *popView;//弹出框
//附件显示按钮
@property(nonatomic,strong)UIButton                     *fjClickBtn;
@property(nonatomic,strong)UILabel                      *fjLabelCount;
@property(nonatomic,strong)UIImageView                  *fjLogoImg;
@property(nonatomic,strong)CXAlertView                  *cxAlertShowView;
@property(nonatomic,strong)UIView                       *cxAlertContentView;
@property(nonatomic,strong)UIButton                     *cxAlertSaveBtn;
@property(nonatomic,strong)UIImageView                  *cxAlertImageView;
@end

@implementation ztOASendEmailViewController
@synthesize sendEmailView;
@synthesize fjTableView,pepoleListView,popView;
@synthesize fjClickBtn,fjLogoImg,fjLabelCount;
@synthesize cxAlertShowView,cxAlertContentView,cxAlertImageView,cxAlertSaveBtn;
- (id)initWithTitle:(NSString *)titleStr withDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if (!i_FjArray) {
            i_FjArray = [[NSMutableArray alloc] init];
            SendToPepolesInfoArray = [[NSMutableArray alloc] init];
            seletedFlagArray = [[NSMutableArray alloc] init];
            i_intjslshlst = @"";
            i_strbzlst = @"";
            i_strxmlst = @"";
            titleName=titleStr;
            self.title = titleStr;
            baseInfoDic = dic;
            i_sessionId = [self getCurrentTimeStr];
            [self clearAttachmentsPool];
        }
    }
    return self;
}
- (void)clearAttachmentsPool
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: i_sessionId,@"moveequipmentid", nil];
    
    [ztOAService deleteEmailAttachments:dic Success:^(id result){
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        if (dataDic!=NULL && [[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
    
    } Failed:^(NSError *error){
        NSLog(@"删除失败");
    }];
}
- (void)deleteAttachmentsByLsh:(NSString *)intfjlsh_t
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: intfjlsh_t,@"intfjlsh", nil];
    
    [ztOAService deleteEmailAttachmentsBylsh:dic Success:^(id result){
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        if (dataDic!=NULL && [[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            NSLog(@"删除成功");
        }
        else
        {
            NSLog(@"删除失败");
        }
        
    } Failed:^(NSError *error){
        NSLog(@"删除失败");
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightButton:@"发 送" Sel:@selector(doSendEmail)];
    
    self.sendEmailView = [[ztOASendEmailView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 220)];
    [sendEmailView setUserInteractionEnabled:YES];
    [self.sendEmailView.pepoleInfoLabel setUserInteractionEnabled:YES];
    [sendEmailView.addPepoleBtn addTarget:self action:@selector(gotoAddPepoleView) forControlEvents:UIControlEventTouchUpInside];
    sendEmailView.titleInfoField.delegate = self;
    sendEmailView.contextInfoView.delegate = self;
    
    if ([titleName isEqualToString:@"转发邮件"]) {
        NSString *receiveStr = @"";
        if([[baseInfoDic objectForKey:@"jsry"] isKindOfClass:[NSDictionary class]])
        {
            receiveStr = [NSString stringWithFormat:@"%@",[[baseInfoDic objectForKey:@"jsry"] objectForKey:@"strxm"]]?:@"";
        }
        else
        {
            NSMutableArray *array = [baseInfoDic objectForKey:@"jsry"];
            for (int i= 0; i<array.count; i++) {
                if (i<array.count-1) {
                    receiveStr = [receiveStr stringByAppendingString:[NSString stringWithFormat:@"%@,",[[array objectAtIndex:i] objectForKey:@"strxm"]]];
                }
                else
                {
                    receiveStr = [receiveStr stringByAppendingString:[[array objectAtIndex:i] objectForKey:@"strxm"]];
                }
                
            }
        }
        NSString *senderStr = [NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"strryxm"]]?:@"?";
        NSString *timeStr = [NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"dtmdjsj"]];
       sendEmailView.titleInfoField.text = [NSString stringWithFormat:@"转发:%@",[baseInfoDic objectForKey:@"strtzbt"]];
        sendEmailView.contextInfoView.text = [NSString stringWithFormat:@"------------------原始邮件------------------\n发件人:%@\n发送时间:%@\n收件人:%@\n------------------------------------------\n%@",senderStr,timeStr,receiveStr,[baseInfoDic objectForKey:@"strzw"]];
        
        if ([baseInfoDic objectForKey:@"fj"]!=NULL) {
            if ( [[baseInfoDic objectForKey:@"fj"] isKindOfClass:[NSDictionary class]]) {
                [i_FjArray addObject:[baseInfoDic objectForKey:@"fj"]];
            }
            else
            {
                i_FjArray = [NSMutableArray arrayWithArray:[baseInfoDic objectForKey:@"fj"]];
            }
        }

        
        if (i_FjArray.count>0) {
            [self forwardEmailAttachments];
        }
    }else if ([titleName isEqualToString:@"回复邮件"]) {
        sendEmailView.titleInfoField.text = [NSString stringWithFormat:@"回复:%@",[baseInfoDic objectForKey:@"strtzbt"]];
        
        //初始化人员数据
         NSDictionary *oneManDic =[[NSDictionary alloc] initWithObjectsAndKeys:[baseInfoDic objectForKey:@"strryxm"],@"name",[baseInfoDic objectForKey:@"intrylsh"],@"lsh",[baseInfoDic objectForKey:@"intfsrlx"],@"chrbz",nil];
        [SendToPepolesInfoArray addObject:oneManDic];
        [seletedFlagArray addObject:@"1"];
        [self sendPersonChange];
    }
    
    [self.view addSubview:sendEmailView];
    
    //附件
    fjClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fjClickBtn setImage:[UIImage imageNamed:@"fjClickBtnImg"] forState:UIControlStateNormal];
    fjClickBtn.backgroundColor = [UIColor clearColor];
    fjClickBtn.frame = CGRectMake(self.view.width-20-50, sendEmailView.bottom-30, 50, 30);
    [self.view addSubview:fjClickBtn];
    
    fjLogoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bag_Icon_Img"]];
    fjLogoImg.frame = CGRectMake(2, 2, 25, 25);
    [fjClickBtn addSubview:fjLogoImg];
    
    fjLabelCount = [[UILabel alloc] initWithFrame:CGRectMake(fjLogoImg.right+1, 5, 21, 20)];
    [fjLabelCount setFont:[UIFont systemFontOfSize:10.0f]];
    fjLabelCount.textAlignment = NSTextAlignmentLeft;
    fjLabelCount.textColor = [UIColor whiteColor];
    fjLabelCount.backgroundColor = [UIColor clearColor];
    fjLabelCount.text = @"0";
    [fjClickBtn addSubview:fjLabelCount];
    
    [self.fjClickBtn addTarget:self action:@selector(gotofjDetailView) forControlEvents:UIControlEventTouchUpInside];
    self.fjLabelCount.text = [NSString stringWithFormat:@"%d",i_FjArray.count];
    
    self.fjTableView = [[ztOASendEmailFjDetailView alloc] initWithFrame:CGRectMake(0, self.view.height,self.view.width, self.view.height-sendEmailView.bottom)];
    fjTableView.fjTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fjTableView];
    fjTableView.backgroundColor = [UIColor clearColor];
    [fjTableView.fjTable setDataSource:self];
    [fjTableView.fjTable setDelegate:self];
    [fjTableView.getPhotosBtn addTarget:self action:@selector(addPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    [fjTableView.getCameraBtn addTarget:self action:@selector(addCameraPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    
    //图片上传提示框（含图片展示）
    self.cxAlertContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.cxAlertContentView setUserInteractionEnabled:YES];
    cxAlertContentView.backgroundColor = [UIColor clearColor];
    
    self.cxAlertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 150, 150)];
    cxAlertImageView.backgroundColor = [UIColor clearColor];
    cxAlertImageView.contentMode =UIViewContentModeScaleAspectFit;
    [cxAlertContentView addSubview:cxAlertImageView];
    
    UIImage *saveBtnImg = [UIImage imageNamed:@"color_04"];
    NSInteger saveBtnWidth = saveBtnImg.size.width * 0.5f;
    NSInteger saveBtnHeight = saveBtnImg.size.height * 0.5f;
    saveBtnImg = [saveBtnImg stretchableImageWithLeftCapWidth:saveBtnWidth topCapHeight:saveBtnHeight];
    self.cxAlertSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cxAlertSaveBtn.frame = CGRectMake(0, 155, 200, 35);
    [cxAlertSaveBtn addTarget:self action:@selector(doSendEmailAttachments:) forControlEvents:UIControlEventTouchUpInside];
    [cxAlertSaveBtn setBackgroundImage:saveBtnImg forState:UIControlStateNormal];
    [cxAlertSaveBtn setTitle:@"上传" forState:UIControlStateNormal ];
    [cxAlertSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cxAlertSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cxAlertContentView addSubview:cxAlertSaveBtn];
    
    self.cxAlertShowView = [[CXAlertView alloc] initWithTitle:@"图片上传" contentView:self.cxAlertContentView cancelButtonTitle:@"取消"];
    cxAlertShowView.frame = CGRectMake((self.view.width-200)/2, (self.view.height-200)/2, 200,200);
    
    //弹出框
    self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [popView setUserInteractionEnabled:YES];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, popView.width, popView.height)];
    [bgImgView setBackgroundColor:[UIColor blackColor]];
    [bgImgView setAlpha:0.5];
    [bgImgView setUserInteractionEnabled:YES];
    [popView addSubview:bgImgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedBtnClickedOn:)];
    tap.delegate = self;
    [self.sendEmailView.pepoleInfoLabel addGestureRecognizer:tap];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(30, 64+10, popView.width - 60, popView.height - 120)];
    [selectedView setBackgroundColor:[UIColor whiteColor]];
    [popView addSubview:selectedView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectedView.width, 40)];
    [titleLabel setBackgroundColor:MF_ColorFromRGB(53, 105, 236)];
    [titleLabel setText:@"已选择的人员："];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [selectedView addSubview:titleLabel];
    
    //已选择人员列表
    __weak UIImage *leftBtnImg = [UIImage imageNamed:@"common_btn_left"];
    __weak UIImage *hlLeftBtnImg = [UIImage imageNamed:@"common_btn_left_hl"];
    __weak UIImage *rightBtnImg = [UIImage imageNamed:@"common_btn_right"];
    __weak UIImage *hlRightBtnImg = [UIImage imageNamed:@"common_btn_right_hl"];
    NSInteger leftCapWidth = leftBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = leftBtnImg.size.height * 0.5f;
    leftBtnImg = [leftBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    hlLeftBtnImg = [hlLeftBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    rightBtnImg = [rightBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    hlRightBtnImg = [hlRightBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    self.pepoleListView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, selectedView.width, selectedView.height - titleLabel.bottom - 40) style:UITableViewStylePlain];
    [pepoleListView setTableFooterView:nil];
    [pepoleListView setBackgroundColor:[UIColor whiteColor]];
    [pepoleListView setDelegate:self];
    [pepoleListView setDataSource:self];
    if (currentSystemVersion >= 7.0) {
        [pepoleListView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 15)];
    }
    [selectedView addSubview:pepoleListView];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setFrame:CGRectMake(0, pepoleListView.bottom, selectedView.width / 2, 40)];
    [okBtn setBackgroundImage:leftBtnImg forState:UIControlStateNormal];
    [okBtn setBackgroundImage:hlLeftBtnImg forState:UIControlStateHighlighted];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectedView addSubview:okBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setFrame:CGRectMake(okBtn.right, okBtn.top, okBtn.width, okBtn.height)];
    [cancelBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:hlRightBtnImg forState:UIControlStateHighlighted];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [selectedView addSubview:cancelBtn];
    
    addN(@selector(selectPepole:), @"TREERESPONCHOOSE");//人员返回
    addN(@selector(getAttachment:), @"EMAILATTACHMENT");//附件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification object:self.view.window];
	
}
//人员信息弹出层按钮事件start....
-(void)selectedBtnClickedOn:(id)sender{
    [pepoleListView reloadData];
    [self.view addSubview:popView];
    [sendEmailView.titleInfoField resignFirstResponder];
    [sendEmailView.contextInfoView resignFirstResponder];
}

-(void)popviewTapHandler{
    [popView removeFromSuperview];
}

- (void)okBtnClicked:(id)sender{
    NSMutableArray *selectArray =[[NSMutableArray alloc] init];
    for (int i=0; i<seletedFlagArray.count; i++) {
        if ([[seletedFlagArray objectAtIndex:i] isEqualToString:@"1"]) {
            [selectArray addObject:[SendToPepolesInfoArray objectAtIndex:i]];
        }
    }
    
    [SendToPepolesInfoArray removeAllObjects];
    [seletedFlagArray removeAllObjects];
    
    SendToPepolesInfoArray = selectArray;
    for (int i = 0; i<SendToPepolesInfoArray.count; i++) {
        [seletedFlagArray addObject:@"1"];
    }
    [self sendPersonChange];
    
    [pepoleListView reloadData];
    [popView removeFromSuperview];
}

- (void)cancelBtnClicked:(id)sender{
    [popView removeFromSuperview];
}
//end

- (void)keyboardShow:(NSNotification *)notif
{
    //获取键盘的高度
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    kOFFSET_KEYBOARD = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        fjClickBtn.frame = CGRectMake(self.view.width-20-50, self.view.height-kOFFSET_KEYBOARD-35, 50, 30);
    }];
}
#pragma mark- 人员选择数据反馈
- (void)selectPepole:(NSNotification *)notify
{
    [SendToPepolesInfoArray removeAllObjects];
    [seletedFlagArray removeAllObjects];
    
    SendToPepolesInfoArray = [[notify userInfo] objectForKey:@"arrayInfo"];
    for (int i=0; i<SendToPepolesInfoArray.count; i++) {
        [seletedFlagArray addObject:@"1"];
    }
    [self sendPersonChange];
}
-(void)sendPersonChange{
    i_strxmlst = @"";
    i_strbzlst = @"";
    i_intjslshlst = @"";
    if (SendToPepolesInfoArray.count==1) {
        i_strxmlst = [NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:0] objectForKey:@"name"]?:@""];
        i_strbzlst = [NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:0] objectForKey:@"chrbz"]];
        i_intjslshlst = [NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:0] objectForKey:@"lsh"]];
    }
    else
    {
        for (int i= 0; i<SendToPepolesInfoArray.count; i++) {
            if (i<SendToPepolesInfoArray.count-1) {
                i_strxmlst = [i_strxmlst stringByAppendingString:[NSString stringWithFormat:@"%@,",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"name"]?:@""]];
                i_strbzlst = [i_strbzlst stringByAppendingString:[NSString stringWithFormat:@"%@,",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"chrbz"]?:@""]];
                i_intjslshlst = [i_intjslshlst stringByAppendingString:[NSString stringWithFormat:@"%@,",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"lsh"]?:@""]];
            }
            else
            {
                i_strxmlst = [i_strxmlst stringByAppendingString:[NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"name"]?:@""]];
                i_strbzlst = [i_strbzlst stringByAppendingString:[NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"chrbz"]?:@""]];
                i_intjslshlst = [i_intjslshlst stringByAppendingString:[NSString stringWithFormat:@"%@",[[SendToPepolesInfoArray objectAtIndex:i] objectForKey:@"lsh"]?:@""]];
            }
        }
    }
    sendEmailView.pepoleInfoLabel.text =i_strxmlst;
}
- (void)gotoAddPepoleView
{
    ztOANewDocTableViewController *newDocVC = [[ztOANewDocTableViewController alloc]
                                               initWithTitleName:@"请选择人员"
                                               data:nil
                                               strcxlx:@"1"
                                               multiSelectFlag:@"2" withCompanylsh:@"" isMail:YES];
    [self.navigationController pushViewController:newDocVC animated:YES];

}
- (void)gotofjDetailView
{
    if (fjTableView.frame.origin.y==self.view.height) {
        //显示
        [UIView animateWithDuration:0.3 animations:^{
            [sendEmailView.titleInfoField resignFirstResponder];
            [sendEmailView.contextInfoView resignFirstResponder];
            fjClickBtn.frame = CGRectMake(self.view.width-20-50, sendEmailView.bottom-30, 50, 30);
            [fjTableView setFrame:CGRectMake(0, sendEmailView.bottom,self.view.width, self.view.height-sendEmailView.bottom)];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [fjTableView setFrame:CGRectMake(0, self.view.height,self.view.width, self.view.height-sendEmailView.bottom)];
            [sendEmailView.titleInfoField becomeFirstResponder];
            
        }];
    }
    
}
#pragma mark- 发送邮件
- (void)doSendEmail
{
    if([sendEmailView.titleInfoField.text length]==0 || [[sendEmailView.titleInfoField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"标题不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    
    }
    if([sendEmailView.pepoleInfoLabel.text length]==0 || [[sendEmailView.pepoleInfoLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未添加收件人！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    if([sendEmailView.contextInfoView.text length]==0 || [[sendEmailView.contextInfoView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"内容不能为空！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }
    
    NSString *dicXml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><intxtsessionlsh>%@</intxtsessionlsh><strtzbt>%@</strtzbt><strxxjbz>%@</strxxjbz><strzw>%@</strzw><strhhbz>%@</strhhbz><strtzgwz>%@</strtzgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><strryxm>%@</strryxm><intrylsh>%@</intrylsh><strcsjc>%@</strcsjc><intcsdwlsh>%@</intcsdwlsh><inttzfs>%@</inttzfs><intdwlsh>%@</intdwlsh><strdwjc>%@</strdwjc><intjslshlst>%@</intjslshlst><strxmlst>%@</strxmlst><strbzlst>%@</strbzlst></root>",
                     i_sessionId,
                     [self UnicodeToISO88591:sendEmailView.titleInfoField.text],
                     @"",
                        [self UnicodeToISO88591: sendEmailView.contextInfoView.text?:@""],
                     @"1",
                     @"",
                     @"",
                     @"",
                     [self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].username],
                     [ztOAGlobalVariable sharedInstance].intrylsh,
                     [self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].unitname_child],
                     [ztOAGlobalVariable sharedInstance].intdwlsh_child,
                     @"1",
                     [ztOAGlobalVariable sharedInstance].intdwlsh,
                     [self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].unitname],
                     i_intjslshlst,
                     [self UnicodeToISO88591:i_strxmlst],
                     i_strbzlst];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:dicXml,@"sendXML", nil];
    NSLog(@"i_intjslshlst==%@ /n i_strxmlst==%@ \n i_strbzlst==%@",i_intjslshlst,i_strxmlst,i_strbzlst);
    
    [self showWaitViewWithTitle:@"发送中..."];
    [ztOAService sendEmail:dic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dicData = [result objectFromJSONData];
        NSLog(@"发送结果：%@",dicData);
        if ( dicData!=NULL&&[[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            AudioServicesPlaySystemSound((unsigned long)1303);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送成功！"];
            [alert addButtonWithTitle:@"ok" handler:^(void){
                postN(@"reflashEmailTable");
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } Failed:^(NSError *error){
        [self closeWaitView];
         AudioServicesPlaySystemSound((unsigned long)1057);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"发送失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}
#pragma mark- end
- (void)getAttachment:(NSNotification *)notify
{
    NSDictionary *dic = (NSDictionary *)[notify userInfo];
    [self doSendEmailAttachments:dic];
}

//上传邮件附件
- (void)doSendEmailAttachments:(NSDictionary *)dic{
    NSLog(@"++1");
    [self.cxAlertShowView dismiss];
    NSLog(@"++1");
    [self showWaitViewWithTitle:@"上传附件中..."];
    NSString* fileName = [NSString stringWithFormat:@"%@.jpg",[self getCurrentTimeStr]];
    
    UIImage *fileImage = self.cxAlertImageView.image;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = UIImageJPEGRepresentation(fileImage, 0.5);
        NSString *base64Str = [data base64EncodedString];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *dicXml = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strfjmc>%@</strfjmc><imgfjnr>%@</imgfjnr><intfjlxbh>%@</intfjlxbh><strryxm>%@</strryxm><intxtsessionlsh>%@</intxtsessionlsh></root>",
                                [self UnicodeToISO88591:fileName],
                                base64Str,
                                @"",
                                [self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].username],
                                i_sessionId];
            NSDictionary *sendFjDic= [[NSDictionary alloc] initWithObjectsAndKeys:dicXml,@"sendFjXML",nil];
            NSLog(@"++1");
            [ztOAService sendEmailAttachments:sendFjDic Success:^(id result){
                [self closeWaitView];
                NSDictionary *dicData = [result objectFromJSONData];
                NSLog(@"上传附件结果：%@",dicData);
                if (dicData!=NULL&&[[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    NSString *fjlshStr = [[dicData objectForKey:@"root"] objectForKey:@"intfjlsh"];
                    NSDictionary *fileDicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fileName,@"strfjmc",fjlshStr,@"inttzfjlsh",nil];
                    [i_FjArray addObject:fileDicInfo];
                    
                    [self.fjLabelCount setText:[NSString stringWithFormat:@"%d",i_FjArray.count]];
                    [fjTableView.fjTable reloadData];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } Failed:^(NSError *error){
                [self closeWaitView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];

        });
    });
    
}
//转发更新附件
- (void)forwardEmailAttachments
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[baseInfoDic objectForKey:@"inttzlsh"]],@"inttzlsh", i_sessionId,@"moveequipmentid", nil];
    
    [ztOAService sendForwardEmailAttachments:dic Success:^(id result){
        NSDictionary *resultDic = [result objectFromJSONData];
        NSLog(@"--%@",resultDic);
        if (resultDic!=NULL&&[[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            [i_FjArray removeAllObjects];
            if ([[[resultDic objectForKey:@"root"] objectForKey:@"fj"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *ondDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[[resultDic objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"chrfjmc"],@"strfjmc",[[[resultDic objectForKey:@"root"] objectForKey:@"fj"] objectForKey:@"intfjlsh"],@"inttzfjlsh",nil];
                [i_FjArray addObject:ondDic];
            }
            else
            {
                for (int i=0; i<((NSArray *)[[resultDic objectForKey:@"root"] objectForKey:@"fj"]).count; i++) {
                   NSDictionary *ondDic = [[NSDictionary alloc] initWithObjectsAndKeys:[[[[resultDic objectForKey:@"root"] objectForKey:@"fj"] objectAtIndex:i] objectForKey:@"chrfjmc"],@"strfjmc",[[[[resultDic objectForKey:@"root"] objectForKey:@"fj"] objectAtIndex:i] objectForKey:@"intfjlsh"],@"inttzfjlsh",nil];
                    [i_FjArray addObject:ondDic];
                }
            }
            [fjTableView.fjTable reloadData];
            [self.fjLabelCount setText:[NSString stringWithFormat:@"%d",i_FjArray.count]];
        }
        else{
            [i_FjArray removeAllObjects];
            [fjTableView.fjTable reloadData];
            [self.fjLabelCount setText:[NSString stringWithFormat:@"%d",i_FjArray.count]];
            
        }
    } Failed:^(NSError *error){
        [i_FjArray removeAllObjects];
        [fjTableView.fjTable reloadData];
        [self.fjLabelCount setText:[NSString stringWithFormat:@"%d",i_FjArray.count]];
        
    }];
}
//添加相册图片
- (void)addPhotosAction
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//添加照相机图片
- (void)addCameraPhotosAction
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提 示" message:@"该设备沒有照相功能"
                              delegate:self cancelButtonTitle:@"确定"
                              otherButtonTitles: nil];
        [alert show];
        [self performSelector:@selector(dimissAlertView:) withObject:alert afterDelay:1.5];
    }else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
- (void) dimissAlertView:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma uiImagePickerCOntrol delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self myPop];
    
    UIImage *image = [[UIImage alloc]init];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //如果是 来自照相机的image，那么先保存
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    self.cxAlertImageView.image = image;
    [self.cxAlertShowView show];
    currentImage = image;
    //[self performSelector:@selector(showPhotoView) withObject:nil afterDelay:0.2];
    //[self showPhotoView];
    //ztOAPhotoViewController *photoSendVC = [[ztOAPhotoViewController alloc] initWithTitle:@"附件上传" withImage:image];
    //[self.navigationController pushViewController:photoSendVC animated:YES];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)delectOne:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *attachmentLsh = [[i_FjArray objectAtIndex:(btn.tag-100)] objectForKey:@"inttzfjlsh"];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: attachmentLsh,@"intfjlsh", nil];
    [self showWaitViewWithTitle:@"删除中..."];
    [ztOAService deleteEmailAttachmentsBylsh:dic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",dataDic);
        if (dataDic!=NULL && [[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            [i_FjArray removeObjectAtIndex:(btn.tag-100)];
            [self.fjLabelCount setText:[NSString stringWithFormat:@"%d",i_FjArray.count]];
            [fjTableView.fjTable reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
}
- (void)lookingBigImg:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    UIButton *btn = (UIButton *)sender;
    [array addObject:[i_FjArray objectAtIndex:(btn.tag-1000)]];
    
    //[self.navigationController pushViewController:[[ztOABigImgViewController alloc] initWithTitle:@"大图" selectedIndex:0 pictureArray:array currentType:3] animated:YES];
    
}
-(NSData*)sendOnePic:(UIImage *)image
{
    NSData *imagedata;
    if (UIImagePNGRepresentation(image) == nil)
    {
        imagedata = UIImageJPEGRepresentation(image, 0.5);
    }
    else
    {
        imagedata = UIImageJPEGRepresentation(image, 0.5);
        
        //imagedata = UIImagePNGRepresentation(image);
    }
    return imagedata;
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [sendEmailView.contextInfoView becomeFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (fjTableView.frame.origin.y<self.view.height) {
        [UIView animateWithDuration:0.3 animations:^{
            [fjTableView setFrame:CGRectMake(0, self.view.height,self.view.width, self.view.height-sendEmailView.bottom-20)];
            
        }];
    }
}
#pragma mark - textView delegate -
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (fjTableView.frame.origin.y<self.view.height) {
        [UIView animateWithDuration:0.3 animations:^{
            [fjTableView setFrame:CGRectMake(0, self.view.height,self.view.width, self.view.height-sendEmailView.bottom-20)];
            
        }];
    }
}

#pragma mark-tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (fjTableView.fjTable==tableView) {
        return  i_FjArray.count;
    }
    else if(pepoleListView==tableView)
    {
        return SendToPepolesInfoArray.count;
    }
    else
        return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (fjTableView.fjTable==tableView) {
        static NSString *cellId = @"fjCell";
        ztOAFjDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[ztOAFjDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
            [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
            [cell setSelectedBackgroundView:selectView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        NSString *fileNameStr = [NSString stringWithFormat:@"%@",[[i_FjArray objectAtIndex:indexPath.row] objectForKey:@"strfjmc"]];
        NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
        NSString *fileType = [array lastObject];
        NSString *iconImgName= @"";
        if ([fileType isEqualToString:@"doc"]) {
            iconImgName = @"file_ic_word1";
        }
        else if ([fileType isEqualToString:@"txt"]){
            iconImgName = @"file_ic_txt";
        }
        else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
            iconImgName = @"file_ic_img";
        }
        else if ([fileType isEqualToString:@"xls"]){
            iconImgName = @"file_ic_xls1";
        }
        else if ([fileType isEqualToString:@"pdf"]){
            iconImgName = @"file_ic_pdf";
        }
        else {
            iconImgName = @"file_ic_x";
        }
        cell.fileNameLable.text = fileNameStr;
        cell.fileSimpleImg.image = [UIImage imageNamed:iconImgName];
        cell.fileDeleteBtn.tag = 100+indexPath.row;
        [cell.fileDeleteBtn addTarget:self action:@selector(delectOne:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;

    }
    else
    {
        NSString *cellID = @"identifier";
        ztOANewDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ztOANewDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if (tableView == pepoleListView) {//已选择人员列表
            NSDictionary *pepoleDic = [SendToPepolesInfoArray objectAtIndex:indexPath.row];
            [cell setCellImageView:[UIImage imageNamed:@"treeIcon_02"]];
            if ([[seletedFlagArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                cell.accessoryType =UITableViewCellAccessoryNone;
            }
            else
            {
                cell.accessoryType =UITableViewCellAccessoryCheckmark;
            }
            
            [cell.title setText:[NSString stringWithFormat:@"%@", [pepoleDic objectForKey:@"name"]]];
        }
        return cell;
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == pepoleListView){
        //1:选中；0为选中
        if ([[seletedFlagArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            [seletedFlagArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        }
        else
        {
            [seletedFlagArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }
        if ([[seletedFlagArray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            cell.accessoryType =UITableViewCellAccessoryNone;
        }
        else
        {
            cell.accessoryType =UITableViewCellAccessoryCheckmark;
        }
    }
}

-(void)didReceiveMemoryWarning
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
