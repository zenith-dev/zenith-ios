//
//  LBAppointViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/24.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBAppointViewController.h"
#import "LBrightImageButton.h"
#import "SHbsTableViewCell.h"
#import "LBAgentsViewController.h"
#import "QRadioButton.h"
#import "TreeViewNode.h"
@interface LBAppointViewController ()<UITableViewDataSource,UITableViewDelegate,QRadioButtonDelegate,UIAlertViewDelegate>
{
    UITableView *lbpersontb;
    NSMutableArray *dwary;//单位列表
    NSString *bolsendsms;//是否发送短信（0：不发，1：发送）
    NSMutableArray *levelarray;//层次数组
    NSInteger rootlength;
    NSDictionary *rtyperydic;//
}
@property(nonatomic,strong)NSMutableArray *displayArray;
@end

@implementation LBAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //短信提示
    UIView *msgpromptView=[[UIView alloc]initWithFrame:CGRectMake(0, 20,kScreenWidth, 40)];
    [msgpromptView setBackgroundColor:[UIColor whiteColor]];
    NSString *msgstr=@"短信提示:";
    UILabel *msglb=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, [msgstr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width, H(msgpromptView))];
    msglb.text=msgstr;
    msglb.font=Font(14);
    msglb.textColor=[SingleObj defaultManager].mainColor;
    [msgpromptView addSubview:msglb];
    QRadioButton *msgqr=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr.tag=1000;
    
    [msgqr setTitle:@"是" forState:0];
    msgqr.frame=CGRectMake(XW(msglb)+5, 0, 60,H(msglb));
    [msgpromptView addSubview:msgqr];
    
    QRadioButton *msgqr1=[[QRadioButton alloc]initWithDelegate:self groupId:@"msg"];
    msgqr1.tag=1001;
    msgqr1.checked=YES;
    [msgqr1 setTitle:@"否" forState:0];
    msgqr1.frame=CGRectMake(XW(msgqr)+10, 0, W(msgqr),H(msglb));
    [msgpromptView addSubview:msgqr1];
    //line
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(msglb), W(msgpromptView), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [msgpromptView addSubview:oneline];
    msgpromptView.frame=CGRectMake(X(msgpromptView), Y(msgpromptView), W(msgpromptView), YH(oneline));
    
    lbpersontb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    lbpersontb.showsVerticalScrollIndicator=NO;
    
    [lbpersontb setBackgroundColor:[SingleObj defaultManager].backColor];
    
    lbpersontb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbpersontb];
    [lbpersontb setTableHeaderView:msgpromptView];
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    lbpersontb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    // 马上进入刷新状态
    [lbpersontb.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)loadNewData
{
    if (self.lcint ==2||self.lcint ==12) {
        [self getDepartment];
    }
    else if (self.lcint ==4||self.lcint ==13)
    {
        [self getPelp];
    }
}


