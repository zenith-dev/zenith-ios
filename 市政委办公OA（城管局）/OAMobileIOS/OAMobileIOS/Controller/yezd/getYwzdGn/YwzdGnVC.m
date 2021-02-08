//
//  YwzdGnVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "YwzdGnVC.h"
#import "YwzdGnCell.h"
#import "YwzGnWdVC.h"
@interface YwzdGnVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *gnary;
@property (nonatomic,strong)UITableView *ywzdGnTable;
@end
@implementation YwzdGnVC
@synthesize gnary,ywzdGnTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    gnary=[[NSArray alloc]init];
    [self.view setBackgroundColor:UIColorFromRGB(0xb1b1b1)];
    ywzdGnTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) style:UITableViewStyleGrouped];
    ywzdGnTable.delegate=self;
    ywzdGnTable.dataSource=self;
    [self.view addSubview:ywzdGnTable];
    [self getYwzdGn];
    // Do any additional setup after loading the view.
}
#pragma mark-------------职能------------------
-(void)getYwzdGn{
    NSDictionary *dataDic=@{@"strccbm":[NSString stringWithFormat:@"00%@",self.strccbm]};
    [self showWaitView];
    [ztOAService getYwzdGn:dataDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
        {
            gnary =[dic objectForKey:@"root"][@"gn"];
            [ywzdGnTable reloadData];
        }
    } Failed:^(NSError *error) {
        
    }];

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return gnary.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
#pragma mark -tableview delegate -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"YwzdGnCell";
    YwzdGnCell *cell = (YwzdGnCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[YwzdGnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.csmclb.text=gnary[indexPath.row][@"strgnmc"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowdic=[gnary objectAtIndex:indexPath.row];
    YwzGnWdVC *yezgnwd=[[YwzGnWdVC alloc]init];
    yezgnwd.title=rowdic[@"strgnmc"];
    yezgnwd.strccbm=[NSString stringWithFormat:@"00%@",rowdic[@"strccbm"]];
    [self.navigationController pushViewController:yezgnwd animated:YES];
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
