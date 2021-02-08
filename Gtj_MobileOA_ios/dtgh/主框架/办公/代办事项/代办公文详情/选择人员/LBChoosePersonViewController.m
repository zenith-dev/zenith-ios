//
//  LBChoosePersonViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/20.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBChoosePersonViewController.h"
#import "SHbsTableViewCell.h"
#import "QCheckBox.h"
#import "LBrightImageButton.h"
#import "TreeViewNode.h"
@interface LBChoosePersonViewController ()<UITableViewDataSource,UITableViewDelegate,QCheckBoxDelegate>
{
    UITableView *lbpersontb;
    NSMutableArray *levelarray;//层次数组
    NSMutableArray *dwary;//单位列表
    NSMutableArray *checkarray;//选中的人员
    NSInteger rootlength;
}
@property (nonatomic, retain) NSMutableArray *displayArray;
@end
@implementation LBChoosePersonViewController
@synthesize qcheckary;
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.singordouble==NO) {
        [self rightButton:@"确定" image:nil sel:@selector(choosePerson:)];
    }
    lbpersontb=[[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight)];
    lbpersontb.showsVerticalScrollIndicator=NO;
    [lbpersontb setBackgroundColor:[SingleObj defaultManager].backColor];
    lbpersontb.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:lbpersontb];
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
-(void)getcheckarray:(NSMutableArray*)nodeChildren
{
    for (TreeViewNode *node in nodeChildren) {
        for (NSDictionary *dic in dwary) {
            if ([self.type  isEqualToString:@"部门"]||[self.type  isEqualToString:@"单位"]) {
                if (node.check&&[node.strdwccbm isEqualToString:[dic objectForKey:@"strdwccbm"]]&&node.nodeChildren.count==0) {
                    [checkarray addObject:dic];
                }
            }
            else{
                if (node.check&&[node.intlsh isEqualToString:[dic objectForKey:@"intrylsh"]]&&node.nodeChildren.count==0) {
                    [checkarray addObject:dic];
                }
            }
        }
        if (node.nodeChildren.count>0) {
            [self getcheckarray:node.nodeChildren];
        }
    }
}
#pragma mark--------------------选择人员--------------
-(void)choosePerson:(UIButton*)sender{
    checkarray=[[NSMutableArray alloc]init];
    
    for (TreeViewNode *node in levelarray) {
        for (NSDictionary *dic in dwary) {
            if ([self.type  isEqualToString:@"部门"]||[self.type  isEqualToString:@"单位"]) {
                if ([node.intlsh isEqualToString:[dic objectForKey:@"intdwlsh"]]&&node.nodeLevel!=0) {
                    [checkarray addObject:dic];
                }
            }
            else
            {
                if ([node.intlsh isEqualToString:[dic objectForKey:@"intrylsh"]]&&node.check==YES&&node.nodeChildren.count==0) {
                    [checkarray addObject:dic];
                }
            }
        }
        if (node.nodeChildren.count>0) {
            [self getcheckarray:node.nodeChildren];
        }
        
    }
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [checkarray count]; i++){
        if ([categoryArray containsObject:[checkarray objectAtIndex:i]] == NO){
            [categoryArray addObject:[checkarray objectAtIndex:i]];
        }
        
    }
    [self.delegate setZrrValue:categoryArray andid:self.lbs andGupID:self.gupid];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadNewData
{
    if ([self.type isEqualToString:@"单位"]) {
        [self getDepartment];
    }
    else if ([self.type isEqualToString:@"部门"])
    {
        [self getdw];
    }
    else if ([self.type isEqualToString:@"人员"])
    {
        [self getDepartmentPeople];
    }
}
#pragma mark-------------------查询单位人员----------
-(void)getDepartmentPeople
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getDepartmentPeople:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] completionBlock:^(id rep, NSString *emsg) {
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

#pragma mark-------------------查询单位----------
-(void)getDepartment
{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getDepartment:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] completionBlock:^(id rep, NSString *emsg) {
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
                for (int j=0; j<dwary.count; j++) {
                    NSDictionary *dic=[dwary objectAtIndex:j];
                    if ([[dic objectForKey:@"strdwccbm"] length]==3) {
                        TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
                        firstLevelNode1.nodeLevel = 0;
                        firstLevelNode1.nodeObject = [dic objectForKey:@"strdwjc"];
                        firstLevelNode1.strdwccbm=[dic objectForKey:@"strdwccbm"];
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
//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

#pragma mark------------------查询单位-----------
-(void)getdw{
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SHNetWork getDw:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"intdwlsh"] strdwccbm:[[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] objectForKey:@"strdwccbm"] completionBlock:^(id rep, NSString *emsg) {
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
                for (NSDictionary *dic in dwary) {
                    if ([[dic objectForKey:@"strdwccbm"] length]==3) {
                        TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
                        firstLevelNode1.nodeLevel = 0;
                        firstLevelNode1.nodeObject = [dic objectForKey:@"strdwjc"];
                        firstLevelNode1.strdwccbm=[dic objectForKey:@"strdwccbm"];
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
                childern.nodeObject =[chidic objectForKey:@"strryxm"];
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
        if ([strdwccbm length]+3==[[dic objectForKey:@"strdwccbm"]length]&&[strdwccbm isEqualToString:[[dic objectForKey:@"strdwccbm"] substringToIndex:strdwccbm.length]]) {
            TreeViewNode *childern = [[TreeViewNode alloc]init];
            childern.nodeLevel = i;
            childern.intlsh=[dic objectForKey:@"intdwlsh"];
            childern.strdwccbm=[dic objectForKey:@"strdwccbm"];
            childern.nodeObject =[self.type isEqualToString:@"人员"]?[dic objectForKey:@"strryxm"]:[dic objectForKey:@"strdwjc"];
            childern.nodeChildren = [self childrenfarther:[dic objectForKey:@"strdwccbm"] level:i+1];
            childern.check=NO;
            [childenary addObject:childern];
        }
    }
    return childenary;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displayArray.count;
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
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[SingleObj defaultManager].backColor];
    }
    UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 0)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [cell addSubview:headerview];
    TreeViewNode *treenode =[self.displayArray objectAtIndex:indexPath.row];
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
    float withd=0;
    if ([self.type isEqualToString:@"人员"]&&treenode.nodeChildren.count==0) {
        UIImageView *hedimg=[[UIImageView alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10, 11, 18, 18)];
        [hedimg setImage:PNGIMAGE(@"iv_head")];
        [headerview addSubview:hedimg];
        withd+=18;
    }
    if (self.singordouble==YES) {
        UILabel *lbs=[[UILabel alloc]initWithFrame:CGRectMake(treenode.nodeLevel*25+10+withd, 0, [treenode.nodeObject sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40)];
        lbs.text=treenode.nodeObject;
        lbs.textColor=[UIColor blackColor];
        lbs.font=Font(14);
        [headerview addSubview:lbs];
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(lbs), W(headerview), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [headerview addSubview:oneline];
        headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
    }
    else
    {
        QCheckBox *qcheckBox=[[QCheckBox alloc]initWithDelegate:self];
        qcheckBox.frame=CGRectMake(treenode.nodeLevel*25+10+withd, 0, [treenode.nodeObject sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40);
        [qcheckBox setTitle:treenode.nodeObject forState:0];
        [qcheckBox setTitleColor:[UIColor blackColor] forState:0];
        qcheckBox.titleLabel.font=Font(14);
        qcheckBox.tag=indexPath.row+1000;
        qcheckBox.selected=treenode.check;
        [headerview addSubview:qcheckBox];
        UILabel *oneline=[[UILabel alloc]initWithFrame:CGRectMake(0, YH(qcheckBox), W(headerview), 1)];
        [oneline setBackgroundColor:[SingleObj defaultManager].lineColor];
        [headerview addSubview:oneline];
        headerview.frame=CGRectMake(X(headerview), Y(headerview), W(headerview),YH(oneline));
        cell.contentView.frame = CGRectMake(0.0f, 0.0f, kScreenWidth, YH(headerview));
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.singordouble==YES) {
        NSMutableArray *checkay=[[NSMutableArray alloc]init];
        TreeViewNode *treenode = [self.displayArray objectAtIndex:indexPath.row];
        for (NSDictionary *dic in dwary) {
            if ([treenode.intlsh isEqualToString:[dic objectForKey:@"intrylsh"]]) {
                [checkay addObject:dic];
            }
        }
        [self.delegate setZrrValue:checkay andid:self.lbs andGupID:self.gupid];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)checkChildern:(TreeViewNode*)treenochildern check:(BOOL)check
{
    for (int i=0; i<treenochildern.nodeChildren.count; i++) {
        TreeViewNode *treenochilder=[treenochildern.nodeChildren objectAtIndex:i];
        treenochilder.check=check;
        [self checkChildern:treenochilder check:check];
    }
}
-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked
{
    TreeViewNode *treenode = [self.displayArray objectAtIndex:checkbox.tag-1000];
    if (checked) {
        treenode.check=YES;
        [self checkChildern:treenode check:YES];
    }
    else
    {
        treenode.check=NO;
        [self checkChildern:treenode check:NO];
    }
    [lbpersontb reloadData];
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
