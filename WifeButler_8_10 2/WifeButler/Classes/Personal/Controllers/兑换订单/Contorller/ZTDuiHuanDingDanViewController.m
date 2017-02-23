//
//  ZTDuiHuanDingDanViewController.m
//  WifeButler
//
//  Created by ZT on 16/8/5.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDuiHuanDingDanViewController.h"
#import "ZTDuiHuanOrder1TableViewCell.h"
#import "ZTDuiHuanOrder2TableViewCell.h"
#import "ZTDingDanXiangQinDuiHuanViewController.h"
#import "ZTBackImageView.h"
#import "ZTDuiHuanOederModel.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"

typedef enum {
    
    orderTypeQuanBu,      // 全部
    orderTypeDaiShouHuo,  // 代收货
    orderTypeYiWanChen    // 已完成
    
}orderType;


@interface ZTDuiHuanDingDanViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    int _prize;
}

@property (weak, nonatomic) IBOutlet UIButton *quanBuBtn;
@property (weak, nonatomic) IBOutlet UIButton *daiShouHuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *wanchenBtn;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (nonatomic, assign) orderType  orderType;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) ZTBackImageView * backImageView;

@end

@implementation ZTDuiHuanDingDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"兑换订单";
    
    [self setPram];
    
    [self netWorkingYype];
    
    [self shuaXinJiaZa];
}

#pragma mark - 创建返回按钮
- (void)leftBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 20);
    [leftBtn setImage:[UIImage imageNamed:@"jiantou_03"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *letbtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = letbtn;
    
}

- (void)backLast
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _prize = 1;
        [self netWorkingYype];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _prize ++;
        [self netWorkingYypeJiaZa];
    }];
}


- (void)setPram
{
    _prize = 1;
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self leftBtn];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZTDuiHuanOederModel *model = self.dataSource[indexPath.row];
    
    if ([model.status intValue] == 3 || [model.status intValue] == 4) {
        
        ZTDuiHuanOrder1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTDuiHuanOrder1TableViewCell" forIndexPath:indexPath];
        
        
        [cell setDataSourceModel:model];
        // 确认收货
        [cell setQueRenBlock:^{
            
            ZJLog(@"确认收货");
            [self netWorkingQueRen:[model.id intValue]];
        }];
        
        
        return cell;
        
    }
    else
    {
        ZTDuiHuanOrder2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTDuiHuanOrder2TableViewCell" forIndexPath:indexPath];
        
        [cell setDataSourceModel:model];
        
        // 删除
        [cell setDeleteBlock:^{
            
            ZJLog(@"删除");
            [self netWorkingDelete:[model.id intValue]];
        }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZTDuiHuanOederModel *model = self.dataSource[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTDuiHuanDingDan" bundle:nil];
    ZTDingDanXiangQinDuiHuanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDingDanXiangQinDuiHuanViewController"];
    vc.order_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 全部
- (IBAction)quanBuClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = MAINCOLOR;
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    _orderType = orderTypeQuanBu;
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 待收货
- (IBAction)daiShouHuoClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = MAINCOLOR;
    
    _orderType = orderTypeDaiShouHuo;
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 完成
- (IBAction)tuiHuoClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = MAINCOLOR;
    
    
    _orderType = orderTypeYiWanChen;
    
    [_dataSource removeAllObjects];

    
    [self.tableView reloadData];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 数据请求
- (void)netWorkingYype
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(_prize) forKey:@"pageindex"];
    
    if (self.orderType == orderTypeQuanBu) {
        
        [dic setObject:@(0) forKey:@"status"];
    }

    if (self.orderType == orderTypeDaiShouHuo) {
        
        [dic setObject:@(4) forKey:@"status"];
    }

    if (self.orderType == orderTypeYiWanChen) {
        
        [dic setObject:@(6) forKey:@"status"];
    }
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanOrderList];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        [self.backImageView removeFromSuperview];
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            self.dataSource = [ZTDuiHuanOederModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer.hidden = YES;
                
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
                
            }
            
            [self.tableView reloadData];
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [vc setShuaiXinShuJu:^{
                        
                        [self netWorkingYype];
                        
                    }];
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
               
                if ([[responseObject objectForKey:@"code"] intValue] == 30000) {
                    
                    [SVProgressHUD dismiss];
                    
                    [self.view addSubview:self.backImageView];
                }
                else
                {
                
                    [SVProgressHUD showErrorWithStatus:message];
                }
            }
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)netWorkingYypeJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(_prize) forKey:@"pageindex"];
    
    if (self.orderType == orderTypeQuanBu) {
        
        [dic setObject:@(0) forKey:@"status"];
    }
    
    if (self.orderType == orderTypeDaiShouHuo) {
        
        [dic setObject:@(4) forKey:@"status"];
    }
    
    if (self.orderType == orderTypeYiWanChen) {
        
        [dic setObject:@(6) forKey:@"status"];
    }
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanOrderList];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [self.dataSource addObjectsFromArray:[ZTDuiHuanOederModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer.hidden = YES;
                
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
            }
            
            [self.tableView reloadData];
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [vc setShuaiXinShuJu:^{
                        
                        [self netWorkingYype];
                        
                    }];
                    
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
                
            }
            
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark - 删除
- (void)netWorkingDelete:(int)order_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(order_id) forKey:@"order_id"];
    [dic setObject:@"1" forKey:@"exchange"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanOrderListDelete];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self netWorkingYype];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 确认收货
- (void)netWorkingQueRen:(int)order_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(order_id) forKey:@"order_id"];
    [dic setObject:@"1" forKey:@"exchange"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanOrderListQueRenShouHuo];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self netWorkingYype];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}



- (ZTBackImageView *)backImageView
{
    if (_backImageView == nil) {
        
        _backImageView = [[[NSBundle mainBundle] loadNibNamed:@"ZTBackImageView" owner:self options:nil] firstObject];
        _backImageView.frame = CGRectMake(0, 104, iphoneWidth, iphoneHeight - 104);
        _backImageView.backImageView.image = [UIImage imageNamed:@"ZTBackDingDan"];
        _backImageView.titleLab.text = @"您暂时没有任何订单";
    }
    
    return _backImageView;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
