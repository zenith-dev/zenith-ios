//
//  MsgAlertVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/6.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "MsgAlertVC.h"
#import "GTMBase64.h"
#import "LFCGzipUtillity.h"
#import "NSDictionary+util.h"
#import "NSArray+util.h"
#import <ChineseString.h>
#import "MsgUserModel.h"
#import "MsgUserCell.h"
#import "CharModel.h"
#import "CharCell.h"
#import "QueryChatxqVC.h"
@interface MsgAlertVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchBar *mySearchBar;
    UISearchDisplayController *mySearchDisplayController;//搜索功能
}
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)NSMutableArray *letterResultArr;
@property (nonatomic,strong)UIButton *linkManbtn;
@property (nonatomic,strong)NSMutableArray *searchAry;//搜索
@property (nonatomic,strong)NSMutableArray *allAry;//所有人员
@property (nonatomic,strong)UIButton *msgBtn;
@property (nonatomic,strong)UILabel *slidLabel;
@property (nonatomic,strong)UIScrollView *tableScrollView;
@property (nonatomic,strong)UITableView *linkmantb;
@property (nonatomic,strong)UITableView *msgtb;
@property (nonatomic,strong) UILabel *sectionTitleView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong)NSMutableArray *charAry;//聊天记录
@property (nonatomic,strong)UIButton *rfbtn;//刷新按钮

@end

