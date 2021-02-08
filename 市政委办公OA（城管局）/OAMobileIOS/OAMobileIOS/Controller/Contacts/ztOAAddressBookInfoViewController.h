//
//  ztOAAddressBookInfoViewController.h
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-13.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ztOABaseViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ztOAAddressBook.h"
#import "ChineseString.h"
#import "pinyin.h"
@class ztOAAddressBook,ztOAAddressBookInfoViewController;

@interface ztOAAddressBookInfoViewController : ztOABaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@end
