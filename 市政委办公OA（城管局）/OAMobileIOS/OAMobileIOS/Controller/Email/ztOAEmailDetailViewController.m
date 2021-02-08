//
//  ztOAEmailDetailViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAEmailDetailViewController.h"
#import "ztOASendEmailViewController.h"
#import "ztOAUnderLineLabel.h"
@interface ztOAEmailDetailViewController ()
{
    NSString *titleStr;
    NSString *senderStr;
    NSString *receiveStr;
    NSString *timeStr;
    NSString *contextStr;
    NSMutableArray *fjBagArray;
    
    NSString *i_intnbyjlsh;//内部邮件流水号
    FilePlugin *filePlugin;
   
    NSDictionary *dataDic;
    NSDictionary *baseDic;
    NSString     *appTitleStr;
    NSString     *emailType;//0收件;1发件
    UIButton *conerightBtn;
}
@property(nonatomic,strong)UIScrollView *mainMailView;
@property(nonatomic,strong)UIView  *titleBackImg;//标题栏
@property(nonatomic,strong)UILabel      *mailTitle;//邮件标题
@property(nonatomic,strong)UILabel      *mailSender;//邮件发送人
@property(nonatomic,strong)UILabel      *mailReceiver;//邮件收件人
@property(nonatomic,strong)UILabel      *mailTime;//邮件时间
@property(nonatomic,strong)UILabel      *mailContext;//邮件内容
@property(nonatomic,strong)UIButton     *mailDetailShowBtn;//显示详情按钮
@property(nonatomic,strong)UIImageView  *breakLine1;//分割线1
@property(nonatomic,strong)UIImageView  *breakLine2;//分割线2

@property(nonatomic,strong)UIView       *mailToolBar;//底部按钮拦（回复、转发、新建）
@property(nonatomic,strong)UIButton     *mailReplyBtn;
@property(nonatomic,strong)UIButton     *mailForwardBtn;
@property(nonatomic,strong)UIButton     *mailCreatNewBtn;
@property(nonatomic,strong)UITableView  *emailFjTable;
@property (nonatomic,strong) UIViewController   *viewController;
@property(nonatomic,strong)UIView       *bottomBtnBar;

@end

@implementation ztOAEmailDetailViewController
@synthesize mainMailView;
@synthesize titleBackImg,mailTitle,mailSender,mailReceiver,mailContext,mailTime,mailDetailShowBtn,breakLine1,breakLine2;
@synthesize mailToolBar,mailReplyBtn,mailForwardBtn,mailCreatNewBtn;
@synthesize emailFjTable;
@synthesize viewController = _viewController;
@synthesize bottomBtnBar;

- (id)initWithDataDic:(NSDictionary *)dic  withTitle:(NSString *)titleString withBaseInfoDic:(NSDictionary *)baseInfoDic
{
    self = [super init];
    if (self) {
        dataDic = dic;
        baseDic = baseInfoDic;
        self.title = titleString;
        appTitleStr=titleString;
        fjBagArray = [[NSMutableArray alloc] init];
        
        filePlugin = [FilePlugin alloc];
        filePlugin.delegate = self;
        NSLog(@"dic==%@",dataDic);
        titleStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"strtzbt"]]?:@"";
        senderStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"strryxm"]]?:@"?";
        timeStr = [ztOASmartTime timeFromStr:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"dtmdjsj"]]];
        contextStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"strzw"]]?:@"";
        
        receiveStr = @"";
        if([[dataDic objectForKey:@"jsry"] isKindOfClass:[NSDictionary class]])
        {
            receiveStr = [NSString stringWithFormat:@"%@",[[dataDic objectForKey:@"jsry"] objectForKey:@"strxm"]]?:@"";
        }
        else
        {
            NSMutableArray *array = [dataDic objectForKey:@"jsry"];
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
        
        NSString *fjStr = ([dataDic objectForKey:@"fj"]==[NSNull null]?@"":[dataDic objectForKey:@"fj"])?:@"";
            if ([fjStr isKindOfClass:[NSDictionary class]]) {
                [fjBagArray addObject:[dataDic objectForKey:@"fj"]];
            }
            else
            {
                fjBagArray = [dataDic objectForKey:@"fj"];
            }
        //更新邮件查看更新标志
        [self reflashLookingFlag];
    }
    return self;
}
//更新邮件查看更新标志
- (void)reflashLookingFlag
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"inttzlsh"]],@"inttzlsh", nil];
    [ztOAService updateEmailLookingFlag:dic Success:^(id result){
        NSLog(@"%@",[result objectFromJSONData]);
    
    } Failed:^(NSError *errpr){
        NSLog(@"error!");
    }];
}

