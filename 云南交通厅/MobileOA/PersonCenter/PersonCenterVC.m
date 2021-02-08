//
//  PersonCenterVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/14.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "PersonCenterVC.h"
#import "NSData+Base64.h"
#import "DocmentTodoListVC.h"
#import "NoticeGGVC.h"
#import "ztOASettingViewController.h"
#import "RePassWordVC.h"
#import "MyCollectVC.h"
#import "PopView.h"
@interface PersonCenterVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *_imagePickerControl;
    NSString *i_DocNum;
    NSString *i_ggNum;
    NSString *i_tzNum;//通知数量
}
@property (strong, nonatomic) UIActionSheet *photoAction;
@property (strong, nonatomic) UIAlertView *powerAlert;
@property (nonatomic,strong)UIImageView *userHeadImg;//用户头像
@property (nonatomic,strong)UILabel *userNamelb;
@property (nonatomic,strong)UIImageView *sexImg;
@property (nonatomic,strong)UITableView *personCentertb;
@property (nonatomic,strong)NSArray *personCenterlst;
@property (nonatomic,strong)NSDictionary *userInfoDic;
@property (nonatomic,strong)NSDictionary *unitInfoDic;
@property (nonatomic,strong)UIImage *headerImg;
@property (nonatomic,strong)NSArray *dgcslst;
@property (nonatomic,assign)NSInteger selectrow1;
@end

