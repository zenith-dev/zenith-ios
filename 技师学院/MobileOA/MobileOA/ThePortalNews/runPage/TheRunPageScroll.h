//
//  TheRunPageScroll.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheRunPageScroll : UIView<UIScrollViewDelegate>
@property (nonatomic,strong)NSString *key;
@property (nonatomic, copy) void (^callback)(int PageIndex);
@property(nonatomic,strong)NSMutableArray *scrollImagearray;
- (void)scrolladdimage:(NSMutableArray*)scrollviewarray;
@end
