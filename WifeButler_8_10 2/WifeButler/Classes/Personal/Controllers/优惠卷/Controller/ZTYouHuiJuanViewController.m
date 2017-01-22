//
//  ZTYouHuiJuanViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTYouHuiJuanViewController.h"
#import "ZTYouHuiJuanTableViewCell.h"
#import "ZTYouHuiJuanModel.h"
#import "ZTBackImageView.h"
#import "ZJLoginController.h"

@interface ZTYouHuiJuanViewController ()
{
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZTYouHuiJuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的优惠卷";
    
    _dataSource = [NSMutableArray array];
    
    // 数据源从上一个界面中传入的值
    if (self.isFanHui == YES) {
        
        _dataSource = self.dataSourceYouHuiJuan;
        
        // 如果数据为空  显示背景图片
        if (_dataSource.count == 0) {
            
            ZTBackImageView *backImage = [[[NSBundle mainBundle] loadNibNamed:@"ZTBackImageView" owner:self options:nil] firstObject];
            backImage.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight);
            backImage.backImageView.image = [UIImage imageNamed:@"ZTBackYouHuiJuan"];
            backImage.titleLab.text = @"暂无优惠卷";
            
            [self.view addSubview:backImage];
        }
        
        
        [self.tableView reloadData];
    }
    else
    {
        
        [self netWorking];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTYouHuiJuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTYouHuiJuanTableViewCell" forIndexPath:indexPath];
    
    ZTYouHuiJuanModel *model = _dataSource[indexPath.row];
    
    cell.youHuiJuanLab.text = [NSString stringWithFormat:@"%@元代金卷", model.money];
    
    if ([model.day isEqualToString:@"已过期"]) {
        
        cell.timeGuoQILab.text = @"优惠券已过期";
        cell.backImageVIew.image = [UIImage imageNamed:@"ZTDaiJinJuanBack"];
    }
    else
    {
        cell.backImageVIew.image = [UIImage imageNamed:@"ZTDaiJinJuan"];
        cell.timeGuoQILab.text = [NSString stringWithFormat:@"%@", model.day];
    }
    
    if (model.biaoShiWei != 0) {
        
        cell.backImageVIew.image = [UIImage imageNamed:@"ZTDaiJinJuanBack"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.isFrist=3;
    ZTYouHuiJuanModel *model = _dataSource[indexPath.row];

    //model.biaoShiWei=self.row;
    
    // 是否过期
    if ([model.day isEqualToString:@"已过期"]) {
        
        return;
    }
    
    if (self.isFanHui == YES) {
                
        if ([model.money floatValue] > [self.shopMoney floatValue]) {
            
            [SVProgressHUD showErrorWithStatus:@"您的优惠卷金额大于订单金额"];
            return;
        }
    }
    
    // 如果已近选择的优惠卷
    if (model.biaoShiWei != 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"优惠卷已被选择"];
        return;
    }

    for (int i = 0 ; i < _dataSource.count; i ++) {
        
        ZTYouHuiJuanModel *model1 = _dataSource[i];
        
        if (model1.biaoShiWei == self.biaoShi.integerValue) {
            
            model1.biaoShiWei = 0;
        }
    }
    
    model.biaoShiWei = self.biaoShi.integerValue;
    
    
    if (self.isFanHui == YES) {
        
        if (self.moneyBlack) {
            
            self.moneyBlack(model);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 取消所有选择
- (void)quXiaoXuanZe
{
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTYouHuiJuanModel *model = _dataSource[i];
        model.isXuanZe = NO;
    }
}

#pragma mark - 优惠劵请求数据
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWoDeDaiJinJuan];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTYouHuiJuanModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
        
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
                    backImage.frame = CGRectMake(0, 0, iphoneWidth, iphoneHeight);
                    backImage.backImageView.image = [UIImage imageNamed:@"ZTBackYouHuiJuan"];
                    backImage.titleLab.text = @"暂无优惠卷";
                    
                    [self.view addSubview:backImage];
                }
                else
                {
                
                    [SVProgressHUD showErrorWithStatus:message];
                }
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
