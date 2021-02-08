//
//  LBShuntViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/28.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBShuntViewController.h"
#import "LBTreeViewNode.h"
#import "LBrightImageButton.h"
#import "QCheckBox.h"
#import "LBAgentsViewController.h"
#import "SHbsTableViewCell.h"
#import "LBChoosePersonViewController.h"
@interface LBShuntViewController ()<QCheckBoxDelegate,UITableViewDataSource,UITableViewDelegate,ChooseLxPersonDelegate>
{
    NSMutableArray *ldpsarray;
    NSMutableArray *readyarray;//已经选择
    UITableView *lindertb;
    NSString *intnextgzlclsh;//下一步工作流程流水号
    NSString *intlcczlsh;//流程操作流水号
    NSMutableString *intgzlclshlst;//工作流程流水号
    NSMutableDictionary *zdrydic;//指定人员
    
    NSString *intnextgzrylsh ;//下一步工作人员流水号
    NSString *strnextgzrylx ;//下一步工作人员类型
    NSString *strnextdwbz;//下一级单位标志
    NSString *strnextrybz;//下一级人员标志
}
@property(nonatomic,strong)NSMutableArray *displayArray;
@property(nonatomic,strong)NSMutableArray *displayArray1;
@property(nonatomic,strong)NSMutableArray *listryjss;
@end
@implementation LBShuntViewController
@synthesize listryjss;
- (void)viewDidLoad {
    [super viewDidLoad];
    zdrydic=[[NSMutableDictionary alloc]init];
    [self rightButton:@"保存" image:nil sel:@selector(okSEL:)];
    lindertb =[[UITableView alloc]initWithFrame:CGRectMake(0,5,kScreenWidth, kScreenHeight-10) style:UITableViewStylePlain];
    lindertb.showsVerticalScrollIndicator=NO;
    lindertb.dataSource=self;
    lindertb.delegate=self;
    [lindertb setBackgroundColor:[SingleObj defaultManager].backColor];
    lindertb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lindertb];
    [self getPartFlowPeople];
    // Do any additional setup after loading the view from its nib.
}
-(void)getFlowPeople
{
    //[SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getFlowPeople:[_savedic objectForKey:@"intgwlzlsh"] intgzlclsh:[_savedic objectForKey:@"intgzlclsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                readyarray=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                [self getPartFlowPeople];
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


-(void)getPartFlowPeople
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *userinfodic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    NSString* intcsdwlsh = [userinfodic objectForKey:@"intcsdwlsh"];//处室单位流水号
    NSString* intrylsh = [userinfodic objectForKey:@"intrylsh"];//人员流水号
    NSString* dwccbm = [_savedic objectForKey:@"strdwccbm"];//单位层次编码
    NSString* strryxm = [userinfodic objectForKey:@"strryxm"];//人员姓名
    NSString* intbzjllsh = [_savedic objectForKey:@"intbzjllsh"] ;//步骤记录流水号
    NSString* xtDwlsh = [_savedic objectForKey:@"intdwlsh"] ;//单位流水号,如果需要下一层从接口中取出数据重新传
    NSString* lcczlsh = [_savedic objectForKey:@"intlcczlsh"];//流程操作流水号
    NSString* nextgzlclsh = [_savedic objectForKey:@"intnextgzlclsh"];//下一步工作流程流水号
    
    NSString *intgzlclsh =_savedic[@"intgzlclsh"];
    NSString *strxzbz =@"";
    
    
    [SHNetWork getFlclzdxxx:intrylsh:strryxm:intbzjllsh:intcsdwlsh:xtDwlsh:dwccbm:nextgzlclsh:lcczlsh:
            ^(id rep, NSString *emsg) {
          if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                intnextgzlclsh =[[rep objectForKey:@"data"] objectForKey:@"strnextgzlclsh"];
                intlcczlsh=[_savedic objectForKey:@"intlcczlsh"];
                NSMutableDictionary *lstGzlc=[[NSMutableDictionary alloc]initWithDictionary:[[rep objectForKey:@"data"] objectForKey:@"flcxx"]] ;
                NSMutableArray *ryinfo =  [[lstGzlc objectForKey:@"strzdryc"] objectForKey:@"ryinfo"];
                NSMutableDictionary *strzdryc = [[NSMutableDictionary alloc]initWithDictionary:[lstGzlc objectForKey:@"strzdryc"]];
                ldpsarray=[[NSMutableArray alloc]init];
                intnextgzrylsh = [lstGzlc objectForKey:@"intnextgzrylsh"];
                strnextgzrylx = [lstGzlc objectForKey:@"strnextgzrylx"];
                
                NSMutableArray *listryjs=[[NSMutableArray alloc]init];
                
                for (int i=0; i<ryinfo.count; i++) {
                    NSDictionary *gzlc=[ryinfo objectAtIndex:i];
                    if (self.bzlcint==321) {
                        NSDictionary *dic =[SHNetWork asnetworkgetFlowPeopleintgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intgzlclsh:[_savedic objectForKey:@"intgzlclsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"]];
                        if ([[dic objectForKey:@"flag"] intValue]==0) {
                            readyarray=[[NSMutableArray alloc]initWithArray:[dic objectForKey:@"data"]];
                        }
                    }else
                    {
                        readyarray=[[NSMutableArray alloc]init];
                    }
                    LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                    lbtree.selectary=readyarray;
                    lbtree.strname = @"";//这个标志控制是否显示选中框
                    lbtree.nodeLevel=0;
                    lbtree.returnType=[gzlc objectForKey:@"returnType"];
                    lbtree.strgzrw=[gzlc objectForKey:@"strryxm"];
                    lbtree.isExpanded=NO;
                    lbtree.isCheck=NO;
                    lbtree.intrylsh=[gzlc objectForKey:@"intrylsh"];
                    lbtree.intgzlclshlst = [strzdryc objectForKey:@"intgzlclshlst"];
                    lbtree.strzrrlxLst = [strzdryc objectForKey:@"strzrrlxLst"];
                    [listryjs addObject:gzlc];

                    //下一级单位标志
                    strnextdwbz =  [NSString stringWithFormat:@"%@",[gzlc objectForKey:@"strnextdwbz"]];
                    //下一级人员标志
                    strnextrybz = [NSString stringWithFormat:@"%@",[gzlc objectForKey:@"strnextrybz"]];
                    if([strnextdwbz isEqual:@"0"]&&[strnextrybz isEqual:@"0"]){
                        //表示没有下一级
                        lbtree.hasnext = @"0";
                        lbtree.nodeChildren = nil;
                    }else if([strnextdwbz isEqualToString:@"0"]&&[strnextrybz isEqualToString:@"1"]){
                        //表示有下一级
                        lbtree.hasnext=@"1";
                        lbtree.nodeChildren=[self childern:listryjs];//改标志控件是否展示箭头表示有下一级
                    }
                    
                
                    [ldpsarray addObject:lbtree];
                }
                [self fillDisplayArray];

                [lindertb reloadData];
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


-(void)getPartFlowPeople1
{
    [SVProgressHUD showWithStatus:@"加载中..."];

    NSString*   strcsdwccbm= [[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strcsdwccbm"];
    NSLog(@"%@",strcsdwccbm);

    NSString *intgzlclsh =_savedic[@"intgzlclsh"];
    NSString *strxzbz =@"";

    [SHNetWork getPartFlowPeople:[_savedic objectForKey:@"strdwccbm"] intlcczlsh:[_savedic objectForKey:@"intlcczlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] intgzlclsh:intgzlclsh strcsdwccbm:strcsdwccbm strxzbz:strxzbz  completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                intnextgzlclsh =[[rep objectForKey:@"data"] objectForKey:@"strnextgzlclsh"];
                intlcczlsh=[_savedic objectForKey:@"intlcczlsh"];
                NSMutableArray *lstGzlc=[[NSMutableArray alloc]initWithArray:[[rep objectForKey:@"data"] objectForKey:@"lstGzlc"]];
                ldpsarray=[[NSMutableArray alloc]init];
                for (int i=0; i<lstGzlc.count; i++) {
                    NSDictionary *gzlc=[lstGzlc objectAtIndex:i];
                    if (self.bzlcint==321) {
                        NSDictionary *dic =[SHNetWork asnetworkgetFlowPeopleintgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intgzlclsh:[gzlc objectForKey:@"intgzlclsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"]];
                        if ([[dic objectForKey:@"flag"] intValue]==0) {
                            readyarray=[[NSMutableArray alloc]initWithArray:[dic objectForKey:@"data"]];
                        }
                    }else
                    {
                        readyarray=[[NSMutableArray alloc]init];
                    }
                    LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                    lbtree.selectary=readyarray;
                    lbtree.nodeLevel=0;
                    lbtree.returnType=[gzlc objectForKey:@"returnType"];
                    lbtree.hasnext=[NSString stringWithFormat:@"%@",[gzlc objectForKey:@"hasNext"]];
                    lbtree.strgzrw=[gzlc objectForKey:@"strgzrw"];
                    lbtree.isExpanded=NO;
                    lbtree.isCheck=NO;
                    lbtree.intrylsh=[gzlc objectForKey:@"intrylsh"];
                    lbtree.strname=[gzlc objectForKey:@"strdwmc"];
                    NSMutableArray *listryjs=[[NSMutableArray alloc]init];;
                    for (NSDictionary *listdic in [gzlc objectForKey:@"listryjs"]) {
                        NSMutableDictionary *dis=[[NSMutableDictionary alloc]initWithDictionary:listdic];
                        [dis setObject:[gzlc objectForKey:@"intgzlclsh"] forKey:@"intgzlclsh"];
                        [dis setObject:lbtree forKey:@"father"];
                        [dis setObject:[gzlc objectForKey:@"returnType"] forKey:@"returnType"];
                        [dis setObject:[gzlc objectForKey:@"hasNext"] forKey:@"hasNext"];
                        [listryjs addObject:dis];
                    }
                    lbtree.nodeChildren=[self childern:listryjs];
                    [ldpsarray addObject:lbtree];
                }
                [self fillDisplayArray];

                [lindertb reloadData];
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
-(NSMutableArray*)childern:(NSMutableArray*)childern
{
    NSMutableArray *carray=[[NSMutableArray alloc]init];
    for (int i=0; i<childern.count; i++) {
        NSDictionary *childerndic=[childern objectAtIndex:i];
        LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
        lbtree.hasnext=[childerndic objectForKey:@"hasNext"];
        lbtree.returnType=[childerndic objectForKey:@"returnType"];
        if ([[childerndic objectForKey:@"returnType"] isEqualToString:@"peo"]) {
            lbtree.strname=[childerndic objectForKey:@"strryxm"];
            lbtree.strgzrw=[childerndic objectForKey:@"strryxm"];
        }else
        {
            lbtree.strname=[childerndic objectForKey:@"strdwmc"];
            lbtree.strgzrw=[childerndic objectForKey:@"strdwmc"];
        }
        if ([[childerndic objectForKey:@"hasNext"] intValue]==1) {
            lbtree.strdwccbm=[childerndic objectForKey:@"strdwccbm"];
        }
        lbtree.intpxh=[childerndic objectForKey:@"intpxh"];
        lbtree.strdlm=[childerndic objectForKey:@"strdlm"];
        lbtree.intjsid=[childerndic objectForKey:@"intjsid"];
        lbtree.stryddh=[childerndic objectForKey:@"stryddh"];
        lbtree.intrylsh=[childerndic objectForKey:@"intrylsh"];
        lbtree.intgzlclsh=[childerndic objectForKey:@"intgzlclsh"];
        LBTreeViewNode *lbnote=(LBTreeViewNode*)[childerndic objectForKey:@"father"];
        
        lbtree.fatherself=[childerndic objectForKey:@"father"];
        lbtree.selectary=lbnote.selectary;
        lbtree.isExpanded=NO;
        lbtree.nodeLevel=1;
        lbtree.isCheck=NO;
        lbtree.nodeChildren=nil;
        [carray addObject:lbtree];
    }
    return carray;
}
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (LBTreeViewNode *node in ldpsarray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (LBTreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayArray.count;
//    if (section==0) {
//        return return self.displayArray.count;;
//    }
//    else
//    {
//        
//    }
    // Return the number of rows in the section.
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return 50;
//    }
//    else
//    {
//        return 80;
//    }
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        return [self headView:@"指定下一步人员"];
//    }
//    else
//    {
//        return [self headView:@"分流流程定义"];
//    }
//}
-(UIView*)headView:(NSString*)title
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, W(lindertb), 40)];
    if ([title isEqualToString:@"分流流程定义"]) {
        head.frame=CGRectMake(0, 0, W(lindertb), 80);
        [head setBackgroundColor:[SingleObj defaultManager].backColor];
    }else
    {
        [head setBackgroundColor:[UIColor whiteColor]];
    }
    UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, H(head)-40, W(head), 39)];
    [titlelb setBackgroundColor:[UIColor whiteColor]];
    titlelb.font=BoldFont(18);
    titlelb.textColor=[SingleObj defaultManager].mainColor;
    titlelb.textAlignment=NSTextAlignmentCenter;
    titlelb.text=title;
    [head addSubview:titlelb];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(titlelb), W(head), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [head addSubview:oneline];
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *identifier = @"mytable";
    SHbsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SHbsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[SingleObj defaultManager].backColor];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, W(tableView), 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    if (indexPath.section==1) {
        LBrightImageButton *lbrigtbutton=[LBrightImageButton buttonWithType:UIButtonTypeCustom];
        lbrigtbutton.frame=CGRectMake(0, 0, W(headerview), 40);
        [lbrigtbutton bootstrapNoborderStyle:[UIColor clearColor] titleColor:[UIColor blackColor] andbtnFont:Font(14)];
        if ([zdrydic allKeys].count!=0) {
            [lbrigtbutton setTitle:[zdrydic objectForKey:@"strryxm"] forState:0];
        }else
        {
            [lbrigtbutton setTitle:@"请指定人员" forState:0];
        }
        [lbrigtbutton setImage:PNGIMAGE(@"turnopen") forState:0];
        [lbrigtbutton addTarget:self action:@selector(choosePersonSEL:) forControlEvents:UIControlEventTouchUpInside];
        [headerview addSubview:lbrigtbutton];
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(lbrigtbutton), W(headerview), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [headerview addSubview:oneline];
        headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    }else if (indexPath.section==0) {
        LBTreeViewNode *treenode =[self.displayArray objectAtIndex:indexPath.row];
        if (treenode.nodeChildren.count!=0||([treenode.hasnext intValue]==1&&![Tools isBlankString:treenode.strdwccbm])) {
            LBrightImageButton *ssbtn=[LBrightImageButton buttonWithType:UIButtonTypeCustom];
            ssbtn.frame=CGRectMake(0, 0, W(headerview), 40);
            ssbtn.tag=indexPath.row+1000;
            [ssbtn addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchUpInside];
            if (treenode.isExpanded==NO)
            {
                [ssbtn setImage:PNGIMAGE(@"turnopen") forState:0];
            }
            else
            {
                [ssbtn setImage:PNGIMAGE(@"carat-close-black") forState:0];
            }
            [headerview addSubview:ssbtn];
        }
        if (treenode.strname!=nil) {
            QCheckBox *qcheckBox=[[QCheckBox alloc]initWithDelegate:self];
            qcheckBox.treeviewnode=treenode;
            qcheckBox.frame=CGRectMake(treenode.nodeLevel*25+10, 0,  [treenode.strgzrw sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40);
            [qcheckBox setTitle:treenode.strgzrw forState:0];
            [qcheckBox setTitleColor:[UIColor blackColor] forState:0];
            qcheckBox.titleLabel.font=Font(14);
            qcheckBox.tag=(indexPath.section+1)*1000+indexPath.row;
            qcheckBox.selected=treenode.isCheck;
            [headerview addSubview:qcheckBox];
            LBTreeViewNode *fatherLb=(LBTreeViewNode*)treenode.fatherself;
            for (NSDictionary *dic in fatherLb.selectary) {
                if ([[dic objectForKey:@"intrylsh"] isEqualToString:treenode.intrylsh]) {
                    qcheckBox.selected=YES;
                    treenode.isselect=YES;
                    qcheckBox.userInteractionEnabled=NO;
                }
            }
            UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(qcheckBox), W(headerview), 1)];
            [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
            [headerview addSubview:oneline];
            headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
            cell.contentView.frame = CGRectMake(0.0f, 0.0f, W(tableView), YH(headerview));
            
        }
        else
        {
            UILabel *qcheckBox=[[UILabel alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10, 0,  [treenode.strgzrw sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40)];
            qcheckBox.text=treenode.strgzrw;
            qcheckBox.textColor=[UIColor blackColor];
            qcheckBox.font=Font(14);
            [headerview addSubview:qcheckBox];
            UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(qcheckBox), W(headerview), 1)];
            [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
            [headerview addSubview:oneline];
            headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
            cell.contentView.frame = CGRectMake(0.0f, 0.0f, W(tableView), YH(headerview));
        }
        
    }
    return cell;
}
#pragma mark------------------initview---------------
-(void)expand1:(UIButton*)sender
{
    LBTreeViewNode *treenode =[self.displayArray objectAtIndex:sender.tag-1000];
    treenode.isExpanded = !treenode.isExpanded;
    if ([treenode.hasnext intValue]==1&&treenode.isExpanded==YES&&treenode.strdwccbm.length!=0) {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        [SHNetWork getDepartmentPeople:treenode.strdwccbm completionBlock:^(id rep, NSString *emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                NSMutableArray *childerary=[[NSMutableArray alloc]init];
                NSMutableArray *tempary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                for (NSDictionary *dic in tempary) {
                    LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                    lbtree.returnType=@"peo";
                    lbtree.strgzrw=[dic objectForKey:@"strryxm"];
                    lbtree.fatherself=treenode;
                    lbtree.hasnext=treenode.hasnext;
                    lbtree.selectary=treenode.selectary;
                    lbtree.intpxh=[dic objectForKey:@"intpxh"];
                    lbtree.strdlm=[dic objectForKey:@"strdlm"];
                    lbtree.intjsid=[dic objectForKey:@"intjsid"];
                    lbtree.stryddh=[dic objectForKey:@"stryddh"];
                    lbtree.intrylsh=[dic objectForKey:@"intrylsh"];
                    lbtree.intgzlclsh=treenode.intgzlclsh;
                    lbtree.strname=[dic objectForKey:@"strryxm"];
                    lbtree.isExpanded=NO;
                    lbtree.nodeLevel=treenode.nodeLevel+1;
                    lbtree.isCheck=NO;
                    lbtree.nodeChildren=nil;
                    [childerary addObject:lbtree];
                }
                treenode.nodeChildren=childerary;
                [self fillDisplayArray];
                [lindertb reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }];
    }
    else
    {
        [self fillDisplayArray];
        [lindertb reloadData];
    }
    
}

-(void)expand:(UIButton*)sender
{
    LBTreeViewNode *treenode =[self.displayArray objectAtIndex:sender.tag-1000];
    treenode.isExpanded = !treenode.isExpanded;
    if ([treenode.hasnext intValue]==1&&treenode.isExpanded==YES) {
        [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
        NSMutableDictionary *userinfodic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
        
        NSString* intcsdwlsh = [userinfodic objectForKey:@"intcsdwlsh"];//处室单位流水号
        NSString* intrylsh = [userinfodic objectForKey:@"intrylsh"];//人员流水号
        NSString* dwccbm = [_savedic objectForKey:@"strdwccbm"];//单位层次编码
        NSString* strryxm = [userinfodic objectForKey:@"strryxm"];//人员姓名
        NSString* intbzjllsh = [_savedic objectForKey:@"intbzjllsh"] ;//步骤记录流水号
        NSString* xtDwlsh = treenode.intrylsh ;//单位流水号,如果需要下一层从接口中取出数据重新传
        NSString* lcczlsh = [_savedic objectForKey:@"intlcczlsh"];//流程操作流水号
        NSString* nextgzlclsh = [_savedic objectForKey:@"intnextgzlclsh"];//下一步工作流程流水号
        
        [SHNetWork getFlclzdxxx:intrylsh:strryxm:intbzjllsh:intcsdwlsh:xtDwlsh:dwccbm:nextgzlclsh:lcczlsh: ^(id rep, NSString *emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                NSMutableDictionary *lstGzlc=[[NSMutableDictionary alloc]initWithDictionary:[[rep objectForKey:@"data"] objectForKey:@"flcxx"]] ;
                NSMutableArray *ryinfo =  [[lstGzlc objectForKey:@"strzdryc"] objectForKey:@"ryinfo"];
                NSMutableDictionary *strzdryc = [[NSMutableDictionary alloc]initWithDictionary:[lstGzlc objectForKey:@"strzdryc"]];
                NSMutableArray *childerary=[[NSMutableArray alloc]init];
               // NSMutableArray *tempary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                for (NSDictionary *dic in ryinfo) {
                    LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                    lbtree.returnType=@"peo";
                    lbtree.strgzrw=[dic objectForKey:@"strryxm"];
                    lbtree.fatherself=treenode;
                    lbtree.hasnext=treenode.hasnext;
                    lbtree.selectary=treenode.selectary;
                    lbtree.intpxh=[dic objectForKey:@"intpxh"];
                    lbtree.strdlm=[dic objectForKey:@"strdlm"];
                    lbtree.intjsid=[dic objectForKey:@"intjsid"];
                    lbtree.stryddh=[dic objectForKey:@"stryddh"];
                    lbtree.intrylsh=[dic objectForKey:@"intrylsh"];
                    lbtree.intgzlclsh=treenode.intgzlclsh;
                    lbtree.strname=[dic objectForKey:@"strryxm"];
                    lbtree.intgzlclshlst = [strzdryc objectForKey:@"intgzlclshlst"];
                    lbtree.strzrrlxLst = [strzdryc objectForKey:@"strzrrlxLst"];
                    lbtree.isExpanded=NO;
                    lbtree.nodeLevel=treenode.nodeLevel+1;
                    lbtree.isCheck=NO;
                    lbtree.nodeChildren=nil;
                    

                    //下一级单位标志
                    NSString *strnextdwbz =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"strnextdwbz"]];
                    //下一级人员标志
                    NSString *strnextrybz = [NSString stringWithFormat:@"%@",[dic objectForKey:@"strnextrybz"]];
                    if([strnextdwbz isEqual:@"0"]&&[strnextrybz isEqual:@"0"]){
                        //表示没有下一级
                        lbtree.hasnext = @"0";
                    }else if([strnextdwbz isEqualToString:@"0"]&&[strnextrybz isEqualToString:@"1"]){
                        //表示有下一级
                        lbtree.hasnext=@"1";
                    }
                    [childerary addObject:lbtree];
                }
                treenode.nodeChildren=childerary;
                [self fillDisplayArray];
                [lindertb reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }];
    }
    else
    {
        [self fillDisplayArray];
        [lindertb reloadData];
    }

}
#pragma mark----------------添加人员-----------
-(void)didSelectedCheckBo1:(id)chechbox checked:(BOOL)checked
{
    LBTreeViewNode *treenode=(LBTreeViewNode*)chechbox;
    treenode.isCheck=checked;
    if ([treenode.hasnext intValue]==1&&![Tools isBlankString:treenode.strdwccbm]) {
        if (treenode.isExpanded==NO) {
            treenode.isExpanded=!treenode.isExpanded;
            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
            [SHNetWork getDepartmentPeople:treenode.strdwccbm completionBlock:^(id rep, NSString *emsg) {
                NSLog(@"%@",[rep JSONString]);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD dismiss];
                    NSMutableArray *childerary=[[NSMutableArray alloc]init];
                    NSMutableArray *tempary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                    for (NSDictionary *dic in tempary) {
                        LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                        lbtree.hasnext=treenode.hasnext;
                        lbtree.returnType=@"peo";
                        lbtree.fatherself=treenode;
                        lbtree.selectary=treenode.selectary;
                        lbtree.intgzlclsh=treenode.intgzlclsh;
                        lbtree.strgzrw=[dic objectForKey:@"strryxm"];
                        lbtree.strname=[dic objectForKey:@"strryxm"];
                        lbtree.intpxh=[dic objectForKey:@"intpxh"];
                        lbtree.strdlm=[dic objectForKey:@"strdlm"];
                        lbtree.intjsid=[dic objectForKey:@"intjsid"];
                        lbtree.stryddh=[dic objectForKey:@"stryddh"];
                        lbtree.intrylsh=[dic objectForKey:@"intrylsh"];
                        lbtree.isExpanded=NO;
                        lbtree.nodeLevel=treenode.nodeLevel+1;
                        lbtree.isCheck=treenode.isCheck;
                        lbtree.nodeChildren=nil;
                        
                        [childerary addObject:lbtree];
                    }
                    treenode.nodeChildren=childerary;
                    [self fillDisplayArray];
                    [lindertb reloadData];
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                }
            }];
        }
        else
        {
            for (LBTreeViewNode *treenode1 in treenode.nodeChildren) {
                 treenode1.isCheck=treenode.isCheck;
            }
             [lindertb reloadData];
        }
    }
    else{
        [lindertb reloadData];
    }
    
}


#pragma mark----------------添加人员-----------
-(void)didSelectedCheckBo:(id)chechbox checked:(BOOL)checked
{
    LBTreeViewNode *treenode=(LBTreeViewNode*)chechbox;
    treenode.isCheck=checked;
    if ([treenode.hasnext intValue]==1) {
        if (treenode.isExpanded==NO) {
            treenode.isExpanded=!treenode.isExpanded;
            [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
            
            NSMutableDictionary *userinfodic = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
            
            NSString* intcsdwlsh = [userinfodic objectForKey:@"intcsdwlsh"];//处室单位流水号
            NSString* intrylsh = [userinfodic objectForKey:@"intrylsh"];//人员流水号
            NSString* dwccbm = [_savedic objectForKey:@"strdwccbm"];//单位层次编码
            NSString* strryxm = [userinfodic objectForKey:@"strryxm"];//人员姓名
            NSString* intbzjllsh = [_savedic objectForKey:@"intbzjllsh"] ;//步骤记录流水号
            NSString* xtDwlsh = treenode.intrylsh ;//单位流水号,如果需要下一层从接口中取出数据重新传
            NSString* lcczlsh = [_savedic objectForKey:@"intlcczlsh"];//流程操作流水号
            NSString* nextgzlclsh = [_savedic objectForKey:@"intnextgzlclsh"];//下一步工作流程流水号
            
            [SHNetWork getFlclzdxxx:intrylsh:strryxm:intbzjllsh:intcsdwlsh:xtDwlsh:dwccbm:nextgzlclsh:lcczlsh: ^(id rep, NSString *emsg) {
                NSLog(@"%@",[rep JSONString]);
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                    [SVProgressHUD dismiss];
                    NSMutableDictionary *lstGzlc=[[NSMutableDictionary alloc]initWithDictionary:[[rep objectForKey:@"data"] objectForKey:@"flcxx"]] ;
                    NSMutableArray *ryinfo =  [[lstGzlc objectForKey:@"strzdryc"] objectForKey:@"ryinfo"];
                    NSMutableDictionary *strzdryc = [[NSMutableDictionary alloc]initWithDictionary:[lstGzlc objectForKey:@"strzdryc"]];
                    NSMutableArray *childerary=[[NSMutableArray alloc]init];
                    // NSMutableArray *tempary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                    for (NSDictionary *dic in ryinfo) {
                        LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                        lbtree.hasnext=treenode.hasnext;
                        lbtree.returnType=@"peo";
                        lbtree.fatherself=treenode;
                        lbtree.selectary=treenode.selectary;
                        lbtree.intgzlclsh=treenode.intgzlclsh;
                        lbtree.strgzrw=[dic objectForKey:@"strryxm"];
                        lbtree.strname=[dic objectForKey:@"strryxm"];
                        lbtree.intpxh=[dic objectForKey:@"intpxh"];
                        lbtree.strdlm=[dic objectForKey:@"strdlm"];
                        lbtree.intjsid=[dic objectForKey:@"intjsid"];
                        lbtree.stryddh=[dic objectForKey:@"stryddh"];
                        lbtree.intrylsh=[dic objectForKey:@"intrylsh"];
                        lbtree.intgzlclshlst = [strzdryc objectForKey:@"intgzlclshlst"];
                        lbtree.strzrrlxLst = [strzdryc objectForKey:@"strzrrlxLst"];
                        lbtree.isExpanded=NO;
                        lbtree.nodeLevel=treenode.nodeLevel+1;
                        lbtree.isCheck=treenode.isCheck;
                        lbtree.nodeChildren=nil;
                        //下一级单位标志
                        NSString *strnextdwbz =  [NSString stringWithFormat:@"%@",[dic objectForKey:@"strnextdwbz"]];
                        //下一级人员标志
                        NSString *strnextrybz = [NSString stringWithFormat:@"%@",[dic objectForKey:@"strnextrybz"]];
                        if([strnextdwbz isEqual:@"0"]&&[strnextrybz isEqual:@"0"]){
                            //表示没有下一级
                            lbtree.hasnext = @"0";
                        }else if([strnextdwbz isEqualToString:@"0"]&&[strnextrybz isEqualToString:@"1"]){
                            //表示有下一级
                            lbtree.hasnext=@"1";
                        }
                        [childerary addObject:lbtree];
                    }

                    treenode.nodeChildren=childerary;
                    [self fillDisplayArray];
                    [lindertb reloadData];
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
                }
            }];
        }
        else
        {
            for (LBTreeViewNode *treenode1 in treenode.nodeChildren) {
                treenode1.isCheck=treenode.isCheck;
            }
            [lindertb reloadData];
        }
    }
    else{
        [lindertb reloadData];
    }
    
}

-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    LBTreeViewNode *treenode = [self.displayArray objectAtIndex:checkbox.tag-1000];
    treenode.isCheck=!treenode.isCheck;
    if (treenode.fatherself!=nil&&treenode.isCheck==YES) {
        LBTreeViewNode *treenod=(LBTreeViewNode*)treenode.fatherself;
        treenod.isCheck=YES;
    }
    [lindertb reloadData];
}
#pragma mark------------------确定--------------
-(void)okSEL:(UIButton*)sender
{
    listryjss=[[NSMutableArray alloc]init];
    if([strnextdwbz isEqual:@"0"]&&[strnextrybz isEqual:@"0"]){
        //表示没有下一级
        for (LBTreeViewNode *treenode in self.displayArray) {
            //没有子节点的情况
            if([treenode.hasnext intValue]==0&&treenode.isCheck == YES)
            {
                [listryjss addObject:treenode];
            }
        }
    }else if([strnextdwbz isEqualToString:@"0"]&&[strnextrybz isEqualToString:@"1"]){
        //表示有下一级
        for (LBTreeViewNode *treenode in self.displayArray) {
                for (LBTreeViewNode *treenode1 in treenode.nodeChildren) {
                    if (treenode1.isCheck) {
                        if ([treenode1.returnType isEqualToString:@"dep"]){
                            if (treenode1.nodeChildren.count>0) {
                                for (LBTreeViewNode *treenode11 in treenode1.nodeChildren) {
                                    if (treenode11.isCheck&&treenode1.isselect!=YES) {
                                        [listryjss addObject:treenode11];
                                    }
                                }
                            }
                        }
                        else if([treenode1.returnType isEqualToString:@"peo"]&&[treenode1.hasnext intValue]==0&&treenode1.isselect!=YES)
                        {
                            [listryjss addObject:treenode1];
                        }
                    }
                }
        }
    }
    
    NSLog(@"%@",listryjss);
    //去重
   // listryjss = (NSMutableArray*)[[NSSet setWithArray:listryjss] allObjects];
    if (listryjss.count==0) {
        [Tools showMsgBox:@"请选择人员"];
        return;
    }
    [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
    [self partFlowPermit:intnextgzrylsh strnextgzrylx:strnextgzrylx strczrxm:[_savedic objectForKey:@"strczrxm"]];
  //  [self getperson];
}

-(void)okSEL1:(UIButton*)sender
{
    listryjss=[[NSMutableArray alloc]init];
    
    for (LBTreeViewNode *treenode in self.displayArray) {
        for (LBTreeViewNode *treenode1 in treenode.nodeChildren) {
            if (treenode1.isCheck) {
                if ([treenode1.returnType isEqualToString:@"dep"]){
                    if (treenode1.nodeChildren.count>0) {
                        for (LBTreeViewNode *treenode11 in treenode1.nodeChildren) {
                            if (treenode11.isCheck&&treenode1.isselect!=YES) {
                                [listryjss addObject:treenode11];
                            }
                        }
                    }
                }
                else if([treenode1.returnType isEqualToString:@"peo"]&&[treenode1.hasnext intValue]==0&&treenode1.isselect!=YES)
                {
                    [listryjss addObject:treenode1];
                }
            }
        }
    }
    NSLog(@"%@",listryjss);
    if (listryjss.count==0) {
        [Tools showMsgBox:@"请选择人员"];
        return;
    }
    [SVProgressHUD showWithStatus:@"保存中..." maskType:SVProgressHUDMaskTypeClear];
    [self getperson];
}
#pragma mark--------------选择人员接口-------------
-(void)getperson{
    [SHNetWork getPeople:[_savedic objectForKey:@"intdwlsh"] intnextgzlclsh:intnextgzlclsh intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] intlcczlsh:intlcczlsh type:@"1" completionBlock:^(id rep, NSString *emsg) {
        NSLog(@"%@",[rep JSONString]);
        if ([[rep objectForKey:@"flag"] intValue]==0) {
            NSString *intnextgzrylsh=@"";
             NSString *strnextgzrylx=@"";
            NSString *strczrxm=@"";
            if ([[rep objectForKey:@"rType"] intValue]==1) {
               intnextgzrylsh=rep[@"data"][@"strqszrrlsh"];
                strczrxm=rep[@"data"][@"strqszrrmc"];
                strnextgzrylx=@"2";
                if ([Tools isBlankString:intnextgzrylsh]) {
                    intnextgzrylsh=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]objectForKey:@"intrylsh"];
                    strczrxm=[_savedic objectForKey:@"strczrxm"];
                }
            }
            else if ([[rep objectForKey:@"rType"] intValue]==5)
            {
                intnextgzrylsh=rep[@"data"][@"strqszrrlsh"];
                strczrxm=rep[@"data"][@"strqszrrmc"];
                strnextgzrylx=@"1";
                if ([Tools isBlankString:intnextgzrylsh]) {
                    intnextgzrylsh=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]objectForKey:@"intrylsh"];
                    strczrxm=[_savedic objectForKey:@"strczrxm"];
                    strnextgzrylx=@"2";
                }
            }
            else if ([[rep objectForKey:@"rType"] intValue]==6)
            {
                intnextgzrylsh=rep[@"data"][@"intzrrlsh"];
                 strczrxm=rep[@"data"][@"strzrrmc"];
                strnextgzrylx=@"2";
                if ([Tools isBlankString:intnextgzrylsh]) {
                    intnextgzrylsh=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]objectForKey:@"intrylsh"];
                    strczrxm=[_savedic objectForKey:@"strczrxm"];
                    strnextgzrylx=@"2";
                }
            }
            else
            {
                intnextgzrylsh=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"]objectForKey:@"intrylsh"];
                strczrxm=[_savedic objectForKey:@"strczrxm"];
                strnextgzrylx=@"2";
            }
            [self partFlowPermit:intnextgzrylsh strnextgzrylx:strnextgzrylx strczrxm:strczrxm];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
        }
    }];
}

