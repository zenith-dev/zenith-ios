
//
//  LBSendLinderViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/27.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBSendLinderViewController.h"
#import "LBTreeViewNode.h"
#import "SHbsTableViewCell.h"
#import "LBrightImageButton.h"
#import "QCheckBox.h"
#import "LBAgentsViewController.h"
@interface LBSendLinderViewController ()<QCheckBoxDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *lindertb;
    NSMutableArray *readyarray;//已经选择领导
    NSMutableArray *yxldarray;//已选领导
    NSMutableArray *ldpsarray;//领导批示
    NSString *intnextgzlclsh;//下一个流程处理流水号
    NSString *intgzlclsh;//工作流程流水号
    NSString *cintgzlclsh;
}
@property (nonatomic, retain) NSMutableArray *displayArray;
@property (nonatomic, retain) NSMutableArray *displayArray1;
@end

@implementation LBSendLinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:[SingleObj defaultManager].backColor];
    [self rightButton:@"确定" image:nil sel:@selector(okSEL:)];
    
    lindertb =[[UITableView alloc]initWithFrame:CGRectMake(5,5,kScreenWidth-10, kScreenHeight-10) style:UITableViewStyleGrouped];
    lindertb.showsVerticalScrollIndicator=NO;
    lindertb.dataSource=self;
    lindertb.delegate=self;
    [lindertb setBackgroundColor:[SingleObj defaultManager].backColor];
    lindertb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lindertb];
    [self getExistSubFlowPeople];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark------------------查询已定义的工作流程名单--------------
