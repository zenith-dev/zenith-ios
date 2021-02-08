//
//  ztOAEmailListViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-6-19.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAEmailListViewController.h"
@interface Item : NSObject
@property (assign, nonatomic) BOOL isChecked;
@property (assign, nonatomic) NSIndexPath *indexpath;
@end
@implementation Item
@end
@interface ztOAEmailListViewController ()
{
    NSString *titleName;
    BOOL isNOData;//是否有数据
    BOOL isLoadFinish;//是否加载完毕
    int iRecentPageIndex;//当前加载的页数
    NSMutableArray *dataListArray;//数据列表
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSString            *searchBarStr;
    NSString            *isReceiveOrSendEmail;//收件箱：0；发件箱：1
    NSMutableArray      *selectedDic;
    NSMutableArray      *emailLshArray;
}
@property(nonatomic,strong)UITableView  *table;
@property(nonatomic,strong)NSString     *i_QueryTermXML;
@property(nonatomic,strong)UIImageView  *searchInfoBar;
@property(nonatomic,strong)UISearchBar  *searchField;
@property(nonatomic,strong)UIButton     *searchCheckBtn;
@property(nonatomic,strong)UIButton     *receiveEmailBtn;
@property(nonatomic,strong)UIButton     *sendEmailBtnBtn;
@property(nonatomic,strong)UIImageView       *bottomBar;
@property (retain, nonatomic) NSMutableArray *items;
@property(nonatomic,strong)UIButton         *deleteAtionBtn;//删除垃圾桶按钮

@end

