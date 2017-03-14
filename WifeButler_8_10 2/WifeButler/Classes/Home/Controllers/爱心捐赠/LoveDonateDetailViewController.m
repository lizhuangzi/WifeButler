//
//  LoveDonateDetailViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateDetailViewController.h"
#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "LoveDonateDetailViewCell.h"
#import "LoveDonateDetailHeaderView.h"
#import "LoveDonateDetailModel.h"

@interface LoveDonateDetailViewController ()

@property (nonatomic,strong) LoveDonateDetailModel * viewModel;

@property (nonatomic,weak) LoveDonateDetailHeaderView * headerView;
@end

@implementation LoveDonateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱心捐赠";

    LoveDonateDetailHeaderView * header = [[LoveDonateDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    self.tableView.tableHeaderView = header;
    self.headerView = header;
    
    NSString * urlStr = [NSString stringWithFormat:KLoveDonateProjectDetail,self.projectId];
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:urlStr parameter:nil success:^(NSDictionary * resultCode) {
        
        self.viewModel = [LoveDonateDetailModel modelWithDictionary:resultCode];
        self.headerView.model = self.viewModel;
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
    }];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LoveDonateDetailViewCell" bundle:nil] forCellReuseIdentifier:@"LoveDonateDetailViewCell"];
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView.tableFooterView = bottomBtn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDonateDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoveDonateDetailViewCell"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
