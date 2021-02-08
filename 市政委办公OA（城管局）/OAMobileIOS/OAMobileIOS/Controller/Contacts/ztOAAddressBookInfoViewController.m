//
//  ztOAAddressBookInfoViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-13.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOAAddressBookInfoViewController.h"
#import "ztOAContactDetailInfoViewController.h"
@interface ztOAAddressBookInfoViewController ()
{
@private
    NSUInteger _selectedCount;
    NSMutableArray *addressListContent;
	NSMutableArray *searchListContent;
}
@property(nonatomic,strong)UITableView  *addressBookTable;
@property(nonatomic,strong)UISearchBar  *searchInfoBar;
@property(nonatomic,strong)UISearchDisplayController *searchDisplayController;
@end

@implementation ztOAAddressBookInfoViewController
@synthesize addressBookTable,searchInfoBar,searchDisplayController;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.leftBtn setHidden:NO];
    self.leftBtnLab.text = @"";
   // //self.appTitle.text = @"电话联系人";
    addressListContent = [[NSMutableArray alloc] init];
    searchListContent = [[NSMutableArray alloc] init];
    _selectedCount = 0;
    //获取通讯录数据
    [self initData];
    self.searchInfoBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 44)];
    searchInfoBar.delegate = self;
    searchInfoBar.barStyle = UIBarStyleDefault;
    //适配ios7.0系统
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([searchInfoBar respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[searchInfoBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        }
        else
        {
            //iOS7.0
            [searchInfoBar setBarTintColor:[UIColor clearColor]];
        }
    }
    else
    {
        //iOS7.0以下
        [[searchInfoBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    searchInfoBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchInfoBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchInfoBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:searchInfoBar];
    
    
    self.addressBookTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchInfoBar.bottom, self.view.width, self.view.height-self.searchInfoBar.bottom) style:UITableViewStylePlain];
    addressBookTable.backgroundColor = [UIColor clearColor];
    self.addressBookTable.separatorStyle = UITableViewCellSelectionStyleNone;
    addressBookTable.delegate = self;
    addressBookTable.dataSource = self;
    [self.view addSubview:addressBookTable];
    
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchInfoBar contentsController:self];
    searchDisplayController.delegate = self;
    [searchDisplayController setSearchResultsDataSource:addressBookTable.dataSource];
    [searchDisplayController setSearchResultsDelegate:addressBookTable.delegate];
	self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
	self.searchDisplayController.searchBar.showsCancelButton = NO;

}
- (void)initData
{
     NSMutableArray *addressBookTemp = [NSMutableArray array];
    //取得本地通信录名柄
    
    typedef void(^ABAddressBookRequestAccessCompletionHandler)(bool granted, CFErrorRef error);
    //请求用户访问授权
    AB_EXTERN void ABAddressBookRequestAccessWithCompletion(ABAddressBookRef addressBook,  ABAddressBookRequestAccessCompletionHandler completion) __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);
    
    ABAddressBookRef addressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //dispatch_release(sema);
    }
    else
    {
        addressBook =ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    if (addressBook==nil) {
        return ;
    };
    
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (NSInteger i = 0; i < nPeople; i++)
    {
        ztOAAddressBook *addressBook = [[ztOAAddressBook alloc] init];
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        //读取联系人姓名属性
        CFStringRef abFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)(abFirstName);
        NSString *lastNameString = (__bridge NSString *)(abLastName);
    
        if ((__bridge id)(abFullName) != nil) {
            nameString = (__bridge NSString *)(abFullName);
        } else {
            if ((__bridge id)(abLastName) != nil)
            {
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.nameStr = nameString;
        //获取字符串中英文字的拼音首字母并与字符串共同存放
        ChineseString *chineseStr = [[ChineseString alloc] init];
        chineseStr.string =[NSString stringWithFormat:@"%@",addressBook.nameStr];
        if(chineseStr.string==nil){
            chineseStr.string=@"";
        }
        
        if(![chineseStr.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseStr.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseStr.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseStr.pinYin=pinYinResult;
        }else{ 
            chineseStr.pinYin=@"";
        }
        addressBook.suoyinStr = [NSString stringWithFormat:@"%@",chineseStr.pinYin];
       
        //读取联系人公司信息
        addressBook.companyNameStr = (__bridge NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        //读取联系人工作
        addressBook.jobNameStr = (__bridge NSString *)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        
         //读取联系人email信息，email有好几种，比如工作邮箱，家庭邮箱，通过ABMultiValueCopyLabelAtIndex 属性来判断
        ABMultiValueRef emailForWORK = ABRecordCopyValue(person,kABPersonEmailProperty);
        
        if ((emailForWORK !=nil ) && (ABMultiValueGetCount(emailForWORK)>0)) {
            for (int i = 0;i<ABMultiValueGetCount(emailForWORK); i++) {
                NSString *aEmail = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emailForWORK, i);
                NSString *aEmailLable = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(emailForWORK, i);
                if ([aEmailLable isEqualToString:@"_$!<Work>!$_"]) {
                    addressBook.emailStr = aEmail;
                }
                
            }
        }
        //读取电话信息，和emial类似，也分为工作电话，家庭电话，工作传真，家庭传真。。。。
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if ((phone!=nil) && (ABMultiValueGetCount(phone)>0)) {
            for (int i = 0; i< ABMultiValueGetCount(phone); i++) {
                NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, i);
                NSString *aPhoneLable = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phone, i);
                if ([aPhoneLable isEqualToString:@"_$!<Mobile>!$_"]) {
                    addressBook.mobilePhoneStr = aPhone;
                }
                if ([aPhoneLable isEqualToString:@"_$!<HomeFAX>!$_"]) {
                    addressBook.faxPhoneStr = aPhone;
                }
                if ([aPhoneLable isEqualToString:@"_$!<WorkFAX>!$_"]) {
                    addressBook.telePhoneStr = aPhone;
                }
            }
        }
        //读取照片信息
        NSData *imageData = (__bridge NSData *)ABPersonCopyImageData(person);
        UIImage *myImage = [UIImage imageWithData:imageData];
        addressBook.headImageData = imageData;
        
        CGSize newSize = CGSizeMake(55, 55);
        UIGraphicsBeginImageContext(newSize);
        [myImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();//上诉代码实现图片压缩，可根据需要选择，现在是压缩到55*55
        
        imageData = UIImagePNGRepresentation(newImage);
        
        [addressBookTemp addObject:addressBook];
    }

// Sort data索引
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (ztOAAddressBook *addressBook in addressBookTemp) {
        NSInteger sect = [theCollation sectionForObject:addressBook
                                collationStringSelector:@selector(suoyinStr)];
        addressBook.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (ztOAAddressBook *addressBook in addressBookTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:addressBook.sectionNumber] addObject:addressBook];
    }
    
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(suoyinStr)];
        [addressListContent addObject:sortedSection];
    }

}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
	[self.searchDisplayController.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[self.searchDisplayController setActive:NO animated:YES];
	[self.addressBookTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [searchInfoBar resignFirstResponder];
}
#pragma mark -
#pragma mark ContentFiltering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[searchListContent removeAllObjects];
    for (NSArray *section in addressListContent) {
        for (ztOAAddressBook *addressBook in section)
        {
            NSComparisonResult result = [addressBook.nameStr compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
            {
                [searchListContent addObject:addressBook];
            }
            else
            {
                //中文可根据拼音搜索
                ChineseString *chineseStr = [[ChineseString alloc] init];
                chineseStr.string =[NSString stringWithFormat:@"%@",addressBook.nameStr];
                if(chineseStr.string==nil){
                    chineseStr.string=@"";
                }
                
                if(![chineseStr.string isEqualToString:@""]){
                    NSString *pinYinResult=[NSString string];
                    for(int j=0;j<chineseStr.string.length;j++){
                        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseStr.string characterAtIndex:j])]uppercaseString];
                        
                        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
                    }
                    chineseStr.pinYin=pinYinResult;
                }else{
                    chineseStr.pinYin=@"";
                }
                
                NSRange rangePinyin = [chineseStr.pinYin rangeOfString:searchText options:NSCaseInsensitiveSearch | NSNumericSearch];
                if (rangePinyin.location!=NSNotFound) {
                    //根据中文或英文搜索
                    [searchListContent addObject:addressBook];
                }
            }

        }
    }
}

