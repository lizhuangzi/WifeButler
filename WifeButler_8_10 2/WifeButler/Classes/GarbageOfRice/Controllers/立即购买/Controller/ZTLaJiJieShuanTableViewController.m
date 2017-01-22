//
//  ZTLaJiJieShuanTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiJieShuanTableViewController.h"
#import "ZTYouHuiJuanViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZTjieSuanModel.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZJLoginController.h"

@interface ZTLaJiJieShuanTableViewController ()
{
    ZTjieSuanModel *_model;
    
    NSString *_isZaiXianPay;      // 1在线支付   2货到付款
}

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UIView *tiJiaoView;
@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn1;
@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn2;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;

/**
 *  商品数量
 */
@property (weak, nonatomic) IBOutlet UILabel *numShopLab;

/**
 *  优惠券数量
 */
@property (weak, nonatomic) IBOutlet UIButton *youHuiJuanLab;

/**
 *  总金额
 */
@property (weak, nonatomic) IBOutlet UIButton *zongMoneyBtn;

/**
 *  优惠
 */
@property (weak, nonatomic) IBOutlet UIButton *youHuiMongBtn;

/**
 *  运费
 */
@property (weak, nonatomic) IBOutlet UIButton *yunFeiBtn;

/**
 *  总计
 */
@property (weak, nonatomic) IBOutlet UILabel *heJiLab;


/**
 *  选择优惠卷的金额
 */
@property (nonatomic, assign) float  youHuiJuanMoney;


@property (nonatomic, strong) NSMutableArray * dataSourceYouHuiJuan;

@end

@implementation ZTLaJiJieShuanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"结算";
    
    [self setParam];
    
    self.numShopLab.text = [NSString stringWithFormat:@"共%@件", self.num];
    [self.zongMoneyBtn setTitle:[NSString stringWithFormat:@"%.2f", self.price] forState:UIControlStateNormal];
    
    [self.yunFeiBtn setTitle:self.yunFei forState:UIControlStateNormal];
    
    // 合计
    self.heJiLab.text = [NSString stringWithFormat:@"%.2f", self.price + [self.yunFei floatValue]];
    
    [self netWorking];
    
    [self netWorkingYouHuiJuan];
}

- (void)setParam
{
    _isZaiXianPay = @"1";
    
    self.tiJiaoView.layer.borderWidth = 1;
    self.tiJiaoView.layer.borderColor = [UIColor colorWithRed:0.737 green:0.729 blue:0.757 alpha:1.000].CGColor;
    
}


- (IBAction)zhiFuClick:(id)sender {
    
    [self.ZhiFuFangShiBtn1 setBackgroundImage:[UIImage imageNamed:@"ZTZhiFuFangShi"] forState:UIControlStateNormal];
    [self.ZhiFuFangShiBtn1 setTitleColor:[UIColor colorWithRed:0.039 green:0.675 blue:0.569 alpha:1.000] forState:UIControlStateNormal];
    
    
    [self.ZhiFuFangShiBtn2 setBackgroundImage:[UIImage imageNamed:@"ZTZhiFuFangShiBack"] forState:UIControlStateNormal];
    [self.ZhiFuFangShiBtn2 setTitleColor:[UIColor colorWithWhite:0.604 alpha:1.000] forState:UIControlStateNormal];
    
    // 在线支付
    _isZaiXianPay = @"1";
    
}

- (IBAction)zhiFuClick1:(id)sender {
    
    [self.ZhiFuFangShiBtn1 setBackgroundImage:[UIImage imageNamed:@"ZTZhiFuFangShiBack"] forState:UIControlStateNormal];
    [self.ZhiFuFangShiBtn1 setTitleColor:[UIColor colorWithRed:0.737 green:0.729 blue:0.757 alpha:1.000] forState:UIControlStateNormal];
    
    [self.ZhiFuFangShiBtn2 setBackgroundImage:[UIImage imageNamed:@"ZTZhiFuFangShi"] forState:UIControlStateNormal];
    [self.ZhiFuFangShiBtn2 setTitleColor:[UIColor colorWithRed:0.039 green:0.675 blue:0.569 alpha:1.000] forState:UIControlStateNormal];
    
    // 货到付款
    _isZaiXianPay = @"2";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
         // 进入地址选择
        if (indexPath.row == 0) {
            
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
        else
        {
            
        }
    }
    
    // 优惠卷
    if (indexPath.section == 1) {
        
        if (indexPath.row == 1) {
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJMineController" bundle:nil];
            ZTYouHuiJuanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTYouHuiJuanViewController"];
            vc.isFanHui = YES;
            vc.dataSourceYouHuiJuan = self.dataSourceYouHuiJuan;
            vc.shopMoney = [NSString stringWithFormat:@"%f", self.price];
            vc.biaoShi = @"1";
            
            __weak typeof(self) weakSelf = self;
            
            [vc setMoneyBlack:^(ZTYouHuiJuanModel *model) {
               
                
                [weakSelf.youHuiJuanLab setTitle:[NSString stringWithFormat:@"使用%@元优惠券", model.money] forState:UIControlStateNormal];

                [weakSelf.youHuiMongBtn setTitle:[NSString stringWithFormat:@"%@", model.money] forState:UIControlStateNormal];
                
                weakSelf.heJiLab.text = [NSString stringWithFormat:@"%.2f", (weakSelf.price + [weakSelf.yunFei floatValue]) - [model.money intValue]];
                
                
                self.youHuiJuanMoney = [model.money floatValue];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
}

#pragma mark - 请求数据
- (void)netWorking
{
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
            
            [self.youHuiJuanLab setTitle:[NSString stringWithFormat:@"可使用%@张优惠券", responseObject[@"resultCode"][@"voucher"]] forState:UIControlStateNormal];
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
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",self.nameLab.text, self.shouHuoAddressLab.text, self.iphoneLab.text];
    [dic setObject:str forKey:@"receipt"];
    [dic setObject:@"0" forKey:@"shop_id"];
    [dic setObject:_isZaiXianPay forKey:@"pay_way"];
    
    NSString *strMoneyYouHui = [NSString stringWithFormat:@"%f", self.youHuiJuanMoney];
    [dic setObject:strMoneyYouHui forKey:@"voucher"];   // 优惠
    [dic setObject:self.tempId forKey:@"goods_ids"];
    [dic setObject:self.num forKey:@"nums"];
    [dic setObject:self.yunFei forKey:@"ship_fee"];
    
    CGFloat strPrice2 = self.price - self.youHuiJuanMoney;

    [dic setObject:@(self.price) forKey:@"goods_money"];    //
    [dic setObject:@(strPrice2) forKey:@"order_money"];
    [dic setObject:self.colorShop forKey:@"color"];

    
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
            vc.hidesBottomBarWhenPushed = YES;
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

#pragma mark - 提交订单
- (IBAction)tiJiaoDingDanClick:(id)sender {
    
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

#pragma mark - Table view data source


@end
