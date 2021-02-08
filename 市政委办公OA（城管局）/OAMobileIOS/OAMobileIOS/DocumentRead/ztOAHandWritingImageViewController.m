//
//  ztOAHandWritingImageViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-3.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAHandWritingImageViewController.h"
#import "ztOADrawViewBar.h"
@interface ztOAHandWritingImageViewController ()

@end

#import "ztMyView.h"
#import <QuartzCore/QuartzCore.h>
@interface ztOAHandWritingImageViewController ()
{
    NSString *i_Type;
    UIImage *OldImage;
    NSArray *colorArray;
    BOOL isPortraitIn_;//横屏数据
    BOOL isSettingStatusBar_;//横屏数据
    int  i_colorIndex;
}
@property(nonatomic,strong) UIImageView     *drawBigBackView;//画布背景图
@property(nonatomic,strong) ztMyView        *drawView;//画布
@property(nonatomic,strong) ztOADrawViewBar *drawToolBar;//工具栏

@property(nonatomic,strong) UISlider        *widthSlider;//宽度调节器
@property(nonatomic,strong) UIView          *sliderBackImg;//宽度调节器背景
@property(nonatomic,strong) UILabel         *sliderNumLabel;//宽度调节器数值
@property(nonatomic,strong) UIView          *colorChooseBtnsBar;//颜色选择条

@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) UIView *toolView;
@property (strong,nonatomic) NSString *currentURL;

@property (strong,nonatomic) UIActionSheet  *actionSheetView;

@property (strong,nonatomic) UIView         *helpInfoView;
@end

