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
#import "ZTFuJinShangJiaViewController.h"
#import "ZTSheQuWuYeViewController.h"
#import "ZTSheQuQuanZiViewController.h"
#import "ZTSheQuZhenWuViewController.h"
#import "ZTQuanZiZViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "SDCycleScrollView.h"
#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZTJianKangShenHuoBottomModel.h"
#import "ZTLunBoToModel.h"
#import "UIColor+HexColor.h"
#import "Masonry.h"

#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerHomeTableHeaderView.h"
@interface ZJHomePageController ()<UIScrollViewDelegate, SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
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
    
    
    [self requestData];
    
    // 如果用户没有设置经纬度, 设置默认经纬度, 防止社区购物的时候没有物品
//    if ([NSGetUserDefaults(@"jing") length] == 0) {
//        
//        [self netWorkingJinWeiDu];
//    }

    // 延迟加载, 等候storyboard 加载完成
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [self netWorking];
//    });
    
}

- (void)requestData
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

- (void)createTableView
{
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor redColor];
    table.dataSource = self;
    table.delegate = self;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * rId = @"ID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rId];
    }
    return cell;
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
    
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    [vc setReturnBackBlock:^{
        [self createNav];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
//    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KHomeLunBoTu];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTLunBoToModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];

    }];
    
}

#pragma mark - 默认经纬度请求
- (void)netWorkingJinWeiDu
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [manager POST:KMoRenXiaoQuJinWeiDu parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            NSString *weiDu = responseObject[@"resultCode"][@"latitude"];
            NSString *jinDu = responseObject[@"resultCode"][@"longitude"];
            NSString *xiaoQu = responseObject[@"resultCode"][@"village"];
            
            NSSaveUserDefaults(jinDu, @"jing");
            NSSaveUserDefaults(weiDu, @"wei");
            NSSaveUserDefaults(xiaoQu, @"xiaoQu");
            self.addressLab.text = NSGetUserDefaults(@"xiaoQu");
        }
        else
        {
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
