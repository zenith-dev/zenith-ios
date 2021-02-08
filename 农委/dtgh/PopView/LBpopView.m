//
//  LBpopView.m
//  dtgh
//
//  Created by 熊佳佳 on 15/11/23.
//  Copyright © 2015年 熊佳佳. All rights reserved.
//

#import "LBpopView.h"
#import "AppDelegate.h"
@interface LBpopView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *view_userContact;
    UITableView *tableViewT;
    UILabel *lblT;
    UIView *headView;
}
@end
@implementation LBpopView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=frame;
        [closeBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        view_userContact=[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-270)/2, -300, 270, 256)];
        view_userContact.clipsToBounds=YES;
        [self addSubview:view_userContact];
        view_userContact.backgroundColor=[UIColor clearColor];
        view_userContact.layer.masksToBounds = YES;
        view_userContact.layer.cornerRadius =10;
        [view_userContact setBackgroundColor:[SingleObj defaultManager].backColor];
        //table
        tableViewT=[[UITableView alloc]initWithFrame:CGRectMake(view_userContact.bounds.origin.x, view_userContact.bounds.origin.y, view_userContact.bounds.size.width, view_userContact.bounds.size.height) style:UITableViewStylePlain];
        [tableViewT setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        tableViewT.delegate=self;
        tableViewT.dataSource = self;
        tableViewT.backgroundColor=[UIColor clearColor];
        [tableViewT setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [view_userContact addSubview:tableViewT];
    }
    return self;
}
#pragma mark-----------取消按钮-------------
-(void)closeButtonClicked{
    [self hidden];
}
#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!headView) {
        headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, W(view_userContact), 44)];
        headView.backgroundColor=[SingleObj defaultManager].mainColor;
        lblT=[[UILabel alloc]initWithFrame:CGRectMake(X(headView), Y(headView)+12, W(headView), 20)];
        lblT.backgroundColor=[UIColor clearColor];
        lblT.textAlignment=NSTextAlignmentCenter;
        lblT.textColor=[UIColor whiteColor];
        lblT.font=Font(18);
        [headView addSubview:lblT];
    }
    lblT.text=self.popTitle;
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.popArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    NSDictionary *dic=[self.popArray objectAtIndex:indexPath.row];
    identifier= dic.description;
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *bgViewse=[[UIView alloc]initWithFrame:cell.bounds];
        bgViewse.backgroundColor=[UIColor clearColor];
        [bgViewse addSubview:[Tools imageviewWithFrame:CGRectMake(230, 16, 11, 11) defaultimage:@"userAddGroup"]];
        [cell setSelectedBackgroundView:bgViewse];
        NSString *strlmmc=@"";
        if ([self.popType isEqualToString:@"gwzh"])
        {
            strlmmc=[[self.popArray objectAtIndex:indexPath.row] objectForKey:@"strgwz"];
        }
        else if ([self.popType isEqualToString:@"nh"])
        {
            strlmmc=[[[self.popArray objectAtIndex:indexPath.row] objectForKey:@"nh"] stringValue];
        }
        else if ([self.popType isEqualToString:@"ylqh"])
        {
            strlmmc=[[self.popArray objectAtIndex:indexPath.row] objectForKey:@"intgwqh"];
        }else if ([self.popType isEqualToString:@"fwms"])
        {
            strlmmc=[[self.popArray objectAtIndex:indexPath.row] objectForKey:@"kname"];
        }
        UILabel *lblTitle=[Tools labelWithFrame:CGRectMake(20, 15, 270, 20) font:[UIFont systemFontOfSize:15] color:RGBCOLOR(0, 0, 0) text:strlmmc];
        [lblTitle setHighlightedTextColor:RGBCOLOR(0, 0, 0)];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:lblTitle];
        [cell addSubview:[Tools imageviewWithFrame:CGRectMake(0, 49, 270, 1) defaultimage:@"通讯录分割线.png"]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate getIndexRow:(int)indexPath.row warranty:self.popType];
    [self hidden];
}

#pragma mark------------显示视图------------------
- (void)show
{
    float tempF=(self.popArray.count) * 50.0+44;
    if (self.popArray.count>5) {
        tempF=4*50.0;
    }
    float tempY=tempF>(kScreenHeight-100)?(kScreenHeight-100):tempF;
    view_userContact.frame=CGRectMake(25, - tempY, 270,tempY);
    DLog(@"____________%f",tempY);
    [tableViewT reloadData];
    if (self.popArray.count && self.selectRowIndex<self.popArray.count) {
        [tableViewT selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRowIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    [[AppDelegate Share].window addSubview:self];
    //[[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                         [view_userContact setFrame:CGRectMake(X(view_userContact), (kScreenHeight-H(view_userContact))/2+20, W(view_userContact), H(view_userContact))];
                         
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:0
                                          animations:^{
                                              [view_userContact setFrame:CGRectMake(X(view_userContact), (kScreenHeight-H(view_userContact))/2, W(view_userContact), H(view_userContact))];
                                          }
                                          completion:nil];
                     }];
}
#pragma mark------------隐藏显示------------------
- (void)hidden
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:0
                     animations:^{
                         [view_userContact setFrame:CGRectMake(X(view_userContact), (kScreenHeight-H(view_userContact))/2+20, W(view_userContact), H(view_userContact))];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              [view_userContact setFrame:CGRectMake(X(view_userContact), -H(view_userContact), W(view_userContact), H(view_userContact))];
                                              self.alpha = 0.0;
                                          }
                                          completion:^(BOOL finished) {
                                              self.hidden = YES;
                                              
                                          }];
                     }];
}

@end
