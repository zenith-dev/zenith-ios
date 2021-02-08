//
//  ztOANoticeDetialViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-6.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOANoticeDetialViewController.h"

@interface ztOANoticeDetialViewController ()
{
    NSString        *noticeTitleStr;//标题
    NSString        *noticeTimeStr;//时间
    NSString        *noticeContextStr;//正文
    NSString        *type;//type:1通知详情；2公告详情
    
    NSDictionary    *init_Data;
    NSMutableArray  *fjDataInfoArray;//附件信息数组
    FilePlugin      *filePlugin;
    
    float           titleHeight;//标题高度
    float           height_scrollView;//滚动屏高度
}
@property(nonatomic,strong)UIScrollView *noticeMainView;
@property(nonatomic,strong)UILabel      *noticeTitle;
@property(nonatomic,strong)UILabel      *noticeContext;
@property(nonatomic,strong)UILabel      *noticeMan;
@property(nonatomic,strong)UILabel      *noticeUnit;
@property(nonatomic,strong)UILabel      *noticeTime;
@property(nonatomic,strong)UIView       *noticeTitleBar;
@property(nonatomic,strong)UIWebView    *webView;//内容
@property(nonatomic,strong)UITableView  *fjTable;//附件信息

@property (nonatomic,strong) UIViewController   *viewController;
@end

@implementation ztOANoticeDetialViewController
@synthesize noticeTitle,noticeContext,noticeMan,noticeUnit,noticeTime;
@synthesize noticeTitleBar,noticeMainView,webView,fjTable;
@synthesize viewController = _viewController;

