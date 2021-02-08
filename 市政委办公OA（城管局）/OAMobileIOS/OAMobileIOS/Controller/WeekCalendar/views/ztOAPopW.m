//
//  ztOAPopW.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/3/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ztOAPopW.h"

@implementation ztOAPopW
- (id)initWithFrame:(CGRect)frame a:(NSString*)strHeader
{
    self = [super initWithFrame:frame];
    if (self) {
        self.strHeader=strHeader;
        // Initialization code
        self.backgroundColor= MF_ColorFromRGBA(0, 0, 0, 0.4);
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

        UIImageView *bg=[self imageviewWithFrame:view_userContact.bounds defaultimage:@"selectTypeCellBG.png" stretchW:20 stretchH:11];
        [bg setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [view_userContact addSubview:bg];
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
#pragma mark------------显示视图------------------
- (void)show
{
    float tempF=(self.popArray.count) * 50.0+44;
    if (self.popArray.count>5) {
        tempF=4*50.0;
    }
    float tempY=tempF>(kScreenHeight-100)?(kScreenHeight-100):tempF;
    view_userContact.frame=CGRectMake(25, - tempY, 270,tempY);
    [tableViewT reloadData];
    if (self.popArray.count && self.selectRowIndex<self.popArray.count) {
        [tableViewT selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRowIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:self];
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
#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!headView) {
        headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, W(view_userContact), 44)];
        headView.backgroundColor=MF_ColorFromRGB(52, 129, 194);
        
        lblT=[[UILabel alloc]initWithFrame:CGRectMake(X(headView), Y(headView)+12, W(headView), 20)];
        lblT.backgroundColor=[UIColor clearColor];
        lblT.textAlignment=NSTextAlignmentCenter;
        
        lblT.textColor=[UIColor whiteColor];
        lblT.font=Font(18);
        [headView addSubview:lblT];
    }
    lblT.text=self.strHeader;
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.popArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    NSDictionary *dic=[self.popArray objectAtIndex:indexPath.row];
    identifier= dic.description;//@"tableMessageCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *bgViewse=[[UIView alloc]initWithFrame:cell.bounds];
        bgViewse.backgroundColor=[UIColor clearColor];
        [bgViewse addSubview:[self imageviewWithFrame:CGRectMake(230, 16, 11, 11) defaultimage:@"userAddGroup" stretchW:0 stretchH:0]];
        [cell setSelectedBackgroundView:bgViewse];
        NSString *strlmmc=@"";
        if ([self.popType isEqualToString:@"intldid"]) {
            strlmmc= [[self.popArray objectAtIndex:indexPath.row] objectForKey:@"chrldxm"];
        }
        UILabel *lblTitle=[self labelWithFrame:CGRectMake(20, 15, 270, 20) font:[UIFont systemFontOfSize:15] color:MF_ColorFromRGB(0, 0, 0) text:strlmmc];
        [lblTitle setHighlightedTextColor:MF_ColorFromRGB(0, 0, 0)];
        [lblTitle setTextAlignment:NSTextAlignmentLeft];
        [cell addSubview:lblTitle];
        UIImageView *onelineImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49, 270, 1)];
        [onelineImg setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell addSubview:onelineImg];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate getIndexRow:(int)indexPath.row value:self.popType];
    [self hidden];
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

//-1 if want stretch half of image.size
-(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h
{
    UIImageView *imageview = nil;
    if(_image){
        if (_w&&_h) {
            UIImage *image = [UIImage imageNamed:_image];
            if (_w==-1) {
                _w = image.size.width/2;
            }
            if(_h==-1){
                _h = image.size.height/2;
            }
            imageview = [[UIImageView alloc] initWithImage:
                         [image stretchableImageWithLeftCapWidth:_w topCapHeight:_h]];
        }else{
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_image]];
        }
    }
    if (CGRectIsEmpty(_frame)) {
        [imageview setFrame:CGRectMake(_frame.origin.x,_frame.origin.y, imageview.image.size.width, imageview.image.size.height)];
    }else{
        [imageview setFrame:_frame];
    }
    return  imageview;// autorelease];
}
/**
 *	根据aframe返回相应高度的label（默认透明背景色，白色高亮文字）
 *
 *	@param	aframe	预期框架 若height=0则计算高度  若width=0则计算宽度
 *	@param	afont	字体
 *	@param	acolor	颜色
 *	@param	atext	内容
 *
 *	@return	UILabel
 */
- (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
{
    UILabel *baseLabel=[[UILabel alloc] initWithFrame:aframe];
    if(afont)baseLabel.font=afont;
    if(acolor)baseLabel.textColor=acolor;
    baseLabel.lineBreakMode=NSLineBreakByWordWrapping;
    baseLabel.text=atext;
    baseLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
    if(aframe.size.height>20){
        baseLabel.numberOfLines=0;
    }
    if (!aframe.size.height) {
        baseLabel.numberOfLines=0;
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(aframe.size.width, MAXFLOAT)];
        aframe.size.height = size.height;
        baseLabel.frame = aframe;
    }else if (!aframe.size.width) {
        CGSize size = [baseLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
        aframe.size.width = size.width;
        baseLabel.frame = aframe;
    }
    baseLabel.backgroundColor=[UIColor clearColor];
    baseLabel.highlightedTextColor=[UIColor whiteColor];
    return baseLabel;// autorelease];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
