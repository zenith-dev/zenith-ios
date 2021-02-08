//
//  LBMoreViewController.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/6.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBMoreViewController.h"
#import "TreeViewNode.h"
#import "SHbsTableViewCell.h"
#import "LBrightImageButton.h"
#import "QCheckBox.h"
@interface LBMoreViewController ()<UITableViewDataSource,UITableViewDelegate,QCheckBoxDelegate>
{
    UITableView *lbpersontb;
    NSMutableArray *dwary;//单位列表
    NSMutableArray *dwaryBoolary;
    NSInteger layerlevel;//层
    NSMutableArray *levelarray;//层次数组
}
@property (nonatomic, retain) NSMutableArray *displayArray;
@end

@implementation LBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma mark------------------查询单位-----------
-(void)loadNewData{
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
                for (int j=0; j<dwary.count; j++) {
                    NSDictionary *dic=[dwary objectAtIndex:j];
                    if ([[dic objectForKey:@"strdwccbm"] length]==3) {
                        TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
                        firstLevelNode1.nodeLevel = 0;
                        firstLevelNode1.nodeObject = [dic objectForKey:@"strdwjc"];
                        firstLevelNode1.strdwccbm=[dic objectForKey:@"strdwccbm"];
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
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

-(NSMutableArray*)childrenfarther:(NSString*)strdwccbm level:(NSInteger)i
{
    NSMutableArray *childenary=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in dwary) {
        if ([strdwccbm length]<[[dic objectForKey:@"strdwccbm"]length]&&[strdwccbm isEqualToString:[[dic objectForKey:@"strdwccbm"] substringToIndex:strdwccbm.length]]) {
            TreeViewNode *childern = [[TreeViewNode alloc]init];
            childern.nodeLevel = i;
            childern.strdwccbm=[dic objectForKey:@"strdwccbm"];
            childern.nodeObject = [dic objectForKey:@"strdwjc"];
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
    QCheckBox *qcheckBox=[[QCheckBox alloc]initWithDelegate:self];
    qcheckBox.frame=CGRectMake(treenode.nodeLevel*25+10, 0, [treenode.nodeObject sizeWithAttributes:@{NSFontAttributeName:Font(14)}].width+40, 40);
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
    return cell;
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
