//
//  ztOANewDocInfo.h
//  OAMobileIOS
//
//  Created by ran chen on 14-5-14.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOANewDocInfo : NSObject
@property(nonatomic)BOOL isSelected;//是否被选中
@property(nonatomic)int type;//类型：1为个人，2为单位
@property(nonatomic, strong)NSString *fullName;//全称
@property(nonatomic, strong)NSString *shortName;//简称
@property(nonatomic, strong)NSString *dwlsh;//单位流水号
@property(nonatomic, strong)NSString *chrbz;//chrbz=0时表示是处室流水号,当chrbz=1时表示是人员流水号
@end
