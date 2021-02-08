//
//  ztWeekCalendarOAViewController.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/7.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztWeekCalendarOAViewController.h"
#import "ztWButton.h"
#import "MJRefresh.h"
#import "ztOAPopW.h"
#import "ztOAWcTableViewCell.h"
#import "ztAWeekcAddOAViewController.h"
#import "ztWeekcUpdateViewController.h"
@interface ztWeekCalendarOAViewController ()<UITableViewDelegate,UITableViewDataSource,OAPopDelegate>
{
    NSDate *newDate;
    NSString *startString;
    NSString *endString;
    MJRefreshHeaderView *header_doc;
    NSInteger index1row;//选择行
    NSArray *moweekary;//周
    NSMutableArray *tempary;
    NSMutableArray *dataary;//获取的数据
    BOOL fistLoad ;
}
@property(nonatomic,strong)UITableView *wctable;//每周日程列表
@property(nonatomic,strong)ztWButton *selePersonBtn;//选择人员
@property(nonatomic,strong)UILabel *rqlb;//日期
@property(nonatomic,strong)UIButton *nextwBtn;//下周
@property(nonatomic,strong)UIButton *upwBtn;//上周
@property(nonatomic,strong)NSString *intldid;//领导ID
@property(nonatomic,strong)NSMutableArray *ldary;//领导列表
@property(nonatomic,assign)int weekdate;
@property(nonatomic,strong)ztOAPopW *oapopw;
@end

