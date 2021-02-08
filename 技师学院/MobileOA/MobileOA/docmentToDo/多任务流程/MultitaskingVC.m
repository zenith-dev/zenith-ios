//
//  MultitaskingVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 17/2/10.
//  Copyright © 2017年 xj. All rights reserved.
//

#import "MultitaskingVC.h"
#import "PopView.h"
#import "MultRwModel.h"
#import "MultFlowPersonVC.h"
#import "AddUserInfo.h"
@interface MultitaskingVC ()
@property (nonatomic,assign)NSInteger selectnum;
@property (nonatomic,strong)UITextView *chooselb;//选择
@property (nonatomic,strong)UILabel *bxmclb;
@property (nonatomic,strong)UITextView *brxztv;//选择的任务和人员

@end

@implementation MultitaskingVC
@synthesize intlcczlsh,gzrwlst,chooselb,selectnum,bxmclb,processOpr,multRwselectRylst,brxztv,responsibleManDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getrwsz];
    UILabel *xblabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64+5, 100, 30)];
    xblabel.text =@"下步任务:";
    xblabel.textAlignment = NSTextAlignmentLeft;
    xblabel.textColor = [UIColor blackColor];
    xblabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:xblabel];
    
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, xblabel.bottom, kScreenWidth-40, 40)];
    [bgImg setBackgroundColor:[UIColor clearColor]];
    [bgImg.layer setBorderWidth:1];
    [bgImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
    [bgImg setUserInteractionEnabled:YES];
    [self.view addSubview:bgImg];
    
    bxmclb=[[UILabel alloc]initWithFrame:CGRectMake(4, 0, bgImg.width-8, 40)];
    bxmclb.font=Font(14);
    bxmclb.text=@"===请选择===";
    [bgImg addSubview:bxmclb];
    bxmclb.width=bxmclb.width-40;
    UIButton *selectNextSetpBtn = [[UIButton alloc] initWithFrame:CGRectMake(bxmclb.right, 1, 40, 38)];
    [selectNextSetpBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    [selectNextSetpBtn addTarget:self action:@selector(selectChargeWay) forControlEvents:UIControlEventTouchUpInside];
    [selectNextSetpBtn setBackgroundColor:[UIColor clearColor]];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, 0, 1, selectNextSetpBtn.height);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
    [selectNextSetpBtn.layer addSublayer:bottomBorder];
    [bgImg addSubview:selectNextSetpBtn];
    bxmclb.userInteractionEnabled=YES;
    [bxmclb bk_whenTapped:^{
        [self selectChargeWay];
    }];
    
    UILabel *xbclrlb = [[UILabel alloc] initWithFrame:CGRectMake(20, bgImg.bottom+10, 100, 30)];
    xbclrlb.text =@"下步处理人:";
    xbclrlb.textAlignment = NSTextAlignmentLeft;
    xbclrlb.textColor = [UIColor blackColor];
    xbclrlb.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:xbclrlb];
    bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(20, xbclrlb.bottom, kScreenWidth-40, 40)];
    [bgImg setBackgroundColor:[UIColor clearColor]];
    [bgImg.layer setBorderWidth:1];
    [bgImg.layer setBorderColor:[[UIColor colorWithWhite:0.800 alpha:1.000] CGColor]];
    [bgImg setUserInteractionEnabled:YES];
    [self.view addSubview:bgImg];
    UILabel* clrlb=[[UILabel alloc]initWithFrame:CGRectMake(4, 0, bgImg.width-8, 40)];
    clrlb.font=Font(15);
    clrlb.text=@"===请选择===";
    [bgImg addSubview:clrlb];
    clrlb.width=clrlb.width-40;
    UIButton *selectNextRyBtn = [[UIButton alloc] initWithFrame:CGRectMake(clrlb.right, 1, 40, 38)];
    [selectNextRyBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    [selectNextRyBtn addTarget:self action:@selector(selectPerson) forControlEvents:UIControlEventTouchUpInside];
    [selectNextRyBtn setBackgroundColor:[UIColor clearColor]];
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0, 0, 1, selectNextSetpBtn.height);
    bottomBorder1.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000].CGColor;
    [selectNextRyBtn.layer addSublayer:bottomBorder1];
    [bgImg addSubview:selectNextRyBtn];
    bxmclb.userInteractionEnabled=YES;
    [bxmclb bk_whenTapped:^{
        [self selectPerson];
    }];
    brxztv =[[UITextView alloc]initWithFrame:CGRectMake(20, bgImg.bottom+10, kScreenWidth-40, kScreenHeight-90-(bgImg.bottom+10))];
    brxztv.font=Font(14);
    brxztv.textColor=[UIColor grayColor];
    [self.view addSubview:brxztv];
    NSMutableString *multstr=[[NSMutableString alloc]initWithFormat:@""];
    for (MultRwModel *multrwModel in multRwselectRylst) {
        NSString *rwstr=[NSString stringWithFormat:@"%@：%@\n\n\n",multrwModel.rwmc,multrwModel.xbrwryxm];
        [multstr appendFormat:@"%@",rwstr];
    }
    brxztv.text=multstr;
    //查询
    UIButton *searchBtn=[[UIButton alloc]initWithFrame:CGRectMake(15, kScreenHeight-80, (kScreenWidth-60)/2.0, 40)];
    [searchBtn bootstrapNoborderStyle:UIColorFromRGB(0x28b559) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    [searchBtn setTitle:@"重置" forState:UIControlStateNormal];
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(resetSEL:) forControlEvents:UIControlEventTouchUpInside];
    //重置
    UIButton*resetBtn=[[UIButton alloc]initWithFrame:CGRectMake(searchBtn.right+30, searchBtn.top, searchBtn.width, searchBtn.height)];
    [resetBtn bootstrapNoborderStyle:UIColorFromRGB(0xfaaa21) titleColor:[UIColor whiteColor] andbtnFont:Font(15)];
    [resetBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:resetBtn];
    [resetBtn addTarget:self action:@selector(okSEL:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
#pragma mark--------------重置---------
-(void)resetSEL:(UIButton*)sender{
    multRwselectRylst =[[NSMutableArray alloc]init];
    responsibleManDic=[[NSDictionary alloc]init];
    brxztv.text=@"";
}
#pragma mark--------------确定---------
-(void)okSEL:(UIButton*)sender
{
    if (self.callback) {
        self.callback(multRwselectRylst,responsibleManDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark---------------选择下步任务------------
-(void)selectChargeWay{
    PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择下步任务"];
    popview.sourceary=gzrwlst;
    popview.key=@"strgzrw";
    popview.selectRowIndex=selectnum;
    popview.callback=^(int selectrow,NSString *key){
        selectnum=selectrow;
        NSString *selectrwmc=gzrwlst[selectrow][@"strgzrw"];
        bxmclb.text= gzrwlst[selectrow][@"strgzrw"];
        BOOL existlst=NO;
        for (MultRwModel *multrwModel in multRwselectRylst) {
            if ([multrwModel.rwmc isEqualToString:selectrwmc]) {
                existlst=YES;
                break;
            }
        }
        if (existlst==NO) {
            MultRwModel *multrwModel=[[MultRwModel alloc]init];
            multrwModel.rwmc=selectrwmc;
            multrwModel.xbryAry=[[NSMutableArray alloc]init];
            multrwModel.storeDicts=[[NSMutableDictionary alloc]init];
            multrwModel.responsibleManDic=[[NSMutableDictionary alloc]init];
            multrwModel.intgzlclsh=gzrwlst[selectrow][@"intgzlclsh"];
            [multRwselectRylst addObject:multrwModel];
        }
    };
    [popview show];
}
#pragma mark----------------选择任务人员---------
-(void)selectPerson{
    if (multRwselectRylst.count==0) {
        [self showMessage:@"请选择下步任务"];
        return;
    }
    NSString *selectrwmc=gzrwlst[selectnum][@"strgzrw"];
    MultRwModel *selectmultrwModel;
    for (MultRwModel *multrwModel in multRwselectRylst) {
        if ([multrwModel.rwmc isEqualToString:selectrwmc]) {
            selectmultrwModel=multrwModel;
            break;
        }
    }
    MultFlowPersonVC *flowperson=[[MultFlowPersonVC alloc]init:@"请选择下步处理人" selectAry:selectmultrwModel.xbryAry storeDict:selectmultrwModel.storeDicts];
    flowperson.storeDict=selectmultrwModel.storeDicts;
    flowperson.intgzlclsh=selectmultrwModel.intgzlclsh;
    flowperson.processOpr=processOpr;
    [flowperson selectedPersonCallback:^(NSMutableArray *selectAry, NSMutableDictionary *storeDict) {
        selectmultrwModel.xbryAry =selectAry;
        selectmultrwModel.storeDicts=storeDict;
        NSMutableString *zrobj=[[NSMutableString alloc]init];
        NSMutableString *tempcontent=[[NSMutableString alloc]init];
        NSMutableString *tempintnewrylshlst=[[NSMutableString alloc]init];
        NSMutableString *tempintlcdylshlst=[[NSMutableString alloc]init];
        NSMutableString *tempintbzlst=[[NSMutableString alloc]init];
        NSMutableString *tempintbcbhlst=[[NSMutableString alloc]init];
        NSMutableString *tempstrzrrlxLst=[[NSMutableString alloc]init];
        NSMutableString *tempintgzlclshlst=[[NSMutableString alloc]init];
        NSString *xml;
        for (AddUserInfo *oamodel  in selectAry) {
            [tempcontent appendFormat:@"%@,",oamodel.strryxm];
            [tempstrzrrlxLst appendFormat:@"%@,",storeDict[@"strzrrlxLst"]];
            [tempintlcdylshlst appendFormat:@"0,"];
            [tempintnewrylshlst appendFormat:@"%@,",@(oamodel.intrylsh)];
            
            [tempintbzlst appendFormat:@"%@,",storeDict[@"intbzlst"]];
            [tempintbcbhlst appendFormat:@"%@,",storeDict[@"intbcbhlst"]];
            
            [zrobj appendFormat:@"%@",[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",@(oamodel.intrylsh),[processOpr objectForKey:@"zRdxlx"], oamodel.strryxm]];
            [tempintgzlclshlst appendFormat:@"%@,", storeDict[@"intgzlclshlst"]];
        }
        NSString *intnewrylshlst=@"";
        NSString *content=@"";
        NSString *intlcdylshlst=@"";
        NSString *intbzlst=@"";
        NSString *intbcbhlst=@"";
        NSString *strzrrlxLst=@"";
        NSString *intgzlclshlst=@"";
        if (selectAry.count>0) {
            strzrrlxLst=[tempstrzrrlxLst substringToIndex:tempstrzrrlxLst.length-1];
            intbcbhlst=[tempintbcbhlst substringToIndex:tempintbcbhlst.length-1];
            intbzlst=[tempintbzlst substringToIndex:tempintbzlst.length-1];
            intlcdylshlst=[tempintlcdylshlst substringToIndex:tempintlcdylshlst.length-1];
            intnewrylshlst=[tempintnewrylshlst substringToIndex:tempintnewrylshlst.length-1];
            content =[tempcontent substringToIndex:tempcontent.length-1];
            intgzlclshlst =[tempintgzlclshlst substringToIndex:tempintgzlclshlst.length-1];
        }
        selectmultrwModel.zrobj=zrobj;
        selectmultrwModel.xbrwryxm=[NSMutableString stringWithString:content];
        selectmultrwModel.intnewrylshlst=intnewrylshlst;
        selectmultrwModel.intlcdylshlst=intlcdylshlst;
        selectmultrwModel.intbzlst=intbzlst;
        selectmultrwModel.intbcbhlst=intbcbhlst;
        selectmultrwModel.strzrrlxLst=strzrrlxLst;
        selectmultrwModel.intgzlclshlst=intgzlclshlst;

        NSMutableString *multstr=[[NSMutableString alloc]init];
        NSMutableArray *multzrobj=[[NSMutableArray alloc]init];
        NSMutableArray *multintnewrylshlst=[[NSMutableArray alloc]init];
        NSMutableArray *multintlcdylshlst=[[NSMutableArray alloc]init];
        NSMutableArray *multintbzlst=[[NSMutableArray alloc]init];
        NSMutableArray *multintbcbhlst=[[NSMutableArray alloc]init];
        NSMutableArray *multstrzrrlxLst=[[NSMutableArray alloc]init];
        NSMutableArray *multintgzlclshlst=[[NSMutableArray alloc]init];
        for (MultRwModel *multrwModel in multRwselectRylst) {
            NSString *rwstr=[NSString stringWithFormat:@"%@：%@\n\n\n",multrwModel.rwmc,multrwModel.xbrwryxm];
            [multstr appendFormat:@"%@",rwstr];
            [multzrobj addObject:multrwModel.zrobj];
            [multintnewrylshlst addObject:multrwModel.intnewrylshlst];
            [multintlcdylshlst addObject:multrwModel.intlcdylshlst];
            [multintbcbhlst addObject:multrwModel.intbcbhlst];
            [multintbzlst addObject:multrwModel.intbzlst];
            [multstrzrrlxLst addObject:multrwModel.strzrrlxLst];
            [multintgzlclshlst addObject:multrwModel.intgzlclshlst];
        }
        brxztv.text=multstr;
        xml= [NSString stringWithFormat:@"%@<intnextgzrylsh>%@</intnextgzrylsh><intnextgzlclsh>%@</intnextgzlclsh><strzrrlxLst>%@</strzrrlxLst><strnextgzrylx>%@</strnextgzrylx><intrylshlst>%@</intrylshlst><intlcdylshlst>%@</intlcdylshlst><strlzlxlst>%@</strlzlxlst><strwcbz>%@</strwcbz><strbwcbzLst></strbwcbzLst><intbzlst>%@</intbzlst><intgzlclshlst>%@</intgzlclshlst><intbcbhlst>%@</intbcbhlst>",[multzrobj componentsJoinedByString:@""],storeDict[@"intnextgzrylsh"]?:@"",processOpr[@"intnextgzlclsh"],[multstrzrrlxLst componentsJoinedByString:@","],storeDict[@"strnextgzrylx"],[multintnewrylshlst componentsJoinedByString:@","],[multintlcdylshlst componentsJoinedByString:@","],[multintlcdylshlst componentsJoinedByString:@","],storeDict[@"strwcbz"],[multintbzlst componentsJoinedByString:@","],[multintgzlclshlst componentsJoinedByString:@","],[multintbcbhlst componentsJoinedByString:@","]];
        responsibleManDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",content,@"content",nil];
    }];
    [self.navigationController pushViewController:flowperson animated:YES];
}
#pragma mark----------------获取任务数组----------
-(void)getrwsz{
    [self network:@"document" requestMethod:@"getQuickbw" requestHasParams:@"true" parameter:@{@"intdwlsh":@(SingObj.unitInfo.intdwlsh),@"intlcczlsh":intlcczlsh} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            NSLog(@"%@",[rep mj_JSONString]);
            if ([rep[@"result"] intValue]==0) {
                gzrwlst =[[NSMutableArray alloc]initWithArray:rep[@"gzrw"]];
            }
        }
    }];
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
