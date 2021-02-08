//
//  LBParallelProcessViewController.m
//  dtgh
//并行多个分流程
//

#import "LBParallelProcessViewController.h"
#import "LBPersonTreeViewController.h"
#import "LBTaskModel.h"
#import "LBAgentsViewController.h"

@interface LBParallelProcessViewController ()<LBPersonTreeViewControllerDelegate>
@property(nonatomic, strong, readonly) MyBaseLayout *rootLayout;
@property(nonatomic, strong, readonly) MyLinearLayout *resultLayout;
@property(nonatomic,strong) NSMutableDictionary *userinfodic;
@property(nonatomic,strong)UIButton *followTaskBtn;
@property(nonatomic,copy)NSString* intlcbh;//流程编号
@property(nonatomic,strong)NSMutableDictionary* taskResult;//选择的任务，key为流程编号
@property(nonatomic,strong)NSMutableDictionary* personResult;//选择的人员，key为流程编号
@end

@implementation LBParallelProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskResult = [[NSMutableDictionary alloc]init];
    _personResult = [[NSMutableDictionary alloc]init];
    _userinfodic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    [self loadView];
}

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIScrollView *scrollView = [UIScrollView new];
    [scrollView setBackgroundColor:[SingleObj defaultManager].backColor];
    self.view = scrollView;
    
    _rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootLayout.padding = UIEdgeInsetsMake(20, 20, 0, 20);
    _rootLayout.leadingPos.equalTo(@0);
    _rootLayout.trailingPos.equalTo(@0);
    _rootLayout.wrapContentHeight = YES;
    [scrollView addSubview:_rootLayout];
    
    //下步任务
    UILabel* followTask = [UILabel new];
    followTask.text = @"下步任务：";
    followTask.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    followTask.textColor = [UIColor darkTextColor];
    followTask.rightPos.equalTo(_rootLayout.rightPos);
    followTask.leftPos.equalTo(_rootLayout.leftPos);
    [followTask sizeToFit];
    [_rootLayout addSubview:followTask];
    
    _followTaskBtn = [[UIButton alloc]init];
    _followTaskBtn.showsTouchWhenHighlighted=YES;
    _followTaskBtn.rightPos.equalTo(_rootLayout.rightPos);
    _followTaskBtn.leftPos.equalTo(_rootLayout.leftPos);
    _followTaskBtn.myTop = 10;
    _followTaskBtn.wrapContentHeight = YES;
    _followTaskBtn.userInteractionEnabled = YES;
    [_followTaskBtn setTitle:@"请选择下步任务" forState:UIControlStateNormal];

    [_followTaskBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    _followTaskBtn.backgroundColor = [UIColor whiteColor];
    [_followTaskBtn addTarget:self action:@selector(selectTask:) forControlEvents:UIControlEventTouchUpInside];
    [_rootLayout addSubview:_followTaskBtn];
    
    //下步处理人
    UILabel* followPerson = [UILabel new];
    followPerson.text = @"下步处理人：";
    followPerson.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    followPerson.textColor = [UIColor darkTextColor];
    followPerson.rightPos.equalTo(_rootLayout.rightPos);
    followPerson.leftPos.equalTo(_rootLayout.leftPos);
    followPerson.myTop = 20;
    [followPerson sizeToFit];
    [_rootLayout addSubview:followPerson];
    
    UIButton *followPersonBtn = [[UIButton alloc]init];
    followPersonBtn.showsTouchWhenHighlighted=YES;
    followPersonBtn.rightPos.equalTo(_rootLayout.rightPos);
    followPersonBtn.leftPos.equalTo(_rootLayout.leftPos);
    followPersonBtn.myTop = 10;
    followPersonBtn.wrapContentHeight = YES;
    followPersonBtn.userInteractionEnabled = YES;
    [followPersonBtn setTitle:@"请选择下步处理人" forState:UIControlStateNormal];
    [followPersonBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    followPersonBtn.backgroundColor = [UIColor whiteColor];
    [followPersonBtn addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
    [_rootLayout addSubview:followPersonBtn];
    
    //已选择的结果展示布局
    _resultLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _resultLayout.topPos.equalTo(@30);
    _resultLayout.leftPos.equalTo(_rootLayout.leftPos);
    _resultLayout.rightPos.equalTo(_rootLayout.rightPos);
    _resultLayout.wrapContentHeight = YES;
    [_rootLayout addSubview:_resultLayout];
    
    //操作布局
    MyLinearLayout *handleLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    handleLayout.topPos.equalTo(@30);
    handleLayout.leftPos.equalTo(_rootLayout.leftPos);
    handleLayout.rightPos.equalTo(_rootLayout.rightPos);
    handleLayout.wrapContentHeight = YES;
    UIButton *reset = [[UIButton alloc]init];//重置按钮
    reset.showsTouchWhenHighlighted=YES;
    reset.weight = 1;
    reset.myRight = 10;
    reset.wrapContentHeight = YES;
    reset.backgroundColor = [UIColor redColor];
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
    [handleLayout addSubview:reset];
    
    UIButton *submit = [[UIButton alloc]init];//提交按钮
    submit.showsTouchWhenHighlighted=YES;
    submit.weight = 1;
    submit.wrapContentHeight = YES;
    submit.myLeft = 10;
    submit.backgroundColor = [UIColor greenColor];
    [submit setTitle:@"确认" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [handleLayout addSubview:submit];
    [_rootLayout addSubview:handleLayout];
}


/**
 选择下步任务
 */
-(void)selectTask:(UIButton*)sender
{
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeClear];
    //查询接口获取下步任务数据
    [SHNetWork getQuickbw:[_userinfodic objectForKey:@"intdwlsh"] :[_savedic objectForKey:@"intlcczlsh"] completionBlock:^(id rep, NSString *emsg) {
        if (!emsg) {
            NSLog(@"%@",rep);
            [SVProgressHUD dismiss];
            if ([[rep objectForKey:@"flag"] intValue]==0) {
                NSArray *arr =  [rep objectForKey:@"data"];
                [self showDialog:arr];
            }
            else
            {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:emsg];
        }
    }];
}


/**
 显示选中下步任务对话框
 */
-(void)showDialog:(NSArray*)arr
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSMutableDictionary *dic in arr) {
        [actionSheetController addAction:[UIAlertAction actionWithTitle: [dic objectForKey:@"strgzrw"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LBTaskModel *taskModel = [LBTaskModel mj_objectWithKeyValues:dic];
            _intlcbh = taskModel.intlcbh;
            //首先判断任务集合中是否已经存在了该任务，如果存在则不用重复加入
            if(![[_taskResult allKeys] containsObject:_intlcbh])
            {
                [_taskResult setObject:taskModel forKey:_intlcbh];
                _followTaskBtn.titleLabel.text = taskModel.strgzrw;
            }
        }]];
    }
    [self presentViewController:actionSheetController animated:YES completion:nil];
}