#pragma mark -
#pragma mark UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    } else {
        return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
                [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0;
    } else {
        if (title == UITableViewIndexSearch) {
            [tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
            return -1;
        } else {
            return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index-1];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
	} else {
        return [addressListContent count];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    headView.backgroundColor = BACKCOLOR;
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.font = [UIFont systemFontOfSize:15.0f];
    headLabel.textColor = [UIColor grayColor];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
         headLabel.text=@"";
    } else {
         headLabel.text =  [[addressListContent objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
    }
    [headView addSubview:headLabel];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    return ([[addressListContent objectAtIndex:section] count]>0) ? 20 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchListContent count];
    } else {
        return [[addressListContent objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	ztOAAddressBook *addressBook = [[ztOAAddressBook alloc] init];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
	if (tableView == self.searchDisplayController.searchResultsTableView)
        addressBook = (ztOAAddressBook *)[searchListContent objectAtIndex:indexPath.row];
	else
        addressBook = (ztOAAddressBook *)[[addressListContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if ([[addressBook.nameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        cell.textLabel.text = addressBook.nameStr;
    } else {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:cell.textLabel.font.pointSize];
        cell.textLabel.text = @"No Name";
    }
	UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.height-1, cell.width, 1)];
    imgLine.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [cell.contentView addSubview:imgLine];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        ztOAAddressBook *addressBook = [[ztOAAddressBook alloc] init];
        addressBook = (ztOAAddressBook *)[searchListContent objectAtIndex:indexPath.row];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:addressBook.nameStr?:@"-",@"姓名",addressBook.mobilePhoneStr?:@"",@"移动电话", addressBook.telePhoneStr?:@"-",@"办公电话",addressBook.companyNameStr?:@"",@"单位",addressBook.emailStr?:@"",@"Email", nil];
		ztOAContactDetailInfoViewController *contactVC = [[ztOAContactDetailInfoViewController alloc] initWithData:dic isLocalPhotoInfo:@"2"];
        [self.navigationController pushViewController:contactVC animated:YES];
	}
	else {
        ztOAAddressBook *addressBook = [[ztOAAddressBook alloc] init];
        addressBook = (ztOAAddressBook *)[[addressListContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:addressBook.nameStr?:@"-",@"姓名",addressBook.mobilePhoneStr?:@"",@"移动电话", addressBook.telePhoneStr?:@"",@"办公电话",addressBook.companyNameStr?:@"",@"单位",addressBook.emailStr?:@"",@"Email", nil];
        
		ztOAContactDetailInfoViewController *contactVC = [[ztOAContactDetailInfoViewController alloc] initWithData:dic isLocalPhotoInfo:@"2"];
        [self.navigationController pushViewController:contactVC animated:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
