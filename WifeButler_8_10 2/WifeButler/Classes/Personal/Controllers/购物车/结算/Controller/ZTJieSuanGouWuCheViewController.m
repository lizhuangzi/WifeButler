//
//  ZTJieSuanGouWuCheViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJieSuanGouWuCheViewController.h"
#import "ZTJieSuan11TableViewCell.h"
#import "ZTJieSuang11Model.h"
#import "ZTJieShuan2Model.h"
#import "ZTYouHuiJuanViewController.h"
#import "ZTjieSuanModel.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"

@interface ZTJieSuanGouWuCheViewController ()
{
    NSString *_isZaiXianPay;      // 1在线支付   2货到付款
    
    ZTjieSuanModel *_modelAddress;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView1;

@property (weak, nonatomic) IBOutlet UIView *addressView;

/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;

@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn1;
@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn2;

@property (weak, nonatomic) IBOutlet UILabel *allMoney;

/**
 *  优惠卷数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSourceYouHuiJuan;

/**
 *  选择优惠卷数据
 */
@property (nonatomic, strong) NSMutableArray * dataYouHuiJuanArr;


@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger flag1;

@end

@implementation ZTJieSuanGouWuCheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"结算";
    
    _isZaiXianPay = @"1";
    
    self.flag = 0;
    
    self.dataYouHuiJuanArr = [NSMutableArray array];
    
    
    self.allMoney.text = self.allMoneyYemp;
    
    [self netWorking];
    
    // 优惠卷
    [self netWorkingYouHuiJuan];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTJieSuan11TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTJieSuan11TableViewCell" forIndexPath:indexPath];
 
    ZTJieSuang11Model *model = _dataSource[indexPath.row];
    
    cell.dianPuNameLab.text = model.shop_name;
    
    [cell setTableViewTempWithAry:[ZTJieShuan2Model mj_objectArrayWithKeyValuesArray:model.goods]];
    
    cell.shopNumLab.text = [NSString stringWithFormat:@"共%@件商品", model.num];
    cell.heJiMoneyLab.text = [NSString stringWithFormat:@"￥%.2f", [model.money floatValue]-[model.price_youHuiJuan floatValue]];
    
    if (model.price_youHuiJuan) {
        
        cell.youHuiJuanLab.text = [NSString stringWithFormat:@"优惠金额:%@", model.price_youHuiJuan];
    }
    else
    {
        cell.youHuiJuanLab.text = [NSString stringWithFormat:@"请选择代金卷"];
    }
    
    __weak typeof(self) weakSelf = self;

