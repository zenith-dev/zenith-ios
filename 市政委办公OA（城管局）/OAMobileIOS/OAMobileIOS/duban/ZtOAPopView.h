//
//  ZtOAPopView.h
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/10/25.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZtOAPopView : UIView
-(void)show:(UIView*)subview;
@property (nonatomic, copy) void (^callback)(NSDictionary * bb);
@end
