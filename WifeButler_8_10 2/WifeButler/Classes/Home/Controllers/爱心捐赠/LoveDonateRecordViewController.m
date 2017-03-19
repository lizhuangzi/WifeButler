//
//  LoveDonateRecordViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateRecordViewController.h"
#import "LoveDonateRecordTableViewCell.h"
#import "LoveDonateRecordHeader.h"
#import "NetWorkPort.h"
#import "WifeButlerDefine.h"
#import "WifeButlerNetWorking.h"
#import "LoaveDonateRecorelistModel.h"

@interface LoveDonateRecordViewController ()

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,weak) LoveDonateRecordHeader * headerView;

@property (nonatomic,assign) NSUInteger page;
@end

@implementation LoveDonateRecordViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"捐赠记录";
    
    [self setUpUI];
    [self requestData];
}

- (void)setUpUI
{
    LoveDonateRecordHeader * headerView = [LoveDonateRecordHeader headerView];
    headerView.frame = CGRectMake(0, 0, self.view.width, 150);
    headerView.usermodel = self.usermodel;
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    [backView addSubview:headerView];
    self.tableView.tableHeaderView = backView;
    
    self.headerView = headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoveDonateRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"LoveDonateRecordTableViewCell"];

}

- (void)requestData
{
    NSString * urlStr = [NSString stringWithFormat:KLoveDonateUserRecordlist,KUserId,@(self.page)];
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:urlStr parameter:nil success:^(id resultCode) {
        
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            
            for (NSDictionary * dict in arr) {
                LoaveDonateRecorelistModel * m = [LoaveDonateRecorelistModel modelWithDictionary:dict];
                [self.dataArray addObject:m];
            }
        });


    } failure:^(NSError *error) {
        D_FailLoadingDeal(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDonateRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoveDonateRecordTableViewCell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"我的捐赠记录";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - loading refresh
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestData];
}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestData];
    
}


@end
