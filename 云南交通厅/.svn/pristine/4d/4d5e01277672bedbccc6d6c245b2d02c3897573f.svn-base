//
//  QueryChatxqVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/7.
//  Copyright © 2016年 xj. All rights reserved.
//
#import "QueryChatxqVC.h"
#import "QcXqModel.h"
#import <HPGrowingTextView.h>
#import "QueryChatXqCell.h"
@interface QueryChatxqVC ()<UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate>
@property (nonatomic,strong)NSMutableArray *querylist;//聊天信息列表
@property (nonatomic,strong)UITableView *querytb;//聊天
@property (nonatomic,strong)UIView *moreView;
@property (nonatomic,strong)HPGrowingTextView *textView;
@property (nonatomic,strong)UIButton *sendBtn;//发送按钮
@end

@implementation QueryChatxqVC
@synthesize intfsrlsh,intjsrlsh,querylist,querytb,moreView,textView,sendBtn,jsrxm,fsrxm;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[QueryChatxqVC class]];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField=10;
    // 是否显示键盘上的工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField=40;
    // 是否显示键盘上的工具条
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    querylist=[[NSMutableArray alloc]init];
    querytb =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50) style:UITableViewStylePlain];
    querytb.delegate=self;
    querytb.dataSource=self;
    [self.view addSubview:querytb];
    [querytb setBackgroundColor:[UIColor colorWithRed:0.922 green:0.922 blue:0.949 alpha:1.00]];
    [querytb setSeparatorStyle:UITableViewCellSeparatorStyleNone];//设置表格无横线
    UITapGestureRecognizer *gestureRecognizer = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self hideKeyboard];
    }];
    gestureRecognizer.cancelsTouchesInView = NO;//不影响其他控件操作
    [querytb addGestureRecognizer:gestureRecognizer];
    
    moreView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
    [moreView setBackgroundColor:[UIColor colorWithRed:0.894 green:0.898 blue:0.902 alpha:1.00]];
    //发送框
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 8, moreView.width-60, 34)];
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    textView.returnKeyType = UIReturnKeyDone;
    textView.font = Font(15);
    textView.placeholder = @"请输入消息";
    textView.delegate = self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    textView.backgroundColor = [UIColor whiteColor];
    sendBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [sendBtn setImage:PNGIMAGE(@"发送") forState:UIControlStateNormal];
    sendBtn.right=moreView.width-10;
    sendBtn.centerY=moreView.height/2.0;
    [sendBtn addTarget:self action:@selector(sendMsgSEL) forControlEvents:UIControlEventTouchUpInside];
    [moreView addSubview:sendBtn];
    
    [moreView addSubview:textView];
    [self.view addSubview:moreView];
    
    [self queryChatxq:NO];
    // Do any additional setup after loading the view.
}
#pragma mark----------------获取聊天信息-------------------
-(void)queryChatxq:(BOOL)isrefsh{
    [querylist removeAllObjects];
    [self network:@"SsGdServices" requestMethod:@"queryChatxq" requestHasParams:@"true" parameter:@{@"intfsrlsh":intfsrlsh,@"intjsrlsh":intjsrlsh} progresHudText:isrefsh==NO?@"加载中...":nil completionBlock:^(id rep) {
        if (rep!=nil) {
            if ([rep[@"chats"] isKindOfClass:[NSArray class]]) {
                querylist=[[NSMutableArray alloc]initWithArray:[QcXqModel mj_objectArrayWithKeyValuesArray:rep[@"chats"]]];
            }else if ([rep[@"chats"] isKindOfClass:[NSDictionary class]]){
                [querylist addObject:[QcXqModel mj_objectWithKeyValues:rep[@"chats"]]];
            }
            [querytb reloadData];
            if (querylist.count>0) {
                 [querytb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[querylist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
           
            
        }
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return querylist.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     QcXqModel *qcxqModel=querylist[indexPath.row];
     NSString *endCellIdentifier =[qcxqModel mj_JSONString];
    QueryChatXqCell *cell = [tableView dequeueReusableCellWithIdentifier:endCellIdentifier];
    if (cell == nil) {
        cell = [[QueryChatXqCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:endCellIdentifier];
        [cell setBackgroundColor:[UIColor colorWithRed:0.922 green:0.922 blue:0.949 alpha:1.00]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.row==0) {
            cell.fristTime=qcxqModel.dtmfssj;
        }else if (indexPath.row>0)
        {
            QcXqModel *qcxqModel1=querylist[indexPath.row-1];
            cell.fristTime=qcxqModel1.dtmfssj;
        }
        cell.qcxqModel=querylist[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//点击表格背景 取消键盘
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark HPGrowingTextView Delegate Methods
//用于换行时 拉升高度 和 讲聊天记录顶上去
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = moreView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    moreView.frame = r;
    sendBtn.centerY=moreView.height/2.0;
    CGRect t = querytb.frame;
    t.size.height += diff;
    querytb.frame = t;
    if([querylist count]>0){
        [querytb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[querylist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
//点击键盘的return 进行发送操作 ，注意修改过源码HPGrowingTextView
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *) growingTextView{
    [growingTextView resignFirstResponder];
    if (![Tools isBlankString:growingTextView.text]) {
        [self sendMsgSEL];
    }
    return NO;
}
#pragma mark Responding to keyboard events
-(void) keyboardWillShow:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //获取键盘的高度
    NSDictionary *userInfo = [note userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        querytb.height = (kScreenHeight-height-moreView.height);
        moreView.top=querytb.bottom;
    }];
    [self autoMovekeyBoard:height tableIsLast:YES];
}
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        querytb.height = (kScreenHeight-0-moreView.height);
        moreView.top=querytb.bottom;
    }];
    [self autoMovekeyBoard:0 tableIsLast:NO];
}
//调整键盘高度
-(void) autoMovekeyBoard: (float) h tableIsLast:(BOOL) isLast{

    NSLog(@"==========%@",@(h));
   
    if(isLast){//发送框获取焦点时 移到最后一行记录
        if([querylist count]>0){
            [querytb scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[querylist count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}
#pragma mark-------------发送信息--------------
-(void)sendMsgSEL{
    if (![Tools isBlankString:textView.text]) {
        [self network:@"SsGdServices" requestMethod:@"insertChat" requestHasParams:@"true" parameter:@{@"intfsrlsh":intfsrlsh,@"intjsrlsh":intjsrlsh,@"jsrxm":jsrxm,@"fsrxm":fsrxm,@"nr":textView.text} progresHudText:@"发送中..." completionBlock:^(id rep) {
            if (rep!=nil) {
                textView.text=@"";
                [self queryChatxq:YES];
                if (self.callback) {
                    self.callback(YES);
                }
            }
        }];
    }else
    {
        [self showMessage:@"请输入发送信息"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