@implementation PersonCenterVC
@synthesize personCentertb,personCenterlst,userHeadImg,userNamelb,sexImg,userInfoDic,unitInfoDic,dgcslst,selectrow1;
#pragma mark------------Getter-----------
- (UIActionSheet *)photoAction
{
    if (!_photoAction) {
        _photoAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择", @"拍照", nil];
        _photoAction.delegate = self;
    }
    return _photoAction;
}
- (UIAlertView *)powerAlert
{
    if (!_powerAlert) {
        _powerAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到设置->隐私->把相机权限打开!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    }
    return _powerAlert;
}
- (void)initImagePicker
{
    if (!_imagePickerControl) {
        _imagePickerControl = [[UIImagePickerController alloc] init];
        _imagePickerControl.delegate = self;
        _imagePickerControl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _imagePickerControl.allowsEditing = NO;  //是否可编辑
        _imagePickerControl.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dgcslst=[[NSArray alloc]init];
    userInfoDic=[[NSDictionary alloc]init];
    unitInfoDic =[[NSDictionary alloc]init];
    i_DocNum=@"";
    NSArray *oneary=@[@"单位",@"处室",@"办公电话",@"移动电话"];
    NSArray *twoary=@[@"待办公文",@"通知公告",@"我的收藏"];
    NSArray *threeary=@[@"修改密码",@"设置"];
    [self.view setBackgroundColor:RGBCOLOR(234, 234, 234)];
    personCenterlst =@[oneary,twoary,threeary];
    UIImageView *bgImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, ScaleBI(120))];
    bgImg.userInteractionEnabled=YES;
    [bgImg setImage:PNGIMAGE(@"headView_titleBar_Img")];
    [self.view addSubview:bgImg];
    
    userHeadImg =[[UIImageView alloc]initWithFrame:CGRectMake(ScaleBI(20), 0, ScaleBI(80), ScaleBI(80))];
    [userHeadImg setImage:PNGIMAGE(@"headView_titleBar_userImg_normal")];
    ViewRadius(userHeadImg, userHeadImg.height/2.0);
    if (SingObj.userInfo.userhaderImg!=nil) {
        [userHeadImg setImage:SingObj.userInfo.userhaderImg];
    }
    [bgImg addSubview:userHeadImg];
    userHeadImg.userInteractionEnabled=YES;
    [userHeadImg bk_whenTapped:^{
        [self.photoAction showInView:self.view];
    }];
    userHeadImg.clipsToBounds=YES;
    userHeadImg.contentMode=UIViewContentModeScaleAspectFill;
    userHeadImg.centerY=bgImg.height/2.0;
    NSString *usernamestr=[NSString stringWithFormat:@"%@",SingObj.userInfo.username?:@""];
    CGSize namessize=[usernamestr sizeWithAttributes:@{NSFontAttributeName:Font(15)}];
    
    userNamelb =[[UILabel alloc]initWithFrame:CGRectMake(userHeadImg.right+10, 0, namessize.width, 20)];
    userNamelb.font=Font(15);
    userNamelb.text=usernamestr;
    [bgImg addSubview:userNamelb];
    userNamelb.centerY=userHeadImg.centerY;
    
    
    sexImg =[[UIImageView alloc]initWithFrame:CGRectMake(userNamelb.right+5, 0, 14, 14)];
    [bgImg addSubview:sexImg];
    sexImg.centerY=userNamelb.centerY;
    
    personCentertb=[[UITableView alloc]initWithFrame:CGRectMake(0, bgImg.bottom, kScreenWidth, kScreenHeight-bgImg.bottom) style:UITableViewStyleGrouped];
    personCentertb.delegate=self;
    personCentertb.dataSource=self;
    [self.view addSubview:personCentertb];
    [self loadUserInfoData];
    [self dbgwnum];
    [self getTznum];
    // Do any additional setup after loading the view.
}
#pragma mark---------获取用户信息------------
-(void)loadUserInfoData{
    NSString *searchStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strryxmtj>%@</strryxmtj><stryhmtj>%@</stryhmtj></root>",[NSString stringWithFormat:@"%@",SingObj.userInfo.username],[NSString stringWithFormat:@"%@",SingObj.userInfo.userzh]];
    NSDictionary *dic=@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"strryxm":SingObj.userInfo.username,@"stryhm":SingObj.userInfo.userzh,@"queryTermXML":searchStr};
    [self networkall:@"usercenter" requestMethod:@"getRyxx" requestHasParams:@"true" parameter:dic progresHudText:@"加载中..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"root"][@"result"] intValue]==0) {
                userInfoDic =[[rep objectForKey:@"root"] objectForKey:@"userinfo"];
                if ([[[rep objectForKey:@"root"] objectForKey:@"unitinfo"] isKindOfClass:[NSArray class]]) {
                     dgcslst=[[rep objectForKey:@"root"] objectForKey:@"unitinfo"];
                     unitInfoDic=[[rep objectForKey:@"root"] objectForKey:@"unitinfo"][0];
                    if (dgcslst.count>1) {
                        NSArray *oneary=@[@"单位",@"处室",@"办公电话",@"移动电话"];
                        NSArray *twoary=@[@"待办公文",@"通知公告",@"我的收藏"];
                        NSArray *threeary=@[@"修改密码",@"切换处室",@"设置"];
                        personCenterlst =@[oneary,twoary,threeary];
                    }else
                    {
                        NSArray *oneary=@[@"单位",@"处室",@"办公电话",@"移动电话"];
                        NSArray *twoary=@[@"待办公文",@"通知公告",@"我的收藏"];
                        NSArray *threeary=@[@"修改密码",@"设置"];
                        personCenterlst =@[oneary,twoary,threeary];
                    }
                }else
                {
                    unitInfoDic=[[rep objectForKey:@"root"] objectForKey:@"unitinfo"];
                    NSArray *oneary=@[@"单位",@"处室",@"办公电话",@"移动电话"];
                    NSArray *twoary=@[@"待办公文",@"通知公告",@"我的收藏"];
                    NSArray *threeary=@[@"修改密码",@"设置"];
                    
                    personCenterlst =@[oneary,twoary,threeary];
                }
                NSString *sexIsMan=userInfoDic[@"strxb"];
                if ([sexIsMan isEqualToString:@"男"]) {
                    sexImg.image = [UIImage imageNamed:@"icon_sex_male"];
                }
                else if ([sexIsMan isEqualToString:@"女"]) {
                    sexImg.image = [UIImage imageNamed:@"icon_sex_female"];
                }
                [personCentertb reloadData];
            }
        }
    }];
}
#pragma mark-tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return personCenterlst.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.01;
    }
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [personCenterlst[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=personCenterlst[indexPath.section][indexPath.row];
    static NSString *cellId = @"id";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [[cell.contentView subviews] bk_each:^(id sender){
        [(UIView *)sender removeFromSuperview];
    }];
    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *lgimg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    lgimg.contentMode=UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:lgimg];
    
    UILabel *sublb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-160, 20)];
    sublb.font=Font(15);
    sublb.textAlignment=NSTextAlignmentRight;
    sublb.textColor=[UIColor blueColor];
    [cell.contentView addSubview:sublb];
    
    
    UILabel *numslb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    numslb.font=Font(13);
    numslb.textAlignment=NSTextAlignmentCenter;
    numslb.adjustsFontSizeToFitWidth=YES;
    numslb.textColor=[UIColor whiteColor];
    numslb.backgroundColor=[UIColor redColor];
    ViewRadius(numslb, numslb.height/2.0);
    numslb.hidden=YES;
    [cell.contentView addSubview:numslb];
    
    if ([str isEqualToString:@"单位"]) {
        sublb.text=unitInfoDic[@"unitname"]?:@"";
        [lgimg setImage:PNGIMAGE(@"icon_department")];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else if ([str isEqualToString:@"处室"])
    {
        sublb.text=SingObj.unitInfo.unitname_child;
        [lgimg setImage:PNGIMAGE(@"icon_depart_c")];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else if ([str isEqualToString:@"办公电话"])
    {
        sublb.text=[NSString stringWithFormat:@"%@", userInfoDic[@"strbgdh"]?:@""];
        sublb.userInteractionEnabled=YES;
        [sublb bk_whenTapped:^{
            if (sublb.text.length!=0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sublb.text]]];
            }else
            {
                [self showMessage:@"暂无办公电话"];
            }
            
        }];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [lgimg setImage:PNGIMAGE(@"icon_telephone")];
    }
    else if ([str isEqualToString:@"移动电话"])
    {
        sublb.text=[NSString stringWithFormat:@"%@", userInfoDic[@"stryddh"]?:@""];
        sublb.userInteractionEnabled=YES;
        [sublb bk_whenTapped:^{
            if (sublb.text.length!=0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sublb.text]]];
            }else
            {
                [self showMessage:@"暂无移动电话"];
            }
        }];
        [lgimg setImage:PNGIMAGE(@"icon_mobile")];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    else if ([str isEqualToString:@"待办公文"])
    {
        if (i_DocNum.length>0) {
            numslb.hidden=NO;
            numslb.text=i_DocNum;
        }
        [lgimg setImage:PNGIMAGE(@"doc_redLogo")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([str isEqualToString:@"通知公告"])
    {
        if (i_tzNum.length>0) {
            numslb.hidden=NO;
            numslb.text=i_tzNum;
        }
        [lgimg setImage:PNGIMAGE(@"icon_tz")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([str isEqualToString:@"我的收藏"])
    {
        [lgimg setImage:PNGIMAGE(@"st_icon_fav")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([str isEqualToString:@"修改密码"])
    {
        [lgimg setImage:PNGIMAGE(@"st_icon_pwd")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([str isEqualToString:@"切换处室"])
    {
        [lgimg setImage:PNGIMAGE(@"st_change_dw")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if ([str isEqualToString:@"设置"])
    {
        [lgimg setImage:PNGIMAGE(@"st_icon_setting")];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(lgimg.right+8, 0, 100, 20)];
    nameLable.font = [UIFont systemFontOfSize:15.0f];
    nameLable.text = str;
    [cell.contentView addSubview:nameLable];
    nameLable.centerY=lgimg.centerY;
    numslb.centerY=sublb.centerY=lgimg.centerY;
    sublb.right=kScreenWidth-15;
    numslb.right=kScreenWidth-40;
    
    cell.contentView.height=lgimg.bottom+10;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str=personCenterlst[indexPath.section][indexPath.row];
    if ([str isEqualToString:@"待办公文"]) {
        DocmentTodoListVC *docmentTodo=[[DocmentTodoListVC alloc]initWithTitle:str];
        docmentTodo.type=@"016";
        docmentTodo.callback=^(BOOL isSu){
            if (isSu==YES) {
                [self dbgwnum];
                if (self.callbackGW) {
                    self.callbackGW(YES);
                }
            }
        };
        [self.navigationController pushViewController:docmentTodo animated:YES];
    }
    else if ([str isEqualToString:@"通知公告"])
    {
        NoticeGGVC *noticevc=[[NoticeGGVC alloc]initWithTitle:@"通知"];
        noticevc.type=2;
        noticevc.callback=^(BOOL isSu){
            [self getGgNum];
            if (self.callbackGG) {
                self.callbackGG(YES);
            }
        };
        [self.navigationController pushViewController:noticevc animated:YES];
    }
    else if ([str isEqualToString:@"设置"])
    {
        ztOASettingViewController *ztoaset=[[ztOASettingViewController alloc]initWithTitle:@"设置"];
        [self.navigationController pushViewController:ztoaset animated:YES];
    }
    else if ([str isEqualToString:@"修改密码"])
    {
        RePassWordVC *repass=[[RePassWordVC alloc]initWithTitle:@"修改密码"];
        [self.navigationController pushViewController:repass animated:YES];
    }
    else if([str isEqualToString:@"切换处室"])
    {
        PopView * popview=[[PopView alloc]initWithFrame:[UIScreen mainScreen].bounds title:@"请选择切换处室"];
        popview.sourceary=dgcslst;
        popview.key=@"unitname_child";
        popview.selectRowIndex=selectrow1;
        popview.callback=^(int selectrow,NSString *key){
            selectrow1=selectrow;
             unitInfoDic=dgcslst[selectrow];
             SingObj.unitInfo=[Unitinfo mj_objectWithKeyValues:unitInfoDic];
            [personCentertb reloadData];
        };
        [popview show];
    
    }
    else if ([str isEqualToString:@"我的收藏"])
    {
        MyCollectVC *mycollectVc=[[MyCollectVC alloc]initWithTitle:@"我的收藏"];
        [self.navigationController pushViewController:mycollectVc animated:YES];
    }
}
#pragma mark--------------待办公文---------
-(void)dbgwnum{
    //待办公文
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh", @(SingObj.unitInfo.intdwlsh_child),@"intcsdwlsh",nil];
    [self networkall:@"document" requestMethod:@"getDclgwNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_DocNum=@"";
        }else
        {
            i_DocNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [personCentertb reloadData];
    }];
    
}
#pragma mark--------------公告未读条数-------------
-(void)getGgNum{
    
    //公告未读条数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",nil];
    [self networkall:@"ggservices" requestMethod:@"getGgNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_ggNum=@"";
        }else
        {
            i_ggNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [personCentertb reloadData];
    }];
}
#pragma mark-----------通知的未读数量-------------
-(void)getTznum{
    //通知未读条数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@(SingObj.userInfo.intrylsh),@"intrylsh",nil];
    [self networkall:@"tzServices" requestMethod:@"getTzNum" requestHasParams:@"true" parameter:dic progresHudText:nil completionBlock:^(id rep) {
        if (rep[@"root"][@"result"]==[NSNull class]||[rep[@"root"][@"result"] intValue]<=0) {
            i_tzNum=@"";
        }else
        {
            i_tzNum =[NSString stringWithFormat:@"%@",[[rep objectForKey:@"root"] objectForKey:@"result"]];
        }
        [personCentertb reloadData];
    }];
}
#pragma mark--------------------对于图片的处理--------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        if (buttonIndex == 0) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                [self initImagePicker];
                _imagePickerControl.allowsEditing = YES;
                _imagePickerControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:_imagePickerControl animated:YES completion:nil];
            }
        }else if (buttonIndex == 1){
            //是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                [self initImagePicker];
                _imagePickerControl.allowsEditing = YES;
                _imagePickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:_imagePickerControl animated:YES completion:nil];
            }else{
                [self.powerAlert show];
            }
        }
    }];
