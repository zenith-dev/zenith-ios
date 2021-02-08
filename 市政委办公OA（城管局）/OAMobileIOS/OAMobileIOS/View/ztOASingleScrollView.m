//
//  ztOASingleScrollView.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-12-17.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASingleScrollView.h"
#define MRScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define MRScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface ztOASingleScrollView (Utility)

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;

@end

@implementation ztOASingleScrollView

@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, MRScreenWidth, MRScreenHeight);
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
        flag = NO;
        [self initImageView];
    }
    return self;
}
- (void)initImageView
{
    imageView = [[UIImageView alloc]init];
    // The imageView can be zoomed largest size
    imageView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5, MRScreenHeight * 2.5);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    // Add gesture,double tap zoom imageView.
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [doubleTapGesture setNumberOfTouchesRequired:1];
    doubleTapGesture.delegate = self;
    [imageView addGestureRecognizer:doubleTapGesture];
    
    float minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
    
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    if (flag==NO) {
        imageView.contentMode = UIViewContentModeCenter;
        flag=YES;
        if (imageView.image.size.height>0) {
            
            imageView.frame =CGRectMake(0,  0, imageView.image.size.width*self.zoomScale, imageView.image.size.height*self.zoomScale);
        }
    }else{
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, MRScreenWidth * 2.5*self.zoomScale, MRScreenHeight * 2.5*self.zoomScale);
        flag=NO;
    }
    CGFloat scrollViewHeight = 0.0f;
    CGFloat scrollViewWidth  = 0.0f;
    for (UIView* view in self.subviews){
        scrollViewHeight += view.frame.size.height;
        scrollViewWidth +=view.frame.size.width;
    }
    
    CGRect zoomRect = [self zoomRectForScale:(1-self.zoomScale) withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = MRScreenWidth*2.5/2 - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = MRScreenHeight*2.5/2 - (zoomRect.size.height / 2.0);
  
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?(self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = ((self.bounds.size.height-20) > self.contentSize.height)?((self.bounds.size.height-20) - self.contentSize.height) * 0.5 : 0.0;
    
    //    self.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,self.contentSize.height * 0.5 + offsetY);
    
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                   scrollView.contentSize.height * 0.5 + offsetY);
}
@end
