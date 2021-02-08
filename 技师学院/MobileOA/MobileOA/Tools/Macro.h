//
//  Macro.h
//  MoothClub
//
//  Created by Dx on 15/8/7.
//  Copyright (c) 2015年 Dc. All rights reserved.
//

#ifndef MoothClub_Macro_h
#define MoothClub_Macro_h
#endif

#define SystemProName [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]

#define SystemBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#define SystemProVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)CFBundleShortVersionString]

#define MainColor UIColorFromRGB(0x35b8de)
#define BgColor RGBCOLOR(237, 237, 237)
#define NotWrok @"您正处于离线状态,请检查网络连接"
#define errorMsg @"数据请求失败！"
#define NoData @"亲！页面暂无数据😢"

#define pageSize 10

#define API      @"http://61.186.249.146:7001/sport"

#define txt404 @"接口没找到！"
#define txt500 @"服务器异常！"

#define SystemVersion_floatValue ([[[UIDevice currentDevice] systemVersion] floatValue])

#define IOSOver(A) ([[[UIDevice currentDevice] systemVersion] floatValue] >= A)

#define DLog( s, ... ) NSLog(@"< %@:(%d) > %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#pragma mark -------Frame (宏 x, y, width, height)-----------------
// App Frame
#define Application_Frame  [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width

#define ScaleBI(scale)   scale*kScreenWidth/375.0

//App MainScreen Height&Width
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define W(obj)   (!obj?0:(obj).frame.size.width)
#define H(obj)   (!obj?0:(obj).frame.size.height)
#define X(obj)   (!obj?0:(obj).frame.origin.x)
#define Y(obj)   (!obj?0:(obj).frame.origin.y)
#define XW(obj) X(obj)+W(obj)
#define YH(obj) Y(obj)+H(obj)

// 加载图片
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define PNGIMAGE(NAME)          [UIImage imageNamed:NAME]
// 字体大小(常规/粗体/字体类型)
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]
#define SMFONT(x)  [UIFont boldSystemFontOfSize:x]
#define SNFONT(x) [UIFont systemFontOfSize:x]

#define SingObj [YYBSingObj defaultManager]


#define Scale5BI(x)  x*kScreenWidth/320.0

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
