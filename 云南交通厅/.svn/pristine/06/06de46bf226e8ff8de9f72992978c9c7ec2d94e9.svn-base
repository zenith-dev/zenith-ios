//
//  SKGraphicView.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKGraphicView : UIView
{
    CGPoint _start;
    CGPoint _move;
    CGMutablePathRef _path;
    NSMutableArray *_pathArray;
    CGFloat _lineWidth;
    UIColor *_color;
    float wImg;//图片的宽度
    float hImg;//图片的高度
    float xImg;//图片的x
    float yImg;//图片的Y
}
@property (nonatomic,strong)NSMutableArray *pointStart;//点结束
@property (nonatomic,strong)NSMutableArray *pointend;//点开始
@property (nonatomic,assign)CGFloat lineWidth;/**< 线宽 */
@property (nonatomic,strong)UIColor *color;/**< 线的颜色 */
@property (nonatomic,strong)NSMutableArray *pathArray;
-(UIImage*)getDrawingImg;//获取图片
-(void)undoBtnEvent;//返回
-(void)clearBtnEvent;//清楚
@end
