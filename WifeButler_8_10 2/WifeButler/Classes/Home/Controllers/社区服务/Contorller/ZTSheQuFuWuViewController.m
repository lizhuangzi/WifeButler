//
//  ZTSheQuFuWuViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/6.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuFuWuViewController.h"
#import "CommonShopLeftSelectTypeView.h"
#import "Masonry.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "NetWorkPort.h"
#import "WifeButlerLocationManager.h"
#import "ZTSheQuFuWuCollectionViewCell.h"
#import "ZTSheQuFuWuCollectionViewCellModel.h"

#import "ServiceListViewController.h"

@interface ZTSheQuFuWuViewController ()<CommonShopLeftSelectTypeViewSelectDelegate,UICollectionViewDelegateFlowLayout>
/**数据源*/
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) CommonShopLeftSelectTypeView * selectTypeView;
/**当前选中的模型*/
@property (nonatomic,weak) ShopLeftSelectTypeViewModel * currentSelectModel;

@property (nonatomic,strong) NSMutableDictionary * dataDict;

@end

@implementation ZTSheQuFuWuViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (instancetype)init
{
    if (self = [super init]) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 15;
        
        return [super initWithCollectionViewLayout:layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"社区服务";
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZTSheQuFuWuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZTSheQuFuWuCollectionViewCell"];
    
    CommonShopLeftSelectTypeView * selectView = [CommonShopLeftSelectTypeView AddIntoFatherView:self.view];
    selectView.selectDelegate = self;
    self.selectTypeView = selectView;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(selectView.mas_right);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    [self requestDataWithServiceID:@"2"];
}

- (void)requestDataWithServiceID:(NSString *)Id
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"jing"] = NSGetUserDefaults(@"jing");
    parm[@"wei"] = NSGetUserDefaults(@"wei");
    parm[@"serve_id"] = Id;
    [SVProgressHUD showWithStatus:@""];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KCommunityService parameter:parm success:^(NSDictionary * resultCode) {
        
        [SVProgressHUD dismiss];
        NSArray * cats = resultCode[@"cats"];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * dict in cats) {
            ShopLeftSelectTypeViewModel * model = [ShopLeftSelectTypeViewModel ShopLeftSelectTypeViewModelWithDictionary:dict];
            [tempArray addObject:model];
        }
        [self.selectTypeView receiveDatas:tempArray];
        for (int i = 0; i<cats.count; i++) {
            NSMutableArray * tempModelArray = [NSMutableArray new];
            NSDictionary * smallDict = cats[i];
            NSArray * child = smallDict[@"child"];
            for (int j = 0; j<child.count; j++) {
                NSDictionary * dict = child[j];
                ZTSheQuFuWuCollectionViewCellModel * model = [ZTSheQuFuWuCollectionViewCellModel modelWithDict:dict];
                [tempModelArray addObject:model];
            }
            ShopLeftSelectTypeViewModel * typeModel = tempArray[i];
            self.dataDict[typeModel.Id] = tempModelArray;
        }
        
        
        [self.selectTypeView defaultSelect];
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
}

#pragma CommonShopLeftSelectTypeViewDelegate
- (void)CommonShopLeftSelectTypeView:(CommonShopLeftSelectTypeView *)view didSelect:(ShopLeftSelectTypeViewModel *)model
{
    self.currentSelectModel = model;
    self.dataArray.array = self.dataDict[self.currentSelectModel.Id];
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZTSheQuFuWuCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTSheQuFuWuCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone5 || iPhone4) {
        return CGSizeMake(50, 70);
    }
    else if(iPhone6P){
        return CGSizeMake(85, 105);
    }else{
        return CGSizeMake(75, 95);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushServiceListViewWithServiceID:@"2" IndexPath:indexPath];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}


- (void)pushServiceListViewWithServiceID:(NSString *)Id IndexPath:(NSIndexPath *)indexPath
{
    ZTSheQuFuWuCollectionViewCellModel * model = self.dataArray[indexPath.item];
    
    ServiceListViewController * list = [[ServiceListViewController alloc]initWithServiceId:Id];
    list.catId = model.Id;
    list.title = model.name;
    [self.navigationController pushViewController :list animated:YES];

}

@end
