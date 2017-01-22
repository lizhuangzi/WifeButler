//
//  ZJCommunityShopVC.m
//  YouHu
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZJCommunityShopVC.h"
#import "ZJCommunityShopCell.h"
#import "ZJCommunityShopHeaderView.h"
#import "ZJShopClassVC.h"
#import "SDCycleScrollView.h"
#import "ZJShopClassCell1.h"
#import "ZJCommunityShopFooterView.h"
#import "ZTFuJinShangJiaViewController.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "WZLBadgeImport.h"
#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZJGoodsDetailVC.h"
#import "ZJLoginController.h"

@interface ZJCommunityShopVC ()<UICollectionViewDataSource,UICollectionViewDelegate, SDCycleScrollViewDelegate,
    ZJLabelClickDelegate,UISearchBarDelegate>
{
    ZJCommunityShopHeaderView *_headerView;
    ZJCommunityShopFooterView *_footerView;
    
    UIButton *_btnGoShopCar;
    
    NSMutableArray *_dataSourceGoWuChe;
}

@property (nonatomic,strong)NSMutableDictionary*dataDic;
@property (nonatomic,strong)NSMutableArray*dataAry;
@property (nonatomic,strong)NSMutableArray*shopAry;

@property (nonatomic,strong)NSMutableArray*shopAry1;
@property (nonatomic,strong)NSMutableArray*shopAry2;

@property (nonatomic,copy)NSString*type1;    //判断headerView [setLabel] 方法的执行

// 顶部轮播数据
@property (nonatomic, strong) NSMutableArray * topDataSource;

@end

@implementation ZJCommunityShopVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setCollectionView];
    
    [self setPram];
    
    [self netWorking];
    
}

- (void)setPram
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 30)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor colorWithRed:0.558 green:0.558 blue:0.591 alpha:1.000];
    self.navigationItem.titleView = searchBar;    
    
    self.topDataSource = [NSMutableArray array];
    
    [self right];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _btnGoShopCar = [[UIButton alloc] initWithFrame:CGRectMake(10, iphoneHeight - 100, 50, 50)];
    [_btnGoShopCar setImage:[UIImage imageNamed:@"ZTCar"] forState:UIControlStateNormal];
    
    [_btnGoShopCar addTarget:self action:@selector(ClickTemp11) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *wid = [[UIApplication sharedApplication] keyWindow];;
    [wid addSubview:_btnGoShopCar];
    
    // 购物车列表
    [self netWorkingGoWuChe];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_btnGoShopCar removeFromSuperview];
}

- (void)ClickTemp11
{
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
    ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJShopClassVC * nav=[sb instantiateViewControllerWithIdentifier:@"ZJShopClassVC"];
    nav.keyBoard = searchBar.text;
    
    nav.titleName = @"搜索结果";
    nav.serve_idType = @"1";
    nav.type = 2;
    [self.navigationController pushViewController:nav animated:YES];
}

//headView Delgate
-(void)labelClickWithType:(NSString *)type
{
    if ([type intValue]==1) {
        
        self.dataAry=nil;
        
        self.dataAry = [[self.dataDic objectForKey:@"cats"] objectForKey:@"period_1"];
        
        self.shopAry = [self.dataDic objectForKey:@"shops"][@"period_1"];
    
        
        [self.collectionView reloadData];
        
    }else if ([type intValue]==2){
        
        self.dataAry = nil;
        self.dataAry = [[self.dataDic objectForKey:@"cats"] objectForKey:@"period_2"];
        
        self.shopAry = [self.dataDic objectForKey:@"shops"][@"period_2"];
        
        [self.collectionView reloadData];
        
    }else{
        
        self.dataAry = nil;
        self.dataAry = [[self.dataDic objectForKey:@"cats"] objectForKey:@"period_3"];
        
        self.shopAry = [self.dataDic objectForKey:@"shops"][@"period_3"];
        
        [self.collectionView reloadData];
        
    }
}

