//
//  ztOAPersonalCollectViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-7-2.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPersonalCollectViewController.h"

@interface ztOAPersonalCollectViewController ()
{
    NSString *i_type;//type:1收藏的公文
    NSString *titleName;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据列表
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    NIDropDown          *dropView;
    NSArray             *dropTypeArray;
}
@property(nonatomic,strong)UITableView  *collectTable;
@property(nonatomic,strong)UIButton     *deleteToTrashBtn;
@end

@implementation ztOAPersonalCollectViewController
@synthesize collectTable;
@synthesize deleteToTrashBtn;
- (id)initWithType:(NSString *)whichType withTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        i_type =whichType;
        self.title = title;
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        dropTypeArray = [NSArray arrayWithObjects:@"公文",@"邮件", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self rightButton:@"公文" Sel:@selector(openDropView:)];
    //type:1公文
    self.collectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.collectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    collectTable.delegate = self;
    collectTable.dataSource = self;
    [self.view addSubview:collectTable];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteToTrashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteToTrashBtn.backgroundColor = [UIColor clearColor];
    deleteToTrashBtn.frame = CGRectMake((self.view.width-50)/2, self.view.height-70, 50, 50);
    [deleteToTrashBtn setImage:[UIImage imageNamed:@"trashIconImg_normal"] forState:UIControlStateNormal];
    [deleteToTrashBtn setImage:[UIImage imageNamed:@"trashIconImg_on"] forState:UIControlStateHighlighted];
    [deleteToTrashBtn addTarget:self action:@selector(deleteToTrash) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteToTrashBtn];
    
    // 3.1.下拉刷新
    [self addHeader];
    addN(@selector(reflashCollectView), @"reflashEmailTable");
}
- (void)addHeader
{
    __unsafe_unretained ztOAPersonalCollectViewController *vc= self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.collectTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self reflashCollectView];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    [header beginRefreshing];
    _header = header;
    
}
- (void)addFooter
{
    __unsafe_unretained ztOAPersonalCollectViewController *vc= self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.collectTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[self initWithData];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
    };
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.collectTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}
- (void)deleteToTrash
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要清空列表？"];
    [alert addButtonWithTitle:@"确定" handler:^(void){
        [dataListArray removeAllObjects];
        if ([i_type isEqualToString:@"公文"]) {
            //本地数据
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:nil forKey:@"localDocCollectArray"];
            [userDefaults synchronize];
        }
        if ([i_type isEqualToString:@"邮件"]) {
            //本地数据
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:nil forKey:@"localEmailCollectArray"];
            [userDefaults synchronize];
        }
        [collectTable reloadData];
    }];
    [alert addButtonWithTitle:@"取消" handler:^(void){     }];
    [alert show];
    
}
#pragma mark-加载数据
- (void)reflashCollectView
{
    //获取公文列表
    if ([i_type isEqualToString:@"公文"]) {
        //本地数据
        isLoadFinish = NO;
        iRecentPageIndex=1;
        [dataListArray removeAllObjects];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"localDocCollectArray"]!=nil) {
            [dataListArray addObjectsFromArray:[userDefaults objectForKey:@"localDocCollectArray"]];
        }
    }
    if ([i_type isEqualToString:@"邮件"]) {
        //本地数据
        isLoadFinish = NO;
        iRecentPageIndex=1;
        [dataListArray removeAllObjects];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"localEmailCollectArray"]!=nil) {
            [dataListArray addObjectsFromArray:[userDefaults objectForKey:@"localEmailCollectArray"]];
        }
    }
    [self.collectTable reloadData];
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //公文
    if ([i_type isEqualToString:@"公文"]) {
        if (indexPath.row<dataListArray.count) {
            NSDictionary *rowdic=[dataListArray objectAtIndex:indexPath.row];
            static NSString *cellID = @"officeDocCellIdentifier";
            ztOAOfficeDocListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[NSBundle mainBundle] loadNibNamed:@"ztOAOfficeDocListCell" owner:self options:nil][0];
            }
            cell.i_type=@"5";
            cell.modedic=rowdic;
            return cell;
        }
        else
        {
            static NSString *cellId = @"lookingForMore";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [[cell.contentView subviews] each:^(id sender) {
                [(UIView *)sender removeFromSuperview];
            }];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
            lab.backgroundColor = [UIColor clearColor];
            [lab setTextColor:[UIColor blackColor]];
            lab.text = @"";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:14.0f];
            [cell addSubview:lab];
            return cell;
        }
    }
    //邮件
    else if ([i_type isEqualToString:@"邮件"])
    {
        if (indexPath.row<dataListArray.count) {
            static NSString *cellID = @"emailCellIdentifier";
            ztOAEmailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(!cell){
                cell = [[ztOAEmailListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
                [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
                [cell setSelectedBackgroundView:selectView];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            [cell.iconImg setFrame:CGRectMake(5, 15, 30, 30)];
            [cell.noticeName setFrame:CGRectMake(cell.iconImg.right+5, 10, cell.width-10-cell.iconImg.right, 20)];
            [cell.detailInfo setFrame:CGRectMake(cell.iconImg.right+5, 40, cell.width-120-5-cell.iconImg.right, 15)];
    
            if ([[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"0"]) {
                cell.noticeName.text = [NSString stringWithFormat:@"[收件]%@",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"] objectForKey:@"strtzbt"]];
                cell.detailInfo.text =[NSString stringWithFormat:@"%@",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic" ] objectForKey:@"strryxm"]];
                cell.iconImg.image = [UIImage imageNamed:@"email_openLogo"];
            }
            else
            {
                cell.noticeName.text = [NSString stringWithFormat:@"[发件]%@",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"] objectForKey:@"strtzbt"]];
                cell.detailInfo.text =[NSString stringWithFormat:@"%@",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"] objectForKey:@"strjsrxx"]];
                cell.iconImg.image = [UIImage imageNamed:@"email_openLogo"];
            }
            
            cell.noticeTime.text =[ztOASmartTime intervalSinceNow:[NSString stringWithFormat:@"%@",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"] objectForKey:@"dtmdjsj"]]];
            [cell.readCount setHidden:YES];
            [cell.readImg setHidden:YES];
            
            return cell;
        }
        else
        {
            static NSString *cellId = @"lookingForMore";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [[cell.contentView subviews] each:^(id sender) {
                [(UIView *)sender removeFromSuperview];
            }];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
            lab.backgroundColor = [UIColor clearColor];
            [lab setTextColor:[UIColor blackColor]];
            lab.text = @"";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:14.0f];
            [cell addSubview:lab];
            return cell;
        }
    }
    else{
            static NSString *cellId = @"ceshi";
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [[cell.contentView subviews] each:^(id sender) {
                [(UIView *)sender removeFromSuperview];
            }];
            cell.selectionStyle =UITableViewCellSelectionStyleGray;
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
            lab.backgroundColor = [UIColor clearColor];
            [lab setTextColor:[UIColor blackColor]];
            lab.text = @"";
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [UIFont boldSystemFontOfSize:14.0f];
            [cell addSubview:lab];
            return cell;
        }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([i_type isEqualToString:@"公文"]) {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
    else
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataListArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //公文
    if([i_type isEqualToString:@"公文"])
    {
        if (indexPath.row<dataListArray.count) {
            //查询公文信息
            ztOAOfficialDocSendAndReceiveViewController *searchDetailVC = [[ztOAOfficialDocSendAndReceiveViewController alloc] initWithData:[dataListArray objectAtIndex:indexPath.row] isOnSearch:YES];
            searchDetailVC.title=@"公文详情";
            [self.navigationController pushViewController:searchDetailVC animated:YES];
        }
    }
    else if ([i_type isEqualToString:@"邮件"])
    {
        if (indexPath.row<dataListArray.count) {
            
            NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"]objectForKey:@"inttzlsh"],@"intnbyjlsh",nil];
            [self showWaitView];
            [ztOAService getEmailDetailInfo:emailDic Success:^(id result)
             {
                 [self closeWaitView];
                 NSDictionary *dic = [result objectFromJSONData];
                 if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                     NSString *titleString =@"";
                     if ([[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"0"]) {
                         titleString = @"收件详情";
                     }
                     else
                     {
                          titleString = @"发件详情";
                     }
                    ztOAEmailDetailViewController *mailVC = [[ztOAEmailDetailViewController alloc] initWithDataDic:[[dic objectForKey:@"root"] objectForKey:@"document"] withTitle:titleString withBaseInfoDic:[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dic"]];
                    [self.navigationController pushViewController:mailVC animated:YES];
                 }
                 
             }Failed:^(NSError *error)
             {
                 [self closeWaitView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        UIAlertView *alertShow = [UIAlertView alertWithTitle:@"温馨提示" message:@"是否删除该收藏?"];
        [alertShow addButtonWithTitle:@"确定" handler:^{
                //删除成功
            [dataListArray removeObjectAtIndex:indexPath.row];
            if ([i_type isEqualToString:@"公文"]) {
                //本地数据
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dataListArray forKey:@"localDocCollectArray"];
                [userDefaults synchronize];
            }
            if ([i_type isEqualToString:@"邮件"]) {
                //本地数据
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dataListArray forKey:@"localEmailCollectArray"];
                [userDefaults synchronize];
            }
            [collectTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//此句必须在后面
            
        }];
        [alertShow addButtonWithTitle:@"取消" handler:^{}];
        
        [alertShow show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [collectTable setContentOffset:CGPointMake(0,0) animated:animated];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==collectTable) {
        if (collectTable.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
- (void)openDropView:(id)sender
{

    if(dropView == nil) {
        CGFloat f = 44*dropTypeArray.count;
        dropView = [[NIDropDown alloc]showDropDown:sender height:&f arr:dropTypeArray];
        dropView.delegate = self;
    }
    else {
        [dropView hideDropDown:sender];
        dropView = nil;
    }
}
#pragma mark - DropDowndelegate-
- (void)niDropDownDelegateMethod: (NIDropDown *)sender index:(int)index{
    //date = self.rightBtnLab.text;
    dropView = nil;
    if (index == 0) {
        i_type =@"公文";
        self.rightBtnLab.text = @"公文";
    }
    else if (index == 1) {
       i_type =@"邮件";
        self.rightBtnLab.text = @"邮件";
    }
    [self reflashCollectView];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
