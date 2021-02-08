//
//  ChooseHotVC.m
//  MobileOA
//
//  Created by 熊佳佳 on 16/12/15.
//  Copyright © 2016年 xj. All rights reserved.
//

#import "ChooseHotVC.h"
#import "ChooseHotCell.h"
@interface ChooseHotVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *homepageCollection;
@property(nonatomic,strong)NSMutableArray *itemArray;
@end

@implementation ChooseHotVC
@synthesize homepageCollection,itemArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:RGBCOLOR(220, 220, 220)];
    float iconw=(kScreenWidth-((3+1)*5))/3.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(iconw, iconw);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    homepageCollection= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    [homepageCollection registerClass:[ChooseHotCell class]forCellWithReuseIdentifier:@"cell"];
    homepageCollection.backgroundColor = [UIColor clearColor];
    homepageCollection.delegate = self;
    homepageCollection.dataSource = self;
    [self.view addSubview:homepageCollection];
    
    [self getrdzt];
    // Do any additional setup after loading the view.
}
#pragma mark--------------获取热点专题-------------
-(void)getrdzt
{
    [self newworkGetall:@"getrdzt.ashx" parameter:nil progresHudText:@"加载中..." completionBlock:^(id rep) {
        NSDictionary *repdic=[rep mj_JSONObject];
        if (repdic!=nil) {
            if ([repdic[@"ds"] isKindOfClass:[NSArray class]]) {
                itemArray =[[NSMutableArray alloc]initWithArray:repdic[@"ds"]];
                [homepageCollection reloadData];
            }
        }
    }];
}
#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return itemArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    ChooseHotCell *cell = (ChooseHotCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSDictionary *celldic=itemArray[indexPath.row];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:celldic[@"img_url"]] placeholderImage:PNGIMAGE(@"默认图")];
    cell.titlelb.text=celldic[@"title"];
    cell.numlb.hidden=YES;
    return cell;
}
//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *celldic=itemArray[indexPath.row];
    if (self.callback) {
        self.callback(celldic);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