-(void)getExistSubFlowPeople
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getExistSubFlowPeople:[_savedic objectForKey:@"intbzjllsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                readyarray=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                yxldarray=[[NSMutableArray alloc]init];
                LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                lbtree.nodeLevel=0;
                lbtree.strgzrw=@"已选领导";
                lbtree.isExpanded=YES;
                lbtree.isCheck=NO;
                lbtree.intrylsh=nil;
                lbtree.nodeChildren=[self childern1:[rep objectForKey:@"data"]];
                [yxldarray addObject:lbtree];
                [self fillDisplayArray1];
                [self getWorkTaskPeople];
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
#pragma mark-----------------查询工作任务领导------------
-(void)getWorkTaskPeople
{
    [SHNetWork getWorkTaskPeople:[_savedic objectForKey:@"intlcczlsh"] intdwlsh:[_savedic objectForKey:@"intdwlsh"] strlclxbm:[_savedic objectForKey:@"strlclxbm"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",[rep JSONString]);
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                intnextgzlclsh=[[rep objectForKey:@"data"] objectForKey:@"strnextgzlclsh"];
                intgzlclsh=[[[[rep objectForKey:@"data"] objectForKey:@"lstGzlc"] objectAtIndex:0]objectForKey:@"intgzlclsh"];
                cintgzlclsh=[[rep objectForKey:@"data"] objectForKey:@"intgzlclsh"];
                
                NSMutableArray *lstGzlc=[[NSMutableArray alloc]initWithArray:[[rep objectForKey:@"data"] objectForKey:@"lstGzlc"]];
                ldpsarray=[[NSMutableArray alloc]init];
                for (int i=0; i<lstGzlc.count; i++) {
                    NSDictionary *gzlc=[lstGzlc objectAtIndex:i];
                    LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
                    lbtree.nodeLevel=0;
                    lbtree.strgzrw=[gzlc objectForKey:@"strgzrw"];
                    lbtree.isExpanded=NO;
                    lbtree.isCheck=NO;
                    lbtree.intgzlclsh=[gzlc objectForKey:@"intgzlclsh"];
                    lbtree.intgzlclshlst=[gzlc objectForKey:@"intgzlclsh"];
                    lbtree.intrylsh=[gzlc objectForKey:@"intrylsh"];
                    NSMutableArray *listryjs=[[NSMutableArray alloc]init];;
                    for (NSDictionary *listdic in [gzlc objectForKey:@"listryjs"]) {
                        NSMutableDictionary *dis=[[NSMutableDictionary alloc]initWithDictionary:listdic];
                        [dis setObject:[gzlc objectForKey:@"intgzlclsh"] forKey:@"intgzlclsh"];
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
-(NSMutableArray*)childern1:(NSMutableArray*)childern
{
    NSMutableArray *carray=[[NSMutableArray alloc]init];
    for (int i=0; i<childern.count; i++) {
        NSDictionary *childerndic=[childern objectAtIndex:i];
        LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
        lbtree.intbcbh=[childerndic objectForKey:@"intbcbh"];
        lbtree.strgzrw=[childerndic objectForKey:@"strryxm"];
        lbtree.intpxh=[childerndic objectForKey:@"intpxh"];
        lbtree.strdlm=[childerndic objectForKey:@"strdlm"];
        lbtree.intjsid=[childerndic objectForKey:@"intjsid"];
        lbtree.stryddh=[childerndic objectForKey:@"stryddh"];
        lbtree.intgzlclshlst=[childerndic objectForKey:@"intgzlclsh"];
        lbtree.isExpanded=YES;
        lbtree.nodeLevel=1;
        lbtree.isCheck=NO;
        lbtree.intrylsh=[childerndic objectForKey:@"intrylsh"];
        lbtree.nodeChildren=nil;
        [carray addObject:lbtree];
    }
    return carray;
}

-(NSMutableArray*)childern:(NSMutableArray*)childern
{
    NSMutableArray *carray=[[NSMutableArray alloc]init];
    for (int i=0; i<childern.count; i++) {
        NSDictionary *childerndic=[childern objectAtIndex:i];
        LBTreeViewNode *lbtree=[[LBTreeViewNode alloc]init];
        lbtree.strgzrw=[childerndic objectForKey:@"strryxm"];
        lbtree.intpxh=[childerndic objectForKey:@"intpxh"];
        lbtree.strdlm=[childerndic objectForKey:@"strdlm"];
        lbtree.intjsid=[childerndic objectForKey:@"intjsid"];
        lbtree.stryddh=[childerndic objectForKey:@"stryddh"];
        lbtree.intgzlclshlst=[childerndic objectForKey:@"intrylsh"];
        lbtree.intgzlclsh=[childerndic objectForKey:@"intgzlclsh"];
        lbtree.isExpanded=NO;
        lbtree.nodeLevel=1;
        lbtree.isCheck=NO;
        lbtree.intrylsh=[childerndic objectForKey:@"intrylsh"];
        lbtree.nodeChildren=nil;
        [carray addObject:lbtree];
    }
    return carray;
}

- (void)fillDisplayArray1
{
    self.displayArray1 = [[NSMutableArray alloc]init];
    for (LBTreeViewNode *node in yxldarray) {
        [self.displayArray1 addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray1:node.nodeChildren];
        }
    }
}
- (void)fillNodeWithChildrenArray1:(NSArray *)childrenArray
{
    for (LBTreeViewNode *node in childrenArray) {
        [self.displayArray1 addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray1:node.nodeChildren];
        }
    }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.displayArray1.count;
    }
    else
    {
      return self.displayArray.count;
    }
    // Return the number of rows in the section.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    else
    {
        return 80;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
      return [self headView:@"已选领导"];
    }
    else
    {
       return [self headView:self.title];
    }
}
-(UIView*)headView:(NSString*)title
{
    UIView *head=[[UIView alloc]initWithFrame:CGRectMake(0, 0, W(lindertb), 40)];
    if ([title isEqualToString:self.title]) {
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
    if (indexPath.section==0) {
        LBTreeViewNode *treenode =[self.displayArray1 objectAtIndex:indexPath.row];
        UILabel *qcheckBox=[[UILabel alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10, 0,  [treenode.strgzrw sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40)];
        if ([Tools isBlankString:treenode.intbcbh]) {
            qcheckBox.text=[NSString stringWithFormat:@"%@",treenode.strgzrw];
        }
        else
        {
              qcheckBox.text=[NSString stringWithFormat:@"%@ - %@",treenode.intbcbh,treenode.strgzrw];
        }
        qcheckBox.font=Font(14);
        [headerview addSubview:qcheckBox];
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(qcheckBox), W(headerview), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [headerview addSubview:oneline];
        headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    }else if (indexPath.section==1) {
        LBTreeViewNode *treenode =[self.displayArray objectAtIndex:indexPath.row];
        if (treenode.nodeChildren.count!=0) {
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
        if (treenode.intrylsh!=nil) {
            QCheckBox *qcheckBox=[[QCheckBox alloc]initWithDelegate:self];
            qcheckBox.frame=CGRectMake(treenode.nodeLevel*25+10, 0,  [treenode.strgzrw sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40);
            [qcheckBox setTitle:treenode.strgzrw forState:0];
            [qcheckBox setTitleColor:[UIColor blackColor] forState:0];
            qcheckBox.titleLabel.font=Font(14);
            qcheckBox.tag=indexPath.section*1000+indexPath.row;
            qcheckBox.selected=treenode.isCheck;
            [headerview addSubview:qcheckBox];
            for (NSDictionary *dic in readyarray) {
                if ([[dic objectForKey:@"intrylsh"] isEqualToString:treenode.intrylsh]&&[[dic objectForKey:@"intgzlclsh"] isEqualToString:treenode.intgzlclsh]) {
                    qcheckBox.selected=YES;
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
-(void)expand:(UIButton*)sender
{
    LBTreeViewNode *treenode =[self.displayArray objectAtIndex:sender.tag-1000];
    treenode.isExpanded = !treenode.isExpanded;
    [self.displayArray replaceObjectAtIndex:sender.tag-1000 withObject:treenode];
    [self fillDisplayArray];
    [lindertb reloadData];
}
-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    LBTreeViewNode *treenode = [self.displayArray objectAtIndex:checkbox.tag-1000];
    treenode.isCheck=!treenode.isCheck;
    [lindertb reloadData];
}
#pragma mark-------------------确定-----------------
-(void)okSEL:(UIButton*)sender
{
    NSMutableString *intrylshlst=[NSMutableString string];
    NSMutableString *intbcbhlst=[NSMutableString string];
    NSMutableString *intgzlclshlst=[NSMutableString string];
    NSMutableString *strlzlxlst=[NSMutableString string];
    NSMutableString *intbzlst=[NSMutableString string];
    NSMutableString *intlcdylshlst=[NSMutableString string];
    NSMutableArray *listryjs=[[NSMutableArray alloc]init];
    for (LBTreeViewNode *treenode in self.displayArray) {
        for (LBTreeViewNode *treenode1 in treenode.nodeChildren) {
            if (treenode1.isCheck) {
                [listryjs addObject:treenode1];
            }
        }
    }
    NSLog(@"%@",listryjs);
    if (listryjs.count+readyarray.count==0) {
        [Tools showMsgBox:@"请选择人员"];
        return;
    }
    [SVProgressHUD showWithStatus:@"提交中..." maskType:SVProgressHUDMaskTypeClear];
    int intbcbh=0;
    for (int i=0; i<readyarray.count; i++) {
        NSDictionary *readdic=[readyarray objectAtIndex:i];
        if (readyarray.count==i+1&&listryjs.count==0) {
            [intrylshlst appendFormat:@"%@,",[readdic objectForKey:@"intrylsh"]];
            [intbcbhlst appendFormat:@"%@,",[readdic objectForKey:@"intbcbh"]];
            [intgzlclshlst appendFormat:@"%@,",cintgzlclsh];
            [strlzlxlst appendFormat:@"0,"];
            [intbzlst appendFormat:@"0,"];
            [intlcdylshlst appendFormat:@"%@",[readdic objectForKey:@"intlcdylsh"]];
        }
        else
        {
            [intrylshlst appendFormat:@"%@,",[readdic objectForKey:@"intrylsh"]];
            [intbcbhlst appendFormat:@"%@,",[readdic objectForKey:@"intbcbh"]];
            [intgzlclshlst appendFormat:@"%@,",cintgzlclsh];
            
            [strlzlxlst appendFormat:@"0,"];
            [intbzlst appendFormat:@"0,"];
            [intlcdylshlst appendFormat:@"%@,",[readdic objectForKey:@"intlcdylsh"]];
        }
        if (intbcbh<[[readdic objectForKey:@"intbcbh"] intValue]) {
            intbcbh=[[readdic objectForKey:@"intbcbh"] intValue];
        }
    }
    for (int i=0; i<listryjs.count; i++) {
        LBTreeViewNode *treenode=[listryjs objectAtIndex:i];
        if (listryjs.count==i+1) {
            [intrylshlst appendFormat:@"%@,",treenode.intrylsh];
            [intbcbhlst appendFormat:@"%i,",intbcbh+1];
            [intgzlclshlst appendFormat:@"%@,",treenode.intgzlclsh];
            [strlzlxlst appendFormat:@"0,"];
            [intbzlst appendFormat:@"1,"];
            [intlcdylshlst appendFormat:@"0,"];
        }
        else
        {
            [intrylshlst appendFormat:@"%@,",treenode.intrylsh];
             [intbcbhlst appendFormat:@"%i,",intbcbh+1];
            [intgzlclshlst appendFormat:@"%@,",treenode.intgzlclsh];
            [strlzlxlst appendFormat:@"0,"];
            [intbzlst appendFormat:@"1,"];
            [intlcdylshlst appendFormat:@"0,"];
        }
    }
    [SHNetWork subFlowPermit:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:intnextgzlclsh intrylshlst:intrylshlst intgzlclshlst:intgzlclshlst strlzlxlst:strlzlxlst intbzlst:intbzlst intlcdylshlst:intlcdylshlst intbcbhlst:intbcbhlst strczrxm:[_savedic objectForKey:@"strczrxm"] completionBlock:^(id rep, NSString *emsg) {
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
    for (id views in self.navigationController.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.navigationController popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
    //[self.navigationController popViewControllerAnimated:YES];
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
