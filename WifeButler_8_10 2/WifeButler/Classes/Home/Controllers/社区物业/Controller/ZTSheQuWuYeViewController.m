//
//  ZTSheQuWuYeViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuWuYeViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZTPersonGouWuCheViewController.h"
#import "WZLBadgeImport.h"
#import "ZTSheQuWuYeCollectionViewCell.h"
#import "ZTSheQuWuYeFuJinCollectionViewCell.h"
#import "ZTOneSheQuWuYeCollectionViewCell.h"
#import "ZTHeard1CollectionReusableView.h"
#import "ZTHeard2CollectionReusableView.h"
#import "SDCycleScrollView.h"
#import "ZTWuYeShopsModel.h"
#import "ZTWuYeShangPinModel.h"
#import "ZJShopClassVC.h"
#import "ZTFuJinShangJiaViewController.h"
#import "ZTLeiXinShangPinViewController.h"
#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZJGoodsDetailVC.h"
#import "ZTSheQuWuYeFuWuXiangQinViewController.h"


@interface ZTSheQuWuYeViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>
{
    UIButton *_btnGoShopCar;
    
    NSMutableArray *_dataSourceGoWuChe;
    
    ZTHeard1CollectionReusableView *_heard1;
    
    ZTHeard2CollectionReusableView *_heard2;
}

@property (nonatomic, assign) NSInteger  selectBig;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// 商品
@property (nonatomic, strong) NSMutableArray * shangPinMArr;

// 商家
@property (nonatomic, strong) NSArray * shangJiaMArr;

@property (nonatomic, strong) NSMutableArray * topLunBoDataSource;

@end

@implementation ZTSheQuWuYeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 注册标识
    UINib *nib1 = [UINib nibWithNibName:@"ZTHeard1" bundle:nil];
    [self.collectionView registerNib:nib1 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZTHeard1"];
    
    UINib *nib2 = [UINib nibWithNibName:@"ZTheard2" bundle:nil];
    [self.collectionView registerNib:nib2 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZTHeard2"];
    
    [self setPram];
    
    [self netWorkingWuYe];
}

- (void)setPram
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 200, 30)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor colorWithRed:0.558 green:0.558 blue:0.591 alpha:1.000];
    self.navigationItem.titleView = searchBar;
    
    self.topLunBoDataSource = [NSMutableArray array];
    
    
    [self right];
}

- (void)right
{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 25, 30);
    [right setBackgroundImage:[UIImage imageNamed:@"ZTDingDan"] forState:UIControlStateNormal];
    
    [right addTarget:self action:@selector(ClikcTemp) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:right];
}

- (void)ClikcTemp
{
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTHuiZhuanDingDan1ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTHuiZhuanDingDan1ViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 数据请求
- (void)netWorkingWuYe
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
    [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
    
    if (self.Type == 2) {
        
        [dic setObject:@(2) forKey:@"serve_id"];
    }
    else
    {
        [dic setObject:@(3) forKey:@"serve_id"];
    }
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuFuWuList];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.topLunBoDataSource = responseObject[@"resultCode"][@"carousel"];
            
            [self createScorllView1:responseObject[@"resultCode"][@"carousel"]];
            
            self.shangPinMArr = [ZTWuYeShangPinModel mj_objectArrayWithKeyValuesArray: responseObject[@"resultCode"][@"cats"]];
            
            [self.collectionView reloadData];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        
        
    }];
    
}