- (id)initWithType:(NSString *)whichType Data:(NSDictionary *)initData
{
    self = [super init];
    if (self) {
        // Custom initialization
        type = whichType;
        init_Data = initData;
        if ([type isEqualToString:@"1"]) {
            //通知
            noticeTitleStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strtzbt"]];
            noticeTimeStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"dtmdjsj"]];
            if ([initData objectForKey:@"strzw"]!=NULL && ![[initData objectForKey:@"strzw"] isEqualToString:@""]) {
                noticeContextStr  = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strzw"]] ;
            }
            else
            {
                noticeContextStr = @"(空)";
            }
            
            fjDataInfoArray = [[NSMutableArray alloc] init];
            if ([[initData objectForKey:@"tzfj"] isKindOfClass:[NSDictionary class]]) {
                [fjDataInfoArray addObject:[initData objectForKey:@"tzfj"]];
            }
            else
            {
                fjDataInfoArray = [initData objectForKey:@"tzfj"];
            }
            
        }
        else if ([type isEqualToString:@"2"]) {
            //公告
            noticeTitleStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strggbt"]];
            noticeTimeStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"dtmfbrq"]];
            noticeContextStr  = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strggnr"]];
            
            fjDataInfoArray = [[NSMutableArray alloc] init];
            if ([[initData objectForKey:@"ggfj"] isKindOfClass:[NSDictionary class]]) {
                [fjDataInfoArray addObject:[initData objectForKey:@"ggfj"]];
            }
            else
            {
                fjDataInfoArray = [initData objectForKey:@"ggfj"];
            }
        }
        else if ([type isEqualToString:@"3"]) {
           //刊物
            noticeTitleStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strkwbt"]];
            noticeTimeStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"dtmfbrq"]];
            if ([initData objectForKey:@"strzw"]!=NULL && ![[initData objectForKey:@"strzw"] isEqualToString:@""]) {
                noticeContextStr  = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strzw"]] ;
            }
            else
            {
                noticeContextStr = @"(空)";
            }
            fjDataInfoArray = [[NSMutableArray alloc] init];
            if ([[initData objectForKey:@"kwfj"] isKindOfClass:[NSDictionary class]]) {
                [fjDataInfoArray addObject:[initData objectForKey:@"kwfj"]];
            }
            else
            {
                fjDataInfoArray = [initData objectForKey:@"kwfj"];
            }
        }else if ([type isEqualToString:@"4"])
        {
            //刊物
            noticeTitleStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strzt"]];
            noticeTimeStr = [NSString stringWithFormat:@"%@",[initData objectForKey:@"dtmfbsj"]];
            if ([initData objectForKey:@"strzw"]!=NULL && ![[initData objectForKey:@"strzw"] isEqualToString:@""]) {
                noticeContextStr  = [NSString stringWithFormat:@"%@",[initData objectForKey:@"strzw"]] ;
            }
            else
            {
                noticeContextStr = @"(空)";
            }
            fjDataInfoArray = [[NSMutableArray alloc] init];
            if ([[initData objectForKey:@"wzfj"] isKindOfClass:[NSDictionary class]]) {
                [fjDataInfoArray addObject:[initData objectForKey:@"wzfj"]];
            }
            else
            {
                fjDataInfoArray = [initData objectForKey:@"wzfj"];
            }
        }
        filePlugin = [FilePlugin alloc];
        filePlugin.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //计算标题高度
    CGSize maximumLabelSizeContext = CGSizeMake(self.view.width-10,MAXFLOAT);
    CGSize expectedLabelSizeContext= [noticeTitleStr sizeWithFont:BoldFont(16) constrainedToSize:maximumLabelSizeContext lineBreakMode:NSLineBreakByWordWrapping];
    titleHeight = expectedLabelSizeContext.height;
    //titlebar
    self.noticeTitleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.view.width, 35+titleHeight)];
    self.noticeTitleBar.backgroundColor = [UIColor whiteColor];
    noticeTitleBar.layer.shadowOffset = CGSizeMake(0, 5);
    noticeTitleBar.layer.shadowRadius = 5;
    noticeTitleBar.layer.shadowOpacity = 0.5;
    //title
    UILabel *noticeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.noticeTitleBar.width-10, titleHeight)];
    noticeTitleLabel.backgroundColor = [UIColor clearColor];
    noticeTitleLabel.font = BoldFont(16);
    noticeTitleLabel.text = [NSString stringWithFormat:@"%@",noticeTitleStr];
    noticeTitleLabel.textAlignment = NSTextAlignmentCenter;
    noticeTitleLabel.numberOfLines= 0;
    noticeTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.noticeTitleBar addSubview:noticeTitleLabel];
    //time
    UILabel *noticeTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleHeight+10, self.noticeTitleBar.width-20, 15)];
    noticeTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    noticeTimeLabel.textColor = [UIColor grayColor];
    noticeTimeLabel.text = [NSString stringWithFormat:@"发布时间:%@ ",[ztOASmartTime sjFromStr:noticeTimeStr]];
     noticeTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.noticeTitleBar addSubview:noticeTimeLabel];
    //redline
    UIImageView *redLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35+titleHeight-1, noticeTitleBar.width, 1)];
    redLineImage.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    [self.noticeTitleBar addSubview:redLineImage];
    //Black, Olive,Teal, Red, Blue,Maroon, Navy,Gray, Lime, Fuchsia, White,Green, Silver, Yellow,Aqua
    NSString *contentStr ;
    if ([type isEqualToString:@"1"])
    {
        contentStr = [NSString stringWithFormat:@"<html><body><font face=\"仿宋\" size=\"8\" color=black>    %@</font></body></html>",noticeContextStr];
        
    }else if ([type isEqualToString:@"2"])
    {
        contentStr = [NSString stringWithFormat:@"<html><body><font face=\"仿宋\" size=\"8\" color=black>    %@</font></body></html>",noticeContextStr];
    }else if ([type isEqualToString:@"3"])
    {
        
        contentStr = [NSString stringWithFormat:@"<html><body><font face=\"仿宋\" size=\"8\" color=black>    %@</font></body></html>",noticeContextStr];
    }else if ([type isEqualToString:@"4"])
    {
        
        contentStr = [NSString stringWithFormat:@"<html><body><font face=\"仿宋\" size=\"8\" color=black>    %@</font></body></html>",noticeContextStr];
    }
    
    self.noticeMainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    noticeMainView.backgroundColor = [UIColor clearColor];
    noticeMainView.directionalLockEnabled = YES;
    noticeMainView.showsHorizontalScrollIndicator = NO;
    noticeMainView.showsVerticalScrollIndicator = NO;
    noticeMainView.delegate = self;
    height_scrollView = self.noticeMainView.contentSize.height - self.noticeMainView.frame.size.height;
    [self.view addSubview:noticeMainView];
    
    [self.noticeMainView addSubview:noticeTitleBar];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, noticeTitleBar.bottom, self.view.width, self.view.height-64-64-self.noticeTitleBar.height)];
    [webView setDelegate:self];
    webView.backgroundColor = [UIColor clearColor];
    [webView setScalesPageToFit:YES];
    [self.noticeMainView addSubview:webView];
    [webView loadHTMLString:contentStr baseURL:nil];
    
    [self.view addSubview:self.scrollToTopBtn];
    self.scrollToTopBtn.origin = CGPointMake(self.scrollToTopBtn.origin.x, self.scrollToTopBtn.origin.y-10);
    [self.scrollToTopBtn setHidden:YES];
    [self.scrollToTopBtn addTarget:self action:@selector(scrollToTopBtnAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scrollToBottomBtn];
    [self.scrollToBottomBtn setHidden:YES];
    [self.scrollToBottomBtn addTarget:self action:@selector(scrollToBottomBtnAtion) forControlEvents:UIControlEventTouchUpInside];
}

