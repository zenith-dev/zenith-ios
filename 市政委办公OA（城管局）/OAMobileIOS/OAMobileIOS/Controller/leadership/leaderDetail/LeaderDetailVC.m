//
//  LeaderDetailVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "LeaderDetailVC.h"
#import "ZMOFjView.h"
@interface LeaderDetailVC ()<ZMOFjDelegate>
@property (nonatomic,strong)UIScrollView *infoScr;
@property (nonatomic,strong)UIButton *collBtn;//收藏按钮
@end

@implementation LeaderDetailVC
@synthesize datadic,infoScr,collBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (self.i_type==0) {
        [self showWaitView];
        [ztOAService getWzglxx:self.infodic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                self.datadic =dic[@"root"][@"wzgl"];
                [self leaderView];
             }
         }Failed:^(NSError *error)
         {
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
    else if (self.i_type==1)
    {
         collBtn =[self rightButton:nil imagen:@"btn_fav_no_n" imageh:nil sel:@selector(collectDocAction)];
         [collBtn setImage:PNGIMAGE(@"btn_fav_yes_n") forState:UIControlStateSelected];
    
        [self showWaitView];
        [ztOAService getZxzwxxxq:self.infodic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                 self.datadic=dic[@"root"][@"zxxx"];
                 if ([self.datadic[@"scts"] intValue]!=0) {
                     collBtn.selected=YES;
                 }
                 [self zwxxView];
             }
         }Failed:^(NSError *error)
         {
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
        // Do any additional setup after loading the view.
}
-(NSMutableAttributedString *)attributedStringWithHtml:(NSString *)html {
    html=[html stringByReplacingOccurrencesOfString:@"<img" withString:@"<a"];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:options documentAttributes:nil error:nil];
    return attrString;
}