    [cell setYouHuijuanBlack:^(){
        
        weakSelf.flag = 0;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJMineController" bundle:nil];
        ZTYouHuiJuanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTYouHuiJuanViewController"];
        vc.isFanHui = YES;
        vc.dataSourceYouHuiJuan = self.dataSourceYouHuiJuan;
        vc.biaoShi = model.shop_id;
 
//        vc.shopMoney = [NSString stringWithFormat:@"%f", [model.money floatValue] - [model.price_youHuiJuan floatValue]]
        
        vc.shopMoney = model.money;
        
        [vc setMoneyBlack:^(ZTYouHuiJuanModel *modelBack) {
            
//                // weakSelf.flag = 1;
//                ZJLog(@"weakSelf.dataSourceYouHuiJuan:%@", weakSelf.dataSourceYouHuiJuan);
//                // 优惠卷金额
                model.price_youHuiJuan = modelBack.money;
                model.YouHuiJuan_id = modelBack.id;
            

//                weakCell.youHuiJuanLab.text = [NSString stringWithFormat:@"使用%@元优惠券", modelBack.money];
//                
//                if ([model.money floatValue] > [modelBack.money floatValue]) {
//                    
//                    weakCell.heJiMoneyLab.text = [NSString stringWithFormat:@"%.2f", [model.money floatValue] - [modelBack.money floatValue]];
//                }
//                else
//                {
//                    weakCell.heJiMoneyLab.text = @"0";
//                }
//            
//                model.money = weakCell.heJiMoneyLab.text;
//                
                CGFloat floatMoney = 0;
                
                for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                    
                    ZTJieSuang11Model *modePrice = _dataSource[i];
                    
                    floatMoney = floatMoney + [modePrice.price_youHuiJuan floatValue];
                    
                }
                
                ZJLog(@"floatMoney:%f", floatMoney);
                ZJLog(@"self.allMoneyYemp:%@", self.allMoneyYemp);
                
                NSString *strAllMoney = [self.allMoneyYemp substringFromIndex:1];
                
                if ([strAllMoney floatValue] > floatMoney) {
                    
                    weakSelf.allMoney.text = [NSString stringWithFormat:@"%.2f", [strAllMoney floatValue] - floatMoney];
                }
                else
                {
                    weakSelf.allMoney.text = @"0";
                }
            
                [tableView reloadData];
            
        }];
        
    
        
        [weakSelf.navigationController pushViewController:vc animated:YES];

        ZJLog(@"优惠卷");
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTJieSuang11Model *model = _dataSource[indexPath.row];
    
    // 基本高度  +  每个子cell高度
    return 170 + (model.goods.count * 86);
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

            _modelAddress = [ZTjieSuanModel mj_objectWithKeyValues:responseObject[@"resultCode"][@"address"]];
            
            self.nameLab.text = _modelAddress.realname;
            self.shouHuoAddressLab.text = _modelAddress.address;
            self.iphoneLab.text = _modelAddress.phone;

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
    if ([self.shouHuoAddressLab.text length] == 0 || [self.nameLab.text length] == 0 || [self.iphoneLab.text length] == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"请填写完整的收货地址"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *strAddress = [NSString stringWithFormat:@"%@,%@,%@", _modelAddress.realname, _modelAddress.phone, _modelAddress.address];
    
    [dic setObject:strAddress forKey:@"receipt"];
    
    NSString *strShop_id =  @"";            // Shop_id
    NSString *temp6YunFei = @"";            // 运费
    NSString *tempMoney =   @"";            // 商品金额
    NSString *tempMoneyOrder =   @"";       // 订单金额
    NSString *tempMoneyPrice =   @"";       // 优惠卷价格
    
    NSMutableArray *TempMArr1 = [NSMutableArray array];  // goods_ids
    NSMutableArray *TempMArr2 = [NSMutableArray array];  // 数量
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        ZTJieSuang11Model *model1 = _dataSource[i];
        
        tempMoneyPrice = [NSString stringWithFormat:@"%@,%@", tempMoneyPrice, model1.YouHuiJuan_id];
        
        strShop_id = [NSString stringWithFormat:@"%@,%@", strShop_id, model1.shop_id];
        temp6YunFei = [NSString stringWithFormat:@"%@,%@", temp6YunFei, @"0"];
        tempMoney = [NSString stringWithFormat:@"%@,%@", tempMoney, model1.money];
        
        CGFloat flo = [model1.money floatValue] - [model1.price_youHuiJuan floatValue];
        
        tempMoneyOrder = [NSString stringWithFormat:@"%@,%f", tempMoneyOrder, flo];
        
        NSString *goods_ids = @"";
        
        NSString *num = @"";
        
        for (int j = 0; j < model1.goods.count; j ++) {
            
            NSMutableArray *arr = [ZTJieShuan2Model mj_objectArrayWithKeyValuesArray:model1.goods];
    
            ZTJieShuan2Model *model2 = arr[j];

            if (j == 0) {
                
                goods_ids = model2.goods_id;
                num = model2.num;
            }
            else
            {
                goods_ids = [NSString stringWithFormat:@"%@_%@", goods_ids, model2.goods_id];
                num = [NSString stringWithFormat:@"%@_%@", num, model2.num];
            }
            
        }
        
        [TempMArr1 addObject:goods_ids];
        
        [TempMArr2 addObject:num];
    }
    
    
    // shop_id
    [dic setObject:[strShop_id substringFromIndex:1] forKey:@"shop_id"];
    [dic setObject:_isZaiXianPay forKey:@"pay_way"];
    [dic setObject:[tempMoneyPrice substringFromIndex:1] forKey:@"voucher"];   // 优惠
    
    [dic setObject:[TempMArr1 componentsJoinedByString:@","] forKey:@"goods_ids"];
    [dic setObject:[TempMArr2 componentsJoinedByString:@","] forKey:@"nums"];
    [dic setObject:[temp6YunFei substringFromIndex:1] forKey:@"ship_fee"];
    
    tempMoney = [tempMoney substringFromIndex:1];
    tempMoneyOrder = [tempMoneyOrder substringFromIndex:1];
    
    [dic setObject:tempMoney forKey:@"goods_money"];
    [dic setObject:tempMoneyOrder forKey:@"order_money"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDanTiJiao];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
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

- (NSString *)guShiZhuanHuan:(NSString *)temp andGeShi:(NSString *)geShi
{
    temp = [temp substringFromIndex:1];
    
    NSArray *arr = [temp componentsSeparatedByString:geShi];
    
    return [arr componentsJoinedByString:geShi];
}

- (IBAction)tiJiaoClick:(id)sender {
    
    [self netWorkingTiJiao];
}


- (IBAction)xuanZheAddress:(id)sender {
    
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    vc.isBack = YES;
    
    __weak typeof(self) weakSelf = self;
    
    [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
        
        weakSelf.nameLab.text = model.realname;
        weakSelf.shouHuoAddressLab.text = model.address;
        weakSelf.iphoneLab.text = model.phone;
        weakSelf.addressView.hidden = YES;
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
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
            if ([responseObject[@"code"] intValue] == 30000) {
            
                [SVProgressHUD dismiss];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
