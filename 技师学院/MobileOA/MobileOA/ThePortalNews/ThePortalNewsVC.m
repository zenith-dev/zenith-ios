//
//  ThePortalNewsVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/6.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ThePortalNewsVC.h"
#import "SUNSlideSwitchView.h"
#import "ThePortalList.h"
#import "TheRunPageScroll.h"
#import "ThePortalDetailVC.h"
#import "ChooseHotVC.h"
@interface ThePortalNewsVC ()<SUNSlideSwitchViewDelegate>
@property(nonatomic,strong)SUNSlideSwitchView *slideSwitchView;
@property(nonatomic,strong)NSMutableArray *tableList_arr;
@property(nonatomic,strong)NSArray *typeList;
@property(nonatomic,assign)NSInteger curuntnum;
@property(nonatomic,strong)TheRunPageScroll *therunpageScr;
@property(nonatomic,strong)NSMutableArray *picartAry;
@end

@implementation ThePortalNewsVC
@synthesize tableList_arr,typeList,curuntnum,slideSwitchView,therunpageScr,picartAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self newworkGet:@"getMainPageInfo.ashx" parameter:nil progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"datas"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dsdic in rep[@"datas"]) {
                    if ([dsdic[@"tablename"] isEqualToString:@"channel"]) {
                        typeList=dsdic[@"ds"];
                        tableList_arr =[[NSMutableArray alloc]init];
                        for (int i=0; i<typeList.count; i++) {
                            ThePortalList *hphy=[[ThePortalList alloc]initWithTitle:typeList[i][@"title"]];
                            hphy.title=typeList[i][@"title"];
                            hphy.navs=self.navigationController;
                            hphy.channelid=[NSString stringWithFormat:@"%@",typeList[i][@"channel_id"]];
                            hphy.category_id=[NSString stringWithFormat:@"%@",typeList[i][@"id"]];
                            [tableList_arr addObject:hphy];
                        }
                        ThePortalList *hphy=[[ThePortalList alloc]initWithTitle:@"热点新闻"];
                        hphy.title=@"热点新闻";
                        hphy.navs=self.navigationController;
                        [tableList_arr addObject:hphy];
                    }else if ([dsdic[@"tablename"] isEqualToString:@"picart"])
                    {
                        picartAry =[[NSMutableArray alloc]init];
                        if ([dsdic[@"ds"] isKindOfClass:[NSArray class]]) {
                            [picartAry addObjectsFromArray:dsdic[@"ds"]];
                            
                        }else if ([dsdic[@"ds"] isKindOfClass:[NSDictionary class]])
                        {
                            [picartAry addObject:dsdic[@"ds"]];
                        }
                    }
                }
                [self initview];
            }
        }
    }];
    // Do any additional setup after loading the view.
}
#pragma mark-------初始化---------
-(void)initview{
    slideSwitchView=[[SUNSlideSwitchView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    slideSwitchView.slideSwitchViewDelegate=self;
    slideSwitchView.tabItemNormalColor = UIColorFromRGB(0x868686);
    slideSwitchView.tabItemSelectedColor = UIColorFromRGB(0x35b8de);
    slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    [slideSwitchView buildUI];//创建srcolltop按钮
    [self.view addSubview:slideSwitchView];
    
    therunpageScr=[[TheRunPageScroll alloc]initWithFrame:CGRectMake(0, slideSwitchView.top+44, kScreenWidth, 150)];
    __unsafe_unretained __typeof(self) weakSelf = self;
    therunpageScr.callback=^(int pageIndex){
        NSDictionary *picartDic = weakSelf.picartAry [pageIndex];
        ThePortalDetailVC *theport=[[ThePortalDetailVC alloc]initWithTitle:@"新闻详情"];
        theport.news_id=[NSString stringWithFormat:@"%@",picartDic[@"id"]];
        [weakSelf.navigationController pushViewController:theport animated:YES];
    };
    therunpageScr.key=@"img_url";
    therunpageScr.scrollImagearray=picartAry;
    [therunpageScr scrolladdimage:picartAry];
    [self.view addSubview:therunpageScr];
}
#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return self.tableList_arr.count;
}
- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    ThePortalList *vc = [self.tableList_arr objectAtIndex:number];
    return vc;
}
- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    curuntnum=number;
    ThePortalList *vc = [self.tableList_arr objectAtIndex:number];
    [vc getDatas:NO];
}
//当新闻列表滑动到最左边，显示左侧菜单
- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
    
}
-(void)gotoChooseType
{
    ChooseHotVC *chooseHotVc=[[ChooseHotVC alloc]initWithTitle:@"选择热点专题"];
    chooseHotVc.callback=^(NSDictionary*itemDic){
        ThePortalList *thePortvc = [self.tableList_arr objectAtIndex:self.tableList_arr.count-1];
        thePortvc.channelid=itemDic[@"channel_id"];
        thePortvc.category_id=itemDic[@"id"];
        [thePortvc getDatas:YES];
    };
    [self.navigationController pushViewController:chooseHotVc animated:YES];
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
