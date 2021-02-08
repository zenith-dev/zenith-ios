//
//  ztOANewDocTableViewCell.h
//  OAMobileIOS
//
//  Created by ran chen on 14-5-15.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ztOANewDocTableViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel     *title;

- (void)setCellImageView:(UIImage *)aImage;

@end