//跳转发送邮件界面
-(void)doSendEmail
{
    ztOASendEmailViewController *sendVC = [[ztOASendEmailViewController alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    conerightBtn=[self rightButton:nil imagen:@"btn_fav_no_n" imageh:nil sel:@selector(collectEmailAction)];
    [conerightBtn setImage:PNGIMAGE(@"btn_fav_yes_n") forState:UIControlStateSelected];
    float  bottomHeight_t = 50;
    //主屏
    self.mainMailView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,self.view.width ,self.view.height-bottomHeight_t)];
    mainMailView.backgroundColor = [UIColor whiteColor];
    mainMailView.directionalLockEnabled = YES;
    mainMailView.showsHorizontalScrollIndicator = NO;
    mainMailView.showsVerticalScrollIndicator = NO;
    mainMailView.delegate = self;
    [mainMailView setUserInteractionEnabled:YES];
    [self.view addSubview:mainMailView];
    //底部按钮bar
    self.bottomBtnBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-bottomHeight_t, self.view.width, bottomHeight_t)];
    self.bottomBtnBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomBtnBar];
    UIImage *backBtnImg = [UIImage imageNamed:@"banner_bg"];
    NSInteger leftCapWidth = backBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = backBtnImg.size.height * 0.5f;
    backBtnImg = [backBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    if ([appTitleStr isEqualToString:@"收件详情"]) {
        emailType = @"0";
        //转发
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/4-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_forward"];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/4, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"转发";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *forwardMailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forwardMailBtn setFrame:CGRectMake(0, 0, bottomBtnBar.width/4, 50)];
        [forwardMailBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [forwardMailBtn addTarget:self action:@selector(forwardMail) forControlEvents:UIControlEventTouchUpInside];
        [forwardMailBtn addSubview:imageIcon];
        [forwardMailBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:forwardMailBtn];
        
        
        //回复
        imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/4-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_reply"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/4, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"回复";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyBtn setFrame:CGRectMake(forwardMailBtn.right, 0, bottomBtnBar.width/4, 50)];
        [replyBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [replyBtn addTarget:self action:@selector(replyMail) forControlEvents:UIControlEventTouchUpInside];
        [replyBtn addSubview:imageIcon];
        [replyBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:replyBtn];
        
        //删除
        imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/4-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_del"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/4, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"删除";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *deleteEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteEmailBtn setFrame:CGRectMake(replyBtn.right, 0, bottomBtnBar.width/4, 50)];
        [deleteEmailBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [deleteEmailBtn addTarget:self action:@selector(deleteEmailAtion) forControlEvents:UIControlEventTouchUpInside];
        [deleteEmailBtn addSubview:imageIcon];
        [deleteEmailBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:deleteEmailBtn];
        
        //新建
        imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/4-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_new"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/4, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"新建";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *creatNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [creatNewBtn setFrame:CGRectMake(deleteEmailBtn.right, 0, bottomBtnBar.width/4, 50)];
        [creatNewBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [creatNewBtn addTarget:self action:@selector(creatNewMail) forControlEvents:UIControlEventTouchUpInside];
        [creatNewBtn addSubview:imageIcon];
        [creatNewBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:creatNewBtn];
        
    }
    else
    {
        emailType = @"1";
        //转发
        UIImageView *imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/3-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_forward"];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/3, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"转发";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *forwardMailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forwardMailBtn setFrame:CGRectMake(0, 0, bottomBtnBar.width/3, 50)];
        [forwardMailBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [forwardMailBtn addTarget:self action:@selector(forwardMail) forControlEvents:UIControlEventTouchUpInside];
        [forwardMailBtn addSubview:imageIcon];
        [forwardMailBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:forwardMailBtn];
        
        //删除
        imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/3-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_del"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/3, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"删除";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *deleteEmailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteEmailBtn setFrame:CGRectMake(forwardMailBtn.right, 0, bottomBtnBar.width/3, 50)];
        [deleteEmailBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [deleteEmailBtn addTarget:self action:@selector(deleteEmailAtion) forControlEvents:UIControlEventTouchUpInside];
        [deleteEmailBtn addSubview:imageIcon];
        [deleteEmailBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:deleteEmailBtn];
        
        //新建
        imageIcon = [[UIImageView alloc] initWithFrame:CGRectMake((bottomBtnBar.width/3-21)/2, 5, 21, 21)];
        imageIcon.backgroundColor = [UIColor clearColor];
        imageIcon.image = [UIImage imageNamed:@"btn_yj_new"];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, bottomBtnBar.width/3, 15)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:10.0f];
        nameLabel.text = @"新建";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = BACKCOLOR;
        
        UIButton *creatNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [creatNewBtn setFrame:CGRectMake(deleteEmailBtn.right, 0, bottomBtnBar.width/3, 50)];
        [creatNewBtn setBackgroundImage:backBtnImg forState:UIControlStateNormal];
        [creatNewBtn addTarget:self action:@selector(creatNewMail) forControlEvents:UIControlEventTouchUpInside];
        [creatNewBtn addSubview:imageIcon];
        [creatNewBtn addSubview:nameLabel];
        [self.bottomBtnBar addSubview:creatNewBtn];
    }
    
    //显示标题栏
    self.titleBackImg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainMailView.width, 90)];
    [titleBackImg setUserInteractionEnabled:YES];
    titleBackImg.backgroundColor = [UIColor clearColor];
    [self.mainMailView addSubview:titleBackImg];
    
    CGSize maximumLabelSizeTitle = CGSizeMake(titleBackImg.width-20,MAXFLOAT);
    CGSize expectedLabelSizeTitle = [titleStr sizeWithFont:[UIFont systemFontOfSize:16]
                                          constrainedToSize:maximumLabelSizeTitle
                                              lineBreakMode:NSLineBreakByWordWrapping];
    CGRect titleRect = CGRectMake(10, 10 ,titleBackImg.width-20, expectedLabelSizeTitle.height);
    
    self.mailTitle = [[UILabel alloc] initWithFrame:titleRect];
    self.mailTitle.text = titleStr;
    self.mailTitle.font = [UIFont systemFontOfSize:16];
    mailTitle.textAlignment = NSTextAlignmentLeft;
    mailTitle.backgroundColor = [UIColor clearColor];
    mailTitle.lineBreakMode = NSLineBreakByWordWrapping;
    mailTitle.numberOfLines = 0;
    //[mailTitle sizeToFit];
    [titleBackImg addSubview:mailTitle];
    
    self.mailTime = [[UILabel alloc] initWithFrame:CGRectMake(10, mailTitle.bottom, titleBackImg.width-20-80, 20)];
    mailTime.text = timeStr;
    mailTime.textColor = [UIColor grayColor];
    mailTime.backgroundColor = [UIColor clearColor];
    mailTime.font = [UIFont systemFontOfSize:12];
    [titleBackImg addSubview:mailTime];
    //默认不显示
    self.mailDetailShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mailDetailShowBtn.frame = CGRectMake(mainMailView.width-10-80, mailTitle.bottom,70 , 20);
    mailDetailShowBtn.backgroundColor = [UIColor clearColor];
    [mailDetailShowBtn setTitle:@"隐藏详情" forState:UIControlStateNormal];
    [mailDetailShowBtn setTitle:@"显示详情" forState:UIControlStateSelected];
    [mailDetailShowBtn setBackgroundImage:[UIImage imageNamed:@"whiteBtn120_60"] forState:UIControlStateNormal];
    [mailDetailShowBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [mailDetailShowBtn setTitleColor:MF_ColorFromRGB(85, 123, 233) forState:UIControlStateNormal];
    [mailDetailShowBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [mailDetailShowBtn addTarget:self action:@selector(mailDetailShow) forControlEvents:UIControlEventTouchUpInside];
    [titleBackImg addSubview:mailDetailShowBtn];
    
    self.mailSender = [[UILabel alloc] initWithFrame:CGRectMake(10, mailTime.bottom, titleBackImg.width-20, 20)];
    mailSender.text = [NSString stringWithFormat:@"发件人:%@",senderStr];
    mailSender.textColor = [UIColor grayColor];
    mailSender.backgroundColor = [UIColor clearColor];
    mailSender.font = [UIFont systemFontOfSize:12];
    [titleBackImg addSubview:mailSender];
    
    CGSize maximumLabelSizeReceiver = CGSizeMake(titleBackImg.width-20,MAXFLOAT);
    CGSize expectedLabelSizeReceiver = [[NSString stringWithFormat:@"收件人:%@",receiveStr]
                                        sizeWithFont:[UIFont systemFontOfSize:12]
                                        constrainedToSize:maximumLabelSizeReceiver
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGRect receiverRect = CGRectMake(10, mailSender.bottom ,titleBackImg.width-20, expectedLabelSizeReceiver.height);
    
    self.mailReceiver = [[UILabel alloc] initWithFrame:receiverRect];
    mailReceiver.text = [NSString stringWithFormat:@"收件人:%@",receiveStr];
    mailReceiver.backgroundColor = [UIColor clearColor];
    mailReceiver.textColor = [UIColor grayColor];
    mailReceiver.font = [UIFont systemFontOfSize:12];
    mailReceiver.lineBreakMode = NSLineBreakByWordWrapping;
    mailReceiver.numberOfLines = 0;
    [titleBackImg addSubview:mailReceiver];
    //默认显示
    titleBackImg.frame = CGRectMake(0, 0, mainMailView.width, mailTime.bottom);
    //[mailReceiver setHidden:YES];
    //[mailSender setHidden:YES];

    titleBackImg.frame = CGRectMake(0, 0, mainMailView.width, mailReceiver.bottom);
    
    self.breakLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleBackImg.bottom+10, mainMailView.width, 1)];
    breakLine1.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    [mainMailView addSubview:breakLine1];
    
    //邮件内容
    CGSize maximumLabelSizeContext = CGSizeMake(titleBackImg.width-20,MAXFLOAT);
    CGSize expectedLabelSizeContext= [contextStr sizeWithFont:[UIFont systemFontOfSize:14]
                                    constrainedToSize:maximumLabelSizeContext
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGRect ContextRect = CGRectMake(10, titleBackImg.bottom+20 ,titleBackImg.width-20, expectedLabelSizeContext.height);
    
    
    self.mailContext = [[UILabel alloc] initWithFrame:ContextRect];
    self.mailContext.text = contextStr;
    self.mailContext.font = [UIFont systemFontOfSize:14];
    mailContext.textAlignment = NSTextAlignmentLeft;
    mailContext.backgroundColor = [UIColor clearColor];
    mailContext.lineBreakMode = NSLineBreakByWordWrapping;
    mailContext.numberOfLines = 0;
    //[mailTitle sizeToFit];
    [mainMailView addSubview:mailContext];
    
    
    //附件
    if (fjBagArray.count>0) {
        
        self.emailFjTable = [[UITableView alloc] initWithFrame:CGRectMake(0, mailContext.bottom+20, mainMailView.width, (fjBagArray.count-1)*44+64 )];
        emailFjTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.emailFjTable setDataSource:self];
        [self.emailFjTable setDelegate:self];
        [mainMailView addSubview:emailFjTable];
        [emailFjTable setScrollEnabled:NO];
        //NSLog(@"%@",fjBagArray);
        [mainMailView setContentSize:CGSizeMake(self.view.width, (emailFjTable.bottom+20)>=(self.view.height-64-bottomHeight_t)?(emailFjTable.bottom+20):(self.view.height-64-bottomHeight_t))];
    }
    else {
        [mainMailView setContentSize:CGSizeMake(self.view.width, (mailContext.bottom+20)>=(self.view.height-64-bottomHeight_t)?(mailContext.bottom+20):(self.view.height-64-bottomHeight_t))];
    }
    
    //监测本地收藏情况
    [self searchLocalEmailCollect];
}
- (void)mailDetailShow
{
    [UIView animateWithDuration:0.3 animations:^{
        if ([mailDetailShowBtn isSelected]) {
            [mailDetailShowBtn setSelected:NO];
            titleBackImg.frame = CGRectMake(0, 0, mainMailView.width, mailReceiver.bottom);
            [mailReceiver setHidden:NO];
            [mailSender setHidden:NO];
        }
        else
        {
            [mailDetailShowBtn setSelected:YES];
            titleBackImg.frame = CGRectMake(0, 0, mainMailView.width, mailTime.bottom);
            [mailReceiver setHidden:YES];
            [mailSender setHidden:YES];
        }
        [mailContext setOrigin:CGPointMake(10, titleBackImg.bottom+20)] ;
        [emailFjTable setOrigin:CGPointMake(0, mailContext.bottom+20)];
        [breakLine1 setOrigin:CGPointMake(0, titleBackImg.bottom+10)] ;
        [breakLine2 setOrigin:CGPointMake(0, mailContext.bottom+10)];
    }];
}
- (void)replyMail
{
    ztOASendEmailViewController *sendVC = [[ztOASendEmailViewController alloc] initWithTitle:@"回复邮件" withDic:dataDic];
    [self.navigationController pushViewController:sendVC animated:YES];
}
- (void)forwardMail
{
    ztOASendEmailViewController *sendVC = [[ztOASendEmailViewController alloc] initWithTitle:@"转发邮件" withDic:dataDic];
    [self.navigationController pushViewController:sendVC animated:YES];
}
- (void)creatNewMail
{
    ztOASendEmailViewController *sendVC = [[ztOASendEmailViewController alloc] initWithTitle:@"写邮件" withDic:nil];
    [self.navigationController pushViewController:sendVC animated:YES];
}
#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    headView.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width-20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"附件";
    [headView addSubview:label];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([fjBagArray isKindOfClass:[NSDictionary class]]) {
        return 1;
    }
    else    return fjBagArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SearchList";
    ztOAFjSimpelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[ztOAFjSimpelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSString *fileNameStr =@"";
    if ([fjBagArray isKindOfClass:[NSDictionary class]]) {
        fileNameStr = [NSString stringWithFormat:@"%@",[(NSDictionary*)fjBagArray objectForKey:@"strfjmc"]];
    }
    else
    {
        fileNameStr =  [NSString stringWithFormat:@"%@", [[fjBagArray objectAtIndex:indexPath.row] objectForKey:@"strfjmc"] ];
    }
    
    NSLog(@"-%@-",fileNameStr);
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
    cell.fjName.text = fileNameStr;
    [cell.iconImg setImage:[UIImage imageNamed:iconImgName]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([fjBagArray isKindOfClass:[NSDictionary class]]) {
        
        
        
        NSDictionary *fileObj = (NSDictionary *)fjBagArray;
        filePlugin.viewController = self;
        [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                blnvalue:@"false"
                strClass:@"nbyjServices"
               strMethod:@"getNbyjFj"
                   pageX:@""
                   pageY:@""
                isChange:@""
                 withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
            withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"intfjlsh", nil] fjType:nil];
    }
    else
    {
        if (indexPath.row<fjBagArray.count) {
            NSDictionary *fileObj = [fjBagArray objectAtIndex:indexPath.row];
            filePlugin.viewController = self;
            NSLog(@"name==%@",[fileObj objectForKey:@"strfjmc"]);
            
            
            [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                    blnvalue:@"false"
                    strClass:@"nbyjServices"
                   strMethod:@"getNbyjFj"
                       pageX:@""
                       pageY:@""
                    isChange:@""
                     withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"intfjlsh", nil] fjType:nil];
        }
    }
    
    
}
#pragma mark - 收藏-
//收藏操作
- (void)collectEmailAction
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
        if ([userDefaults objectForKey:@"localEmailCollectArray"]!=nil) {
            [allCollectInfoArray addObjectsFromArray:[userDefaults objectForKey:@"localEmailCollectArray"]];
        }
        //收藏
        if (![conerightBtn isSelected]) {
            NSDictionary *collectDic = [NSDictionary dictionaryWithObjectsAndKeys:emailType,@"type",baseDic,@"dic", nil];;
            [allCollectInfoArray addObject:collectDic];
        }
        //取消收藏
        else
        {
            for (int i = 0; i<allCollectInfoArray.count; i++) {
                NSDictionary *oneCollectDic = [allCollectInfoArray objectAtIndex:i];
                if ([[NSString stringWithFormat:@"%@",[oneCollectDic objectForKey:@"type"]] isEqualToString:emailType] &&
                    [[NSString stringWithFormat:@"%@",[[oneCollectDic objectForKey:@"dic"]objectForKey:@"inttzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[baseDic objectForKey:@"inttzlsh"]]]) {
                    [allCollectInfoArray removeObject:oneCollectDic];
                    break;
                }
            }
        }
        [userDefaults setObject:allCollectInfoArray forKey:@"localEmailCollectArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        conerightBtn.selected = !conerightBtn.selected;
    }];
    [alert addButtonWithTitle:@"取消" handler:^(void){
        
    }];
    [alert show];
}
//监测本地是否已收藏
- (void)searchLocalEmailCollect
{
    //本地数据
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *allCollectInfoArray = [[NSMutableArray alloc] init];
    if ([userDefaults objectForKey:@"localEmailCollectArray"]!=nil) {
        [allCollectInfoArray addObjectsFromArray:[userDefaults objectForKey:@"localEmailCollectArray"]];
    }
    [conerightBtn setSelected:NO];
    for (int i = 0; i<allCollectInfoArray.count; i++) {
        NSDictionary *oneCollectDic = [allCollectInfoArray objectAtIndex:i];
        
        if ([[NSString stringWithFormat:@"%@",[oneCollectDic objectForKey:@"type"]] isEqualToString:emailType] &&
            [[NSString stringWithFormat:@"%@",[[oneCollectDic objectForKey:@"dic"] objectForKey:@"inttzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[baseDic objectForKey:@"inttzlsh"]]]  )
        {
            [conerightBtn setSelected:YES];
            break;
        }
    }
}
//删除邮件
- (void)deleteEmailAtion
{
    NSString *emailLshIndex = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"inttzlsh"]];
    NSString *isReceiveOrSendEmail = @"0";
    if ([appTitleStr isEqualToString:@"收件详情"]) {
        isReceiveOrSendEmail = @"0";
    }
    else
    {
        isReceiveOrSendEmail = @"1";
    }
    
    NSDictionary *delectDic = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",isReceiveOrSendEmail,@"intsfbz",emailLshIndex,@"inttzlshs", nil];
    UIAlertView *alertShow = [UIAlertView alertWithTitle:@"温馨提示" message:@"是否删除该邮件?"];
    [alertShow addButtonWithTitle:@"确定" handler:^{
        [self showWaitViewWithTitle:@"正在删除..."];
        [ztOAService deleteEmailsBylsh:delectDic Success:^(id result){
            [self closeWaitView];
            NSDictionary *resultDic = [result objectFromJSONData];
            NSLog(@"%@",resultDic);
            if ([[resultDic objectForKey:@"root"] objectForKey:@"result"]!=NULL &&[[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                //删除本地收藏
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *allCollectInfoArray = [[NSMutableArray alloc] init];
                if ([userDefaults objectForKey:@"localEmailCollectArray"]!=nil) {
                    [allCollectInfoArray addObjectsFromArray:[userDefaults objectForKey:@"localEmailCollectArray"]];
                }
                for (int i = 0; i<allCollectInfoArray.count; i++) {
                    NSDictionary *oneCollectDic = [allCollectInfoArray objectAtIndex:i];
                    if ([[NSString stringWithFormat:@"%@",[oneCollectDic objectForKey:@"type"]] isEqualToString:emailType] &&
                        [[NSString stringWithFormat:@"%@",[[oneCollectDic objectForKey:@"dic"]objectForKey:@"inttzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[baseDic objectForKey:@"inttzlsh"]]]) {
                        [allCollectInfoArray removeObject:oneCollectDic];
                        break;
                    }
                }
                [userDefaults setObject:allCollectInfoArray forKey:@"localEmailCollectArray"];
                [userDefaults synchronize];
                
                //删除成功
                postN(@"reflashEmailTable");
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } Failed:^(NSError *error){
            [self closeWaitView];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            
        }];
        
    }];
    [alertShow addButtonWithTitle:@"取消" handler:^{}];
    
    [alertShow show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
