//
//  ztOAPersonalCenterViewController.m
//  OAMobileIOS
//
//  Created by 大熊 on 16-10-28.
//  Copyright (c) 2016年 daxiong. All rights reserved.
//

#import "ztOAPersonalCenterViewController.h"

@interface ztOAPersonalCenterViewController ()
{
    NSString        *sexIsMan;//男，女,未知
    NSString        *unitnameStr;//单位
    NSString        *unitname_childStr;//处室
    NSString        *mobilePhoneStr;//移动电话
    NSString        *bgPhoneStr;//办公电话
    
    NSString *i_DocNum;
    NSString *i_ggNum;
    NSString *i_EmailNum;

}
@property(nonatomic,strong)UIImageView  *headImageBGView;
@property(nonatomic,strong)UIButton     *persnalHeadImageView;
@property(nonatomic,strong)UILabel      *persnalNameLable;
@property(nonatomic,strong)UIImageView  *persnalSexImage;
@property(nonatomic,strong)UITableView  *personalView;

@property(nonatomic,strong)CXAlertView                  *cxAlert;
@property(nonatomic,strong)UIView                       *cxAlertContent;
@end

@implementation ztOAPersonalCenterViewController
@synthesize headImageBGView,persnalHeadImageView,persnalNameLable,persnalSexImage,personalView;
@synthesize cxAlert,cxAlertContent;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    if ([self isLogin]) {
        [self upNumdata];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    sexIsMan = @"未知";
    unitnameStr = @"";
    unitname_childStr = @"";
    bgPhoneStr = @"";
    mobilePhoneStr = @"";
    self.headImageBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 120)];
    headImageBGView.backgroundColor = [UIColor clearColor];
    headImageBGView.userInteractionEnabled = YES;
    headImageBGView.image = [UIImage imageNamed:@"headView_titleBar_Img.jpg"];
    [self.view addSubview:headImageBGView];
    
    self.persnalNameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20-14, 20)];
    NSString *usernamestr=[NSString stringWithFormat:@"%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    self.persnalNameLable.text = usernamestr;
    persnalNameLable.backgroundColor = [UIColor clearColor];
    persnalNameLable.font = [UIFont systemFontOfSize:15.0f];
    persnalNameLable.textAlignment = NSTextAlignmentRight;
    persnalNameLable.textColor = [UIColor blackColor];
    persnalNameLable.bottom=headImageBGView.height-25;
    [headImageBGView addSubview:persnalNameLable];
    
    self.persnalSexImage = [[UIImageView alloc] initWithFrame:CGRectMake(XW(persnalNameLable)+5, persnalNameLable.top+3, 14, 14)];
    [persnalSexImage setImage:nil] ;
    persnalSexImage.backgroundColor = [UIColor clearColor];
    [headImageBGView addSubview:persnalSexImage];

    self.personalView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headImageBGView.bottom,self.view.width, self.view.height-self.headImageBGView.bottom) style:UITableViewStylePlain];
    self.personalView.backgroundColor = [UIColor clearColor];
    self.personalView.delegate = self;
    self.personalView.dataSource = self;
    self.personalView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.personalView];
    [self loadUserInfoData];
}
- (void)loadUserInfoData
{
    NSString *searchStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strryxmtj>%@</strryxmtj><stryhmtj>%@</stryhmtj></root>",[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",[ztOAGlobalVariable sharedInstance].username]],[self UnicodeToISO88591:[NSString stringWithFormat:@"%@",[ztOAGlobalVariable sharedInstance].userzh] ]];
    NSLog(@"%@",searchStr);
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",[self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].username],@"strryxm",[self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].userzh],@"stryhm",searchStr,@"queryTermXML",nil];
    [self showWaitView];
    [ztOAService userInfo:dic Success:^(id result){
        [self closeWaitView];
        NSDictionary *dataDic = [result objectFromJSONData];
        NSLog(@"%@",[dataDic JSONString]);
        if ([[dataDic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dataDic objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
            sexIsMan = [NSString stringWithFormat:@"%@",[[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"strxb"] isEqual:[NSNull null]]?@"":[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"strxb"]];
            if ([sexIsMan isEqualToString:@"男"]) {
                persnalSexImage.image = [UIImage imageNamed:@"icon_sex_male"];
            }
            else if ([sexIsMan isEqualToString:@"女"]) {
                persnalSexImage.image = [UIImage imageNamed:@"icon_sex_female"];
            }
            else
            {
                persnalSexImage.image =nil;
            }

            //电话
            bgPhoneStr = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"strbgdh"] ==NULL ?@"":[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"strbgdh"]];
            //电话
            mobilePhoneStr = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"stryddh"] ==NULL?@"":[[[dataDic objectForKey:@"root"] objectForKey:@"userinfo"] objectForKey:@"stryddh"]];
            //单位
           unitnameStr = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname"] ==NULL?@"":[[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname"]];
            //处室
            unitname_childStr = [NSString stringWithFormat:@"%@",[[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname_child"] ==NULL?@"":[[[dataDic objectForKey:@"root"] objectForKey:@"unitinfo"] objectForKey:@"unitname_child"]];
            [personalView reloadData];
        }
        
    } Failed:^(NSError *error){
        [self closeWaitView];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载超时！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    headView.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }
    else
        return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"persnalCenter";
    if (indexPath.section==0) {
        ztOAPersnalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[ztOAPersnalCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
            [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
            [cell setSelectedBackgroundView:selectView];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        if (indexPath.row==0) {
            cell.nameLabel.text = @"单位";
            cell.detailInfo.text = unitnameStr;
            cell.iconImg.image = [UIImage imageNamed:@"icon_department"];
        }
        else if (indexPath.row==1){
            cell.nameLabel.text = @"处室";
            cell.detailInfo.text = unitname_childStr;
            cell.iconImg.image = [UIImage imageNamed:@"icon_depart_c1"];
        }
        else if (indexPath.row==2){
            cell.nameLabel.text = @"办公电话";
            cell.detailInfo.text = bgPhoneStr;
            cell.iconImg.image = [UIImage imageNamed:@"icon_telephone"];
        }
        else if (indexPath.row==3){
            cell.nameLabel.text = @"移动电话";
            cell.detailInfo.text = mobilePhoneStr;
            cell.iconImg.image = [UIImage imageNamed:@"icon_mobile"];
        }
        
        return cell;
    }
    else if (indexPath.section==1)
    {
        static NSString *cellId = @"baseView";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
        iconView.contentMode=UIViewContentModeScaleAspectFit;
        iconView.clipsToBounds=YES;
        [iconView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:iconView];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right*1.2, 15, self.view.width-50*4, 20)];
        [nameLab setBackgroundColor:[UIColor clearColor]];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:nameLab];
        
        UILabel *numlb=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, 24, 24)];
        ViewRadius(numlb, 12);
        numlb.textAlignment=NSTextAlignmentCenter;
        numlb.adjustsFontSizeToFitWidth=YES;
        numlb.font=Font(12);
        [numlb setBackgroundColor:[UIColor redColor]];
        numlb.textColor=[UIColor whiteColor];
        numlb.hidden=YES;
        numlb.right=kScreenWidth-35;
        [cell.contentView addSubview:numlb];
        if (indexPath.row==0)
        {
            [nameLab setText:@"待办公文"];
            iconView.image = [UIImage imageNamed:@"doc_redLogo"];
            if (i_DocNum.length!=0) {
                numlb.text=i_DocNum;
                numlb.hidden=NO;
            }
        }
        else if (indexPath.row==1)
        {
            [nameLab setText:@"内部邮件"];
            iconView.image = [UIImage imageNamed:@"email_yellowLogo"];
            if (i_EmailNum.length!=0) {
                numlb.text=i_EmailNum;
                numlb.hidden=NO;
            }
        }
        else if(indexPath.row==2)
        {
            [nameLab setText:@"通知公告"];
            iconView.image = [UIImage imageNamed:@"icon_tz"];
            if (i_ggNum.length!=0) {
                numlb.text=i_ggNum;
                numlb.hidden=NO;
            }
        }
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [cell addSubview:lineBreak];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else if (indexPath.section==2)
    {
        static NSString *cellId = @"baseView";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 30, 30)];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:iconView];
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right*1.2, 15, self.view.width-50*4, 20)];
        [nameLab setBackgroundColor:[UIColor clearColor]];
        [nameLab setTextAlignment:NSTextAlignmentLeft];
        [nameLab setTextColor:[UIColor blackColor]];
        [nameLab setFont:[UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:nameLab];
        
        if (indexPath.row==0)
        {
            [nameLab setText:@"我的收藏"];
            iconView.image = [UIImage imageNamed:@"st_icon_fav"];
        }
        else if (indexPath.row==1)
        {
            [nameLab setText:@"设置"];
            iconView.image = [UIImage imageNamed:@"st_icon_setting"];
        }
        UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, tableView.width, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [cell addSubview:lineBreak];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
        static NSString *cellId = @"outLoadin";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [[cell.contentView subviews] each:^(id sender) {
            [(UIView *)sender removeFromSuperview];
        }];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, cell.width, cell.height-10)];
        [lab setTextColor:[UIColor blackColor]];
        lab.text = @"退出登陆";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:14.0f];
        [cell addSubview:lab];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 4;
    }
    else if (section==1)
    {
        return 3;
    }
    else if (section==2)
    {
        return 2;
    }
    else   return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            NSString  *searchBarStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><chrgwbt>%@</chrgwbt><chrgwz>%@</chrgwz><intgwnh>%@</intgwnh><chrgwlb>%@</chrgwlb><chrztc>%@</chrztc><chrfwdwmc>%@</chrfwdwmc><chrlwdwmc>%@</chrlwdwmc><intmjbh>%@</intmjbh><inthjcdbh>%@</inthjcdbh><dtmdjsj>%@</dtmdjsj><chrsjxzbz>%@</chrsjxzbz></root>",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
            ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"1" withTitle:@"待办公文" queryTerm:searchBarStr];
            [self.navigationController pushViewController:listVC animated:YES];
        }else if (indexPath.row==1)
        {
            //邮件系统
            ztOAEmailListViewController *listVC = [[ztOAEmailListViewController alloc] initWithTitle:@"内部邮件"];
            [self.navigationController pushViewController:listVC animated:YES];
        }else if (indexPath.row==2)
        {
            ztOADetailInfoListViewController *listVC=[[ztOADetailInfoListViewController alloc] initWithType:@"2" withTitle:@"通知公告" queryTerm:@""];
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0)
        {
            //我的收藏
            ztOAPersonalCollectViewController *collectVC = [[ztOAPersonalCollectViewController alloc] initWithType:@"公文" withTitle:@"我的收藏"];
            [self.navigationController pushViewController:collectVC animated:YES];
        }
        else if(indexPath.row==1)
        {
            //设置
            ztOASettingViewController *listVC=[[ztOASettingViewController alloc] init];
            listVC.title=@"设 置";
            [self.navigationController pushViewController:listVC animated:YES];
        }
    }
}
-(void)upNumdata{
    //待办公文
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh", [ztOAGlobalVariable sharedInstance].intdwlsh_child,@"intcsdwlsh",nil];
    [ztOAService getOfficeDocNumber:dic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if ( ([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_DocNum=@"";
        }
        else
        {
            i_DocNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [personalView reloadData];
        }
    } Failed:^(NSError *error){
        i_DocNum=@"";
    }];
    //通知未读条数
    NSDictionary *ggDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",nil];
    [ztOAService getInformNumber:ggDic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if (([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_ggNum=@"";
        }
        else
        {
            i_ggNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [personalView reloadData];
        }
    } Failed:^(NSError *error){
        i_ggNum=@"";
    }];
    //邮件系统
    NSString *emailXml = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strtzbt></strtzbt><strryxm></strryxm><dtmdjsj1></dtmdjsj1><dtmdjsj2></dtmdjsj2><querytype>2</querytype></root>";
    NSDictionary *emailDic = [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",emailXml,@"queryTermXML",nil];
    [ztOAService getEmailNumber:emailDic Success:^(id result){
        NSDictionary *dicData = [result objectFromJSONData];
        if (([[dicData objectForKey:@"root"] objectForKey:@"result"] ==[NSNull null]) || ([[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]<0)) {
            i_EmailNum=@"";
        }
        else
        {
            i_EmailNum =[NSString stringWithFormat:@"%@",[[dicData objectForKey:@"root"] objectForKey:@"result"]];
            [personalView reloadData];
        }
    } Failed:^(NSError *error){
            i_EmailNum=@"";
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
