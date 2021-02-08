//
//  ZtOAFlowPersonVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/8/8.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "ZtOAFlowPersonVC.h"
#import "ztOAService.h"
#import "ztOAAddressBookItemCell.h"
@interface ZtOAFlowPersonVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray  *allData;//所有节点
    NSString *strnextgzrylx;
}
@property (nonatomic,strong)UITableView *flow_tb;
@end

@implementation ZtOAFlowPersonVC
@synthesize selectary,processOpr,flow_tb;
-(id)init:(NSString*)title selectAry:(NSMutableArray*)selectAry storeDict:(NSMutableDictionary*)storeDict;
{
    self=[super init];
    if (self) {
        self.title=title;
        selectary=selectAry;
        self.storeDict=storeDict;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightButton:@"确定" Sel:@selector(okSEL:)];
    addN(@selector(checkedInsertAddressBook:), @"CELLCHECHEDUP");
    flow_tb=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    flow_tb.delegate=self;
    flow_tb.dataSource=self;
    [self.view addSubview:flow_tb];
    allData=[[NSMutableArray alloc]init];
    [self getFlclzdxxx];
    // Do any additional setup after loading the view.
}
#pragma mark------------确定选择---------------
-(void)okSEL:(UIButton*)sender
{
    self.callback(selectary,self.storeDict);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark--------------获取人员列表-------------
-(void)getFlclzdxxx
{
    //已有数据，无需重新请求
    for (NSString *key in [self.storeDict allKeys]) {
        if ([[NSString stringWithFormat:@"level%d&lsh%@", 0, @"0"] isEqualToString:key]) {
            [allData removeAllObjects];
            allData = [NSMutableArray arrayWithArray:[ self.storeDict objectForKey:key]];
            [flow_tb reloadData];
            return;
        }
    }
    [ztOAService getFlclzdxxx:@{@"intrylsh":[ztOAGlobalVariable sharedInstance].intrylsh,@"strryxm":[ztOAGlobalVariable sharedInstance].username,@"intbzjllsh":processOpr[@"intbzjllsh"],@"intcsdwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh_child,@"xtDwlsh":[ztOAGlobalVariable sharedInstance].intdwlsh,@"dwccbm":[ztOAGlobalVariable sharedInstance].dwccbm,@"intnextgzlclsh":processOpr[@"intnextgzlclsh"],@"intlcczlsh":processOpr[@"intlcczlsh"]} Success:^(id result) {
        NSDictionary *resultDict = [result objectFromJSONData];
        strnextgzrylx=[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strnextgzrylx"];
        NSArray *userInfoData = [[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strzdryc"] objectForKey:@"ryinfo"];
            if ([userInfoData isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in userInfoData) {
                    ztOAABModel *userInfo = [[ztOAABModel alloc] init];
                    userInfo.type = 1;
                    userInfo.strnextrybz=dict[@"strnextrybz"];
                    userInfo.strnextdwbz=dict[@"strnextdwbz"];
                    userInfo.chrbz = @"1";
                    userInfo.fullName = [dict objectForKey:@"strryxm"];
                    userInfo.shortName = [dict objectForKey:@"strryxm"];
                    userInfo.dwlsh = [dict objectForKey:@"intrylsh"];
                    userInfo.intrylsh=[dict objectForKey:@"intrylsh"];
                    userInfo.strxm=[dict objectForKey:@"strryxm"];
                    userInfo.strdw=[dict objectForKey:@"strdw"];
                    if ([[dict objectForKey:@"strzwmc"] isKindOfClass:[NSArray class]]) {
                        NSArray *zw=[dict objectForKey:@"strzwmc"];
                        NSString *strzw = [zw componentsJoinedByString:@","];
                        userInfo.strzw=strzw;
                    }else
                    {
                        userInfo.strzw=[dict objectForKey:@"strzwmc"];
                    }
                    userInfo.stryddh=[NSString stringWithFormat:@"%@",[dict objectForKey:@"stryddh"]];
                    userInfo.strbgdh=[NSString stringWithFormat:@"%@",[dict objectForKey:@"strbgdh"]];
                    
                    [allData addObject:userInfo];
                }
            } else{
                ztOAABModel *userInfo = [[ztOAABModel alloc] init];
                userInfo.strnextrybz=[(NSDictionary *)userInfoData objectForKey:@"strnextrybz"];
                userInfo.strnextdwbz=[(NSDictionary *)userInfoData objectForKey:@"strnextdwbz"];
                userInfo.type = 1;
                userInfo.chrbz = @"1";
                userInfo.intrylsh=[(NSDictionary *)userInfoData objectForKey:@"intrylsh"];
                userInfo.strxm=[NSString stringWithFormat:@"%@",[(NSDictionary *)userInfoData objectForKey:@"strryxm"]];
                [allData addObject:userInfo];
            }
        NSArray *tempArr = [[NSArray alloc] initWithArray:allData];
        [self.storeDict setObject:strnextgzrylx?:@"" forKey:@"strnextgzrylx"];
        [self.storeDict setObject:[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"intnextgzrylsh"] forKey:@"intnextgzrylsh"];
        
        [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"strzrrlxLst"] forKey:@"strzrrlxLst"];
        
        [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intgzlclshlst"] forKey:@"intgzlclshlst"];
        

        
         [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbzlst"] forKey:@"intbzlst"];
        
        [self.storeDict setObject:[[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"] objectForKey:@"strzdryc"] objectForKey:@"intbcbhlst"] forKey:@"intbcbhlst"];
        
         [self.storeDict setObject:[[[resultDict objectForKey:@"root"] objectForKey:@"flcxx"]objectForKey:@"strwcbz"] forKey:@"strwcbz"];
        
        [self.storeDict setObject:tempArr forKey:[NSString stringWithFormat:@"level%d&lsh%@", 0, @"0"]];
        [flow_tb reloadData];
        [self closeWaitView];
    } Failed:^(NSError *error) {
         [self closeWaitView];
    }];
}
- (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark-------------------UITableViewDelegate---------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allData.count;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectZero];
    [sectionView setBackgroundColor:[UIColor clearColor]];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.contentView.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addressId";
    ztOAAddressBookItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ztOAAddressBookItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, cell.contentView.height - 1)];
        [selectView setBackgroundColor:MF_ColorFromRGB(220, 220, 220)];
        [cell setSelectedBackgroundView:selectView];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    ztOAABModel *addressItem = [[ztOAABModel alloc] init];
    addressItem = (ztOAABModel *)[allData objectAtIndex:indexPath.row];
    cell.name.text = addressItem.shortName;
    [cell.cellIcon setOrigin:CGPointMake(2+20, 7)];
    [cell.name setOrigin:CGPointMake(35+20, 5)];
    [cell.name setCenterY:22];
    [cell.companyName setOrigin:CGPointMake(35+20, 30)];
    [cell.checkedBtn setOrigin:CGPointMake(cell.name.right+5, 2)];
    cell.checkedBtn.right=kScreenWidth-15;
    cell.ABookCell = addressItem;
    [cell setChecked:addressItem.isCheckedUp];
    if (addressItem.type==2) {
        cell.upImg.hidden=NO;
        cell.checkedBtn.hidden=YES;
    }
    else
    {
        cell.upImg.hidden=YES;
        cell.checkedBtn.hidden=NO;
    }
    //cell.delegate = self;
    return cell;
}
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark--------------- 勾选处理------------------
- (void)checkedInsertAddressBook:(NSNotification *)notify
{
    NSDictionary *bookDic = (NSDictionary *)[notify userInfo];
    NSString *ischecked = [bookDic objectForKey:@"ischecked"];
    ztOAABModel *bookModel = [[ztOAABModel alloc]init];
    bookModel.intrylsh = [bookDic objectForKey:@"intrylsh"];
    bookModel.strxm = [bookDic objectForKey:@"strxm"];
    bookModel.shortName = [bookDic objectForKey:@"strxm"];
    bookModel.strnextrybz=[bookDic objectForKey:@"strnextrybz"];
    bookModel.strnextdwbz=[bookDic objectForKey:@"strnextdwbz"];
    
    NSLog(@"%@",notify);
    BOOL isAlreadyStay=NO;
    for (int i = 0;i<selectary.count;i++) {
        ztOAABModel *model = [selectary objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%@",model.intrylsh] isEqualToString:[NSString stringWithFormat:@"%@", bookModel.intrylsh]]) {
            isAlreadyStay = YES;
            if (![ischecked isEqualToString:@"yes"]) {
                [selectary removeObjectAtIndex:i];
                break;
            }
        }
    }
    if ([ischecked isEqualToString:@"yes"] && isAlreadyStay == NO) {
        [selectary addObject:bookModel];
    }
    NSLog(@"count==%d,%@",selectary.count,selectary);
    [flow_tb reloadData];
}
- (void)selectedPersonCallback:(void (^)(NSMutableArray * selectAry,NSMutableDictionary *storeDict))callback {
    self.callback = callback;
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