@implementation ztOAHandWritingImageViewController
@synthesize drawBigBackView,drawView;
@synthesize drawToolBar;
@synthesize widthSlider,sliderBackImg,sliderNumLabel,colorChooseBtnsBar;
@synthesize webView,toolView,currentURL;
@synthesize actionSheetView;
@synthesize helpInfoView;
- (id)initWithType:(NSString *)typeStr withOldImg:(UIImage *)image
{
    self = [super init];
    if (self) {
        i_Type = typeStr;
        OldImage = image;
        colorArray = [[NSArray alloc] initWithObjects:[UIColor blackColor],[UIColor whiteColor],[UIColor yellowColor],[UIColor blueColor],[UIColor redColor],[UIColor grayColor],[UIColor purpleColor],[UIColor brownColor],[UIColor cyanColor],[UIColor darkGrayColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor colorWithRed:0.400 green:0.400 blue:1.000 alpha:1.000], nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //工具栏
    self.drawToolBar = [[ztOADrawViewBar alloc] initWithFrame:CGRectMake(0, 0, self.view.height+20, 40)];
    [drawToolBar.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.loadSignImgBtn addTarget:self action:@selector(downUserSign) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.eraserBtn addTarget:self action:@selector(clearDraw) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.saveBtn addTarget:self action:@selector(actionSheetShow:) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.preDrawBtn addTarget:self action:@selector(drawPre) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.nextDrawBtn addTarget:self action:@selector(drawNext) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.colorChangeBtn addTarget:self action:@selector(colorChange:) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.widthChangeBtn addTarget:self action:@selector(widthChange:) forControlEvents:UIControlEventTouchUpInside];
    [drawToolBar.helpInBtn addTarget:self action:@selector(gotoHelp:) forControlEvents:UIControlEventTouchUpInside];
    
    //画布背景
    self.drawBigBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.drawToolBar.bottom,self.view.height+20,self.view.width-self.drawToolBar.bottom)];
    if (OldImage!=nil) {
        drawBigBackView.image =OldImage;
    }
    drawBigBackView.userInteractionEnabled = YES;
    drawBigBackView.backgroundColor = [UIColor clearColor];
    
    
    //画布
    self.drawView = [[ztMyView alloc] initWithFrame:CGRectMake(0, 0,self.view.height+20,self.view.width-self.drawToolBar.bottom)];
    drawView.backgroundColor = [UIColor clearColor];
    [self.drawBigBackView addSubview:self.drawView];
   
    //宽度调节器
    self.sliderBackImg = [[UIView alloc] initWithFrame:CGRectMake(0, drawToolBar.bottom, 400, 50)];
    sliderBackImg.backgroundColor = [UIColor grayColor];
    [sliderBackImg setUserInteractionEnabled:YES];
    
    //宽度调节器布局
    self.widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, 400-20-10-70, 30)];
    widthSlider.minimumValue = 1;//下限
    widthSlider.maximumValue = 50;//上限
    [widthSlider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
    widthSlider.backgroundColor = [UIColor clearColor];
    [sliderBackImg addSubview:widthSlider];
    
    self.sliderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthSlider.right+10, 10, 70, 30)];
    sliderNumLabel.font = [UIFont systemFontOfSize:12.0f];
    sliderNumLabel.textAlignment = NSTextAlignmentRight;
    sliderNumLabel.backgroundColor = [UIColor clearColor];
    [sliderBackImg addSubview:sliderNumLabel];
    
    //设置画笔默认值
    NSString *filePath = [self UrlFromPathOfDocuments:@"/loadingInfo.plist"];
    NSMutableDictionary *dataList = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath]mutableCopy];
    i_colorIndex=0;
    [drawView setlineWidth:4];
    widthSlider.value = 5;
    [drawToolBar.widthChangeBtn setTitle:@"5" forState:UIControlStateNormal];
    
    if ([dataList objectForKey:@"drawColor"]) {
        i_colorIndex = [[dataList objectForKey:@"drawColor"] intValue];
    }
    if ([dataList objectForKey:@"drawWidth"]) {
        [drawView setlineWidth:[[dataList objectForKey:@"drawWidth"] intValue]];
        [drawToolBar.widthChangeBtn setTitle:[dataList objectForKey:@"drawWidth"] forState:UIControlStateNormal];
        widthSlider.value = [[dataList objectForKey:@"drawWidth"] intValue];
    }
    
    [drawView setLineColor:i_colorIndex];
    [drawToolBar.colorChangeBtn setBackgroundColor:[colorArray objectAtIndex:i_colorIndex]];
    sliderNumLabel.text = [NSString stringWithFormat:@"画笔宽度:%.f", widthSlider.value];
    
    //颜色选择条
    self.colorChooseBtnsBar = [[UIView alloc] initWithFrame:CGRectMake(0, drawToolBar.bottom, 400, 130)];
    colorChooseBtnsBar.backgroundColor = [UIColor grayColor];
    [colorChooseBtnsBar setUserInteractionEnabled:YES];
    
    [self.sliderBackImg setFrame:CGRectMake(0, drawToolBar.bottom-50, 400, 50)];
    [self.colorChooseBtnsBar setFrame:CGRectMake(0, drawToolBar.bottom-130, 400, 130)];

    //颜色选择条布局
    for (int i = 0; i<colorArray.count/3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.layer setBorderColor:[[UIColor blackColor] CGColor]];
        if (0==i) {
            [btn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        }
        [btn.layer setBorderWidth:2];
        [btn.layer setCornerRadius:10];
        btn.tag = 1000+i;
        btn.backgroundColor = [colorArray objectAtIndex:i];
        btn.frame = CGRectMake(colorChooseBtnsBar.width/(colorArray.count/3)*i+5, 5, colorChooseBtnsBar.width/(colorArray.count/3)-10, 30);
        [btn addTarget:self action:@selector(colorChooseChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorChooseBtnsBar addSubview:btn];
    }
    for (int i = 0; i<colorArray.count/3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [btn.layer setBorderWidth:2];
        [btn.layer setCornerRadius:10];
        btn.tag = 1000+i+colorArray.count/3;
        btn.backgroundColor = [colorArray objectAtIndex:(i+colorArray.count/3)];
        btn.frame = CGRectMake(colorChooseBtnsBar.width/(colorArray.count/3)*i+5, 50, colorChooseBtnsBar.width/(colorArray.count/3)-10, 30);
        [btn addTarget:self action:@selector(colorChooseChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorChooseBtnsBar addSubview:btn];
    }
    for (int i = 0; i<colorArray.count/3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [btn.layer setBorderWidth:2];
        [btn.layer setCornerRadius:10];
        btn.tag = 1000+i+colorArray.count*2/3;
        btn.backgroundColor = [colorArray objectAtIndex:(i+colorArray.count*2/3)];
        btn.frame = CGRectMake(colorChooseBtnsBar.width/(colorArray.count/3)*i+5, 95, colorChooseBtnsBar.width/(colorArray.count/3)-10, 30);
        [btn addTarget:self action:@selector(colorChooseChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.colorChooseBtnsBar addSubview:btn];
    }
    [self.view addSubview:drawBigBackView];
    [self.view addSubview:sliderBackImg];
    [self.view addSubview:colorChooseBtnsBar];
    [self.view addSubview:self.drawToolBar];
    [sliderBackImg setHidden:YES];
    [colorChooseBtnsBar setHidden:YES];
    
    //actionSheet
    self.actionSheetView = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传本次签名",@"保存为默认签名档", nil];
    actionSheetView.actionSheetStyle = UIActionSheetStyleDefault;
    
    //helpInfoView
    self.helpInfoView =[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.height+20,self.view.width)];
    self.helpInfoView.backgroundColor = [UIColor clearColor];
    UIImageView *helpBackImg = [[UIImageView alloc] initWithFrame:helpInfoView.frame];
    helpBackImg.backgroundColor = [UIColor grayColor];
    helpBackImg.alpha = 0.7;
    [self.helpInfoView addSubview:helpBackImg];
    UIButton *closeHelpViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeHelpViewBtn.frame = CGRectMake(20, 5, 30, 30);
    closeHelpViewBtn.backgroundColor = [UIColor clearColor];
    [closeHelpViewBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeHelpViewBtn setBackgroundImage:[UIImage imageNamed:@"close_on"] forState:UIControlStateNormal];
    [closeHelpViewBtn addTarget:self action:@selector(gotoHelp:) forControlEvents:UIControlEventTouchUpInside];
    [self.helpInfoView addSubview:closeHelpViewBtn];
    UIImageView *helpImg = [[UIImageView alloc]initWithFrame:CGRectMake(50, 30, 400, 268)];
    helpImg.image = [UIImage imageNamed:@"drawHelp1"];
    [self.helpInfoView addSubview:helpImg];
    [self.helpInfoView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toucheView) name:@"MyViewTouch" object:nil];
}
- (void)actionSheetShow:(id)sender
{
    [self.actionSheetView showInView:self.view];
}
#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheetView == actionSheet) {
        switch (buttonIndex) {
            case 0:
            {//上传本次签名
                [self save:0];
            }
                break;
                
            case 1:
            {//保存为默认签名档
                [self save:1];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark - 导入用户默认签名档
- (void)downUserSign
{
    NSString *filename = @"/userSign.png";
    NSString *userSignImgPath = [self UrlFromPathOfDocuments:filename];
    if( [[NSFileManager defaultManager] fileExistsAtPath:userSignImgPath]==NO ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无默认签名档!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否导入你的默认签名档？"];
        [alert addButtonWithTitle:@"是的" handler:^{
            [self clearDraw];
            UIImage* userSignImg = [UIImage imageWithContentsOfFile:userSignImgPath];
            [self.drawBigBackView setImage:userSignImg];
        }];
        [alert addButtonWithTitle:@"否" handler:^{
        
        }];
        [alert show];
    }

    
}
#pragma mark - 返回
- (void)goBack
{
     NSString *filePath = [self UrlFromPathOfDocuments:@"/loadingInfo.plist"];
     NSMutableDictionary *dataList = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath]mutableCopy];
    NSString *colorIndexStr = [NSString stringWithFormat:@"%d",i_colorIndex];
    NSString *widthStr = [NSString stringWithFormat:@"%@",drawToolBar.widthChangeBtn.currentTitle];
    [dataList setObject:colorIndexStr forKey:@"drawColor"];
    [dataList setObject:widthStr forKey:@"drawWidth"];
    [dataList writeToFile:filePath atomically:YES ];
    
    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)gotoHelp:(id)sender
{
    if ([self.helpInfoView isHidden] ) {
        [self.helpInfoView setHidden:NO];
        [self.view addSubview:helpInfoView];
    }
    else{
        [self.helpInfoView removeFromSuperview];
        [self.helpInfoView setHidden:YES];
    }
}
- (void)toucheView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [drawToolBar.colorChangeBtn setSelected:NO];
    [drawToolBar.widthChangeBtn setSelected:NO];
    
    self.sliderBackImg.frame=CGRectMake(0, drawToolBar.bottom-50, 400, 50);
    self.colorChooseBtnsBar.frame =  CGRectMake(0, drawToolBar.bottom-130, 400, 130);
    [UIView commitAnimations];
}
- (void)sliderValueChanged
{
    self.sliderNumLabel.text = [NSString stringWithFormat:@"画笔宽度:%.f",widthSlider.value];
    [drawView setlineWidth:(int)(widthSlider.value-1)];
    [drawToolBar.widthChangeBtn setTitle:[NSString stringWithFormat:@"%.f",widthSlider.value] forState:UIControlStateNormal];
}
#pragma mark - 删除旧的签名
- (void)deleteOldDraw
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要删除旧的签名吗？"];
    [alert addButtonWithTitle:@"确定" handler:^{
        [self.drawBigBackView setImage:nil];
    }];
    [alert addButtonWithTitle:@"取消" handler:^{}];
    [alert show];
}

