//
//  LBAgentsDetailViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/11.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAgentsDetailViewController.h"
#import "LBAgentsSwitchViewController.h"
#import "SHbsTableViewCell.h"
#import "LBAgentsButton.h"
#import "UnderLineLabel.h"
#import "LBLoadFileViewController.h"
#import "LBAgentsOpinion.h"
#import "LBOpinionCzViewController.h"
#import "LBMakeNumViewController.h"
#import "LBAppointViewController.h"
#import "LBPointJSdwViewController.h"
#import "LBTransferred.h"
#import "LBBackOffice.h"
#import "LBSendLinderViewController.h"
#import "LBShuntViewController.h"
#import "LBAgentsViewController.h"
@interface LBAgentsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,OpinionDelegate,LBTransferredDelegate,LBBackOfficeDelegate,UIAlertViewDelegate>
{
    NSDictionary *agetsDetaildic;
    UIImageView *jtimge;
    UITableView *lbagetstb;
    NSMutableArray *licary;//流程列表
    NSMutableArray *aboutfileary;//关联文件
    NSMutableArray *fileary;//附件列表
    BOOL open;
    float seactionhight;
    NSMutableDictionary *flowEnddic;
    NSMutableDictionary *lryjdic;
}
@end
static NSInteger lryjInt;
@implementation LBAgentsDetailViewController
@synthesize detaildic,lstdic,optionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark-------------部门详情接口---------------------
-(void)getSwBumphInfo
{
    [SHNetWork getSwBumphInfo:[lstdic objectForKey:@"intgwlzlsh"] intbzjllsh:self.intbzjllsh completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                detaildic=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                [lbagetstb reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
    }];
}

#pragma mark----------------------------处理意见---------------------
-(void)getHandleOpinion
{
    [SHNetWork getHandleOpinion:[lstdic objectForKey:@"intgwlzlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
               self.optionary=[rep objectForKey:@"data"];
                [lbagetstb reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
        }
    }];
}


