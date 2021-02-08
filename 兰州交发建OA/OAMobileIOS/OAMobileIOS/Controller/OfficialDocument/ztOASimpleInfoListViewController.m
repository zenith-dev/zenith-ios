//
//  ztOASimpleInfoListViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-12.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOASimpleInfoListViewController.h"

@interface ztOASimpleInfoListViewController ()
{
    NSArray         *infoArray;//列表数据
    NSString        *i_type;//1，处理意见；2，下步任务；3下步处理人;4所属刊物列表；5刊物年号
}
@property(nonatomic,strong)UITableView *tableList;//列表
@end

@implementation ztOASimpleInfoListViewController
@synthesize tableList;
-(id)initWithTitle:(NSString *)titleString listArray:(NSArray *)listArray whichType:(NSString *)whitchType
{
    self = [super init];
    if (self) {
        infoArray       = [NSArray arrayWithArray:listArray];
        i_type          = whitchType;
        self.title      = titleString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    tableList.delegate = self;
    tableList.dataSource = self;
    tableList.backgroundColor = [UIColor whiteColor];
    tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableList];
}
#pragma table delegate&datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([i_type isEqualToString:@"1"]) {
        postNWithInfos(@"OPINIONSELECT", nil, [infoArray objectAtIndex:indexPath.row]);
    }
    else if([i_type isEqualToString:@"2"])
    {
        postNWithInfos(@"NEXTSTEPWAY", nil, [infoArray objectAtIndex:indexPath.row]);
    }
    else if([i_type isEqualToString:@"3"])
    {
        postNWithInfos(@"RESPONSIBLEMAN", nil, [infoArray objectAtIndex:indexPath.row]);
    }
    else if ([i_type isEqualToString:@"4"])
    {
        NSDictionary *dic;
        if (indexPath.row==0) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"row",nil,@"dic", nil];
        }
        else{
           dic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"row",[infoArray objectAtIndex:(indexPath.row-1)],@"dic", nil];
        }
        postNWithInfos(@"PUBLICSEARCHDONE", nil, dic);
    }
    else if ([i_type isEqualToString:@"5"])
    {
        NSDictionary *dic;
        if (indexPath.row==0) {
            dic= [NSDictionary dictionaryWithObjectsAndKeys:@"所有",@"name", nil];
        }
        else{
            dic= [NSDictionary dictionaryWithObjectsAndKeys:[infoArray objectAtIndex:(indexPath.row-1)],@"name", nil];
        }
        postNWithInfos(@"YEARSEARCHDONE", nil, dic);
        
    }
    else if ([i_type isEqualToString:@"6"])
    {
        NSDictionary *dic;
        if (indexPath.row==0) {
            dic= [NSDictionary dictionaryWithObjectsAndKeys:@"所有",@"name", nil];
        }
        else{
            dic= [NSDictionary dictionaryWithObjectsAndKeys:[infoArray objectAtIndex:(indexPath.row-1)],@"name", nil];
        }
        postNWithInfos(@"TYPESEARCHDONE", nil, dic);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([i_type isEqualToString:@"4"]||[i_type isEqualToString:@"5"]||[i_type isEqualToString:@"6"]) {
        return infoArray.count+1;
    }
    else
        return infoArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"listCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [[cell.contentView subviews] each:^(id sender){
        [(UIView *)sender removeFromSuperview];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, tableList.width-40, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    //type:1,下步任务；2，下步处理人；3:处理意见；
    if ([i_type isEqualToString:@"1"])
    {
        label.text = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:indexPath.row] ];
    }
    else if ([i_type isEqualToString:@"2"]) {
        label.text = [NSString stringWithFormat:@"%@",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"stryjmc"]];
    }
    else if ([i_type isEqualToString:@"3"])
    {
        label.text = [NSString stringWithFormat:@"%@",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"content"]];
    }
    else if ([i_type isEqualToString:@"4"])
    {
        if (indexPath.row==0) {
            label.text = @"全部刊物";
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%@",[[infoArray objectAtIndex:(indexPath.row-1)] objectForKey:@"strkwmc"]];
        }
    }
    else if ([i_type isEqualToString:@"5"])
    {
        if (indexPath.row==0) {
            label.text = @"全部年号";
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:(indexPath.row-1)]];
        }
    }
    else if ([i_type isEqualToString:@"6"])
    {
        if (indexPath.row==0) {
            label.text = @"全部类型";
        }
        else
        {
            label.text = [NSString stringWithFormat:@"%@",[infoArray objectAtIndex:(indexPath.row-1)]];
        }
    }
    
    label.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:label];
    
    UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, tableList.width, 1)];
    lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    [cell addSubview:lineBreak];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