-(void)leaderView{
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(15, 20+64, kScreenWidth-30, 18)];
    titlelb.font=BoldFont(17);
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.numberOfLines=0;
    titlelb.text=datadic[@"strzt"];
    [self.view addSubview:titlelb];
    CGSize titls=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlelb.height>titls.height?titlelb.height:titls.height;
    UILabel *timelb=[[UILabel alloc]initWithFrame:CGRectMake(20, titlelb.bottom+5, titlelb.width, 18)];
    timelb.textAlignment=NSTextAlignmentCenter;
    timelb.text=datadic[@"dtmfbsj"];
    timelb.textColor=[UIColor grayColor];
    [self.view addSubview:timelb];
    
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, timelb.bottom+19, kScreenWidth, 0.5)];
    [onelb setBackgroundColor:UIColorFromRGB(0xcacbcc)];
    [self.view addSubview:onelb];
     float fhight=onelb.bottom+10;
    //加载附件
    if ([datadic[@"xxwzfjb"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithArray:datadic[@"xxwzfjb"]];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, fhight, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServletProxy" andMethod:@"getXxwzfj" andClass:@"fzbgservices" andFjlshKey:@"intxxzxwzfjlsh" typeShow:@"1" andFjlshKeyStr:@"intxxzxwzfjlsh"];
        fjView.viewController = self;
        [self.view addSubview:fjView];
        fhight=fjView.bottom;
    }else if ([datadic[@"xxwzfjb"] isKindOfClass:[NSDictionary class]]){
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithObjects:datadic[@"xxwzfjb"],nil];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, onelb.bottom+20, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServletProxy" andMethod:@"getXxwzfj" andClass:@"fzbgservices" andFjlshKey:@"intxxzxwzfjlsh" typeShow:@"1" andFjlshKeyStr:@"intxxzxwzfjlsh"];
        fjView.viewController = self;
        [self.view addSubview:fjView];
        fhight=fjView.bottom;;
    }
    UIWebView *zwlb=[[UIWebView alloc]initWithFrame:CGRectMake(0, fhight, kScreenWidth, self.view.height-fhight)];
    if ([datadic[@"txtzw"] length]!=0) {
        [zwlb loadHTMLString:datadic[@"txtzw"] baseURL:nil];
    }else
    {
        [zwlb loadHTMLString:@"<p style=\"font-size: 14px\">(正文为空)</p>" baseURL:nil];
    }
    [self.view addSubview:zwlb];
}
-(void)zwxxView{
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(15, 20+64, kScreenWidth-30, 18)];
    titlelb.font=BoldFont(17);
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.numberOfLines=0;
    titlelb.text=datadic[@"strxxbt"];
    [self.view addSubview:titlelb];
    CGSize titls=[titlelb.text boundingRectWithSize:CGSizeMake(titlelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titlelb.font} context:nil].size;
    titlelb.height=titlelb.height>titls.height?titlelb.height:titls.height;
    UILabel *timelb=[[UILabel alloc]initWithFrame:CGRectMake(20, titlelb.bottom+5, titlelb.width, 18)];
    timelb.textAlignment=NSTextAlignmentCenter;
    timelb.text=datadic[@"dtmbssj"];
    timelb.textColor=[UIColor grayColor];
    [self.view addSubview:timelb];
    
    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, timelb.bottom+19, kScreenWidth, 0.5)];
    [onelb setBackgroundColor:UIColorFromRGB(0xcacbcc)];
    [self.view addSubview:onelb];
    float fhight=onelb.bottom+10;
    //加载附件
    if ([datadic[@"fj"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithArray:datadic[@"fj"]];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, fhight, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServletProxy" andMethod:@"getZxxxfjByXxfjlsh" andClass:@"kwservices" andFjlshKey:@"intxxbslsh" typeShow:@"1" andFjlshKeyStr:@"intxxbslsh"];
        fjView.viewController = self;
        [self.view addSubview:fjView];
        fhight=fjView.bottom;
    }else if ([datadic[@"fj"] isKindOfClass:[NSDictionary class]]){
        NSMutableArray *fjArray =[[NSMutableArray alloc]initWithObjects:datadic[@"fj"],nil];
        ZMOFjView *fjView ;
        fjView.delegate = self;
        [fjView.fjTableView setScrollEnabled:NO];
        fjView= [[ZMOFjView alloc] initWithFrame:CGRectMake(20, onelb.bottom+20, kScreenWidth-30, fjArray.count*44+20) data:fjArray isGg:NO jbxx:nil withUrl:[ztOAGlobalVariable sharedInstance].serviceIp andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServletProxy" andMethod:@"getZxxxfjByXxfjlsh" andClass:@"kwservices" andFjlshKey:@"intxxbslsh" typeShow:@"1" andFjlshKeyStr:@"intxxbslsh"];
        fjView.viewController = self;
        [self.view addSubview:fjView];
        fhight=fjView.bottom;
    }
    UIWebView *zwlb=[[UIWebView alloc]initWithFrame:CGRectMake(0, fhight, kScreenWidth, self.view.height-fhight)];
    if ([datadic[@"strzw"] length]!=0) {
        [zwlb loadHTMLString:datadic[@"strzw"] baseURL:nil];
    }else
    {
        [zwlb loadHTMLString:@"<p style=\"font-size: 14px\">(正文为空)</p>" baseURL:nil];
    }
    [self.view addSubview:zwlb];
}
#pragma mark------------进行收藏------------
-(void)collectDocAction{
    //取消收藏
    if (collBtn.selected==YES) {
        [self showWaitView];
        [ztOAService delxxgrscfj:self.infodic Success:^(id result)
         {
            [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                 collBtn.selected=!collBtn.selected;
             }
         }Failed:^(NSError *error)
         {
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }else
    {
        [self showWaitView];
        [ztOAService setxxgrscfj:self.infodic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                 collBtn.selected=!collBtn.selected;
             }
         }Failed:^(NSError *error)
         {
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
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
