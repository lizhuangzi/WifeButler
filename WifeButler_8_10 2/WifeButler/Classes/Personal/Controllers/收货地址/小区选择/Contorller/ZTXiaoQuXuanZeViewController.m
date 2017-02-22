//
//  ZTXiaoQuXuanZeViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTXiaoQuXuanZeViewController.h"
#import "ZTXiaoQuXuanZeTableViewCell.h"
#import "MJRefresh.h"

@interface ZTXiaoQuXuanZeViewController () <UISearchBarDelegate>
{
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISearchBar *XiaoQusearchBar;

@end

@implementation ZTXiaoQuXuanZeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择小区";
    
    _dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self shuaXinJiaZa];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
  
        [self downLoadInfoDiQu];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTXiaoQuXuanZeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTXiaoQuXuanZeTableViewCell" forIndexPath:indexPath];
    
    ZTXiaoQuXuanZe *model = _dataSource[indexPath.row];
    
    cell.titleLab.text = model.village;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTXiaoQuXuanZe *model = _dataSource[indexPath.row];
    
    if (self.addressBlack) {
        
        self.addressBlack(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 数据小区
- (void)downLoadInfoDiQu
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.address_id forKey:@"zoneid"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KXiaoQuList];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTXiaoQuXuanZe mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            [self.tableView reloadData];
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

//点击搜索跳转页面
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self downLoadInfoSearch:searchBar.text];
    
    ZJLog(@"xxxxxxxxx");
}

#pragma mark - 数据小区
- (void)downLoadInfoSearch:(NSString *)word
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.address_id forKey:@"zoneid"];
    [dic setObject:word forKey:@"word"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KXiaoQuList];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTXiaoQuXuanZe mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            [self.tableView reloadData];
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
