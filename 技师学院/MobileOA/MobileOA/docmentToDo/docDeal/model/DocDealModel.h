//
//  DocDealModel.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/9.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocDealModel : NSObject
@property (nonatomic,strong)NSString *clyjStr;//处理意见
@property (nonatomic,strong)NSMutableArray *xbrwAry;//下步任务数组
@property (nonatomic,strong)NSString *xbrwmc;//选择了下步任务名称
@property (nonatomic,assign)int xbrwnum;//下步任务编号
@property (nonatomic,assign)BOOL isOpenRy;//打开下步人员
@property (nonatomic,strong)NSMutableArray *xbryAry;//下步任务人员数组
@property (nonatomic,strong)NSMutableString *xbrwryxm;//下步任务人员选择的姓名
@property (nonatomic,assign)int xbrwrynum;
@property (nonatomic,strong)NSDictionary    *responsibleManDic;//选定的处理人数据
@property (nonatomic,assign)BOOL isDirecReturn;//判断是否需要选择人员
@property (nonatomic,strong)NSDictionary *opinionSelectedDic;//选择处理意见
@property (nonatomic,strong)UIImage *dwImg;
@end
