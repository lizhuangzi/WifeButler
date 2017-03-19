//
//  MyDonateViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "MyDonateViewController.h"
#import "MyDonateTableViewCell.h"
#import "MyDonateHeaderView.h"
#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "MyDonateUserModel.h"
#import "MyDonateUserlistModel.h"
#import "WifeButlerDefine.h"

#import "LoveDonateRecordViewController.h"
#import "LoveDonateDetailViewController.h"


@interface MyDonateViewController ()
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) MyDonateHeaderView * headerView;

@property (nonatomic,strong) MyDonateUserModel * userModel;

@property (nonatomic,assign) NSUInteger page;
@end

@implementation MyDonateViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的捐赠";
    
    [self setUpUI];
    
    [self requestUserInfo];
    [self requestUserListData];
}

- (void)setUpUI
{
    WEAKSELF;
    MyDonateHeaderView * headerView = [MyDonateHeaderView headerView];
    [headerView setReturnBlock:^(MyDonateUserModel * model) {
        LoveDonateRecordViewController * record = [[LoveDonateRecordViewController alloc]init];
        record.usermodel = model;
        [weakSelf.navigationController pushViewController:record animated:YES];
    }];
    headerView.frame = CGRectMake(0, 0, self.view.width, 141);
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 141)];
    [backView addSubview:headerView];
    self.tableView.tableHeaderView = backView;
    
    self.headerView = headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyDonateTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyDonateTableViewCell"];
}

- (void)requestUserInfo
{
    NSDictionary * parm = @{@"userid":KUserId};
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KLoveDonateUserInfo parameter:parm success:^(NSDictionary * resultCode) {
        
        self.userModel = [MyDonateUserModel userWithDictionary:resultCode];
        self.headerView.model = self.userModel;
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal;
    }];
}

- (void)requestUserListData
{
    NSDictionary * parm = @{@"userid":KUserId,@"page":@(self.page)};
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KLoveDonateUserDonateList parameter:parm success:^(NSArray * resultCode) {
        
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            for (NSDictionary * dict in arr) {
                MyDonateUserlistModel * model = [MyDonateUserlistModel modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
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
    MyDonateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyDonateTableViewCell"];
    cell.model = self.dataArray[indexPath.row];
    WEAKSELF;
    [cell setJuankuanblock:^(MyDonateUserlistModel * model){
        
        LoveDonateDetailViewController * detail = [[LoveDonateDetailViewController alloc]init];
        detail.projectId = model.Id;
        [weakSelf.navigationController pushViewController:detail animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyDonateUserlistModel * model = self.dataArray[indexPath.row];
    LoveDonateDetailViewController * detail = [[LoveDonateDetailViewController alloc]init];
    detail.projectId = model.Id;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - loading refresh
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestUserListData];
}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestUserListData];

}

@end