@implementation ztWeekCalendarOAViewController
#pragma mark---------------Getter-----------------
-(ztWButton*)selePersonBtn
{
    if (!_selePersonBtn) {
        _selePersonBtn=[ztWButton buttonWithType:UIButtonTypeCustom];
        _selePersonBtn.frame=CGRectMake(0,64, 110, 40);
        [_selePersonBtn setImage:PNGIMAGE(@"icon_arrow_down") forState:UIControlStateNormal];
        [_selePersonBtn bootStrapBG:MF_ColorFromRGB(230, 230, 230) forState:UIControlStateNormal];
        _selePersonBtn.titleLabel.font=Font(14);
        [_selePersonBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selePersonBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_selePersonBtn addTarget: self action:@selector(selePersonBtnSEL:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selePersonBtn;

}
-(UILabel*)rqlb
{
    if (!_rqlb) {
        _rqlb=[[UILabel alloc]init];
        _rqlb.textColor=[UIColor blackColor];
        _rqlb.font=Font(14);
        [_rqlb setBackgroundColor:MF_ColorFromRGB(230, 230, 230)];
        _rqlb.adjustsFontSizeToFitWidth=YES;
        _rqlb.textAlignment=NSTextAlignmentCenter;
    }
    return _rqlb;
}
-(UIButton*)upwBtn
{
    if (!_upwBtn) {
        _upwBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_upwBtn setImage:PNGIMAGE(@"icon_arrow_left") forState:UIControlStateNormal];
        _upwBtn.tag=1000;
        
        [_upwBtn addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _upwBtn;
}

-(UIButton*)nextwBtn
{
    if (!_nextwBtn) {
        _nextwBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextwBtn setImage:PNGIMAGE(@"icon_arrow_right") forState:UIControlStateNormal];
       
         [_nextwBtn addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
        _nextwBtn.tag=1001;
    }
    return _nextwBtn;
}
-(UITableView*)wctable
{
    if (!_wctable) {
        _wctable=[[UITableView alloc]init];
        _wctable.separatorStyle=UITableViewCellSeparatorStyleNone;
        _wctable.delegate=self;
        _wctable.dataSource=self;
    }
    return _wctable;
}
-(ztOAPopW*)oapopw
{
    if (!_oapopw) {
        _oapopw=[[ztOAPopW alloc]initWithFrame:[UIScreen mainScreen].bounds a:@"请选择人员"];
        _oapopw.delegate=self;
    }
    return _oapopw;
}


#pragma mark-------------------改变日期--------------
-(void)changeWeek:(UIButton*)sender
{
   self.rightBtn=[self rightButton:@"今" Sel:@selector(getjSEL:)];
    [self dealDateWeek:sender.tag];
}
-(void)getjSEL:(UIButton*)sender
{
    self.weekdate=0;
    [self dealDateWeek:0];
    self.rightBtn.hidden=YES;
}
#pragma mark-----------处理日历-----------------
- (void)dealDateWeek:(int)i
{
    int currentWeek = 0;
    if (i==1000) {
        currentWeek=currentWeek-1;self.weekdate--;
    }
    else if(i==1001)
    {
        currentWeek=currentWeek+1;self.weekdate++;
    }
    else
    {
        newDate=[NSDate date];
        currentWeek = 0;
    }
    NSTimeInterval secondsPerDay1 = 24 * 60 * 60 * (abs(currentWeek)*7);
    if (currentWeek > 0)
    {
        newDate = [newDate dateByAddingTimeInterval:+secondsPerDay1];//目标时间
    }else{
        newDate = [newDate dateByAddingTimeInterval:-secondsPerDay1];//目标时间
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval - 1];
    }else {
        return;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM月dd日"];
    startString = [myDateFormatter stringFromDate:beginDate];
    endString = [myDateFormatter stringFromDate:endDate];
    NSLog(@"beginString:%@",startString);
    NSLog(@"endString:%@",endString);
    self.rqlb.text=[NSString stringWithFormat:@"%@-%@",startString,endString];
    tempary=[[NSMutableArray alloc]init];
    for (int i=0; i<7; i++) {
        NSTimeInterval haha = 24 * 60 * 60 * (abs(i));
        NSDate *getbegindate =[beginDate dateByAddingTimeInterval:haha];
        NSDateFormatter *myDateFormatte1r = [[NSDateFormatter alloc] init];
        [myDateFormatte1r setDateFormat:@"yyyy年MM月dd日"];
        NSString *rqstr = [myDateFormatte1r stringFromDate:getbegindate];
        [self updata:[moweekary objectAtIndex:i] rqstr:rqstr getbegindate:getbegindate isopen:NO];
    }
    NSLog(@"%@",[tempary JSONString]);
    [header_doc beginRefreshing];
}
#pragma mark--------------造数据----------
-(void)updata:(NSString*)weekstr rqstr:(NSString*)rqstr getbegindate:(NSDate*)getbegindate isopen:(BOOL)isopen
{
    int i=[ztOASmartTime compareOneDay:getbegindate withAnotherDay:[NSDate date]];
    NSDictionary *dic=@{@"weekstr":weekstr,@"rqstr":rqstr,@"isopen":[NSNumber numberWithBool:isopen],@"isafter":i>=0?[NSNumber numberWithBool:NO]:[NSNumber numberWithBool:YES]};
    [tempary addObject:dic];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    fistLoad =YES;
    moweekary=[[NSArray alloc]initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    [self.selePersonBtn setTitle:[ztOAGlobalVariable sharedInstance].username forState:UIControlStateNormal];
    self.upwBtn.frame=CGRectMake(self.selePersonBtn.right+1, self.selePersonBtn.top, 40, self.selePersonBtn.height);
    [self.upwBtn bootStrapBG:MF_ColorFromRGB(230, 230, 230) forState:UIControlStateNormal];
    self.rqlb.frame=CGRectMake(self.upwBtn.right, self.upwBtn.top, self.view.width-110-40-40, self.selePersonBtn.height);
    self.nextwBtn.frame=CGRectMake(self.rqlb.right, self.selePersonBtn.top, 40, self.selePersonBtn.height);
      [self.nextwBtn bootStrapBG:MF_ColorFromRGB(230, 230, 230) forState:UIControlStateNormal];
    
    self.wctable.frame=CGRectMake(0, self.selePersonBtn.bottom, self.view.width, self.view.height- self.selePersonBtn.bottom);
    [self.view addSubview:self.selePersonBtn];
    [self.view addSubview:self.upwBtn];
    [self.view addSubview:self.rqlb];
    [self.view addSubview:self.nextwBtn];
    [self.view addSubview:self.wctable];
    self.intldid=[ztOAGlobalVariable sharedInstance].intrylsh;
    self.weekdate=0;
    newDate = [NSDate date];
    [self addHeader];
    [self dealDateWeek:10002];
    // Do any additional setup after loading the view.
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.wctable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self getRcxx];
    };
    header_doc = header;
}

#pragma mark------------每周日程信息---------------
-(void)getRcxx
{
    NSDictionary *searchDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intlrrid",self.intldid,@"intldid",[NSString stringWithFormat:@"%i",self.weekdate],@"weekDate",fistLoad==YES?@"0":[[NSString stringWithFormat:@"%@",self.intldid] isEqualToString:[ztOAGlobalVariable sharedInstance].intrylsh]?@"1": @"2",@"czfwbz",nil];
     [self showWaitView];
     [ztOAService getRcxx:searchDic Success:^(id result) {
         [self closeWaitView];
         [header_doc endRefreshing];
         fistLoad=NO;
         NSDictionary *dic = [result objectFromJSONData];
         NSLog(@"list=%@",[dic JSONString]);
         if ([[[dic objectForKey:@"root"] objectForKey:@"bdlr"] isKindOfClass:[NSArray class]]) {
             self.ldary=[[NSMutableArray alloc]init];
             [self.ldary addObject:@{@"intldid":[ztOAGlobalVariable sharedInstance].intrylsh,@"chrldxm":[ztOAGlobalVariable sharedInstance].username}];
             [self.ldary addObjectsFromArray:[[dic objectForKey:@"root"] objectForKey:@"bdlr"]];
         }
         if ([[[dic objectForKey:@"root"] objectForKey:@"rcxx"] isKindOfClass:[NSArray class]]) {
              dataary=[[NSMutableArray alloc]initWithArray:[[dic objectForKey:@"root"] objectForKey:@"rcxx"]];
         }else
         {
              dataary=[[NSMutableArray alloc]initWithObjects:[[dic objectForKey:@"root"] objectForKey:@"rcxx"],nil];
         }
        
         [self.wctable reloadData];
     } Failed:^(NSError *error) {
         [self closeWaitView];
         [header_doc endRefreshing];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [alert show];
     }];
}
-(void)updata
{
    [self getRcxx];
}
#pragma mark----------------选择人员信息-------------
-(void)selePersonBtnSEL:(id)sender
{
    self.oapopw.popType=@"intldid";
    self.oapopw.selectRowIndex=index1row;
    self.oapopw.popArray=self.ldary;
    [self.oapopw show];
}
-(void)getIndexRow:(int)indexrow value:(id)value
{
    index1row=indexrow;
    NSDictionary *dic=[self.ldary objectAtIndex:indexrow];
    self.intldid =[dic objectForKey:@"intldid"];
    [self.selePersonBtn setTitle:[dic objectForKey:@"chrldxm"] forState:UIControlStateNormal];
    [header_doc beginRefreshing];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tempary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"ztOAWcTableViewCell";
    ztOAWcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *temdic=[tempary objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ztOAWcTableViewCell" owner:self options:nil][0];
    }
    NSString *rqstr = [temdic objectForKey:@"rqstr"];//获取日期
    NSMutableArray *rcxxary=[[NSMutableArray alloc]init];
    for (NSDictionary *datadic in dataary) {
         NSString *dtmtxrq=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:[datadic objectForKey:@"dtmkssj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy年MM月dd日"];
        if ([rqstr isEqualToString:dtmtxrq]) {
            [rcxxary addObject:datadic];
        }
    }
    NSLog(@"rcxxary==%@",[rcxxary JSONString]);
    cell.dataary=rcxxary;
    cell.weekdic =temdic;
    cell.weeklb.text=[temdic objectForKey:@"weekstr"];
    cell.rqlb.text=[temdic objectForKey:@"rqstr"];
    //判断时间是否过期
    if ([[cell.weekdic objectForKey:@"isafter"] boolValue]==YES) {
        [cell.addrcBtn setTitle:@"暂无日程" forState:UIControlStateNormal];
        if (rcxxary.count>0) {
            cell.addrcBtn.hidden=YES;
        }
    }
    //判断是否有日程
    if (cell.dataary.count>0) {
        cell.addrcBtn.frame=CGRectMake(cell.width-30-75, cell.icon_arrowview.top, 70, 24);
        cell.icon_arrowview.hidden=NO;
    }
    else
    {
        cell.addrcBtn.frame=CGRectMake(cell.width-75, cell.icon_arrowview.top, 70, 24);
        cell.icon_arrowview.hidden=YES;
    }
    [cell.addrcBtn bootStrapBG:MF_ColorFromRGB(235, 235, 235) forState:UIControlStateHighlighted];
    cell.addrcBtn.tag=indexPath.row+1000;
    [cell.addrcBtn addTarget:self action:@selector(addrcSEL:) forControlEvents:UIControlEventTouchUpInside];
    float hightcell=cell.rqlb.bottom+5;
    //加载日程
    if ([[cell.weekdic objectForKey:@"isopen"] boolValue]) {
        [cell.icon_arrowview setImage:PNGIMAGE(@"icon_arrow_up")];
        if (rcxxary.count>0) {
            UILabel *onelbs=[[UILabel alloc]initWithFrame:CGRectMake(0, hightcell, cell.width, 1)];hightcell+=1;
            [onelbs setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
            [cell addSubview:onelbs];
            for (int i=0;i<rcxxary.count; i++) {
                NSDictionary *rcxxdic=[rcxxary objectAtIndex:i];
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(5, hightcell+=5, cell.width-10, 20);
                [btn bootStrapBG:MF_ColorFromRGB(230, 230, 230) forState:UIControlStateNormal];
                btn.tag=indexPath.row*1000+i;
                [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIButton *sender) {
                    ztWeekcUpdateViewController *ztweekup=[[ztWeekcUpdateViewController alloc]init];
                    ztweekup.weekxxdic=rcxxdic;
                    ztweekup.isafter=[[cell.weekdic objectForKey:@"isafter"] boolValue];
                    ztweekup.strrq=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:rqstr andFormat:@"yyyy年MM月dd日"] andFormat:@"yyyy-MM-dd"];
                    ztweekup.title=@"每周日程";
                    [self.navigationController pushViewController:ztweekup animated:YES];
                }];
                NSMutableString *strjs=[NSMutableString string];
                if ([[rcxxdic objectForKey:@"dtmkssj"] length]!=0) {
                    [strjs appendFormat:@"%@",[[rcxxdic objectForKey:@"dtmkssj"] substringWithRange:NSMakeRange(11, 5)]];
                }
                if ([[rcxxdic objectForKey:@"dtmjssj"] length]!=0) {
                     [strjs appendFormat:@"-%@",[[rcxxdic objectForKey:@"dtmjssj"] substringWithRange:NSMakeRange(11, 5)]];
                }
                //日期
                UILabel *rqlb=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, [strjs sizeWithAttributes:@{NSFontAttributeName:Font(13)}].width, 20)];
                rqlb.font=Font(13);
                rqlb.textColor=[UIColor blackColor];
                rqlb.text=strjs;
                [btn addSubview:rqlb];
                //内容
                UILabel *nrlb=[[UILabel alloc]initWithFrame:CGRectMake(rqlb.right+5, rqlb.top, btn.width-(rqlb.right+10), 20)];
                nrlb.text=[NSString stringWithFormat:@"%@",[rcxxdic objectForKey:@"chrrcnr"]];
                nrlb.font=Font(13);
                nrlb.numberOfLines=0;
                nrlb.textColor=[UIColor blueColor];
                CGSize chrrcnr =[nrlb.text sizeWithFont:Font(13) constrainedToSize:CGSizeMake(nrlb.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                nrlb.frame=CGRectMake(X(nrlb), Y(nrlb), nrlb.width, chrrcnr.height>20?chrrcnr.height:20);
                [btn addSubview:nrlb];
                btn.frame=CGRectMake(X(btn), Y(btn), btn.width, nrlb.bottom+5);
                [cell addSubview:btn];
                hightcell+=(btn.height+5);
            }
        }
    }
    else
    {
        [cell.icon_arrowview setImage:PNGIMAGE(@"icon_arrow_down")];
    }
    cell.onelinelb.frame=CGRectMake(0, hightcell+5, kScreenWidth, 1);
    cell.frame=CGRectMake(X(cell), Y(cell), cell.width, YH(cell.onelinelb));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSMutableDictionary *temdic=[[NSMutableDictionary alloc]initWithDictionary:[tempary objectAtIndex:indexPath.row]];
    NSString *rqstr = [temdic objectForKey:@"rqstr"];//获取日期
    NSMutableArray *rcxxary=[[NSMutableArray alloc]init];
    for (NSDictionary *datadic in dataary) {
        NSString *dtmtxrq=[ztOASmartTime dateToStr:[ztOASmartTime strToDate1:[datadic objectForKey:@"dtmkssj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy年MM月dd日"];
        if ([rqstr isEqualToString:dtmtxrq]) {
            [rcxxary addObject:datadic];
        }
    }
    if (rcxxary.count>0) {
        [temdic setObject:[NSNumber numberWithBool:![[temdic objectForKey:@"isopen"] boolValue]] forKey:@"isopen"];
        [tempary replaceObjectAtIndex:indexPath.row withObject:temdic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark------------------新增---------------
-(void)addrcSEL:(UIButton*)sender
{
  NSLog(@"%i",sender.tag-1000);
    NSDictionary *dic =[tempary objectAtIndex:sender.tag-1000];
    ztAWeekcAddOAViewController *ztaweekaddoa=[[ztAWeekcAddOAViewController alloc]init];
    ztaweekaddoa.title=@"每周日程";
    ztaweekaddoa.ldxx=[self.ldary objectAtIndex:index1row];
    ztaweekaddoa.strrq=[dic objectForKey:@"rqstr"];
    [self.navigationController pushViewController:ztaweekaddoa animated:YES];
}
#pragma mark--------------修改或删除------------------
-(void)upxxSEL:(UIButton*)sender
{
    NSLog(@"%i",sender.tag);
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
