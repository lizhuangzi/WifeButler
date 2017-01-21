//
//  ZTFuJinShangJiaViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTFuJinShangJiaViewController.h"
#import "ZTFuJinShangJiaCollectionViewCell.h"
#import "ZTFuJinShangJiaTableViewCell.h"
#import "ZTLeiBieaaModel.h"
#import "ZJShopClassVC.h"
#import "ZJGoodsDetailVC.h"
#import "ZTSheQuWuYeFuWuXiangQinViewController.h"

typedef enum {

    PaiXuMoRen,     // 默认
    PaiXuXiaoLiang, // 销量
    PaiXuZuiXin     // 最新
    
}PaiXu;

@interface ZTFuJinShangJiaViewController () <UISearchBarDelegate>
{
    NSMutableArray *_dataSourceTableV;
    
    NSMutableArray *_dataSourceCollectV;
    
    int _pize;
    
    int fenLie_id;
    
    UISearchBar *_searchBar;
}

@property(nonatomic, assign) NSInteger  type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) PaiXu  paiXu;

@end

@implementation ZTFuJinShangJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPram];
    
    [self netWorkingZouCe];
    
    [self shuaXinJiaZa];
    

}

- (void)setPram
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 200, 30)];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithRed:0.558 green:0.558 blue:0.591 alpha:1.000];
    
    self.navigationItem.titleView = _searchBar;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pize = 1;
        [self netWorking];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pize ++;
        [self netWorkingJiaZa];
    }];
    
}

#pragma mark - 左侧数据
- (void)netWorkingZouCe
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.shop_id forKey:@"shop_id"];
    [dic setObject:self.serve_idType forKey:@"serve_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuZuo];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSourceTableV = responseObject[@"resultCode"];
            
            if (_dataSourceTableV.count != 0) {
                
                
                fenLie_id = [_dataSourceTableV[0][@"cat_id"] intValue];
            }
            
            [self.tableView reloadData];
            
            [self.collectionView.mj_header beginRefreshing];

        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}


#pragma mark - 右侧数据
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(_pize) forKey:@"pageindex"];
    [dic setObject:self.shop_id forKey:@"shop_id"];
    [dic setObject:@(fenLie_id) forKey:@"cat_id"];
    [dic setObject:@(_pize) forKey:@"pageindex"];
    [dic setObject:self.serve_idType forKey:@"serve_id"];

    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuYou];
    
    if (self.paiXu == PaiXuMoRen) { // 换米
        
        [dic setObject:@(0) forKey:@"orderby"];
    }
    if (self.paiXu == PaiXuXiaoLiang) { // 换米
        
        [dic setObject:@(1) forKey:@"orderby"];
    }
    if (self.paiXu == PaiXuZuiXin) { // 换米
        
        [dic setObject:@(2) forKey:@"orderby"];
    }
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            
            _dataSourceCollectV = [ZTLeiBieaaModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            if (_dataSourceCollectV.count < 9) {
                
                self.collectionView.mj_footer = nil;
            }
            
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


- (void)netWorkingJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(_pize) forKey:@"pageindex"];
    [dic setObject:self.shop_id forKey:@"shop_id"];
    
    [dic setObject:@(fenLie_id) forKey:@"cat_id"];
    
    [dic setObject:@(_pize) forKey:@"pageindex"];

    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuYou];
    
    if (self.paiXu == PaiXuMoRen) { // 换米
        
        [dic setObject:@(0) forKey:@"orderby"];
    }
    if (self.paiXu == PaiXuXiaoLiang) { // 换米
        
        [dic setObject:@(1) forKey:@"orderby"];
    }
    if (self.paiXu == PaiXuZuiXin) { // 换米
        
        [dic setObject:@(2) forKey:@"orderby"];
    }
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            

            [_dataSourceCollectV addObjectsFromArray:[ZTLeiBieaaModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            [self.collectionView reloadData];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.collectionView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.collectionView.mj_footer endRefreshing];
        
    }];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceTableV.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTFuJinShangJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTFuJinShangJiaTableViewCell" forIndexPath:indexPath];
    
    cell.titleLab.text = _dataSourceTableV[indexPath.row][@"cat_name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_dataSourceCollectV removeAllObjects];
    
    [self.collectionView reloadData];
    
    fenLie_id = [_dataSourceTableV[indexPath.row][@"cat_id"] intValue];
    
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return 10;
    return _dataSourceCollectV.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZTFuJinShangJiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTFuJinShangJiaCollectionViewCell" forIndexPath:indexPath];
    ZTLeiBieaaModel *model = _dataSourceCollectV[indexPath.row];
    
    [cell.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.files]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.titleLab.text = model.title;
    cell.moneyLab.text = model.money;
    
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 128) / 2.0, ([UIScreen mainScreen].bounds.size.width - 128) / 2.0 + 40);
}


#pragma mark - 点击事件进行状态改变
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZTLeiBieaaModel *model = _dataSourceCollectV[indexPath.row];
    
    if ([self.serve_idType intValue] == 1) {
        
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
        ZJGoodsDetailVC * nav=[sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
        
        nav.goodId = model.id;
    
        [self.navigationController pushViewController:nav animated:YES];
    }
    
    if ([self.serve_idType intValue] == 2) {
        
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
        ZTSheQuWuYeFuWuXiangQinViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeFuWuXiangQinViewController"];
        vc.goods_id = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([self.serve_idType intValue] == 3) {

        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
        ZTSheQuWuYeFuWuXiangQinViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeFuWuXiangQinViewController"];
        vc.goods_id = model.id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
}


- (IBAction)paiXuSender:(UISegmentedControl *)sender {
    
    [_dataSourceCollectV removeAllObjects];
    
    [self.collectionView reloadData];
    
    
    _type = sender.selectedSegmentIndex + 1;
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            
            self.paiXu = PaiXuMoRen;
            [self.collectionView.mj_header beginRefreshing];
            
            break;
            
        case 1:
            
            self.paiXu = PaiXuXiaoLiang;
            [self.collectionView.mj_header beginRefreshing];
            break;
            
        case 2:
            
            self.paiXu = PaiXuZuiXin;
            [self.collectionView.mj_header beginRefreshing];
            break;
            
        default:
            break;
    }
    
}

//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [_dataSourceCollectV removeAllObjects];

    [self.collectionView reloadData];
    
    [self netWorkingSearch:searchBar.text];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}

#pragma mark - 搜索
- (void)netWorkingSearch:(NSString *)strWord
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(30) forKey:@"pagesize"];
    [dic setObject:self.shop_id forKey:@"shop_id"];
    [dic setObject:strWord forKey:@"keyword"];
    [dic setObject:@(fenLie_id) forKey:@"cat_id"];
    [dic setObject:self.serve_idType forKey:@"serve_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuYou];

    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSourceCollectV = [ZTLeiBieaaModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            
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
