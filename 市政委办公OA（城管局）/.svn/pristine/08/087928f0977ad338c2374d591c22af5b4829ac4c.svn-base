//
//  ZMOFjView.m
//  libztmobileoaapi
//
//  Created by 陈 也 on 14-3-4.
//  Copyright (c) 2014年 陈 也. All rights reserved.
//

#import "ZMOFjView.h"

@implementation ZMOFjView{
    NSMutableArray *_array;
    NSDictionary *gwfjxx;
    UIButton *btnGg;
    UIButton *btnSc;
    UIButton *btnCx;
    NSString *url;
    NSString *port;
    NSString *path;
    NSString *method;
    NSString *class;
    NSString *fjlshKey;//查看调用接口参数附件流水号对应名称
    FilePlugin *filePlugin;
    NSString *_typeShow;
    NSString *_fjlshKeyStr;//获取附件数组里面的附件流水号key
    BOOL _isGg;
}
@synthesize fjTableView = _fjTableView;
@synthesize viewController = _viewController;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)fjArray
{
    self = [super initWithFrame:frame];
    if (self) {
        filePlugin = [FilePlugin alloc];
        filePlugin.delegate = self;
        
        _array = fjArray;
        _fjTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        _fjTableView.scrollEnabled = NO;
        _fjTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _fjTableView.backgroundColor = [UIColor clearColor];
        _fjTableView.delegate = self;
        _fjTableView.dataSource = self;
        [self addSubview:_fjTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)fjArray
               isGg:(BOOL)isGg
               jbxx:(NSDictionary *)jbxx
            withUrl:(NSString *)aUrl
            andPort:(NSString *)aPort
            andPath:(NSString *)aPath
          andMethod:(NSString *)aMethod
           andClass:(NSString *)aClass
        andFjlshKey:(NSString *)aFjlshKey
           typeShow:(NSString *)typeShow
     andFjlshKeyStr:(NSString *)fjlshKeyStr
{
    gwfjxx = jbxx;
    _isGg = isGg;
    url = aUrl;
    port = aPort;
    path = aPath;
    method = aMethod;
    class = aClass;
    fjlshKey = aFjlshKey;
    _typeShow = typeShow;
    _fjlshKeyStr = fjlshKeyStr;
    return [self initWithFrame:frame data:fjArray];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_typeShow isEqualToString:@"1"]) {
        if (_array.count>1) {
            return 2;
        }
        else
        {
            return 1;
        }
        
    }
    else if ([_typeShow isEqualToString:@"2"])
    {
        return 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    headView.backgroundColor = [UIColor clearColor];
    NSString *headName;
    if ([_typeShow isEqualToString:@"1"]) {
        if (section==0) {
            headName = @"正文文稿:";
        }
        else  if (section==1) {
            headName = @"附件:";
        }
    }
    else if ([_typeShow isEqualToString:@"2"])
    {
        headName = @"附件:";
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,100, 20)];
    nameLabel.text = headName;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    [headView addSubview:nameLabel];
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_typeShow isEqualToString:@"1"]) {
        if (section==0) {
            return 1;
        }
        else  if (section==1) {
            return _array.count-1;
        }
        else return 0;
    }
    else if ([_typeShow isEqualToString:@"2"])
    {
        return _array.count;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SearchList";
    ztOAFjSimpelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[ztOAFjSimpelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    if (([_typeShow isEqualToString:@"1"] && ((indexPath.section==0 &&_array.count>0)|| (indexPath.section==1 && indexPath.row< _array.count-1))) || ([_typeShow isEqualToString:@"1"] && indexPath.row <_array.count)) {
        NSString *fileNameStr =@"";
        //正文稿和附件显示，类型1
        if ([_typeShow isEqualToString:@"1"]) {
            
            if (indexPath.section==0) {
                fileNameStr = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:0] objectForKey:@"strfjmc"]];
            }
            else
            {
                fileNameStr = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row+1] objectForKey:@"strfjmc"]];
            }
        }
        //只有附件，类型2
        else if ([_typeShow isEqualToString:@"2"])
        {
            fileNameStr = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"strfjmc"]];
        }
        
        [cell.lineBreak setHidden:YES];
        [cell.backImage setHidden:NO];
        NSLog(@"-%@-",fileNameStr);
        NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
        NSString *fileType = [array lastObject];
        NSString *iconImgName= @"";
        if ([fileType isEqualToString:@"doc"]) {
            iconImgName = @"file_ic_word1";
        }
        else if ([fileType isEqualToString:@"txt"]){
            iconImgName = @"file_ic_txt";
        }
        else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
            iconImgName = @"file_ic_img";
        }
        else if ([fileType isEqualToString:@"xls"]){
            iconImgName = @"file_ic_xls1";
        }
        else if ([fileType isEqualToString:@"pdf"]){
            iconImgName = @"file_ic_pdf";
        }
        else {
            iconImgName = @"file_ic_x";
        }
        cell.fjName.text = fileNameStr;
        [cell.iconImg setImage:[UIImage imageNamed:iconImgName]];
        return cell;
    }
    else if([_typeShow isEqualToString:@"2"] && ((indexPath.section==0 &&_array.count>0)))
    {
        NSString *fileNameStr =@"";
        fileNameStr = [NSString stringWithFormat:@"%@",[[_array objectAtIndex:indexPath.row] objectForKey:@"strfjmc"]];
        [cell.lineBreak setHidden:YES];
        [cell.backImage setHidden:NO];
        NSLog(@"-%@-",fileNameStr);
        NSArray *array = [fileNameStr componentsSeparatedByString:@"."];
        NSString *fileType = [array lastObject];
        NSString *iconImgName= @"";
        if ([fileType isEqualToString:@"doc"]) {
            iconImgName = @"file_ic_word1";
        }
        else if ([fileType isEqualToString:@"txt"]){
            iconImgName = @"file_ic_txt";
        }
        else if ([fileType isEqualToString:@"png"]||[fileType isEqualToString:@"jpg"]||[fileType isEqualToString:@"jpeg"]){
            iconImgName = @"file_ic_img";
        }
        else if ([fileType isEqualToString:@"xls"]){
            iconImgName = @"file_ic_xls1";
        }
        else if ([fileType isEqualToString:@"pdf"]){
            iconImgName = @"file_ic_pdf";
        }
        else {
            iconImgName = @"file_ic_x";
        }
        cell.fjName.text = fileNameStr;
        [cell.iconImg setImage:[UIImage imageNamed:iconImgName]];
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int currentRow=0;
    if ([_typeShow isEqualToString:@"1"]) {
        if (indexPath.section==0) {
            currentRow = 0;
        }
        else if(indexPath.section==1)
        {
            currentRow = indexPath.row+1;
        }
    }
    else if([_typeShow isEqualToString:@"2"])
    {
        currentRow = indexPath.row;
    }
    NSDictionary *fileObj = [_array objectAtIndex:currentRow];
    
    NSString *fjlsh = [NSString stringWithFormat:@"%@",[fileObj objectForKey:_fjlshKeyStr]];
    filePlugin.viewController = _viewController;
    
    
    NSMutableDictionary *par=[[NSMutableDictionary alloc]initWithDictionary:[NSDictionary dictionaryWithObject:fjlsh forKey:fjlshKey]];
    [par setObject:[ztOAGlobalVariable sharedInstance].intrylsh forKey:@"chrrylsh"];
    [par setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"deviceIdSave"] forKey:@"deviceId"];
    
    [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
            blnvalue:@"false"
            strClass:class
           strMethod:method
               pageX:@""
               pageY:@""
            isChange:@""
             withUrl:url
             andPort:port
             andPath:path
        withSendDict:par
              fjType:[fileObj objectForKey:@"fjlx"]];
}
- (void)handleSingleTapUp:(UIGestureRecognizer *)gesture
{
    int currentRow = gesture.view.tag;
    NSDictionary *fileObj = [_array objectAtIndex:currentRow-1000];
    
    NSString *fjlsh = [NSString stringWithFormat:@"%@",[fileObj objectForKey:_fjlshKeyStr]];
    filePlugin.viewController = _viewController;

    [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
            blnvalue:@"false"
            strClass:class
           strMethod:method
               pageX:@""
               pageY:@""
            isChange:@""
             withUrl:url
             andPort:port
             andPath:path
        withSendDict:[NSDictionary dictionaryWithObject:fjlsh forKey:fjlshKey]
              fjType:[fileObj objectForKey:@"fjlx"]];
    
}
//改稿
-(void)doGg:(id)sender
{
    UIButton *btnSender = (UIButton*)sender;
    NSDictionary *fileObj = [_array objectAtIndex:btnSender.tag];
    NSString *fjlsh = [NSString stringWithFormat:@"%@",[fileObj objectForKey:_fjlshKeyStr]];
    filePlugin.viewController = _viewController;
    NSString *x = [NSString stringWithFormat:@"%f",btnSender.frame.origin.x];
    NSString *y = [NSString stringWithFormat:@"%f",btnSender.frame.origin.y];
    

    [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
            blnvalue:@"false"
            strClass:class
           strMethod:method
               pageX:x
               pageY:y
            isChange:@"yes"
             withUrl:url
             andPort:port
             andPath:path
        withSendDict:[NSDictionary dictionaryWithObject:fjlsh forKey:fjlshKey] fjType:[fileObj objectForKey:@"fjlx"]];

}

//上传
-(void)doSc:(id)sender
{
    if(gwfjxx==nil){
        [UIViewHelp alertTitle:@"提示" alertMessage:@"缺少附件基本信息"];
        return;
    }
    
    [btnGg setHidden:NO];
    [btnSc setHidden:YES];
    [btnCx setHidden:YES];
    
    UIButton *btnSender = (UIButton*)sender;
    NSDictionary *fileObj = [_array objectAtIndex:btnSender.tag];
    
//    [filePlugin fjmc:[fileObj objectForKey:@"strfjmc"]
//             strClass:class
//            strMethod:@"setGwfj"
//              withUrl:url andPort:port andPath:path andSendDict:gwfjxx];
}

//撤销
-(void)doCx
{
    [btnGg setHidden:NO];
    [btnSc setHidden:YES];
    [btnCx setHidden:YES];
}

- (void)FileOpenBegin
{
    [btnGg setHidden:YES];
    [btnSc setHidden:NO];
    [btnCx setHidden:NO];
}

-(void) FileUploadOver:(id)result
{
    [_delegate ZMOFjUploadOver:(id)result];
}

@end
