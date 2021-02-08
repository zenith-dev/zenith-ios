//
//  ztOAOfficialDocSearchViewController.m
//  OAMobileIOS
//
//  Created by xj on 16-3-7.
//  Copyright (c) 2016年 chenyang. All rights reserved.
//

#import "ztOAOfficialDocSearchViewController.h"
#import "ztOADetailInfoListViewController.h"
#import "ztOATextField.h"
#import "PopView.h"
@interface ztOAOfficialDocSearchViewController ()<PopViewDelegate>
@property(nonatomic,strong)UIButton     *receiveBtn;//收文
@property(nonatomic,strong)UIButton     *sendBtn;//发文
@property(nonatomic,strong)UIScrollView       *infoView;
@property (nonatomic,strong)PopView *popview;
@property (nonatomic,strong)NSMutableArray *poplist;
//标题
@property(nonatomic,strong)ztOATextField  *titleName;
//公文字
@property(nonatomic,strong)ztOATextField  *official;
//年号
@property(nonatomic,strong)ztOATextField      *yearNum;
//期号
@property(nonatomic,strong)ztOATextField  *dateField;
//来文单位
@property(nonatomic,strong)ztOATextField      *companyField;
//秘密等级
@property(nonatomic,strong)UILabel      *secretGradeField;
//紧急程度
@property(nonatomic,strong)UILabel      *emergencyGradeField;

//开始时间
@property(nonatomic,strong)ztOATextField  *startTimeField;
@property(nonatomic,strong)UIButton     *startTimeBtn;
//结束时间
@property(nonatomic,strong)ztOATextField  *stopTimeField;
//收文分类
@property(nonatomic,strong)ztOATextField *swfltf;//收文分类
@property(nonatomic,strong)UIImageView *swflImg;



@property(nonatomic,strong)UIButton     *stopTimeBtn;






@property(nonatomic,strong)UIButton    *searchBtn;//查询按钮
@property(nonatomic,strong)UIButton    *resetBtn;//重置按钮

@property(nonatomic,strong)UIPickerView *pickerDate;//年号选择器
@property(nonatomic,strong)UIView       *yearDateView;
@property(nonatomic,strong)NSMutableArray *arrayYears;

@property(nonatomic,strong)UIActionSheet *actionSheetView;

@property(nonatomic,strong)UIDatePicker  *datePicker;//日期选择器
@property(nonatomic,strong)UIView       *dateView;
@property(nonatomic, strong) UIToolbar          *toolBar;//年号工具条
@property(nonatomic, strong) UIToolbar          *timeToolBar;//时间工具条
@property(nonatomic,assign)int indexrow;
@end

