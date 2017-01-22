//
//  ZJShopClassVC.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJShopClassVC.h"
#import "ZJShopClassCell.h"
#import "ZJGoodsDetailVC.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "WZLBadgeImport.h"
#import "ZTSheQuWuYeFuWuXiangQinViewController.h"
#import "ZJLoginController.h"

@interface ZJShopClassVC ()<UICollectionViewDataSource,UICollectionViewDelegate,ZJAddBusDelegate>

{
    UIButton *_btnGoShopCar;
    
    NSMutableArray *_dataSourceGoWuChe;
    
}

@property (nonatomic,strong)NSMutableArray*dataAry;
@property (nonatomic,assign)int currentSize;


@end

@implementation ZJShopClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentSize=1;
    
    self.title = _titleName;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setCollectionView];
    
    [self creteaRefresh];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // 创建购物车小控件
    _btnGoShopCar = [[UIButton alloc] initWithFrame:CGRectMake(10, iphoneHeight - 100, 50, 50)];
    [_btnGoShopCar setImage:[UIImage imageNamed:@"ZTCar"] forState:UIControlStateNormal];
    
    [_btnGoShopCar addTarget:self action:@selector(ClickTemp11) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *wid = [[UIApplication sharedApplication] keyWindow];;
    [wid addSubview:_btnGoShopCar];
    
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


- (void)creteaRefresh
{
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentSize=1;
        [self ZJNetWorking];
    }];
    
    // 上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self ZJNetWorking];
    }];
}

//加入购物车
-(void)addBusWithPath:(NSIndexPath *)path
{
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    NSMutableDictionary*dic = [NSMutableDictionary dictionary];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:[[self.dataAry objectAtIndex:path.row] objectForKey:@"id"] forKey:@"goods_id"];
    [dic setObject:@"1" forKey:@"num"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KAddBusURL];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        NSString *message = responseObject[@"message"];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue]==10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"添加购物车成功"];
            
            [self.collectionView reloadData];
            
            [self netWorkingGoWuChe];
            
        }else
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
                
                [SVProgressHUD showErrorWithStatus:message];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];

}

-(void)setCollectionView
{
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZJShopClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJShopClassCell" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"files"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cell.nameLabel.text=[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"money"]];
    cell.delegate=self;
    cell.path=indexPath;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

//    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
//    ZTSheQuWuYeFuWuXiangQinViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeFuWuXiangQinViewController"];
//    nav.goodId = [[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"id"];
//    [self.navigationController pushViewController:nav animated:YES];

    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJGoodsDetailVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
    nav.goodId = [[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:nav animated:YES];
}

//定义Cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((iphoneWidth-2)/3.0,170);
}

-(void)ZJNetWorking
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.type == 1){
        
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:self.serve_idType forKey:@"serve_id"];
        [dic setObject:self.classId forKey:@"cat_id"];
        
        [dic setObject:[NSString stringWithFormat:@"%d",self.currentSize] forKey:@"pageindex"];
        
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
                
                NSArray *reAry = [responseObject objectForKey:@"resultCode"];
                
                if (self.currentSize==1) {
                    
                    [self.dataAry removeAllObjects];
                }
                if (reAry.count>0) {
                    
                    self.currentSize++;
                }
                [self.dataAry addObjectsFromArray:reAry];
                
                if (self.dataAry.count < 9) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                    self.collectionView.mj_footer.hidden = NO;
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
            }
            else
            {
                [SVProgressHUD showInfoWithStatus:message];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_header endRefreshing];
            
        }];

        
    }else{
        
        
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:self.serve_idType forKey:@"serve_id"];
        [dic setObject:self.keyBoard forKey:@"keyword"];
        [dic setObject:[NSString stringWithFormat:@"%d",self.currentSize] forKey:@"pageindex"];
        
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
                
                NSArray*reAry=[responseObject objectForKey:@"resultCode"];
                
                if (self.currentSize == 1) {
                    
                    [self.dataAry removeAllObjects];
                }
                if (reAry.count > 0) {
                    
                    self.currentSize ++;
                }
                
                [self.dataAry addObjectsFromArray:reAry];
                
                if (self.dataAry.count < 9) {
                    
                    self.collectionView.mj_footer.hidden = YES;
                }
                else
                {
                    self.collectionView.mj_footer.hidden = NO;
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
                
            }else
            {
                [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];

        }];

    }
    
    
    
}

#pragma mark - 购物车
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


-(NSMutableArray*)dataAry
{
    if (!_dataAry) {
        _dataAry=[[NSMutableArray alloc]init];
    }
    return _dataAry;
}

@end