@implementation MsgAlertVC
@synthesize linkManbtn,msgBtn,slidLabel,tableScrollView,linkmantb,msgtb,indexArray,letterResultArr,allAry,searchAry,charAry,rfbtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    rfbtn =[self rightButton:nil image:@"ref" sel:@selector(refsel)];
    self.sectionTitleView = ({
        UILabel *sectionTitleView = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, (kScreenHeight-100)/2,100,100)];
        sectionTitleView.textAlignment = NSTextAlignmentCenter;
        sectionTitleView.font = [UIFont boldSystemFontOfSize:60];
        sectionTitleView.textColor = [UIColor whiteColor];
        sectionTitleView.backgroundColor = RGBACOLOR(200, 200, 200, 0.9);
        ViewBorderRadius(sectionTitleView, 6, 1, [UIColor groupTableViewBackgroundColor]);
        sectionTitleView;
    });
    [self.navigationController.view addSubview:self.sectionTitleView];
    self.sectionTitleView.hidden = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *tabView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth, 40)];
    tabView.backgroundColor = UIColorFromRGB(0xeaeaea);
    linkManbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    linkManbtn.frame=CGRectMake(0, 0, tabView.width/2.0, 40);
    linkManbtn.titleLabel.font=Font(16);
    linkManbtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [linkManbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [linkManbtn bk_addEventHandler:^(id sender) {
        [self swipScr:linkManbtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [linkManbtn setTitle:@"联系人" forState:UIControlStateNormal];
    [tabView addSubview:linkManbtn];
    //cllcBtn
    msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    msgBtn.frame = CGRectMake(linkManbtn.right,linkManbtn.top,linkManbtn.width,linkManbtn.height);
    msgBtn.titleLabel.font=Font(16);
    msgBtn.showsTouchWhenHighlighted = YES;  //指定按钮被按下时发光
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [msgBtn setTitle:@"消息" forState:UIControlStateNormal];
    [msgBtn bk_addEventHandler:^(id sender) {
        [self swipScr:msgBtn];
    } forControlEvents:UIControlEventTouchUpInside];
    [tabView addSubview:msgBtn];
    slidLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,msgBtn.width-20,2)];
    slidLabel.backgroundColor = SingObj.mainColor;
    [tabView addSubview:slidLabel];
    slidLabel.centerX=linkManbtn.centerX;
    [self.view addSubview:tabView];
    self.title=@"联系人";
    rfbtn.hidden=NO;
    
    tableScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight-104)];
    tableScrollView.pagingEnabled = YES;
    tableScrollView.clipsToBounds = NO;
    tableScrollView.backgroundColor = [UIColor whiteColor];
    tableScrollView.contentSize = CGSizeMake(tableScrollView.frame.size.width * 2, tableScrollView.frame.size.height);
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.scrollsToTop = NO;
    tableScrollView.delegate = self;
    [tableScrollView setContentOffset:CGPointMake(0, 0)];
    [self.view addSubview:tableScrollView];
    indexArray =[[NSMutableArray alloc]init];
    letterResultArr=[[NSMutableArray alloc]init];
    
    searchAry =[[NSMutableArray alloc]init];
    charAry =[[NSMutableArray alloc]init];
    mySearchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    mySearchBar.delegate=self;
    mySearchBar.keyboardType=UIBarStyleDefault;
    mySearchBar.placeholder=@"请输入人员姓名";
    mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    mySearchDisplayController.delegate = self;
    mySearchDisplayController.searchResultsDataSource = self;
    mySearchDisplayController.searchResultsDelegate = self;
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    linkmantb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, tableScrollView.height) style:UITableViewStylePlain];
    linkmantb.sectionIndexBackgroundColor =[UIColor clearColor];
    linkmantb.delegate=self;
    linkmantb.dataSource=self;
    [tableScrollView addSubview:linkmantb];
    [linkmantb setTableHeaderView:mySearchBar];
    
    linkmantb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getContactsList];
    }];
    
    msgtb =[[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, tableScrollView.height) style:UITableViewStyleGrouped];
    msgtb.delegate=self;
    msgtb.dataSource=self;
    [tableScrollView addSubview:msgtb];
    
    
    msgtb.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getqueryChat];
    }];
    
    
    [self getContactsList];
    [self getqueryChat];
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark-------------获取联系人列表--------------
-(void)getContactsList{
    [self networkall:@"lxrservices" requestMethod:@"getDwTxlLxrListNoContionBygzip" requestHasParams:@"true" parameter:@{@"intrylsh":@(SingObj.userInfo.intrylsh)} progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            //获取字段
            NSString *content = [[rep objectForKey:@"root"] objectForKey:@"txlnr"];
             NSData *datacontent = [GTMBase64 decodeString:content];
            NSData *dataUncompresss = [LFCGzipUtillity uncompressZippedData:datacontent];
            NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *tempStr = [[NSString alloc] initWithData:dataUncompresss encoding:firstEncoding];
            NSDictionary *dataDic = [tempStr mj_JSONObject];
            dataDic=[dataDic killNull];
            NSLog(@"dataDic=---%@",[dataDic mj_JSONString]);
            if ([dataDic[@"data"] isKindOfClass:[NSArray class]]) {
                 NSArray *dataary=dataDic[@"data"];
             allAry =[[NSMutableArray alloc]initWithArray:[MsgUserModel mj_objectArrayWithKeyValuesArray:dataary]];
             indexArray = [ChineseString IndexArray:dataary];
              NSMutableArray *letter = [ChineseString LetterSortArray:dataary];
                NSMutableArray *ls=[[NSMutableArray alloc]init];
                for (NSArray *ary in letter) {
                    NSMutableArray *lsone=[MsgUserModel mj_objectArrayWithKeyValuesArray:ary];
                    [ls addObject:lsone];
                }
                letterResultArr =[[NSMutableArray alloc]initWithArray:ls];
                [linkmantb reloadData];
                [linkmantb.mj_header endRefreshing];
            }
        }
    }];
}
#pragma mark-----------------获取聊天列表------------------------
-(void)getqueryChat{

    [self network:@"SsGdServices" requestMethod:@"queryChat" requestHasParams:@"true" parameter:@{@"intfsrlsh":@(SingObj.userInfo.intrylsh)} progresHudText:nil completionBlock:^(id rep) {
        if (rep!=nil) {
            [charAry removeAllObjects];
            NSLog(@"%@",[rep mj_JSONString]);
            if ([rep[@"chats"] isKindOfClass:[NSArray class]]) {
                charAry =[CharModel mj_objectArrayWithKeyValuesArray:rep[@"chats"]];
            }else if ([rep[@"chats"] isKindOfClass:[NSDictionary class]])
            {
                [charAry addObject:[CharModel mj_objectWithKeyValues:rep[@"chats"]]];
            }
            [msgtb reloadData];
            [msgtb.mj_header endRefreshing];
        }
    }];
}
-(void)swipScr:(UIButton*)sender
{
    int pagenum=0;
    if (sender==msgBtn) {
        pagenum=1;
        self.title=@"消息";
        rfbtn.hidden=YES;
    }else if (linkManbtn==sender)
    {
        pagenum=0;
        rfbtn.hidden=NO;
        self.title=@"联系人";
    }
    [UIView animateWithDuration:0.3 animations:^{
        slidLabel.centerX=sender.centerX;
        [tableScrollView setContentOffset:CGPointMake(kScreenWidth*pagenum, 0)];
    }];
}
#pragma mark---------------滑动-------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tableScrollView.frame.size.width;
    int page = floor((self.tableScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page==0) {
        [self swipScr:linkManbtn];
    }else if (page==1)
    {
        [self swipScr:msgBtn];
    }
}
#pragma mark - UITableViewDataSource
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(tableView==linkmantb) {
        return self.indexArray;
    }
    else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        return @[];
    }
    else
    {
        return @[];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==linkmantb) {
        return 30;
    }
    return 0.01;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView==linkmantb) {
        NSString *key = [self.indexArray objectAtIndex:section];
        return key;
    }else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        return @"";
    }
    else
    {
        return @"";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==linkmantb) {
       return [self.indexArray count];
    }else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==linkmantb) {
        return [[self.letterResultArr objectAtIndex:section] count];
    }else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        return searchAry.count;
    }
    else
    {
        return charAry.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==linkmantb) {
        static  NSString *identifier = @"RePCell";
        MsgUserCell *cell = (MsgUserCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[MsgUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        MsgUserModel *hmd=letterResultArr[indexPath.section][indexPath.row];
        cell.msguserModel =hmd;
        return cell;
    }
    else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        static  NSString *identifier = @"RePCell";
        MsgUserCell *cell = (MsgUserCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell==nil) {
            cell = [[MsgUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        MsgUserModel *hmd=searchAry[indexPath.row];
        cell.msguserModel =hmd;
        return cell;
    }
   else
   {
       static  NSString *identifier = @"RePCell";
       CharCell *cell = (CharCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
       if (cell==nil) {
           cell = [[CharCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
           cell.selectionStyle=UITableViewCellSelectionStyleNone;
       }
       CharModel *charModel=charAry[indexPath.row];
       cell.charModel=charModel;
       return cell;
   }
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showSectionTitle:title];
    return index;
}

#pragma mark - private
- (void)timerHandler:(NSTimer *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            self.sectionTitleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.sectionTitleView.hidden = YES;
        }];
    });
}

-(void)showSectionTitle:(NSString*)title{
    [self.sectionTitleView setText:title];
    self.sectionTitleView.hidden = NO;
    self.sectionTitleView.alpha = 1;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==linkmantb) {
        UIView *views=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [views setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth, 30)];lab.textColor=[UIColor blackColor];
        lab.text = [self.indexArray objectAtIndex:section];
        [views addSubview:lab];
        return views;
    }else if (mySearchDisplayController.searchResultsTableView==tableView){
        return [UIView new];
    }
    else
    {
        return [UIView new];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==linkmantb) {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.height;
    }else if (mySearchDisplayController.searchResultsTableView==tableView)
    {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.height;
    }
    
    else
    {
        UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.contentView.height;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==linkmantb) {
        MsgUserModel *hmd=letterResultArr[indexPath.section][indexPath.row];
        QueryChatxqVC *queryChatxq=[[QueryChatxqVC alloc]initWithTitle:hmd.strxm];
        queryChatxq.intjsrlsh=[NSString stringWithFormat:@"%@",hmd.intrylsh];
        queryChatxq.jsrxm=hmd.strxm;
        queryChatxq.intfsrlsh=[NSString stringWithFormat:@"%@",@(SingObj.userInfo.intrylsh)];
        queryChatxq.fsrxm=SingObj.userInfo.username;
        queryChatxq.callback=^(BOOL issu){
            if (issu==YES) {
                [self getqueryChat];
            }
        };
        [self.navigationController pushViewController:queryChatxq animated:YES];
        
        
        
    }else if(mySearchDisplayController.searchResultsTableView==tableView)
    {
        MsgUserModel *hmd=searchAry[indexPath.row];
        QueryChatxqVC *queryChatxq=[[QueryChatxqVC alloc]initWithTitle:hmd.strxm];
        queryChatxq.intjsrlsh=[NSString stringWithFormat:@"%@",hmd.intrylsh];
        queryChatxq.jsrxm=hmd.strxm;
        queryChatxq.intfsrlsh=[NSString stringWithFormat:@"%@",@(SingObj.userInfo.intrylsh)];
        queryChatxq.fsrxm=SingObj.userInfo.username;
        queryChatxq.callback=^(BOOL issu){
            if (issu==YES) {
                [self getqueryChat];
            }
        };
        [self.navigationController pushViewController:queryChatxq animated:YES];
        
    }else
    {
        CharModel *charModel=charAry[indexPath.row];
        QueryChatxqVC *queryChatxq=[[QueryChatxqVC alloc]initWithTitle:charModel.strjsrxm];
        queryChatxq.intjsrlsh=[NSString stringWithFormat:@"%@",charModel.intjsrlsh];
        queryChatxq.jsrxm=charModel.strjsrxm;
        queryChatxq.intfsrlsh=[NSString stringWithFormat:@"%@",charModel.intfsrlsh];
        queryChatxq.fsrxm=charModel.strfsrxm;
        queryChatxq.callback=^(BOOL issu){
            if (issu==YES) {
                [self getqueryChat];
            }
        };
        [self.navigationController pushViewController:queryChatxq animated:YES];
    }
}
#pragma mark-------------------------searchBardelegate--------------------
//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    mySearchBar.showsCancelButton = YES;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length!=0) {
        //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態
        NSMutableString *wordOfSearch = [NSMutableString stringWithString:searchBar.text];
        if ([wordOfSearch length] > 0) {
            [searchAry removeAllObjects];//清空搜索数组
            for (MsgUserModel *userModel in allAry) {//循环所有的人
                NSString *xm=userModel.strxm;
                ChineseString *chineseStr = [[ChineseString alloc] init];
                chineseStr.string =[NSString stringWithFormat:@"%@",userModel.strxm];
                if(chineseStr.string==nil){
                    chineseStr.string=@"";
                }
                if(![chineseStr.string isEqualToString:@""]){
                    NSString *pinYinResult=[NSString string];
                    for(int j=0;j<chineseStr.string.length;j++){
                        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseStr.string characterAtIndex:j])]uppercaseString];
                        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                    }
                    chineseStr.pinYin=pinYinResult;
                }else{
                    chineseStr.pinYin=@"";
                }
                if ([xm rangeOfString: wordOfSearch
                              options:NSCaseInsensitiveSearch].location != NSNotFound
                    ||[chineseStr.pinYin rangeOfString:wordOfSearch options:NSCaseInsensitiveSearch | NSNumericSearch].location!=NSNotFound) {
                        [searchAry addObject:userModel];
                    }
            }
            [mySearchDisplayController.searchResultsTableView reloadData];
        }
    }
    [searchBar resignFirstResponder];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    NSMutableString *wordOfSearch = [NSMutableString stringWithString:searchString];
    if ([wordOfSearch length] > 0) {
        [searchAry removeAllObjects];//清空搜索数组
        for (MsgUserModel *userModel in allAry) {//循环所有的人
            NSString *xm=userModel.strxm;
            ChineseString *chineseStr = [[ChineseString alloc] init];
            chineseStr.string =[NSString stringWithFormat:@"%@",userModel.strxm];
            if(chineseStr.string==nil){
                chineseStr.string=@"";
            }
            if(![chineseStr.string isEqualToString:@""]){
                NSString *pinYinResult=[NSString string];
                for(int j=0;j<chineseStr.string.length;j++){
                    NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseStr.string characterAtIndex:j])]uppercaseString];
                    pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                chineseStr.pinYin=pinYinResult;
            }else{
                chineseStr.pinYin=@"";
            }
            if ([xm rangeOfString: wordOfSearch
                          options:NSCaseInsensitiveSearch].location != NSNotFound
                ||[chineseStr.pinYin rangeOfString:wordOfSearch options:NSCaseInsensitiveSearch | NSNumericSearch].location!=NSNotFound) {
                [searchAry addObject:userModel];
            }
        }
        [mySearchDisplayController.searchResultsTableView reloadData];
    }
    return NO;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Return YES to cause the search result table view to be reloaded.
    return NO;
}
#pragma mark------------刷新------
-(void)refsel{
    [self getContactsList];
}
-(void)backPage
{
     [tableScrollView setContentOffset:CGPointMake(0, 0)];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
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
