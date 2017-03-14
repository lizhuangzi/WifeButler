//
//  ChooseLocationViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/13.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "CurrentLocationTableViewCell.h"
#import "DeliveryLocationTableViewCell.h"
#import "NearbyVillageTableViewCell.h"
#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerLocationManager.h"
#import "WifebutlerConst.h"

@interface ChooseLocationViewController ()<UITableViewDelegate,UITableViewDataSource>
/**小区列表*/
@property (nonatomic,strong) NSMutableArray * nearByvillageList;
/**收货地址列表*/
@property (nonatomic,strong) NSMutableArray * DeliveryLocationList;

@property (nonatomic,weak) UITableView * tableView;

/**当前定位位置*/
@property (nonatomic,strong)WifeButlerLocationModel * currentLocationModel;
@end

@implementation ChooseLocationViewController

#pragma mark - lazy
- (NSMutableArray *)nearByvillageList
{
    if (!_nearByvillageList) {
        _nearByvillageList = [NSMutableArray array];
    }
    return _nearByvillageList;
}

- (NSMutableArray *)DeliveryLocationList
{
    if (!_DeliveryLocationList) {
        _DeliveryLocationList = [NSMutableArray array];
    }
    return  _DeliveryLocationList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpUI];
    
    [self requestDeliverLocation];
    [self requestLocationAndNearbyVillage];
}

- (void)setUpUI
{
    self.title = @"选择地址";
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;

    [self.view addSubview:table];
    
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [table registerNib:[UINib nibWithNibName:@"CurrentLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"CurrentLocationTableViewCell"];
    [table registerNib:[UINib nibWithNibName:@"DeliveryLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"DeliveryLocationTableViewCell"];
    [table registerNib:[UINib nibWithNibName:@"NearbyVillageTableViewCell" bundle:nil] forCellReuseIdentifier:@"NearbyVillageTableViewCell"];
    
    self.tableView = table;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地址管理" style:UIBarButtonItemStylePlain target:self action:@selector(locationManage)];
    [self showFooter];
}

- (void)showFooter
{
    UILabel * label = [[UILabel alloc]init];
    label.textColor = WifeButlerGaryTextColor2;
    label.text = @"附近小区对接中....";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, iphoneWidth, 44);
    self.tableView.tableFooterView = label;
}

- (void)locationManage
{
    ZJGuangLiShouHuoDiZhiViewController * vc = [[ZJGuangLiShouHuoDiZhiViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**请求收货地址*/
- (void)requestDeliverLocation
{
    WEAKSELF
    NSDictionary * parm1 = @{@"pageindex":@"1",@"token":KToken};
    //我的收货地址
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KMyDeliveryLocation parameter:parm1 success:^(NSArray * resultCode) {
        
        self.DeliveryLocationList.array = resultCode;
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];

}
/**请求附近小区数据*/
- (void)requestLocationAndNearbyVillage
{
    self.currentLocationModel = nil;
    WEAKSELF;
    [[WifeButlerLocationManager sharedManager]startLocationAndFinishBlock:^(WifeButlerLocationModel * locationInfo) {
        
         weakSelf.currentLocationModel = locationInfo;
        if (locationInfo.location2D.longitude == 0.0 && locationInfo.location2D.latitude == 0.0) {
            weakSelf.currentLocationModel.formateAddress = @"定位失败，请在设置中开启应用定位功能";
            [weakSelf.tableView reloadData];
            return ;
        }
       
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
        double la = locationInfo.location2D.latitude;
        double lo = locationInfo.location2D.longitude;
        NSString * laStr = [NSString stringWithFormat:@"%lf",la];
        NSString * loStr = [NSString stringWithFormat:@"%lf",lo];
        NSDictionary * parm2 = @{@"word":@"",@"lat":laStr,@"lon":loStr};
        // 小区列表
        [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KvillageList parameter:parm2 success:^(NSArray * resultCode) {
            weakSelf.tableView.tableFooterView = nil;
            weakSelf.nearByvillageList.array = resultCode;
            [weakSelf.tableView reloadData];
            
        } failure:^(NSError *error) {
            if (error.code == 30000) {
                [weakSelf showFooter];
            }
        }];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.DeliveryLocationList.count;
    }else{
        return self.nearByvillageList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CurrentLocationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentLocationTableViewCell"];
        if(self.currentLocationModel)
            cell.locationLabel.text = self.currentLocationModel.formateAddress;
        else
            cell.locationLabel.text = @"正在定位当前定位...";
       
        [cell.reLocateBtn addTarget:self action:@selector(relocated) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else if (indexPath.section == 1){
        
        DeliveryLocationTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryLocationTableViewCell"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.dataDict = self.DeliveryLocationList[indexPath.row];
        return cell;
    }else{
        
        NearbyVillageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NearbyVillageTableViewCell"];
        NSDictionary * dict = self.nearByvillageList[indexPath.row];
        cell.villageLabel.text = dict[@"village"];
        cell.detailLocationLabel.text = dict[@"position"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 44;
    }else if (indexPath.section == 1){
        return 70;
    }else{
        return 65;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"当前地址";
    }else if (section == 1){
        return @"收货地址";
    }else{
        return @"附近小区";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!self.currentLocationModel) return; //不存在reutrn
        
        [WifeButlerLocationManager sharedManager].longitude = self.currentLocationModel.location2D.longitude;
         [WifeButlerLocationManager sharedManager].latitude = self.currentLocationModel.location2D.latitude;
         [WifeButlerLocationManager sharedManager].village = self.currentLocationModel.POIName;
        
    }else if (indexPath.section == 1){
        
        NSDictionary * dictd = self.DeliveryLocationList[indexPath.row];
        [WifeButlerLocationManager sharedManager].longitude = [dictd[@"longitude"] doubleValue];
        [WifeButlerLocationManager sharedManager].latitude = [dictd[@"latitude"] doubleValue];
        [WifeButlerLocationManager sharedManager].village = dictd[@"village_name"];
    }else{
        
        NSDictionary * dictv = self.nearByvillageList[indexPath.row];
       [WifeButlerLocationManager sharedManager].latitude =[dictv[@"latitude"] doubleValue];
       [WifeButlerLocationManager sharedManager].longitude = [dictv[@"longitude"] doubleValue];
       [WifeButlerLocationManager sharedManager].village = dictv[@"village"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:WifebutlerLocationDidChangeNotification object:nil userInfo:nil];
}

- (void)relocated
{
    [self requestLocationAndNearbyVillage];
    [self.nearByvillageList removeAllObjects];
    [self.tableView reloadData];
}



- (void)dealloc
{
    ZJLog(@"ChooseLocationViewController dealloc");
}
@end
