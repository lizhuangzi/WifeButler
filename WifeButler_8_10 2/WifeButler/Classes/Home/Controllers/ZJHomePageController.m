//
//  ZJHomePageController.m
//  Fish
//
//  Created by zjtdmac3 on 15/6/6.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "ZJHomePageController.h"
//#import "ZTSheQuWuYeViewController.h"
//#import "ZTSheQuZhenWuViewController.h"
//#import "ZJGuangLiShouHuoDiZhiViewController.h"
//#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "EPCalendarViewController.h"
#import "ZJShopClassVC.h"
#import "ZTSheQuFuWuViewController.h"
#import "CommunityRealEstateController.h"
#import "ChooseLocationViewController.h"
#import "LoveDonateViewController.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTLaJiHuanMiViewController.h"
#import "ZJGoodsDetailVC.h"
#import "ServiceDetailViewController.h"
#import "CommunityRealEstateController.h"
#import "RecycleViewController.h"
#import "EnzymesRecycleViewController.h"
#import "MedRefFriendCircleViewController.h"
#import "WifeButlerWebViewController.h"

#import "ZTJianKangShenHuoBottomModel.h"
#import "ZTLunBoToModel.h"
#import "Masonry.h"
#import  "MJExtension.h"
#import "MJRefresh.h"

#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"

#import "WifeButlerHomeTableHeaderView.h"
#import "HomePageCommodityCell.h"
#import "HomePageSectionHeaderView.h"

#import "HomePageSectionModel.h"
#import "HomePageCellModel.h"
#import "WifebutlerConst.h"
#import "WifeButlerDefine.h"
#import "WifeButlerLocationManager.h"
#import "InformationPort.h"

@interface ZJHomePageController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HomePageCommodityCellDelegate>
{
    NSArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UILabel *addressLab;


@property (nonatomic, assign) CGSize cardSize;

//首页tableview
@property (nonatomic,weak) UITableView * homeTableView;

/**tableview组的数组*/
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) WifeButlerHomeTableHeaderView * tableHeader;

@property (nonatomic,assign) BOOL canLoadAppear;

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
    
    [self listenNotify];

    [self requestBannerData];
    
    self.canLoadAppear = NO;
    
    if ([WifeButlerAccount sharedAccount].isLogin) { //如果用户登录了
        
        if([WifeButlerLocationManager sharedManager].village.length == 0){ //用户没地址
            [self tianjiaDiZhi];
            [self netWorkingJinWeiDu];
            
        }else{ //用户有地址
            NSString * jing = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].longitude];
            NSString * wei = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].latitude];
            self.addressLab.text = [WifeButlerLocationManager sharedManager].village;
            [self requestBoutiqueDataWithLongitude:jing latitude:wei];
        }

    }else{
        [self netWorkingJinWeiDu];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //没登录或者 没有地址
   
    if (self.canLoadAppear) {
        if (![WifeButlerAccount sharedAccount].isLogin || [WifeButlerLocationManager sharedManager].village.length == 0) {
            [self netWorkingJinWeiDu];
        }
    }
}

/**监听通知*/
- (void)listenNotify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locatedChange) name:WifebutlerLocationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:LoginViewControllerDidLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOut) name:WifeButlerUserDidLogOutNotification object:nil];
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
        [self.dataArray removeAllObjects];
        if ([response[CodeKey] intValue] == SUCCESS) {
            
            NSDictionary * resultCode = response[@"resultCode"];
            
            for (int i = 0; i<4; i++) {
               NSDictionary * tempDict = resultCode.allValues[i];
                HomePageSectionModel * sectionModel = [HomePageSectionModel SectionModelWithDictionary:tempDict];
                sectionModel.type = i;
                
                sectionModel.title = titleArr[i];
                [self.dataArray addObject:sectionModel];
            }
            
            [self.homeTableView reloadData];
        }else{
            [self.dataArray removeAllObjects];
            [self.homeTableView.mj_header endRefreshing];
        }
        [self.homeTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.dataArray removeAllObjects];
        [self.homeTableView.mj_header endRefreshing];
    }];
}

