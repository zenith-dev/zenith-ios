//
//  ztOAAddressBookListViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-13.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAAddressBookListViewController.h"

@interface ztOAAddressBookListViewController ()
{
    NSString        *isGroupListOrNot;//1:所有联系人；2:群组
    NSMutableArray  *allAddressBookInfoArray;//后台获取所有原始数据
    NSMutableArray  *allContactListArray;
    NSMutableArray  *groupListArray;//群组数据
    NSMutableArray  *searchListContent;//搜索结果
    NSMutableArray  *grouSetArray;//勾选中得群组
    
    NSMutableArray  *openFlagArray;//展开标志
    ztOAABModel     *longPressABModel;//长按cell数据
}
@property(nonatomic,strong)UIButton         *allContactsListBtn;//所有联系人
@property(nonatomic,strong)UIButton         *groupListBtn;//群组
@property(nonatomic,strong)UISearchBar      *searchBarKuang;//搜索

@property(nonatomic,strong)UIScrollView     *mainScrollView;
@property(nonatomic,strong)UITableView      *allContactListTable;
@property(nonatomic,strong)UITableView      *groupListTable;
@property(nonatomic,strong)UISearchDisplayController *searchDisplayController;
@property(nonatomic,strong)ztOAContactCheckedActionBar  *checkTitleBar;//选中提示框bar

@end

@implementation ztOAAddressBookListViewController
@synthesize allContactsListBtn,groupListBtn,searchBarKuang;
@synthesize mainScrollView,allContactListTable,groupListTable,searchDisplayController,checkTitleBar;

