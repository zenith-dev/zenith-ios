//
//  SKGraphicView.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "SKGraphicView.h"

@implementation SKGraphicView

static UIButton *selectBtn;
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        yImg=kScreenHeight;
        xImg=kScreenWidth;
        self.pointStart =[[NSMutableArray alloc]init];
        self.pointend=[[NSMutableArray alloc]init];
        
        _pathArray = [NSMutableArray array];
       // [self toolsviewgo];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}
- (void)drawPicture:(CGContextRef)context {
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _path = CGPathCreateMutable(); //创建路径
    
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    
    [_pathArray addObject:attributeArry]; //路径及属性数组数组
    _start = [touch locationInView:self]; //起始点
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
    
    [self.pointStart addObject:[NSValue valueWithCGPoint:_start]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    释放路径
    CGPathRelease(_path);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    [self.pointend addObject:[NSValue valueWithCGPoint:_move]];
    [self setNeedsDisplay];
    
}
-(UIImage *)getDrawingImg{
    if (_pathArray.count) {
        for (NSValue *poStart in self.pointStart) {
            CGPoint pointstart=[poStart CGPointValue];
            if (wImg<pointstart.x) {
                wImg=pointstart.x;
            }
            if (xImg>pointstart.x) {
                xImg=pointstart.x;
            }
            if (hImg<pointstart.y) {
                hImg=pointstart.y;
            }
            if (yImg>pointstart.y) {
                yImg=pointstart.y;
            }
        }
        for (NSValue *poend in self.pointend) {
            CGPoint pointend=[poend CGPointValue];
            if (wImg<pointend.x) {
                wImg=pointend.x;
            }
            if (xImg>pointend.x) {
                xImg=pointend.x;
            }
            if (hImg<pointend.y) {
                hImg=pointend.y;
            }
            if (yImg>pointend.y) {
                yImg=pointend.y;
            }
        }
        UIGraphicsBeginImageContext(CGSizeMake(wImg, hImg));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect rect1 = CGRectMake(xImg , yImg , wImg , hImg);
        UIImage * imgeee = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect1)];
        return imgeee;
    }
    return nil;
}
-(void)undoBtnEvent
{
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}

-(void)clearBtnEvent
{
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