-(void)initview
{
    lbagetstb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight-64-40) style:UITableViewStyleGrouped];
    lbagetstb.showsVerticalScrollIndicator=NO;
    lbagetstb.dataSource=self;
    lbagetstb.delegate=self;
    [lbagetstb setBackgroundColor:[SingleObj defaultManager].backColor];
    lbagetstb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbagetstb];
    //[lbagetstb setTableHeaderView:[self tableHeader]];
}
-(UIView*)tableHeader
{
    UIView *mainscr=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    UIView *hwxxview=[[UIView alloc]initWithFrame:CGRectMake(5, 10, kScreenWidth-10, 0)];
    [hwxxview setBackgroundColor:[UIColor whiteColor]];
    [mainscr addSubview:hwxxview];
    //标题
    NSString *withStr=@"网站公开：";
    UILabel *btlb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [withStr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, 40)];
    btlb.font=Font(14);
    btlb.text=@"标题：";
    btlb.hidden=YES;
    btlb.textColor=[SingleObj defaultManager].mainColor;
    [hwxxview addSubview:btlb];
    UILabel *btzlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), Y(btlb), W(hwxxview)-2*X(btlb), H(btlb))];
    btzlb.font=Font(14);
    btzlb.textAlignment=NSTextAlignmentCenter;
    btzlb.text=[detaildic objectForKey:@"strgwbt"];
    btzlb.numberOfLines=0;
    CGSize btCgsizeFont =[btzlb.text boundingRectWithSize:CGSizeMake(W(btzlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
    //CGSize btCgsizeFont = [btzlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(btzlb), 200) lineBreakMode:NSLineBreakByWordWrapping];
    btzlb.frame=CGRectMake(X(btzlb), Y(btzlb), W(btzlb), H(btzlb)>btCgsizeFont.height?H(btzlb):btCgsizeFont.height+12);
    [hwxxview addSubview:btzlb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(btlb), W(hwxxview)-10, 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [hwxxview addSubview:oneline];
    //公文字号
    NSMutableString *gwzhstr=[NSMutableString string];
    if (![Tools isBlankString:[detaildic objectForKey:@"strgwzh"]])
    {
        [gwzhstr appendFormat:@"%@号",[detaildic objectForKey:@"strgwzh"]];
    }
    float hight=YH(oneline);
    if (![Tools isBlankString:gwzhstr]) {
        //公文字号
        UILabel *jbdzlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        jbdzlb.font=Font(14);
        jbdzlb.text=@"公文字号：";
        jbdzlb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:jbdzlb];
        UILabel *jbdzzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(jbdzlb), Y(jbdzlb), W(hwxxview)-(XW(jbdzlb))-5, H(btlb))];
        jbdzzlb.text=gwzhstr;
        jbdzzlb.adjustsFontSizeToFitWidth=YES;
        jbdzzlb.font=Font(14);
        [hwxxview addSubview:jbdzzlb];
        hight+=H(btlb);
        
        UILabel *twoline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(jbdzlb), W(hwxxview)-10, 1)];
        [twoline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:twoline];
        hight+=1;
    }
    //收文
    if ([[[lstdic objectForKey:@"strlzlx"] substringToIndex:3]isEqualToString:@"001"]) {
        //来文单位
        UILabel *lwdwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        lwdwlb.font=Font(14);
        lwdwlb.text=@"来文单位：";
        lwdwlb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:lwdwlb];
        UILabel *lwdwzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lwdwlb), Y(lwdwlb), W(hwxxview)-(XW(lwdwlb))-5, H(btlb))];
        lwdwzlb.text=[lstdic objectForKey:@"strlwdwmc"];
        lwdwzlb.adjustsFontSizeToFitWidth=YES;
        lwdwzlb.font=Font(14);
        [hwxxview addSubview:lwdwzlb];
        hight+=H(btlb);
        
        UILabel *lwdwline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(lwdwzlb), W(hwxxview)-10, 1)];
        [lwdwline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:lwdwline];
        hight+=1;
        //来文时间
        UILabel *lwsjlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        lwsjlb.font=Font(14);
        lwsjlb.text=@"来文时间：";
        lwsjlb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:lwsjlb];
        UILabel *lwsjzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(lwsjlb), Y(lwsjlb), W(hwxxview)-(XW(lwsjlb))-5, H(btlb))];
        lwsjzlb.text=[Tools dateToStr:[Tools strToDate:[detaildic objectForKey:@"dtmlwsj"] andFormat:@"yyyy-MM-dd HH:mm:ss"] andFormat:@"yyyy-MM-dd"];
        lwsjzlb.adjustsFontSizeToFitWidth=YES;
        lwsjzlb.font=Font(14);
        [hwxxview addSubview:lwsjzlb];
        hight+=H(btlb);
        
        UILabel *lwsjline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(lwsjzlb), W(hwxxview)-10, 1)];
        [lwsjline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:lwsjline];
        hight+=1;
        //公开方式
        UILabel *gkfslb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        hight+=H(btlb);
        gkfslb.font=Font(14);
        gkfslb.text=@"公开方式：";
        gkfslb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:gkfslb];
        NSString *gkfsstr=[[detaildic objectForKey:@"intgkfs"] intValue]==1?@"主动公开":[[detaildic objectForKey:@"intgkfs"] intValue]==2?@"依申请公开":@"不予公开";
        UILabel *gkfszlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gkfslb), Y(gkfslb), [gkfsstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(btlb))];
        gkfszlb.text=gkfsstr;
        gkfszlb.font=Font(14);
        [hwxxview addSubview:gkfszlb];
        
        if (![Tools isBlankString:[detaildic objectForKey:@"strnbjbmc"]]) {
            //查询范围
            UILabel *cxfwlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(gkfszlb), Y(gkfszlb), [@"查询范围：" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(gkfszlb))];
            cxfwlb.text=@"查询范围：";
            cxfwlb.textColor=[SingleObj defaultManager].mainColor;
            cxfwlb.font=Font(14);
            [hwxxview addSubview:cxfwlb];
            UILabel *ngrzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(cxfwlb), Y(cxfwlb), [[detaildic objectForKey:@"strnbjbmc"] sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(cxfwlb))];
            ngrzlb.font=Font(14);
            ngrzlb.text=[detaildic objectForKey:@"strnbjbmc"];
            [hwxxview addSubview:ngrzlb];
            UILabel *gkfsline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(gkfslb), W(hwxxview)-10, 1)];
            [gkfsline setBackgroundColor:[SingleObj defaultManager].lineColor];
            [hwxxview addSubview:gkfsline];
        }
        hight+=1;
        //内容摘要
        UILabel *linkfilelb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        linkfilelb.font=Font(14);
        linkfilelb.text=@"内容摘要：";
        linkfilelb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:linkfilelb];
        UILabel *linkfilezlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(linkfilelb), Y(linkfilelb)+12,W(hwxxview)-( XW(linkfilelb)+5), H(linkfilelb)-12)];
        linkfilezlb.font=Font(14);
        linkfilezlb.text=[detaildic objectForKey:@"txtnrty"];
        linkfilezlb.numberOfLines=0;
        CGSize linkfileFontSize =[linkfilezlb.text boundingRectWithSize:CGSizeMake(W(linkfilezlb), MAXFLOAT) options:1 << 5 | 1 << 0 | 1 << 1 attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
       // CGSize linkfileFontSize=[linkfilezlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(linkfilezlb), 500) lineBreakMode:NSLineBreakByWordWrapping];
        linkfilezlb.frame=CGRectMake(X(linkfilezlb), Y(linkfilezlb), W(linkfilezlb), linkfileFontSize.height);
        [hwxxview addSubview:linkfilezlb];
        hight+=(12+linkfileFontSize.height);
        
        UILabel *nrzyline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(linkfilezlb)+5, W(hwxxview)-10, 1)];
        [nrzyline setBackgroundColor:[SingleObj defaultManager].lineColor];
        hight+=1;
        [hwxxview addSubview:nrzyline];
    }
    else if ([[[lstdic objectForKey:@"strlzlx"] substringToIndex:3] isEqualToString:@"002"]) //发文
    {
        //拟稿人
        UILabel *ngbmlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        hight+=H(btlb);
        ngbmlb.font=Font(14);
        ngbmlb.text=@"拟稿人：";
        ngbmlb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:ngbmlb];
        UILabel *ngbmzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(ngbmlb), Y(ngbmlb), W(hwxxview)-(XW(ngbmlb)+5), H(btlb))];
        ngbmzlb.text=[NSString stringWithFormat:@"%@ %@",[detaildic objectForKey:@"strdjrcsmc"],[detaildic objectForKey:@"strjsrxm"]];
        ngbmzlb.font=Font(14);
        [hwxxview addSubview:ngbmzlb];
        
        UILabel *ngbmline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(ngbmlb), W(hwxxview)-10, 1)];
        [ngbmline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:ngbmline];
        hight+=1;
        //公开方式
        UILabel *webopenlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        hight+=H(btlb);
        webopenlb.font=Font(14);
        webopenlb.text=@"公开方式：";
        webopenlb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:webopenlb];
        NSString *gkfsstr=[[detaildic objectForKey:@"intgkfs"] intValue]==1?@"主动公开":[[detaildic objectForKey:@"intgkfs"] intValue]==2?@"依申请公开":@"不予公开";
        UILabel *webopenzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(webopenlb), Y(webopenlb), [gkfsstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(webopenlb))];
        webopenzlb.font=Font(14);
        webopenzlb.text=[[detaildic objectForKey:@"intgkfs"] intValue]==1?@"主动公开":[[detaildic objectForKey:@"intgkfs"] intValue]==2?@"依申请公开":@"不予公开";
        [hwxxview addSubview:webopenzlb];
        //缓急
        UILabel *cxfwlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(webopenzlb)+5, Y(webopenzlb), [@"缓急：" sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(webopenzlb))];
        cxfwlb.text=@"缓急：";
        cxfwlb.textColor=[SingleObj defaultManager].mainColor;
        cxfwlb.font=Font(14);
        [hwxxview addSubview:cxfwlb];
        UILabel *ngrzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(cxfwlb), Y(cxfwlb), 120-W(cxfwlb)-5, H(cxfwlb))];
        ngrzlb.font=Font(14);
        ngrzlb.text=[detaildic objectForKey:@"strhjcd"];
        [hwxxview addSubview:ngrzlb];
        
        UILabel *webopenline=[[UILabel alloc]initWithFrame:CGRectMake(X(webopenlb), YH(webopenlb), W(hwxxview)-10, 1)];
        hight+=1;
        [webopenline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:webopenline];
        //查询范围
        if (![Tools isBlankString:[detaildic objectForKey:@"strnbjbmc"]]) {
            UILabel *xcfwlb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
            hight+=H(btlb);
            xcfwlb.font=Font(14);
            xcfwlb.text=@"查询范围：";
            xcfwlb.textColor=[SingleObj defaultManager].mainColor;
            [hwxxview addSubview:xcfwlb];
            UILabel *xcfwzlb=[[UILabel alloc]initWithFrame:CGRectMake(XW(xcfwlb), Y(xcfwlb), [[detaildic objectForKey:@"strnbjbmc"] sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(btlb))];
            xcfwzlb.text=[detaildic objectForKey:@"strnbjbmc"];
            xcfwzlb.font=Font(14);
            [hwxxview addSubview:xcfwzlb];
            
            UILabel *xcfwline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), YH(xcfwlb), W(hwxxview)-10, 1)];
            [xcfwline setBackgroundColor:[SingleObj defaultManager].lineColor];
            [hwxxview addSubview:xcfwline];
        }
        hight+=1;
        if ([[detaildic objectForKey:@"glsw"] count]>0) {
            //关联文件
            UILabel *linkfilelb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
            linkfilelb.font=Font(14);
            linkfilelb.text=@"关联文件：";
            linkfilelb.textColor=[SingleObj defaultManager].mainColor;
            [hwxxview addSubview:linkfilelb];
            hight+=12;
            aboutfileary=[[NSMutableArray alloc]initWithArray:[detaildic objectForKey:@"glsw"]];
            for (int i=0; i<[[detaildic objectForKey:@"glsw"] count]; i++) {
                NSDictionary *aboutdetail=[[detaildic objectForKey:@"glsw"] objectAtIndex:i];
                UnderLineLabel *linkfilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(XW(linkfilelb), hight, W(hwxxview)-(XW(linkfilelb))-X(linkfilelb), H(webopenzlb)-12)];
                linkfilezlb.tag=1000+i;
                linkfilezlb.shouldUnderline=YES;
                linkfilezlb.font=Font(14);
                linkfilezlb.text=[aboutdetail objectForKey:@"strgwbt"];
                linkfilezlb.numberOfLines=0;
                CGSize linkfileFontSize=[linkfilezlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(linkfilezlb), 500) lineBreakMode:NSLineBreakByCharWrapping];
                linkfilezlb.frame=CGRectMake(X(linkfilezlb), Y(linkfilezlb), W(linkfilezlb), linkfileFontSize.height);
                
                [linkfilezlb setLineBreakMode:NSLineBreakByCharWrapping];
                NSMutableAttributedString *lineAttributed=[[NSMutableAttributedString alloc]initWithString:linkfilezlb.text];
                [lineAttributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [lineAttributed length])];
                [linkfilezlb setAttributedText:lineAttributed];
                [linkfilezlb addTarget:self action:@selector(aboutfile:)];
                [hwxxview addSubview:linkfilezlb];
                hight+=linkfileFontSize.height+5;
            }
            UILabel *linkline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(hwxxview)-10, 1)];
            [linkline setBackgroundColor:[SingleObj defaultManager].lineColor];
            [hwxxview addSubview:linkline];
        }
    }
    //附件
    UILabel *ffilelb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
    ffilelb.font=Font(14);
    ffilelb.text=@"附件：";
    ffilelb.numberOfLines=0;
    ffilelb.textColor=[SingleObj defaultManager].mainColor;
    [hwxxview addSubview:ffilelb];
    if ([[detaildic objectForKey:@"attachmentList"] count]>0) {
        hight+=12;
        fileary=[[NSMutableArray alloc]initWithArray:[detaildic objectForKey:@"attachmentList"]];
        for (int i=0; i<[[detaildic objectForKey:@"attachmentList"] count]; i++) {
            UnderLineLabel *lffilezlb=[[UnderLineLabel alloc]initWithFrame:CGRectMake(XW(ffilelb), hight,  W(hwxxview)-(XW(ffilelb))-5, H(btlb)-12)];
            lffilezlb.font=Font(14);
            lffilezlb.tag=1000+i;
            lffilezlb.shouldUnderline=YES;
            lffilezlb.text=[NSString stringWithFormat:@"%@(%@)",[[[detaildic objectForKey:@"attachmentList"] objectAtIndex:i] objectForKey:@"strfjmc"],[[[detaildic objectForKey:@"attachmentList"] objectAtIndex:i] objectForKey:@"fjlx"]];
            lffilezlb.numberOfLines=0;
            [lffilezlb setLineBreakMode:NSLineBreakByCharWrapping];
            CGSize lffileFontSize=[lffilezlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(lffilezlb), 500) lineBreakMode:NSLineBreakByCharWrapping];
            lffilezlb.frame=CGRectMake(X(lffilezlb), Y(lffilezlb), W(lffilezlb), lffileFontSize.height);
            
            NSMutableAttributedString *lineAttributed=[[NSMutableAttributedString alloc]initWithString:lffilezlb.text];
            [lineAttributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [lineAttributed length])];
            [lffilezlb setAttributedText:lineAttributed];
            
            
            [lffilezlb addTarget:self action:@selector(gotufile:)];
            [hwxxview addSubview:lffilezlb];
            hight+=lffileFontSize.height+5;
        }
    }
    else
    {
        hight+=H(btlb);
    }
    if (optionary.count>0) {
        UILabel *lffileline=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(hwxxview)-10, 1)];
        [lffileline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [hwxxview addSubview:lffileline];
        hight+=1;
        //处理信息
        UILabel *dealMsglb=[[UILabel alloc]initWithFrame:CGRectMake(X(btlb), hight, W(btlb), H(btlb))];
        dealMsglb.font=Font(14);
        dealMsglb.text=@"处理信息：";
        dealMsglb.textColor=[SingleObj defaultManager].mainColor;
        [hwxxview addSubview:dealMsglb];
        hight+=H(btlb);
        for (int i=0; i<[optionary count]; i++) {
            UILabel *dealMsglbzlb=[[UILabel alloc]initWithFrame:CGRectMake(X(dealMsglb), hight,  W(hwxxview)-2*X(dealMsglb), H(btlb)-12)];
            dealMsglbzlb.font=Font(14);
            dealMsglbzlb.tag=1000+i;
            dealMsglbzlb.text=[NSString stringWithFormat:@"%@:%@ %@",[[optionary objectAtIndex:i] objectForKey:@"strlrryxm"],[[optionary objectAtIndex:i] objectForKey:@"stryjnr"],[Tools isBlankString:[[optionary objectAtIndex:i] objectForKey:@"dtmclsj"]]?@"":[Tools dateToStr:[Tools strToDate:[[optionary objectAtIndex:i] objectForKey:@"dtmclsj"] andFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] andFormat:@"yyyy-MM-dd HH:mm"]];
            dealMsglbzlb.numberOfLines=0;
            CGSize dealMsgeFontSize=[dealMsglbzlb.text sizeWithFont:Font(14) constrainedToSize:CGSizeMake(W(dealMsglbzlb), 500) lineBreakMode:NSLineBreakByWordWrapping];
            dealMsglbzlb.frame=CGRectMake(X(dealMsglbzlb), Y(dealMsglbzlb), W(dealMsglbzlb), dealMsgeFontSize.height);
            [hwxxview addSubview:dealMsglbzlb];
            hight+=dealMsgeFontSize.height+5;
        }
        
    }
    UILabel *bordline=[[UILabel alloc]initWithFrame:CGRectMake(0, hight+4, W(hwxxview), 1)];
    [bordline setBackgroundColor:[SingleObj defaultManager].boderlineColor];
    [hwxxview addSubview:bordline];
    hwxxview.frame=CGRectMake(X(hwxxview), Y(hwxxview), W(hwxxview), YH(bordline));
    mainscr.frame=CGRectMake(X(mainscr), Y(mainscr), W(mainscr), YH(hwxxview));
    return mainscr;
   seactionhight =YH(mainscr);
}
#pragma mark---------------关联文件--------------
-(void)aboutfile:(UIControl*)file
{
     NSDictionary *dic = [aboutfileary objectAtIndex:file.tag-1000];
    LBAgentsSwitchViewController *lbagentsdetail=[[LBAgentsSwitchViewController alloc]init];
    NSMutableDictionary *gwdic=[[NSMutableDictionary alloc]initWithDictionary:dic];
    [gwdic setObject:@"公文详情" forKey:@"strgzrwmc"];
    [gwdic setObject:[lstdic objectForKey:@"strlwdwmc"] forKey:@"strlwdwmc"];
    lbagentsdetail.lstdic=gwdic;
    lbagentsdetail.isshow=YES;
    lbagentsdetail.intgwlzlsh=[dic objectForKey:@"intgldxpk"];
    lbagentsdetail.intbzjllsh=@"";
    lbagentsdetail.title=@"公文详情";
    [self.nav pushViewController:lbagentsdetail animated:YES];

}


