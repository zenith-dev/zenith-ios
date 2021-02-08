//
//  DocmentSearchVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/5.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "DocmentSearchVC.h"
#import "CTextField.h"
#import "SdmkListVC.h"
@interface DocmentSearchVC ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSMutableArray *arrayYears;
@property (nonatomic,strong)UIScrollView *docmentSrc;//分段控制器
@property (nonatomic,strong)UISegmentedControl *segmentCtrl;//分段控制器
@property (nonatomic,strong)CTextField *titleNametf;//标题名称
@property (nonatomic,strong)CTextField *gwztf;//公文字
@property (nonatomic,strong)CTextField *nhtf;//年号
@property (nonatomic,strong)CTextField *qhtf;//期号
@property (nonatomic,strong)CTextField *lwdwtf;//来文单位
@property (nonatomic,strong)CTextField *ksjstf;//开始时间
@property (nonatomic,strong)CTextField *jsjstf;//结束时间
@property (nonatomic,strong)UIPickerView *pickerDate;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)NSString *gwtype;//公文类型

@end

@implementation DocmentSearchVC
@synthesize type,docmentSrc,segmentCtrl,arrayYears,titleNametf,gwztf,nhtf,qhtf,lwdwtf,ksjstf,jsjstf,pickerDate,datePicker,gwtype;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate* nowDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:nowDate];
    int nowYear =(int)[dd year];
    arrayYears = [[NSMutableArray alloc] init];
    for (int i = nowYear-5;i <= nowYear;i++)
    {
        [arrayYears addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.view.backgroundColor = RGBCOLOR(234, 234, 234);
    docmentSrc =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-90)];
    docmentSrc.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:docmentSrc];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 70, 40)];
    label.text =@"公文类型";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    segmentCtrl =[[UISegmentedControl alloc]initWithItems:@[@"收文",@"发文"]];
    segmentCtrl.selectedSegmentIndex=0;
    gwtype=@"001";
    segmentCtrl.frame=CGRectMake(0, 0, 140, 30);
    segmentCtrl.right=kScreenWidth-15;
    segmentCtrl.centerY=label.centerY;
    [segmentCtrl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    [docmentSrc addSubview:segmentCtrl];
    
    //标题
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, label.bottom+15, 70, 40)];
    label.text =@"标    题";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    
    titleNametf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+15), label.height)];
    titleNametf.font=Font(14);
    titleNametf.backgroundColor=[UIColor whiteColor];
    titleNametf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [docmentSrc addSubview:titleNametf];
    //公文字
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, titleNametf.bottom+15, 70, 40)];
    label.text =@"公 文 字";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    gwztf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+15), label.height)];
    gwztf.font=Font(14);
    gwztf.backgroundColor=[UIColor whiteColor];
    gwztf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [docmentSrc addSubview:gwztf];
    
    float nhf=gwztf.bottom+15;
    if ([type isEqualToString:@"014"]) {
        //年号
        label = [[UILabel alloc] initWithFrame:CGRectMake(10,nhf, 70, 40)];
        label.text =@"年      号";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = Font(15);
        [docmentSrc addSubview:label];
        nhtf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+55), label.height)];
        nhtf.font=Font(14);
        nhtf.backgroundColor=[UIColor whiteColor];
        nhtf.delegate=self;
        nhtf.clearButtonMode=UITextFieldViewModeWhileEditing;
        [docmentSrc addSubview:nhtf];
        
        UIView *bview=[[UIView alloc]initWithFrame:CGRectMake(nhtf.right, nhtf.top, 40, 40)];
        [bview setBackgroundColor:[UIColor whiteColor]];
        UIImageView * imgeview=[[UIImageView alloc]initWithImage:PNGIMAGE(@"icon_arrow_down")];
        [imgeview setBackgroundColor:[UIColor whiteColor]];
        imgeview.center=CGPointMake(bview.width/2.0, bview.height/2.0);
        [bview addSubview:imgeview];
        [docmentSrc addSubview:bview];
        
        nhf=nhtf.bottom+15;
    }
    //期号
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, nhf, 70, 40)];
    label.text =@"期      号";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    qhtf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+15), label.height)];
    qhtf.font=Font(14);
    qhtf.backgroundColor=[UIColor whiteColor];
    qhtf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [docmentSrc addSubview:qhtf];
    
    //来文单位
