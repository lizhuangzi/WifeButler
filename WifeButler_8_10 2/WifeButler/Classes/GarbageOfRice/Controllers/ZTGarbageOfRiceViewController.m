//
//  ZTGarbageOfRiceViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGarbageOfRiceViewController.h"
//关联控制器
#import "ZTLaJiHuanMiViewController.h"
#import "UserQRViewController.h"
//模型
#import "ZTLaJiHuanMiModel.h"
#import "exchangeStationModel.h"

//控件
#import "WifebutlerRCRHomeHeaderView.h"
#import "ZTLaJiHuanMiTableViewCell.h"

//头文件
#import "WifebutlerConst.h"
#import "RCRNetWorkPort.h"
//工具
#import "MJRefresh.h"
#import "Masonry.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerLocationManager.h"
#import "WifeButlerDefine.h"

#import "WifeButlerNoDataView.h"

/** 兑换点接口 */
@interface ZTGarbageOfRiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) UITableView * tableView;

@property (nonatomic,weak) WifebutlerRCRHomeHeaderView * tableHeaderView;
@end

@implementation ZTGarbageOfRiceViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableViewUI];
    
    [self listenNotify];
    
    [self requestData];
}

/**创建tableview及相关控件*/
- (void)createTableViewUI{
    
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView = table;
    WEAKSELF
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
    
    WifebutlerRCRHomeHeaderView * headerView = [WifebutlerRCRHomeHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, iphoneWidth, 209);
    table.tableHeaderView = headerView;
    self.tableHeaderView = headerView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"QRCodeImage"] style:UIBarButtonItemStylePlain target:self action:@selector(WifebutlerRCRHomeHeaderViewdidClickQR)];
    
    [self createLeftItem];
}

- (void)createLeftItem
{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    btn.frame = CGRectMake(0, 0, 120, 17);
    [btn setImage:[UIImage imageNamed:@"ArrowDown2"] forState:UIControlStateNormal];
    [btn setTitle:[WifeButlerLocationManager sharedManager].village forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];

}

/**监听通知*/
- (void)listenNotify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locatedChange) name:WifebutlerLocationDidChangeNotification object:nil];
}

- (void)requestData{
    
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[WifeButlerLongtitudeKey] = @([WifeButlerLocationManager sharedManager].longitude);
    parm[WifeButlerLatitudeKey] = @([WifeButlerLocationManager sharedManager].latitude);

    [WifeButlerNetWorking postHttpRequestWithURLsite:KLaJiHuanMiList parameter:parm success:^(NSDictionary *response) {
        
        if ([response[CodeKey] intValue]==SUCCESS) {
            
            WifeButlerNoDataViewRemoveFrom(self.view);
            
            NSDictionary * resultCode =  response[@"resultCode"];
            NSDictionary * shop = resultCode[@"shop"];
            exchangeStationModel * model = [exchangeStationModel exchangeStationModelWithDict:shop];
            self.tableHeaderView.model = model;
            
            [self.dataArray removeAllObjects];
            NSArray * goodsList = resultCode[@"goods"];
            for (int i = 0; i<goodsList.count; i++) {
                NSDictionary * dict = goodsList[i];
                ZTLaJiHuanMiModel * rcrModel = [ZTLaJiHuanMiModel laJiHuanMiModelWithDictioary:dict];
                [self.dataArray addObject:rcrModel];
            }
            [self.tableView reloadData];
        }else{
            
            WifeButlerNoDataViewShow(self.view,1,nil);
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        SVDCommonErrorDeal
    }];
}

#pragma mark - tableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTLaJiHuanMiTableViewCell * cell = [ZTLaJiHuanMiTableViewCell LaJiHuanMiTableViewCellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZTLaJiHuanMiModel * model = self.dataArray[indexPath.row];

    ZTLaJiHuanMiViewController * vc =[[ZTLaJiHuanMiViewController  alloc]init];
    vc.good_id = model.commodityId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 经纬度改变通知刷新页面
- (void)locatedChange
{
    [self createLeftItem];
    
    [self requestData];
}

- (void)choose
{
    
}

- (void)WifebutlerRCRHomeHeaderViewdidClickQR
{
    UserQRViewController *qrVc = [[UserQRViewController alloc]init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

@end
