//
//  ZJHomePageController.m
//  Fish
//
//  Created by zjtdmac3 on 15/6/6.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "ZJHomePageController.h"
#import "ZJCommunityShopVC.h"
#import "LoopView.h"
//#import "ZTFuJinShangJiaViewController.h"
//#import "ZTSheQuWuYeViewController.h"
//#import "ZTSheQuQuanZiViewController.h"
//#import "ZTSheQuZhenWuViewController.h"
//#import "ZTQuanZiZViewController.h"
//#import "ZJGuangLiShouHuoDiZhiViewController.h"
//#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZTJianKangShenHuoBottomModel.h"
#import "ZTLunBoToModel.h"
#import "Masonry.h"
#import  "MJExtension.h"

#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"

#import "WifeButlerHomeTableHeaderView.h"
#import "HomePageCommodityCell.h"
#import "HomePageSectionHeaderView.h"

#import "HomePageSectionModel.h"
#import "HomePageCellModel.h"
#import "WifeButlerCommonDef.h"

@interface ZJHomePageController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconTopImageView;

@property (weak, nonatomic) IBOutlet UIView *cneterView;

@property (weak, nonatomic) IBOutlet UIView *gunDongView;

@property (nonatomic, assign) CGSize cardSize;

//首页tableview
@property (nonatomic,weak) UITableView * homeTableView;

/**tableview组的数组*/
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) WifeButlerHomeTableHeaderView * tableHeader;

@end

@implementation ZJHomePageController

#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createNav];
    
    [self createTableView];
    
    [self requestBannerData];
    
    // 如果用户没有设置经纬度, 设置默认经纬度, 防止社区购物的时候没有物品
    if ([NSGetUserDefaults(@"jing") length] == 0) {
        
        [self netWorkingJinWeiDu];
    }else{
        [self requestBoutiqueDataWithLongitude:NSGetUserDefaults(@"jing") latitude:NSGetUserDefaults(@"wei")];
    }
    
    // 延迟加载, 等候storyboard 加载完成
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [self netWorking];
    //    });
    
}

