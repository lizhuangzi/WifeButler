//
//  ZJGuangLiShouHuoDiZhiViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/18.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZJGuangLiShouHuoDiZhiTableViewCell.h"
#import "ZTBianJiDiZhiTableViewController.h"
#import "ZTAddAddressTableViewController.h"
#import "ZJLoginController.h"
#import "ZTBackImageView.h"
#import "UIColor+HexColor.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "NetWorkPort.h"

@interface ZJGuangLiShouHuoDiZhiViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) ZTBackImageView * backImageViewA;

@end

@implementation ZJGuangLiShouHuoDiZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址管理";
    
    [self createUI];
    
    [self shuaXinJiaZa];
    
    [self downLoadInfo];

}


//- (void)settingNav
//{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemBack)];
//    
//    [self.navigationController.navigationBar setBarTintColor:WifeButlerCommonRedColor];
//    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//}

//- (void)leftBarItemBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    if (self.returnBackBlock) {
//        self.returnBackBlock();
//    }
//}

- (void)createUI
{
    
    _dataSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    _tableView.rowHeight = 114;
    [self.view addSubview:_tableView];
    
    // 添加尾部视图
    [self addAddressClickOfTableViewFooterView];
}

- (void)addAddressClickOfTableViewFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 150)];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 40, iphoneWidth - 60, 35)];
//    [btn setTitle:@"添加地址" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor colorWithRed:0.133 green:0.714 blue:0.620 alpha:1.000];
//    btn.layer.cornerRadius = 5;
//    [btn addTarget:self action:@selector(AddAddress) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
    
    _tableView.tableFooterView = view;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加地址" style:UIBarButtonItemStylePlain target:self action:@selector(AddAddress)];

}



#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self downLoadInfo];
    }];
}

#pragma mark - 数据请求
- (void)downLoadInfo
{
    if ([KToken length] == 0) {
        
        __weak typeof(self) weakSelf = self;
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录,请先进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
            ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
            vc.isLogo = YES;
            [vc setShuaiXinShuJu:^{
                
                [self downLoadInfo];
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        [vc addAction:action];
        [vc addAction:otherAction];
        
        [weakSelf presentViewController:vc animated:YES completion:nil];
        
        [_tableView.mj_header endRefreshing];
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(50) forKey:@"pagesize"];
    
    NSString *url = KMyDeliveryLocation;
    
    ZJLog(@"%@", dic);
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        [self.backImageViewA removeFromSuperview];
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
        
            _dataSource = [ZTShouHuoAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
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
                        
                        [self downLoadInfo];
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
                    backImage.backImageView.image = [UIImage imageNamed:@"ZTBackAddress"];
                    backImage.titleLab.text = @"没有送货地址";
                    self.backImageViewA = backImage;
                    [self.view addSubview:self.backImageViewA];
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

#pragma mark - 删除
- (void)downLoadInfoDelete:(NSString *)str_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:str_id forKey:@"id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDeleteShouHuoAddress];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            
            [self downLoadInfo];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [_tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
}



- (void)AddAddress
{
    ZJLog(@"新增地址");
    
    __weak typeof(self) weakSelf = self;
    
    // 如果没有登录
    if (KToken == nil) {
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录,请先进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
            ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
            vc.isLogo = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        [vc addAction:action];
        [vc addAction:otherAction];
        
        [weakSelf presentViewController:vc animated:YES completion:nil];
        
    }

    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
    ZTBianJiDiZhiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTBianJiShouHuoDiZhi"];
    
    [vc setRelshBlack:^{
       
        [_tableView.mj_header beginRefreshing];
    }];
    
    vc.isAddAddress = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGuangLiShouHuoDiZhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJGuangLiShouHuoDiZhiTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZJGuangLiShouHuoDiZhiTableViewCell" owner:self options:nil] firstObject];
    }
    
    __weak typeof(self) weakSelf = self;

    ZTShouHuoAddressModel *model = _dataSource[indexPath.row];
    
    [cell setAssignmentData:_dataSource[indexPath.row]];
    
    // 编辑
    [cell setBianJiBlack:^{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTAddAddress" bundle:nil];
        ZTAddAddressTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTAddAddressTableViewController"];
        vc.address_id = model.id;
        __weak typeof(self) weakSelf = self;
        
        [vc setRelshBlack:^{
            
            [_tableView.mj_header beginRefreshing]; 
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];

    // 删除
    [cell setDeleteBlack:^{
        
        [weakSelf downLoadInfoDelete:model.id];
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (self.isBack == YES) {
        
        ZTShouHuoAddressModel *model = _dataSource[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        
        if ([model.defaults intValue] != 2) {
            
            NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
            NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您选择的地址和定位地址不符合,如果您继续的话,购物车将会被清空." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                

            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
                // 设置默认地址
                [weakSelf downLoadInfoSetdefaults:model.id];
                
            }];
            
            [vc addAction:action];
            [vc addAction:otherAction];
            
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        if (self.addressBlack) {
            
            self.addressBlack(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
- (void)downLoadInfoClear
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KClearGouWuChe];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
    
}


#pragma mark - 设置默认地址
- (void)downLoadInfoSetdefaults:(NSString *)address_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:address_id forKey:@"id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSetDefaultAddress];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            // 刷新接口  经纬度变化
            [self downLoadInfo111];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
    
}


#pragma mark - 数据请求
- (void)downLoadInfo111
{
    if ([KToken length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"你还没有登录哦"];
        [_tableView.mj_header endRefreshing];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(50) forKey:@"pagesize"];
    
    NSString *url = KMyDeliveryLocation;
    
    ZJLog(@"%@", dic);
    
    __weak typeof(self) weakSelf = self;
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _dataSource = [ZTShouHuoAddressModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            [_tableView reloadData];
            
            
            // 清空购物车
            [weakSelf downLoadInfoClear];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [_tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        [_tableView.mj_header endRefreshing];
    }];
    
    
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
