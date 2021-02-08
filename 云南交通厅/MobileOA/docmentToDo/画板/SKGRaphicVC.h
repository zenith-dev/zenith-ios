//
//  SKGRaphicVC.h
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/13.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "BaseViewController.h"

@interface SKGRaphicVC : BaseViewController
@property (nonatomic,strong)UILabel *withlb;
@property (nonatomic, copy) void (^callback)(UIImage *dwimage);
@end
