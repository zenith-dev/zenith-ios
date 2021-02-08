//
//  LeaderSearchVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/28.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "LeaderSearchVC.h"
#import "ztOATextField.h"
#import "LeadershipVC.h"
@interface LeaderSearchVC()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UIScrollView       *infoView;
@property(nonatomic,strong)ztOATextField *titleName;//标题名
@property(nonatomic,strong)ztOATextField *leaderNamelb;//领导名称
@property(nonatomic,strong)ztOATextField *startTimelb;//开始日期
@property(nonatomic,strong)ztOATextField *endTimelb;//开始日期
@property(nonatomic,strong)UIDatePicker  *datePicker;//日期选择器
@property(nonatomic,strong)UIPickerView  *pickerview;
@property(nonatomic,strong)NSArray *leaderAry;//领导列表
@end

@implementation LeaderSearchVC
@synthesize infoView,titleName,leaderNamelb,startTimelb,endTimelb,datePicker,pickerview,leaderAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    leaderAry=[[NSArray alloc]init];
    self.view.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    infoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 40*6)];
    infoView.backgroundColor = [UIColor clearColor];
    infoView.contentSize = CGSizeMake(self.view.width, 40*6);
    infoView.backgroundColor = [UIColor clearColor];
    infoView.directionalLockEnabled = YES;
    infoView.showsHorizontalScrollIndicator = NO;
    infoView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:infoView];
    
    //标题
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"标      题:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    titleName = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80, 30)];
    [titleName setFont:[UIFont systemFontOfSize:14.0f]];
    titleName.returnKeyType = UIReturnKeyDone;
    [titleName setKeyboardType:UIKeyboardTypeDefault];
    titleName.backgroundColor = [UIColor whiteColor];
    [backImg addSubview:label];
    [backImg addSubview:titleName];
    float hight=backImg.bottom;
    //年号
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, hight, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"领      导:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    leaderNamelb = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    [leaderNamelb setFont:[UIFont systemFontOfSize:14.0f]];
    leaderNamelb.backgroundColor = [UIColor whiteColor];
    leaderNamelb.clearButtonMode=UITextFieldViewModeWhileEditing;
    leaderNamelb.delegate=self;
    [leaderNamelb setTextAlignment:NSTextAlignmentLeft];
    
    UIButton *upAndDownIcon = [[UIButton alloc] initWithFrame:CGRectMake(leaderNamelb.right, 5, 40, 30)];
    [upAndDownIcon setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn"] forState:UIControlStateNormal];
    [upAndDownIcon addTarget:self action:@selector(yearSelect) forControlEvents:UIControlEventTouchUpInside];
    [upAndDownIcon setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:label];
    [backImg addSubview:upAndDownIcon];
    [backImg addSubview:leaderNamelb];
    hight+=40;
    //开始时间
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, hight, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"开始时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    startTimelb = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    startTimelb.clearButtonMode=UITextFieldViewModeWhileEditing;

    [startTimelb setFont:[UIFont systemFontOfSize:14.0f]];
    startTimelb.placeholder=@"请选择开始时间";
    startTimelb.delegate=self;
    startTimelb.backgroundColor = [UIColor whiteColor];
    UIButton *startTimeBtn= [[UIButton alloc] initWithFrame:CGRectMake(startTimelb.right, 5, 40, 30)];
    [startTimeBtn setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn"] forState:UIControlStateNormal];
    [startTimeBtn addTarget:self action:@selector(startTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    [startTimeBtn setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:label];
    [backImg addSubview:startTimelb];
    [backImg addSubview:startTimeBtn];
    [startTimelb setUserInteractionEnabled:YES];
    hight+=40;
    //结束时间
    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, hight+10, self.view.width-20, 40)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setUserInteractionEnabled:YES];
    [self.infoView addSubview:backImg];
    label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
    label.text =@"结束时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    endTimelb = [[ztOATextField alloc] initWithFrame:CGRectMake(80, 5, backImg.width-80-40, 30)];
    endTimelb.placeholder=@"请选择结束时间";
    endTimelb.delegate=self;
    endTimelb.clearButtonMode=UITextFieldViewModeWhileEditing;
    [endTimelb setFont:[UIFont systemFontOfSize:14.0f]];
    endTimelb.backgroundColor = [UIColor whiteColor];
    UIButton *stopTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(endTimelb.right, 5, 40, 30)];
    [stopTimeBtn setBackgroundImage:[UIImage imageNamed:@"upAndDown_btn.png"] forState:UIControlStateNormal];
    [stopTimeBtn addTarget:self action:@selector(stopTimeSelect) forControlEvents:UIControlEventTouchUpInside];
    [stopTimeBtn setBackgroundColor:[UIColor clearColor]];
    [backImg addSubview:label];
    [backImg addSubview:endTimelb];
    [backImg addSubview:stopTimeBtn];
    [endTimelb setUserInteractionEnabled:YES];
    
    
    UIImage *searchBtnImg = [UIImage imageNamed:@"color_02"];
    UIImage *resetBtnImg = [UIImage imageNamed:@"color_03"];
    NSInteger leftCapWidth = searchBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = searchBtnImg.size.height * 0.5f;
    searchBtnImg = [searchBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    resetBtnImg = [resetBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, infoView.bottom+20, self.view.width/2-20, 40)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:searchBtnImg forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(toSearch) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton*resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2+10, infoView.bottom+20, self.view.width/2-20, 40)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resetBtn setBackgroundImage:resetBtnImg forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(toReset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [self.view addSubview:resetBtn];
    [self getrysyflbyrylshlst];
    // Do any additional setup after loading the view.
}
-(void)getrysyflbyrylshlst{
    [self showWaitView];
    NSDictionary *infodata=@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh};
    [ztOAService getrysyflbyrylshlst:infodata Success:^(id result) {
        [self closeWaitView];
        
        NSDictionary *dic = [result objectFromJSONData];
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0){
            leaderAry =[[NSArray alloc]initWithArray:dic[@"root"][@"fl"]];
        }
    } Failed:^(NSError *error) {
        [self closeWaitView];
    }];

}
#pragma mark----------查询-----------
-(void)toSearch{
    
    NSDate *startDate = [self stringToDate:[NSString stringWithFormat:@"%@",startTimelb.text?:@""]];
    NSDate *endDate = [self stringToDate:[NSString stringWithFormat:@"%@",endTimelb.text?:@""]];
    if ([[startDate earlierDate:endDate] isEqualToDate:endDate]) {
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"结束时间不能早于开始时间！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *dic=@{@"dtmfbsj1":startTimelb.text?:@"",@"dtmfbsj2":endTimelb.text?:@"",@"strflmc":leaderNamelb.text?:@""};
    LeadershipVC *leadership=[[LeadershipVC alloc]init];
    leadership.searchDic=dic;
    leadership.searchKey=titleName.text?:@"";
    leadership.title=@"领导讲话";
    [self.navigationController pushViewController:leadership animated:YES];
}
-(NSDate *)stringToDate:(NSString *)strTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strTime];
    return date;
}



