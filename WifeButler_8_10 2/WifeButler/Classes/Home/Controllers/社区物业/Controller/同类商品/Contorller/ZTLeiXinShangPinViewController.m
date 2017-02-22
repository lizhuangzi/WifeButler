//
//  ZTLeiXinShangPinViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLeiXinShangPinViewController.h"
#import "ZTTongLeiShangPinCollectionViewCell.h"
#import "ZTTongLeiModel.h"
#import "ZTSheQuWuYeFuWuXiangQinViewController.h"
#import "MJRefresh.h"

typedef enum {
    
    RefreshShuaXin,      // 刷新
    RefreshJiaZa,        // 加载
    
}Refresh;


@interface ZTLeiXinShangPinViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
   int _price;
    NSMutableArray *_dataSource;
}

@property (nonatomic, assign) Refresh refresh;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ZTLeiXinShangPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPram];
    
    [self creteaRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setPram
{
    self.title = self.titleName;
    
    _price = 1;
    
    _dataSource = [NSMutableArray array];
}

- (void)creteaRefresh
{
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _price = 1;
        self.refresh = RefreshShuaXin;
        [self ZJNetWorking];
    }];
    
    // 上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _price ++;
        self.refresh = RefreshJiaZa;
        [self ZJNetWorking];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTTongLeiShangPinCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTTongLeiShangPinCollectionViewCell" forIndexPath:indexPath];
    
    ZTTongLeiModel *model = _dataSource[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.files]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.titleLab.text = model.title;
    
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", model.money];
    
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((iphoneWidth) / 3.0, (iphoneWidth) / 3.0 + 35);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
    ZTSheQuWuYeFuWuXiangQinViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeFuWuXiangQinViewController"];
    ZTTongLeiModel *model = _dataSource[indexPath.row];
    vc.goods_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)ZJNetWorking
{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    
    if (self.type == 1){
        
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:self.serve_idType forKey:@"serve_id"];
        [dic setObject:self.classId forKey:@"cat_id"];
        [dic setObject:@(_price) forKey:@"pageindex"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
        
        ZJLog(@"%@", dic);
        
        NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuGoods];
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            
            ZJLog(@"%@", responseObject);
            
            // 登录成功
            if ([[responseObject objectForKey:@"code"] intValue]==10000) {
                
                [SVProgressHUD dismiss];
                
                if (self.refresh == RefreshShuaXin) {
                    
                    _dataSource = [ZTTongLeiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
                }
                else
                {
                    [_dataSource addObjectsFromArray:[ZTTongLeiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
                }
                
                if (_dataSource.count < 9) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                    self.collectionView.mj_footer.hidden = NO;
                }
                
                [self.collectionView reloadData];
            }
            else
            {
                if ([[responseObject objectForKey:@"code"] intValue] == 30000) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                
                    [SVProgressHUD showInfoWithStatus:message];
                }
            }
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        }];
        
        
    }else{
        
        
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:self.serve_idType forKey:@"serve_id"];
        [dic setObject:self.keyBoard forKey:@"keyword"];
        [dic setObject:@(_price) forKey:@"pageindex"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
        
        NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuSearch];
        
        ZJLog(@"%@", dic);
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            ZJLog(@"%@", responseObject);
            
            // 登录成功
            if ([[responseObject objectForKey:@"code"] intValue] == 10000) {
                
                [SVProgressHUD dismiss];
    
                if (self.refresh == RefreshShuaXin) {
                    
                    _dataSource = [ZTTongLeiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
                }
                else
                {
                    [_dataSource addObjectsFromArray:[ZTTongLeiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
                }
                
                if (_dataSource.count < 9) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                    self.collectionView.mj_footer.hidden = NO;
                }
                
                [self.collectionView reloadData];
            }
            else
            {
                
                if ([[responseObject objectForKey:@"code"] intValue] == 30000) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                    
                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
                }
            }
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        }];
        
    }
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