#pragma mark - 创建table
- (void)createTableView
{
    //创建tableview
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
   
    WEAKSELF
    //创建tableviewheaderview
    WifeButlerHomeTableHeaderView * header = [WifeButlerHomeTableHeaderView WifeButlerHomeTableHeaderViewWithimageArray:nil];
    
    [header setReturnBlock:^(NSInteger index) {
        
        [weakSelf delalPushViewControllerWithClickIndex:index];
        
    }];
    
    
    [header setTopScrollViewClick:^(ZTLunBoToModel * model){
        NSString * urlStr = [NSString stringWithFormat:KinformationDetial,model.goods_id];
        WifeButlerWebViewController * web = [[WifeButlerWebViewController alloc]initWithUrlStr:urlStr];
        web.title = @"资讯详情";
        [self.navigationController pushViewController:web animated:YES];
    }];
    table.tableHeaderView = header;
    
    table.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        if ([WifeButlerAccount sharedAccount].isLogin) { //如果用户登录了
            if ([WifeButlerLocationManager sharedManager].village.length == 0) {//用户没设置默认地址
                [weakSelf netWorkingJinWeiDu];
            }else{
                NSString * jing = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].longitude];
                NSString * wei = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].latitude];
                self.addressLab.text = [WifeButlerLocationManager sharedManager].village;
                [weakSelf requestBoutiqueDataWithLongitude:jing latitude:wei];
            }
        }else{
            [weakSelf netWorkingJinWeiDu];
        }
    }];
    
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
    cell.delegate = self;
    cell.model = self.dataArray[indexPath.section];
    return cell;
}

#pragma tableViewDelegate
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
    return 163;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - push控制器操作
- (void)delalPushViewControllerWithClickIndex:(NSInteger)index
{
    WifeButlerLetUserLoginCode
    switch (index) {
        case 0:{ //社区圈子
            //[SVProgressHUD showInfoWithStatus:@"功能暂未开放"];
            //     WifeButlerLetUserLoginCode
            
            MedRefFriendCircleViewController * circle = [[MedRefFriendCircleViewController alloc]init];
            [self.navigationController pushViewController:circle animated:YES];
        }
            break;
        case 1:{ //社区购物
            ZJShopClassVC * shop = [[ZJShopClassVC alloc]init];
            [self.navigationController pushViewController:shop animated:YES];
        }
            break;
        case 2:{ //社区服务
            ZTSheQuFuWuViewController * ser = [[ZTSheQuFuWuViewController alloc]init];
            [self.navigationController pushViewController:ser animated:YES];
        }
            break;
        case 3:{
            CommunityRealEstateController * realEstate = [[CommunityRealEstateController alloc]init];
            [self.navigationController pushViewController:realEstate animated:YES];
        }
            break;
        case 4:{ //环保日历
            
            EPCalendarViewController * calendar = [[EPCalendarViewController alloc]init];
            [self.navigationController pushViewController:calendar animated:YES];
        }
            break;
        case 5:{
            LoveDonateViewController * lo = [LoveDonateViewController new];
            [self.navigationController pushViewController:lo animated:YES];
        }
            break;
        case 6:{
            RecycleViewController * re = [RecycleViewController new];
            [self.navigationController pushViewController:re animated:YES];
        }
            break;
        case 7:{
            EnzymesRecycleViewController * ez = [EnzymesRecycleViewController new];
            [self.navigationController pushViewController:ez animated:YES];
        }
            break;
        default:
            break;
    }
}







- (void)tianjiaDiZhi
{
    D_CommonAlertShow(@"您还没添加默认收货地址 块去添加吧", ^{
        
        [self titleButtonClick];
    });
}

- (void)createNav
{
    self.addressLab.textColor = [UIColor whiteColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"shopCart"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoShopCart) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item1;
}

#pragma mark - 默认经纬度请求
- (void)netWorkingJinWeiDu
{
    [[WifeButlerLocationManager sharedManager]startLocationAndFinishBlock:^(WifeButlerLocationModel *locationInfo) {
        
        if (locationInfo.POIName.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请求默认经纬度失败,请检查你的网络连接"];
            return ;
        }
        
        NSString * jingDu = [NSString stringWithFormat:@"%f",locationInfo.location2D.longitude];
        NSString * weiDu = [NSString stringWithFormat:@"%f",locationInfo.location2D.latitude];
        
        [WifeButlerLocationManager sharedManager].longitude = locationInfo.location2D.longitude;
        [WifeButlerLocationManager sharedManager].latitude = locationInfo.location2D.latitude;
        [WifeButlerLocationManager sharedManager].village = locationInfo.POIName;
        self.addressLab.text = locationInfo.POIName;
        
        [self requestBoutiqueDataWithLongitude:jingDu latitude:weiDu];
    }];
}


