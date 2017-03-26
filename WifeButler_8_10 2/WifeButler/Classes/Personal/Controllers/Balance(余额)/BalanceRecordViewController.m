//
//  BalanceRecordViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "BalanceRecordViewController.h"
#import "BalanceRecordTableViewCell.h"
#import "WifeButlerNetWorking.h"
#import "PersonalPort.h"
#import "WifeButlerDefine.h"
#import "BalanceRecordListModel.h"

@interface BalanceRecordViewController ()

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSUInteger page;
@end

@implementation BalanceRecordViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易明细";
    [self.tableView registerNib:[UINib nibWithNibName:@"BalanceRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BalanceRecordTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.page = 1;
    
    [self requestHttpData];
}


- (void)requestHttpData
{
    NSString * page = [NSString stringWithFormat:@"%zd",self.page];
    NSDictionary * parm = @{@"userid":KUserId,@"token":KToken,@"page":page};
    [SVProgressHUD showWithStatus:@""];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KTransactionRecord parameter:parm success:^(id resultCode) {
      
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            for (NSDictionary * dict in arr) {
                  BalanceRecordListModel * model = [BalanceRecordListModel modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        });

    } failure:^(NSError *error) {
        D_FailLoadingDeal(0);
    }];
}


- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestHttpData];
}

- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestHttpData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceRecordTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)dealloc
{
    ZJLog(@"BalanceRecordViewController dealloc");
}

@end
