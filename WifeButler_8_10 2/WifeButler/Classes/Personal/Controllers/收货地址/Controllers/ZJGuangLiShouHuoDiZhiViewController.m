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
#import "ZJLoginController.h"
#import "ZTBackImageView.h"
#import "UIColor+HexColor.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "NetWorkPort.h"
#import "WifeButlerDefine.h"
#import "PersonalPort.h"
#import "WifeButlerNetWorking.h"

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

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLoginSuccess) name:LoginViewControllerDidLoginSuccessNotification object:nil];
}


- (void)createUI
{
    _dataSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight - 44 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.950 alpha:1.000];
    _tableView.rowHeight = 70;
    [self.view addSubview:_tableView];
    
    // 添加尾部视图
    [self addAddressClickOfTableViewFooterView];
    
    UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:bottomBtn];
    bottomBtn.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), iphoneWidth, 44);
    [bottomBtn setTitle:@"添加地址" forState:UIControlStateNormal];
    [bottomBtn setImage:[UIImage imageNamed:@"gwc_add"] forState:UIControlStateNormal];
    [bottomBtn setBackgroundColor:[UIColor whiteColor]];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bottomBtn setTitleColor:WifeButlerCommonRedColor forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(AddAddress) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAddressClickOfTableViewFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _tableView.tableFooterView = view;
}



#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self downLoadInfo];
    }];
}

- (void)userLoginSuccess
{
    [self downLoadInfo];
}

#pragma mark - 数据请求
- (void)downLoadInfo
{
    WifeButlerLetUserLoginCode    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(50) forKey:@"pagesize"];
        
    ZJLog(@"%@", dic);
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KMyDeliveryLocation parameter:dic success:^(NSArray * resultCode) {
        [SVProgressHUD dismiss];

        _dataSource = [ZTShouHuoAddressModel mj_objectArrayWithKeyValuesArray:resultCode];
        [_tableView reloadData];
         [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        SVDCommonErrorDeal;
        [_tableView.mj_header endRefreshing];
    }];

}

#pragma mark - 删除
- (void)downLoadInfoDelete:(NSString *)str_id
{
    
    D_CommonAlertShow(@"确定要删除该收货地址吗",^{
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:KToken forKey:@"token"];
        [dic setObject:str_id forKey:@"id"];
        
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        
        [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KDeleteShouHuoAddress parameter:dic success:^(id resultCode) {
            [SVProgressHUD dismiss];
            [self downLoadInfo];
            
        } failure:^(NSError *error) {
            SVDCommonErrorDeal;
        }];
    });
    
    
}



- (void)AddAddress
{
    ZJLog(@"新增地址");
    WifeButlerLetUserLoginCode
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
    ZTBianJiDiZhiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTBianJiDiZhiTableViewController"];
    
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
    
    ZTShouHuoAddressModel *model = _dataSource[indexPath.row];
    
    [cell setAssignmentData:_dataSource[indexPath.row]];
    
    // 编辑
    [cell setBianJiBlack:^{
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTBianJiShouHuoDiZhi" bundle:nil];
        ZTBianJiDiZhiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTBianJiDiZhiTableViewController"];
        vc.isAddAddress = NO;
        vc.address_id = model.id;
        __weak typeof(self) weakSelf = self;
        
        [vc setRelshBlack:^{
            
            [_tableView.mj_header beginRefreshing]; 
        }];
        
        [weakSelf.navigationController pushViewController:vc animated:YES];
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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTShouHuoAddressModel *model =_dataSource[indexPath.row];
    [self downLoadInfoDelete:model.id];
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:address_id forKey:@"id"];
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KSetDefaultAddress parameter:dic success:^(id resultCode) {
        
        [SVProgressHUD dismiss];
        
        // 刷新接口  经纬度变化
        [self downLoadInfo];
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
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
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(50) forKey:@"pagesize"];
    

    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KMyDeliveryLocation parameter:dic success:^(NSArray * resultCode) {
        
        _dataSource = [ZTShouHuoAddressModel mj_objectArrayWithKeyValuesArray:resultCode];
        
        [_tableView reloadData];
        
        // 清空购物车
        [self downLoadInfoClear];
        [_tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
        [_tableView.mj_header endRefreshing];
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