//    label = [[UILabel alloc] initWithFrame:CGRectMake(10, qhtf.bottom+15, 70, 40)];
//    label.text =@"来文单位";
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = Font(15);
//    [docmentSrc addSubview:label];
//    lwdwtf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+15), label.height)];
//    lwdwtf.font=Font(14);
//    lwdwtf.backgroundColor=[UIColor whiteColor];
//    lwdwtf.clearButtonMode=UITextFieldViewModeWhileEditing;
//    [docmentSrc addSubview:lwdwtf];
//    //开始时间
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, qhtf.bottom+15, 70, 40)];
    label.text =@"开始时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    ksjstf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+55), label.height)];
    ksjstf.font=Font(14);
    ksjstf.delegate=self;
    ksjstf.backgroundColor=[UIColor whiteColor];
    ksjstf.clearButtonMode=UITextFieldViewModeWhileEditing;
    [docmentSrc addSubview:ksjstf];
    
    UIView * bview1=[[UIView alloc]initWithFrame:CGRectMake(ksjstf.right, ksjstf.top, 40, 40)];
    [bview1 setBackgroundColor:[UIColor whiteColor]];
    UIImageView* imgeview1=[[UIImageView alloc]initWithImage:PNGIMAGE(@"icon_arrow_down")];
    [imgeview1 setBackgroundColor:[UIColor whiteColor]];
    imgeview1.center=CGPointMake(bview1.width/2.0, bview1.height/2.0);
    [bview1 addSubview:imgeview1];
    [docmentSrc addSubview:bview1];
    
    //结束时间
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, ksjstf.bottom+15, 70, 40)];
    label.text =@"结束时间";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = Font(15);
    [docmentSrc addSubview:label];
    jsjstf =[[CTextField alloc]initWithFrame:CGRectMake(label.right+5, label.top, kScreenWidth-(label.right+55), label.height)];
    jsjstf.font=Font(14);
    jsjstf.delegate=self;
    jsjstf.backgroundColor=[UIColor whiteColor];
    jsjstf.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    UIView *bview2=[[UIView alloc]initWithFrame:CGRectMake(jsjstf.right, jsjstf.top, 40, 40)];
    [bview2 setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgeview2=[[UIImageView alloc]initWithImage:PNGIMAGE(@"icon_arrow_down")];
    [imgeview2 setBackgroundColor:[UIColor whiteColor]];
    imgeview2.center=CGPointMake(bview2.width/2.0, bview2.height/2.0);
    [bview2 addSubview:imgeview2];
    [docmentSrc addSubview:bview2];
    [docmentSrc addSubview:jsjstf];
    [docmentSrc setContentSize:CGSizeMake(kScreenWidth, jsjstf.bottom+20)];
    //查询
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, kScreenHeight-80, (kScreenWidth-60)/2.0, 40)];
    [searchBtn bootstrapNoborderStyle:UIColorFromRGB(0x28b559) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchSEL:) forControlEvents:UIControlEventTouchUpInside];
    
    //重置
    UIButton*resetBtn=[[UIButton alloc]initWithFrame:CGRectMake(searchBtn.right+30, searchBtn.top, searchBtn.width, searchBtn.height)];
    [resetBtn bootstrapNoborderStyle:UIColorFromRGB(0xfaaa21) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(resetSEL:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark---------change -----
-(void)change:(UISegmentedControl*)sender{
    if (sender.selectedSegmentIndex==0) {
        gwtype=@"001";
    }else if (sender.selectedSegmentIndex==1)
    {
        gwtype=@"002";
    }
}
#pragma mark-----------UITextFieldDelegate---------------
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==nhtf) {
        if (!pickerDate) {
            pickerDate = [[UIPickerView alloc]initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
            pickerDate.showsSelectionIndicator = YES;
            pickerDate.dataSource = self;
            pickerDate.delegate = self;
            [pickerDate selectRow:5 inComponent:0 animated:YES];
            NSDate* nowDate = [NSDate date];
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
            NSDateComponents *dd = [cal components:unitFlags fromDate:nowDate];
            int nowYear =(int)[dd year];
            nhtf.text=[NSString stringWithFormat:@"%@",@(nowYear)];
        }
        textField.inputView = pickerDate;
    }else if (textField==ksjstf||textField==jsjstf)
    {
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake((kScreenWidth-320)/2, 200, 320, 216)];
        datePicker.backgroundColor=[UIColor lightGrayColor];
        [datePicker sizeToFit];
        datePicker.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        datePicker.datePickerMode=UIDatePickerModeDate;
        if (textField==ksjstf&&jsjstf.text.length>0) {
            datePicker.maximumDate=[Tools strToDate:jsjstf.text andFormat:@"yyyy-MM-dd"];
        }
        if (textField==jsjstf&&ksjstf.text.length>0) {
            datePicker.minimumDate=[Tools strToDate:ksjstf.text andFormat:@"yyyy-MM-dd"];
        }
        textField.text=[Tools dateToStr:[datePicker date] andFormat:@"yyyy-MM-dd"];
        textField.inputView = datePicker;
        if (ksjstf==textField) {
            datePicker.tag=1;
        }else
        {
            datePicker.tag=2;
        }
        [datePicker bk_addEventHandler:^(UIDatePicker * sender) {
            if (sender.tag==1) {
                ksjstf.text=[Tools dateToStr:[datePicker date] andFormat:@"yyyy-MM-dd"];
            }else
            {
                jsjstf.text=[Tools dateToStr:[datePicker date] andFormat:@"yyyy-MM-dd"];
            }
        } forControlEvents:UIControlEventValueChanged];
    }
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
    [nhtf setText:[NSString stringWithFormat:@"%@",[arrayYears objectAtIndex:row]]] ;
}
#pragma mark--------------查询---------------
-(void)searchSEL:(UIButton*)sender
{
    if ([type isEqualToString:@"014"]||[type isEqualToString:@"015"]) {
        NSDictionary *searchdic=@{@"chrgwbt":titleNametf.text?:@"",
                                  @"chrgwz":gwztf.text?:@"",
                                  @"intgwnh":nhtf.text?:@"",
                                  @"intgwqh":qhtf.text?:@"",
                                  @"chrlwdwmc": lwdwtf.text?:@"",
                                  @"dtmdjsj1":ksjstf.text?:@"",
                                  @"dtmdjsj2":jsjstf.text?:@"",
                                  @"chrgwlb":gwtype,
                                  @"gwlx":[gwtype isEqualToString:@"001"]?@"1":@"0"};
        NSString *searchStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2><intgwnh>%@</intgwnh><gwlx>%@</gwlx></root>",
                         titleNametf.text?:@"",
                         gwztf.text?:@"",
                         qhtf.text?:@"",
                         gwtype,
                         lwdwtf.text?:@"",
                         @"",
                         @"",
                         ksjstf.text?:@"" ,
                         jsjstf.text?:@"",nhtf.text?:@"",[gwtype isEqualToString:@"001"]?@"1":@"0"];
        SdmkListVC *sdmklistvc=[[SdmkListVC alloc]initWithTitle:[gwtype isEqualToString:@"001"]?@"收文列表":@"发文列表"];
        sdmklistvc.type=type;
        sdmklistvc.searchBarStr=searchStr;
        sdmklistvc.searchDic=searchdic;
        [self.navigationController pushViewController:sdmklistvc animated:YES];
        
    }
}
#pragma mark--------------重置---------------
-(void)resetSEL:(UIButton*)sender
{
    titleNametf.text =@"";
    gwztf.text =@"";
    nhtf.text =@"";
    qhtf.text = @"";
    lwdwtf.text = @"";
    ksjstf.text = @"";
    jsjstf.text = @"";
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
