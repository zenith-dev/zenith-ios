//
//  AddressBookCell.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/30.
//  Copyright © 2016年 xj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddUnitInfo.h"
#import "AddUserInfo.h"
@protocol longPressUpDelegate <NSObject>
- (void)longPressUpLateAction;
@end
@interface AddressBookCell : UITableViewCell
@property (nonatomic,assign)id<longPressUpDelegate>delegate;
@property (nonatomic,strong)AddUnitInfo *addUnitInfo;
@property (nonatomic,strong)AddUserInfo *addUserInfo;
@end
