//
//  ztOANewDocTableViewController.m
//  OAMobileIOS
//
//  Created by ran chen on 14-5-14.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOANewDocTableViewController.h"
#import "ztOANewDocTableViewCell.h"
#import "ztOANewDocInfo.h"
#import "ztOAPersonGroupInfo.h"
#import "ztOAPersonInfo.h"

@interface ztOANewDocTableViewController ()
{
    NSString        *titleStr;
    NSMutableArray  *allData;//所有节点
    NSString        *currentStrcxlx;//当前查询类型
    NSString        *i_Strcxlx;//传入原始查询类型数据
    NSString        *currentCompanylsh;//当前查询处室流水号
    NSString        *i_multiSelectFlag;//节点单选多选标志<!--1：单选 ；2:多选；3：不需要返回下一步责任对象 -->
    NSMutableArray  *i_selectedArray;//选中的数组
    NSString        *i_selectNameStr;
    NSString        *lastTitle;
    NSString        *ryzTitle;
    int level;
    int personGroupLevel;
    float bottom;
    BOOL mail;
}
@property (nonatomic,strong)UITableView         *myTableView;//列表
@property (nonatomic,strong)UITableView         *ryzTableView;//人员组列表
@property (nonatomic,strong)UIView              *popView;//弹出框
@property (nonatomic,strong)UITableView         *selectedTableView;//已选择的人员列表
@property (nonatomic,strong)UIButton            *leftChooseBtn;//左边选择按钮
@property (nonatomic,strong)UIButton            *rightChooseBtn;//右边选择按钮
@property (nonatomic,strong)NSMutableArray      *personGroupArray;//人员组列表数据源
@property (nonatomic,strong)NSMutableArray      *selectedDataSource;//已选中人列表数据源
@property (nonatomic,strong)UIButton            *selectedName;
@property (nonatomic,strong)NSMutableDictionary *storeDict;//组织机构保存字典
@property (nonatomic,strong)NSMutableDictionary *persongroupStoreDict;//人员组保存字典
@property (nonatomic,strong)NSMutableArray      *lshArr;
@property (nonatomic,strong)NSMutableArray      *dwNameArr;
@property (nonatomic,strong)UIScrollView        *mainScrollView;
@end

@implementation ztOANewDocTableViewController
@synthesize myTableView, ryzTableView, popView, selectedTableView, leftChooseBtn, rightChooseBtn, personGroupArray, selectedDataSource, selectedName, storeDict, persongroupStoreDict, lshArr, dwNameArr, mainScrollView;

