//
//  FDAddImagePubliceScroll.m
//  FOODSecure
//
//  Created by Dx on 14-8-7.
//  Copyright (c) 2014年 XJ. All rights reserved.
//

#import "SHRunPageScroll.h"
#import "UIImageView+WebCache.h"
@implementation SHRunPageScroll
@synthesize shrunpagescrolldelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W(self), H(self))];
        [imageview  setImage:PNGIMAGE(@"默认图带背景")];
        [self addSubview:imageview];
        // Initialization code
    }
    return self;
}
- (void)scrolladdimage:(NSMutableArray*)scrollviewarray
{
    [self initviewscroll:scrollviewarray];
}
- (void)scrolladdimage1:(NSMutableArray*)scrollviewarray
{
    [self initviewscroll1:scrollviewarray];
}
//初始化scroll
-(void)initviewscroll:(NSMutableArray*)scrollImagearray
{
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:NO];
    self.imageScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W(self), H(self))];
    self.imageScrollview.bounces = YES;
    self.imageScrollview.pagingEnabled = YES;
    self.imageScrollview.delegate = self;
    self.imageScrollview.userInteractionEnabled = YES;
    self.imageScrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.imageScrollview];
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,H(self)-18,100,18)]; // 初始化mypagecontrol
    self.pageControl.center=CGPointMake(self.imageScrollview.center.x, self.pageControl.center.y);
    [self.pageControl setCurrentPageIndicatorTintColor:[SingleObj defaultManager].mainColor];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    self.pageControl.numberOfPages =[scrollImagearray count]==1?0:[scrollImagearray count];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self addSubview:self.pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[scrollImagearray count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(W(self) * (i+1), 0, W(self), H(self))];
        imageView.contentMode=UIViewContentModeScaleToFill;
        [imageView setImage:[UIImage imageNamed:scrollImagearray[i]]];
        [self.imageScrollview addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=imageView.frame;
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(turnto:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageScrollview addSubview:btn];
    }
    // 取数组最后一张图片 放在第0页
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
//初始化scroll
-(void)initviewscroll1:(NSMutableArray*)scrollImagearray
{
    self.imageScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W(self), H(self))];
    self.imageScrollview.bounces = YES;
    self.imageScrollview.pagingEnabled = YES;
    self.imageScrollview.delegate = self;
    self.imageScrollview.userInteractionEnabled = YES;
    self.imageScrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.imageScrollview];
    // 初始化 pagecontrol
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(W(self)-100,H(self)-25,100,18)]; // 初始化mypagecontrol
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor greenColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    self.pageControl.numberOfPages =[scrollImagearray count]==1?0:[scrollImagearray count];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self addSubview:self.pageControl];
    if (scrollImagearray.count<=1) {
        self.pageControl.hidden=YES;
    }
    // 创建四个图片 imageview
    for (int i = 0;i<[scrollImagearray count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(W(self) * i, 0, W(self), H(self))];
        [imageView setImage:[UIImage imageNamed:scrollImagearray[i]]];
        [self.imageScrollview addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    [self.imageScrollview setContentSize:CGSizeMake(W(self) * ([scrollImagearray count]), H(self))]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [self.imageScrollview setContentOffset:CGPointMake(0, 0)];
    [self.imageScrollview scrollRectToVisible:CGRectMake(0,0,W(self),H(self)) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
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
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(runTimePage) userInfo:nil repeats:NO];
    int page =(int) self.pageControl.currentPage; // 获取当前的page
    page++;
    page = page > self.scrollImagearray.count-1 ? 0 : page ;
    self.pageControl.currentPage = page;
    [self turnPage];
}
-(void)turnto:(UIButton*)sender
{
   [shrunpagescrolldelegate turntoImg:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
