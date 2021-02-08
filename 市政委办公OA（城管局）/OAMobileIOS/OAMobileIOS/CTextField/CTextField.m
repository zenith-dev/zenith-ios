//
//  CTextField.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/10/13.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "CTextField.h"

@implementation CTextField
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 30+8, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 30+8, 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