- (id)initWithTitleName:(NSString *)titleName data:(id)initData strcxlx:(NSString *)strcxlx multiSelectFlag:(NSString *)multiSelectFlag withCompanylsh:(NSString *)initCompanylsh isMail:(BOOL)isMail
{
    self = [super init];
    if (self) {
        self.title=titleName;
        mail = isMail;
        currentStrcxlx = [NSString stringWithFormat:@"%@",strcxlx];
        i_Strcxlx = [NSString stringWithFormat:@"%@",strcxlx];
        currentCompanylsh = initCompanylsh;
        allData = [[NSMutableArray alloc] init];
        i_multiSelectFlag = multiSelectFlag;
        i_selectedArray = [[NSMutableArray alloc] init];
        i_selectNameStr = @"  已选中：0个：";
        storeDict = [[NSMutableDictionary alloc] init];
        persongroupStoreDict = [[NSMutableDictionary alloc] init];
        
        level = 0;
        personGroupLevel = 0;
        lastTitle = @"";
        ryzTitle = @"";
        
        lshArr = [[NSMutableArray alloc] init];
        dwNameArr = [[NSMutableArray alloc] init];
        if (mail) {
            personGroupArray = [[NSMutableArray alloc] init];
        }
        selectedDataSource = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (mail) {
        [self loadPersonGroupList];
    }
    [self loadDataWithCompanyLsh:currentCompanylsh andLoadType:0 andLevel:0];
}

- (void)replaceLshWithLsh:(NSString *)aLsh{
    NSDictionary *lshDict = [NSDictionary dictionaryWithObject:aLsh forKey:[NSString stringWithFormat:@"level%d", level]];
    if (lshArr.count == 0) {
        [lshArr addObject:lshDict];
    } else{
        for (int i = 0; i < lshArr.count; i++) {
            NSDictionary *dict = [lshArr objectAtIndex:i];
            if ([[[dict allKeys] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"level%d", level]]) {
                [lshArr replaceObjectAtIndex:i withObject:lshDict];
                break;
            } else{
                if (i == lshArr.count - 1) {
                    [lshArr addObject:lshDict];
                }
            }
        }
    }
}

#pragma mark LoadData Function
- (void)loadPersonGroupList{
    personGroupLevel = 0;
    NSDictionary *sendData = [NSDictionary dictionaryWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh, @"intrylsh", [ztOAGlobalVariable sharedInstance].intdwlsh_child, @"intcsdwlsh", [ztOAGlobalVariable sharedInstance].intdwlsh, @"intdwlsh", @"1", @"intlx", nil];
    [ztOAService getPersonGroupList:sendData Success:^(id result) {
        NSDictionary *resultDict = [result objectFromJSONData];
        if ([[[resultDict objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
            NSArray *ryzxxArray = [[[resultDict objectForKey:@"root"] objectForKey:@"ryz"] objectForKey:@"ryzxx"];
            if (ryzxxArray.count > 0) {
                for (NSDictionary *ryzxxDict in ryzxxArray) {
                    ztOAPersonGroupInfo *info = [[ztOAPersonGroupInfo alloc] init];
                    info.intryzbh = [NSString stringWithFormat:@"%@", [ryzxxDict objectForKey:@"intryzbh"]];
                    info.strryzmc =[NSString stringWithFormat:@"%@",[ryzxxDict objectForKey:@"strryzmc"]] ;
                    [personGroupArray addObject:info];
                }
                [ryzTableView reloadData];
                NSArray *tempArray = [NSArray arrayWithArray:personGroupArray];
                [persongroupStoreDict setObject:tempArray forKey:@"PersonGroupList"];
                NSLog(@"persongourpStoreDict:%@", persongroupStoreDict);
            }
        }
    } Failed:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

- (void)loadPersonWithRyzBh:(NSString *)aRyzBh{
    personGroupLevel = 1;
    
    for (NSString *key in [persongroupStoreDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d*#%@", personGroupLevel, aRyzBh] isEqualToString:key]) {
            [personGroupArray removeAllObjects];
            personGroupArray =[NSMutableArray arrayWithArray:[persongroupStoreDict objectForKey:key]];
            [ryzTableView reloadData];
            return;
        }
    }
    
    NSDictionary *sendData = [NSDictionary dictionaryWithObject:aRyzBh forKey:@"intryzbh"];
    [ztOAService getPersonList:sendData Success:^(id result) {
        NSDictionary *resultDict = [result objectFromJSONData];
        if ([[[resultDict objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
            NSArray *ryxxArray = [[[resultDict objectForKey:@"root"] objectForKey:@"ry"] objectForKey:@"ryxx"];
            if (ryxxArray.count > 0) {
                [personGroupArray removeAllObjects];
                for (NSDictionary *ryDict in ryxxArray) {
                    ztOANewDocInfo *info = [[ztOANewDocInfo alloc] init];
                    info.dwlsh = [ryDict objectForKey:@"intrylsh"];
                    info.fullName = [ryDict objectForKey:@"strryxm"];
                    info.shortName = [ryDict objectForKey:@"strryxm"];
                    info.chrbz = @"1";
                    info.isSelected = NO;
                    info.type = 1;
                    [personGroupArray addObject:info];
                }
                [ryzTableView reloadData];
                NSArray *tempArray = [NSArray arrayWithArray:personGroupArray];
                [persongroupStoreDict setObject:tempArray forKey:[NSString stringWithFormat:@"level%d*#%@", personGroupLevel, aRyzBh]];
                NSLog(@"persongourpStoreDict:%@", persongroupStoreDict);
            }
        }
    } Failed:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

/*
 *aLsh:需要查询的单位流水号
 */
- (void)loadDataWithCompanyLsh:(NSString *)aLsh andLoadType:(int)aType andLevel:(int)aLevel{
    //已有数据，无需重新请求
    for (NSString *key in [storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh] isEqualToString:key]) {
            [self replaceLshWithLsh:aLsh];
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:key]];
            [myTableView reloadData];
            return;
        }
    }
    
    //数据没保存或者没有数据
    [self showWaitView];
    NSString *xmlStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strdwmc>%@</strdwmc><strdwccbm>%@</strdwccbm></root>",@"",@""];
    /*
     **currentStrCxlx 查询类型
     **1：查询一个机构；
     **2：查询下级机构；
     **3：查询下级机构及人员；
     **默认等于3：查询下级机构
     */
    if ([currentStrcxlx intValue]==2) {
        currentStrcxlx=@"2";
    } else{
        currentStrcxlx = @"3";
    }
    
    NSDictionary *sendData = [NSDictionary dictionaryWithObjectsAndKeys:aLsh, @"intdwlsh", currentStrcxlx, @"strcxlx", xmlStr, @"queryTermXML", nil];
    [ztOAService getCompanyPersonList:sendData Success:^(id result) {
        NSDictionary *resultDict = [result objectFromJSONData];
        if (allData.count > 0) {
            [allData removeAllObjects];
        }
        if ([[[resultDict objectForKey:@"root"] objectForKey:@"result"] intValue] == 0) {
            [self replaceLshWithLsh:aLsh];
            NSArray *unitInfoData = [[resultDict objectForKey:@"root"] objectForKey:@"unitinfo"];
            NSArray *userInfoData = [[resultDict objectForKey:@"root"] objectForKey:@"userinfo"];
            
            //单位数据
            if (unitInfoData) {
                if ([unitInfoData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in unitInfoData) {
                        ztOANewDocInfo *unitInfo = [[ztOANewDocInfo alloc] init];
                        unitInfo.isSelected = NO;
                        unitInfo.type = 2;
                        unitInfo.chrbz = @"0";
                        unitInfo.fullName = [dict objectForKey:@"strdwmc"];
                        unitInfo.shortName = [dict objectForKey:@"strdwjc"];
                        unitInfo.dwlsh = [dict objectForKey:@"intdwlsh"];
                        [allData addObject:unitInfo];
                    }
                } else{
                    ztOANewDocInfo *unitInfo = [[ztOANewDocInfo alloc] init];
                    unitInfo.isSelected = NO;
                    unitInfo.type = 2;
                    unitInfo.chrbz = @"0";
                    unitInfo.fullName = [(NSDictionary *)unitInfoData objectForKey:@"strdwmc"];
                    unitInfo.shortName = [(NSDictionary *)unitInfoData objectForKey:@"strdwjc"];
                    unitInfo.dwlsh = [(NSDictionary *)unitInfoData objectForKey:@"intdwlsh"];
                    [allData addObject:unitInfo];
                }
            }
            
            //个人数据
            if (userInfoData) {
                if ([userInfoData isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in userInfoData) {
                        ztOANewDocInfo *userInfo = [[ztOANewDocInfo alloc] init];
                        userInfo.isSelected = NO;
                        userInfo.type = 1;
                        userInfo.chrbz = @"1";
                        userInfo.fullName = [dict objectForKey:@"strryxm"];
                        userInfo.shortName = [dict objectForKey:@"strryxm"];
                        userInfo.dwlsh = [dict objectForKey:@"intrylsh"];
                        [allData addObject:userInfo];
                    }
                } else{
                    ztOANewDocInfo *userInfo = [[ztOANewDocInfo alloc] init];
                    userInfo.isSelected = NO;
                    userInfo.type = 1;
                    userInfo.chrbz = @"1";
                    userInfo.fullName = [NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                    userInfo.shortName = [NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                    userInfo.dwlsh = [(NSDictionary *)userInfoData objectForKey:@"intrylsh"];
                    [allData addObject:userInfo];
                }
                
            }
        }
        NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
        [storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", aLevel, aLsh]];
        [myTableView reloadData];
        [self closeWaitView];
    } Failed:^(NSError *error) {
        [self closeWaitView];
    }];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    float scrollViewWidth = self.view.width;
    if ([i_multiSelectFlag isEqualToString:@"2"]) {
        //多选
       [self rightButton:@"确定" Sel:@selector(selectedConfirm)];
        self.selectedName = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectedName addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [selectedName setBackgroundColor:MF_ColorFromRGB(231, 231, 231)];
        [selectedName setFrame:CGRectMake(0, 64, self.view.width, 30)];
        [selectedName.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [selectedName setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [selectedName.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [selectedName setTitle:i_selectNameStr forState:UIControlStateNormal];
        [self.view addSubview:selectedName];
        bottom = selectedName.height+64;
        //弹出框
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [popView setUserInteractionEnabled:YES];
        UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, popView.width, popView.height)];
        [bgImgView setBackgroundColor:[UIColor blackColor]];
        [bgImgView setAlpha:0.5];
        [bgImgView setUserInteractionEnabled:YES];
        [popView addSubview:bgImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popviewTapHandler)];
        [bgImgView addGestureRecognizer:tap];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(30, 64+10, popView.width - 60, popView.height - 64*2)];
        [selectedView setBackgroundColor:[UIColor whiteColor]];
        [popView addSubview:selectedView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selectedView.width, 40)];
        [titleLabel setBackgroundColor:MF_ColorFromRGB(53, 105, 236)];
        titleLabel.textColor=[UIColor whiteColor];
        [titleLabel setText:@"已选择的人员："];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [selectedView addSubview:titleLabel];
        
        //已选择人员列表
        self.selectedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, selectedView.width, selectedView.height - titleLabel.bottom - 40) style:UITableViewStylePlain];
        [selectedTableView setTableFooterView:nil];
        [selectedTableView setBackgroundColor:[UIColor whiteColor]];
        [selectedTableView setDelegate:self];
        [selectedTableView setDataSource:self];
        if (currentSystemVersion >= 7.0) {
            [selectedTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 15)];
        }
        [selectedView addSubview:selectedTableView];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [okBtn setFrame:CGRectMake(0, selectedTableView.bottom, selectedView.width / 2, 40)];
        [okBtn setBackgroundColor:MF_ColorFromRGB(231, 231, 231)];
        [okBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectedView addSubview:okBtn];
        UILabel *hlb=[[UILabel alloc]initWithFrame:CGRectMake(okBtn.right, selectedTableView.bottom, 1, 40)];
        [hlb setBackgroundColor:MF_ColorFromRGB(200, 200, 200)];
        [selectedView addSubview:hlb];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setFrame:CGRectMake(hlb.right, okBtn.top, okBtn.width, okBtn.height)];
        [cancelBtn setBackgroundColor:MF_ColorFromRGB(231, 231, 231)];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [selectedView addSubview:cancelBtn];
    }
    //若为邮件选择
    if (mail) {
        leftChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, bottom, self.view.width/2, 44)];
        [leftChooseBtn setUserInteractionEnabled:YES];
        [leftChooseBtn setTitle:@"组织机构" forState:UIControlStateNormal];
        [leftChooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [leftChooseBtn setBackgroundColor:MF_ColorFromRGB(231, 231, 231)];
        [leftChooseBtn setSelected:YES];
        [leftChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftChooseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [leftChooseBtn addTarget:self action:@selector(showPartyList) forControlEvents:UIControlEventTouchUpInside];
        [leftChooseBtn setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:leftChooseBtn];
      
        
        
        
        rightChooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2, bottom, self.view.width/2, 44)];
        [rightChooseBtn setUserInteractionEnabled:YES];
        [rightChooseBtn setTitle:@"人员组" forState:UIControlStateNormal];
        [rightChooseBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [rightChooseBtn setBackgroundColor:MF_ColorFromRGB(231, 231, 231)];
        [rightChooseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightChooseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [rightChooseBtn addTarget:self action:@selector(showRyzList) forControlEvents:UIControlEventTouchUpInside];
        [rightChooseBtn setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:rightChooseBtn];
        bottom = rightChooseBtn.bottom;
        scrollViewWidth = self.view.width * 2;
    }
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, bottom,self.view.width, self.view.height-bottom)];
    [mainScrollView setContentOffset:CGPointMake(0, 0)];
    [mainScrollView setContentSize:CGSizeMake(scrollViewWidth, 0)];
    mainScrollView.delegate = self;
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setPagingEnabled:YES];
    [self.view addSubview:mainScrollView];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, mainScrollView.height) style:UITableViewStylePlain];
    [myTableView  setTableFooterView:nil];
    [myTableView setDelegate:self];
    [myTableView setDataSource:self];
    [mainScrollView addSubview:myTableView];
    
    if (mail) {
        self.ryzTableView = [[UITableView alloc] initWithFrame:CGRectMake(myTableView.right, 0, self.view.width, mainScrollView.height) style:UITableViewStylePlain];
        [myTableView setTableFooterView:nil];
        [ryzTableView setDelegate:self];
        [ryzTableView setDataSource:self];
        [mainScrollView addSubview:ryzTableView];
    }
    [self.view addSubview:mainScrollView];
    [self.view bringSubviewToFront:selectedName];
}

