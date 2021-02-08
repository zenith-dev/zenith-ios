//
//  FDAddImagePubliceScroll.h
//  FOODSecure
//
//  Created by Dx on 14-8-7.
//  Copyright (c) 2014年 XJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SHRunScrollDelegate<NSObject>
-(void)turntoImg:(UIButton*)sender;
@end
@interface SHRunPageScroll : UIView<UIScrollViewDelegate>
{
    int acrindex;
}
@property(nonatomic,strong)id<SHRunScrollDelegate> shrunpagescrolldelegate;
@property(nonatomic,strong)NSMutableArray *scrollImagearray;
@property (strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)UIScrollView *imageScrollview;
@property (strong,nonatomic)NSString *strType;
- (void)scrolladdimage:(NSMutableArray*)scrollviewarray;
- (void)scrolladdimage1:(NSMutableArray*)scrollviewarray;
-(void)initviewscroll:(NSMutableArray*)scrollImagearray;
@end