#pragma mark-----------操作人员-------

/**
 提交选中的数据

 @param intnextgzrylsh 下一步工作人员流水号
 @param strnextgzrylx 下一步工作人员类型
 @param strczrxm 操作人名称
 */
-(void)partFlowPermit:(NSString*)intnextgzrylsh strnextgzrylx:(NSString*)strnextgzrylx strczrxm:(NSString*)strczrxm
{
    NSMutableString *intbzlst=[NSMutableString string];
    NSMutableString *intlcdylshlst=[NSMutableString string];
    NSMutableString *strzrrlxLst=[NSMutableString string];
    NSMutableString *intbcbhlst =[NSMutableString string];
    NSMutableString *intrylshlst =[NSMutableString string];
    NSMutableString *strlzlxlst =[NSMutableString string];
    intgzlclshlst=[[NSMutableString alloc]init];
    for (int i=0; i<listryjss.count; i++) {
        LBTreeViewNode *treenode=[listryjss objectAtIndex:i];
        if (listryjss.count==i+1) {
            [intbzlst appendFormat:@"1,"];
            [intlcdylshlst appendFormat:@"0,"];
            [strzrrlxLst appendFormat:@"%@,", treenode.strzrrlxLst];//---
            [intbcbhlst appendFormat:@"1,"];
            [intrylshlst appendFormat:@"%@",treenode.intrylsh];
            [strlzlxlst appendFormat:@"%@",self.lint==1?@"1":@"0"];
            [intgzlclshlst appendFormat:@"%@",treenode.intgzlclshlst];
        }
        else
        {
            [intbzlst appendFormat:@"1,"];
            [intlcdylshlst appendFormat:@"0,"];
            [strzrrlxLst appendFormat:@"%@,", treenode.strzrrlxLst];
            [intbcbhlst appendFormat:@"1,"];
            [intrylshlst appendFormat:@"%@,",treenode.intrylsh];
            [strlzlxlst appendFormat:@"%@,",self.lint==1?@"1":@"0"];
            [intgzlclshlst appendFormat:@"%@,",treenode.intgzlclshlst];
        }
    }
    [SHNetWork partFlowPermit:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] strczrxm:strczrxm intlcczlsh:intlcczlsh intrylshlst:intrylshlst intbcbhlst:intbcbhlst intgzlclshlst:intgzlclshlst strlzlxlst:strlzlxlst intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intbzlst:intbzlst intlcdylshlst:intlcdylshlst strnextgzrylx:strnextgzrylx intnextgzrylsh:intnextgzrylsh strzrrlxLst:strzrrlxLst lint:self.bzlcint completionBlock:^(id rep, NSString *emsg) {
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


-(void)gogo
{
    for (id views in self.navigationController.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.navigationController popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
}
-(void)setZrrValue:(NSMutableArray *)value andid:(id)lbs andGupID:(NSString *)gupid
{
    if ([gupid isEqualToString:@"选择人员"]) {
        zdrydic=[value objectAtIndex:0];
        UIButton *sender=(UIButton*)lbs;
        [sender setTitle:[zdrydic objectForKey:@"strryxm"] forState:0];
    }
}
#pragma mark-----------------选择指定人员-------------
-(void)choosePersonSEL:(UIButton*)sender
{
    LBChoosePersonViewController *lbchoosePerson=[[LBChoosePersonViewController alloc]init];
    lbchoosePerson.title=@"选择指定人员";
    lbchoosePerson.type=@"人员";
    lbchoosePerson.singordouble=YES;
    lbchoosePerson.lbs=sender;
    lbchoosePerson.gupid=@"选择人员";
    lbchoosePerson.delegate=self;
    [self.navigationController pushViewController:lbchoosePerson animated:YES];
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
