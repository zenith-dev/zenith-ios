//
//  Macro.h
//  dtgh
//
//  Created by 熊佳佳 on 15/10/14.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


#endif /* Macro_h */
#define errorMsg @"请求失败"
#define NotWrok @"离线"


#define IOSOver(A) ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= A )

#define Scale kScreenWidth/320.0

/** 沙盒路径 ****************************************************************** */
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//异步打印
#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )


// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

//App MainScreen Height&Width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define SCreenWidth self.view.frame.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) X(obj)+W(obj)
#define YH(obj) Y(obj)+H(obj)

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageNamed:NAME]
// 字体大小(常规/粗体/字体类型)
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]
#define Font(x) [UIFont systemFontOfSize:x]
// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define HEXCOLOR(c) ([UIColor colorWithRed : ( (c >> 16) & 0xFF ) / 255.0 green : ( (c >> 8) & 0xFF ) / 255.0 blue : ( (c) & 0xFF ) / 255.0 alpha : 1.0])

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//版本号
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])

#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])

#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])
//其他类型转化字符串
#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]
#define StrFromFloat(F)     [NSString stringWithFormat : @ "%f", F]
#define StrFromInt(I)       [NSString stringWithFormat : @ "%d", I]
//其他类型转化NSNumber
#define NumFromBOOL(B)      [NSNumber numberWithBool : B]
#define NumFromInt(I)       [NSNumber numberWithInt : I]
#define NumFromDouble(D)    [NSNumber numberWithDouble : D]
#define NumFromFloat(f)     [NSNumber numberWithFloat : f]