#pragma mark - 轮播图
- (void)createScorllView1:(NSArray *)imageArr
{
    NSMutableArray *imageArrMutTemp = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        NSString *imageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, imageArr[i][@"file"]];
        
        [imageArrMutTemp addObject:imageStr];
    }
    
    CGRect rect = _heard1.gunDonView.frame;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.delegate = self;
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [_heard1.gunDonView addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    ZJLog(@"%ld", section);
    
    if (section == 0) {
        
        if (self.shangPinMArr.count) {
            
            ZTWuYeShangPinModel *model = self.shangPinMArr[_selectBig];
            return model.child.count + 1;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        if (self.shangPinMArr.count) {
            
            ZTWuYeShangPinModel *model = self.shangPinMArr[_selectBig];
            return model.shops.count;
        }
        
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ZTOneSheQuWuYeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTOneSheQuWuYeCollectionViewCell" forIndexPath:indexPath];
            
            cell.dataSource = self.shangPinMArr;
            
            cell.selectRow = _selectBig;
            
            [cell setCollectionViewTemp];
            
            // 点击事件
            [cell setDianJiShiJianBlack:^(NSInteger row) {
                
                ZJLog(@"点击点击");
                _selectBig = row;
                [collectionView reloadData];
            }];
            
            return cell;
        }
        else
        {
            ZTSheQuWuYeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTSheQuWuYeCollectionViewCell" forIndexPath:indexPath];
            
            ZTWuYeShangPinModel * hehemodel=  self.shangPinMArr[_selectBig];
            ZTWuYeShangPinModel* model = hehemodel.child[indexPath.row-1];
            
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.file]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
            
            cell.titleLab.text = model.name;
            
            return cell;
        }

    }
    else
    {
        
        ZTSheQuWuYeFuJinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTSheQuWuYeFuJinCollectionViewCell" forIndexPath:indexPath];
    
        ZTWuYeShangPinModel * hehemodel = self.shangPinMArr[_selectBig];
        ZTWuYeShopsModel * model = hehemodel.shops[indexPath.row];
        
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.shop_pic]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cell.titleLab.text = model.shop_name;
        
        return cell;
    }
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return CGSizeMake(iphoneWidth, 35);
        }
    }
    
    return CGSizeMake((iphoneWidth - 1) / 3.0, (iphoneWidth) / 3.0);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
    
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
        ZTLeiXinShangPinViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTLeiXinShangPinViewController"];
        
        ZTWuYeShangPinModel * hehemodel = self.shangPinMArr[_selectBig];
        
        ZTWuYeShangPinModel * model = hehemodel.child[indexPath.row-1];
        
        if (self.Type == 2) {
            
            
            nav.serve_idType = @"2";
        }
        else
        {
            nav.serve_idType = @"3";
        }
        
        nav.classId = model.id;
        nav.type = 1;
        nav.titleName = model.name;
        [self.navigationController pushViewController:nav animated:YES];
        
        
    }else{
        
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
        ZTFuJinShangJiaViewController * nav=[sb instantiateViewControllerWithIdentifier:@"ZTFuJinShangJiaViewController"];
        if (self.Type == 2) {
            
            
            nav.serve_idType = @"2";
        }
        else
        {
            nav.serve_idType = @"3";
        }
        
        ZTWuYeShangPinModel * hehemodel = self.shangPinMArr[_selectBig];
        ZTWuYeShopsModel * model = hehemodel.shops[indexPath.row];
        nav.shop_id = model.id;
        
        [self.navigationController pushViewController:nav animated:YES];
        
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        if (kind == UICollectionElementKindSectionHeader){
            
            _heard1 = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZTHeard1" forIndexPath:indexPath];
            
            return _heard1;
        }
        return nil;
    }
    else
    {
        if (kind == UICollectionElementKindSectionHeader){
            
            _heard2 = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ZTHeard2" forIndexPath:indexPath];
            
            return _heard2;
        }
       
        return nil;
    }

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return CGSizeMake(iphoneWidth, 150);
    }
    else
    {
        return CGSizeMake(iphoneWidth, 60);
    }
    
}

//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
    ZTLeiXinShangPinViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTLeiXinShangPinViewController"];
    
    nav.keyBoard = searchBar.text;
    
    if (self.Type == 2) {
        
        
        nav.serve_idType = @"2";
    }
    else
    {
        nav.serve_idType = @"3";
    }
    nav.titleName = @"搜索结果";
    nav.type = 2;
    [self.navigationController pushViewController:nav animated:YES];
}



- (NSArray *)shangJiaMArr
{
    if (_shangJiaMArr == nil) {
        
        _shangJiaMArr = [[NSArray alloc] init];
    }
    
    return _shangJiaMArr;
}

- (NSMutableArray *)shangPinMArr
{
    if (_shangPinMArr == nil) {
        
        _shangPinMArr = [[NSMutableArray alloc] init];
    }
    
    return _shangPinMArr;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
    ZTSheQuWuYeFuWuXiangQinViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeFuWuXiangQinViewController"];
    vc.goods_id = self.topLunBoDataSource[index][@"goods_id"];;
    [self.navigationController pushViewController:vc animated:YES];
    
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
