//
//  ztOAPublicatiinDetailInfoViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-5.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAPublicatiinDetailInfoViewController.h"

@interface ztOAPublicatiinDetailInfoViewController ()
{
    NSMutableArray *headStrArray;
    NSMutableArray *infoStrArray;
    
    NSDictionary   *publicDataDic;
}
@property(nonatomic,strong)UIButton    *loadDocBtn;
@property(nonatomic,strong)UITableView *tableDetailInfo;
@end

@implementation ztOAPublicatiinDetailInfoViewController
@synthesize tableDetailInfo,loadDocBtn;
- (id)initWithData:(NSDictionary *)dicData
{
    self = [super init];
    if (self) {
        publicDataDic = dicData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //下载
    self.loadDocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadDocBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_On"] forState:UIControlStateNormal];
    [loadDocBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_Off"] forState:UIControlStateHighlighted];
    [loadDocBtn setFrame:CGRectMake(self.view.width-60-5, self.leftBtn.origin.y, 120 / 2.0 , 60 / 2.0)];
    [loadDocBtn setHidden:NO];
    [loadDocBtn setTitle:@"下载" forState:UIControlStateNormal];
    [loadDocBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [loadDocBtn addTarget:self action:@selector(loadDoc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadDocBtn];
    
    headStrArray = [[NSMutableArray alloc] initWithObjects:@"刊物目录名称:",@"刊物年号:",@"刊物期号:",@"发布日期:",nil];
    infoStrArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",[publicDataDic objectForKey:@"strkwbt"]?:@""],
                    [NSString stringWithFormat:@"%@",[publicDataDic objectForKey:@"intkwnh"]?:@""],
                    [NSString stringWithFormat:@"%@",[publicDataDic objectForKey:@"intkwqh"]?:@""],
                    [NSString stringWithFormat:@"%@",[publicDataDic objectForKey:@"dtmfbrq"]?:@""],nil];
    NSLog(@"%@",infoStrArray);
    self.tableDetailInfo = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64) style:UITableViewStylePlain];
    self.tableDetailInfo.separatorStyle = UITableViewCellSelectionStyleNone;
    tableDetailInfo.delegate = self;
    tableDetailInfo.dataSource = self;
    [self.view addSubview:tableDetailInfo];
    
}
#pragma mark-获取刊物详情(下载)
- (void)loadDoc
{
    NSDictionary *loadDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[NSString stringWithFormat:@"%@",[publicDataDic objectForKey:@"intkwlsh"]?:@""],@"intkwlsh",nil];
    [ztOAService loadPublication:loadDic Success:^(id result){
        NSDictionary *resultDic = [result objectFromJSONData];
        
        NSString *strMsg=@"空";
        if ([[[resultDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            //strMsg = [strMsg stringByAppendingString:[NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"root"] objectForKey:@"fjlj"]]];
            strMsg = [NSString stringWithFormat:@"%@",[[[resultDic objectForKey:@"root"] objectForKey:@"fj"]objectForKey:@"wjm"] ];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } Failed:^(NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"获取数据失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark -tableview delegate-

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"listInfoCell";
    ztOADetailContactInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[ztOADetailContactInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.name.text= [headStrArray objectAtIndex:indexPath.row];
    cell.detailInfo.text = [infoStrArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return headStrArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
