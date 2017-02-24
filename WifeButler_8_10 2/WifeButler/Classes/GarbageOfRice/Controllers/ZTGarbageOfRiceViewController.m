//
//  ZTGarbageOfRiceViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGarbageOfRiceViewController.h"
//关联控制器
#import "ZJProcessorDetailTableVC.h"
#import "ZTLaJiHuanMiViewController.h"
//模型
#import "ZTLaJiHuanMiModel.h"
#import "exchangeStationModel.h"

//控件
#import "WifebutlerRCRHomeHeaderView.h"
#import "ZTLaJiHuanMiTableViewCell.h"

//头文件
#import "WifeButlerDefine.h"
#import "RCRNetWorkPort.h"
//工具
#import "MJRefresh.h"
#import "Masonry.h"
#import "WifeButlerNetWorking.h"


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
    
    [self requestData];
}

/**创建tableview及相关控件*/
- (void)createTableViewUI{
    
    UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    table.allowsSelection = NO;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView = table;
    
    WifebutlerRCRHomeHeaderView * headerView = [WifebutlerRCRHomeHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, iphoneWidth, 180);
    table.tableHeaderView = headerView;
    self.tableHeaderView = headerView;
}

- (void)requestData{
    
//    [WifeButlerNetWorking getHttpRequestWithURLsite:KexchangeStation parameter:nil success:^(NSDictionary *response) {
//       
//        if ([response[CodeKey] intValue] == SUCCESS) {
//            NSArray * array = response[@"resultCode"];
//            NSDictionary * dict = array.firstObject;
//           
//        }
//      
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    NSString * lok = NSGetUserDefaults(WifeButlerLongtitudeKey);
    NSString * lak = NSGetUserDefaults(WifeButlerLatitudeKey);
    parm[@"jing"] = lok;
    parm[@"wei"] = lak;
    
    [WifeButlerNetWorking postHttpRequestWithURLsite:KLaJiHuanMiList parameter:parm success:^(NSDictionary *response) {
        
        if ([response[CodeKey] intValue]==SUCCESS) {
            
            NSDictionary * resultCode = response[@"resultCode"];
            NSDictionary * shopDict = resultCode[@"shop"];
            exchangeStationModel * model = [exchangeStationModel exchangeStationModelWithDict:shopDict];
            self.tableHeaderView.model = model;
            
            NSArray * goodsList = resultCode[@"goods"];
            for (int i = 0; i<goodsList.count; i++) {
                NSDictionary * dict = goodsList[i];
                ZTLaJiHuanMiModel * rcrModel = [ZTLaJiHuanMiModel laJiHuanMiModelWithDictioary:dict];
                [self.dataArray addObject:rcrModel];
            }
            [self.tableView reloadData];
        }
       
        
    } failure:^(NSError *error) {
        
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
    return 80;
}

@end