-(void)selectedBtnClicked:(id)sender{
    [selectedTableView reloadData];
    [self.view addSubview:popView];
    
}

-(void)popviewTapHandler{
    [popView removeFromSuperview];
}

- (void)okBtnClicked:(id)sender{
    selectedDataSource = [NSMutableArray arrayWithArray:i_selectedArray];
    [selectedName setTitle:i_selectNameStr forState:UIControlStateNormal];
    [myTableView reloadData];
    [ryzTableView reloadData];
    [popView removeFromSuperview];
}

- (void)cancelBtnClicked:(id)sender{
    i_selectedArray = [NSMutableArray arrayWithArray:selectedDataSource];
    for (ztOANewDocInfo *info in i_selectedArray) {
        info.isSelected = YES;
    }
    [myTableView reloadData];
    [ryzTableView reloadData];
    [popView removeFromSuperview];
}
#pragma mark - scrollView delegate -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (mainScrollView==scrollView) {
        if (mainScrollView.contentOffset.x>0) {
            [leftChooseBtn setSelected:NO];
            [rightChooseBtn setSelected:YES];
        }
        else
        {
            [leftChooseBtn setSelected:YES];
            [rightChooseBtn setSelected:NO];
        }
    }
}

#pragma mark ChooseBtn Action
- (void)showPartyList{
    if (![leftChooseBtn isSelected]) {
        [leftChooseBtn setSelected:YES];
        [rightChooseBtn setSelected:NO];
        [myTableView scrollsToTop];
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)showRyzList{
    if (![rightChooseBtn isSelected]) {
        [rightChooseBtn setSelected:YES];
        [leftChooseBtn setSelected:NO];
        [ryzTableView scrollsToTop];
        [mainScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    }
}

- (void)backToLastLevel:(id)sender{
    if (mainScrollView.contentOffset.x >=0 && mainScrollView.contentOffset.x < self.view.width) {
        if (level == 0) {
            //已是第一页时，点击返回退出返回之前的页面
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            //页面>=1，根据保存的流水号数组与已加载数据获取上一层列表相关信息数据并加载
            level--;
            [allData removeAllObjects];
            NSString *lsh = [[lshArr objectAtIndex:level] objectForKey:[NSString stringWithFormat:@"level%d", level]];
            allData = [NSMutableArray arrayWithArray:[storeDict objectForKey:[NSString stringWithFormat:@"level%d&lsh%@", level, lsh]]];
            lastTitle = level > 0? [[dwNameArr objectAtIndex:level - 1] objectForKey:[NSString stringWithFormat:@"level%d", level - 1]] : @"";
            [myTableView reloadData];
        }
    } else{
        if (personGroupLevel == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            personGroupLevel--;
            [personGroupArray removeAllObjects];
            personGroupArray = [NSMutableArray arrayWithArray:[persongroupStoreDict objectForKey:@"PersonGroupList"]];
            [ryzTableView reloadData];
        }
    }
    
}

- (void)selectedConfirm{
    NSString *i_Zrrlsh=@"";
    NSString *i_content = @"";
    NSString *xml =@"";
    NSMutableArray *pepoleInfoArray = [[NSMutableArray alloc] init];//写信人员数据
    for (int i = 0;i < i_selectedArray.count ;i++) {
        ztOANewDocInfo *info = [i_selectedArray objectAtIndex:i];
        i_Zrrlsh = [NSString stringWithFormat:@"%@",info.dwlsh];
        
        xml= [xml stringByAppendingString:[NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>",i_Zrrlsh,i_Strcxlx,[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",info.shortName]]]];
        
        i_content = i<i_selectedArray.count-1? [i_content stringByAppendingString:[NSString stringWithFormat:@"%@,",info.shortName]]:[i_content stringByAppendingString:[NSString stringWithFormat:@"%@",info.shortName]];
        NSDictionary *oneManDic = [NSDictionary dictionaryWithObjectsAndKeys:info.chrbz, @"chrbz", info.dwlsh, @"lsh", info.shortName, @"name", nil];
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

#pragma mark UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == myTableView) {
        return allData.count;
    } else if (tableView == ryzTableView){
        return personGroupArray.count;
    } else if (tableView == selectedTableView){
        return selectedDataSource.count;
    }
    return 0;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    if (tableView == myTableView) {
        if (level != 0) {
            [self setHeaderView:sectionView title:lastTitle];
        }else{
            [sectionView setBackgroundColor:[UIColor clearColor]];
        }
    } else if(tableView == ryzTableView){
        if (personGroupLevel != 0) {
            [self setHeaderView:sectionView title:ryzTitle];
        } else{
            [sectionView setBackgroundColor:[UIColor clearColor]];
        }
    } else if (tableView == selectedTableView){
        [sectionView setBackgroundColor:[UIColor clearColor]];
    }
    
    return sectionView;
}

