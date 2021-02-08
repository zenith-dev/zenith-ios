//
//  ztOAAddressBookItemCell.h
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-15.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOAABModel.h"

@protocol longPressUpDelegate <NSObject>
- (void)longPressUpLateAction:(ztOAABModel *)ABook;
@end

@interface ztOAAddressBookItemCell : UITableViewCell<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIImageView     *cellIcon;
@property (nonatomic,strong)UILabel         *name;
@property (nonatomic,strong)UILabel         *companyName;
@property (nonatomic,strong)UIButton        *checkedBtn;
@property (nonatomic,strong)ztOAABModel     *ABookCell;
@property (nonatomic,strong)UIImageView *upImg;
@property (nonatomic,assign)BOOL            isChecked;//选中标记
@property (nonatomic,assign)id<longPressUpDelegate>delegate;
- (void)setChecked:(BOOL)checked;
@end
