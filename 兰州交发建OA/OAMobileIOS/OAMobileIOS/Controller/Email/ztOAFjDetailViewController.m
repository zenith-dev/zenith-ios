//
//  ztOAFjDetailViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-3-31.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAFjDetailViewController.h"
#import "ztOAProcessDetailListCell.h"
@interface ztOAFjDetailViewController ()
{
    NSMutableArray *i_FjArray;//附件数组
}
@property(nonatomic,strong)UITableView  *fjTableView;
@property(nonatomic,strong)UIImageView  *rootBarView;
@property(nonatomic,strong)UIButton     *addPhotosBtn;
@property(nonatomic,strong)UIButton     *addCameraPhotosBtn;
@end

@implementation ztOAFjDetailViewController
@synthesize fjTableView;
@synthesize rootBarView,addPhotosBtn,addCameraPhotosBtn;

- (id)initWithFjArray:(NSMutableArray *)fjarray
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // //self.appTitle.text = @"附件详情";
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    
    self.fjTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, self.view.width-20, self.view.height-64-60) style:UITableViewStylePlain];
    self.fjTableView.delegate = self;
    self.fjTableView.dataSource = self;
//    self.fjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.fjTableView];
    
    self.rootBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.fjTableView.bottom, self.view.width,60)];
    self.rootBarView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [self.rootBarView setUserInteractionEnabled:YES];
    [self.view addSubview:rootBarView];
    
    self.addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addPhotosBtn.frame = CGRectMake(50, 13, 40, 34);
    [addPhotosBtn setImage:[UIImage imageNamed:@"picture_off"] forState:UIControlStateNormal];
    [addPhotosBtn setImage:[UIImage imageNamed:@"picture_on"] forState:UIControlStateHighlighted];
    [addPhotosBtn addTarget:self action:@selector(addPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    self.addPhotosBtn.backgroundColor = [UIColor clearColor];
    [self.rootBarView addSubview:addPhotosBtn];
    
    self.addCameraPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCameraPhotosBtn.frame = CGRectMake(50*2+40, 10, 40, 40);
    [addCameraPhotosBtn setImage:[UIImage imageNamed:@"camera_Off"] forState:UIControlStateNormal];
    [addCameraPhotosBtn setImage:[UIImage imageNamed:@"camera_On"] forState:UIControlStateHighlighted];
    [addCameraPhotosBtn addTarget:self action:@selector(addCameraPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    self.addCameraPhotosBtn.backgroundColor = [UIColor clearColor];
    [self.rootBarView addSubview:addCameraPhotosBtn];
    	
    if (!i_FjArray) {
        i_FjArray = [[NSMutableArray alloc] init];
    }
}
//添加相册图片
- (void)addPhotosAction
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//添加照相机图片
- (void)addCameraPhotosAction
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提 示" message:@"该设备沒有照相功能"
                              delegate:self cancelButtonTitle:@"确定"
                              otherButtonTitles: nil];
        [alert show];
        //[alert release];
    }else
    {
        //imagePicker.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
//添加本地文件
- (void)addFilesAction
{
    
}
#pragma uiImagePickerCOntrol delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //[self myPop];
    
    UIImage *image = [[UIImage alloc]init];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //如果是 来自照相机的image，那么先保存
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //            UIImageWriteToSavedPhotosAlbum(image, self,
        //                                           @selector(image:didFinishSavingWithError:contextInfo:),
        //                                           nil);
        
    }
    else if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [i_FjArray addObject:image];
    [fjTableView reloadData];
    // lastPathComponent;
    //mySendView.imgAddPic1.image = image;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)delectOne:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [i_FjArray removeObjectAtIndex:(btn.tag-100)];
    [fjTableView reloadData];

}

- (void)lookingBigImg:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    UIButton *btn = (UIButton *)sender;
    [array addObject:[i_FjArray objectAtIndex:(btn.tag-1000)]];
    
    [self.navigationController pushViewController:[[ztOABigImgViewController alloc] initWithTitle:@"大图" selectedIndex:0 pictureArray:array currentType:3] animated:YES];
    
}
#pragma mark-tableview
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  i_FjArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"fjCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [[cell.contentView subviews] each:^(id sender) {
        [(UIView *)sender removeFromSuperview];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *imgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [imgView setImage:[i_FjArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.tag = 1000+indexPath.row;
    [imgView addTarget:self action:@selector(lookingBigImg:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:imgView];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(cell.width-60, 25, 30, 30);
    [deleteBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"close_on"] forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor clearColor];
    deleteBtn.tag = 100+indexPath.row;
    [deleteBtn addTarget:self action:@selector(delectOne:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deleteBtn];
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
