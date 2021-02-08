//
//  AddressBookHelper.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/11/30.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "AddressBookHelper.h"
#import <AddressBook/AddressBook.h>
@implementation AddressBookHelper
// 单列模式
+ (AddressBookHelper*)shareControl
{
    static AddressBookHelper *instance;
    @synchronized(self) {
        if(!instance) {
            instance = [[AddressBookHelper alloc] init];
        }
    }
    return instance;
}
+ (BOOL)addContactName:(NSString *)name phoneNum:(NSString *)num withLabel:(NSString *)label strdw:(NSString*)strdw strzw:(NSString*)strzw
{
    return [[AddressBookHelper shareControl] addContactName:name phoneNum:num withLabel:label strdw:(NSString*)strdw strzw:(NSString*)strzw];
}
// 添加联系人（联系人名称、号码、号码备注标签）
- (BOOL)addContactName:(NSString*)name phoneNum:(NSString*)num withLabel:(NSString*)label strdw:(NSString*)strdw strzw:(NSString*)strzw
{
    // 创建一条空的联系人
    ABRecordRef record = ABPersonCreate();
    CFErrorRef error;
    
    if (name.length!=0||[name isKindOfClass:[NSNull class]]) {
        // 设置联系人的名字
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
    }
    if (strdw.length!=0||[strdw isKindOfClass:[NSNull class]]) {
        //单位
        ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)strdw, &error);
    }
    if (strzw.length!=0||[strzw isKindOfClass:[NSNull class]]){
        //职务
        ABRecordSetValue(record, kABPersonJobTitleProperty, (__bridge CFTypeRef)strzw, &error);
    }
    // 添加联系人电话号码以及该号码对应的标签名
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)num, (__bridge CFTypeRef)label, NULL);
    ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
    
    
    
    ABAddressBookRef addressBook = nil;
    // 如果为iOS6以上系统，需要等待用户确认是否允许访问通讯录。
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }
    else
    {
        //        addressBook = ABAddressBookCreate();
        addressBook = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
    }
    
    // 将新建联系人记录添加如通讯录中
    BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
    if (!success) {
        return NO;
    }else{
        
        // 如果添加记录成功，保存更新到通讯录数据库中
        success = ABAddressBookSave(addressBook, &error);
        return success ? YES : NO;
    }
}
+ (ABHelperCheckExistResultType)existPhone:(NSString *)phoneNum
{
    return [[AddressBookHelper shareControl] existPhone:phoneNum];
}
// 指定号码是否已经存在
- (ABHelperCheckExistResultType)existPhone:(NSString*)phoneNum
{
    ABAddressBookRef addressBook = nil;
    CFErrorRef error;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }
    else
    {
        //        addressBook = ABAddressBookCreate();
        addressBook = ABAddressBookCreateWithOptions(NULL, (CFErrorRef *)&error);
    }
    CFArrayRef records;
    if (addressBook) {
        // 获取通讯录中全部联系人
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
    }else{
#ifdef DEBUG
        NSLog(@"can not connect to address book");
#endif
        return ABHelperCanNotConncetToAddressBook;
    }
    
    // 遍历全部联系人，检查是否存在指定号码
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        CFTypeRef items = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFArrayRef phoneNums = ABMultiValueCopyArrayOfAllValues(items);
        if (phoneNums) {
            for (int j=0; j<CFArrayGetCount(phoneNums); j++) {
                NSString *phone = (NSString*)CFArrayGetValueAtIndex(phoneNums, j);
                if ([phone isEqualToString:phoneNum]) {
                    return ABHelperExistSpecificContact;
                }
            }
        }
    }
    
    CFRelease(addressBook);
    return ABHelperNotExistSpecificContact;
}
@end
