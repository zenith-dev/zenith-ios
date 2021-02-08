//
//  TheRunPageScroll.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "TheRunPageScroll.h"
@interface TheRunPageScroll()
@property (nonatomic,strong)NSTimer * timers;
@property (nonatomic,strong)UIScrollView*imageScrollview;
@property (nonatomic,strong)UIPageControl *pageControl;
@end

@implementation TheRunPageScroll
@synthesize key;
#pragma mark-------------Getter--------------
-(NSTimer*)timers
{
    if (!_timers) {
        _timers=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
    return _timers;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [imageview setImage:PNGIMAGE(@"默认图")];
        [self addSubview:imageview];
        // Initialization code
    }
    return self;
}
- (void)scrolladdimage:(NSMutableArray*)scrollviewarray
{
    [self initviewscroll:scrollviewarray];
}
//初始化scroll
-(void)initviewscroll:(NSMutableArray*)scrollImagearray
{
    for (UIView *views in self.subviews) {
        if ([views isKindOfClass:[UIView class]]) {
            [views removeFromSuperview];
        }
    }
    [self.timers setFireDate:[NSDate distantPast]];
    self.imageScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.imageScrollview.bounces = YES;
    self.imageScrollview.pagingEnabled = YES;
    self.imageScrollview.delegate = self;
    self.imageScrollview.userInteractionEnabled = YES;
    self.imageScrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.imageScrollview];
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,self.height-30,self.width/2.0-10,30)]; // 初始化mypagecontrol
    //self.pageControl.center=CGPointMake(self.imageScrollview.center.x, self.pageControl.center.y);
    self.pageControl.right=self.width-10;
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self.pageControl setPageIndicatorTintColor:RGBACOLOR(255, 255, 255, 0.56)];
    self.pageControl.numberOfPages =[scrollImagearray count]==1?0:[scrollImagearray count];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[scrollImagearray count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(W(self) * (i+1), 0, W(self), H(self))];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        imageView.tag=i;
        NSString *imgUrl;
        NSString *titlestr;
        if ([[scrollImagearray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            imgUrl=[scrollImagearray objectAtIndex:i][key];
            titlestr=[scrollImagearray objectAtIndex:i][@"title"];
        }else
        {
            imgUrl =[scrollImagearray objectAtIndex:i];
        }
        imageView.userInteractionEnabled=YES;
        [imageView setBackgroundColor:UIColorFromRGB(0xdedede)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PNGIMAGE(@"默认图")];
        NSLog(@"%@============",imgUrl);
        [imageView bk_whenTapped:^{
            if (self.callback) {
                self.callback((int)imageView.tag);
            }
        }];
        [self.imageScrollview addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        
        UILabel *bglb=[[UILabel alloc]initWithFrame:CGRectMake(0, imageView.height-30, imageView.width, 30)];
        [bglb setBackgroundColor:RGBACOLOR(100, 100, 100, 0.7)];
        [imageView addSubview:bglb];
        
        UILabel *titlelb=[[UILabel alloc]initWithFrame:CGRectMake(0, imageView.height-30, imageView.width/2.0-10, 30)];
        [titlelb setBackgroundColor:[UIColor clearColor]];
        titlelb.font=Font(14);
        titlelb.textColor=[UIColor whiteColor];
        titlelb.text=[NSString stringWithFormat:@"   %@",titlestr];
        [imageView addSubview:titlelb];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
    imageView.frame = CGRectMake(0, 0,W(self), H(self)); // 添加最后1页在首页 循环
    [self.imageScrollview addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] initWithImage:nil];
    imageView.frame = CGRectMake((W(self) * ([scrollImagearray count] + 1)) , 0, W(self), H(self)); // 添加第1页在最后 循环
    [self.imageScrollview addSubview:imageView];
    
    [self.imageScrollview setContentSize:CGSizeMake(W(self) * ([scrollImagearray count]+2), H(self))]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [self.imageScrollview setContentOffset:CGPointMake(0, 0)];
    [self.imageScrollview scrollRectToVisible:CGRectMake(W(self),0,W(self),H(self)) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    if (scrollImagearray.count==1) {
        self.imageScrollview.scrollEnabled=NO;
    }
}
// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int page = floor((self.imageScrollview.contentOffset.x - pagewidth/([self.scrollImagearray count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
}
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.imageScrollview.frame.size.width;
    int currentPage = floor((self.imageScrollview.contentOffset.x - pagewidth/ ([self.scrollImagearray count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.imageScrollview scrollRectToVisible:CGRectMake(W(self) * [self.scrollImagearray count],0,W(self),H(self)) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([self.scrollImagearray count]+1))
    {
        [self.imageScrollview scrollRectToVisible:CGRectMake(W(self),0,W(self),H(self)) animated:NO]; // 最后+1,循环第1页
    }
}
// pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = self.pageControl.currentPage; // 获取当前的page
    [self.imageScrollview scrollRectToVisible:CGRectMake(W(self)*(page+1),0,W(self),H(self)) animated:YES];
}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page =(int) self.pageControl.currentPage; // 获取当前的page
    page++;
    page = page > self.scrollImagearray.count-1 ? 0 : page ;
    self.pageControl.currentPage = page;
    [self turnPage];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
