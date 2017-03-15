//
//  ZTXiaoQuXuanZeViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTXiaoQuXuanZeViewController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "NetWorkPort.h"
#import <MAMapKit/MAMapKit.h>
#import "WifeButlerLocationManager.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "NearbyVillageTableViewCell.h"

@interface ZTXiaoQuXuanZeViewController () <UISearchBarDelegate,MAMapViewDelegate>
{
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *XiaoQusearchBar;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic,assign) CLLocationCoordinate2D current2D;

@end

@implementation ZTXiaoQuXuanZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择小区";
    
    self.mapView.delegate = self;
    self.XiaoQusearchBar.delegate = self;
    _dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = WifeButlerTableBackGaryColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyVillageTableViewCell" bundle:nil] forCellReuseIdentifier:@"NearbyVillageTableViewCell"];
    
    self.tableView.rowHeight = 70;
    
    UIImageView * needle = [[UIImageView alloc]init];
    [self.view addSubview:needle];
    needle.bounds = CGRectMake(0, 0, 30, 30);
    needle.centerX = self.view.centerX;
    needle.centerY = self.mapView.centerY;
    needle.image = [UIImage imageNamed:@"ZTDingWei1111"];
    [self.mapView setZoomLevel:16.0];
    
    WEAKSELF;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf downLoadInfoSearch:self.XiaoQusearchBar.text Coordinate2D:self.current2D];
    }];
    
    [[WifeButlerLocationManager sharedManager] startLocationAndFinishBlock:^(WifeButlerLocationModel *locationInfo) {
        
        if (locationInfo.POIName) {
            [self.mapView setCenterCoordinate:locationInfo.location2D animated:NO];
        }
    }];
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
 
    ZJLog(@"%lf %lf",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
    self.current2D = self.mapView.centerCoordinate;
    [self downLoadInfoSearch:nil Coordinate2D:self.current2D];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NearbyVillageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyVillageTableViewCell" forIndexPath:indexPath];
    
    ZTXiaoQuXuanZe *model = _dataSource[indexPath.row];
    
    cell.villageLabel.text = model.village;
    cell.detailLocationLabel.text = model.position;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTXiaoQuXuanZe *model = _dataSource[indexPath.row];
    
    if (self.addressBlack) {
        
        self.addressBlack(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self downLoadInfoSearch:searchBar.text Coordinate2D:self.current2D];
    
    ZJLog(@"xxxxxxxxx");
}

#pragma mark - 数据小区
- (void)downLoadInfoSearch:(NSString *)word Coordinate2D:(CLLocationCoordinate2D)col
{
    WEAKSELF
    double la = col.latitude;
    double lo = col.longitude;
    NSString * laStr = [NSString stringWithFormat:@"%lf",la];
    NSString * loStr = [NSString stringWithFormat:@"%lf",lo];
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"lat"] = laStr;
    parm[@"lon"] = loStr;
    if (word) {
        parm[@"word"] = word;

    }else{
        parm[@"word"] = @"";
    }
    // 小区列表
    [SVProgressHUD showWithStatus:@""];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KvillageList parameter:parm success:^(NSArray * resultCode) {
        [SVProgressHUD dismiss];
        
        _dataSource.array = [ZTXiaoQuXuanZe mj_objectArrayWithKeyValuesArray:resultCode];
        
        [weakSelf.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [_dataSource removeAllObjects];
        [weakSelf.tableView reloadData];
        SVDCommonErrorDeal;
    }];
    
}


@end
