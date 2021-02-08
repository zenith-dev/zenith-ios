//
//  YwzdCsVC.m
//  OAMobileIOS
//
//  Created by 熊佳佳 on 16/9/29.
//  Copyright © 2016年 chenyang. All rights reserved.
//

#import "YwzdCsVC.h"
#import "YwzdCsCell.h"
#import "YwzdGnVC.h"
@interface YwzdCsVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray *ywzdAry;
@property(nonatomic,strong)UICollectionView *ywzdCsColl;
@end

@implementation YwzdCsVC
@synthesize ywzdCsColl,ywzdAry;
- (void)viewDidLoad {
    [super viewDidLoad];
    ywzdAry=[[NSArray alloc]init];
    float iconw=(kScreenWidth-((3+1)*5))/3.0;
    float iconh=60;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(iconw, iconh);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    ywzdCsColl= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.height) collectionViewLayout:layout];
    [ywzdCsColl registerClass:[YwzdCsCell class]forCellWithReuseIdentifier:@"cell"];
    ywzdCsColl.backgroundColor = [UIColor whiteColor];
    ywzdCsColl.delegate = self;
    ywzdCsColl.dataSource = self;
    [self.view addSubview:ywzdCsColl];
    [self getYwzdCs];
    // Do any additional setup after loading the view.
}
#pragma mark---------------获取业务指导处室列表-------
-(void)getYwzdCs{
    NSDictionary *dataDic=@{};
    [self showWaitView];
    [ztOAService getYwzdCs:dataDic Success:^(id result) {
        [self closeWaitView];
        NSDictionary *dic = [result objectFromJSONData];
        NSLog(@"list=%@",[dic JSONString]);
        if ([[dic objectForKey:@"root"] objectForKey:@"result"]!=NULL && [[[dic objectForKey:@"root"] objectForKey:@"result"]intValue]==0)
        {
            ywzdAry =[dic objectForKey:@"root"][@"cs"];
            [ywzdCsColl reloadData];
        }
    } Failed:^(NSError *error) {
        
    }];
}
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ywzdAry.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    YwzdCsCell *cell = (YwzdCsCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSDictionary *celldic=ywzdAry[indexPath.row];
    [cell setBackgroundColor:UIColorFromRGB(0x18b6f7)];
    cell.titlelb.text=celldic[@"strcsmc"];
    return cell;
}
//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *celldic=ywzdAry[indexPath.row];
    YwzdGnVC *ywzdcs=[[YwzdGnVC alloc]init];
    NSLog(@"%@",celldic[@"strcsmc"]);
    ywzdcs.title=celldic[@"strcsmc"];
    ywzdcs.strccbm=celldic[@"strccbm"];
    [self.navigationController pushViewController:ywzdcs animated:YES];
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
