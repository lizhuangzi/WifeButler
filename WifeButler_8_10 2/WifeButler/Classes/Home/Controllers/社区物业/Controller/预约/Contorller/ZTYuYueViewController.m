//
//  ZTYuYueViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTYuYueViewController.h"
#import "ZTXuanZeTimeViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZTjieSuanModel.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZTYouHuiJuanViewController.h"
#import "ZJLoginController.h"

@interface ZTYuYueViewController ()
{
    ZTjieSuanModel *_model;
}

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;

@property (weak, nonatomic) IBOutlet UIView *addressView;



// 优惠卷
@property (weak, nonatomic) IBOutlet UILabel *youHuiJuanLab;
// money
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
// 优惠价格
@property (weak, nonatomic) IBOutlet UILabel *youHuiMoneyLab;
// 总价格
@property (weak, nonatomic) IBOutlet UILabel *allMoneLab;

// 预约时间
@property (weak, nonatomic) IBOutlet UILabel *timeYuYueLab;
// 优惠金额
@property (nonatomic, assign) CGFloat youHuiJuanMoney;
// 优惠卷id
@property (nonatomic, copy) NSString * youHuiJuan_id;

/**
 *  预约时间
 */
@property (nonatomic, copy) NSString * yuYueTime;

@property (nonatomic, strong) NSMutableArray * dataSourceYouHuiJuan;

@end

@implementation ZTYuYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"马上预约";
    
    self.moneyLab.text = self.price;
    
    self.allMoneLab.text = self.price;
    
    [self netWorking];
    
    [self netWorkingYouHuiJuan];
}


- (IBAction)addressClick:(id)sender {
    
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    vc.isBack = YES;
    
    __weak typeof(self) weakSelf = self;
    [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
        
        weakSelf.nameLab.text = model.realname;
        weakSelf.shouHuoAddressLab.text = model.address;
        weakSelf.iphoneLab.text = model.phone;
        self.addressView.hidden = YES;
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)yuYueTime:(id)sender {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTTimeXuanZe" bundle:nil];
    ZTXuanZeTimeViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTXuanZeTimeViewController"];
    nav.goods_id = self.goods_id;
    
    __weak typeof(self) weakSelf = self;
    
    [nav setBackTimeBlack:^(NSString *time) {
        
        ZJLog(@"%@", time);
        weakSelf.timeYuYueLab.text = time;
        weakSelf.yuYueTime = time;
    }];
    
    [self.navigationController pushViewController:nav animated:YES];
}

#pragma mark - 提交订单
- (void)netWorkingTiJiao
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if ([self.shouHuoAddressLab.text length] == 0 || [self.nameLab.text length] == 0 || [self.iphoneLab.text length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写完整的收货地址"];
        return;
    }
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",self.nameLab.text, self.iphoneLab.text, self.shouHuoAddressLab.text];
    [dic setObject:str forKey:@"receipt"];
    [dic setObject:self.dianPu_id forKey:@"shop_id"];
    [dic setObject:@"1" forKey:@"pay_way"];
    
    // 优惠卷不为空
    if (self.youHuiJuan_id.length != 0)
    {
        [dic setObject:self.youHuiJuan_id forKey:@"voucher"];   // 优惠
    }
    
    [dic setObject:self.goods_id forKey:@"goods_ids"];
    [dic setObject:@"1" forKey:@"nums"];
    [dic setObject:@"0" forKey:@"ship_fee"];
    
    NSString *strPrice1 = [self.price substringFromIndex:1];
    
    CGFloat strPrice2 = [[self.price substringFromIndex:1] floatValue] - self.youHuiJuanMoney;
    
    [dic setObject:strPrice1 forKey:@"goods_money"];
    [dic setObject:@(strPrice2) forKey:@"order_money"];
    [dic setObject:self.yuYueTime forKey:@"serve_time"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDanTiJiao];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"订单提交成功"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
            ZTHuiZhuanDingDan1ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTHuiZhuanDingDan1ViewController"];
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

#pragma mark - 请求数据
- (void)netWorking
{
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先进行登录"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KMoRenDiZhi];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.addressView.hidden = YES;
            
            _model = [ZTjieSuanModel mj_objectWithKeyValues:responseObject[@"resultCode"][@"address"]];
            
            self.nameLab.text = _model.realname;
            self.shouHuoAddressLab.text = _model.address;
            self.iphoneLab.text = _model.phone;
            
            self.youHuiJuanLab.text = [NSString stringWithFormat:@"可使用%@张优惠券", responseObject[@"resultCode"][@"voucher"]];
        }
        else
        {
            
            if ([responseObject[@"code"] intValue] == 30000) {
                
                [SVProgressHUD dismiss];
                self.addressView.hidden = NO;
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
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}


- (IBAction)youHuiJuanClick:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJMineController" bundle:nil];
    ZTYouHuiJuanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTYouHuiJuanViewController"];
    vc.isFanHui = YES;
    vc.dataSourceYouHuiJuan = self.dataSourceYouHuiJuan;
    vc.shopMoney = [self.price substringFromIndex:1];
    vc.biaoShi = @"11";
    
    __weak typeof(self) weakSelf = self;
    
    [vc setMoneyBlack:^(ZTYouHuiJuanModel *model) {
    
        weakSelf.youHuiJuanLab.text = [NSString stringWithFormat:@"使用%@元优惠券", model.money];
        weakSelf.youHuiMoneyLab.text = [NSString stringWithFormat:@"-￥%@", model.money];
        
        weakSelf.youHuiJuanMoney = [model.money floatValue];
        weakSelf.youHuiJuan_id = model.id;
        
        NSString *str = [weakSelf.price substringFromIndex:1];
        
        if ([str floatValue] > [model.money floatValue]) {
            
            weakSelf.allMoneLab.text = [NSString stringWithFormat:@"%.2f", [str floatValue] - [model.money floatValue]];
        }
        else
        {
            weakSelf.allMoneLab.text = @"0";
        }
    
    }];
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)queDingClick:(id)sender {
    
    ZJLog(@"订单提交");
    
    if ([self.timeYuYueLab.text length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"选择预约时间哦!"];
        return;
    };
    
    [self netWorkingTiJiao];
}

#pragma mark - 优惠劵请求数据
- (void)netWorkingYouHuiJuan
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
            
            self.dataSourceYouHuiJuan = [ZTYouHuiJuanModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
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
                if ([[responseObject objectForKey:@"code"] intValue] == 30000) {
            
                    [SVProgressHUD dismiss];
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