#pragma mark - 擦除
- (void)clearDraw
{
    [self.drawBigBackView setImage:nil];
    [self.drawView clear];
}
#pragma mark - 下一步
- (void)drawNext
{
    [self.drawView refrom];
}
#pragma mark - 返回上一步
- (void)drawPre
{
    [self.drawView revocation];
}
#pragma mark - 截屏
- (void)save:(int)flag
{
    UIGraphicsBeginImageContext(self.drawBigBackView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(self.drawView.frame);
    [self.drawBigBackView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(theImage, self, nil, @"截屏"); //保存到相册
    
    NSString *path;
    NSData *data ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:[self UrlFromPathOfDocuments:@"/image"]];//将图片存储到本地documents/image
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    if (flag==0) {
        if ([i_Type isEqualToString:@"1"]) {
            data = UIImagePNGRepresentation(theImage);
            path= [self UrlFromPathOfDocuments:@"/image/sign1.png"];
        }
        else{
            data = UIImagePNGRepresentation(theImage);
            path= [self UrlFromPathOfDocuments:@"/image/sign2.png"];
        }
    }
    else if (flag==1)
    {
        data = UIImagePNGRepresentation(theImage);
        path= [self UrlFromPathOfDocuments:@"/userSign.png"];
    }
   

    if ([data writeToFile:path atomically:YES])
    {
        //截屏成功
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    //UIGraphicsBeginImageContext(self.drawView.frame.size);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    //UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
}
#pragma mark - 画线宽度调整
- (void)widthChange:(id)sender
{
    [sliderBackImg setHidden:NO];
    [colorChooseBtnsBar setHidden:NO];
    if ([drawToolBar.widthChangeBtn isSelected]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.sliderBackImg.frame=CGRectMake(0, drawToolBar.bottom-50, 400, 50);
        [drawToolBar.widthChangeBtn setSelected:NO];
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.sliderBackImg.frame=CGRectMake(0, drawToolBar.bottom, 400, 50);
        self.colorChooseBtnsBar.frame =  CGRectMake(0, drawToolBar.bottom-130, 400, 130);
        [drawToolBar.colorChangeBtn setSelected:NO];
        [drawToolBar.widthChangeBtn setSelected:YES];
        [UIView commitAnimations];
    }
    
}
#pragma mark - 颜色选取
- (void)colorChange:(id)sender
{
    [sliderBackImg setHidden:NO];
    [colorChooseBtnsBar setHidden:NO];
    if ([drawToolBar.colorChangeBtn isSelected]) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.colorChooseBtnsBar.frame =  CGRectMake(0, drawToolBar.bottom-130, 400, 130);
        [drawToolBar.colorChangeBtn setSelected:NO];
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        self.sliderBackImg.frame=CGRectMake(0, drawToolBar.bottom-50, 400, 50);
        self.colorChooseBtnsBar.frame =  CGRectMake(0, drawToolBar.bottom, 400, 130);
        [drawToolBar.colorChangeBtn setSelected:YES];
        [drawToolBar.widthChangeBtn setSelected:NO];
        [UIView commitAnimations];
    }
}
-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
    self.currentURL = self.webView.request.URL.absoluteString;//获取当前网页的url
    
}
- (void)colorChooseChange:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    self.colorChooseBtnsBar.frame =  CGRectMake(0, drawToolBar.bottom-130, 400, 130);
    [drawToolBar.colorChangeBtn setSelected:NO];
    [UIView commitAnimations];
    for (int i = 0; i<colorArray.count; i++) {
        UIButton *butto = (UIButton*)[self.view viewWithTag:1000+i];
        [butto.layer setBorderColor:[[UIColor blackColor] CGColor]];
    }
    UIButton *btn = (UIButton *)sender;
    [btn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.drawView setLineColor:(btn.tag-1000)];
    i_colorIndex = btn.tag-1000;
    [drawToolBar.colorChangeBtn setBackgroundColor:[colorArray objectAtIndex:btn.tag-1000]];
}