- (void)setHeaderView:(UIView *)aView title:(NSString *)aTitle{
    [aView setFrame:CGRectMake(0, 0, self.view.width, 44)];
    [aView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setBackgroundImage:[self createImageWithColor:MF_ColorFromRGB(245, 245, 245)] forState:UIControlStateHighlighted];
    [backBtn setFrame:aView.frame];
    [backBtn addTarget:self action:@selector(backToLastLevel:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:backBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10,5, self.view.width-40, 30)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont boldSystemFontOfSize:15];
    lab.text = aTitle;
    [backBtn addSubview:lab];
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(lab.right + 1, 18, 25 / 2, 7)];
    [iconImg setImage:[UIImage imageNamed:@"arrow_up"]];
    [backBtn addSubview:iconImg];
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.width, 1)];
    [splitView setBackgroundColor:[UIColor lightGrayColor]];
    [aView addSubview:splitView];
}

- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == myTableView) {
        if (level == 0) {
            return 0;
        }
    } else if (tableView == ryzTableView){
        if (personGroupLevel == 0) {
            return 0;
        }
    } else if (tableView == selectedTableView){
        return 0;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"identifier";    
    ztOANewDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ztOANewDocTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //组织机构列表
    if (tableView == myTableView) {
        ztOANewDocInfo *info = [allData objectAtIndex:indexPath.row];
        if (info.type == 2) {
            [cell setCellImageView:[UIImage imageNamed:@"treeIcon_01"]];
        } else{
            [cell setCellImageView:[UIImage imageNamed:@"treeIcon_02"]];
        }
        cell.accessoryType = info.isSelected? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        [cell.title setText:[NSString stringWithFormat:@"%@", info.shortName]];
        
    } else if (tableView == ryzTableView){//人员组列表
        NSString *nameStr;
        if ([[personGroupArray objectAtIndex:0] isKindOfClass:[ztOAPersonGroupInfo class]]) {
            ztOAPersonGroupInfo *info = [personGroupArray objectAtIndex:indexPath.row];
            nameStr = info.strryzmc;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setCellImageView:[UIImage imageNamed:@"treeIcon_01"]];
        } else if ([[personGroupArray objectAtIndex:0] isKindOfClass:[ztOANewDocInfo class]]){
            ztOANewDocInfo *info = [personGroupArray objectAtIndex:indexPath.row];
            nameStr = info.fullName;
            cell.accessoryType = info.isSelected?  UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            [cell setCellImageView:[UIImage imageNamed:@"treeIcon_02"]];
        }
        [cell.title setText:[NSString stringWithFormat:@"%@", nameStr]];
    } else if (tableView == selectedTableView) {//已选择人员列表
        ztOANewDocInfo *info = [selectedDataSource objectAtIndex:indexPath.row];
        [cell setCellImageView:[UIImage imageNamed:@"treeIcon_02"]];
        cell.accessoryType = info.isSelected? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        [cell.title setText:[NSString stringWithFormat:@"%@", info.fullName]];
    }
    return cell;
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //组织机构列表
    if (tableView == myTableView) {
        ztOANewDocInfo *info = [allData objectAtIndex:indexPath.row];
        if (info.type == 2) {   //2为单位
            [self setLastTitleAndDwNameArr:info.shortName];
            level++;
            [myTableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height - bottom)];
            [self loadDataWithCompanyLsh:info.dwlsh andLoadType:1 andLevel:level];
        } else{ //个人
            if ([i_multiSelectFlag isEqualToString:@"2"]) { //多选
                cell.accessoryType = [self setDataSrouceAndArray:info]? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
                selectedDataSource = [NSMutableArray arrayWithArray:i_selectedArray];
                [selectedName setTitle:i_selectNameStr forState:UIControlStateNormal];
            } else{ //单选
                NSString *i_Zrrlsh;
                i_Zrrlsh = [NSString stringWithFormat:@"%@",info.dwlsh];
                NSString *xml = [NSString stringWithFormat:@"<zrobj zrrlsh=\"%@\" zrrlx=\"%@\">%@</zrobj>", i_Zrrlsh, i_Strcxlx, [self UnicodeToISO88591:[NSString stringWithFormat:@"%@",info.shortName]] ];
                NSDictionary *dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:xml,@"xml",info.shortName,@"content",nil];
                
                postNWithInfos(@"TREERESPONCHOOSE", nil ,dataDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } else if(tableView == ryzTableView){//人员组列表
        //点击人员组
        if ([[personGroupArray objectAtIndex:0] isKindOfClass:[ztOAPersonGroupInfo class]]) {
            ztOAPersonGroupInfo *info = [personGroupArray objectAtIndex:indexPath.row];
            [self loadPersonWithRyzBh:info.intryzbh];
            ryzTitle = info.strryzmc;
        } else{//点击人员组内人员
            ztOANewDocInfo *info = [personGroupArray objectAtIndex:indexPath.row];
            cell.accessoryType = [self setDataSrouceAndArray:info]? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            selectedDataSource = [NSMutableArray arrayWithArray:i_selectedArray];
            [selectedName setTitle:i_selectNameStr forState:UIControlStateNormal];
        }
    } else if (tableView == selectedTableView){
        ztOANewDocInfo *info = [selectedDataSource objectAtIndex:indexPath.row];
        cell.accessoryType = [self setDataSrouceAndArray:info]? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }
}

