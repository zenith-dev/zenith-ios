//
//  ztOAAddressBook.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-13.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ztOAAddressBook : NSObject
@property (nonatomic, strong) NSString *nameStr;//姓名
@property (nonatomic, strong) NSString *emailStr;//email
@property (nonatomic, strong) NSString *companyNameStr;//公司名字
@property (nonatomic, strong) NSString *jobNameStr;//工作
@property (nonatomic, strong) NSString *mobilePhoneStr;//移动电话
@property (nonatomic, strong) NSString *faxPhoneStr;//传真
@property (nonatomic, strong) NSString *telePhoneStr;//办公电话
@property (nonatomic, strong) NSData *headImageData;//头像
@property (nonatomic, strong) NSString *suoyinStr;//英文索引
@property (nonatomic, strong) NSString *sectorNameStr;//部门
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property BOOL rowSelected;

@end
