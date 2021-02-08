//
//  ztOATreeTableViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-2-28.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOATreeTableViewController.h"

@interface ztOATreeTableViewController ()
{
    NSString        *titleStr;
    NSMutableArray  *displayArray;//节点数组
    
    NSUInteger      indentation;
    NSMutableArray  *nodes;//所有节点
    
    NSString        *currentStrcxlx;//当前查询类型
    NSString        *i_Strcxlx;//传入原始查询类型数据
    NSString        *currentCompanylsh;//当前查询处室流水号
    
    NSString        *i_multiSelectFlag;//节点单选多选标志<!--1：单选 ；2:多选；3：不需要返回下一步责任对象 -->
    NSMutableArray  *multiSelectArray;//多选数组
    NSString        *multiNameStr;//多选显示名称字符串
    
    NSMutableArray  *i_selectedArray;//选中的数组
    NSString        *i_selectNameStr;
}
@property (nonatomic,strong)UITableView *treeTableView;
@property (nonatomic,strong)UILabel     *multiLableName;
@end

@implementation ztOATreeTableViewController
@synthesize treeTableView;
@synthesize multiLableName;

- (id)initWithTitleName:(NSString *)titleName data:(id)initData strcxlx:(NSString *)strcxlx multiSelectFlag:(NSString *)multiSelectFlag
{
    self = [super init];
    if (self) {
        //数据初始化
        titleStr = titleName;
        nodes = [[NSMutableArray alloc] init];
        i_selectedArray = [[NSMutableArray alloc] init];
        i_selectNameStr = @"已选中：0个：";
        multiNameStr = @"";
        multiSelectArray = [[NSMutableArray alloc] init];
        currentStrcxlx = [NSString stringWithFormat:@"%@",strcxlx];
        i_Strcxlx = [NSString stringWithFormat:@"%@",strcxlx];
        currentCompanylsh = [ztOAGlobalVariable sharedInstance].intdwlsh;
        i_multiSelectFlag = multiSelectFlag;
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
   // //self.appTitle.text = titleStr;
    [self.leftBtn setHidden:NO];
    
//    __block ztOATreeTableViewController *selfController = self;
//    [self.leftBtn removeTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [self.leftBtn addEventHandler:^(id sender) {
//        [selfController dismissModalViewControllerAnimated:YES];
//    } forControlEvents:UIControlEventTouchUpInside];
//    [self.leftBtnLab setText:@""];
    
    float height_tt=0;
    //多选
    if ([i_multiSelectFlag isEqualToString:@"2"]) {
        [self.rightBtn setHidden:NO];
        self.rightBtnLab.text = @"确定";
        [self.rightBtn addTarget:self action:@selector(multiSelected) forControlEvents:UIControlEventTouchUpInside];
        
        self.multiLableName = [[UILabel alloc] initWithFrame:CGRectMake(10, 64+5, self.view.width-20,30)];
        multiLableName.backgroundColor = [UIColor clearColor];
        multiLableName.textAlignment = NSTextAlignmentLeft;
        multiLableName.textColor = [UIColor grayColor];
        multiLableName.font = [UIFont systemFontOfSize:10.0f];
        multiLableName.text = i_selectNameStr;
        [self.view addSubview:multiLableName];
        height_tt=40;
    }
    
    
    //[self fillNodesArray];[self fillDisplayArray];
    
    self.treeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+height_tt, self.view.width, self.view.height-64-height_tt) style:UITableViewStylePlain];
    treeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    treeTableView.delegate = self;
    treeTableView.dataSource = self;
    [self .view addSubview:treeTableView];
    //加载数据
    [self reloadTreeTableData:currentCompanylsh nodeLevel:-1];
    
    addN(@selector(expandCollapseNode:), @"ProjectTreeNodeButtonClicked");
}
- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}
//多选
- (void)multiSelected
{
    NSString *i_Zrrlsh=@"";
    NSString *i_content = @"";
    NSString *xml =@"";
    //NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
    NSMutableArray *pepoleInfoArray = [[NSMutableArray alloc] init];//写信人员数据
    
    for (int i = 0;i < i_selectedArray.count ;i++) {
        i_Zrrlsh = [NSString stringWithFormat:@"%@",[[i_selectedArray objectAtIndex:i] objectForKey:@"lsh"]];
        
        xml= [xml stringByAppendingString:[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",i_Zrrlsh,i_Strcxlx,[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",[[i_selectedArray objectAtIndex:i] objectForKey:@"name"]]]]];
        
        if (i<i_selectedArray.count-1) {
            i_content = [i_content stringByAppendingString:[NSString stringWithFormat:@"%@,",[[i_selectedArray objectAtIndex:i] objectForKey:@"name"]]];
        }
        else
        {
            i_content = [i_content stringByAppendingString:[NSString stringWithFormat:@"%@",[[i_selectedArray objectAtIndex:i] objectForKey:@"name"]]];
        }
        NSDictionary *oneManDic =[i_selectedArray objectAtIndex:i];
        [pepoleInfoArray addObject:oneManDic];
    }
    if (i_selectedArray.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还未选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }else
    {
        NSDictionary *dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",i_content,@"content",pepoleInfoArray,@"arrayInfo",nil];
        postNWithInfos(@"TREERESPONCHOOSE", nil ,dataDic);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -获取下一级数据
- (void)reloadTreeTableData:(NSString *)companylsh nodeLevel:(int)level
{
    NSString *xmlStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strdwmc>%@</strdwmc><strdwccbm>%@</strdwccbm></root>",@"",@""];
    
    if ([currentStrcxlx intValue]==2) {
        currentStrcxlx=@"2";
    }
    else
    {
        currentStrcxlx = @"3";
    }
    NSDictionary *loadRespDic = [[NSDictionary alloc] initWithObjectsAndKeys:currentCompanylsh,@"intdwlsh",currentStrcxlx,@"strcxlx",xmlStr,@"queryTermXML",nil];
    //NSLog(@"--%@",loadRespDic);
    [self showWaitView];
    [ztOAService getCompanyPersonList:loadRespDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        //NSLog(@"man=%@",dataDic);
        if ([currentStrcxlx isEqualToString:@"3"]) {
            //添加机构列表
            if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                
                NSString *unitList =([[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"]isEqual:[NSNull null]]?@"":[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"])?:@"";
                
                if (![unitList isKindOfClass:[NSString class]]) {
                    if ([unitList isKindOfClass:[NSDictionary class]]) {
                        //[responsibleManArray addObject:str];
                        //添加节点
                        [nodes addObject:[self addChildrenForNode:level nodeDic:(NSDictionary *)unitList type:@"2"]];
                    }
                    else
                    {
                        //responsibleManArray = (NSMutableArray *)str;
                        for (int i = 0; i<((NSMutableArray *)unitList).count; i++) {
                            [nodes addObject:[self addChildrenForNode:level nodeDic:[(NSMutableArray *)unitList objectAtIndex:i]  type:@"2"]];
                        }
                    }
                }
            }
            //添加人员列表
            NSString *userList =([[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"]isEqual:[NSNull null]]?@"":[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"])?:@"";
            if (![userList isKindOfClass:[NSString class]]) {
                
                if ([userList isKindOfClass:[NSDictionary class]]) {
                    //[responsibleManArray addObject:str];
                    //添加节点
                    [nodes addObject:[self addChildrenForNode:level nodeDic:(NSDictionary *)userList type:@"1"]];
                }
                else
                {
                    //responsibleManArray = (NSMutableArray *)str;
                    for (int i = 0; i<((NSMutableArray *)userList).count; i++) {
                        [nodes addObject:[self addChildrenForNode:level nodeDic:[(NSMutableArray *)userList objectAtIndex:i]  type:@"1"]];
                    }
                }
            }
        }
        [self fillDisplayArray];
        [self.treeTableView reloadData];
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"数据加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }];


}
// 增加节点,1:姓名,2单位简称
- (ztOATreeViewNode *)addChildrenForNode:(int)parentLevel nodeDic:(NSDictionary *)nodeDic type:(NSString *)type
{
    int currentLevel = parentLevel +1 ;
    ztOATreeViewNode *childLevelNode = [[ztOATreeViewNode alloc]init];
    childLevelNode.nodeLevel = currentLevel;
    NSLog(@"nodeLevel==%d",currentLevel);
    if ([type isEqualToString:@"1"]) {
        //姓名
        childLevelNode.nodeObject = [NSString stringWithFormat:@"%@",[nodeDic objectForKey:@"strryxm"]];
        childLevelNode.haveChildNodFlag = NO;
        childLevelNode.manType = @"1";
    }
    else
    {//单位简称
        childLevelNode.nodeObject = [NSString stringWithFormat:@"%@",[nodeDic objectForKey:@"strdwjc"]];
        if( ([currentStrcxlx intValue]==2 && [[nodeDic objectForKey:@"strnextdwbz"] intValue]>0 ) ||
           ( [currentStrcxlx intValue]==3 && ([[nodeDic objectForKey:@"strnextdwbz"] intValue]>0 || [[nodeDic objectForKey:@"strnextrybz"] intValue]>0 ) ) ){
           childLevelNode.haveChildNodFlag = YES;
        }
        else
        {
            childLevelNode.haveChildNodFlag = NO;
        }
        childLevelNode.manType = @"2";
    }
    
    childLevelNode.isExpanded = NO;
    childLevelNode.isSelected = NO;
    childLevelNode.infoDic = nodeDic;
    return childLevelNode;
}

#pragma mark - Messages to fill the tree nodes and the display array

//This function is used to expand and collapse the node as a response to the ProjectTreeNodeButtonClicked notification
- (void)expandCollapseNode:(NSNotification *)notification
{
    NSDictionary *dic= [notification userInfo];
    NSLog(@"dic==%@",dic);
    
    [self fillDisplayArray];
    [self.treeTableView reloadData];
}

//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    displayArray = [[NSMutableArray alloc]init];
    for (ztOATreeViewNode *node in nodes) {
        [displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (ztOATreeViewNode *node in childrenArray) {
        [displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

////These functions are used to expand and collapse all the nodes just connect them to two buttons and they will work
//- (IBAction)expandAll:(id)sender
//{
//    [self fillNodesArray];
//    [self fillDisplayArray];
//    [self.treeTableView reloadData];
//}
//
//- (IBAction)collapseAll:(id)sender
//{
//    for (ztOATreeViewNode *treeNode in nodes) {
//        treeNode.isExpanded = NO;
//    }
//    [self fillDisplayArray];
//    [self.treeTableView reloadData];
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ztOATreeViewNode *node = [displayArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"treeNodeCell";
    
    ztOATreeTableCell *cell = (ztOATreeTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[ztOATreeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.treeNode = node;
    cell.delegate = self;
    cell.cellLabel.text = node.nodeObject;
    
    if (node.haveChildNodFlag==NO) {
        [cell.cellBackImage setHidden:YES];
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"treeIcon_02"]];
        if (node.isSelected==YES) {
            [cell setTheSelectedIconImage:[UIImage imageNamed:@"check_icon"]];
        }
        else
        {
            [cell setTheSelectedIconImage:[UIImage imageNamed:@"uncheck_icon"]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        //添加展开收起手势
        [cell.cellBackImage setHidden:NO];
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"treeIcon_01"]];
        if (node.isExpanded) {
            [cell setTheSelectedIconImage:[UIImage imageNamed:@"icon_arrow_up"]];
        }
        else {
            [cell setTheSelectedIconImage:[UIImage imageNamed:@"icon_arrow_down"]];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setNeedsDisplay];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ztOATreeViewNode *node = [displayArray objectAtIndex:indexPath.row];
    if (node.haveChildNodFlag==NO) {
        if (![i_multiSelectFlag isEqualToString:@"2"]) {
            //单选
            NSString *i_Zrrlsh;
            if ([node.manType isEqualToString:@"1"]) {
                i_Zrrlsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intrylsh"]];
            }
            else
            {
                i_Zrrlsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intdwlsh"]];
            }
            NSString *xml = [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",i_Zrrlsh,i_Strcxlx,[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",node.nodeObject]]];
            NSDictionary *dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",node.nodeObject,@"content",nil];
            postNWithInfos(@"TREERESPONCHOOSE", nil ,dataDic);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            ztOATreeTableCell *cell = (ztOATreeTableCell*)[tableView cellForRowAtIndexPath:indexPath];
            if (node.isSelected==YES) {
                node.isSelected=!node.isSelected;
                [cell setTheSelectedIconImage:[UIImage imageNamed:@"uncheck_icon"]];
                NSString *nodeLsh;
                if ([node.manType isEqualToString:@"1"]) {
                    nodeLsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intrylsh"]];
                }
                else
                {
                    nodeLsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intdwlsh"]];
                }

                for (int i =0; i<i_selectedArray.count; i++) {
                    
                    if ([[(NSDictionary *)[i_selectedArray objectAtIndex:i] objectForKey:@"lsh"] isEqualToString:nodeLsh]) {
                        [i_selectedArray removeObjectAtIndex:i];
                        break;
                    }
                }
                
            }
            else
            {
                node.isSelected=!node.isSelected;
                [cell setTheSelectedIconImage:[UIImage imageNamed:@"check_icon"]];
                NSString *i_Zrrlsh=@"";
                NSString *i_content = @"";
                NSString *chrbz = @"";//chrbz=0时表示是处室流水号,当chrbz=1时表示是人员流水号)
                if ([node.manType isEqualToString:@"1"]) {
                    i_Zrrlsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intrylsh"]];
                    chrbz = @"1";
                }
                else
                {
                    i_Zrrlsh = [NSString stringWithFormat:@"%@",[node.infoDic objectForKey:@"intdwlsh"]];
                    chrbz = @"0";
                }
                i_content = [i_content stringByAppendingString:[NSString stringWithFormat:@"%@ ",node.nodeObject]];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:i_content,@"name",i_Zrrlsh,@"lsh",chrbz,@"chrbz",nil];
                [i_selectedArray addObject:dic];
            }
            i_selectNameStr = [NSString stringWithFormat:@"已选中：%d个：",i_selectedArray.count];
            for (int i =0; i<i_selectedArray.count; i++)
            {
                i_selectNameStr = [i_selectNameStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",[[i_selectedArray objectAtIndex:i] objectForKey:@"name"]]];
            }
            multiLableName.text = i_selectNameStr;
            
        }
            
    }
}
#pragma mark - expandNodesAddDelegate
-(void)addnodeChildren:(ztOATreeViewNode *)currentNode hasLoadData:(BOOL)hasLoadData
{
    if (hasLoadData==NO) {
        [self fillDisplayArray];
        [self.treeTableView reloadData];
        return;
    }
    
    NSString *xmlStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strdwmc>%@</strdwmc><strdwccbm>%@</strdwccbm></root>",@"",@""];
    
    NSDictionary *loadRespDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[currentNode.infoDic objectForKey:@"intdwlsh"]],@"intdwlsh",currentStrcxlx,@"strcxlx",xmlStr,@"queryTermXML",nil];
    
    currentNode.nodeChildren = [[NSMutableArray alloc] init];
    
    [self showWaitView];
    [ztOAService getCompanyPersonList:loadRespDic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        if ([currentStrcxlx isEqualToString:@"3"]) {
            //添加机构列表
            if ([[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                
                NSString *unitList =([[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"]isEqual:[NSNull null]]?@"":[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"])?:@"";
                if (![unitList isKindOfClass:[NSString class]]) {
                    
                    if ([unitList isKindOfClass:[NSDictionary class]]) {
                        //[responsibleManArray addObject:str];
                        //添加节点
                        [currentNode.nodeChildren addObject:[self addChildrenForNode:currentNode.nodeLevel nodeDic:(NSDictionary *)unitList type:@"2"]];
                    }
                    else
                    {
                        //responsibleManArray = (NSMutableArray *)str;
                        for (int i = 0; i<((NSMutableArray *)unitList).count; i++) {
                            [currentNode.nodeChildren addObject:[self addChildrenForNode:currentNode.nodeLevel nodeDic:[(NSMutableArray *)unitList objectAtIndex:i]  type:@"2"]];
                        }
                    }
                }
            }
            //添加人员列表
            NSString *userList =([[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"]isEqual:[NSNull null]]?@"":[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"])?:@"";
            
            if (![userList isKindOfClass:[NSString class]]) {
                if ([userList isKindOfClass:[NSDictionary class]]) {
                    //[responsibleManArray addObject:str];
                    //添加节点
                    [currentNode.nodeChildren addObject:[self addChildrenForNode:currentNode.nodeLevel nodeDic:(NSDictionary *)userList type:@"1"]];
                }
                else
                {
                    //responsibleManArray = (NSMutableArray *)str;
                    for (int i = 0; i<((NSMutableArray *)userList).count; i++) {
                        [currentNode.nodeChildren addObject:[self addChildrenForNode:currentNode.nodeLevel nodeDic:[(NSMutableArray *)userList objectAtIndex:i]  type:@"1"]];
                    }
                }
            }
        }
        [self fillDisplayArray];
        [self.treeTableView reloadData];
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"数据加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self fillDisplayArray];
        [self.treeTableView reloadData];
        
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
