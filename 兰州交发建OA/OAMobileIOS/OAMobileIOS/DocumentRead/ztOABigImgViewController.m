//
//  ztOABigImgViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-17.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOABigImgViewController.h"

@interface ztOABigImgViewController ()

@end

@implementation ztOABigImgViewController
@synthesize i_pictureUrlArray;
@synthesize i_scrollView;
//i_type:1:图片网络地址；2本地路径图片;3传入image；
- (id)initWithTitle:(NSString *)titleName selectedIndex:(int)iIndex pictureArray:(NSArray *)array currentType:(int)myType;
{
    self = [super init];
    if (self) {
        i_titleStr = titleName;
        i_displayIndex = iIndex;
        i_pictureUrlArray = array;
        i_AllPage = self.i_pictureUrlArray.count;
        i_currentIndex = i_displayIndex;
        i_type = myType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // //self.appTitle.text = [NSString stringWithFormat:@"%@(%d/%d)",i_titleStr,(i_AllPage==0)?0:(i_currentIndex+1),i_AllPage];
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";

    // 滚动图片
    i_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height-64)];
    [i_scrollView setPagingEnabled:YES];
    i_scrollView.showsHorizontalScrollIndicator = NO;
    i_scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:i_scrollView];
    i_scrollView.backgroundColor = [UIColor whiteColor];
    
    
    //图片显示排序处理
    [i_scrollView setContentSize:CGSizeMake(self.view.width * i_AllPage, self.view.height-64)];
    [i_scrollView setContentOffset:CGPointMake(i_displayIndex * self.view.width,0)];
    for (int i = 0; i < i_AllPage;i++)
    {
        ztOASingleScrollView *singleView = [[ztOASingleScrollView alloc]initWithFrame:CGRectMake(self.view.width * i, 0, self.view.width, self.view.height-64)];
        CGRect frame = i_scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        singleView.frame = frame;
        
        UIImage* currentImage ;
        //本地数据
        if (i_type==1) {
            //加载网络图片
            [singleView.imageView setImageWithURL:[NSURL URLWithString:[NSString  stringWithFormat:@"%@",[i_pictureUrlArray objectAtIndex:i]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            }];
        }else if (i_type==2)
        {
            currentImage = [UIImage imageWithContentsOfFile:[i_pictureUrlArray objectAtIndex:i]];
            [singleView.imageView setImage:currentImage];
        }
        else if (i_type==3)
        {
            currentImage=[i_pictureUrlArray objectAtIndex:i];
            [singleView.imageView setImage:currentImage];
        }
        
        //
        singleView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [i_scrollView addSubview:singleView];
    }
    
    i_scrollView.delegate = self;
    
}
#pragma UIScrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    NSArray *array = [scrollView subviews];
//    return [array lastObject];
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (i_scrollView == scrollView){
        
        int index = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
        i_currentIndex = index;
       // //self.appTitle.text =[NSString stringWithFormat:@"%@(%d/%d)",i_titleStr,(i_AllPage==0)?0:(i_currentIndex+1),i_AllPage];
    }
}
@end