@implementation ztOAEmailListViewController
@synthesize table;
@synthesize i_QueryTermXML;
@synthesize searchInfoBar,searchCheckBtn,searchField;
@synthesize receiveEmailBtn,sendEmailBtnBtn,bottomBar;
@synthesize deleteAtionBtn;
- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
        isLoadFinish = NO;
        iRecentPageIndex=1;
        dataListArray = [[NSMutableArray alloc] init];
        self.items = [[NSMutableArray alloc] init];
        selectedDic = [[NSMutableArray alloc] init];
        emailLshArray = [[NSMutableArray alloc] init];
        self.i_QueryTermXML = @"";
        searchBarStr = @"";
        
    }
    return self;
}
- (void)emailListViewGoBack
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];//注意
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightButton:@"写邮件" Sel:@selector(sendEmail)];
    self.deleteAtionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteAtionBtn.backgroundColor = [UIColor clearColor];
    deleteAtionBtn.frame = CGRectMake(self.rightBtn.left-45, self.rightBtn.origin.y, 30, 30);
    [deleteAtionBtn setImage:[UIImage imageNamed:@"trashWhiteBtn"] forState:UIControlStateNormal];
    [deleteAtionBtn setImage:[UIImage imageNamed:@"trashWhiteBtn_on"] forState:UIControlStateHighlighted];
    [deleteAtionBtn addTarget:self action:@selector(openEditingModelAtion) forControlEvents:UIControlEventTouchUpInside];
    //[self.navBG addSubview:deleteAtionBtn];
    
    UIImage *leftBtnImg = [UIImage imageNamed:@"tab_White_Left"];
    UIImage *hlLeftBtnImg = [UIImage imageNamed:@"tab_blue_Left"];
    UIImage *rightBtnImg = [UIImage imageNamed:@"tab_White_Right"];
    UIImage *hlRightBtnImg = [UIImage imageNamed:@"tab_blue_Right"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //切换查看按钮
    isReceiveOrSendEmail =@"0";//默认收件箱
    self.receiveEmailBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 64+44-29-5, (self.view.width-10)/2, 29)];
    [receiveEmailBtn setUserInteractionEnabled:YES];
    [receiveEmailBtn setTitle:@"收件箱" forState:UIControlStateNormal];
    [receiveEmailBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [receiveEmailBtn setBackgroundImage:hlLeftBtnImg forState:UIControlStateSelected];
    [receiveEmailBtn setBackgroundImage:leftBtnImg forState:UIControlStateNormal];
    [receiveEmailBtn setSelected:YES];
    [receiveEmailBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [receiveEmailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [receiveEmailBtn addTarget:self action:@selector(showReceiveEmail) forControlEvents:UIControlEventTouchUpInside];
    [receiveEmailBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:receiveEmailBtn];
    
    self.sendEmailBtnBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2, 64+44-29-5, (self.view.width-10)/2, 29)];
    [sendEmailBtnBtn setUserInteractionEnabled:YES];
    [sendEmailBtnBtn setTitle:@"发件箱" forState:UIControlStateNormal];
    [sendEmailBtnBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [sendEmailBtnBtn setBackgroundImage:hlRightBtnImg forState:UIControlStateSelected];
    [sendEmailBtnBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [sendEmailBtnBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [sendEmailBtnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sendEmailBtnBtn addTarget:self action:@selector(showSendEmail) forControlEvents:UIControlEventTouchUpInside];
    [sendEmailBtnBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:sendEmailBtnBtn];
    
    NSString *placeholderStr = @"输入邮件标题";
    self.searchInfoBar= [[UIImageView alloc] initWithFrame:CGRectMake(10,64+44 , self.view.width-20-40, 40)];
    searchInfoBar.backgroundColor = [UIColor clearColor];
    [searchInfoBar setUserInteractionEnabled:YES];
    searchInfoBar.image = [UIImage imageNamed:@"searchKuang_Img"];
    
    self.searchField = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, self.searchInfoBar.width-10, 20)];
    self.searchField.delegate = self;
    self.searchField.barStyle = UIBarStyleDefault;
    //适配ios7.0系统
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([searchField respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
//            [[[[self.searchField.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            if (@available(iOS 13.0, *)) {
                [[self.searchField.subviews objectAtIndex:0].subviews objectAtIndex:0].hidden = YES;
            } else {
                [[[self.searchField.subviews objectAtIndex:0].subviews objectAtIndex:0]removeFromSuperview];
            }
        }
        else
        {
            //iOS7.0
            [self.searchField setBarTintColor:[UIColor clearColor]];
        }
        [self.view addSubview:searchInfoBar];
        [self.searchInfoBar addSubview:self.searchField];
    }
    else
    {
        //iOS7.0以下
        [[self.searchField.subviews objectAtIndex:0] removeFromSuperview];
        self.searchField.frame = CGRectMake(5,64+44 , self.view.width-20-40+5, 40);
        [self.view addSubview:self.searchField];
    }
    self.searchField.placeholder = placeholderStr;
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchField.keyboardType = UIKeyboardTypeDefault;
    
    self.searchCheckBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchInfoBar.right, 64+44+5 , 45, 30)];
    [searchCheckBtn addTarget:self action:@selector(searchCheckBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [searchCheckBtn setBackgroundColor:BACKCOLOR];
    [searchCheckBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchCheckBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [searchCheckBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.view addSubview:searchCheckBtn];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44+40, self.view.width, self.view.height-64-44-40) style:UITableViewStylePlain];
    
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    //table.allowsMultipleSelectionDuringEditing = NO;//(编辑模式多选)
    table.allowsSelectionDuringEditing = YES;
    [self.view addSubview:table];
    //编辑模式下的按钮显示
    UIImage *backBtnImg = [UIImage imageNamed:@"banner_bg"];
    UIImage *cancelBtnImg = [UIImage imageNamed:@"color_02"];
    UIImage *deleteBtnImg = [UIImage imageNamed:@"color_10"];
    
    NSInteger backLeftCapWidth = backBtnImg.size.width * 0.5f;
    NSInteger backTopCapHeight = backBtnImg.size.height * 0.5f;
    NSInteger cancelCapWidth = cancelBtnImg.size.width * 0.5f;
    NSInteger cancelCapHeight = cancelBtnImg.size.height * 0.5f;
    
    backBtnImg = [backBtnImg stretchableImageWithLeftCapWidth:backLeftCapWidth topCapHeight:backTopCapHeight];
    cancelBtnImg = [cancelBtnImg stretchableImageWithLeftCapWidth:cancelCapWidth topCapHeight:cancelCapHeight];
    deleteBtnImg = [deleteBtnImg stretchableImageWithLeftCapWidth:cancelCapWidth topCapHeight:cancelCapHeight];
    
    self.bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    bottomBar.image = backBtnImg;
    self.bottomBar.backgroundColor = [UIColor clearColor];
    self.bottomBar.userInteractionEnabled = YES;
    [self.view addSubview:self.bottomBar];
    [self.bottomBar setHidden:YES];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomBar.width-140-20,7, 70, 30)];
    [cancelBtn setUserInteractionEnabled:YES];
    [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cancelBtn setBackgroundImage:cancelBtnImg forState:UIControlStateNormal];
    [cancelBtn setSelected:YES];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelDeleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [self.bottomBar addSubview:cancelBtn];
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomBar.width-70-10,7, 70, 30)];
    [deleteBtn setUserInteractionEnabled:YES];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [deleteBtn setBackgroundImage:deleteBtnImg forState:UIControlStateNormal];
    [deleteBtn setSelected:YES];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAtion) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setBackgroundColor:[UIColor clearColor]];
    [self.bottomBar addSubview:deleteBtn];
    
    [self.view addSubview:self.scrollToTopBtn];
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(goToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    
    // 3.1.下拉刷新
    [self addHeader];
    
    // 3.2.上拉加载更多
    [self addFooter];
    
    addN(@selector(reflashListView), @"reflashEmailTable");
}
//发送邮件
- (void)sendEmail
{
    ztOASendEmailViewController *sendVC = [[ztOASendEmailViewController alloc] initWithTitle:@"写邮件" withDic:nil];
    [self.navigationController pushViewController:sendVC animated:YES];
}
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self initWithData];
    };
    _footer=footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [self reflashListView];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
    
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.table reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated
{
    //[self reflashView];
}
#pragma mark - 刷新列表
- (void)reflashListView
{
    isLoadFinish = NO;
    iRecentPageIndex=1;
    [self initWithData];
    
}
#pragma mark - 切换邮件列表
- (void)showSendEmail
{
    if (![sendEmailBtnBtn isSelected]) {
        //切换发件箱
        [sendEmailBtnBtn setSelected:YES];
        [receiveEmailBtn setSelected:NO];
        isReceiveOrSendEmail = @"1";
        [searchField resignFirstResponder];
        searchField.text = @"";
        searchBarStr = @"";
        [dataListArray removeAllObjects];
        [self.items removeAllObjects];
        [self reflashListView];
    }
}
- (void)showReceiveEmail
{
    if (![receiveEmailBtn isSelected]) {
        //切换收件箱
        [receiveEmailBtn setSelected:YES];
        [sendEmailBtnBtn setSelected:NO];
        isReceiveOrSendEmail = @"0";
        [searchField resignFirstResponder];
        searchField.text = @"";
        searchBarStr = @"";
        [dataListArray removeAllObjects];
        [self.items removeAllObjects];
        [self reflashListView];
    }
    
}
#pragma mark-加载数据
- (void)initWithData
{
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%d",iRecentPageIndex],@"intCurrentPage",@"10",@"intPageRows",searchBarStr,@"queryTermXML",nil];
    [self showWaitView];
    if ([isReceiveOrSendEmail isEqualToString:@"0"]) {
        [ztOAService getReceiveEmailList:emailDic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             NSLog(@"%@",[dic JSONString]);
             if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
                 //刷新获取数据成功显示前先清楚旧数据
                 if (iRecentPageIndex==1) {
                     [dataListArray removeAllObjects];
                     [self.items removeAllObjects];
                 }
                 if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]).count>0) {
                     
                     iRecentPageIndex++;
                     if ([[[dic objectForKey:@"root"]objectForKey:@"document"] isKindOfClass:[NSDictionary class]]) {
                         [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"document"]];
                     }
                     else
                     {
                         [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]];
                     }
                     
                     if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                         isLoadFinish=YES;
                     }
                 }
                 
             }
             for (int i=0; i<dataListArray.count; i++) {
                 Item *item = [[Item alloc] init];
                 item.isChecked = NO;
                 [_items addObject:item];
             }
             [_header endRefreshing];
             [_footer endRefreshing];
             [table reloadData];
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
    else if ([isReceiveOrSendEmail isEqualToString:@"1"])
    {
        [ztOAService getSendEmailList:emailDic Success:^(id result)
         {
             [self closeWaitView];
             NSDictionary *dic = [result objectFromJSONData];
             if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0) {
                 if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]).count>0) {
                     //刷新获取数据成功显示前先清楚旧数据
                     if (iRecentPageIndex==1) {
                         [dataListArray removeAllObjects];
                         [self.items removeAllObjects];
                     }
                     if (((NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]).count>0) {
                         iRecentPageIndex++;
                         if ([[[dic objectForKey:@"root"]objectForKey:@"document"] isKindOfClass:[NSDictionary class]]) {
                             [dataListArray addObject:[[dic objectForKey:@"root"]objectForKey:@"document"]];
                         }
                         else
                         {
                             [dataListArray addObjectsFromArray:(NSMutableArray *)[[dic objectForKey:@"root"]objectForKey:@"document"]];
                         }
                         
                         if (iRecentPageIndex>[[[dic objectForKey:@"root"] objectForKey:@"countpage"]intValue]) {
                             isLoadFinish=YES;
                         }
                     }
                 }
             }
             for (int i=0; i<dataListArray.count; i++) {
                 Item *item = [[Item alloc] init];
                 item.isChecked = NO;
                 [_items addObject:item];
             }
             [table reloadData];
         }Failed:^(NSError *error){
             [self closeWaitView];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alert show];
         }];
    }
    
    [self.table reloadData];
}