@implementation ztOAOfficialDocSearchViewController
@synthesize receiveBtn,sendBtn,searchBtn,resetBtn;
@synthesize infoView,titleName,official,yearNum,dateField,companyField,emergencyGradeField,secretGradeField,startTimeField,startTimeBtn,stopTimeField,stopTimeBtn;
@synthesize pickerDate,yearDateView,arrayYears,actionSheetView,datePicker,dateView;
@synthesize toolBar,timeToolBar,swfltf,swflImg,poplist,indexrow;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    NSDate* nowDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:nowDate];
    int nowYear = [dd year];
    self.arrayYears = [[NSMutableArray alloc] init];
    for (int i = nowYear-5;i <= nowYear;i++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 40*11)];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.contentSize = CGSizeMake(self.view.width, 40*10);
    infoView.backgroundColor = [UIColor clearColor];
    infoView.directionalLockEnabled = YES;
    infoView.showsHorizontalScrollIndicator = YES;
    infoView.showsVerticalScrollIndicator = YES;
    infoView.delegate = self;
    [self.view addSubview:infoView];
    //公文类型
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"公文类型:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    [backImg addSubview:label];
    
    UIImage *selectedBtnImg = [UIImage imageNamed:@"color_05"];
    NSInteger leftBtnCapWidth = selectedBtnImg.size.width * 0.5f;
    NSInteger topBtnCapHeight = selectedBtnImg.size.height * 0.5f;
    selectedBtnImg = [selectedBtnImg stretchableImageWithLeftCapWidth:leftBtnCapWidth topCapHeight:topBtnCapHeight];
    
    self.receiveBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImg.width-140, 10,  70, 25)];
    [receiveBtn setBackgroundImage:[UIImage imageNamed:@"blueAndWhite_btnImg"] forState:UIControlStateNormal];
    [receiveBtn setBackgroundImage:selectedBtnImg forState:UIControlStateSelected];
    [receiveBtn setTitle:@"收文" forState:UIControlStateNormal];
    [receiveBtn setSelected:YES];
    [receiveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [receiveBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [receiveBtn addTarget:self action:@selector(doReceive) forControlEvents:UIControlEventTouchUpInside];
    [receiveBtn setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:receiveBtn];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(backImg.width-70, 10,  70, 25)];
    [sendBtn setSelected:NO];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"blueAndWhite_btnImg"] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:selectedBtnImg forState:UIControlStateSelected];
    [sendBtn setTitle:@"发文" forState:UIControlStateNormal];
    [sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sendBtn addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setBackgroundColor:[UIColor clearColor]];
    [sendBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [backImg addSubview:sendBtn];
    
    //标题
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"标      题:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.titleName = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    [titleName setFont:[UIFont systemFontOfSize:14.0f]];
    titleName.delegate = self;
    titleName.returnKeyType = UIReturnKeyDone;
    [titleName setKeyboardType:UIKeyboardTypeDefault];
    titleName.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:titleName];
    
    //公文字
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*2, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    //[backImg setImage:[UIImage imageNamed:@"center_bg_n"]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"公文字  :";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.official = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    [official setFont:[UIFont systemFontOfSize:14.0f]];
    official.delegate = self;
    official.returnKeyType = UIReturnKeyDone;
    [official setKeyboardType:UIKeyboardTypeDefault];
    official.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:official];
    
    //年号
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*3, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"年      号:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.yearNum = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    [yearNum setFont:[UIFont systemFontOfSize:14.0f]];
    yearNum.backgroundColor = [UIColor whiteColor];
    [yearNum setText:@""];
    yearNum.delegate=self;
    [yearNum setTextAlignment:NSTextAlignmentLeft];
    
    UIButton *upAndDownIcon = [[UIButton alloc] initWithFrame:CGRectMake(yearNum.right, 5, 40, 30)];
    [upAndDownIcon setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn"] forState:UIControlStateNormal];
    [upAndDownIcon addTarget:self action:@selector(yearSelect) forControlEvents:UIControlEventTouchUpInside];
    [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
    
    [backImg addSubview:label];
    [backImg addSubview:upAndDownIcon];
    [backImg addSubview:yearNum];
    
    //期号
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*4, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"期      号:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.dateField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    [dateField setFont:[UIFont systemFontOfSize:14.0f]];
    dateField.delegate = self;
    dateField.returnKeyType = UIReturnKeyDone;
    [dateField setKeyboardType:UIKeyboardTypeDefault];
    dateField.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:dateField];
    
    //来文单位
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*5, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    //[backImg setImage:[UIImage imageNamed:@"center_bg_n"]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"来文单位:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.companyField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    [companyField setFont:[UIFont systemFontOfSize:14.0f]];
    companyField.delegate = self;
    companyField.returnKeyType = UIReturnKeyDone;
    [companyField setKeyboardType:UIKeyboardTypeDefault];
    companyField.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:companyField];
    
    
    
    //开始时间
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*6, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"开始时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.startTimeField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    [startTimeField setFont:[UIFont systemFontOfSize:14.0f]];
    startTimeField.placeholder=@"请选择开始时间";
    startTimeField.delegate=self;
    startTimeField.backgroundColor = [UIColor whiteColor];
    self.startTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(startTimeField.right, 5, 40, 30)];
    [startTimeBtn setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn"] forState:UIControlStateNormal];
    [startTimeBtn addTarget:self action:@selector(startTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    [startTimeBtn setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:label];
    [backImg addSubview:startTimeField];
    [backImg addSubview:startTimeBtn];
    [startTimeField setUserInteractionEnabled:YES];
    
    //结束时间
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*7, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"结束时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.stopTimeField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    stopTimeField.placeholder=@"请选择结束时间";
    stopTimeField.delegate=self;
    [stopTimeField setFont:[UIFont systemFontOfSize:14.0f]];
    stopTimeField.backgroundColor = [UIColor whiteColor];
    self.stopTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(stopTimeField.right, 5, 40, 30)];
    [stopTimeBtn setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn.png"] forState:UIControlStateNormal];
    [stopTimeBtn addTarget:self action:@selector(stopTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    [stopTimeBtn setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:label];
    [backImg addSubview:stopTimeField];
    [backImg addSubview:stopTimeBtn];
    [stopTimeField setUserInteractionEnabled:YES];
    
    //收文分类
    swflImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*8, self.view.width-20, 40)];
    [swflImg setBackgroundColor:[UIColor clearColor]];
    [swflImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:swflImg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"收文分类";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    swfltf =[[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    swfltf.clearButtonMode=UITextFieldViewModeWhileEditing;
    swfltf.placeholder=@"请选择收文分类";
    swfltf.delegate=self;
    swfltf.adjustsFontSizeToFitWidth=YES;
    [swfltf setFont:[UIFont systemFontOfSize:14.0f]];
    swfltf.backgroundColor = [UIColor whiteColor];
    
    UIButton *swflbtn = [[UIButton alloc] initWithFrame:CGRectMake(swfltf.right, 5, 40, 30)];
    [swflbtn setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn.png"] forState:UIControlStateNormal];
    [swflbtn addTarget:self action:@selector(swflSelect) forControlEvents:UIControlEventTouchUpInside];
    [swflbtn setBackgroundColor:[UIColor clearColor]];
    [swflImg addSubview:label];
    [swflImg addSubview:swfltf];
    [swflImg addSubview:swflbtn];
    
    UIImage *searchBtnImg = [UIImage imageNamed:@"color_02"];
    UIImage *resetBtnImg = [UIImage imageNamed:@"color_03"];
    NSInteger leftCapWidth = searchBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = searchBtnImg.size.height * 0.5f;
    searchBtnImg = [searchBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    resetBtnImg = [resetBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, infoView.bottom+20, self.view.width/2-20, 40)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:searchBtnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10, infoView.bottom+20, self.view.width/2-20, 40)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:resetBtnImg forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(toReset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:resetBtn];
    
    
    
    self.actionSheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"已办结",@"未办结", nil];
    [actionSheetView setFrame:CGRectMake(0, self.view.size.height-260, 320, 260)];
    actionSheetView.delegate = self;
    actionSheetView.actionSheetStyle = UIActionSheetStyleDefault;
    
    
}
#pragma mark- 选择日期
- (void)selectDate
{
    NSDate *select = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    if ([self.startTimeBtn isSelected])
    {
        startTimeField.text=[NSString stringWithFormat:@"%@",dateAndTime];
        [self.startTimeBtn setSelected:NO];
        
    }else if ([self.stopTimeBtn isSelected])
    {
        stopTimeField.text=[NSString stringWithFormat:@"%@",dateAndTime];
        [self.stopTimeBtn setSelected:NO];
    }
    [dateView setHidden:YES];
}
-(NSDate *)stringToDate:(NSString *)strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strTime];
    return date;
}

#pragma mark- 查询
- (void)toSearch
{
    NSString *type ;
    if ([sendBtn isSelected]) {
        type = @"002";
    }
    else
    {
        type = @"001";
    }
    NSMutableDictionary *searchdic=[[NSMutableDictionary alloc]initWithDictionary:@{@"chrgwbt":[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",titleName.text?:@"" ]],
                              @"chrgwz":[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",official.text?:@""]],
                              @"intgwnh":yearNum.text?:@"",
                              @"intgwqh":[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",dateField.text?:@""]],
                              @"chrlwdwmc": [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",companyField.text?:@""]],
                              @"dtmdjsj1":startTimeField.text?:@"",
                              @"dtmdjsj2":stopTimeField.text?:@"",
                              @"chrgwlb":type,@"intzbflbh":([type isEqualToString:@"002"]||swfltf.text.length==0)?@"":poplist[indexrow][@"intzbflbh"]}];
    
    
    
    NSString *dic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2><intzbflbh>%@</intzbflbh></root>",
           [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",titleName.text?:@"" ]],
           [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",official.text?:@""]],
           yearNum.text?:@"",
           [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",dateField.text?:@""]],
           type,
           [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",companyField.text?:@""]],
           @"",
           @"",
           startTimeField.text?:@"" ,
           stopTimeField.text?:@"",([type isEqualToString:@"002"]||swfltf.text.length==0)?@"":poplist[indexrow][@"intzbflbh"]];
    NSLog(@"searchdic==%@",dic);
    //公文查询
    ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"5" withTitle:[type isEqualToString:@"001"]?@"收文列表":@"发文列表" queryTerm:dic];
    listVC.searchDic=searchdic;
    [self.navigationController pushViewController:listVC animated:YES];
}
#pragma mark- 重置
- (void)toReset
{
    titleName.text =@"";
    official.text =@"";
    yearNum.text =@"";
    dateField.text = @"";
    companyField.text = @"";
    secretGradeField.text = @"普通秘密";
    emergencyGradeField.text = @"一般";
    startTimeField.text = @"";
    stopTimeField.text = @"";
}
#pragma mark- 年选择器
- (void)yearSelect
{
    [yearNum becomeFirstResponder];
}

#pragma mark- 查看收文
- (void)doReceive
{
    [self.receiveBtn setSelected:YES];
    swflImg.hidden=NO;
    
    [self.sendBtn setSelected:NO];
}
#pragma mark- 查看发文
- (void)doSend
{
    [self.receiveBtn setSelected:NO];
    swflImg.hidden=YES;
    [self.sendBtn setSelected:YES];
}
#pragma mark- 开始时间选择
- (void)startTimeSelect
{
    [startTimeField becomeFirstResponder];
}
#pragma mark- 结束时间选择
- (void)stopTimeSelect
{
    [stopTimeField becomeFirstResponder];
}
#pragma mark-----------收文分类---------
-(void)swflSelect{
    if (poplist.count==0) {
        [ztOAService getSwfl:@{@"intdwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh} Success:^(id result) {
            NSDictionary *resultInfo = [result objectFromJSONData];
            NSLog(@"list=%@",[resultInfo JSONString]);
            if ([resultInfo[@"root"][@"result"][@"object"] isKindOfClass:[NSArray class]]) {
                poplist =[[NSMutableArray alloc]initWithArray: resultInfo[@"root"][@"result"][@"object"]];
                _popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择收文分类"];
                _popview.sourceary=poplist;
                _popview.key=@"chrzbfl";
                _popview.selectRowIndex=indexrow;
                _popview.delegate=self;
                [_popview show];
            }
            
            
        } Failed:^(NSError *error) {
            
        }];
    }else
    {
        _popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择收文分类"];
        _popview.sourceary=poplist;
        _popview.key=@"chrzbfl";
        _popview.selectRowIndex=indexrow;
        _popview.delegate=self;
        [_popview show];
    }
   
}
#pragma mark--------------PopDelegate-------------------
-(void)getIndexRow:(int)selectrow key:(NSString *)key
{
    if ([key isEqualToString:@"chrzbfl"]) {
        indexrow =selectrow;
        swfltf.text=poplist[indexrow][@"chrzbfl"];
    }
}
#pragma mark - actionsheet delegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
    
    
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField==startTimeField||textField==stopTimeField) {
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker.datePickerMode=UIDatePickerModeDate;
        }
        if (textField==startTimeField&&stopTimeField.text.length>0) {
            datePicker.maximumDate=[ztOASmartTime strToDate1:stopTimeField.text andFormat:@"yyyy-MM-dd HH:mm"];
        }
        if (textField==stopTimeField&&startTimeField.text.length>0) {
            datePicker.minimumDate=[ztOASmartTime strToDate1:startTimeField.text andFormat:@"yyyy-MM-dd HH:mm"];
        }
        textField.inputView = datePicker;
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        if (textField==startTimeField) {
            okbt.tag=1000;
        }
        else if(textField==stopTimeField)
        {
            okbt.tag=1001;
        }
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt addTarget:self action:@selector(pickercancelSEL:) forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
    else if (textField==yearNum)
    {
        if (self.pickerDate == nil)
        {
            self.pickerDate = [[UIPickerView alloc]initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            pickerDate.showsSelectionIndicator = YES;
            pickerDate.dataSource = self;
            pickerDate.delegate = self;
            // 取当前年份。默认显示当前年
            NSDate* now = [NSDate date];
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
            NSDateComponents *dd = [cal components:unitFlags fromDate:now];
            int y = [dd year];
            [pickerDate selectRow:y -1900 inComponent:0 animated:YES];
        }
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleDefault;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIButton *okbt=[UIButton buttonWithType:UIButtonTypeCustom];
        okbt.tag=1998;
        [okbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [okbt setTitle:@"确定" forState:UIControlStateNormal];
        [okbt addTarget:self action:@selector(pickerStartDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
        okbt.frame=CGRectMake(10, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:okbt];
        UIButton *cancelbt=[UIButton buttonWithType:UIButtonTypeCustom];
        [cancelbt setTitleColor:MF_ColorFromRGB(36, 99, 195) forState:UIControlStateNormal];
        [cancelbt setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbt addTarget:self action:@selector(pickercancelSEL:) forControlEvents:UIControlEventTouchUpInside];
        cancelbt.frame=CGRectMake(W(keyboardDoneButtonView)-60, 0, 50, H(keyboardDoneButtonView));
        [keyboardDoneButtonView addSubview:cancelbt];
        
        textField.inputAccessoryView = keyboardDoneButtonView;
        textField.inputView = pickerDate;
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (swfltf==textField) {
        [self swflSelect];
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark 选择开始时间
-(void)pickerStartDoneClicked:(UIButton*)obj{
    NSLog(@"%@",obj);
    if (obj.tag==1000) {
        [startTimeField resignFirstResponder];
        NSDate *date=[datePicker date];
        startTimeField.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
    }
    else if (obj.tag==1001)
    {
        [stopTimeField resignFirstResponder];
        NSDate *date=[datePicker date];
        stopTimeField.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
    }else if (obj.tag==1998)
    {
        [yearNum resignFirstResponder];
        [self.yearNum setText:[NSString stringWithFormat:@"%@",[arrayYears objectAtIndex:[pickerDate selectedRowInComponent:0]]]] ; ;
    }
}
-(void)pickercancelSEL:(id)obj
{
    NSLog(@"%@",obj);
    [startTimeField resignFirstResponder];
    [stopTimeField resignFirstResponder];
    [yearNum resignFirstResponder];
    yearNum.text=@"";
}
#pragma mark-  返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
#pragma mark- 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayYears count];
}
#pragma mark- 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayYears objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.yearNum setText:[NSString stringWithFormat:@"%@",[arrayYears objectAtIndex:row]]] ;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