-(void)gotufile:(UIControl*)file
{
    NSDictionary *dic = [fileary objectAtIndex:file.tag-1000];
    LBLoadFileViewController *lbloadfile=[[LBLoadFileViewController alloc]init];
    lbloadfile.title=[dic objectForKey:@"strfjmc"];
    NSRange range = [[dic objectForKey:@"strfjmc"] rangeOfString:@"."options:NSBackwardsSearch];
    NSString *suffix=[[dic objectForKey:@"strfjmc"] substringFromIndex:range.length+range.location];
    NSLog(@"%@",suffix);
    if (([suffix isEqualToString:@"docx"]||[suffix isEqualToString:@"pptx"]||[suffix isEqualToString:@"xlsx"])) {
        lbloadfile.isx=YES;
    }
    lbloadfile.shopurl=[dic objectForKey:@"url"];
    [[SingleObj defaultManager].rootnav pushViewController:lbloadfile animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *sectionView=[self tableHeader];
    return H(sectionView);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self tableHeader];
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
        [cell setBackgroundColor:[SingleObj defaultManager].backColor];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth-10, 0)];
    [headerview setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:headerview];
    if (self.isshow==NO) {
        //选择处理流程
        UILabel *deallb=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, kScreenWidth-10, 40)];
        deallb.font=Font(14);
        deallb.textColor=[SingleObj defaultManager].subtitleColor;
        deallb.text=@"选择处理方式";
        [headerview addSubview:deallb];
        UIView *choosedealview=[[UIView alloc]initWithFrame:CGRectMake(X(deallb), YH(deallb), W(deallb), H(deallb))];
        [choosedealview setBackgroundColor:[UIColor whiteColor]];
        [headerview addSubview:choosedealview];
        UILabel *cl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, W(choosedealview)-17, H(choosedealview)-1)];
        cl.text=@"请选择处理方式";
        cl.font=Font(14);
        cl.textAlignment=NSTextAlignmentCenter;
        [choosedealview addSubview:cl];
        jtimge=[[UIImageView alloc]initWithFrame:CGRectMake(cl.center.x+[cl.text sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width/2.0+5, 0, 17, H(cl))];
        if (open) {
            [jtimge setImage:PNGIMAGE(@"close")];
        }else
        {
            [jtimge setImage:PNGIMAGE(@"open")];
        }
        jtimge.contentMode=UIViewContentModeScaleAspectFit;
        [choosedealview addSubview:jtimge];
        UILabel *bordline1=[[UILabel alloc]initWithFrame:CGRectMake(0, H(choosedealview)-1, W(choosedealview), 1)];
        [bordline1 setBackgroundColor:[SingleObj defaultManager].boderlineColor];
        [choosedealview addSubview:bordline1];
        if (open) {
            float w=W(choosedealview)/2.0;
            float k=YH(bordline1);
            float xb=0;
            for (int i=0; i<licary.count; i++) {
                if (i!=0&&i%2==0) {
                    k+=40;
                    UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(5, k, W(choosedealview)-10, 1)];
                    [onelb setBackgroundColor:[SingleObj defaultManager].lineColor];
                    [choosedealview addSubview:onelb];
                    k+=1;
                    xb=0;
                }
                NSDictionary *dic=[licary objectAtIndex:i];
                LBAgentsButton *lbagets=[self getLbagetsButton:[dic objectForKey:@"stranbt"] width:w tags:i+1000];
                lbagets.frame=CGRectMake(xb, k, w, 40);
                xb+=w;
                [choosedealview addSubview:lbagets];
            }
            choosedealview.frame=CGRectMake(X(choosedealview), Y(choosedealview), W(choosedealview), k+41);
        }
        //横线
        UIImageView *oneline=[[UIImageView alloc]initWithFrame:CGRectMake(0, YH(choosedealview), W(headerview), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [headerview addSubview:oneline];
        headerview.frame=CGRectMake(0, 0, kScreenWidth, YH(oneline));
    }
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
-(LBAgentsButton*)getLbagetsButton:(NSString*)title width:(float)width tags:(int)tags
{
    UIImage *img= [Tools buttonImageFromColor:[SingleObj defaultManager].mainColor :CGRectMake(0, 0, 5, 5)];
    LBAgentsButton *lbagentsbtn=[[LBAgentsButton alloc]initWithFrame:CGRectMake(0, 0, width, 40)];
    [lbagentsbtn setTitle:title forState:UIControlStateNormal];
    lbagentsbtn.titleLabel.adjustsFontSizeToFitWidth=YES;
    lbagentsbtn.titleLabel.font=Font(14);
    [lbagentsbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [lbagentsbtn setImage:img forState:UIControlStateNormal];
    ViewRadius(lbagentsbtn.imageView, H(lbagentsbtn.imageView)/2.0);
    lbagentsbtn.tag=tags;
    [lbagentsbtn addTarget:self action:@selector(chooseTagrs:) forControlEvents:UIControlEventTouchUpInside];
    return lbagentsbtn;
    
}
#pragma mark-------------选择流程项目-------------
-(void)chooseTagrs:(UIButton*)sender
{
    NSDictionary *lcdic=[licary objectAtIndex:sender.tag-1000];
    if ([[lcdic objectForKey:@"strsfioscz"] intValue]==0) {
        [Tools showMsgBox:@"此功能请在电脑上操作"];
        return;
    }
    for (NSDictionary *dic in licary) {
        if ([[dic objectForKey:@"isyx"] intValue]==1&&[[lcdic objectForKey:@"isyx"] intValue]==0) {
            NSString *alertstr=[NSString stringWithFormat:@"请先%@",[dic objectForKey:@"stranbt"]];
            [Tools showMsgBox:alertstr];
            return;
        }
    }
    int lcint=[[lcdic objectForKey:@"intact"] intValue];
    if (lcint==3||lcint==8||lcint==9||lcint==18||lcint==19||lcint==20||lcint==26||lcint==54||lcint==55||lcint==56||lcint==57||lcint==58||lcint==68) {//填写意见
        lryjdic=[[NSMutableDictionary alloc]initWithDictionary:lcdic];
        lryjInt=sender.tag-1000;
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork getOpinion:[lstdic objectForKey:@"intbzjllsh"] intact:[lcdic objectForKey:@"intact"] completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",rep);
                NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
                [saveDic setObject:[[rep objectForKey:@"data"] objectForKey:@"intclyjlsh"]==nil?@"0":[[rep objectForKey:@"data"] objectForKey:@"intclyjlsh"] forKey:@"intclyjlsh"];//处理意见流水号：第一次意见为0
                [saveDic setObject:[lcdic objectForKey:@"intact"] forKey:@"intact"];//操作号
                [saveDic setObject:[detaildic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];//公文流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"chrlrryxm"];//录入人员姓名
                [saveDic setObject:[lcdic objectForKey:@"stryjbh"] forKey:@"intyjbh"];
                 //意见编号
                [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
                [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
                
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intlrrylsh"];//实际人员流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intrylsh"];//人员流水号
                [SVProgressHUD dismiss];
                LBAgentsOpinion *lbagetnsOpinion=[[LBAgentsOpinion alloc]initWithFrame:[UIScreen mainScreen].bounds opiniontitle:[lcdic objectForKey:@"stranbt"]];
                lbagetnsOpinion.nav=self.nav;
                lbagetnsOpinion.savedic=saveDic;
                lbagetnsOpinion.opinionDelegate=self;
                lbagetnsOpinion.opintondic=[rep objectForKey:@"data"];
                [lbagetnsOpinion show];
                
            }else
            {
                [SVProgressHUD showInfoWithStatus:emsg];
            }
        }];
        
    }
    else if(lcint==5||lcint==7)
    {
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        LBOpinionCzViewController *lbopinioncz=[[LBOpinionCzViewController alloc]init];
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//操作人员名称
         [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intfsdwlsh"];//单位流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intfwdwlsh"];//发文单位流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwmc"] forKey:@"strfsrdwmc"];//单位名称
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intsessionlsh"] forKey:@"intxtsessionlsh"];//会话流水号
         [saveDic setObject:[[detaildic objectForKey:@"intmjbh"] length]==0?@"1":[detaildic objectForKey:@"intmjbh"] forKey:@"strmjlst"];//接收单位密级串
        [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
        lbopinioncz.opinoidic=lcdic;
        lbopinioncz.savedic=saveDic;
        lbopinioncz.title=[lcdic objectForKey:@"stranbt"];
        [self.nav pushViewController:lbopinioncz animated:YES];
    }
    else if (lcint==11)
    {
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intgwlsh"];//步骤记录流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//单位流水号
        [saveDic setObject:[detaildic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];//公文流水号
         LBMakeNumViewController *lbmakenum=[[LBMakeNumViewController alloc]init];
         lbmakenum.detailContorller=self;
         lbmakenum.savedic=saveDic;
         lbmakenum.opinoidic=lcdic;
         lbmakenum.title=[lcdic objectForKey:@"stranbt"];
         [self.nav pushViewController:lbmakenum animated:YES];
    }
    else if (lcint==2||lcint==4||lcint==13||lcint==12)
    {
        
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [saveDic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//下一个流程流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strryxm"];//操作人员名称
        [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
        [saveDic setObject:[lcdic objectForKey:@"intlcczlsh"] forKey:@"intlcczlsh"];//流程操作流水号
        LBAppointViewController *lpappoint=[[LBAppointViewController alloc]init];
        lpappoint.lcint=lcint;
        lpappoint.savedic=saveDic;
        lpappoint.detailContorller=self;
        lpappoint.title=[lcdic objectForKey:@"stranbt"];
        [self.nav pushViewController:lpappoint animated:YES];
    }
    else if (lcint==47)//返回承办人
    {
        flowEnddic=[[NSMutableDictionary alloc]init];
        [flowEnddic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [flowEnddic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//下一个流程流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//操作人员名称
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strnextzrrmc"];//操作人员名称
        [flowEnddic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
        [flowEnddic setObject:@"0" forKey:@"bolsendsms"];//公文流转流水号
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",[lcdic objectForKey:@"stranbt"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag=1960;
        [alertview show];
    }
    else if (lcint==10)//办结
    {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork querybjpage:[lstdic objectForKey:@"intbzjllsh"] completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",[rep JSONString]);
                [SVProgressHUD dismiss];
                NSDictionary *redic=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
                [saveDic setObject:[redic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
                [saveDic setObject:[redic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//单位流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intrylsh"];//操作人流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strryxm"];//操作人员名称
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwjc"] forKey:@"strdwjc"];//单位名称
                [saveDic setObject:[redic objectForKey:@"intgwjhnum"] forKey:@"intgwjhnum"];
                [saveDic setObject:[self.lstdic objectForKey:@"strlzlx"] forKey:@"strlzlx"];
                LBTransferred *lbagetnsOpinion=[[LBTransferred alloc]initWithFrame:[UIScreen mainScreen].bounds transferred:[lcdic objectForKey:@"stranbt"] savedic:saveDic];
                lbagetnsOpinion.savedic=saveDic;
                lbagetnsOpinion.delegate=self;
                [lbagetnsOpinion show];
            }else
            {
                [SVProgressHUD showInfoWithStatus:emsg];
            }
        }];
    }
    else if (lcint==14)//指定接收单位
    {
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        [saveDic setObject:[detaildic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];//公文流水号
        [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//单位流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strgwxdz"] forKey:@"strfsdwdz"];//发送单位地址
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intfwdwlsh"];//发送单位流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwjc"] forKey:@"strfsrdwmc"];//发送单位名称
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intfsrlsh"];//发送人流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strfsrxm"];//发送人姓名
        
        LBPointJSdwViewController *pointjsdw=[[LBPointJSdwViewController alloc]init];
        pointjsdw.title=[lcdic objectForKey:@"stranbt"];
        pointjsdw.savedic=saveDic;
        [self.nav pushViewController:pointjsdw animated:YES];
    }
    else if (lcint==0)//退办
    {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork querytbshow:[lstdic objectForKey:@"intbzjllsh"] completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",[rep JSONString]);
                [SVProgressHUD dismiss];
                NSDictionary *redic=[[NSDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
                [saveDic setObject:[redic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
                [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
                [saveDic setObject:[redic objectForKey:@"intgwlsh"] forKey:@"intgwlsh"];//上一步公文流水号
                [saveDic setObject:[redic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//上一步公文流水号
                [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
                LBBackOffice *backoffice=[[LBBackOffice alloc]initWithFrame:[UIScreen mainScreen].bounds backOffice:[lcdic objectForKey:@"stranbt"]];
                backoffice.savedic=saveDic;
                backoffice.backofficedic=redic;
                backoffice.delegate=self;
                [backoffice show];
            }else
            {
                [SVProgressHUD showInfoWithStatus:emsg];
            }
        }];
    }
    else if (lcint==21)//送领导批示
    {
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] forKey:@"strdwccbm"];
         [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//单位流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//单位流水号
        [saveDic setObject:[lstdic objectForKey:@"strlzlx"] forKey:@"strlclxbm"];//流程类型编码
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
        
        
        [saveDic setObject:[lcdic objectForKey:@"intlcczlsh"] forKey:@"intlcczlsh"];//流程操作流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        LBSendLinderViewController *lbsendlinder=[[LBSendLinderViewController alloc]init];
        lbsendlinder.title=[lcdic objectForKey:@"stranbt"];
        lbsendlinder.savedic=saveDic;
        [self.nav pushViewController:lbsendlinder animated:YES];
    }
    else if (lcint==60||lcint==321)
    {
        NSMutableDictionary *saveDic=[NSMutableDictionary dictionary];
        [saveDic setObject:[lcdic objectForKey:@"intlcczlsh"] forKey:@"intlcczlsh"];//流程操作流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] forKey:@"intdwlsh"];//部门
        [saveDic setObject:[lstdic objectForKey:@"intgzlclsh"] forKey:@"intgzlclsh"];//部门
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] forKey:@"strdwccbm"];//单位流水号
        [saveDic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];//步骤记录流水号
         [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [saveDic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
        [saveDic setObject:[lstdic objectForKey:@"intgwlzlsh"] forKey:@"intgwlzlsh"];//公文流转流水号
        [saveDic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//下一个流程流水号
        LBShuntViewController *lbsendlinder=[[LBShuntViewController alloc]init];
        lbsendlinder.title=[lcdic objectForKey:@"stranbt"];
        lbsendlinder.savedic=saveDic;
        lbsendlinder.lint=2;
        lbsendlinder.bzlcint=lcint;
        [self.nav pushViewController:lbsendlinder animated:YES];
    
    }
    else if (lcint==6)//继续流程
    {
        flowEnddic=[[NSMutableDictionary alloc]init];
        [flowEnddic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [flowEnddic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//责任人流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
         UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",[lcdic objectForKey:@"stranbt"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag=1958;
        [alertview show];
    }
    else if (lcint==35)//继续流程
    {
        flowEnddic=[[NSMutableDictionary alloc]init];
        [flowEnddic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [flowEnddic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//责任人流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",[lcdic objectForKey:@"stranbt"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag=1959;
        [alertview show];
    }else if (lcint==128)
    {
        flowEnddic=[[NSMutableDictionary alloc]init];
        [flowEnddic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",[lcdic objectForKey:@"stranbt"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag=1961;
        [alertview show];
    }
    else if (lcint==61)
    {
        flowEnddic=[[NSMutableDictionary alloc]init];
        [flowEnddic setObject:[lstdic objectForKey:@"intbzjllsh"] forKey:@"intbzjllsh"];
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] forKey:@"intczrylsh"];//操作人流水号
        [flowEnddic setObject:[lcdic objectForKey:@"strnextgzlclsh"] forKey:@"intnextgzlclsh"];//下一个流程流水号
        [flowEnddic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strryxm"] forKey:@"strczrxm"];//当前操作人姓名
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否%@",[lcdic objectForKey:@"stranbt"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertview.tag=1962;
        [alertview show];
    }
    else
    {
        [Tools showMsgBox:@"此功能请在网页上操作"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1958) {
        if (buttonIndex==1) {
            [SHNetWork subFlowEnd:[flowEnddic objectForKey:@"intbzjllsh"] intczrylsh:[flowEnddic objectForKey:@"intczrylsh"] intnextgzlclsh:[flowEnddic objectForKey:@"intnextgzlclsh"] strczrxm:[flowEnddic objectForKey:@"strczrxm"] completionBlock:^(id rep, NSString *emsg) {
                if (!emsg) {
                    if ([[rep objectForKey:@"flag"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:@"流转成功"];
                        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                    }
                    else
                    {
                        [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                    }
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
    else if (alertView.tag==1959)
    {
        if (buttonIndex==1) {
            [SHNetWork setsfsropt:[flowEnddic objectForKey:@"intbzjllsh"] intczrylsh:[flowEnddic objectForKey:@"intczrylsh"] intnextgzlclsh:[flowEnddic objectForKey:@"intnextgzlclsh"] strczrxm:[flowEnddic objectForKey:@"strczrxm"] completionBlock:^(id rep, NSString *emsg) {
                if (!emsg) {
                    if ([[rep objectForKey:@"flag"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:@"流转成功"];
                        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                    }
                    else
                    {
                        [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                    }
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
    else if (alertView.tag==1960)
    {
        if (buttonIndex==1) {
            [SHNetWork returnUndertakePeople:[flowEnddic objectForKey:@"intbzjllsh"] intczrylsh:[flowEnddic objectForKey:@"intczrylsh"] intnextgzlclsh:[flowEnddic objectForKey:@"intnextgzlclsh"] strnextzrrmc:[flowEnddic objectForKey:@"strnextzrrmc"] strczrxm:[flowEnddic objectForKey:@"strczrxm"] bolsendsms:[flowEnddic objectForKey:@"bolsendsms"] intgwlzlsh:[flowEnddic objectForKey:@"intgwlzlsh"] completionBlock:^(id rep, NSString *emsg) {
                if (!emsg) {
                    if ([[rep objectForKey:@"flag"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:@"返回成功"];
                        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                    }
                    else
                    {
                        [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                    }
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
    else if (alertView.tag==1961)
    {
        if (buttonIndex==1) {
            [SHNetWork transactBzEnd:[flowEnddic objectForKey:@"intbzjllsh"] intczrylsh:[flowEnddic objectForKey:@"intczrylsh"] strczrxm:[flowEnddic objectForKey:@"strczrxm"] completionBlock:^(id rep, NSString *emsg) {
                if (!emsg) {
                    if ([[rep objectForKey:@"flag"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                    }
                    else
                    {
                        [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                    }
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
    else if (alertView.tag==1962)
    {
        if (buttonIndex==1)
        {
            [SHNetWork partFlowEnd:[flowEnddic objectForKey:@"intbzjllsh"] intczrylsh:[flowEnddic objectForKey:@"intczrylsh"] intnextgzlclsh:[flowEnddic objectForKey:@"intnextgzlclsh"] strczrxm:[flowEnddic objectForKey:@"strczrxm"] completionBlock:^(id rep, NSString *emsg) {
                if (!emsg) {
                    if ([[rep objectForKey:@"flag"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                        [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
                    }
                    else
                    {
                        [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                    }
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
}
-(void)gogo
{
    for (id views in self.nav.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.nav popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
}
#pragma mark----------------意见处理协议------------------
-(void)updates
{
    [self getHandleOpinion];
    [self buttonupdate];
   // [lryjdic setObject:@"0" forKey:@"isyx"];
    //[licary replaceObjectAtIndex:lryjInt withObject:lryjdic];
}
#pragma mark---------------办结意见处理协议--------------
-(void)transferredupdata
{
    for (id views in self.nav.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.nav popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
}
#pragma mark----------------退办处理协议----------------
-(void)backofficeupdata
{
    for (id views in self.nav.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.nav popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (licary.count==0) {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
        [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
        [SHNetWork getOperateList:[lstdic objectForKey:@"intbzjllsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] intjsid:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strjsid"] strlclxbm:[lstdic objectForKey:@"strlzlx"] intgwlsh:[lstdic objectForKey:@"intgwlsh"] intgwlzlsh:[lstdic objectForKey:@"intgwlzlsh"] intgzlclsh:[lstdic objectForKey:@"intgzlclsh"] strgqbz:[lstdic objectForKey:@"strgqbz"] completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                NSLog(@"%@",rep);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                    if (tempary.count==0)
                    {
                        [SVProgressHUD showInfoWithStatus:@"暂无办理流程"];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                        licary=[[NSMutableArray alloc]initWithArray:tempary];
                        if (open) {
                            open=NO;
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationTop];
                            
                        }else
                        {
                            open=YES;
                            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
                            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        }
                    }
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
                    
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:emsg];
            }
        }];
    }else
    {
        if (open) {
            open=NO;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationTop];
        }else
        {
            open=YES;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationBottom];
            [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    }
}
#pragma mark-----------刷新操作-------
-(void)buttonupdate{

    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
    [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [SHNetWork getOperateList:[lstdic objectForKey:@"intbzjllsh"] intrylsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intrylsh"] intcsdwlsh:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intcsdwlsh"] intjsid:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strjsid"] strlclxbm:[lstdic objectForKey:@"strlzlx"] intgwlsh:[lstdic objectForKey:@"intgwlsh"] intgwlzlsh:[lstdic objectForKey:@"intgwlzlsh"] intgzlclsh:[lstdic objectForKey:@"intgzlclsh"] strgqbz:[lstdic objectForKey:@"strgqbz"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *tempary=[[NSArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (tempary.count==0)
                {
                    [SVProgressHUD showInfoWithStatus:@"暂无办理流程"];
                }
                else
                {
                    [SVProgressHUD dismiss];
                    licary=[[NSMutableArray alloc]initWithArray:tempary];
                    
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:emsg];
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