- (void)scrollToTopBtnAtion
{
    [noticeMainView setContentOffset:CGPointMake(0,0) animated:YES];
}
- (void)scrollToBottomBtnAtion
{
    [noticeMainView setContentOffset:CGPointMake(0,height_scrollView) animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==noticeMainView) {
        if (noticeMainView.contentOffset.y>0) {
            [self.scrollToTopBtn setHidden:NO];
        }
        else
        {
            [self.scrollToTopBtn setHidden:YES];
        }
        
        if (noticeMainView.contentOffset.y<height_scrollView-1) {
            [self.scrollToBottomBtn setHidden:NO];
        }
        else
        {
            [self.scrollToBottomBtn setHidden:YES];
        }
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight=[self.webView.scrollView contentSize].height;
    CGRect newFrame = self.webView.frame;
    newFrame.size.height = webViewHeight;
    self.webView.frame = newFrame;
    
    if (fjDataInfoArray.count==0) {
        [self.noticeMainView setContentSize:CGSizeMake(self.view.width, webViewHeight+35+titleHeight)];
    }
    else
    {
        self.fjTable = [[UITableView alloc] initWithFrame:CGRectMake(0, webViewHeight+35+titleHeight, self.view.width, 20+44*fjDataInfoArray.count)];
        fjTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.fjTable setDataSource:self];
        [self.fjTable setScrollEnabled:NO];
        [self.fjTable setDelegate:self];
        [self.noticeMainView addSubview:fjTable];
        [self.noticeMainView setContentSize:CGSizeMake(self.view.width, webViewHeight+35+titleHeight+20+44*fjDataInfoArray.count)];
    }
    height_scrollView = self.noticeMainView.contentSize.height - self.noticeMainView.frame.size.height;
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    headView.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width-20, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = @"附件";
    [headView addSubview:label];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
        return 1;
    }
    else    return fjDataInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SearchList";
    ztOAFjSimpelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[ztOAFjSimpelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSString *fileNameStr =@"";
    if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
        fileNameStr = [NSString stringWithFormat:@"%@",[(NSDictionary*)fjDataInfoArray objectForKey:@"strfjmc"]];
    }
    else
    {
        fileNameStr =  [NSString stringWithFormat:@"%@", [[fjDataInfoArray objectAtIndex:indexPath.row] objectForKey:@"strfjmc"] ];
    }
    
    NSLog(@"-%@-",fileNameStr);
    NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
    NSString *fileType = [array lastObject];
    NSString *iconImgName= @"";
    if ([fileType isEqualToString:@"doc"]) {
        iconImgName = @"file_ic_word1";
    }
    else if ([fileType isEqualToString:@"txt"]){
        iconImgName = @"file_ic_txt";
    }
    else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
        iconImgName = @"file_ic_img";
    }
    else if ([fileType isEqualToString:@"xls"]){
        iconImgName = @"file_ic_xls1";
    }
    else if ([fileType isEqualToString:@"pdf"]){
        iconImgName = @"file_ic_pdf";
    }
    else {
        iconImgName = @"file_ic_x";
    }
    cell.fjName.text = fileNameStr;
    [cell.iconImg setImage:[UIImage imageNamed:iconImgName]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([type isEqualToString:@"1"]) {
        //通知
        if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *fileObj = (NSDictionary *)fjDataInfoArray;
            filePlugin.viewController = self;
            [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                    blnvalue:@"false"
                    strClass:@"tzServices"
                   strMethod:@"getTzfj"
                       pageX:@""
                       pageY:@""
                    isChange:@""
                     withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"inttzfjlsh", nil] fjType:nil];
        }
        else
        {
            
            
            if (indexPath.row<fjDataInfoArray.count) {
                NSDictionary *fileObj = [fjDataInfoArray objectAtIndex:indexPath.row];
                filePlugin.viewController = self;
                [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                        blnvalue:@"false"
                        strClass:@"tzServices"
                       strMethod:@"getTzfj"
                           pageX:@""
                           pageY:@""
                        isChange:@""
                         withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                    withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"inttzfjlsh", nil] fjType:nil];
            }
        }
        
    }else if ([type isEqualToString:@"2"])
    {
        {
            //公告
            if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *fileObj = (NSDictionary *)fjDataInfoArray;
                filePlugin.viewController = self;
                [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                        blnvalue:@"false"
                        strClass:@"ggServices"
                       strMethod:@"getGgfj"
                           pageX:@""
                           pageY:@""
                        isChange:@""
                         withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                    withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"inttzfjlsh", nil] fjType:nil];
            }
            else
            {
                
                
                if (indexPath.row<fjDataInfoArray.count) {
                    NSDictionary *fileObj = [fjDataInfoArray objectAtIndex:indexPath.row];
                    filePlugin.viewController = self;
                    [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                            blnvalue:@"false"
                            strClass:@"ggServices"
                           strMethod:@"getGgfj"
                               pageX:@""
                               pageY:@""
                            isChange:@""
                             withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                        withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"inttzfjlsh"]],@"inttzfjlsh", nil] fjType:nil];
                }
            }
            
        }
    }
    else if ([type isEqualToString:@"3"])
    {    //刊物
        if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary *fileObj = (NSDictionary *)fjDataInfoArray;
            NSLog(@"%@",fileObj);
            filePlugin.viewController = self;
            [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                    blnvalue:@"false"
                    strClass:@"kwservices"
                   strMethod:@"getKwfjByKwfjlsh"
                       pageX:@""
                       pageY:@""
                    isChange:@""
                     withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"intkwfjlsh"]],@"intkwfjlsh", nil] fjType:nil];
        }
        else
        {
            
            
            if (indexPath.row<fjDataInfoArray.count) {
                NSDictionary *fileObj = [fjDataInfoArray objectAtIndex:indexPath.row];
                NSLog(@"%@",fileObj);
                filePlugin.viewController = self;
                [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                        blnvalue:@"false"
                        strClass:@"kwservices"
                       strMethod:@"getKwfjByKwfjlsh"
                           pageX:@""
                           pageY:@""
                        isChange:@""
                         withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                    withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"intkwfjlsh"]],@"intkwfjlsh", nil] fjType:nil];
            }
        }
    }
    else if ([type isEqualToString:@"4"])
    {    //业务详情
        if ([fjDataInfoArray isKindOfClass:[NSDictionary class]]) {
            NSDictionary *fileObj = (NSDictionary *)fjDataInfoArray;
            NSLog(@"%@",fileObj);
            filePlugin.viewController = self;
            [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                    blnvalue:@"false"
                    strClass:@"kwservices"
                   strMethod:@"getXxwzfjByXxwzfjlsh"
                       pageX:@""
                       pageY:@""
                    isChange:@""
                     withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"intxxzxwzfjlsh"]],@"intxxzxwzfjlsh", nil] fjType:nil];
        }
        else
        {
            
            
            if (indexPath.row<fjDataInfoArray.count) {
                NSDictionary *fileObj = [fjDataInfoArray objectAtIndex:indexPath.row];
                NSLog(@"%@",fileObj);
                filePlugin.viewController = self;
                [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
                        blnvalue:@"false"
                        strClass:@"kwservices"
                       strMethod:@"getXxwzfjByXxwzfjlsh"
                           pageX:@""
                           pageY:@""
                        isChange:@""
                         withUrl:[ztOAGlobalVariable sharedInstance].serviceIp  andPort:[ztOAGlobalVariable sharedInstance].servicePort andPath:@"/ZTMobileGateway/oaAjaxServlet"
                    withSendDict:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[fileObj objectForKey:@"intxxzxwzfjlsh"]],@"intxxzxwzfjlsh", nil] fjType:nil];
            }
        }
    }
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
