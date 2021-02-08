//
//  ZtOASummaryVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 17/3/8.
//  Copyright © 2017年 chenyang. All rights reserved.
//

#import "ZtOASummaryVC.h"
#import "ztOADetailInfoListViewController.h"
@interface ZtOASummaryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *summarylst;
@property (nonatomic,strong)UITableView *summarytb;
@end

@implementation ZtOASummaryVC
@synthesize summarytb,summarylst;
- (void)viewDidLoad {
    [super viewDidLoad];
    summarylst=@[@{@"name":@"董事会 会议决议",@"val":@"董事会会议决议"},@{@"name":@"党委会 会议纪要",@"val":@"党委会会议纪要"},@{@"name":@"经理办公会 会议纪要",@"val":@"经理办公会会议纪要"},@{@"name":@"其他 会议纪要",@"val":@"其他会议纪要"}];
    summarytb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    summarytb.delegate=self;
    summarytb.dataSource=self;
    [self.view addSubview:summarytb];
    // Do any additional setup after loading the view.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return summarylst.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"mytable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
    cell.textLabel.text=summarylst[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *dic = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strgwbt>%@</strgwbt><strgwz>%@</strgwz><intgwnh>%@</intgwnh><intgwqh>%@</intgwqh><chrgwlb>%@</chrgwlb><strlwdwmc>%@</strlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj1>%@</dtmdjsj1><dtmdjsj2>%@</dtmdjsj2><intzbflbh>%@</intzbflbh></root>",
                     @"",[self UnicodeToISO88591:summarylst[indexPath.row][@"val"]],
                     @"",
                     @"",
                     @"002",
                     @"",
                     @"",
                     @"",
                     @"" ,
                     @"",
                     @""];
    NSLog(@"searchdic==%@",dic);
    
//    NSString *dic = [NSString stringWithFormat:@"<?xml version=\"1.0\"  encoding=\"UTF-8\"?><root><strgwbt></strgwbt><strgwz>%@</strgwz><intgwqh></intgwqh><dtmdjsj1></dtmdjsj1><dtmdjsj2></dtmdjsj2><intzbflbh></intzbflbh><chrgwlb>002<chrgwlb><intgwlxbh>13</intgwlxbh><strlwdwmc></strlwdwmc><intmjbh></intmjbh><inthjcdbh></inthjcdbh></root>",summarylst[indexPath.row][@"val"]];
    NSLog(@"searchdic==%@",dic);
    ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"5" withTitle:@"发文列表" queryTerm:dic];
    NSMutableDictionary *searchDic=[[NSMutableDictionary alloc]initWithDictionary:@{@"strgwbt":@"",@"strgwz":summarylst[indexPath.row][@"val"],@"intgwqh":@"",@"dtmdjsj1":@"",@"dtmdjsj2":@"",@"intzbflbh":@"",@"chrgwlb":@"002",@"intgwlxbh":@"13",@"strlwdwmc":@"",@"intmjbh":@"",@"inthjcdbh":@""}];
    listVC.searchDic=searchDic;
    [self.navigationController pushViewController:listVC animated:YES];
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
