//
//  button+block.h
//  123123
//
//  Created by 祝敏彧 on 14-5-14.
//  Copyright (c) 2014年 ScrollViewText. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>



typedef void (^ActionBlock)(UIButton *);

@interface UIButton(Block)

@property (readonly) NSMutableDictionary *event;

- (void) handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end