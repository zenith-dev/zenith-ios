//
//  SdmkModel.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/1.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SdmkModel : NSObject
@property (nonatomic, strong) NSString * chrgwbt;
@property (nonatomic, strong) NSString * chrlwdwmc;
@property (nonatomic, strong) NSString * chrlzlx;
@property (nonatomic, strong) NSString * chrzwcs;
@property (nonatomic, strong) NSString * chrzwr;
@property (nonatomic, strong) NSString * dtmbjsj;
@property (nonatomic, strong) NSString * dtmblsx;
@property (nonatomic, strong) NSString * dtmfssj;
@property (nonatomic, assign) long intgwlsh;
@property (nonatomic, assign) long intgwlzlsh;
@property (nonatomic,copy) NSString *intlxid;//督办件类型ID
@property (nonatomic,copy) NSString *strblgcbz;//督办类型
@end
