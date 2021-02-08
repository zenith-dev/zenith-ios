//
//  ztOAPopW.h
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OAPopDelegate<NSObject>
-(void)getIndexRow:(int)indexrow value:(id)value;
@end
@interface ztOAPopW : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *view_userContact;
    UITableView *tableViewT;
    UILabel *lblT;
    UIView *headView;
}
@property(nonatomic,strong)NSMutableArray *popArray;
@property(nonatomic,strong)NSString *popType;
@property(nonatomic,strong)NSString *strHeader;
@property(nonatomic,assign)NSInteger selectRowIndex;
@property(nonatomic,assign)id <OAPopDelegate> delegate;
- (id)initWithFrame:(CGRect)frame a:(NSString*)strHeader;
- (void)show;
- (void)hidden;
@end
