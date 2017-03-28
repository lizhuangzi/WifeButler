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
#import "PersonalPort.h"

@interface ZTXiaoQuXuanZeViewController () <UISearchBarDelegate,MAMapViewDelegate,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *XiaoQusearchBar;

@property (weak, nonatomic) IBOutlet MAMapView *mapView;

@property (nonatomic,assign) CLLocationCoordinate2D current2D;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTopCon;
@property (nonatomic,assign) BOOL firstLoad;

@property (nonatomic,weak) UIImageView * pointImage;
@end

@implementation ZTXiaoQuXuanZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择小区";
    _firstLoad = YES;
    
    self.XiaoQusearchBar.delegate = self;
    _dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = WifeButlerTableBackGaryColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearbyVillageTableViewCell" bundle:nil] forCellReuseIdentifier:@"NearbyVillageTableViewCell"];
    
    self.tableView.rowHeight = 70;
    
    UIImageView * needle = [[UIImageView alloc]init];
    [self.view addSubview:needle];
    needle.bounds = CGRectMake(0, 0, 18, 30);
    needle.centerX = self.view.centerX;
    needle.centerY = self.mapView.centerY;
    needle.image = [UIImage imageNamed:@"mapViewloc"];
    self.pointImage = needle;
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;

    [self.mapView setZoomLevel:16.0];
    
    WEAKSELF;
    if (self.choseType == 0) {
        
        [[WifeButlerLocationManager sharedManager] startLocationAndFinishBlock:^(WifeButlerLocationModel *locationInfo) {
            _firstLoad = NO;
            if (locationInfo.POIName) {
                [weakSelf.mapView setCenterCoordinate:locationInfo.location2D animated:NO];
            }
        }];
    }else{
        CLLocationCoordinate2D  l = CLLocationCoordinate2DMake(self.changeLatitude, self.changeLongitude);
         [weakSelf.mapView setCenterCoordinate:l animated:NO];
    }
}

- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
 
    if (_firstLoad && self.choseType == 0) { return;}
    
    ZJLog(@"%lf %lf",self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
    [self.view endEditing:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self downLoadInfoSearch:searchBar.text Coordinate2D:self.current2D];
    }
}

//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    [self requestAllVillage];
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

    parm[@"word"] = @"";
    parm[@"lat"] = laStr;
    parm[@"lon"] = loStr;
    
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

- (void)requestAllVillage
{
    [SVProgressHUD showWithStatus:@""];
    NSDictionary * parm = @{@"search":self.XiaoQusearchBar.text};
    NSString * word = self.XiaoQusearchBar.text;
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KGetSearchVillageList parameter:parm success:^(id resultCode) {
        [SVProgressHUD dismiss];
        _dataSource.array = [ZTXiaoQuXuanZe mj_objectArrayWithKeyValuesArray:resultCode];
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (word.length>0) {
            self.tableTopCon.constant = 44;
            self.pointImage.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [_dataSource removeAllObjects];
        [self.tableView reloadData];
        SVDCommonErrorDeal;
    }];
}

- (void)dealloc
{
    ZJLog(@"选择小区 dealloc *****");
}
@end
