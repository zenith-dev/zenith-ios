
//
//  LBPointJSdwViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/25.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBPointJSdwViewController.h"
#import "QRadioButton.h"
#import "LBrightImageButton.h"
#import "SHbsTableViewCell.h"
#import "BlockUI.h"
#import "LBpopView.h"
#import "LBChoosePersonViewController.h"
@interface LBPointJSdwViewController ()<QRadioButtonDelegate,UITableViewDelegate,UITableViewDataSource,LBpopDelegate,ChooseLxPersonDelegate>
{
    LBrightImageButton *gwzgbtn;
    UITableView *deptb;//选择部门
    NSMutableArray *deparry;//部门数组
    NSMutableArray *depcarry;//选择的部门数组
    NSMutableArray *msmxlist;//已经确定部门
    NSInteger depindex;
    NSMutableArray *fwmsarray;//发文模式
    NSInteger fwmindex;
    LBpopView *popView;
    UILabel *bmnumlb;
    NSString *fszjstr;//发送纸件
    NSString *strsmsset;
    NSString *defintmjbh;
}
@end

@implementation LBPointJSdwViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    depcarry=[[NSMutableArray alloc]init];
    deparry=[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self rightButton:@"保存" image:nil sel:@selector(saveSEL:)];
    [self setzdswdw];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
