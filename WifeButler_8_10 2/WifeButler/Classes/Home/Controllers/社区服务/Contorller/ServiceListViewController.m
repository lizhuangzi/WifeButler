//
//  ServiceListViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ServiceListViewController.h"
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"
#import "ServiceListTableViewCell.h"
#import "ServiceListModel.h"
#import "WifeButlerDefine.h"
#import "ServiceDetailViewController.h"

@interface ServiceListViewController ()

@property (nonatomic,copy)NSString * serviceId;
@property (nonatomic,assign) NSUInteger page;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation ServiceListViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (instancetype)initWithServiceId:(NSString *)serviceId
{
    if (self = [super init]) {
        self.serviceId = serviceId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    [self requestHTTPData];
}

- (void)requestHTTPData
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"cat_id"] = self.catId;
    parm[@"serve_id"] = self.serviceId;
    parm[@"jing"] = NSGetUserDefaults(@"jing");
    parm[@"wei"] = NSGetUserDefaults(@"wei");
    parm[@"pageindex"] = [NSString stringWithFormat:@"%zd",self.page];
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:ServiceCategory parameter:parm success:^(NSArray * resultCode) {
        
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        if (resultCode.count == 0) { //无数据
            if (self.page == 1) {
                [SVProgressHUD showInfoWithStatus:@"无数据"];
                //显示无数据
            }else{
                self.page --;
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            }
        }else{ //有数据
            
            for (NSDictionary * dict in resultCode) {
                ServiceListModel * model = [ServiceListModel modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }

        }
        [self.tableView reloadData];
        [self.tableView endRefreshing];

    } failure:^(NSError *error) {
        
        self.page = 1;
        SVDCommonErrorDeal
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceListTableViewCell * cell = [ServiceListTableViewCell serviceListTableViewCellWithTableView:tableView];
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
    
    ServiceListModel * model = self.dataArray[indexPath.row];
    ServiceDetailViewController * sv = [[ServiceDetailViewController alloc]initWithGoodId:model.Id];
    [self.navigationController pushViewController:sv animated:YES];
}

#pragma loadingDelegate
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestHTTPData];
}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestHTTPData];
}

@end
