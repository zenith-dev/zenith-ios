//
//  ztOAPublicationSearchViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-4.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAPublicationSearchViewController.h"
#import "ztOAPublicationSearchResultViewController.h"
@interface ztOAPublicationSearchViewController ()
@property(nonatomic,strong)UITextField *searchNum;//刊物号
@property(nonatomic,strong)UILabel *searchYearNum;//刊物年号
@property(nonatomic,strong)UITextField *searchDateNum;//刊物期号
@property(nonatomic,strong)UIButton    *searchBtn;//查询按钮
@property(nonatomic,strong)UIButton    *resetBtn;//重置按钮
@property(nonatomic,strong)UIPickerView *pickerDate;//时间选择器
@property(nonatomic,strong)UIView       *dateView;
@property(nonatomic,strong)NSMutableArray *arrayYears;
@property(nonatomic,strong)UIToolbar    *yearToolbar;
@end

@implementation ztOAPublicationSearchViewController
@synthesize searchNum,searchYearNum,searchDateNum;
@synthesize searchBtn,resetBtn;
@synthesize pickerDate,dateView;
@synthesize arrayYears;
@synthesize yearToolbar;
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
	
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
   // //self.appTitle.text = @"刊物查询";
    UIImageView *infoBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64+10, self.view.width-20, 150)];
    infoBackImg.backgroundColor = [UIColor whiteColor];
    [infoBackImg.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [infoBackImg.layer setBorderWidth:1];
    [infoBackImg setUserInteractionEnabled:YES];
    [self.view addSubview:infoBackImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 40)];
    label.text =@"目录    号:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.searchNum = [[UITextField alloc] initWithFrame:CGRectMake(80, 15, infoBackImg.width-80-25, 30)];
    [searchNum setFont:[UIFont systemFontOfSize:14.0f]];
    searchNum.returnKeyType = UIReturnKeyDone;
    searchNum.delegate = self;
    [searchNum setKeyboardType:UIKeyboardTypeDefault];
    searchNum.backgroundColor = [UIColor clearColor];
    [infoBackImg addSubview:label];
    [infoBackImg addSubview:searchNum];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 70, 40)];
    label.text =@"刊物年号:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.searchYearNum = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 60, 30)];
    [searchYearNum setFont:[UIFont systemFontOfSize:14.0f]];
    [searchYearNum setUserInteractionEnabled:YES];
    searchYearNum.backgroundColor = [UIColor clearColor];
    [searchYearNum setText:@""];
    [searchYearNum setTextAlignment:NSTextAlignmentLeft];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectYear)];
    gesture.delegate = self;
    [gesture setNumberOfTapsRequired:1];
    [searchYearNum addGestureRecognizer:gesture];
    
    UIImageView *upAndDownIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_down"]];
    upAndDownIcon.backgroundColor = [UIColor clearColor];
    upAndDownIcon.frame = CGRectMake(searchYearNum.right, 70, 20, 20);
    
    [searchYearNum setTextColor:[UIColor blackColor]];
    [infoBackImg addSubview:label];
    [infoBackImg addSubview:searchYearNum];
    [infoBackImg addSubview:upAndDownIcon];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 105, 70, 40)];
    label.text =@"刊物期号:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    self.searchDateNum = [[UITextField alloc] initWithFrame:CGRectMake(80, 115, infoBackImg.width-80-25, 30)];
    searchDateNum.delegate = self;
    searchDateNum.returnKeyType = UIReturnKeyDone;
    [searchDateNum setFont:[UIFont systemFontOfSize:14.0f]];
    [searchDateNum setKeyboardType:UIKeyboardTypeDefault];
    searchDateNum.backgroundColor = [UIColor clearColor];
    [infoBackImg addSubview:label];
    [infoBackImg addSubview:searchDateNum];
    
    
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 300, self.view.width/2-20, 40)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    
    self.resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10, 300, self.view.width/2-20, 40)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [resetBtn addTarget:self action:@selector(doReset) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    [self.view addSubview:resetBtn];
    
//    self.arrayYears = [[NSMutableArray alloc] init];
//    for (int i = 2009;i < 2014;i++)
//    {
//        [arrayYears addObject:[NSString stringWithFormat:@"%d",i]];
//    }
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
    
    
    if (self.dateView == nil)
    {
        self.dateView = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-240, 320, 240)];
        [dateView setBackgroundColor:MF_ColorFromRGB(211, 211, 211)];
        self.pickerDate = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 220-10)];
        pickerDate.showsSelectionIndicator = YES;
        pickerDate.dataSource = self;
        pickerDate.delegate = self;
        [self.dateView addSubview:pickerDate];
        
        // 取当前年份。默认显示当前年
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        int y = [dd year];
        //strSelectedYear = [NSString stringWithFormat:@"%d",y];
        [pickerDate selectRow:y -1900 inComponent:0 animated:YES];
        
        UIBarButtonItem *btnPickerPrev =	[[UIBarButtonItem alloc] initWithTitle:@"Prev" style:UIBarButtonItemStyleBordered target:self action:@selector(doPrev)];
        UIBarButtonItem *btnPickerNext =	[[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(doNext)];
        UIBarButtonItem *btnPickerOK =	[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doOK)];
        self.yearToolbar = [[UIToolbar alloc] init];
        [yearToolbar setFrame:CGRectMake(0, 0 , 320,30)];
        yearToolbar.barStyle = UIBarStyleBlack;
        yearToolbar.translucent = TRUE;
        yearToolbar.Items = @[btnPickerPrev,btnPickerNext,btnPickerOK];
        yearToolbar.alpha = 1.0;
        [self.dateView addSubview:yearToolbar];
    }
    [dateView setHidden:YES];
    [self.view addSubview:dateView];
}
#pragma mark - UIBarButtonItem事件 -
- (void)doPrev
{
    [self.dateView setHidden:YES];
    [self.searchNum becomeFirstResponder];
}
- (void)doNext
{
    [self.dateView setHidden:YES];
    [self.searchDateNum becomeFirstResponder];
}
- (void)doOK
{
    [self.dateView setHidden:YES];
}
//选择年
- (void)selectYear
{
    [searchNum resignFirstResponder];
    [searchDateNum resignFirstResponder];
    [self.dateView setHidden:NO];
}
//查询
- (void)doSearch
{    
    ztOAPublicationSearchResultViewController *resultVC = [[ztOAPublicationSearchResultViewController alloc] init];
    [self.navigationController pushViewController:resultVC animated:YES];
}
//重置
-(void)doReset
{
    searchNum.text = @"";
    searchYearNum.text =@"";
    searchDateNum.text = @"";
}
#pragma mark -textField delegate-
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.dateView setHidden:YES];
}
#pragma mark -picker delegate-
// 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayYears count];
}
// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrayYears objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSString *result = [pickerView pickerView:pickerView titleForRow:row forComponent:component];
    [searchYearNum setText:[NSString stringWithFormat:@"%@",[arrayYears objectAtIndex:row]]] ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
