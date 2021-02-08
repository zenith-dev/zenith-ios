//
//  LBBaseViewController.h
//  dtgh
//
//  Created by 熊佳佳 on 15/11/5.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBaseViewController : UIViewController
@property (nonatomic,assign)BOOL ishide;
/**定义→_→按钮文字
 */
- (UIButton*)rightButton:(NSString*)title image:(NSString*)image sel:(SEL)sel;
-(void)backPage;
@end