- (id)init
{
    self = [super init];
    if (self) {
        allAddressBookInfoArray = [[NSMutableArray alloc] init];
        allContactListArray     = [[NSMutableArray alloc] init];
        groupListArray          = [[NSMutableArray alloc] init];
        searchListContent       = [[NSMutableArray alloc] init];
        openFlagArray           = [[NSMutableArray alloc] init];
        grouSetArray            = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightButton:@"更新" Sel:@selector(reloadTableData)];
    
    //切换查看按钮
    UIImage *leftBtnImg = [UIImage imageNamed:@"tab_White_Left"];
    UIImage *hlLeftBtnImg = [UIImage imageNamed:@"tab_blue_Left"];
    UIImage *rightBtnImg = [UIImage imageNamed:@"tab_White_Right"];
    UIImage *hlRightBtnImg = [UIImage imageNamed:@"tab_blue_Right"];
    isGroupListOrNot =@"1";//默认所有联系人
    self.allContactsListBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 64+44-29-5, (self.view.width-10)/2, 29)];
    [allContactsListBtn setUserInteractionEnabled:YES];
    [allContactsListBtn setTitle:@"所有联系人" forState:UIControlStateNormal];
    [allContactsListBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [allContactsListBtn setBackgroundImage:hlLeftBtnImg forState:UIControlStateSelected];
    [allContactsListBtn setBackgroundImage:leftBtnImg forState:UIControlStateNormal];
    [allContactsListBtn setSelected:YES];
    [allContactsListBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [allContactsListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [allContactsListBtn addTarget:self action:@selector(showAllContactList) forControlEvents:UIControlEventTouchUpInside];
    [allContactsListBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:allContactsListBtn];
    
    self.groupListBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2, 64+44-29-5, (self.view.width-10)/2, 29)];
    [groupListBtn setUserInteractionEnabled:YES];
    [groupListBtn setTitle:@"群组" forState:UIControlStateNormal];
    [groupListBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [groupListBtn setBackgroundImage:hlRightBtnImg forState:UIControlStateSelected];
    [groupListBtn setBackgroundImage:rightBtnImg forState:UIControlStateNormal];
    [groupListBtn setTitleColor:BACKCOLOR forState:UIControlStateNormal];
    [groupListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [groupListBtn addTarget:self action:@selector(showGroupList) forControlEvents:UIControlEventTouchUpInside];
    [groupListBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:groupListBtn];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+44,self.view.width, self.view.height-64-44)];
    [mainScrollView setContentOffset:CGPointMake(0, 0)];
    [mainScrollView setContentSize:CGSizeMake(self.view.width*2, self.view.height-64-44)];
    mainScrollView.delegate = self;
    [mainScrollView setPagingEnabled:YES];
    [self.view addSubview:mainScrollView];
    
    self.searchBarKuang = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    searchBarKuang.delegate = self;
    searchBarKuang.barStyle = UIBarStyleDefault;
    //适配ios7.0系统
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([searchBarKuang respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[searchBarKuang.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        }
        else
        {
            //iOS7.0
            [searchBarKuang setBarTintColor:[UIColor clearColor]];
        }
        //添加背景框
        UIImageView *searchInfoBar= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
        searchInfoBar.backgroundColor = [UIColor clearColor];
        [searchInfoBar setUserInteractionEnabled:YES];
        searchInfoBar.image = [UIImage imageNamed:@"searchKuang_Img"];
        [self.mainScrollView addSubview:searchInfoBar];
    }
    else
    {
        //iOS7.0以下
        [[searchBarKuang.subviews objectAtIndex:0] removeFromSuperview];
    }
    searchBarKuang.placeholder = @"搜索";
    searchBarKuang.backgroundColor = [UIColor clearColor];
    searchBarKuang.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBarKuang.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBarKuang.keyboardType = UIKeyboardTypeDefault;
    [self.mainScrollView addSubview:searchBarKuang];
    
    self.allContactListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, mainScrollView.height-44) style:UITableViewStylePlain];
    self.allContactListTable.delegate = self;
    self.allContactListTable.dataSource = self;
   
    self.allContactListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollView addSubview:allContactListTable];
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBarKuang contentsController:self];

    searchDisplayController.delegate = self;
    [searchDisplayController setSearchResultsDataSource:allContactListTable.dataSource];
    [searchDisplayController setSearchResultsDelegate:allContactListTable.delegate];
	self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
	self.searchDisplayController.searchBar.showsCancelButton = NO;
    
    self.groupListTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, mainScrollView.height) style:UITableViewStylePlain];
    self.groupListTable.delegate = self;
    self.groupListTable.dataSource = self;
    groupListTable.backgroundColor = [UIColor colorWithWhite:0.963 alpha:1.000];
    self.groupListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainScrollView addSubview:groupListTable];
    
    self.checkTitleBar = [[ztOAContactCheckedActionBar alloc] initWithFrame:CGRectMake(0, self.view.height-44, self.view.width, 44)];
    [self.checkTitleBar setHidden:YES];
    [self.checkTitleBar.closeBtn addTarget:self action:@selector(closeCheckTitleBar) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.loadAllToPhone addTarget:self action:@selector(loadAllMemberToPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.sendMessageToPhone addTarget:self action:@selector(sendMessageAllMember) forControlEvents:UIControlEventTouchUpInside];
    [self.checkTitleBar.cancelCheckedBtn addTarget:self action:@selector(cancelCheckedAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkTitleBar];
    
    //加载数据
    [self loadTableDate:@""];
    
    addN(@selector(checkedInsertAddressBook:), @"CELLCHECHEDUP");
	
}
//刷新数据
- (void)reloadTableData
{
    [self.searchDisplayController setActive:NO animated:YES];
    [self removeAllHistoryInfo];
    [self loadTableDate:@""];
}
//导入所有数据到通讯录
- (void)loadAllAddressToPhone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"导入所有数据到通讯录！"];
    [alert addButtonWithTitle:@"确定" handler:^(void){
        [self doLoadToPhone:allAddressBookInfoArray];
    }];
    [alert addButtonWithTitle:@"取消" handler:^(void){}];
    [alert show];
}
//取消选择
- (void)cancelCheckedAll
{
    for (int i = 0; i <allAddressBookInfoArray.count; i++) {
        ztOAABModel *modelBook = [allAddressBookInfoArray objectAtIndex:i];
        modelBook.isCheckedUp = NO;
    }
    [grouSetArray removeAllObjects];
    [self.checkTitleBar setHidden:YES];
    [self.allContactListTable reloadData];
    [self.groupListTable reloadData];
}
- (void)closeCheckTitleBar
{
    [self.checkTitleBar setHidden:YES];
}
- (void)loadAllMemberToPhoto
{
    [self doLoadToPhone:grouSetArray];

}
- (void)sendMessageAllMember
{
    NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<grouSetArray.count; i++) {
        ztOAABModel *oneBook = (ztOAABModel *)[grouSetArray objectAtIndex:i];
        if (![oneBook.stryddh isEqualToString:@""]) {
            [phoneArray addObject:oneBook.stryddh];
        }
        
    }
    [self sendSMS:@"" recipientList:phoneArray];
}
//勾选处理
- (void)checkedInsertAddressBook:(NSNotification *)notify
{
    NSDictionary *bookDic = (NSDictionary *)[notify userInfo];
    NSString *ischecked = [bookDic objectForKey:@"ischecked"];
    
    ztOAABModel *bookModel = [[ztOAABModel alloc]init];
    bookModel.intrylsh = [bookDic objectForKey:@"intrylsh"];
    bookModel.strxm = [bookDic objectForKey:@"strxm"];
    bookModel.strdw = [bookDic objectForKey:@"strdw"];
    bookModel.strzw = [bookDic objectForKey:@"strzw"];
    bookModel.strbgdh = [bookDic objectForKey:@"strbgdh"];
    bookModel.stryddh = [bookDic objectForKey:@"stryddh"];
    bookModel.intdwpxh = [bookDic objectForKey:@"intdwpxh"];
    bookModel.intrypxh = [bookDic objectForKey:@"intrypxh"];
    
    NSLog(@"%@",notify);
    BOOL isAlreadyStay=NO;
    for (int i = 0;i<grouSetArray.count;i++) {
        ztOAABModel *model = [grouSetArray objectAtIndex:i];
        if ([model.intrylsh isEqualToString:bookModel.intrylsh]) {
            isAlreadyStay = YES;
            if (![ischecked isEqualToString:@"yes"]) {
                [grouSetArray removeObjectAtIndex:i];
                break;
            }

        }
    }
    if ([ischecked isEqualToString:@"yes"] && isAlreadyStay == NO) {
        [grouSetArray addObject:bookModel];
    }
    
        NSLog(@"count==%d,%@",grouSetArray.count,grouSetArray);
    if (grouSetArray.count>0) {
        checkTitleBar.sendMsgNumLable.text = [NSString stringWithFormat:@"(%d)",grouSetArray.count];
        checkTitleBar.loadToPhoneNumLable.text = [NSString stringWithFormat:@"(%d)",grouSetArray.count];
        
        [self.checkTitleBar setHidden:NO];
    }
    else
    {
        [self.checkTitleBar setHidden:YES];
    }
    [self.allContactListTable reloadData];
    [self.groupListTable reloadData];
}
//显示所有联系人
- (void)showAllContactList
{
    if (![allContactsListBtn isSelected]) {
        [allContactsListBtn setSelected:YES];
        [groupListBtn setSelected:NO];
        isGroupListOrNot = @"1";
        [self.searchDisplayController setActive:NO animated:YES];
        [self.allContactListTable reloadData];
        [mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
    
}
//显示群组
- (void)showGroupList
{
    if (![groupListBtn isSelected]) {
        [groupListBtn setSelected:YES];
        [allContactsListBtn setSelected:NO];
        isGroupListOrNot = @"2";
        [self.searchDisplayController setActive:NO animated:YES];
        [self.allContactListTable reloadData];
        [mainScrollView setContentOffset:CGPointMake(self.view.width, 0)];
    }
}
//数据重组成群组
- (void)NSSetinGroup
{
    NSMutableArray *setArray = [[NSMutableArray alloc] init];
    for (int i = 0;i<allAddressBookInfoArray.count ;i++) {
        ztOAABModel*bookItem = [allAddressBookInfoArray objectAtIndex:i];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bookItem.intdwpxh,@"dwlsh",bookItem.strdw,@"dwmc",bookItem.dwsuoyinStr,@"suoyinStr", nil];
        if (![setArray containsObject:dic]) {
            [setArray addObject:dic];
        }
    }
    //按单位拼音排序
    NSComparator comparatorpinyin = ^(id obj1, id obj2){
        if ([[(NSDictionary *)obj1 objectForKey:@"suoyinStr"] compare:[(NSDictionary *)obj2 objectForKey:@"suoyinStr"]]==NSOrderedDescending) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([[(NSDictionary *)obj1 objectForKey:@"suoyinStr"] compare: [(NSDictionary *)obj2 objectForKey:@"suoyinStr"]]==NSOrderedAscending){
            return (NSComparisonResult)NSOrderedAscending;
        } else{
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    
    //按单位流水号排序
    NSComparator comparatordwlsh = ^(id obj1, id obj2){
        if ([[(NSDictionary *)obj1 objectForKey:@"dwlsh"] intValue] > [[(NSDictionary *)obj2 objectForKey:@"dwlsh"]intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([[(NSDictionary *)obj1 objectForKey:@"dwlsh"] intValue] < [[(NSDictionary *)obj2 objectForKey:@"dwlsh"]intValue]){
            return (NSComparisonResult)NSOrderedAscending;
        } else{
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    [setArray sortUsingComparator:comparatorpinyin];
    [setArray sortUsingComparator:comparatordwlsh];
    
    [openFlagArray addObject:@"收起"];//所有联系人展开标记，节点0赋值
    for (int i = 0;i<setArray.count;i++) {
        NSString *str = [((NSDictionary *)[setArray objectAtIndex:i]) objectForKey:@"dwmc"];
        NSMutableArray *groupArray = [[NSMutableArray alloc]init];
        for (ztOAABModel *bookItem in allAddressBookInfoArray) {
            if ([bookItem.strdw isEqualToString:str]) {
                [groupArray addObject:bookItem];
            }
        }
        //组员排序
        [groupArray sortUsingComparator:^(id obj1,id obj2){
            if ([((ztOAABModel *)obj1).intrypxh compare:((ztOAABModel *)obj2).intrypxh]==NSOrderedDescending) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ([((ztOAABModel *)obj1).intrypxh compare:((ztOAABModel *)obj2).intrypxh]==NSOrderedAscending){
                return (NSComparisonResult)NSOrderedAscending;
            } else{
                return (NSComparisonResult)NSOrderedSame;
            }
            
        }];
        NSDictionary *groupDic = [NSDictionary dictionaryWithObjectsAndKeys:str,@"dw",groupArray,@"array", nil];
        [groupListArray addObject:groupDic];
        [openFlagArray addObject:@"收起"];//默认收起
    }
}
//所有联系人数据整理（拼音索引）
- (void)allContactInSuoyin
{
    // Sort data索引
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (ztOAABModel *book in allAddressBookInfoArray) {
        NSInteger sect = [theCollation sectionForObject:book
                                collationStringSelector:@selector(suoyinStr)];
        book.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (ztOAABModel *book in allAddressBookInfoArray) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:book.sectionNumber] addObject:book];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(suoyinStr)];
        [allContactListArray addObject:sortedSection];
    }

}
//展开or收起
- (void)openOrCloseCellAction:(UITapGestureRecognizer *)gesture
{
    int index = [gesture view].tag-100;
    NSLog(@"%d",[gesture view].tag-100);
    if ([[openFlagArray objectAtIndex:index] isEqualToString:@"展开"]) {
        [openFlagArray replaceObjectAtIndex:index withObject:@"收起"];
    }
    else
    {
        [openFlagArray replaceObjectAtIndex:index withObject:@"展开"];
    }
    [groupListTable reloadData];
}
#pragma mark - getData 加载数据 -

- (void)loadTableDate:(NSString *)searchStr
{
    NSDictionary *datadic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",nil];
    NSLog(@"%@",datadic);
    [allContactListArray removeAllObjects];
    [groupListArray removeAllObjects];
    [allAddressBookInfoArray removeAllObjects];
    [grouSetArray removeAllObjects];
    [openFlagArray removeAllObjects];
    //获取本地联系人列表
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESSBOOKLIST"]!=nil) {
        [self getLocalAddressBookInfoList];
        //数据组装
        [self allContactInSuoyin];
        [self NSSetinGroup];
    }
    else
    {
        //获取服务器联系人列表
        [self showWaitView];
        [ztOAService getContactsList:datadic Success:^(id result){
            [self closeWaitView];
            /*
             使用zip解压字符串
             
            NSString *string1 = @"{\"UserName\":\"LiYang\",\"Password\":\"123\",\"errorCode\":\"0\"}";
            NSData *data1 = [LFCGzipUtillity gzipData:[string1 dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSData *data2 = [LFCGzipUtillity uncompressZippedData:data1];
            NSLog(@"data1==%@,data2==%@",data1,data2);
            NSString *string2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
            NSLog(@"string2==%@",string2);
            */
            //获取字段
            NSString *content = [[[result objectFromJSONData] objectForKey:@"root"] objectForKey:@"txlnr"];
            //NSLog(@"content=---%@",content);
            //GTMBase64解密
            NSData *datacontent = [GTMBase64 decodeString:content];
            //NSLog(@"datacontent=---%@",datacontent);
            
            //gzip解压
            NSData *dataUncompresss = [LFCGzipUtillity uncompressZippedData:datacontent];
            //NSString *string2 = [[NSString alloc] initWithData:dataUncompresss encoding:NSASCIIStringEncoding];
            
            //转码
            NSStringEncoding firstEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *tempStr = [[NSString alloc] initWithData:dataUncompresss encoding:firstEncoding];
            
            NSDictionary *dataDic = [tempStr objectFromJSONString];
            NSLog(@"dataDic=---%@",dataDic);
            
            NSMutableArray *dicArray = [[NSMutableArray alloc] init];
            if (dataDic!=NULL && [[dataDic objectForKey:@"result"]intValue]==0) {
                    if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                        [dicArray addObject:[dataDic  objectForKey:@"data"]];
                    }
                    else
                    {
                        dicArray = [dataDic  objectForKey:@"data"];
                    }
                    
                    for (int i=0; i<dicArray.count; i++) {
                        NSDictionary *bookDic = [dicArray objectAtIndex:i];
                        ztOAABModel *bookItem = [[ztOAABModel alloc] init];
                        bookItem.intrylsh = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"intrylsh"]?:@""];//流水号
                        bookItem.strxm = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"strxm"]?:@""];//姓名
                        bookItem.strdw = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"strdw"]?:@""];//单位
                        bookItem.stryddh = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"stryddh"]?:@""];//移动电话
                        bookItem.strbgdh = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"strbgdh"]?:@""];//单位电话
                        bookItem.strzw = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"strzw"]?:@""];//职务
                        bookItem.intdwpxh = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"intdwpxh"]?:@""];//单位排序流水号
                        bookItem.intrypxh = [NSString stringWithFormat:@"%@",[bookDic objectForKey:@"intrypxh"]?:@""];//人员排序流水号
                        
                        //获取字符串中英文字的拼音首字母并与字符串共同存放(人名)
                        ChineseString *chineseStr = [[ChineseString alloc] init];
                        chineseStr.string =[NSString stringWithFormat:@"%@",bookItem.strxm];
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
                        bookItem.suoyinStr = [NSString stringWithFormat:@"%@",chineseStr.pinYin];//赋值
                        
                        //获取字符串中英文字的拼音首字母并与字符串共同存放（单位）
                        ChineseString *chinesedwStr = [[ChineseString alloc] init];
                        chinesedwStr.string =[NSString stringWithFormat:@"%@",bookItem.strdw];
                        if(chinesedwStr.string==nil){
                            chinesedwStr.string=@"";
                        }
                        
                        if(![chinesedwStr.string isEqualToString:@""]){
                            NSString *pinYinResult=[NSString string];
                            for(int j=0;j<chinesedwStr.string.length;j++){
                                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chinesedwStr.string characterAtIndex:j])]uppercaseString];
                                
                                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                            }
                            chinesedwStr.pinYin=pinYinResult;
                        }else{
                            chinesedwStr.pinYin=@"";
                        }
                        bookItem.dwsuoyinStr = [NSString stringWithFormat:@"%@",chinesedwStr.pinYin];//赋值
                        
                        bookItem.isCheckedUp = NO;//默认未选中
                        [allAddressBookInfoArray addObject:bookItem];
                    }
                    //数据组装
                    [self allContactInSuoyin];
                    [self NSSetinGroup];
                    //写入本地
                    [self writeToLocal];
                }
            [self.allContactListTable reloadData];
            [self.groupListTable reloadData];
            [self.checkTitleBar setHidden:YES];
        } Failed:^(NSError *error){
            NSLog(@"wrong");
            [self closeWaitView];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.allContactListTable reloadData];
            [self.groupListTable reloadData];
            [self.checkTitleBar setHidden:YES];
        }];
    }
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
    if ([searchBarKuang respondsToSelector:@selector(barTintColor)]) {
        [self.searchDisplayController.searchBar setShowsCancelButton:NO];
    }
    else
    {
    //iOS7.0以下
        [self.searchDisplayController.searchBar setShowsCancelButton:YES];
        for(UIView *subView in searchDisplayController.searchBar.subviews)
        {
            if([subView isKindOfClass:[UIButton class]])
            {
                [(UIButton*)subView setTitle:@"取消" forState:UIControlStateNormal];
            }
        }
        
    }
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.allContactListTable reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [searchBarKuang resignFirstResponder];
}
#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //ios7,searchDisplayController显示问题解决
    if ([searchBarKuang respondsToSelector:@selector(barTintColor)]) {
        //[self.view bringSubviewToFront:self.navigationView];
        [self.view bringSubviewToFront:self.allContactsListBtn];
        [self.view bringSubviewToFront:self.groupListBtn];
        [self.view bringSubviewToFront:self.checkTitleBar];
    }
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //ios7,searchDisplayController显示问题解决
    if ([searchBarKuang respondsToSelector:@selector(barTintColor)]) {
        controller.searchResultsTableView.frame = CGRectMake(0, mainScrollView.origin.y+searchBarKuang.bottom, self.view.width, self.view.height-mainScrollView.origin.y-searchBarKuang.bottom);
        controller.searchResultsTableView.contentInset = UIEdgeInsetsZero;
    }

}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
#pragma mark -
#pragma mark ContentFiltering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[searchListContent removeAllObjects];
    for (NSArray *section in allContactListArray) {
        for (ztOAABModel *addressBook in section)
        {
            //按人名搜索
            //NSComparisonResult result = [addressBook.strxm compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            //按单位搜索
             //NSComparisonResult dwResult = [addressBook.strdw compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            //if (result == NSOrderedSame || dwResult == NSOrderedSame)
            
            NSRange rangeOfName=[addressBook.strxm rangeOfString:searchText];
            NSRange rangeOfDw=[addressBook.strdw rangeOfString:searchText];
            
            if (rangeOfName.location!=NSNotFound || rangeOfDw.location!=NSNotFound )
            {
                [searchListContent addObject:addressBook];
            }
            else
            {
                //中文可根据拼音搜索
                NSRange rangePinyin = [addressBook.suoyinStr rangeOfString:searchText options:NSCaseInsensitiveSearch | NSNumericSearch];//人名
                
                NSRange rangeDwPinyin = [addressBook.dwsuoyinStr rangeOfString:searchText options:NSCaseInsensitiveSearch | NSNumericSearch];//单位
                
                if (rangePinyin.location!=NSNotFound || rangeDwPinyin.location!=NSNotFound) {
                    //根据中文或英文搜索
                    [searchListContent addObject:addressBook];
                }
            }
            
        }
    }
}
#pragma mark - tableview delegate -
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (allContactListTable==tableView) {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    else return nil;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else if(tableView == allContactListTable) {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
        else
            return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == allContactListTable) {
        return ([[allContactListArray objectAtIndex:section] count]>0) ? 20 : 0;
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return 0;
    }
    else if (tableView == self.groupListTable)
    {
        return 50;
    }
    else
        return 20;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==groupListTable) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *groupIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
        groupIconImage.backgroundColor = [UIColor clearColor];
        groupIconImage.image = [UIImage imageNamed:@"treeIcon_01"];
        [headView  addSubview:groupIconImage];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, tableView.width-45-50,20)];
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.font = [UIFont systemFontOfSize:14.0f];
        titleLable.textColor = [UIColor blackColor];
        if (section==0) {
            titleLable.text = @"所有联系人";
        }
        else
        {
            titleLable.text = [[groupListArray objectAtIndex:(section-1)] objectForKey:@"dw"];
        }
        [headView addSubview:titleLable];
        
        UILabel *numberLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, tableView.width-45-50,20)];
        numberLable.textColor = [UIColor grayColor];
        numberLable.backgroundColor = [UIColor clearColor];
        numberLable.font = [UIFont systemFontOfSize:14.0f];
        if (section==0) {
            numberLable.text = [NSString stringWithFormat:@"%d人",allAddressBookInfoArray.count];
        }
        else
        {
            numberLable.text = [NSString stringWithFormat:@"%d人",((NSMutableArray *)[[groupListArray objectAtIndex:(section-1)] objectForKey:@"array"]).count];
        }
        [headView addSubview:numberLable];
        
        UIImageView *cellOpenOrCloseImage = [[UIImageView alloc] initWithFrame:CGRectMake(numberLable.right+10, 10, 30, 30)];
        cellOpenOrCloseImage.backgroundColor = [UIColor clearColor];
        if ([[openFlagArray objectAtIndex:section] isEqualToString:@"展开"]) {
            cellOpenOrCloseImage.image = [UIImage imageNamed:@"icon_arrow_up"];
        }
        else
        {
            cellOpenOrCloseImage.image = [UIImage imageNamed:@"icon_arrow_down"];
        }
        [headView  addSubview:cellOpenOrCloseImage];
        headView.tag = 100+section;
        
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [headView addSubview:lineBreak];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openOrCloseCellAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        [headView addGestureRecognizer:tapGesture];
        
        return headView;
    }
    else
    {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        headView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
        headView.alpha= 0.5;
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
        headLabel.textAlignment = NSTextAlignmentLeft;
        headLabel.backgroundColor = [UIColor clearColor];
        headLabel.font = [UIFont systemFontOfSize:15.0f];
        headLabel.textColor = [UIColor whiteColor];
        
        if (tableView == allContactListTable) {
            headLabel.text =  [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }
        else if (tableView == self.searchDisplayController.searchResultsTableView) {
            headLabel.text=@"";
        }
        
        else {
            headLabel.text=@"";
        }
        [headView addSubview:headLabel];
        return headView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (allContactListTable == tableView) {
        return [[allContactListArray objectAtIndex:section] count];
    }
    else if (groupListTable == tableView){
        if ([[openFlagArray objectAtIndex:section] isEqualToString:@"展开"]) {
            if (section==0) {
                return allAddressBookInfoArray.count;
            }
            else
                return ((NSMutableArray *)[[groupListArray objectAtIndex:section-1] objectForKey:@"array"]).count ;
        }
        else
        {
            return 0;
        }
        
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchListContent count];
    }
    else
        return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (allContactListTable==tableView) {
        
        return allContactListArray.count;
    }
    else if(groupListTable == tableView){
        if (groupListArray.count==0) {
            return 0;
        }
        else   return groupListArray.count+1;
    }
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addressId";
    ztOAAddressBookItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ztOAAddressBookItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    ztOAABModel *addressItem = [[ztOAABModel alloc] init];
    if (allContactListTable == tableView) {
        addressItem = (ztOAABModel *)[[allContactListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.name.text = addressItem.strxm;
        cell.companyName.text = addressItem.strdw;
    }
    else if (tableView == self.searchDisplayController.searchResultsTableView){
        
        addressItem = (ztOAABModel *)[searchListContent objectAtIndex:indexPath.row];
        cell.name.text = addressItem.strxm;
        cell.companyName.text = addressItem.strdw;
    }
    else if(groupListTable == tableView) {
        if (indexPath.section==0) {
            addressItem = (ztOAABModel *)[allAddressBookInfoArray objectAtIndex:indexPath.row];
            cell.name.text = addressItem.strxm;
            cell.companyName.text = addressItem.strdw;
        }
        else
        {
            addressItem = (ztOAABModel *)[[[groupListArray objectAtIndex:(indexPath.section-1)] objectForKey:@"array"] objectAtIndex:indexPath.row];
            cell.name.text = addressItem.strxm;
            cell.companyName.text = addressItem.strdw;
        }
        //(2, 7, 30, 30)        (35, 12, self.width-60-60, 20)        (name.right+5, 2, 40, 40)
        
        [cell.cellIcon setOrigin:CGPointMake(2+20, 7)];
        [cell.name setOrigin:CGPointMake(35+20, 5)];
        [cell.companyName setOrigin:CGPointMake(35+20, 30)];
        [cell.checkedBtn setOrigin:CGPointMake(cell.name.right+5, 2)];
    }
    
    cell.ABookCell = addressItem;
    [cell setChecked:addressItem.isCheckedUp];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ztOAABModel *addressBook;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        addressBook = (ztOAABModel *)[searchListContent objectAtIndex:indexPath.row];
        ztOAAddressBookDetailInfoViewController *VC = [[ztOAAddressBookDetailInfoViewController alloc] initWithBook:addressBook];
        VC.title=@"通讯录详情";
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if(tableView == self.allContactListTable) {
        addressBook = (ztOAABModel *)[[allContactListArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        ztOAAddressBookDetailInfoViewController *VC = [[ztOAAddressBookDetailInfoViewController alloc] initWithBook:addressBook];
        VC.title=@"通讯录详情";
        [self.navigationController pushViewController:VC animated:YES];
    }
    else if (tableView == self.groupListTable)
    {
        if (indexPath.section==0) {
            addressBook = (ztOAABModel *)[allAddressBookInfoArray objectAtIndex:indexPath.row];
        }
        else
        {
            addressBook = (ztOAABModel *)[((NSMutableArray *)[[groupListArray objectAtIndex:(indexPath.section-1)] objectForKey:@"array"]) objectAtIndex:indexPath.row];
        }
        ztOAAddressBookDetailInfoViewController *VC = [[ztOAAddressBookDetailInfoViewController alloc] initWithBook:addressBook];
        VC.title=@"通讯录详情";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark - scrollView delegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBarKuang resignFirstResponder];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (mainScrollView==scrollView) {
        if (mainScrollView.contentOffset.x>0) {
            [allContactsListBtn setSelected:NO];
            [groupListBtn setSelected:YES];
            isGroupListOrNot = @"2";
            [searchBarKuang resignFirstResponder];
        }
        else
        {
            [allContactsListBtn setSelected:YES];
            [groupListBtn setSelected:NO];
            isGroupListOrNot = @"1";
            [searchBarKuang resignFirstResponder];
        }
    }
}
#pragma mark - longPressUpDelegate -
- (void)longPressUpLateAction:(ztOAABModel *)ABook
{
    NSLog(@"name%@",ABook.strxm);
    
    longPressABModel = ABook;
    if (![ABook.stryddh isEqualToString:@""] || ![ABook.strbgdh isEqualToString:@""]) {
        //长按选择框
        UIActionSheet *longPressUpActionSheet = [[UIActionSheet alloc] initWithTitle:ABook.strxm delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"呼叫",@"发送短信",@"导入到通讯录", nil];
        [longPressUpActionSheet setFrame:CGRectMake(0, self.view.size.height-260, 320, 260)];
        longPressUpActionSheet.delegate = self;
        longPressUpActionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [longPressUpActionSheet showInView:self.view];
    }
    
}
#pragma mark - actionSheetDelegate -
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"呼叫");
            if (![longPressABModel.stryddh isEqualToString:@""]) {
              [self toCallPhotoNumber:longPressABModel.stryddh];
            }
            else
            {
                [self toCallPhotoNumber:longPressABModel.strbgdh];
            }
        }
            break;
        case 1:
        {
             NSLog(@"发送短信");
            if (![longPressABModel.stryddh isEqualToString:@""]) {
                [self sendSMS:@"" recipientList:[NSArray arrayWithObjects:longPressABModel.stryddh, nil]];
            }
            else
            {
                [self sendSMS:@"" recipientList:[NSArray arrayWithObjects:longPressABModel.strbgdh, nil]];
            }
        }
            break;
        case 2:
        {
             NSLog(@"导入到通讯录");
            [self doLoadToPhone:[NSMutableArray arrayWithObjects:longPressABModel, nil]];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -本地数据处理-
//删除本地数据
- (void)removeAllHistoryInfo
{
    [allContactListArray removeAllObjects];
    [groupListArray removeAllObjects];
    [allAddressBookInfoArray removeAllObjects];
    [grouSetArray removeAllObjects];
    [openFlagArray removeAllObjects];
    
    [self.allContactListTable reloadData];
    [self.groupListTable reloadData];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESSBOOKLIST"] != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ADDRESSBOOKLIST"];
    }
}
//存储本地数据
- (void)writeToLocal
{
    NSMutableArray *allInfoDicArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<allAddressBookInfoArray.count; i++) {
        //intrylsh,intdwpxh,intrypxh,strxm,strdw,strbgdh,stryddh,strzw,sectionNumber,suoyinStr
        ztOAABModel *oneBook = [allAddressBookInfoArray objectAtIndex:i];
        NSDictionary *dicBook = [NSDictionary dictionaryWithObjectsAndKeys:
                                 oneBook.intrylsh,@"intrylsh",
                                 oneBook.intdwpxh,@"intdwpxh",
                                 oneBook.intrypxh,@"intrypxh",
                                 oneBook.strxm,@"strxm",
                                 oneBook.strdw,@"strdw",
                                 oneBook.strbgdh,@"strbgdh",
                                 oneBook.stryddh,@"stryddh",
                                 oneBook.strzw,@"strzw",
                                 oneBook.suoyinStr,@"suoyinStr" ,
                                 oneBook.dwsuoyinStr,@"dwsuoyinStr",
                                 [NSNumber numberWithBool:oneBook.isCheckedUp],@"isCheckedUp" ,nil];
        [allInfoDicArray addObject:dicBook];
    }
    if (allInfoDicArray.count>0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:allInfoDicArray forKey:@"ADDRESSBOOKLIST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
//获取本地数据
- (void)getLocalAddressBookInfoList
{
    [allAddressBookInfoArray removeAllObjects];
    NSArray *localDicList = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADDRESSBOOKLIST"];
    for (int i = 0; i<localDicList.count; i++) {
        NSDictionary *dicInfo = [localDicList objectAtIndex:i];
        ztOAABModel *oneBook =[[ztOAABModel alloc]init];
        oneBook.intrylsh= [dicInfo objectForKey:@"intrylsh"];
        oneBook.intdwpxh= [dicInfo objectForKey:@"intdwpxh"];
        oneBook.intrypxh= [dicInfo objectForKey:@"intrypxh"];
        oneBook.strxm= [dicInfo objectForKey:@"strxm"];
        oneBook.strdw= [dicInfo objectForKey:@"strdw"];
        oneBook.strbgdh= [dicInfo objectForKey:@"strbgdh"];
        oneBook.stryddh= [dicInfo objectForKey:@"stryddh"];
        oneBook.strzw= [dicInfo objectForKey:@"strzw"];
        oneBook.suoyinStr= [dicInfo objectForKey:@"suoyinStr"];
        oneBook.dwsuoyinStr= [dicInfo objectForKey:@"dwsuoyinStr"];
        oneBook.isCheckedUp= [[dicInfo objectForKey:@"isCheckedUp"] boolValue];
        [allAddressBookInfoArray addObject:oneBook];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