#pragma mark - 轮播图
- (void)createScorllView1:(NSArray *)imageArr
{
    NSMutableArray *imageArrMutTemp = [NSMutableArray array];
    
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        ZTLunBoToModel *model = imageArr[i];
        
        NSString *imageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, model.file];
        [imageArrMutTemp addObject:imageStr];
    }
    self.tableHeader.bannerImageURLStrings = imageArrMutTemp;
    self.tableHeader.lunboModelArr = imageArr;
}


#pragma mark - 经纬度改变通知刷新页面
- (void)locatedChange
{
    double lo = [WifeButlerLocationManager sharedManager].longitude;
    double la = [WifeButlerLocationManager sharedManager].latitude;
    NSString * lon = [NSString stringWithFormat:@"%lf",lo];
    NSString * lat = [NSString stringWithFormat:@"%lf",la];
    [self.dataArray removeAllObjects];
    [self requestBoutiqueDataWithLongitude:lon latitude:lat];
    self.addressLab.text = [WifeButlerLocationManager sharedManager].village;
}

- (void)userLogOut
{
    self.canLoadAppear = NO;
}

- (void)userLogin
{
    self.canLoadAppear = YES;
    if([WifeButlerLocationManager sharedManager].village.length == 0){ //用户没地址
        [self tianjiaDiZhi];
        [self netWorkingJinWeiDu];
        
    }else{ //用户有地址
        NSString * jing = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].longitude];
        NSString * wei = [NSString stringWithFormat:@"%f", [WifeButlerLocationManager sharedManager].latitude];
        self.addressLab.text = [WifeButlerLocationManager sharedManager].village;
        [self requestBoutiqueDataWithLongitude:jing latitude:wei];
    }
}

- (IBAction)titleButtonClick {
    
    ChooseLocationViewController * vc = [[ChooseLocationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)gotoShopCart{
    
    WifeButlerLetUserLoginCode
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
    ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)HomePageCommodityCell:(HomePageCommodityCell *)cell didClickFindMore:(HomePageSectionModel *)model
{
    if ([model.title isEqualToString:@"兑换精选"]) {
        [self.tabBarController setSelectedIndex:2];
    }else if ([model.title isEqualToString:@"商品精选"]){
        ZJShopClassVC * shop = [[ZJShopClassVC alloc]init];
        [self.navigationController pushViewController:shop animated:YES];
    }else if ([model.title isEqualToString:@"服务精选"]){
        ZTSheQuFuWuViewController * ser = [[ZTSheQuFuWuViewController alloc]init];
        [self.navigationController pushViewController:ser animated:YES];

    }else if ([model.title isEqualToString:@"物业精选"]){
        CommunityRealEstateController * realEstate = [[CommunityRealEstateController alloc]init];
        [self.navigationController pushViewController:realEstate animated:YES];
    }

}

- (void)HomePageCommodityCell:(HomePageCommodityCell *)cell didClickOneCommdity:(HomePageCellModel *)model
{
    if ([cell.model.title isEqualToString:@"兑换精选"]) {
        ZTLaJiHuanMiViewController * huami = [ZTLaJiHuanMiViewController new];
        huami.good_id = model.commodityId;
        [self.navigationController pushViewController:huami animated:YES];
    }
    else if ([cell.model.title isEqualToString:@"商品精选"]) {
        UIStoryboard * story = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
        ZJGoodsDetailVC * vc = [story instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
        vc.goodId = model.commodityId;
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if ([cell.model.title isEqualToString:@"服务精选"] || [cell.model.title isEqualToString:@"物业精选"]) {
        ServiceDetailViewController * service = [[ServiceDetailViewController alloc]initWithGoodId:model.commodityId];
        [self.navigationController pushViewController:service animated:YES];
    }
}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat fl = scrollView.contentOffset.y;
//    self.navigationController.navigationBar.alpha = 1 - fl/iphoneHeight;
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
