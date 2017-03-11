//
//  ZTPersonGouWuCheViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/23.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTPersonGouWuCheViewController.h"
#import "ZTGouWuCheTableViewCell.h"
#import "ZTGouWuCheModel.h"
#import "ZTJieSuanGouWuCheViewController.h"
#import "ZTJieSuang11Model.h"
#import "ZTBackImageView.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "WifeButlerDefine.h"

@interface ZTPersonGouWuCheViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
    
    int _pize;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *quanBuBtn;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UIButton *tiJiaoBtn;

@end

@implementation ZTPersonGouWuCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"购物车";
    
    _pize = 1;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = WifeButlerTableBackGaryColor;
    
    _dataSource = [NSMutableArray array];
    
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (void)setPriceModel
{
    CGFloat floatMoney = 0;
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTGouWuCheModel *model = _dataSource[i];
        
        if (model.isSelect == YES) {
            
            
            floatMoney = floatMoney + ([model.num intValue] * [model.money floatValue]);
        }
        
    }
    
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f", floatMoney];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTGouWuCheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTGouWuCheTableViewCell" forIndexPath:indexPath];
    
    ZTGouWuCheModel *model = _dataSource[indexPath.row];
    
    cell.titleLab.text = model.title;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.files] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", model.money];
    cell.numTF.text = model.num;
    
    if (model.isSelect == YES) {
        
        cell.xuanZhongBtn.selected = YES;
    }
    else
    {
        cell.xuanZhongBtn.selected = NO;
    }
    
    __weak typeof(cell) weakCell = cell;
    
    // 增加
    [cell setAddBlack:^{
        
        NSString *strNum = [NSString stringWithFormat:@"%d", ([cell.numTF.text intValue] + 1)];
        
        [self netWorkingXuanZhongShuLiangModel:model andNum:strNum];
        
    }];
    
    // 减少
    [cell setJianBlack:^{
        
        if ([weakCell.numTF.text intValue] <= 1) {
            
            return;
        }
        
        NSString *strNum = [NSString stringWithFormat:@"%d", ([cell.numTF.text intValue] - 1)];
        
        [self netWorkingXuanZhongShuLiangModel:model andNum:strNum];

    }];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTGouWuCheModel *model = _dataSource[indexPath.row];
    
    if (model.isSelect == YES) {
        
        model.isSelect = NO;
        
        // 0 取消
        [self netWorkingXuanZhongType:model.id andStatus:@"0"];
    }
    else
    {
        model.isSelect = YES;
        
        // 1 选中
        [self netWorkingXuanZhongType:model.id andStatus:@"1"];
    }
    
}

/**删除*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
     ZTGouWuCheModel *model = _dataSource[indexPath.row];
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"将要删除该商品" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [weakSelf netWorkingDelete:model];
        
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark -  判断是否全选
- (void)panDuanisQuanXuan
{
    for (int i = 0; i < _dataSource.count; i++) {
        
        ZTGouWuCheModel *model = _dataSource[i];
        
        // 中间有一个非选中  就不是全选了
        if (model.isSelect == NO) {
            
            self.quanBuBtn.selected = NO;
            
            return;
        }
        else
        {
            self.quanBuBtn.selected = YES;
        }
        
    }
}




#pragma mark - 设置提交按钮提交个数
- (void)setTiJiaoNum
{
    int a = 0;
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTGouWuCheModel *model1 = _dataSource[i];
        
        if (model1.isSelect == YES) {
            
            a ++;
        }
    }
    
    [self.tiJiaoBtn setTitle:[NSString stringWithFormat:@"提交(%d)", a] forState:UIControlStateNormal];
}


- (IBAction)quanXuanClick:(id)sender {
    
    self.quanBuBtn.selected = !self.quanBuBtn.selected;
    
    if (self.quanBuBtn.selected == YES) {
        
        for (int i = 0; i < _dataSource.count; i ++) {
            
            ZTGouWuCheModel *model = _dataSource[i];
            
            model.isSelect = YES;
            
        }
        
        [self netWorkingXuanZhongQuanStatus:@"1"];

    }
    else
    {
        for (int i = 0; i < _dataSource.count; i ++) {
            
            ZTGouWuCheModel *model = _dataSource[i];
            
            model.isSelect = NO;
            
        }
        
        [self netWorkingXuanZhongQuanStatus:@"0"];

    }
    
}


- (IBAction)tiJiaoClick:(id)sender {
    
    int j = 0;
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTGouWuCheModel *model = _dataSource[i];
        
        if (model.isSelect == YES) {
            
            j = 1;
        }
    }
    
    if (j == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择商品"];
        return;
    }
    
    
    [self netWorkingTiJiao];
    
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(_pize) forKey:@"pageindex"];
    [dic setObject:@(100) forKey:@"pagesize"];
    
   
    [dic setObject: [WifeButlerAccount sharedAccount].userParty.token_app forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheList];
    
    [SVProgressHUD showWithStatus:@"加载中..."];

    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTGouWuCheModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            [self setTiJiaoNum];
            
            [self setPriceModel];
            
            // 判断是否全选
            [self panDuanisQuanXuan];
            
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
                    backImage.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight - 53);
                    backImage.backImageView.image = [UIImage imageNamed:@"ZTBackGouWuCar"];
                    backImage.titleLab.text = @"   购物车内暂无商品";
                    
                    [self.view addSubview:backImage];
                }
                else
                {
                    
                    [SVProgressHUD showErrorWithStatus:message];
                }

            }
            

        }
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

#pragma mark - 购物车列表选中状态
/**
 *  购物车选中状态
 *
 *  @param idStr  商品id
 *  @param status 状态
 */
