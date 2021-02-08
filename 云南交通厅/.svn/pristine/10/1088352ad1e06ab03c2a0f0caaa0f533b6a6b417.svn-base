//
//  KWFileListViewModel
//  DemoOa
//
//  Created by 何海伟 on 16/2/29.
//  Copyright © 2016年 KingSoft Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KWFileType)
{
    KWFileTypeWord,
    KWFileTypeET,
    KWFileTypePPT,
    KWFileTypePDF,
};

@interface KWFileListViewModel : NSObject

/**
 *  配置文件的操作权限
 *
 *  @param fileType 文件类型
 *
 *  @return 配置列表
 */
+ (NSDictionary<NSString*,NSString*>*)configFilePolicyWithFileType:(KWFileType)fileType;

/**
 *  配置模拟的操作权限列表（仅仅是用来测试区分效果，没有其他特殊意义）
 *
 *  @param fileType 文件列表
 *
 *  @return 配置列表
 */
+ (NSDictionary<NSString*,NSString*>*)configControllerModelFilePolicyWithFileType:(KWFileType)fileType;
@end