-(void)setCollectionView
{
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return self.dataAry.count;
        
    }else{
        
        return self.shopAry.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        ZJCommunityShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJCommunityShopCell" forIndexPath:indexPath];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"file"]]]  placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        cell.nameLabel.text = [[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"name"];
        
        return cell;
    }
    else{
        
        
        ZJShopClassCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJShopClassCell1" forIndexPath:indexPath];
        
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.shopAry objectAtIndex:indexPath.row] objectForKey:@"shop_pic"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cell.nameLabel.text=[[self.shopAry objectAtIndex:indexPath.row] objectForKey:@"shop_name"];
        
        return cell;
    }
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
        ZJShopClassVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJShopClassVC"];
        nav.classId = [[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"id"];
        nav.type=1;
        nav.titleName = [[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"name"];
        nav.serve_idType = @"1";
        [self.navigationController pushViewController:nav animated:YES];
        
        
    }else{
        
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
        ZTFuJinShangJiaViewController * nav=[sb instantiateViewControllerWithIdentifier:@"ZTFuJinShangJiaViewController"];
        nav.shop_id = [[self.shopAry objectAtIndex:indexPath.row] objectForKey:@"id"];
        nav.serve_idType = @"1";
        [self.navigationController pushViewController:nav animated:YES];
    }
    
}


//定义Cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return CGSizeMake((iphoneWidth - 2) / 3.0, 100);
        
    }
    else
    {
        return CGSizeMake((iphoneWidth - 2) / 3.0, 130);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
        if (kind == UICollectionElementKindSectionHeader){
            
            if (indexPath.section == 0) {
            
                _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZJCommunityShopHeaderView" forIndexPath:indexPath];
                
                if ([self.type1 intValue]==0) {
                    [_headerView setLabel];
                    self.type1=@"2";
                }
                
                _headerView.delegate=self;
                return _headerView;
            }
            else
            {
                _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZJCommunityShopHeaderView" forIndexPath:indexPath];
                _headerView.frame = CGRectMake(0, 0, 0, 0);
                return _headerView;
            }


        }else{
            
            UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView" forIndexPath:indexPath];
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 15)];
            view.backgroundColor = [UIColor colorWithWhite:0.956 alpha:1.000];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), iphoneWidth, 30)];
            label.text=@"  附近商家";
            [label setFont:[UIFont systemFontOfSize:15]];

            [footView addSubview:label];
            [footView addSubview:view];
            return footView;
        }
    return nil;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return CGSizeMake(iphoneWidth, 180);

    }
    return CGSizeMake(iphoneWidth, 0);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
   
    if (section == 0) {
        
        return CGSizeMake(iphoneWidth, 40);
    }
    
    return CGSizeMake(iphoneWidth, 0);
}


#pragma mark - 请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
    [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWu];

    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.topDataSource = responseObject[@"resultCode"][@"carousel"];
            
            [self createScorllView1:responseObject[@"resultCode"][@"carousel"]];
            
            self.dataDic = [responseObject objectForKey:@"resultCode"];
            self.dataAry = [[self.dataDic objectForKey:@"cats"] objectForKey:@"period_1"];
            self.shopAry = [self.dataDic objectForKey:@"shops"][@"period_1"];
            
            [self.collectionView reloadData];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.collectionView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.collectionView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 数据购物车
- (void)netWorkingGoWuChe
{
    if (KToken == nil) {
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(1) forKey:@"pageindex"];
    [dic setObject:@(100) forKey:@"pagesize"];
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheList];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _dataSourceGoWuChe = responseObject[@"resultCode"];
            
            _btnGoShopCar.badgeCenterOffset = CGPointMake(-16, 8);
            
            [_btnGoShopCar showBadgeWithStyle:WBadgeStyleNumber value:_dataSourceGoWuChe.count animationType:WBadgeAnimTypeNone];
            
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                if ([[responseObject objectForKey:@"code"] intValue] == 30000) {
                    
                    [SVProgressHUD dismiss];
                }
                else
                {
                
                    [SVProgressHUD showErrorWithStatus:message];
                }
                
            }

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
    
    CGRect rect = _headerView.viewLunBo.frame;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
//    cycleScrollView2.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    cycleScrollView2.delegate = self;
    
    [_headerView.viewLunBo addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    ZTXiangQinHealthyLifeViewController *vc = [[ZTXiangQinHealthyLifeViewController alloc] init];
//    vc.id_temp = self.topDataSource[index][@"goods_id"];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJGoodsDetailVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
    nav.goodId = self.topDataSource[index][@"goods_id"];;
    [self.navigationController pushViewController:nav animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableDictionary*)dataDic
{
    if (!_dataDic) {
        _dataDic=[[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}

- (NSMutableArray*)dataAry
{
    if (!_dataAry) {
        _dataAry=[[NSMutableArray alloc]init];
    }
    return _dataAry;
}

- (NSMutableArray*)shopAry
{
    if (!_shopAry) {
        _shopAry=[[NSMutableArray alloc]init];
    }
    return _shopAry;
}

@end
