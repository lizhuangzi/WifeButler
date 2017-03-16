//
//  WithdrawDepositViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/16.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WithdrawDepositViewController.h"
#import "SelectCardViewController.h"
#import "Masonry.h"
#import "WifeButlerNetWorking.h"
#import "PersonalPort.h"
#import "WifeButlerDefine.h"

@interface WithdrawDepositViewController ()

@property (nonatomic,strong) CardPocklistModel * returnModel;

@end

@implementation WithdrawDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createFooterView];
}


- (void)createFooterView
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 55)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = WifeButlerCommonRedColor;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(20);
        make.right.mas_equalTo(backView.mas_right).offset(-20);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.height.mas_equalTo(44);
    }];
    
    self.tableView.tableFooterView = backView;
}

#pragma mark - tableview 代理 , 源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Id"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Id"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (self.returnModel) {
         cell.textLabel.text = self.returnModel.bankname;
    }else
        cell.textLabel.text = @"请选择提现的银行卡";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WEAKSELF
        SelectCardViewController * card = [[SelectCardViewController alloc]init];
        [card setReturnBlock:^(CardPocklistModel * model) {
            [weakSelf.tableView reloadData];
        }];
        [self.navigationController pushViewController:card animated:YES];
    }
}

#pragma mark - 事件处理
- (void)sureClick
{
    if (!self.returnModel) {[SVProgressHUD showInfoWithStatus:@"请选择银行卡"]; return;}
    
    NSDictionary * parm = @{@"ordernum":self.orderID,@"bankid":self.returnModel.Id};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:Kdeposit parameter:parm success:^(id resultCode) {
        
        D_CommonAlertShow(@"申请已提交银行，具体到账时间又银行来定",^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal;
    }];
}

@end
