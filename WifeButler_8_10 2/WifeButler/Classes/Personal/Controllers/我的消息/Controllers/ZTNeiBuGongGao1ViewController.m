//
//  ZTNeiBuGongGao1ViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/22.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTNeiBuGongGao1ViewController.h"
#import "ZTNeiBuGongGaoTableViewCell.h"
#import "ZTXiaoXiXiangQinViewController.h"
#import "ZTWoDeXiaoXiModel.h"
#import "ZTBackImageView.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"

@interface ZTNeiBuGongGao1ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataSource;
    
    int _pize;
}

@end

@implementation ZTNeiBuGongGao1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的消息";
    
    _pize = 1;
    
    _dataSource = [NSMutableArray array];
    
    [self createUI];
    
    [self shuaXinJiaZa];
    
    [self netWorking];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pize = 1;
        [self netWorking];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pize ++;
        [self netWorkingJiaZa];
    }];
    
}


#pragma mark
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSDictionary *dic = @{@"token":KToken};
    
    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, KWoDeXiaoXi];

    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _dataSource = [ZTWoDeXiaoXiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
        
            if (_dataSource.count < 9) {
                
                _tableView.mj_footer.hidden = YES;
            }
            
            
            [_tableView reloadData];
            
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
                        
                        [self netWorking];
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
                    
                    ZTBackImageView *backImage = [[[NSBundle mainBundle] loadNibNamed:@"ZTBackImageView" owner:self options:nil] firstObject];
                    backImage.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight);
                    backImage.backImageView.image = [UIImage imageNamed:@"ZTBackXiaoXi"];
                    backImage.titleLab.text = @"暂无消息";
                    
                    [self.view addSubview:backImage];
                }
                else
                {
                    
                    [SVProgressHUD showErrorWithStatus:message];
                }
                

            }
            

        }
        
        [_tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [_tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 
- (void)netWorkingJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSDictionary *dic = @{@"token" : KToken, @"pageindex" : @(_pize)};
    
    NSString *url = [NSString stringWithFormat:@"%@%@", HTTP_BaseURL, KWoDeXiaoXi];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [_dataSource addObjectsFromArray:[ZTWoDeXiaoXiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            if (_dataSource.count < 9) {
                
                _tableView.mj_footer = nil;
            }
            
            
            [_tableView reloadData];
            
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
                        
                        [self netWorkingJiaZa];
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
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];
    
}



- (void)createUI
{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 77;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTNeiBuGongGaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTNeiBuGongGaoTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZTNeiBuGongGaoTableViewCell" owner:self options:nil] firstObject];
    }
    
    ZTWoDeXiaoXiModel *model = _dataSource[indexPath.row];
    
    cell.titleLab.text = model.type;
    cell.desLab.text = model.contents;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTXiaoXiXiangQinViewController *vc = [[ZTXiaoXiXiangQinViewController alloc] init];
    ZTWoDeXiaoXiModel *model = _dataSource[indexPath.row];
    vc.titleZ = model.type;
    vc.desZ = model.contents;
    [self.navigationController pushViewController:vc animated:YES];
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
