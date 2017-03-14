//
//  LoveDonateViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateViewController.h"
#import "LoveDonateListHeaderView.h"
#import "LoveDonateListSectionView.h"
#import "LoveDonateListTableViewCell.h"
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"
#import "WifeButlerDefine.h"
#import "LoveDonateListModel.h"

#import "LoveDonateDetailViewController.h"

@interface LoveDonateViewController ()

@property (nonatomic,weak) LoveDonateListHeaderView * headerView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,assign) NSUInteger page;
@end

@implementation LoveDonateViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setUpUI];
    [self requestCountData];
    [self requestListData];
}

- (void)setUpUI
{
    self.title = @"爱心捐赠";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoveDonateListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LoveDonateListTableViewCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LoveDonateMe"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMyDonate)];
    
    LoveDonateListHeaderView * headerView = [LoveDonateListHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, self.view.width, 141);
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 141)];
    [backView addSubview:headerView];
    self.tableView.tableHeaderView = backView;
    
    self.headerView = headerView;

}

- (void)requestCountData
{
    //1.请求爱心数目
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KLoveDonateCount parameter:nil success:^(NSDictionary * resultCode) {
        
        NSString * sum = resultCode[@"sum"];
        self.headerView.loveCount = sum;
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
}

- (void)requestListData
{
    NSDictionary * parm = @{@"page":@(self.page)};
    
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KLoveDonateProjectList parameter:parm success:^(id resultCode) {
        
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            for (NSDictionary * dict in arr) {
                LoveDonateListModel * model = [LoveDonateListModel modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        });

    } failure:^(NSError *error) {
        D_FailLoadingDeal(0);
    }];
}

#pragma - mark tableViewDelegate DataSocurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDonateListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoveDonateListTableViewCell"];
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    LoveDonateListSectionView * view = [[NSBundle mainBundle]loadNibNamed:@"LoveDonateListSectionView" owner:nil options:nil].lastObject;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDonateListModel * model = self.dataArray[indexPath.row];
    return model.cellH;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LoveDonateListModel * model = self.dataArray[indexPath.row];
    LoveDonateDetailViewController * detail = [[LoveDonateDetailViewController alloc]init];
    detail.projectId = model.Id;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -  刷新 加载
- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestListData];
}

- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestListData];
}


- (void)clickMyDonate
{
    
}

@end