#pragma mark-------------重置-----------
-(void)toReset{
    titleName.text=@"";
    leaderNamelb.text=@"";
    startTimelb.text=@"";
    endTimelb.text=@"";
    pickerview=nil;
    datePicker=nil;
}
#pragma mark- 选择领导名称----------------
- (void)yearSelect
{
    [leaderNamelb becomeFirstResponder];
}
#pragma mark-------------选择开始时间-------------
-(void)startTimeSelect
{
    [startTimelb becomeFirstResponder];
}
#pragma mark-------------选择结束时间----------
-(void)stopTimeSelect
{
    [endTimelb becomeFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==leaderNamelb) {
        if (!pickerview) {
            pickerview=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, 216)];
            pickerview.dataSource=self;
            pickerview.delegate=self;
        }
         textField.inputView = pickerview;
    }else if (textField==startTimelb||textField==endTimelb)
    {
        if (!datePicker) {
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            datePicker.backgroundColor=[UIColor lightGrayColor];
            [datePicker sizeToFit];
            datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
            datePicker.datePickerMode=UIDatePickerModeDate;
        }
        if (textField==startTimelb&&endTimelb.text.length>0) {
            datePicker.maximumDate=[ztOASmartTime strToDate1:endTimelb.text andFormat:@"yyyy-MM-dd HH:mm"];
        }
        if (textField==endTimelb&&startTimelb.text.length>0) {
            datePicker.minimumDate=[ztOASmartTime strToDate1:startTimelb.text andFormat:@"yyyy-MM-dd HH:mm"];
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
        if (textField==startTimelb) {
            okbt.tag=1000;
        }
        else if(textField==endTimelb)
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

}
#pragma mark 选择开始时间
-(void)pickerStartDoneClicked:(UIButton*)obj{
    NSLog(@"%@",obj);
    if (obj.tag==1000) {
        [startTimelb resignFirstResponder];
        NSDate *date=[datePicker date];
        startTimelb.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
    }
    else if (obj.tag==1001)
    {
        [endTimelb resignFirstResponder];
        NSDate *date=[datePicker date];
        endTimelb.text=[ztOASmartTime dateToStr:date andFormat:@"yyyy-MM-dd"];
    }
}
-(void)pickercancelSEL:(id)obj
{
    NSLog(@"%@",obj);
    [startTimelb resignFirstResponder];
    [endTimelb resignFirstResponder];
    [leaderNamelb resignFirstResponder];
    leaderNamelb.text=@"";
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return leaderAry.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return leaderAry[row][@"strflmc"];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    leaderNamelb.text=leaderAry[row][@"strflmc"];
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