//执行查询
- (void)searchBtnClick
{
    [searchField resignFirstResponder];
    if (searchField.text.length==0) {
        searchBarStr = @"";
    }
    else
    {
        searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt>%@</strtzbt><strryxm>%@</strryxm><dtmfbsj1>%@</dtmfbsj1><dtmfbsj2>%@</dtmfbsj2><querytype>%@</querytype></root>",
                            [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",searchField.text?:@"" ]],
                            @"",
                            @"",
                            @"",
                            @"0"];
    }
    [self reflashListView];
}

#pragma mark -textField delegate-
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
    if (scrollView==table) {
        if (table.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
    }
}
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self.searchField resignFirstResponder];
    [self searchBtnClick];//搜索
}
- (void)searchCheckBtnAtion
{
    [self.searchField resignFirstResponder];
    [self searchBtnClick];//搜索
    
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<dataListArray.count) {
        static NSString *cellID = @"emailCellIdentifier";
        ztOAEmailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[ztOAEmailListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
            [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
            [cell setSelectedBackgroundView:selectView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        cell.noticeName.text = [NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strtzbt"]];
        if ([isReceiveOrSendEmail isEqualToString:@"0"]) {
            cell.detailInfo.text =[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strryxm"]];
            //新邮件标识
            if ([[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strczbz"] intValue]==0) {
                cell.iconImg.image = [UIImage imageNamed:@"icon_yj_new"];
            }
            else
            {
                cell.iconImg.image = [UIImage imageNamed:@"icon_yj_read"];
            }
        }
        else
        {
            cell.detailInfo.text =[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strjsrxx"]];
            
            cell.iconImg.image = [UIImage imageNamed:@"icon_yj_read"];;
        }
        //附件标识
        if ([[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strfjbz"]!=NULL &&[[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"strfjbz"] intValue]==0) {
            cell.attachmentImg.image = [UIImage imageNamed:@"bag_blueIcon_Img"];
        }
        else
        {
            cell.attachmentImg.image = nil;
        }
        cell.noticeTime.text =[ztOASmartTime intervalSinceNow:[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"dtmdjsj"]]];
        [cell.readCount setHidden:YES];
        [cell.readImg setHidden:YES];
        
        Item* item = [_items objectAtIndex:indexPath.row];
        [cell setChecked:item.isChecked];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataListArray.count!=0) {
        return dataListArray.count;
    }
    else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.row<dataListArray.count) {
        if (table.editing==YES) {
            Item* item = [_items objectAtIndex:indexPath.row];
            ztOAEmailListCell *cell = (ztOAEmailListCell*)[tableView cellForRowAtIndexPath:indexPath];
            item.isChecked = !item.isChecked;
            [cell setChecked:item.isChecked];
            if (item.isChecked==YES) {
                item.indexpath = indexPath;
                [selectedDic addObject:indexPath];
                [emailLshArray addObject:[dataListArray objectAtIndex:indexPath.row]];
            }
            else
            {
                [selectedDic removeObject:indexPath];
                [emailLshArray removeObject:[dataListArray objectAtIndex:indexPath.row]];
            }
        }
        else
        {
            NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[[dataListArray objectAtIndex:indexPath.row] objectForKey:@"inttzlsh"],@"intnbyjlsh",nil];
            [self showWaitView];
            [ztOAService getEmailDetailInfo:emailDic Success:^(id result)
             {
                 [self closeWaitView];
                 NSDictionary *dic = [result objectFromJSONData];
                 if ([[[dic objectForKey:@"root"] objectForKey:@"result"] intValue]==0 ) {
                     if ([isReceiveOrSendEmail isEqualToString:@"0"]) {
                         ztOAEmailDetailViewController *mailVC = [[ztOAEmailDetailViewController alloc] initWithDataDic:[[dic objectForKey:@"root"] objectForKey:@"document"] withTitle:@"收件详情"  withBaseInfoDic:[dataListArray objectAtIndex:indexPath.row]];
                         [self.navigationController pushViewController:mailVC animated:YES];
                     }
                     else{
                         ztOAEmailDetailViewController *mailVC = [[ztOAEmailDetailViewController alloc] initWithDataDic:[[dic objectForKey:@"root"] objectForKey:@"document"] withTitle:@"发件详情" withBaseInfoDic:[dataListArray objectAtIndex:indexPath.row]];
                         [self.navigationController pushViewController:mailVC animated:YES];
                     }
                 }
                 
             }Failed:^(NSError *error)
             {
                 [self closeWaitView];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [alert show];
             }];
        }
    }
    else
    {
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing==YES) {
        //编辑模式
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        //删除模式
        return UITableViewCellEditingStyleDelete;
    }
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}//允许编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        NSString *emailLshIndex = [[dataListArray objectAtIndex:indexPath.row] objectForKey:@"inttzlsh"];
        NSDictionary *delectDic = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",isReceiveOrSendEmail,@"intsfbz",emailLshIndex,@"inttzlshs", nil];
        UIAlertView *alertShow = [UIAlertView alertWithTitle:@"温馨提示" message:@"是否删除该邮件?"];
        [alertShow addButtonWithTitle:@"确定" handler:^{
            [self showWaitViewWithTitle:@"正在删除..."];
            [ztOAService deleteEmailsBylsh:delectDic Success:^(id result){
                [self closeWaitView];
                NSDictionary *resultDic = [result objectFromJSONData];
                NSLog(@"%@",resultDic);
                if ([[resultDic objectForKey:@"root"] objectForKey:@"result"]!=NULL &&[[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                    //删除成功
                    [dataListArray removeObjectAtIndex:indexPath.row];
                    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//此句必须在后面
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } Failed:^(NSError *error){
                [self closeWaitView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
            
        }];
        [alertShow addButtonWithTitle:@"取消" handler:^{}];
        
        [alertShow show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark -打开编辑模式
- (void)openEditingModelAtion
{
    [self.deleteAtionBtn setHidden:YES];
    //[table setEditing:YES];
    [self.table setEditing:YES animated:YES];
    table.frame = CGRectMake(0, self.searchInfoBar.bottom, self.view.width, self.view.height-64-44-40-44);
    [self.bottomBar setHidden:NO];
    [table reloadData];
    
}
- (void)cancelDeleteAtion
{
    [self.deleteAtionBtn setHidden:NO];
    table.frame = CGRectMake(0, self.searchInfoBar.bottom, self.view.width, self.view.height-64-44-40);
    [self.bottomBar setHidden:YES];
    //[table setEditing:NO];
    [self.table setEditing:NO animated:YES];
    [emailLshArray removeAllObjects];
    [selectedDic removeAllObjects];
    for (int i = 0; i<self.items.count; i++) {
        Item* item = [_items objectAtIndex:i];
        item.isChecked = NO;
    }
    [table reloadData];
}
- (void)deleteAtion
{
    //删除按钮
    NSString *emailLshString =@"";
    if (emailLshArray.count>0) {
        if (emailLshArray.count==1) {
            emailLshString  = [NSString stringWithFormat:@"%@",[[emailLshArray objectAtIndex:0]objectForKey:@"inttzlsh"]];
        }
        else
        {
            for (int i = 0; i<emailLshArray.count; i++) {
                if (i==emailLshArray.count-1) {
                    emailLshString = [emailLshString stringByAppendingString:[NSString stringWithFormat:@"%@",[[emailLshArray objectAtIndex:i]objectForKey:@"inttzlsh"]]];
                }
                else
                {
                    emailLshString = [emailLshString stringByAppendingString:[NSString stringWithFormat:@"%@,",[[emailLshArray objectAtIndex:i]objectForKey:@"inttzlsh"]]];
                }
            }
        }
        NSDictionary *delectDic = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",isReceiveOrSendEmail,@"intsfbz",emailLshString,@"inttzlshs", nil];
        
        UIAlertView *alertShow = [UIAlertView alertWithTitle:@"温馨提示" message:@"是否删除选中邮件?"];
        [alertShow addButtonWithTitle:@"确定" handler:^{
            [self showWaitViewWithTitle:@"正在删除..."];
            [ztOAService deleteEmailsBylsh:delectDic Success:^(id result){
                [self closeWaitView];
                NSDictionary *resultDic = [result objectFromJSONData];
                NSLog(@"%@",resultDic);
                if ([[resultDic objectForKey:@"root"] objectForKey:@"result"]!=NULL &&[[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                    //删除成功
                    for (int i = 0; i<emailLshArray.count; i++) {
                        NSDictionary *oneDeleteEmailDic = [emailLshArray objectAtIndex:i];
                        for (int j = 0; j<dataListArray.count; j++) {
                            if ([[NSString stringWithFormat:@"%@",[oneDeleteEmailDic objectForKey:@"inttzlsh"]] isEqualToString:[NSString stringWithFormat:@"%@",[[dataListArray objectAtIndex:j] objectForKey:@"inttzlsh"]]]) {
                                [dataListArray removeObjectAtIndex:j];
                            }
                        }
                    }
                    
                    [table deleteRowsAtIndexPaths:[NSArray arrayWithArray:selectedDic] withRowAnimation:UITableViewRowAnimationFade];//此句必须在后面
                    [_items removeAllObjects];
                    for (int i=0; i<dataListArray.count; i++) {
                        Item *item = [[Item alloc] init];
                        item.isChecked = NO;
                        [_items addObject:item];
                    }
                    [emailLshArray removeAllObjects];
                    [selectedDic removeAllObjects];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } Failed:^(NSError *error){
                [self closeWaitView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"删除失败了,请重试～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
                
            }];
        }];
        [alertShow addButtonWithTitle:@"取消" handler:^{}];
        
        [alertShow show];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选中行～" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    
    }
    
    
}
- (void)goToTopBtnAtion
{
    [self scrollToTop:YES];
}
- (void)scrollToTop:(BOOL)animated {
    [table setContentOffset:CGPointMake(0,0) animated:animated];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            // Add code to preserve data stored in the views that might be
            // needed later.
            
            // Add code to clean up other strong references to the view in
            // the view hierarchy.
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}
@end
