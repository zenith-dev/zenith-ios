//
//  ztOAABModel.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-14.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOAABModel : NSObject
@property (nonatomic, strong) NSString *intrylsh;//联系人流水号
@property (nonatomic, strong) NSString *intdwpxh;//单位排序流水号
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *intdwlsh;
@property (nonatomic, strong) NSString *intrypxh;//人员排序流水号
@property (nonatomic,strong)  NSString *strnextdwbz;
@property (nonatomic,strong)  NSString *strnextrybz;
@property (nonatomic, strong) NSString *strxm;//姓名
@property (nonatomic, strong) NSString *strdw;//单位
@property (nonatomic, strong) NSString *strzw;//职务
@property (nonatomic, strong) NSString *strbgdh;//办公电话
@property (nonatomic, strong) NSString *stryddh;//移动电话

@property NSInteger sectionNumber;//索引
@property (nonatomic, strong) NSString *suoyinStr;//人名英文索引
@property (nonatomic, strong) NSString *dwsuoyinStr;//单位英文索引
@property (nonatomic,assign)BOOL       isCheckedUp;//选中


@property(nonatomic)int type;//类型：1为个人，2为单位
@property(nonatomic, strong)NSString *fullName;//全称
@property(nonatomic, strong)NSString *dwlsh;//单位流水号
@property(nonatomic, strong)NSString *chrbz;//chrbz=0时表示是处室流水号,当chrbz=1时表示是人员流水号
@end