- (BOOL)setDataSrouceAndArray:(ztOANewDocInfo *)info{
    if (info.isSelected) {
        info.isSelected = !info.isSelected;
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:i_selectedArray];
        for (ztOANewDocInfo *tempInfo in tempArray) {
            if ([tempInfo isEqual:info]) {
                [i_selectedArray removeObject:info];
            }
        }
    } else{
        info.isSelected = !info.isSelected;
        [i_selectedArray addObject:info];
    }
    i_selectNameStr = [NSString stringWithFormat:@"  已选中：%d个：", i_selectedArray.count];
    for (ztOANewDocInfo *tempInfo in i_selectedArray) {
        i_selectNameStr = [i_selectNameStr stringByAppendingString:[NSString stringWithFormat:@"%@  ",tempInfo.shortName]];
    }
    return info.isSelected;
}

- (void)setLastTitleAndDwNameArr:(NSString *)dwName{
    NSDictionary *dwNameDict = [NSDictionary dictionaryWithObject:dwName forKey:[NSString stringWithFormat:@"level%d", level]];
    if (dwNameArr.count == 0) {
        [dwNameArr addObject:dwNameDict];
    } else{
        for (int i = 0; i < dwNameArr.count; i++) {
            NSDictionary *dict = [dwNameArr objectAtIndex:i];
            if ([[[dict allKeys] objectAtIndex:0] isEqualToString:[NSString stringWithFormat:@"level%d", level]]) {
                [dwNameArr replaceObjectAtIndex:i withObject:dwNameDict];
                break;
            } else{
                if (i == dwNameArr.count - 1) {
                    [dwNameArr addObject:dwNameDict];
                }
            }
        }
    }
    lastTitle = dwName;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
