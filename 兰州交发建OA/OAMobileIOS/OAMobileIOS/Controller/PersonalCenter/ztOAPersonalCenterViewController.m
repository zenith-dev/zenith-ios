//
//  ztOAPersonalCenterViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-6.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPersonalCenterViewController.h"

@interface ztOAPersonalCenterViewController ()
{
    NSString        *sexIsMan;//男，女,未知
    NSString        *unitnameStr;//单位
    NSString        *unitname_childStr;//处室
    NSString        *mobilePhoneStr;//移动电话
    NSString        *bgPhoneStr;//办公电话
     UIImagePickerController *_imagePickerControl;
}
@property (strong, nonatomic) UIActionSheet *photoAction;
@property (strong, nonatomic) UIAlertView *powerAlert;
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
    headImageBGView.image = [UIImage imageNamed:@"headView_titleBar_Img"];
    [self.view addSubview:headImageBGView];
    
    self.persnalHeadImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.persnalHeadImageView setFrame:CGRectMake(20, 20, 80, 80)];
    
    [persnalHeadImageView setImage:[UIImage imageNamed:@"headView_titleBar_userImg_normal"] forState:UIControlStateNormal] ;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"]!=nil) {
        NSString *imageLocalName = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERHEADIMAGENAME"]?:@"";
        NSString *imagePath = [self UrlFromPathOfDocuments:[NSString stringWithFormat:@"/headImage_tt0711/%@",imageLocalName]];
        UIImage* headImage = [UIImage imageWithContentsOfFile:imagePath];
        if (headImage!=nil) {
            [persnalHeadImageView setImage:headImage forState:UIControlStateNormal] ;
        }
    }
    [persnalHeadImageView addTarget:self action:@selector(sendOnUserHeadImage) forControlEvents:UIControlEventTouchUpInside];
    [persnalHeadImageView.layer setCornerRadius:40];
    [persnalHeadImageView setClipsToBounds:YES];
    persnalHeadImageView.backgroundColor = [UIColor clearColor];
    [headImageBGView addSubview:persnalHeadImageView];
    
    self.persnalNameLable = [[UILabel alloc] initWithFrame:CGRectMake(XW(persnalHeadImageView)+10, 50, self.view.width-120, 20)];
    NSString *usernamestr=[NSString stringWithFormat:@"%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    CGSize namessize=[usernamestr sizeWithAttributes:@{NSFontAttributeName:Font(15)}];
    self.persnalNameLable.text = [NSString stringWithFormat:@"%@",[ztOAGlobalVariable sharedInstance].username?:@""];
    persnalNameLable.backgroundColor = [UIColor clearColor];
    persnalNameLable.font = [UIFont systemFontOfSize:15.0f];
    persnalNameLable.textAlignment = NSTextAlignmentLeft;
    persnalNameLable.textColor = [UIColor blackColor];
    [headImageBGView addSubview:persnalNameLable];
    persnalNameLable.frame=CGRectMake(X(persnalNameLable), Y(persnalNameLable), namessize.width, H(persnalNameLable));
    
    
    
    self.persnalSexImage = [[UIImageView alloc] initWithFrame:CGRectMake(XW(persnalNameLable)+5, 53, 14, 14)];
    [persnalSexImage setImage:nil] ;
    persnalSexImage.backgroundColor = [UIColor clearColor];
    [headImageBGView addSubview:persnalSexImage];
    
    
    
    self.personalView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headImageBGView.bottom,self.view.width, self.view.height-self.headImageBGView.bottom) style:UITableViewStylePlain];
    self.personalView.backgroundColor = [UIColor clearColor];
    self.personalView.delegate = self;
    self.personalView.dataSource = self;
    self.personalView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.personalView];
    
    self.cxAlertContent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 50*2)];
    cxAlertContent.backgroundColor = [UIColor clearColor];
    UIImage *cameraBtnImg = [UIImage imageNamed:@"color_04"];
    NSInteger cameraBtnWidth = cameraBtnImg.size.width * 0.5f;
    NSInteger cameraBtnHeight = cameraBtnImg.size.height * 0.5f;
    cameraBtnImg = [cameraBtnImg stretchableImageWithLeftCapWidth:cameraBtnWidth topCapHeight:cameraBtnHeight];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"加载失败，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];

}
#pragma mark - 上传头像
- (void)sendOnUserHeadImage
{
   [self.photoAction showInView:self.view];
}

#pragma mark--------------------对于图片的处理--------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [self initImagePicker];
            _imagePickerControl.allowsEditing = YES;
            _imagePickerControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerControl animated:YES completion:nil];
            _imagePickerControl = nil;
        }
    }else if (buttonIndex == 1){
        //是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [self initImagePicker];
            _imagePickerControl.allowsEditing = YES;
            _imagePickerControl.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerControl animated:YES completion:nil];
            _imagePickerControl = nil;
        }else{
            [self.powerAlert show];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
//当用户选取完成后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到选中的图片对象
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString* fileName = [NSString stringWithFormat:@"%@",[self getCurrentTimeStr]];
        fileName = [fileName stringByAppendingString:@".jpg"];
        NSDictionary *fileDicInfo = [[NSDictionary alloc] initWithObjectsAndKeys:fileName,@"strfjmc",image,@"image",@"",@"inttzfjlsh",nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传头像"];
        [alert addButtonWithTitle:@"确定" handler:^(void){
            [self updateUserHeadImage:fileDicInfo];
        }];
        [alert addButtonWithTitle:@"取消" handler:^(void){    }];
        [alert show];

    }];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//照片上传接口
-(void)updateUserHeadImage:(NSDictionary *)dic
{
    UIImage *image =[dic objectForKey:@"image"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        NSString *base64Str = [data base64EncodedString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *sendXML = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><root><strfjmc>%@</strfjmc><imgfjnr>%@</imgfjnr></root>",
                                 [self UnicodeToISO88591:[dic objectForKey:@"strfjmc"]],
                                 base64Str];
            NSDictionary *sendFjDic= [[NSDictionary alloc] initWithObjectsAndKeys:[ztOAGlobalVariable sharedInstance].intrylsh,@"intrylsh",sendXML,@"sendXML",[self UnicodeToISO88591:[ztOAGlobalVariable sharedInstance].username],@"chrryxm",nil];
            
            [self showWaitViewWithTitle:@"上传附件中..."];
            [ztOAService updateUserHeadImage:sendFjDic Success:^(id result){
                [self closeWaitView];
                NSDictionary *dicData = [result objectFromJSONData];
                NSLog(@"上传附件结果：%@",dicData);
                if (dicData!=NULL&&[[[dicData objectForKey:@"root"] objectForKey:@"result"] intValue]==0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [ztOAGlobalVariable sharedInstance].userHeadPicName=[dicData objectForKey:@"root"][@"ryxpmc"];
                    [persnalHeadImageView setImage:image forState:UIControlStateNormal] ;
                    //保存到本地
                    NSString *path;
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSString *filePath = [NSString stringWithString:[self UrlFromPathOfDocuments:@"/headImage_tt0711"]];//将图片存储到本地documents/image
                    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
                    path = [filePath stringByAppendingString:[NSString stringWithFormat:@"%@/%@",filePath,[dic objectForKey:@"ryxpmc"]]];
                    [data writeToFile:path atomically:true];
                    //更新本地图片名字数据
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:[dic objectForKey:@"ryxpmc"] forKey:@"USERHEADIMAGENAME"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
            } Failed:^(NSError *error){
                [self closeWaitView];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"上传失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        });
    });
    
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        lab.text = @"退出登录";
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
