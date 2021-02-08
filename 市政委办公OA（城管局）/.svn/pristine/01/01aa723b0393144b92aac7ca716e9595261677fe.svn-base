//
//  ztOAPhotoViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-7-10.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAPhotoViewController.h"

@interface ztOAPhotoViewController ()
{
    NSString    *titleName;
    UIImage     *currentImage;
    NSData      *imageData;
}
@property(nonatomic,strong)UIImageView      *photoImage;//图像
@property(nonatomic,strong)UIButton         *sendPhotoBtn;
@property(nonatomic,strong)UILabel          *detailInfoLable;
@end

@implementation ztOAPhotoViewController
@synthesize photoImage,sendPhotoBtn,detailInfoLable;
- (id)initWithTitle:(NSString *)TitleStr withImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        titleName = TitleStr;
        currentImage = image;
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            imageData =[self onePic:currentImage];
//        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MF_ColorFromRGB(234, 234, 234);
	//self.appTitle.text = titleName;
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
    
    self.photoImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-200)/2,64+ 20, 200,200 )];
    photoImage.backgroundColor = [UIColor clearColor];
    photoImage.image = currentImage;
    photoImage.contentMode =UIViewContentModeScaleAspectFit;
    [self.view addSubview:photoImage];
    
    UIImage *sendPhotoBtnImg = [UIImage imageNamed:@"color_05"];
    NSInteger leftCapWidth = sendPhotoBtnImg.size.width * 0.5f;
    NSInteger topCapHeight = sendPhotoBtnImg.size.height * 0.5f;
    sendPhotoBtnImg = [sendPhotoBtnImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    self.sendPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendPhotoBtn.backgroundColor = [UIColor clearColor];
    sendPhotoBtn.frame = CGRectMake(20, self.photoImage.bottom+30, self.view.width-40, 35);
    [sendPhotoBtn setTitle:@"上传" forState:UIControlStateNormal];
    [sendPhotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendPhotoBtn setBackgroundImage:sendPhotoBtnImg forState:UIControlStateNormal];
    [sendPhotoBtn addTarget:self action:@selector(sendPhotoAtion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendPhotoBtn];
    
}
- (void)sendPhotoAtion
{
    //上传
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        imageData =[self onePic:currentImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([titleName isEqualToString:@"附件上传"]) {
                NSDictionary *emailAttachmentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@.jpg",[self getCurrentTimeStr]],@"name",imageData,@"data", nil];
                postNWithInfos(@"EMAILATTACHMENT", nil ,emailAttachmentDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
}
-(NSData*)onePic:(UIImage *)image
{
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5);
    return imagedata;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