//    if (buttonIndex == 0) {
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
//            [self initImagePicker];
//            _imagePickerControl.allowsEditing = YES;
//            _imagePickerControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentViewController:_imagePickerControl animated:YES completion:nil];
//        }
//    }else if (buttonIndex == 1){
//        //是否支持相机
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//            [self initImagePicker];
//            _imagePickerControl.allowsEditing = YES;
//            _imagePickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:_imagePickerControl animated:YES completion:nil];
//        }else{
//            [self.powerAlert show];
//        }
//    }
}
#pragma mark - UIImagePickerControllerDelegate
//当用户选取完成后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到选中的图片对象
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headerImg =image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadRyxp:image];
    }];
}
#pragma mark--------------上传头像------------
-(void)uploadRyxp:(UIImage*)aheaderImg{
    NSString *fileName=[NSString stringWithFormat:@"file_%@.jpg",[Tools getEncryptTime]];
    NSData *data = UIImageJPEGRepresentation(aheaderImg, 0.5);
    NSString *base64Str = [data base64EncodedString];
    NSString *sendXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strfjmc>%@</strfjmc><imgfjnr>%@</imgfjnr></root>",fileName,base64Str];
    NSDictionary *sendFjDic =@{@"intrylsh":@(SingObj.userInfo.intrylsh),@"sendXML":sendXML,@"chrryxm":SingObj.userInfo.username};
    [self networkall:@"usercenter" requestMethod:@"uploadRyxp" requestHasParams:@"true" parameter:sendFjDic progresHudText:@"正在上传头像..." completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([[[rep objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                [self showMessage:@"上传成功"];
                [userHeadImg setImage:self.headerImg];
                if (self.callback) {
                    self.callback(YES);
                }
            }
        }
    }];
}
//当用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