-(void)setzdswdw
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork setzdswdw:[_savedic objectForKey:@"intbzjllsh"] intgwlsh:[_savedic objectForKey:@"intgwlsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                fwmsarray=[[NSMutableArray alloc]init];
                [fwmsarray addObject:@{@"kname":@""}];
                [fwmsarray addObjectsFromArray:[[rep objectForKey:@"data"] objectForKey:@"dwzlst"]];
                defintmjbh=[[rep objectForKey:@"data"] objectForKey:@"intmjbh"];
                msmxlist=[[NSMutableArray alloc]initWithArray:[[rep objectForKey:@"data"] objectForKey:@"msmxlist"]];
                [self initview];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
    }];
}
#pragma mark-------------初始化界面---------------
-(void)initview
{
    UIView *views=[[UIView alloc]initWithFrame:CGRectMake(5, 5+64, kScreenWidth-10, 10)];
    [views setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:views];
    //短信提示
    NSString *dxts=@"短信提示:";
    UILabel *dxtslb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [dxts sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    dxtslb.textColor=[SingleObj defaultManager].mainColor;
    dxtslb.font=Font(14);
    dxtslb.text=dxts;
    //[views addSubview:dxtslb];
    
    QRadioButton *msgqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr.tag=1000;
    
    [msgqr setTitle:@"是" forState:0];
    msgqr.frame=CGRectMake(XW(dxtslb)+5, Y(dxtslb), 60,H(dxtslb));
    //[views addSubview:msgqr];
    
    QRadioButton *msgqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr1.tag=1001;
    msgqr1.checked=YES;
    [msgqr1 setTitle:@"否" forState:0];
    msgqr1.frame=CGRectMake(XW(msgqr)+10, Y(msgqr), W(msgqr),H(dxtslb));
    //[views addSubview:msgqr1];
    //line
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(dxtslb), W(views), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [views addSubview:oneline];
    
    //发文模式
    UILabel *fwmslb=[[UILabel alloc]initWithFrame:CGRectMake(5, YH(oneline), [dxts sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    fwmslb.textColor=[SingleObj defaultManager].mainColor;
    fwmslb.font=Font(14);
    fwmslb.text=@"发文模式:";
    [views addSubview:fwmslb];
    gwzgbtn=[[LBrightImageButton alloc]initWithFrame:CGRectMake(XW(fwmslb)+5, Y(fwmslb)+5, W(views)-(W(fwmslb)+10), H(fwmslb)-10)];
    ViewBorderRadius(gwzgbtn, 2, 1, [SingleObj defaultManager].lineColor);
    [gwzgbtn setImage:PNGIMAGE(@"turnopen") forState:0];
    [gwzgbtn setTitleColor:[UIColor blackColor] forState:0];
    gwzgbtn.titleLabel.font=Font(14);
    [gwzgbtn addTarget:self action:@selector(choosemodelSEL:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:gwzgbtn];
    //line
    UILabel *twoline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(fwmslb), W(views), 1)];
    [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [views addSubview:twoline];
    //发送纸件
    UILabel *fszjlb=[[UILabel alloc]initWithFrame:CGRectMake(X(fwmslb), YH(twoline), W(fwmslb), H(fwmslb))];
    fszjlb.textColor=[SingleObj defaultManager].mainColor;
    fszjlb.font=Font(14);
    fszjlb.text=@"发送纸件:";
    [views addSubview:fszjlb];
    
    QRadioButton *fszjqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"fszjqr"];
    fszjqr.tag=1000;
    [fszjqr setTitle:@"是" forState:0];
    fszjqr.frame=CGRectMake(XW(fszjlb)+5, Y(fszjlb), 60,H(fszjlb));
    [views addSubview:fszjqr];
    QRadioButton *fszjqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"fszjqr"];
    fszjqr1.tag=1001;
    fszjqr1.checked=YES;
    [fszjqr1 setTitle:@"否" forState:0];
    fszjqr1.frame=CGRectMake(XW(fszjqr)+10, Y(fszjqr), W(fszjqr),H(fszjlb));
    [views addSubview:fszjqr1];
    //line
    UILabel *threeline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(fszjlb), W(views), 1)];
    [threeline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [views addSubview:threeline];
    //请选择部门
    NSString *xzbmstr=@"请选择部门";
    UILabel *xzbmlb=[[UILabel alloc]initWithFrame:CGRectMake(X(fszjlb), YH(threeline), [xzbmstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(fszjlb))];
    xzbmlb.textColor=[SingleObj defaultManager].mainColor;
    xzbmlb.font=Font(14);
    xzbmlb.text=xzbmstr;
    [views addSubview:xzbmlb];
    //选择部门
    LBrightImageButton *xzbmbtn=[LBrightImageButton buttonWithType:UIButtonTypeCustom];
    xzbmbtn.frame=CGRectMake(XW(xzbmlb)+5, Y(xzbmlb), W(views)-(W(xzbmlb)+10+60), H(xzbmlb));
    [xzbmbtn setTitle:@"选择部门" forState:0];
    xzbmbtn.titleLabel.font=Font(14);
    [xzbmbtn setTitleColor:[UIColor blackColor] forState:0];
    [xzbmbtn addTarget:self action:@selector(choosedepSEL:) forControlEvents:UIControlEventTouchUpInside];
    [views addSubview:xzbmbtn];
    bmnumlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(xzbmbtn), Y(xzbmbtn), 60, H(xzbmbtn))];
    bmnumlb.textAlignment=NSTextAlignmentRight;
    bmnumlb.font=Font(14);
    bmnumlb.textColor=[UIColor blackColor];
    [views addSubview:bmnumlb];
    
    bmnumlb.text=[NSString stringWithFormat:@"%i",(int)(deparry.count+msmxlist.count)];
    
    //line
    UILabel *fourline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(xzbmlb), W(views), 1)];
    [fourline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [views addSubview:fourline];
    views.frame=CGRectMake(X(views), Y(views), W(views), YH(fourline));
    deptb=[[UITableView alloc]initWithFrame:CGRectMake(5,YH(views), W(views), kScreenHeight-(YH(views)))];
    deptb.delegate=self;
    deptb.dataSource=self;
    [deptb setBackgroundColor:[SingleObj defaultManager].backColor];
    deptb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:deptb];
    
}
-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([groupId isEqualToString:@"msg"]) {
        if (radio.tag==1000) {
            strsmsset=@"1";
        }
        else
        {
            strsmsset=@"0";
        }
    }
    else if ([groupId isEqualToString:@"fszjqr"])
    {
        if (radio.tag==1000) {
            fszjstr=@"发送纸件";
        }
        else if (radio.tag==1001)
        {
            fszjstr=@"没有发送纸质件";
        }
        [deptb reloadData];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return msmxlist.count;
    }
    else
    {
        return deparry.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    NSDictionary *dic;
    if (indexPath.section==0) {
        dic=[msmxlist objectAtIndex:indexPath.row];
    }
    else
    {
        dic=[deparry objectAtIndex:indexPath.row];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-10, 0)];
    [headerview setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:headerview];
    //单位名称
    UILabel *dwmclb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth-100, 40)];
    dwmclb.font=Font(14);
    dwmclb.text=[NSString stringWithFormat:@"%@-(%@)",indexPath.section==0?[dic objectForKey:@"strjsdwmc"]:[dic objectForKey:@"strdwjc"],fszjstr];
    dwmclb.textColor=[UIColor blackColor];
    [headerview addSubview:dwmclb];
    if (indexPath.section==1) {
        UIButton *deletbt=[UIButton buttonWithType:UIButtonTypeCustom];
        deletbt.frame=CGRectMake(W(headerview)-50, 0, 50, 40);
        [deletbt bootstrapNoborderStyle:[UIColor redColor] titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
        [deletbt setTitle:@"删除" forState:0];
        [deletbt handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
            [deparry removeObjectAtIndex:indexPath.row];//移除数据源的数据
            bmnumlb.text=[NSString stringWithFormat:@"%i",(int)(deparry.count+msmxlist.count)];
            [tableView reloadData];
        }];
        [headerview addSubview:deletbt];
    }
    else
    {
        if ([[dic objectForKey:@"strsccgbz"] intValue]==0) {
            UIButton *deletbt=[UIButton buttonWithType:UIButtonTypeCustom];
            deletbt.frame=CGRectMake(W(headerview)-50, 0, 50, 40);
            [deletbt bootstrapNoborderStyle:[UIColor redColor] titleColor:[UIColor whiteColor] andbtnFont:Font(14)];
            [deletbt setTitle:@"删除" forState:0];
            [deletbt handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
                [msmxlist removeObjectAtIndex:indexPath.row];//移除数据源的数据
                bmnumlb.text=[NSString stringWithFormat:@"%i",(int)(deparry.count+msmxlist.count)];
                [tableView reloadData];
            }];
            [headerview addSubview:deletbt];
        }
        
        
    }
    
    //横线
    UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, W(headerview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:oneline];
    headerview.frame=CGRectMake(0, 0, kScreenWidth, YH(oneline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}

-(void)choosemodelSEL:(UIButton*)sender
{
    if (!popView) {
        popView=[[LBpopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    popView.popType=@"fwms";
    popView.selectRowIndex=fwmindex;
    popView.delegate=self;
    popView.popArray=fwmsarray;
    popView.popTitle=@"请选择公文字号";
    [popView show];
    
}
-(void)getIndexRow:(int)indexrow warranty:(id)warranty
{
    if ([warranty isEqualToString:@"fwms"]) {
        fwmindex=indexrow;
        [gwzgbtn setTitle:[[fwmsarray objectAtIndex:indexrow] objectForKey:@"kname"] forState:0];
        if (indexrow==0) {
            deparry=[[NSMutableArray alloc]initWithArray:depcarry];
        }
        else
        {
            deparry=[[NSMutableArray alloc]initWithArray:[[fwmsarray objectAtIndex:indexrow] objectForKey:@"mxlst"]];
            [deparry addObjectsFromArray:depcarry];
            for (int i=0; i<msmxlist.count; i++) {
                NSDictionary *dic=[msmxlist objectAtIndex:i];
                for (int j=0; j<deparry.count; j++) {
                    NSDictionary *ddic=[deparry objectAtIndex:j];
                    if ([[dic objectForKey:@"strjsdwmc"] isEqualToString:[ddic objectForKey:@"strdwjc"]] ) {
                        [deparry removeObjectAtIndex:j];
                    }
                }
            }
        }
        bmnumlb.text=[NSString stringWithFormat:@"%i",(int)(deparry.count+msmxlist.count)];
        [deptb reloadData];
    }
}
#pragma mark--------------------选择部门---------------
-(void)choosedepSEL:(UIButton*)sender
{
    LBChoosePersonViewController *lbChoosePerson=[[LBChoosePersonViewController alloc]init];
    lbChoosePerson.title=@"请选择部门";
    lbChoosePerson.delegate=self;
    lbChoosePerson.lbs=sender;
    lbChoosePerson.type=@"部门";
    lbChoosePerson.gupid=@"多选";
    lbChoosePerson.qcheckary=deparry;
    [self.navigationController pushViewController:lbChoosePerson animated:YES];
}
-(void)setZrrValue:(NSMutableArray *)value andid:(id)lbs andGupID:(NSString *)gupid
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in value) {
        NSMutableDictionary *valudic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        [valudic setObject:defintmjbh forKey:@"intmjbh"];
        [array addObject:valudic];
    }
    [deparry addObjectsFromArray:array];
    
    NSMutableArray *n =[[NSMutableArray alloc]initWithArray:deparry];
    for (NSDictionary *msmxdic in msmxlist) {
        for (NSDictionary *dedic in n) {
            if ([[dedic objectForKey:@"strdwjc"] isEqualToString:[msmxdic objectForKey:@"strjsdwmc"]]) {
                [deparry removeObject:dedic];
            }
        }
    }
    bmnumlb.text=[NSString stringWithFormat:@"%i",(int)(deparry.count+msmxlist.count)];
    [deptb reloadData];
    
}
#pragma mark---------------------保存-------------------
-(void)saveSEL:(UIButton*)sender
{
    if (deparry.count==0&&msmxlist.count==0) {
        [Tools showMsgBox:@"请选择部门"];
        return;
    }
    NSMutableString *strjsdwmclst=[NSMutableString string];//接收单位名称串（以”,”分割）
    NSMutableString *strmjlst=[NSMutableString string];//公文的密级编号(用,号隔开)
    NSMutableString *strdzc=[NSMutableString string];//接收单位地址(多个以”,”分割)
    NSMutableString *intxzrlblst=[NSMutableString string];//接收人类别(多个以”,”分割，默认有多少个单位就有多少  传 0
    NSMutableString *strzcsbzlst=[NSMutableString string];//1：主送，0：抄送 传1
    NSMutableString *intfslst=[NSMutableString string];//接收单位份数串( 传1
    NSMutableString *strzjbzlst=[NSMutableString string];//[ 0:不发送1：发送纸件]
    NSString *strimset=@"0";
    NSString *strljfsbz=@"0";
    NSString *strisscbz=@"1";
    for (NSDictionary *dic in msmxlist) {
        [strjsdwmclst appendFormat:@"%@,",[dic objectForKey:@"strjsdwmc"]];
        [strmjlst appendFormat:@"%@,",[dic objectForKey:@"intmjbh"]];
        [strdzc appendFormat:@"%@,",[dic objectForKey:@"strjsdwdz"] ];
        [intxzrlblst appendFormat:@"0,"];
        [strzcsbzlst appendFormat:@"1,"];
        [intfslst appendFormat:@"1,"];
        [strzjbzlst appendFormat:@"%@,",[fszjstr isEqualToString:@"发送纸件" ]?@"1":@"0"];
    }
    for (NSDictionary *dic  in deparry) {
        [strjsdwmclst appendFormat:@"%@,",[dic objectForKey:@"strdwjc"]];
        [strmjlst appendFormat:@"%@,",[dic objectForKey:@"intmjbh"]];
        [strdzc appendFormat:@"%@,",[dic objectForKey:@"strdz"] ];
        [intxzrlblst appendFormat:@"0,"];
        [strzcsbzlst appendFormat:@"1,"];
        [intfslst appendFormat:@"1,"];
        [strzjbzlst appendFormat:@"%@,",[fszjstr isEqualToString:@"发送纸件" ]?@"1":@"0"];
    }
    
    strjsdwmclst=[NSMutableString stringWithFormat:@"%@",[strjsdwmclst substringToIndex:strjsdwmclst.length-1]];
    strmjlst=[NSMutableString stringWithFormat:@"%@",[strmjlst substringToIndex:strmjlst.length-1]];
    strdzc=[NSMutableString stringWithFormat:@"%@",[strdzc substringToIndex:strdzc.length-1]];
    intxzrlblst=[NSMutableString stringWithFormat:@"%@",[intxzrlblst substringToIndex:intxzrlblst.length-1]];

    strzcsbzlst=[NSMutableString stringWithFormat:@"%@",[strzcsbzlst substringToIndex:strzcsbzlst.length-1]];
    intfslst=[NSMutableString stringWithFormat:@"%@",[intfslst substringToIndex:intfslst.length-1]];
    strzjbzlst=[NSMutableString stringWithFormat:@"%@",[strzjbzlst substringToIndex:strzjbzlst.length-1]];
//    for (int i=0; i<deparry.count; i++) {
//        NSDictionary *dic=[deparry objectAtIndex:i];
//        if (deparry.count==1+i) {
//            [strjsdwmclst appendFormat:@"%@",[dic objectForKey:@"strdwjc"]];
//            [strmjlst appendFormat:@"%@",[dic objectForKey:@"intmjbh"]];
//            [strdzc appendFormat:@"%@",[dic objectForKey:@"strdz"] ];
//            [intxzrlblst appendFormat:@"0"];
//            [strzcsbzlst appendFormat:@"1"];
//            [intfslst appendFormat:@"1"];
//            [strzjbzlst appendFormat:@"%@",[fszjstr isEqualToString:@"发送纸件" ]?@"1":@"0"];
//        }
//        else
//        {
//            [strjsdwmclst appendFormat:@"%@,",[dic objectForKey:@"strdwjc"]];
//            [strmjlst appendFormat:@"%@,",[dic objectForKey:@"intmjbh"]];
//            [strdzc appendFormat:@"%@,",[dic objectForKey:@"strdz"] ];
//            [intxzrlblst appendFormat:@"0,"];
//            [strzcsbzlst appendFormat:@"1,"];
//            [intfslst appendFormat:@"1,"];
//            [strzjbzlst appendFormat:@"%@,",[fszjstr isEqualToString:@"发送纸件" ]?@"1":@"0"];
//        }
//    }
    [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
    [SHNetWork fwzdswdw:strjsdwmclst strmjlst:strmjlst strdzc:strdzc intgwlsh:[_savedic objectForKey:@"intgwlsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intxzrlblst:intxzrlblst strzcsbzlst:strzcsbzlst intfslst:intfslst strzjbzlst:strzjbzlst strfsdwdz:[_savedic objectForKey:@"strfsdwdz"] intfwdwlsh:[_savedic objectForKey:@"intfwdwlsh"] strfsrdwmc:[_savedic objectForKey:@"strfsrdwmc"] intfsrlsh:[_savedic objectForKey:@"intfsrlsh"] strfsrxm:[_savedic objectForKey:@"strfsrxm"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] strsmsset:strsmsset strimset:strimset strljfsbz:strljfsbz strisscbz:strisscbz completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
    }];
}
-(void)gogo{
    [self.navigationController popViewControllerAnimated:YES];
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