- (void)netWorkingXuanZhongType:(NSString *)idStr andStatus:(NSString *)status
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:idStr forKey:@"id"];
    [dic setObject:status forKey:@"status"];
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheXuanZhong];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self setTiJiaoNum];
            
            [self setPriceModel];
            
            // 判断是否全选
            [self panDuanisQuanXuan];
            
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}


#pragma mark - 购物车列表全选
/**
 *  购物车选中状态
 *
 *  @param status 状态
 */
- (void)netWorkingXuanZhongQuanStatus:(NSString *)status
{
    // 如果没有数据,防止崩溃
    if (_dataSource.count == 0) {
        
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *strId = @"";
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTGouWuCheModel *model = _dataSource[i];
        
        strId = [strId stringByAppendingFormat:@",%@", model.id];
        
    }
    
    strId = [strId substringFromIndex:1];
    
    [dic setObject:strId forKey:@"id"];
    [dic setObject:status forKey:@"status"];
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheXuanZhong];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self.tableView reloadData];
            
            [self setTiJiaoNum];
            
            [self setPriceModel];
            
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}

#pragma mark - 删除
- (void)netWorkingDelete:(ZTGouWuCheModel *)model
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:model.id forKey:@"id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheListShanChu];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [_dataSource removeObject:model];
            
            [self setTiJiaoNum];
            
            [self setPriceModel];
            
            // 没有商品 出现背景图片
            if (_dataSource.count == 0) {
                
                ZTBackImageView *backImage = [[[NSBundle mainBundle] loadNibNamed:@"ZTBackImageView" owner:self options:nil] firstObject];
                backImage.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight - 53);
                backImage.backImageView.image = [UIImage imageNamed:@"ZTBackGouWuCar"];
                backImage.titleLab.text = @"   购物车内暂无商品";
                
                [self.view addSubview:backImage];
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
        
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark - 提交
- (void)netWorkingTiJiao
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *arrId = [NSMutableArray array];
    NSMutableArray *arrNums = [NSMutableArray array];
    
    
    for (int i = 0; i < _dataSource.count; i ++) {
     
        ZTGouWuCheModel *model = _dataSource[i];
        
        if (model.isSelect == YES) {
            
            [arrId addObject:model.id];
            [arrNums addObject:model.num];
        }
    }
    
    NSString *idStr = [arrId componentsJoinedByString:@","];
    NSString *numStr = [arrNums componentsJoinedByString:@","];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:idStr forKey:@"ids"];
    [dic setObject:numStr forKey:@"nums"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheListTiJiao];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTJieSuanGouWuChe" bundle:nil];
            ZTJieSuanGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTJieSuanGouWuCheViewController"];
            vc.dataSource = [ZTJieSuang11Model  mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            vc.allMoneyYemp = self.priceLab.text;
            [self.navigationController pushViewController:vc animated:YES];
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}

#pragma mark - 购物车数量增减
- (void)netWorkingXuanZhongShuLiangModel:(ZTGouWuCheModel *)model andNum:(NSString *)num
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:model.id forKey:@"id"];
    [dic setObject:num forKey:@"num"];
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGouWuCheXuanZhongShuLiang];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            
            model.num = num;
            
            [self setPriceModel];
            
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