/**轮播图请求*/
- (void)requestBannerData
{
    [SVProgressHUD showWithStatus:@"正在加载.."];
    
    [WifeButlerNetWorking postHttpRequestWithURLsite:KSheQuGouWu parameter:nil success:^(NSDictionary * response) {
        
        ZJLog(@"%@",response);
        
        NSString *message = response[@"message"];
        
        // 登录成功
        if ([response[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            NSMutableArray * bannerModels = [ZTLunBoToModel mj_objectArrayWithKeyValuesArray:response[@"resultCode"]];
            
            // 轮播图
            [self createScorllView1:bannerModels];
            
            // 获取沙盒根目录
            //            NSString *directory = NSHomeDirectory();
            //
            //            NSLog(@"directory:%@", directory);
            //
            //            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataSource];
            //
            //            [data writeToFile:[NSString stringWithFormat:@"%@/LunBoTu", directory] atomically:YES];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"网络连接有误,请检查网络设置"];
    }];
}

- (void)requestBoutiqueDataWithLongitude:(NSString *)longtitude latitude:(NSString *)latitude
{
    NSArray * titleArr = @[@"兑换精选",@"商品精选",@"服务精选",@"物业精选"];
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"lng"] = longtitude;
    parm[@"lat"] = latitude;
    [WifeButlerNetWorking getHttpRequestWithURLsite:KBoutiqueData parameter:parm success:^(NSDictionary *response) {
        
        if ([response[CodeKey] intValue] == SUCCESS) {
            
            NSDictionary * resultCode = response[@"resultCode"];
            
            for (int i = 0; i<4; i++) {
               NSDictionary * tempDict = resultCode.allValues[i];
                HomePageSectionModel * sectionModel = [HomePageSectionModel SectionModelWithDictionary:tempDict];
                sectionModel.title = titleArr[i];
                [self.dataArray addObject:sectionModel];
            }
            
            [self.homeTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)createTableView
{
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    table.allowsSelection = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    WifeButlerHomeTableHeaderView * header = [WifeButlerHomeTableHeaderView WifeButlerHomeTableHeaderViewWithimageArray:nil];
    table.tableHeaderView = header;
    
    self.tableHeader = header;
    self.homeTableView = table;
}

#pragma mark - tableDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomePageSectionHeaderView * sectionView = [HomePageSectionHeaderView HeaderViewWithTableView:tableView];
    sectionView.sectionModel = self.dataArray[section];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCommodityCell * cell = [HomePageCommodityCell CommodityCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageSectionModel * model = self.dataArray[indexPath.section];
    return model.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}
#pragma mark - iCarousel的代理协议

//- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
//{
//    UIView *cardView = view;
//
//    if ( !cardView )
//    {
//        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
////        cardView.layer.masksToBounds = YES;
////        cardView.layer.cornerRadius = cardView.frame.size.width / 2.0;
//
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cardView.bounds];
//        [cardView addSubview:imageView];
//
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.tag = [@"image" hash];
//
//    }
//
//    UIImageView *imageView = (UIImageView*)[cardView viewWithTag:[@"image" hash]];
//    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ZT%ld%ld",index + 1, index + 1]];
//
//
//    return cardView;
//}


//- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
//{
//
//    //    NSLog(@"offsetoffsetoffset:%f", offset);
//
//    // 位置的变化
//    CGFloat translation = [self translationByOffset:offset];
//
//    // 大小的变化
//    CGFloat scale = [self scaleByOffset:offset];
//
//    transform = CATransform3DScale(transform, scale, scale, 1.0f);
//
//    return CATransform3DTranslate(transform, offset * self.cardSize.width, - translation * self.cardSize.width, 0);
//
//}

//- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
//{
//    ZJLog(@"indexindexindex:::%ld", (long)index);
//
//    __weak typeof(self) weakSelf = self;
//
//
//    if (index == 2) {
//
//        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
//        ZJCommunityShopVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJCommunityShopVC"];
//        nav.hidesBottomBarWhenPushed=YES;
//        [weakSelf.navigationController pushViewController:nav animated:YES];
//    }
//
//    if (index == 3) {
//
//        if (KToken == nil) {
//
//            [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
//
//            return;
//        }
//
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuQuanZi" bundle:nil];
//        ZTQuanZiZViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTQuanZiZViewController"];
//        nav.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:nav animated:YES];
//    }
//
//    if (index == 4) {
//
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuZhenWu" bundle:nil];
//        ZTSheQuZhenWuViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuZhenWuViewController"];
//        nav.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:nav animated:YES];
//    }
//
//    if (index == 0) {
//
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
//        ZTSheQuWuYeViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeViewController"];
//        nav.hidesBottomBarWhenPushed = YES;
//        nav.Type = 2;
//        [weakSelf.navigationController pushViewController:nav animated:YES];
//    }
//
//    if (index == 1) {
//
//        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTSheQuWuYe" bundle:nil];
//        ZTSheQuWuYeViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTSheQuWuYeViewController"];
//        nav.hidesBottomBarWhenPushed = YES;
//        nav.Type = 3;
//        [weakSelf.navigationController pushViewController:nav animated:YES];
//    }
//}

// 缩放大小
- (CGFloat)scaleByOffset:(CGFloat)offset
{
    
    if (offset > 0) {
        
        return 1.1 - (offset * 0.18);
    }
    
    else
    {
        return 1.1 + (offset * 0.18);
    }
    
}

// 抛物线程度
- (CGFloat)translationByOffset:(CGFloat)offset
{
    return (offset * offset) * 0.14;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.addressLab.text = NSGetUserDefaults(@"xiaoQu");
    
    if (self.addressLab.text.length == 0) {
        
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"为了方便为您服务,请先添加小区地址" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self addressClick:nil];
        }];
        
        [vc addAction:action];
        [vc addAction:otherAction];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 地址选择
- (IBAction)addressClick:(id)sender {
    
    //    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    //    [vc setReturnBackBlock:^{
    //        [self createNav];
    //    }];
    //    vc.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 选择地址
- (void)viewClick
{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJCommunityShopVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJCommunityShopVC"];
    nav.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nav animated:YES];
}


- (void)createNav
{
    self.addressLab.textColor = WifeButlerCommonRedColor;
    
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
    //                                                         forBarMetrics:UIBarMetricsDefault];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"ZTZhiHuan"] forState:UIControlStateNormal];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 请求数据
- (void)netWorking
{
    // 本地存放
    //    NSString *directory = NSHomeDirectory();
    //    NSData *dataPath = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/LunBoTu", directory]];
    //    _dataSource = [NSKeyedUnarchiver unarchiveObjectWithData:dataPath];
    //
    //    if (_dataSource.count != 0) {
    //
    //        [self createScorllView1:_dataSource];
    //    }
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KHomeLunBoTu];
    
    [WifeButlerNetWorking getHttpRequestWithURLsite:url parameter:nil success:^(NSDictionary *response) {
        
        NSString *message = [NSString stringWithFormat:@"%@", response[@"message"]];
        
        ZJLog(@"%@", response);
        
        // 登录成功
        if ([response[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTLunBoToModel mj_objectArrayWithKeyValuesArray:response[@"resultCode"]];
            
            // 轮播图
            [self createScorllView1:_dataSource];
            
            // 获取沙盒根目录
            NSString *directory = NSHomeDirectory();
            
            NSLog(@"directory:%@", directory);
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_dataSource];
            
            [data writeToFile:[NSString stringWithFormat:@"%@/LunBoTu", directory] atomically:YES];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];
    
}

#pragma mark - 默认经纬度请求
- (void)netWorkingJinWeiDu
{
    
    [WifeButlerNetWorking getHttpRequestWithURLsite:KMoRenXiaoQuJinWeiDu parameter:nil success:^(NSDictionary *response) {
        
        // 登录成功
        if ([response[@"code"] intValue] == SUCCESS) {
            
            [SVProgressHUD dismiss];
            
            NSString *weiDu = response[@"resultCode"][@"latitude"];
            NSString *jinDu = response[@"resultCode"][@"longitude"];
            NSString *xiaoQu = response[@"resultCode"][@"village"];
            
            [self requestBoutiqueDataWithLongitude:jinDu latitude:weiDu];
            
            NSSaveUserDefaults(jinDu, @"jing");
            NSSaveUserDefaults(weiDu, @"wei");
            NSSaveUserDefaults(xiaoQu, @"xiaoQu");
            self.addressLab.text = NSGetUserDefaults(@"xiaoQu");
        }
        else
        {
            
            
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];
    
}


#pragma mark - 轮播图
- (void)createScorllView1:(NSArray *)imageArr
{
    NSMutableArray *imageArrMutTemp = [NSMutableArray array];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        ZTLunBoToModel *model = imageArr[i];
        
        NSString *imageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, model.file];
        NSString *title = model.word;
        
        [titleArr addObject:title];
        [imageArrMutTemp addObject:imageStr];
    }
    self.tableHeader.bannerImageURLStrings = imageArrMutTemp;
}

/** 点击图片回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
//{
//
//    ZTLunBoToModel *model = _dataSource[index];
//
//    ZTXiangQinHealthyLifeViewController *vc = [[ZTXiangQinHealthyLifeViewController alloc] init];
//    vc.id_temp = model.goods_id;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}





@end