-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId
{
    if ([groupId isEqualToString:@"msg"]) {
        if (radio.tag==1000)
        {
            bolsendsms=@"1";
        }
        else
        {
            bolsendsms=@"0";
        }
    }
    
}
#pragma mark-------------------查询单位----------
-(void)getDepartment
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getDepartment:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",rep);
                dwary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (dwary.count>0) {
                    lbpersontb.dataSource=self;
                    lbpersontb.delegate=self;
                }
                rootlength=3*10;
                for (NSDictionary *dic in dwary) {
                    if ([[dic objectForKey:@"strdwccbm"] length]<rootlength) {
                        rootlength=[[dic objectForKey:@"strdwccbm"] length];
                    }
                }
                levelarray=[[NSMutableArray alloc]init];
                for (int j=0; j<dwary.count; j++) {
                    NSDictionary *dic=[dwary objectAtIndex:j];
                    if ([[dic objectForKey:@"strdwccbm"] length]==rootlength) {
                        TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
                        firstLevelNode1.nodeLevel = 0;
                        firstLevelNode1.nodeObject = [dic objectForKey:@"strdwjc"];
                        firstLevelNode1.strdwccbm=[dic objectForKey:@"strdwccbm"];
                        firstLevelNode1.rymc=[dic objectForKey:@"strryxm"];
                        firstLevelNode1.intlsh=[dic objectForKey:@"intdwlsh"];
                        firstLevelNode1.isExpanded = NO;//是否收缩
                        firstLevelNode1.check=NO;//是否选中
                        firstLevelNode1.nodeChildren = [self childrenfarther:[dic objectForKey:@"strdwccbm"] level:1];
                        [levelarray addObject:firstLevelNode1];
                    }
                }
                NSLog(@"%@",levelarray);
                [self fillDisplayArray];
                [lbpersontb reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
        [lbpersontb.mj_header endRefreshing];
    }];
}
#pragma mark-------------------查询单位人员----------
-(void)getDepartmentPeoplestrdwccbm:(NSString*)strdwccbm
{
    [SHNetWork getDepartmentPeople:strdwccbm completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",[rep JSONString]);
                dwary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                if (dwary.count>0) {
                    lbpersontb.dataSource=self;
                    lbpersontb.delegate=self;
                }
                levelarray=[[NSMutableArray alloc]init];
                rootlength=3*10;
                for (NSDictionary *dic in dwary) {
                    if ([[dic objectForKey:@"strdwccbm"] length]<rootlength) {
                        rootlength=[[dic objectForKey:@"strdwccbm"] length];
                    }
                }
                NSMutableArray *tempary=[[NSMutableArray alloc]init];
                NSString *strtempstrdwccbm=@"";
                for (int i=0; i<dwary.count; i++) {
                    NSDictionary *dwarydic=[dwary objectAtIndex:i];
                    NSString *tempstrdwccbm=[dwarydic objectForKey:@"strdwccbm"];
                    if (rootlength==tempstrdwccbm.length) {
                        if (![strtempstrdwccbm isEqualToString:tempstrdwccbm]) {
                            [tempary addObject:dwarydic];
                            strtempstrdwccbm=[NSString stringWithFormat:@"%@",tempstrdwccbm];
                        }
                    }
                }
                for (NSDictionary *childdic in tempary) {
                    //根节点
                    TreeViewNode *rootchildern = [[TreeViewNode alloc]init];
                    rootchildern.nodeLevel = 0;
                    rootchildern.intlsh=[childdic objectForKey:@"intrylsh"];
                    rootchildern.strdwccbm=[childdic objectForKey:@"strdwccbm"];
                    rootchildern.rymc=[childdic objectForKey:@"strryxm"];
                    rootchildern.nodeChildren = [self childrenfarther1:[childdic objectForKey:@"strdwccbm"] level1:1];
                    if (rootchildern.nodeChildren.count!=0) {
                        rootchildern.nodeObject =[childdic objectForKey:@"strdwjc"];
                    }
                    else
                    {
                        rootchildern.nodeObject =[childdic objectForKey:@"strryxm"];
                    }
                    rootchildern.check=NO;
                    [levelarray addObject:rootchildern];
                    BOOL isfl=NO;
                    for (TreeViewNode *rootch in rootchildern.nodeChildren) {
                        if ([rootch.strdwccbm isEqualToString:[childdic objectForKey:@"strdwccbm"]]) {
                            isfl=YES;
                        }
                    }
                    if (isfl==NO) {
                        //人员信息
                        TreeViewNode *childern = [[TreeViewNode alloc]init];
                        childern.nodeLevel = 1;
                        childern.intlsh=[childdic objectForKey:@"intrylsh"];
                        childern.strdwccbm=[childdic objectForKey:@"strdwccbm"];
                        childern.rymc=[childdic objectForKey:@"strryxm"];
                        childern.nodeObject =[childdic objectForKey:@"strryxm"];
                        childern.check=NO;
                        [rootchildern.nodeChildren addObject:childern];
                    }
                }
                
                NSLog(@"%@",levelarray);
                [self fillDisplayArray];
                [lbpersontb reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:[rep objectForKey:@"msg"]];
            }
        }else
        {
            [SVProgressHUD showInfoWithStatus:emsg];
        }
        [lbpersontb.mj_header endRefreshing];
    }];
}
-(void)getPelp
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getPeople:[_savedic objectForKey:@"intdwlsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] intbzjllsh:[_savedic objectForKey:@"intbzjllsh"] intlcczlsh:[_savedic objectForKey:@"intlcczlsh"] type:nil completionBlock:^(id rep, NSString *emsg) {
            if (!emsg) {
                if ([[rep objectForKey:@"flag"] intValue]==0) {
                   
                    levelarray=[[NSMutableArray alloc]init];
                    if ([[rep objectForKey:@"rType"] intValue]==2) {
                         [SVProgressHUD dismiss];
                        dwary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                         NSMutableArray *tempary=[[NSMutableArray alloc]initWithArray:[rep objectForKey:@"data"]];
                        if (dwary.count>0) {
                            lbpersontb.dataSource=self;
                            lbpersontb.delegate=self;
                        }
                        
                         for (NSDictionary *childdic in tempary)
                         {
                             //根节点
                             TreeViewNode *rootchildern = [[TreeViewNode alloc]init];
                             rootchildern.nodeLevel = 0;
                             rootchildern.intlsh=[childdic objectForKey:@"intrylsh"];
                             rootchildern.strdwccbm=[childdic objectForKey:@"strdwccbm"];
                             rootchildern.rymc=[childdic objectForKey:@"strryxm"];
                             [levelarray addObject:rootchildern];
                         }
                        [self fillDisplayArray];
                        [lbpersontb reloadData];
                    }
                    else if ([[rep objectForKey:@"rType"] intValue]==1)
                    {
                         [SVProgressHUD dismiss];
                        rtyperydic=[[NSMutableDictionary alloc]initWithDictionary:[rep objectForKey:@"data"]];
                        NSString *str=[NSString stringWithFormat:@"是否指定:%@",[rtyperydic objectForKey:@"strryjc"]];
                        UIAlertView *alertviews=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertviews.tag=99999;
                        [alertviews show];

                    }
                else if([[rep objectForKey:@"rType"] intValue]==3)
                {
                    [self getDepartmentPeoplestrdwccbm:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"]];
                }
                else if ([[rep objectForKey:@"rType"] intValue]==4)
                {
                    [self getDepartmentPeoplestrdwccbm:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strcsdwccbm"]];
                
                }
            }else
            {
                [SVProgressHUD showInfoWithStatus:emsg];
            }
            [lbpersontb.mj_header endRefreshing];
        }
    }];
}
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in levelarray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
-(NSMutableArray*)childrenfarther1:(NSString*)strdwccbm1 level1:(NSInteger)i
{
    NSMutableArray *childenary=[[NSMutableArray alloc]init];
    NSMutableArray *tempary=[[NSMutableArray alloc]init];
    NSString *strtempstrdwccbm=@"";
    for (int i=0; i<dwary.count; i++) {
        NSDictionary *dwarydic=[dwary objectAtIndex:i];
        NSString *tempstrdwccbm=[dwarydic objectForKey:@"strdwccbm"];
        if (strdwccbm1.length<tempstrdwccbm.length&&[strdwccbm1 isEqualToString:[tempstrdwccbm substringToIndex:strdwccbm1.length]]) {
            if (![strtempstrdwccbm isEqualToString:tempstrdwccbm]) {
                [tempary addObject:dwarydic];
                strtempstrdwccbm=[NSString stringWithFormat:@"%@",tempstrdwccbm];
            }
        }
    }
    for (NSDictionary *childdic in tempary) {
        TreeViewNode *childern = [[TreeViewNode alloc]init];
        childern.nodeLevel = i;
        childern.intlsh=[childdic objectForKey:@"intrylsh"];
        childern.strdwccbm=[childdic objectForKey:@"strdwccbm"];
        childern.rymc=[childdic objectForKey:@"strdwjc"];
        childern.nodeChildren = [self childrenfarther1:[childdic objectForKey:@"strdwccbm"] level1:i+1];
        if (childern.nodeChildren.count!=0) {
            childern.nodeObject =[childdic objectForKey:@"strdwjc"];
        }
        else
        {
            childern.nodeObject =[childdic objectForKey:@"strdwjc"];
        }
        childern.check=NO;
        [childenary addObject:childern];
    }
    if (childenary.count==0) {
        for (NSDictionary *chidic in dwary) {
            if ([[chidic objectForKey:@"strdwccbm"] isEqualToString:strdwccbm1]) {
                TreeViewNode *childern = [[TreeViewNode alloc]init];
                childern.nodeLevel = i;
                childern.intlsh=[chidic objectForKey:@"intrylsh"];
                childern.strdwccbm=[chidic objectForKey:@"strdwccbm"];
                childern.rymc=[chidic objectForKey:@"strryxm"];
                [childenary addObject:childern];
            }
        }
    }
    return childenary;
}
-(NSMutableArray*)childrenfarther:(NSString*)strdwccbm level:(NSInteger)i
{
    NSMutableArray *childenary=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in dwary) {
        if ([strdwccbm length]<[[dic objectForKey:@"strdwccbm"]length]&&[strdwccbm isEqualToString:[[dic objectForKey:@"strdwccbm"] substringToIndex:[[dic objectForKey:@"strdwccbm"] length]- 3]]) {
            TreeViewNode *childern = [[TreeViewNode alloc]init];
            childern.nodeLevel = i;
            childern.intlsh=[dic objectForKey:@"intdwlsh"];
            childern.strdwccbm=[dic objectForKey:@"strdwccbm"];
            childern.nodeObject = [dic objectForKey:@"strdwjc"];
            childern.rymc=[dic objectForKey:@"strryxm"];
            childern.nodeChildren = [self childrenfarther:[dic objectForKey:@"strdwccbm"] level:i+1];
            childern.check=NO;
            [childenary addObject:childern];
        }
    }
    return childenary;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.displayArray.count;
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
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    TreeViewNode *treenode =[self.displayArray objectAtIndex:indexPath.row];
    NSString *shownamestr;
    float whi=0;
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
        shownamestr=treenode.nodeObject;
    }
    else
    {
        
        if (self.lcint ==2||self.lcint==12) {
            shownamestr=treenode.nodeObject;
            
        }
        else
        {
            UIImageView *hedimg=[[UIImageView alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10, 11, 18, 18)];
            [hedimg setImage:PNGIMAGE(@"iv_head")];
            [headerview addSubview:hedimg];
            shownamestr=treenode.rymc;
            whi+=18;
            
        }
    }
    UILabel *qcheckBox=[[UILabel alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10+whi, 0,  [shownamestr sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40)];
    qcheckBox.text=shownamestr;
    qcheckBox.font=Font(14);
    [headerview addSubview:qcheckBox];
    [headerview addSubview:qcheckBox];
    UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(qcheckBox), W(headerview), 1)];
    [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
    [headerview addSubview:oneline];
    headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
    cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=[NSString stringWithFormat:@"是否指定%@",self.lcint ==2?@"单位":self.lcint ==4?@"人员":self.lcint ==12?@"处室":self.lcint ==13?@"承办人":@"未知"];
    UIAlertView *alertviews=[[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertviews.tag=indexPath.row;
    [alertviews show];
}
#pragma mark------------------initview---------------
-(void)expand:(UIButton*)sender
{
    TreeViewNode *treenode =[self.displayArray objectAtIndex:sender.tag-1000];
    treenode.isExpanded = !treenode.isExpanded;
    [self.displayArray replaceObjectAtIndex:sender.tag-1000 withObject:treenode];
    [self fillDisplayArray];
    [lbpersontb reloadData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSDictionary *getdic=nil;
    if (alertView.tag!=99999) {
        for (NSDictionary *dic in dwary) {
            TreeViewNode *node = [self.displayArray objectAtIndex:alertView.tag];
            NSString *lsh=self.lcint==2?[dic objectForKey:@"intdwlsh"]:[dic objectForKey:@"intrylsh"];
            if ([lsh isEqualToString:node.intlsh]) {
                getdic=dic;
                break;
            }
        }

    }
    else
    {
        getdic =@{@"intrylsh":[rtyperydic objectForKey:@"strqszrrlsh"]};
    }
    if (buttonIndex==1) {
        [SVProgressHUD showWithStatus:@"操作中..." maskType:SVProgressHUDMaskTypeClear];
        if (self.lcint==2) {
            [SHNetWork appointDepartment:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] intzrrlshlst:[getdic objectForKey:@"intdwlsh"] strczrxm:[_savedic objectForKey:@"strryxm"] bolsendsms:bolsendsms completionBlock:^(id rep, NSString *emsg) {
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
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
        else if (self.lcint==4)
        {
            [SHNetWork appointPeople:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] intzrrlshlst:[getdic objectForKey:@"intrylsh"] strczrxm:[_savedic objectForKey:@"strryxm"] bolsendsms:bolsendsms completionBlock:^(id rep, NSString *emsg) {
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
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
        else if (self.lcint==13)
        {
            [SHNetWork appointUndertakePeople:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] intzrrlshlst:[getdic objectForKey:@"intrylsh"] strczrxm:[_savedic objectForKey:@"strryxm"] bolsendsms:bolsendsms intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] completionBlock:^(id rep, NSString *emsg) {
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
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }else if (self.lcint==12)
        {
            [SHNetWork appointCS:[_savedic objectForKey:@"intbzjllsh"] intczrylsh:[_savedic objectForKey:@"intczrylsh"] intnextgzlclsh:[_savedic objectForKey:@"intnextgzlclsh"] intzrrlshlst:[getdic objectForKey:@"intdwlsh"] strczrxm:[_savedic objectForKey:@"strryxm"] bolsendsms:bolsendsms intgwlzlsh:[_savedic objectForKey:@"intgwlzlsh"] completionBlock:^(id rep, NSString *emsg) {
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
                }else
                {
                    [SVProgressHUD showInfoWithStatus:emsg];
                }
            }];
        }
    }
    
}
-(void)gogo{
    for (id views in self.navigationController.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.navigationController popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
    
    [self.detailContorller getSwBumphInfo];
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
