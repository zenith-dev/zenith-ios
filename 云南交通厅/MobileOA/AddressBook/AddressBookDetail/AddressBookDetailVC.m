//
//  AddressBookDetailVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/1.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "AddressBookDetailVC.h"
#import <MessageUI/MessageUI.h>
@interface AddressBookDetailVC ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong)UITableView *addBookTb;
@property (nonatomic,strong)NSArray *addBookAry;
@end

@implementation AddressBookDetailVC
@synthesize addBookTb,addBookAry,adduserInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    addBookAry=@[@"个人信息",@"移动电话",@"办公室电话"];
    addBookTb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    addBookTb.delegate=self;
    addBookTb.dataSource=self;
    [self.view addSubview:addBookTb];
    // Do any additional setup after loading the view.
}
#pragma mark--------------tableViewdelegate----------------------
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addBookAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = addBookAry[indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if ([addBookAry[indexPath.row] isEqualToString:@"个人信息"]) {
            UIImageView *headImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 60, 60)];
            [headImg setImage:PNGIMAGE(@"contact_default_avatar")];
            [cell.contentView addSubview:headImg];
            UILabel *namelb=[[UILabel alloc]initWithFrame:CGRectMake(headImg.right+10, headImg.top, kScreenWidth-(headImg.right+40), 18)];
            namelb.font=Font(16);
            namelb.text=adduserInfo.strryxm;
            [cell.contentView addSubview:namelb];
            
            UILabel *subnamelb=[[UILabel alloc]initWithFrame:CGRectMake(namelb.left, namelb.bottom, namelb.width, 18)];
            subnamelb.numberOfLines=2;
            subnamelb.font=Font(14);
            subnamelb.textColor=[UIColor grayColor];
            subnamelb.text=[NSString stringWithFormat:@"%@[%@],[%@]",adduserInfo.strdw,adduserInfo.strzwmc,adduserInfo.strbgdz];
            CGSize suszie=[subnamelb.text boundingRectWithSize:CGSizeMake(subnamelb.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName:Font(14)} context:nil].size;
            subnamelb.height=suszie.height;
            subnamelb.bottom=headImg.bottom-5;
            [cell.contentView addSubview:subnamelb];
            cell.contentView.height=headImg.bottom+10;
        }else if ([addBookAry[indexPath.row] isEqualToString:@"移动电话"])
        {
            UILabel *yddhlb=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth-90, 21)];
            yddhlb.font=Font(15);
            yddhlb.text=[NSString stringWithFormat:@"%@",adduserInfo.stryddh?adduserInfo.stryddh:@""];
            [cell.contentView addSubview:yddhlb];
            UILabel *marklb=[[UILabel alloc]initWithFrame:CGRectMake(yddhlb.left, yddhlb.bottom+5, yddhlb.width, yddhlb.height)];
            marklb.font=Font(13);
            marklb.textColor=[UIColor grayColor];
            marklb.text=@"移动电话";
            [cell.contentView addSubview:marklb];
            cell.contentView.height=marklb.bottom+15;
            
            
            UIButton *msgbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [msgbtn setImage:PNGIMAGE(@"msg_icon") forState:UIControlStateNormal];
            msgbtn.right=kScreenWidth-50-15;
            msgbtn.centerY=cell.contentView.height/2.0;
            [msgbtn addTarget:self action:@selector(msgSEL) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:msgbtn];
            
            UIButton *callbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [callbtn setImage:PNGIMAGE(@"call_icon") forState:UIControlStateNormal];
            callbtn.right=kScreenWidth-15;
            callbtn.centerY=cell.contentView.height/2.0;
            [callbtn addTarget:self action:@selector(callSEL) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:callbtn];
        }else if ([addBookAry[indexPath.row] isEqualToString:@"办公室电话"])
        {
            
            UILabel *yddhlb=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenWidth-90, 21)];
            yddhlb.font=Font(15);
            yddhlb.text=[NSString stringWithFormat:@"%@",adduserInfo.strbgdh?adduserInfo.strbgdh:@""];
            [cell.contentView addSubview:yddhlb];
            UILabel *marklb=[[UILabel alloc]initWithFrame:CGRectMake(yddhlb.left, yddhlb.bottom+5, yddhlb.width, yddhlb.height)];
            marklb.font=Font(13);
            marklb.textColor=[UIColor grayColor];
            marklb.text=@"办公室电话";
            [cell.contentView addSubview:marklb];
            cell.contentView.height=marklb.bottom+15;
            UIButton *callbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [callbtn setImage:PNGIMAGE(@"call_icon") forState:UIControlStateNormal];
            callbtn.right=kScreenWidth-15;
            callbtn.centerY=cell.contentView.height/2.0;
            [callbtn addTarget:self action:@selector(call1SEL) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:callbtn];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark------------发送信息--------
-(void)msgSEL{
    if (adduserInfo.stryddh.length!=0) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = [NSArray arrayWithObject:adduserInfo.stryddh];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }else
    {
        [self showMessage:@"暂无移动电话"];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:^{
        
    }];//关键的一句   不能为YES
    switch ( result ) {
        case MessageComposeResultCancelled:
            //[self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
           [self showMessage:@"发送信息失败"];
            break;
        case MessageComposeResultSent:
            [self showMessage:@"发送信息成功"];
            break;
        default:
            break;
    }
}

#pragma mark------------拨打移动电话------
-(void)callSEL{
    if (adduserInfo.stryddh.length!=0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",adduserInfo.stryddh]]];
    }else
    {
        [self showMessage:@"暂无移动电话"];
    }
}
#pragma mark-----------拨打办公室电话----
-(void)call1SEL{
    if (adduserInfo.strbgdh.length!=0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",adduserInfo.strbgdh]]];
    }else
    {
        [self showMessage:@"暂无办公电话电话"];
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
