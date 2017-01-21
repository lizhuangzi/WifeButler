//
//  ZTXuanZeTimeViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTXuanZeTimeViewController.h"
#import "ZTTime1CollectionViewCell.h"
#import "ZTTime2CollectionViewCell.h"
#import "ZTHeardMMCollectionReusableView.h"
#import "ZTTimeBottonModel.h"
#import "ZTTimeTopModel.h"

@interface ZTXuanZeTimeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger _indexTemp;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// 选择
@property (nonatomic, assign) int inTag;

@property (nonatomic, strong) NSMutableArray * dataSource;

// 底部模型
@property (nonatomic, strong) NSMutableArray * dataSourceBotton;

// black返回的时间
@property (nonatomic, copy) NSString * timeBack;

@end

@implementation ZTXuanZeTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择时间";
    
    _indexTemp = 0;
    
    self.dataSource = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(queDing)];
    
    [self netWorking];
}

- (void)queDing
{
    
    if (self.BackTimeBlack) {
        
        self.BackTimeBlack(self.timeBack);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dataSource.count) {
        
        NSDictionary *tempDic = self.dataSource[_indexTemp];
        
        NSArray *arrTemp = tempDic[@"time"];
        
        return arrTemp.count + 1;
    }
    else
    {
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        // 1周时间
        ZTTime2CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTTime2CollectionViewCell" forIndexPath:indexPath];
        
        cell.dataSource = self.dataSource;
        
        [cell setCollectionViewTemp];
        
        
        [cell setDianJiShiJianBlack:^(NSInteger i) {
           
            // 选中状态恢复
            _inTag = -1;
            
            // 点击顶部的选中状态
            _indexTemp = i;
            
            [_collectionView reloadData];
            
        }];
        
        cell.selectRow = _indexTemp;
        
        return cell;
    }
    else
    {
        // 每天时间
        ZTTime1CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTTime1CollectionViewCell" forIndexPath:indexPath];
    
        
        NSDictionary *tempDic = self.dataSource[_indexTemp];
        
        NSArray *arrTemp = [ZTTimeBottonModel mj_objectArrayWithKeyValuesArray:tempDic[@"time"]];
    
        ZTTimeBottonModel *model = arrTemp[indexPath.row - 1];
        
        cell.timeLab.text = model.time;
        
        if ([model.type intValue] == 1) {
            
            cell.backImageView.image = [UIImage imageNamed:@"ZTShiJianSelect"];
        }
        else
        {
            cell.backImageView.image = [UIImage imageNamed:@"ZTHuiZhuanKuan"];
        }
        
        if (indexPath.row == _inTag) {
            
            cell.backImageView.image = [UIImage imageNamed:@"ZTShiJian"];
        }
        
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempDic = self.dataSource[_indexTemp];
    
    NSArray *arrTemp = [ZTTimeBottonModel mj_objectArrayWithKeyValuesArray:tempDic[@"time"]];
    
    ZTTimeBottonModel *model = arrTemp[indexPath.row - 1];
    
    if ([model.type intValue] == 1) {
        
        
        return;
    }
    
    _inTag = (int)indexPath.row;
    
    // 预约的时间
    self.timeBack = [NSString stringWithFormat:@"%@ %@", tempDic[@"date"], model.time];
    
    [_collectionView reloadData];
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return CGSizeMake(iphoneWidth, 48);
    }
    
    return CGSizeMake(((iphoneWidth) / 4.0) - 20, 45);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader){
        
        ZTHeardMMCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ZTHeardMMCollectionReusableView" forIndexPath:indexPath];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    
    if ([self.exchange length] != 0) {
        
        [dic setObject:@"1" forKey:@"exchange"];
    }
    
    [dic setObject:self.goods_id forKey:@"goods_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KYuYueTime];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
//            self.dataSource = [ZTTimeTopModel mj_keyValuesArrayWithObjectArray:responseObject[@"resultCode"]];
            
            self.dataSource = responseObject[@"resultCode"];
            
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
