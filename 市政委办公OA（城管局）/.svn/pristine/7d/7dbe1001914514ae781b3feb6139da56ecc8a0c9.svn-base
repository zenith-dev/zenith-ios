//
//  ztMeetDetailVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/5.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztMeetDetailVC.h"
#import "ZMOFjView.h"
@interface ztMeetDetailVC ()<ZMOFjDelegate>
@property (nonatomic,strong)UIScrollView *meetScr;
@end

@implementation ztMeetDetailVC
@synthesize meetScr,datadic;
- (void)viewDidLoad {
    [super viewDidLoad];
    meetScr=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:meetScr];
    //标题
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-30, 21)];
    title.font=Font(16);
    title.numberOfLines=0;
    title.textAlignment=NSTextAlignmentCenter;
    title.text=datadic[@"strhymc"];
    CGSize titls=[title.text boundingRectWithSize:CGSizeMake(title.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:title.font} context:nil].size;
    title.height=title.height>titls.height?title.height:titls.height;
    [meetScr addSubview:title];
    
    //会议地点
    UILabel *ddlb=[[UILabel alloc]initWithFrame:CGRectMake(title.left, title.bottom+8, title.width, 21)];
    ddlb.font=Font(13);
    ddlb.textAlignment=NSTextAlignmentCenter;
    ddlb.textColor=[UIColor grayColor];
    ddlb.text=[NSString stringWithFormat:@"%@|%@",datadic[@"strlxr"],datadic[@"strdwjc"]];
    [meetScr addSubview:ddlb];
    
    //联系人
    UILabel *nomlb=[[UILabel alloc]initWithFrame:CGRectMake(15, ddlb.bottom+5, ddlb.width, 21)];
    nomlb.font=Font(14);
    nomlb.text=[NSString stringWithFormat:@"联系人：%@",datadic[@"strlxr"]];
    [meetScr addSubview:nomlb];
    nomlb=[[UILabel alloc]initWithFrame:CGRectMake(15, nomlb.bottom+5, nomlb.width, 21)];
    nomlb.font=Font(14);
    nomlb.text=[NSString stringWithFormat:@"联系电话：%@",datadic[@"strlxdh"]];
    [meetScr addSubview:nomlb];
    nomlb=[[UILabel alloc]initWithFrame:CGRectMake(15, nomlb.bottom+5, nomlb.width, 21)];
    nomlb.font=Font(14);
    nomlb.text=[NSString stringWithFormat:@"会议地址：%@",datadic[@"strhysmc"]];
    [meetScr addSubview:nomlb];
    nomlb=[[UILabel alloc]initWithFrame:CGRectMake(15, nomlb.bottom+5, nomlb.width, 21)];
    nomlb.font=Font(14);
    nomlb.text=[NSString stringWithFormat:@"会议开始时间：%@",datadic[@"dtmkssj"]];
    [meetScr addSubview:nomlb];
    nomlb=[[UILabel alloc]initWithFrame:CGRectMake(15, nomlb.bottom+5, nomlb.width, 21)];
    nomlb.font=Font(14);
    nomlb.text=[NSString stringWithFormat:@"会议结束时间：%@",datadic[@"dtmjssj"]];
    [meetScr addSubview:nomlb];
    //详情
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(5, nomlb.bottom+5, kScreenWidth-10, 0.5)];
    oneline.textColor=[UIColor lightGrayColor];
    [meetScr addSubview:oneline];
    UILabel *deatil=[[UILabel alloc]initWithFrame:CGRectMake(15, oneline.bottom+5, kScreenWidth-30, 21)];
    deatil.numberOfLines=0;
    deatil.font=Font(14);
    deatil.text=[NSString stringWithFormat:@"%@",datadic[@"strhynr"]];
    CGSize detailsize=[deatil.text boundingRectWithSize:CGSizeMake(deatil.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:deatil.font} context:nil].size;
    deatil.height=detailsize.height;
    [meetScr addSubview:deatil];
    //详情
    oneline=[[UILabel alloc]initWithFrame:CGRectMake(5, deatil.bottom+5, kScreenWidth-10, 0.5)];
    oneline.textColor=[UIColor lightGrayColor];
    [meetScr addSubview:oneline];
    //加载附件
    if ([datadic[@"hyfj"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithArray:datadic[@"hyfj"]];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, oneline.bottom+20, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet" andMethod:@"getHyfj" andClass:@"HyServices" andFjlshKey:@"inthyfjlsh" typeShow:@"1" andFjlshKeyStr:@"inthyfjlsh"];
        fjView.viewController = self;
        [meetScr addSubview:fjView];
        [meetScr setContentSize:CGSizeMake(meetScr.width, fjView.bottom)];
    }else if ([datadic[@"hyfj"] isKindOfClass:[NSDictionary class]]){
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithObjects:datadic[@"hyfj"],nil];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, oneline.bottom+20, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet" andMethod:@"getHyfj" andClass:@"HyServices" andFjlshKey:@"inthyfjlsh" typeShow:@"1" andFjlshKeyStr:@"inthyfjlsh"];
        fjView.viewController = self;
        [meetScr addSubview:fjView];
        [meetScr setContentSize:CGSizeMake(meetScr.width, fjView.bottom)];
    } else
    {
        [meetScr setContentSize:CGSizeMake(meetScr.width, oneline.bottom)];
    }
    // Do any additional setup after loading the view.
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
