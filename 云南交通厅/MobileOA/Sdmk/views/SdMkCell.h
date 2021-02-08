//
//  SdMkCell.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/2.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SdmkModel.h"
#import "DocMentModel.h"
@interface SdMkCell : UITableViewCell
@property (nonatomic,assign)BOOL  isshow;
@property (nonatomic,strong)DocMentModel *docmentModel;
@property (nonatomic,strong)SdmkModel * sdmkModel;
@end
