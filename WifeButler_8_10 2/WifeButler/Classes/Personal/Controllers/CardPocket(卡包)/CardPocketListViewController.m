//
//  CardPocketListViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketListViewController.h"
#import "CardPocketTableViewCell.h"
#import "CardPocketAddViewController.h"
#import "WifeButlerNetWorking.h"
#import "PersonalPort.h"
#import "WifeButlerDefine.h"
#import "CardPocketAddNextStepController.h"
#import "WifeButlerNoDataView.h"
#import "Masonry.h"

@interface CardPocketListViewController ()


@property (nonatomic,assign) NSUInteger page;
@end

@implementation CardPocketListViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUI];
    [self listenNotify];
    [self requestHttpData];
}

- (void)setupUI
{
    self.title = @"我的卡包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Cardadd"] style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardPocketTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardPocketTableViewCell"];
    self.tableView.rowHeight = 105;
    self.tableView.footerRefreshEnable = NO;
    
}


- (void)listenNotify
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addSuccess) name:CardPocketAddNextStepControllerAddSuccessNotification object:nil];
}

- (void)requestHttpData
{
    [SVProgressHUD showWithStatus:@""];
    
    NSString * page = [NSString stringWithFormat:@"%zd",self.page];
    NSDictionary * parm = @{@"userid":KUserId,@"token":KToken,@"page":page};
    
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KBankCardList parameter:parm success:^(NSArray * resultCode) {
        
        [SVProgressHUD dismiss];
        if (resultCode.count == 0) {
            WifeButlerNoDataViewShow(self.view, 3, nil);
            return ;
        }
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            WifeButlerNoDataViewRemoveFrom(self.view);
            for (NSDictionary *dict in arr) {
                CardPocklistModel * model = [CardPocklistModel modelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
        });
        
    } failure:^(NSError *error) {
        D_FailLoadingDeal(0);
    }];
}

#pragma mark - 添加银行卡
- (void)addClick
{
    CardPocketAddViewController * vc = [[CardPocketAddViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新代理
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestHttpData];
}


#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardPocketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CardPocketTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)addSuccess
{
    [self requestHttpData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
