//
//  ztOAAddressBookDetailInfoViewController.m
//  OAMobileIOS
//
//  Created by 陈杨 on 14-5-13.
//  Copyright (c) 2014年 chenyang. All rights reserved.
//

#import "ztOAAddressBookDetailInfoViewController.h"

@interface ztOAAddressBookDetailInfoViewController ()
{
    ztOAABModel *addressBookInfo;
}
@property(nonatomic,strong)UIImageView  *memberheadImg;
@property(nonatomic,strong)UILabel      *memberNameLable;
@property(nonatomic,strong)UILabel      *memberCompanyNameLable;
@property(nonatomic,strong)UILabel      *memberJobNameLable;
@property(nonatomic,strong)UILabel      *memberMobileNumLable;
@property(nonatomic,strong)UILabel      *memberCompanyNumLable;
@property(nonatomic,strong)UIButton     *memberMobileCallBtn;
@property(nonatomic,strong)UIButton     *memberMobileMessageBtn;
@property(nonatomic,strong)UIButton     *memberCompanyCallBtn;
@property(nonatomic,strong)UIButton     *memberCompanyMessageBtn;

@property(nonatomic,strong)UIButton     *loadingToPhone;
@end

@implementation ztOAAddressBookDetailInfoViewController
@synthesize memberheadImg,memberNameLable,memberJobNameLable,memberCompanyNameLable,memberMobileNumLable,memberMobileCallBtn,memberMobileMessageBtn,memberCompanyCallBtn,memberCompanyMessageBtn,memberCompanyNumLable,loadingToPhone;
- (id)initWithBook:(ztOAABModel *)addressBook
{
    self = [super init];
    if (self) {
        addressBookInfo = addressBook;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //头像
    self.memberheadImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"contact_default_avatar"]];
    memberheadImg.frame = CGRectMake(10, 64+20, 65, 65);
    memberheadImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:memberheadImg];
    //姓名
    self.memberNameLable = [[UILabel alloc] initWithFrame:CGRectMake(20+65, 64+20,self.view.width-20-65-10, 20)];
    memberNameLable.backgroundColor = [UIColor clearColor];
    memberNameLable.font = [UIFont systemFontOfSize:14.0f];
    memberNameLable.text = addressBookInfo.strxm;
    [self.view addSubview:memberNameLable];
    //办公室名称
    self.memberCompanyNameLable = [[UILabel alloc] initWithFrame:CGRectMake(20+65, 64+20+30,self.view.width-20-65-10, 20)];
    memberCompanyNameLable.backgroundColor = [UIColor clearColor];
    memberCompanyNameLable.font = [UIFont systemFontOfSize:12.0f];
    memberCompanyNameLable.text = addressBookInfo.strdw;
    [self.view addSubview:memberCompanyNameLable];
    //职务
    self.memberJobNameLable = [[UILabel alloc] initWithFrame:CGRectMake(20+65, 64+25+25+20,self.view.width-20-65-10, 20)];
    memberJobNameLable.backgroundColor = [UIColor clearColor];
    memberJobNameLable.font = [UIFont systemFontOfSize:12.0f];
    memberJobNameLable.text = addressBookInfo.strzw;
    [self.view addSubview:memberJobNameLable];
    
    UIImageView *lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(10, memberheadImg.bottom+20, self.view.width-20, 1)];
    lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
    [self.view addSubview:lineBreak];
    ztOAAddressBookDetailInfoViewController *_self = self;
    ztOAABModel *_addressBookInfo = addressBookInfo;
    //移动电话
    if (![addressBookInfo.stryddh isEqualToString:@""]) {
        self.memberMobileNumLable = [[UILabel alloc] initWithFrame:CGRectMake(20, self.memberheadImg.bottom+40,self.view.width-40-80, 20)];
        memberMobileNumLable.backgroundColor = [UIColor clearColor];
        memberMobileNumLable.font = [UIFont systemFontOfSize:14.0f];
        memberMobileNumLable.text = addressBookInfo.stryddh;
        [self.view addSubview:memberMobileNumLable];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, memberMobileNumLable.bottom, memberMobileNumLable.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.text = @"移动电话";
        [self.view addSubview:label];
        
        self.memberMobileMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberMobileMessageBtn.backgroundColor = [UIColor clearColor];
        [memberMobileMessageBtn setImage:[UIImage imageNamed:@"msg_icon"] forState:UIControlStateNormal];
        memberMobileMessageBtn.frame =  CGRectMake(memberMobileNumLable.right+5, 5+memberMobileNumLable.origin.y, 30, 30);
        [memberMobileMessageBtn addEventHandler:^(id sender){
            [_self sendSMS:@"" recipientList:[NSArray arrayWithObjects:_addressBookInfo.stryddh, nil]];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:memberMobileMessageBtn];
        
        self.memberMobileCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberMobileCallBtn.backgroundColor = [UIColor clearColor];
        [memberMobileCallBtn setImage:[UIImage imageNamed:@"call_icon"] forState:UIControlStateNormal];
        memberMobileCallBtn.frame = CGRectMake(memberMobileMessageBtn.right+15, memberMobileMessageBtn.origin.y, 30, 30);
        [self.view addSubview:memberMobileCallBtn];
        [memberMobileCallBtn addEventHandler:^(id sender){
            [_self toCallPhotoNumber:_addressBookInfo.stryddh];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        
        lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(10, memberMobileNumLable.bottom+30, self.view.width-20, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.view addSubview:lineBreak];
    }
    
    
    //办公室电话
    if (![addressBookInfo.strbgdh isEqualToString:@""]) {
        self.memberCompanyNumLable = [[UILabel alloc] initWithFrame:CGRectMake(20 , lineBreak.bottom+20,self.view.width-40-80, 20)];
        memberCompanyNumLable.backgroundColor = [UIColor clearColor];
        memberCompanyNumLable.font = [UIFont systemFontOfSize:14.0f];
        memberCompanyNumLable.text = addressBookInfo.strbgdh;
        [self.view addSubview:memberCompanyNumLable];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, memberCompanyNumLable.bottom, memberCompanyNumLable.width, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.text = @"办公室电话";
        [self.view addSubview:label];
        
        self.memberCompanyCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberCompanyCallBtn.backgroundColor = [UIColor clearColor];
        [memberCompanyCallBtn setImage:[UIImage imageNamed:@"call_icon"] forState:UIControlStateNormal];
        memberCompanyCallBtn.frame = CGRectMake(memberCompanyNumLable.right+5+30+15, 5+memberCompanyNumLable.origin.y, 30, 30);
        //__block ztOAAddressBookDetailInfoViewController *vc = self;
        [memberCompanyCallBtn addEventHandler:^(id sender){
            [_self toCallPhotoNumber:_addressBookInfo.strbgdh];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:memberCompanyCallBtn];
        
        self.memberCompanyMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        memberCompanyMessageBtn.backgroundColor = [UIColor clearColor];
        [memberCompanyMessageBtn setImage:[UIImage imageNamed:@"msg_icon"] forState:UIControlStateNormal];
        memberCompanyMessageBtn.frame = CGRectMake(memberCompanyCallBtn.right+15, 5+memberCompanyNumLable.origin.y, 30, 30);
        [memberCompanyMessageBtn addEventHandler:^(id sender){
            [_self sendSMS:@"" recipientList:[NSArray arrayWithObjects:_addressBookInfo.strbgdh, nil]];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:memberCompanyMessageBtn];
        [memberCompanyMessageBtn setHidden:YES];//办公电话不能发信息
        
        lineBreak = [[UIImageView alloc] initWithFrame:CGRectMake(10, memberCompanyNumLable.bottom+40, self.view.width-20, 1)];
        lineBreak.backgroundColor = MF_ColorFromRGB(234, 234, 234);
        [self.view addSubview:lineBreak];
    }
    
    if ([addressBookInfo.stryddh isEqualToString:@""] && [addressBookInfo.strbgdh isEqualToString:@""]) {
        //无电话数据
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, lineBreak.bottom+20, self.view.width-40, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无信息";
        [self.view addSubview:label];
        
    }
    else
    {
        //导入手机
        UIImageView *loadToPhIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, lineBreak.bottom+20, 30, 30)];
        loadToPhIcon.backgroundColor = [UIColor clearColor];
        loadToPhIcon.image = [UIImage imageNamed:@"contact_import_icon"];
        [self.view addSubview:loadToPhIcon];
        
        self.loadingToPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        loadingToPhone.backgroundColor = [UIColor clearColor];
        loadingToPhone.frame = CGRectMake(20+30, lineBreak.bottom+20, 120, 30);
        [loadingToPhone setTitle:@"导入手机通讯录" forState:UIControlStateNormal];
        [loadingToPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [loadingToPhone setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [loadingToPhone.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [loadingToPhone addEventHandler:^(id sender){
            [_self doLoadToPhone:[NSMutableArray arrayWithObjects:_addressBookInfo, nil]];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loadingToPhone];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