#pragma mark - 发送邮件：

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.title=@"New Message";
    picker.mailComposeDelegate = self;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[[NSDate alloc] init];
    NSString *content=[[NSString alloc]
                       initWithFormat:@"App:1.0.iOS:%@ Date:%@",
                       [[UIDevice currentDevice] systemVersion],[dateFormatter stringFromDate:date]];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* appFile = [documentsDirectory stringByAppendingPathComponent:@"tmp.pdf"];
    NSData *myData = [NSData dataWithContentsOfFile:appFile];
    [picker addAttachmentData:myData mimeType:@"pdf" fileName:@"ceshi.pdf"];
    [picker setMessageBody:content isHTML:NO];
    
    [self presentModalViewController:picker animated:YES];
}


#pragma mark -横屏处理-
-(void)initLogic
{
    isPortraitIn_ = NO;
    isSettingStatusBar_ = NO;
}
-(BOOL)shouldAutorotate
{
    if (isSettingStatusBar_)
    {
        return NO;
    }
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (isPortraitIn_)
    {
        self.view.transform = CGAffineTransformIdentity;
        isPortraitIn_ = NO;
    }
}

- (void)cleanRotationTrace
{
    if (isPortraitIn_)
    {
        self.view.transform = CGAffineTransformIdentity;
        isPortraitIn_ = NO;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft)
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            isSettingStatusBar_ = NO;
        }
        else
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown animated:NO];
            isSettingStatusBar_ = NO;
        }
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.height + 20,self.view.frame.size.width - 20)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        isPortraitIn_ = YES;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        if (orientation == UIInterfaceOrientationPortrait)
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
            isSettingStatusBar_ = NO;
        }
        else
        {
            isSettingStatusBar_ = YES;
            [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
            isSettingStatusBar_ = NO;
        }
        [self.view setFrame:CGRectMake(0, -20, self.view.frame.size.height - 20,self.view.frame.size.width + 20)];
    }
}


@end
