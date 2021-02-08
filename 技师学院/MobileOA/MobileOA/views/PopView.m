//
//  PopView.m
//  Arfa
//
//  Created by 熊佳佳 on 16/8/24.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "PopView.h"
@interface PopView ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableViewT;
     UIView *view_userContact;
}
@end
@implementation PopView
@synthesize titles;
- (id)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self=[super initWithFrame:frame];
    if (self) {
        titles =title;
        self.sourceary=[[NSArray alloc]init];
        // Initialization code
        self.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
        UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame=frame;
        [closeBtn addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        view_userContact=[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-270)/2.0, -300, 270, 256)];
        view_userContact.clipsToBounds=YES;
        [self addSubview:view_userContact];
        view_userContact.backgroundColor=[UIColor whiteColor];
        view_userContact.layer.masksToBounds = YES;
        view_userContact.layer.cornerRadius =10;
        
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
#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableViewT.width, 44)];
    headView.backgroundColor=RGBCOLOR(52, 129, 194);
    UILabel *lblT=[[UILabel alloc]initWithFrame:CGRectMake(X(headView), Y(headView)+12, W(headView), 20)];
    lblT.backgroundColor=[UIColor clearColor];
    lblT.textAlignment=NSTextAlignmentCenter;
    lblT.textColor=[UIColor whiteColor];
    lblT.font=Font(18);
    [headView addSubview:lblT];
    lblT.text=titles;
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"myUITableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *bgViewse=[[UIView alloc]initWithFrame:cell.bounds];
        bgViewse.backgroundColor=[UIColor clearColor];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, bgViewse.height-0.5, bgViewse.width, 0.5);
        bottomBorder.backgroundColor = UIColorFromRGB(0xcacbcc).CGColor;
        [bgViewse.layer addSublayer:bottomBorder];
        UIImageView *selectImg=[[UIImageView alloc]initWithImage:PNGIMAGE(@"select")];
        selectImg.right=270-10;
        selectImg.centerY=bgViewse.height/2.0;
        [bgViewse addSubview:selectImg];
        selectImg.hidden=self.isHide;
        [cell setSelectedBackgroundView:bgViewse];
        UILabel *onelb=[[UILabel alloc]initWithFrame:CGRectMake(0, 49, 270, 0.5)];
        [onelb setBackgroundColor:UIColorFromRGB(0xcacbcc)];
        [cell addSubview:onelb];
    }
    NSString *strlmmc=@"";
    if ([self.key isEqualToString:@"Str"]) {
        strlmmc= [self.sourceary objectAtIndex:indexPath.row];
    }else if ([self.key isEqualToString:@"type1"]) {
        strlmmc= [self.sourceary objectAtIndex:indexPath.row][@"type"];
    }else
    {
        strlmmc= [[self.sourceary objectAtIndex:indexPath.row] objectForKey:self.key];
    }
    cell.textLabel.text=strlmmc;
    cell.textLabel.highlightedTextColor=RGBCOLOR(0, 0, 0);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callback) {
        self.callback((int)indexPath.row,self.key);
    }
    [self hidden];
}
#pragma mark------------显示视图------------------
- (void)show
{
    float tempF=(self.sourceary.count) * 50.0+44;
    if (self.sourceary.count>5) {
        tempF=4*50.0;
    }
    float tempY=tempF>(kScreenHeight-100)?(kScreenHeight-100):tempF;
    view_userContact.frame=CGRectMake(view_userContact.left, - tempY, view_userContact.width,tempY);
    DLog(@"____________%f",tempY);
    [tableViewT reloadData];
    if (self.sourceary.count && self.selectRowIndex<self.sourceary.count) {
        [tableViewT selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRowIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1.0f;
                         view_userContact.top=(kScreenHeight-view_userContact.height)/2.0+20;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
#pragma mark------------隐藏显示------------------
- (void)hidden
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view_userContact.top= -H(view_userContact);
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.hidden = YES;
                         
                     }];
    
}
#pragma mark-----------取消按钮-------------
-(void)closeButtonClicked{
    [self hidden];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
