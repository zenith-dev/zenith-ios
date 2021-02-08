//
//  ztOASendMesssageViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 13-11-7.
//  Copyright (c) 2013年 chenyang. All rights reserved.
//

#import "ztOASendMesssageViewController.h"
#import "ztOAAddressBook.h"
#define toolbarHeight	35

@interface ztOASendMesssageViewController ()
{
    NSArray *contactsNumber;
    NSString *sendNameTitle;
}
@property(nonatomic,strong)UITextView  *sendMessageContext;
@property(nonatomic, strong) UIToolbar          *toolBar;//键盘工具条
@end

@implementation ztOASendMesssageViewController
@synthesize sendMessageContext,toolBar;
- (id)initWithData:(NSMutableArray *)dataArray
{
    self = [super init];
    if (self) {
        // Custom initialization
         contactsNumber = [[NSArray alloc] init];
        sendNameTitle = [[NSString alloc] init];
        for (int i = 0; i<dataArray.count; i++) {
            ztOAAddressBook *oneBook;
            oneBook = (ztOAAddressBook *)[dataArray objectAtIndex:i];
            contactsNumber = [contactsNumber arrayByAddingObject:oneBook.mobilePhoneStr];
            sendNameTitle = [sendNameTitle stringByAppendingString:oneBook.nameStr];
            if (i!=dataArray.count-1) {
                sendNameTitle = [sendNameTitle stringByAppendingString:@","];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.leftBtnLab.text = @"";
    [self.rightBtn setHidden:NO];
    [self.leftBtn setHidden:NO];
    self.rightBtnLab.text = @"发送";
   // //self.appTitle.text = @"发送短信";
    __block ztOASendMesssageViewController *selfController = self;
    [self.leftBtn removeTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addEventHandler:^(id sender) {
        [[NSNotificationCenter defaultCenter]removeObserver:selfController];//注意
        [selfController.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn addTarget:self action:@selector(sendMesg) forControlEvents:UIControlEventTouchUpInside];
    //背景图
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,64, self.view.width, 50)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setImage:[UIImage imageNamed:@"top_bg_n"]];
    [backImg setUserInteractionEnabled:YES];
    [self.view addSubview:backImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.width-20, 50)];
    label.text = [NSString stringWithFormat:@"收件人:%@",sendNameTitle];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    [backImg addSubview:label];

    backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,64+50, self.view.width, self.view.height-64-50)];
    [backImg setBackgroundColor:[UIColor clearColor]];
    [backImg setImage:[UIImage imageNamed:@"bottom_bg_n"]];
    [backImg setUserInteractionEnabled:YES];
    [self.view addSubview:backImg];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 20)];
    label.text = @"内容:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15.0f];
    [backImg addSubview:label];
    
    self.sendMessageContext = [[UITextView alloc] initWithFrame:CGRectMake(10,30, self.view.width-20, (self.view.height-64-50)-30-10)];
    sendMessageContext.delegate = self;
    [sendMessageContext setFont:[UIFont systemFontOfSize:15.0f]];
    sendMessageContext.text = @"添加信息...";
    [sendMessageContext setTextColor:MF_ColorFromRGB(135, 135, 135)];
    sendMessageContext.backgroundColor = [UIColor whiteColor];
    [sendMessageContext.layer setBorderWidth:1];
    [sendMessageContext.layer setBorderColor:[[UIColor grayColor] CGColor]];
    sendMessageContext.autocorrectionType = UITextAutocorrectionTypeNo;
    sendMessageContext.autocapitalizationType = UITextAutocapitalizationTypeNone;
    sendMessageContext.returnKeyType = UIReturnKeyDefault;
    [sendMessageContext setScrollEnabled:YES];
    [backImg addSubview:sendMessageContext];
    
    self.toolBar = [[UIToolbar alloc] init];
    addN(@selector(handleKeyboardWillShow:), UIKeyboardWillShowNotification);
    addN(@selector(handleKeyboardWillHide:), UIKeyboardWillHideNotification);

}
//发送事件
- (void)sendMesg
{
    [self sendSMS:self.sendMessageContext.text recipientList:contactsNumber];
}
#pragma mark-MFMessageComposeViewControllerDelegate-
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    [self.sendMessageContext resignFirstResponder];
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }   
}
// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        NSLog(@"Message sent");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"操作成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"Message failed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"操作失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [sendMessageContext setSize:CGSizeMake(self.view.width-20, (self.view.height-64-50)-30-10)];
}

#pragma mark -textview delegate-
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([sendMessageContext.text isEqualToString:@"添加信息..."]) {
        sendMessageContext.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [sendMessageContext setSize:CGSizeMake(self.view.width-20, (self.view.height-64-50)-30-10)];
}
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    [self.toolBar removeFromSuperview];
}

- (void)handleKeyboardWillShow:(NSNotification *)notification
{
    UIBarButtonItem *doneButton =	[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [toolBar setFrame:CGRectMake(0, self.view.height - keyBoardFrame.size.height - toolbarHeight , keyBoardFrame.size.width, toolbarHeight)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translucent = TRUE;
    toolBar.items = @[doneButton];
    toolBar.alpha = 1.0;
    [self.view addSubview:toolBar];
    
    //重新设置高度
    float height_t ;
    height_t =keyBoardFrame.size.height + toolbarHeight+10;
    
    [sendMessageContext setSize:CGSizeMake(self.view.width-20, ((self.view.height-64-50)-30)-height_t)];

}
//UIBarButtonItem事件
- (void)done{
    [self.sendMessageContext resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
