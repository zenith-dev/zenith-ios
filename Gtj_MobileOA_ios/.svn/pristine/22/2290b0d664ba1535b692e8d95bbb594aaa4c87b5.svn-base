//
//  button+block.m
//  123123
//
//  Created by 祝敏彧 on 14-5-14.
//  Copyright (c) 2014年 ScrollViewText. All rights reserved.
//

#import "UIButton+Block.h"

@implementation UIButton(Block)

static char overviewKey;

@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(UIButton *)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block(sender);
    }
}


@end