/**
 选择下步处理人
 */
-(void)selectPerson:(UIButton*)sender
{
    
    //选择下步处理人之前必须先选择下步任务
    if(_taskResult.count!=0)
    {
        LBPersonTreeViewController *lbsendlinder=[[LBPersonTreeViewController alloc]init];
        lbsendlinder.title= @"选择处理人";
        lbsendlinder.savedic=_savedic;
        
        [lbsendlinder.savedic setObject:_intlcbh forKey:@"intlcbh"];
        lbsendlinder.lint=2;
        lbsendlinder.bzlcint=_lint;
        lbsendlinder.delegate = self;
        [self.navigationController pushViewController:lbsendlinder animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择下步任务！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/**
 重置
 */
-(void)reset:(UIButton*)sender
{
    //将结果集清除
     [_followTaskBtn setTitle:@"请选择下步任务" forState:UIControlStateNormal];
    [_taskResult removeAllObjects];
    [_personResult removeAllObjects];
    _intlcbh = nil;
    [_resultLayout removeAllSubviews];
    
}


/**
 提交
 */
-(void)submit:(UIButton*)sender
{
    [SVProgressHUD showWithStatus:@"数据提交中..." maskType:SVProgressHUDMaskTypeClear];
    //根据intlcbh获取下步任务数据和下步处理人数据
    NSString* strczrxm = [_userinfodic objectForKey:@"strryxm"];
    NSString* intgwlzlsh = [[NSString alloc]init];
    NSMutableString *intbcbhlst = [[NSMutableString alloc]initWithCapacity:10];
    NSString* intbzjllsh = [[NSString alloc]init];
    NSString* intlcczlsh = [[NSString alloc]init];
    NSMutableString *intgzlclshlst = [[NSMutableString alloc]initWithCapacity:10];
    NSMutableString *strzrrlxLst = [[NSMutableString alloc]initWithCapacity:10];
    NSString* intczrylsh = [[NSString alloc]init];
    NSMutableString *intrylshlst = [[NSMutableString alloc]initWithCapacity:10];
    NSMutableString *intbzlst = [[NSMutableString alloc]initWithCapacity:10];
    NSMutableString *strlzlxlst = [[NSMutableString alloc]initWithCapacity:10];
    NSString* intnextgzrylsh = [[NSString alloc]init];
    NSMutableString *intlcdylshlst = [[NSMutableString alloc]initWithCapacity:10];
    NSString* strnextgzrylx = [[NSString alloc]init];
    NSString* intnextgzlclsh = [[NSString alloc]init];
    
    if(_taskResult.allKeys.count == _personResult.allKeys.count){
        for (NSString* intlcbh in _taskResult.allKeys) {
            LBTaskModel* taskModel =  [_taskResult objectForKey:intlcbh];
            LBPersonModel* personModel = [_personResult objectForKey:intlcbh];
            intgwlzlsh = personModel.intgwlzlsh;
            [intbcbhlst appendString:personModel.intbcbhlst];
            intbzjllsh = personModel.intbzjllsh;
            intlcczlsh = personModel.intlcczlsh;
            [intgzlclshlst appendString:personModel.intgzlclshlst];
            [strzrrlxLst appendString:personModel.strzrrlxLst];
            intczrylsh = personModel.intczrylsh;
            [intrylshlst appendString:personModel.intrylshlst];
            [intbzlst appendString:personModel.intbzlst];
            [strlzlxlst appendString:personModel.strlzlxlst];
            intnextgzrylsh = personModel.intnextgzrylsh;
            [intlcdylshlst appendString:personModel.intlcdylshlst];
            strnextgzrylx = personModel.strnextgzrylx;
            intnextgzlclsh = personModel.intnextgzlclsh;
        }
    }
     [SHNetWork submitQuickbw:intbzjllsh :intczrylsh :intnextgzlclsh :strczrxm :intnextgzrylsh :intbcbhlst :intgzlclshlst :strlzlxlst :intlcczlsh :intrylshlst :intgwlzlsh :intbzlst :intlcdylshlst :strnextgzrylx :strzrrlxLst  completionBlock:^(id rep, NSString *emsg) {
         if (!emsg) {
             NSLog(@"%@",rep);
             [SVProgressHUD dismiss];
             if ([[rep objectForKey:@"flag"] intValue]==0) {
                [SVProgressHUD showSuccessWithStatus:@"操作成功"];
                [self performSelector:@selector(gogo) withObject:nil afterDelay:1.0];
             }
             else
             {
                 [SVProgressHUD dismiss];
                 [SVProgressHUD showErrorWithStatus:[rep objectForKey:@"msg"]];
             }
         }
         else
         {
             [SVProgressHUD dismiss];
             [SVProgressHUD showErrorWithStatus:emsg];
         }
     }];
    
    
}

-(void)gogo
{
    for (id views in self.navigationController.viewControllers) {
        if ([views isKindOfClass:[LBAgentsViewController class]]) {
            LBAgentsViewController *lbagents=views;
            [self.navigationController popToViewController:views animated:YES];
            [lbagents updata];
        }
    }
}


/**
 实现代理方法

 @param Vc
 @param person 选择处理人的结果
 */
-(void)personTreeViewController:(LBPersonTreeViewController *)Vc didClickedButtonWithPerson:(LBPersonModel *)person
{
    //获取的处理人信息存入结果集中
    [_personResult setObject:person forKey:_intlcbh];
    LBTaskModel* taskModel = [_taskResult objectForKey:_intlcbh];
    //遍历结果布局,如果布局中已经存在选择的结果则进行修改操作，不在进行插入操作
    for (UILabel* resultLabel in [_resultLayout subviews]) {
        if([resultLabel tag] == [_intlcbh integerValue]){
            resultLabel.text = [NSString stringWithFormat:@"%@:%@", taskModel.strgzrw, person.names ];
            return;
        }
    }
    UILabel* resultLabel = [UILabel new];
    //将流程编号设作为tag，用来区分结果布局进行修改操作，还是插入操作
    [resultLabel setTag:[_intlcbh integerValue]];
    resultLabel.text = [NSString stringWithFormat:@"%@:%@", taskModel.strgzrw, person.names ];
    [_followTaskBtn setTitle:taskModel.strgzrw forState:UIControlStateNormal];
    
    resultLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:18];
    resultLabel.textColor = [UIColor darkTextColor];
    resultLabel.rightPos.equalTo(_rootLayout.rightPos);
    resultLabel.leftPos.equalTo(_rootLayout.leftPos);
    resultLabel.myTop = 20;
    resultLabel.wrapContentHeight = YES;
    [resultLabel sizeToFit];
    [_resultLayout addSubview:resultLabel];

}


@end
