//
//  ztOADocFilterSearchViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-13.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOADocFilterSearchViewController.h"
#import "ztOATextField.h"
@interface ztOADocFilterSearchViewController ()
@property(nonatomic,strong)UIScrollView       *infoView;
//标题
@property(nonatomic,strong)ztOATextField  *titleName;
//公文字
@property(nonatomic,strong)ztOATextField  *official;
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
@property(nonatomic,strong)UIButton     *stopTimeBtn;

@property(nonatomic,strong)UIButton    *searchBtn;//查询按钮
@property(nonatomic,strong)UIButton    *resetBtn;//重置按钮

@property(nonatomic,strong)UIActionSheet *actionSheetView;

@property(nonatomic,strong)UIDatePicker  *datePicker;//日期选择器
@property(nonatomic,strong)UIView       *dateView;
@property(nonatomic, strong) UIToolbar          *timeToolBar;//时间工具条
@end

@implementation ztOADocFilterSearchViewController
@synthesize searchBtn,resetBtn;
@synthesize infoView,titleName,official,dateField,companyField,emergencyGradeField,secretGradeField,startTimeField,startTimeBtn,stopTimeField,stopTimeBtn;
@synthesize actionSheetView,datePicker,dateView;
@synthesize timeToolBar;
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
    self.title = @"筛选查询";
    self.view.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    self.infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,10, self.view.width, self.view.height-80)];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.directionalLockEnabled = YES;
    infoView.showsHorizontalScrollIndicator = YES;
    infoView.showsVerticalScrollIndicator = YES;
    infoView.delegate = self;
    [self.view addSubview:infoView];
    
    //标题
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"标       题";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.titleName = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
     titleName.placeholder=@"请输入标题";
    [titleName setFont:[UIFont systemFontOfSize:14.0f]];
    titleName.delegate = self;
    titleName.returnKeyType = UIReturnKeyDone;
    [titleName setKeyboardType:UIKeyboardTypeDefault];
    titleName.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:titleName];
    
    //公文字
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*1+10, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    //[backImg setImage:[UIImage imageNamed:@"center_bg_n"]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"公  文  字";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.official = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    official.placeholder=@"请输入公文字";
    [official setFont:[UIFont systemFontOfSize:14.0f]];
    official.delegate = self;
    official.returnKeyType = UIReturnKeyDone;
    [official setKeyboardType:UIKeyboardTypeDefault];
    official.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:official];
    
    //期号
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*2+10, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"期       号";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.dateField = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    self.dateField.placeholder=@"请输入期号";
    [dateField setFont:[UIFont systemFontOfSize:14.0f]];
    dateField.delegate = self;
    dateField.returnKeyType = UIReturnKeyDone;
    [dateField setKeyboardType:UIKeyboardTypeDefault];
    dateField.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:dateField];
    
    //开始时间
     backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*3+10, self.view.width-20, 40)];
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
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40*4+10, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    //[backImg setImage:[UIImage imageNamed:@"bottom_bg_n"]];
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

    infoView.contentSize = CGSizeMake(self.view.width, label.bottom);
    
    UIImage *searchBtnImg = [UIImage imageNamed:@"color_02"];
    UIImage *resetBtnImg = [UIImage imageNamed:@"color_03"];
    NSInteger leftCapWidth = searchBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = searchBtnImg.size.height * 0.5f;
    searchBtnImg = [searchBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    resetBtnImg = [resetBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];    
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.height-70, self.view.width/2-20, 40)];
    [searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:searchBtnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10, self.view.height-70, self.view.width/2-20, 40)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:resetBtnImg forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(toReset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:resetBtn];
    
    [self getFilterOldData];
    
}
//获取本地数据
- (void)getFilterOldData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //标题
    if ([userDefaults objectForKey:@"docSearchName"]!=nil) {
       titleName.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchName"]];
    }
    else
    {
        titleName.text =@"";
    }
    //公文字
    if ([userDefaults objectForKey:@"docSearchOffcial"]!=nil) {
        official.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchOffcial"]];
    }
    else
    {
        official.text =@"";
    }
    //期号
    if ([userDefaults objectForKey:@"docSearchDateNum"]!=nil) {
        dateField.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchDateNum"]];
    }
    else
    {
        dateField.text =@"";
    }
    //来文单位
    if ([userDefaults objectForKey:@"docSearchCompany"]!=nil) {
        companyField.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchCompany"]];
    }
    else
    {
        companyField.text =@"";
    }
    //开始时间
    if ([userDefaults objectForKey:@"docSearchStartTime"]!=nil) {
        startTimeField.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchStartTime"]];
    }
    else
    {
        startTimeField.text =@"";
    }
    //结束时间
    if ([userDefaults objectForKey:@"docSearchEndTime"]!=nil) {
        stopTimeField.text =[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"docSearchEndTime"]];
    }
    else
    {
        stopTimeField.text =@"";
    }
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
    NSDate *startDate = [self stringToDate:[NSString stringWithFormat:@"%@",startTimeField.text?:@""]];
    NSDate *endDate = [self stringToDate:[NSString stringWithFormat:@"%@",stopTimeField.text?:@""]];
    if ([[startDate earlierDate:endDate] isEqualToDate:endDate]) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"结束时间不能早于开始时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"%@",titleName.text?:@""],@"docSearchName",
                        [NSString stringWithFormat:@"%@",official.text?:@""],@"docSearchOffcial",
                        [NSString stringWithFormat:@"%@",dateField.text?:@""],@"docSearchDateNum",
                        [NSString stringWithFormat:@"%@",companyField.text?:@""],@"docSearchCompany",
                        [NSString stringWithFormat:@"%@",startTimeField.text?:@""],@"docSearchStartTime",
                        [NSString stringWithFormat:@"%@",stopTimeField.text?:@""],@"docSearchEndTime",nil];
    postNWithInfos(@"FILTERSEARCHDONE", nil, dic);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 重置
- (void)toReset
{
    titleName.text =@"";
    official.text =@"";
    dateField.text = @"";
    companyField.text = @"";
    startTimeField.text = @"";
    stopTimeField.text = @"";
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
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
#pragma mark textfield Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
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
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
    }
}
-(void)pickercancelSEL:(id)obj
{
    NSLog(@"%@",obj);
    [startTimeField resignFirstResponder];
    [stopTimeField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
