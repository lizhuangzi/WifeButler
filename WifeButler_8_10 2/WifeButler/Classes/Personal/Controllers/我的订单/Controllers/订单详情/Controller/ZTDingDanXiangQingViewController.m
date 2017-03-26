//
//  ZTDingDanXiangQingViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/29.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDingDanXiangQingViewController.h"
#import "ZTDingDanXiangQinTableViewCell.h"
#import "ZTShangPingModel.h"
#import "ZTGouWuCheFooterVIew.h"
#import "ZTZhiFuFangShiTableViewController.h"
#import "ZJGoodsDetailVC.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "WifeButlerAccount.h"

typedef enum {
    
    orderTypeDaiFuKuan = 1,     // 待付款
    orderTypeYiQuXiao,      // 已取消
    orderTypeDaiFaHuo,      // 代发货
    orderTypeDaiShouHuo,    // 待收货
    orderTypeDaiPingJia,    // 待评价
    orderTypeYiPingJia      // 已评价
    
}orderType;


@interface ZTDingDanXiangQingViewController ()
{
    NSMutableArray *_dataSource;
}

@property (nonatomic, assign) orderType  zhuanTai1;

@property (nonatomic, assign) orderType  zhuanTai2;


@property (weak, nonatomic) IBOutlet UILabel *monyLab;
@property (weak, nonatomic) IBOutlet UILabel *daiJinJuanLab;
@property (weak, nonatomic) IBOutlet UILabel *yunFeiLab;
@property (weak, nonatomic) IBOutlet UILabel *zongJinELab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *zhifutypeLab;
@property (weak, nonatomic) IBOutlet UILabel *zhifuZhuangTaiLab;
@property (weak, nonatomic) IBOutlet UILabel *peiSongShiJianLab;

/**
 *  取消订单
 */
@property (weak, nonatomic) IBOutlet UIButton *quXiaoDingDanBtn;
/**
 *  付款
 */
@property (weak, nonatomic) IBOutlet UIButton *fuKuanBtn;


@property (weak, nonatomic) IBOutlet UIView *zhuangTaiView;



@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ZTDingDanXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    self.zhuangTaiView.backgroundColor = WifeButlerTableBackGaryColor;
    self.tableView.backgroundColor = WifeButlerTableBackGaryColor;
    self.zhuangTaiView.hidden = YES;
    
    [self setPram];
    
//    [self setDingDanZhuanTai:self.statai_temp];
    
    [self netWorkingYype];
}

- (void)setPram
{
    self.quXiaoDingDanBtn.layer.borderWidth =  0.5;
    self.quXiaoDingDanBtn.layer.borderColor = [[UIColor colorWithWhite:0.431 alpha:1.000] CGColor];
    self.quXiaoDingDanBtn.layer.cornerRadius = 3;
    
    self.fuKuanBtn.layer.borderWidth =  1;
    self.fuKuanBtn.backgroundColor = [UIColor whiteColor];
    self.fuKuanBtn.layer.borderColor = WifeButlerCommonRedColor.CGColor;
    self.fuKuanBtn.layer.cornerRadius = 3;
    
    self.zhuanTai1 = 0;
    self.zhuanTai2 = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTDingDanXiangQinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTDingDanXiangQinTableViewCell" forIndexPath:indexPath];
    
    ZTShangPingModel *model = _dataSource[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.files] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cell.titleLab.text = model.title;
    cell.numLab.text = [NSString stringWithFormat:@"X%@", model.num];
    cell.moneyLab.text = [NSString stringWithFormat:@"￥%@", model.price];
    
    return cell;
}


#pragma mark - 数据请求
- (void)netWorkingYype
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString * token = [WifeButlerAccount sharedAccount].userParty.token_app;
    [dic setObject:token forKey:@"token"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDanXiangQing];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
    
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _dataSource = [ZTShangPingModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"][@"goods"]];
            
            self.monyLab.text = [NSString stringWithFormat:@"￥%@", responseObject[@"resultCode"][@"goods_money"]];
            
            self.daiJinJuanLab.text = responseObject[@"resultCode"][@"voucher"];
            self.yunFeiLab.text = responseObject[@"resultCode"][@"ship_fee"];
            self.zongJinELab.text = [NSString stringWithFormat:@"￥%.2f", [responseObject[@"resultCode"][@"order_money"] floatValue] - [responseObject[@"resultCode"][@"ship_fee"] floatValue]];
            
            // 地址
            NSArray *address = [responseObject[@"resultCode"][@"receipt"] componentsSeparatedByString:@","];
            self.nameLab.text = address[0];
            self.iphoneLab.text = address[1];
            self.addressLab.text = address[2];
            
            self.timeLab.text = [self setTimeStr:responseObject[@"resultCode"][@"time"]];
            
            self.zhuangTaiView.hidden = NO;
            
            if ([responseObject[@"resultCode"][@"serve_time"] length] == 0) {
                
                self.peiSongShiJianLab.text = @"---";
            }
            else
            {
                self.peiSongShiJianLab.text = responseObject[@"resultCode"][@"serve_time"];
            }
        
        
            
            
            // 状态初始化
            self.zhuanTai1 = 0;
            self.zhuanTai2 = 0;
            
            if ([responseObject[@"resultCode"][@"pay_way"] intValue] == 1) {
                
                self.zhifutypeLab.text = @"在线支付";
                
                if ([responseObject[@"resultCode"][@"status"] intValue] == 1) {
                    
                    self.zhifuZhuangTaiLab.text = @"待付款";
                    
                    self.zhuanTai1 = orderTypeDaiFuKuan;
                    self.zhuanTai2 = orderTypeDaiFuKuan;
                    
                    [self.quXiaoDingDanBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [self.fuKuanBtn setTitle:@"付款" forState:UIControlStateNormal];
                    
                    [self.quXiaoDingDanBtn addTarget:self action:@selector(chongXinGouMia1:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.fuKuanBtn addTarget:self action:@selector(chongXinGouMia2:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 2) {
                    
                    self.zhifuZhuangTaiLab.text = @"已取消";
                    
                    self.zhuanTai1 = orderTypeYiQuXiao;
                    self.zhuanTai2 = orderTypeYiQuXiao;
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    [self.fuKuanBtn setTitle:@"已取消" forState:UIControlStateNormal];
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 3) {
                    
                    self.zhifuZhuangTaiLab.text = @"待发货";
                    
                    self.zhuanTai1 = orderTypeDaiFaHuo;
                    self.zhuanTai2 = orderTypeDaiFaHuo;
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    [self.fuKuanBtn setTitle:@"待发货" forState:UIControlStateNormal];
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 4) {
                    
                    self.zhifuZhuangTaiLab.text = @"待收货";
                    
                    self.zhuanTai1 = orderTypeDaiShouHuo;
                    self.zhuanTai2 = orderTypeDaiShouHuo;
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    [self.fuKuanBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    
                    [self.quXiaoDingDanBtn addTarget:self action:@selector(chongXinGouMia1:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.fuKuanBtn addTarget:self action:@selector(chongXinGouMia2:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 5) {
                    
                    self.zhifuZhuangTaiLab.text = @"待评价";
                    
                    self.zhuanTai1 = orderTypeDaiPingJia;
                    self.zhuanTai2 = orderTypeDaiPingJia;
                    
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    self.fuKuanBtn.hidden = YES;
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 6) {
                    
                    self.zhifuZhuangTaiLab.text = @"已评价";
                    
                    self.zhuanTai1 = orderTypeYiPingJia;
                    self.zhuanTai2 = orderTypeYiPingJia;
                    
                    [self.quXiaoDingDanBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [self.fuKuanBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                    
                    
                    [self.quXiaoDingDanBtn addTarget:self action:@selector(chongXinGouMia1:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.fuKuanBtn addTarget:self action:@selector(chongXinGouMia2:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            else
            {
                self.zhifutypeLab.text = @"货到付款";
                
                if ([responseObject[@"resultCode"][@"status"] intValue] == 2) {
                    
                    self.zhifuZhuangTaiLab.text = @"已取消";
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    [self.fuKuanBtn setTitle:@"已取消" forState:UIControlStateNormal];
                    
                }
               
                if ([responseObject[@"resultCode"][@"status"] intValue] == 1 || [responseObject[@"resultCode"][@"status"] intValue] == 3 || [responseObject[@"resultCode"][@"status"] intValue] == 4) {
                    
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    [self.fuKuanBtn setTitle:@"收货付款" forState:UIControlStateNormal];
                    
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 5) {
                    
                    
                    self.quXiaoDingDanBtn.hidden = YES;
                    self.quXiaoDingDanBtn.hidden = YES;
                    
                }
                if ([responseObject[@"resultCode"][@"status"] intValue] == 6) {
                    
                    self.zhifuZhuangTaiLab.text = @"已评价";
                    
                    self.zhuanTai1 = orderTypeYiPingJia;
                    self.zhuanTai2 = orderTypeYiPingJia;
                    
                    [self.quXiaoDingDanBtn setTitle:@"删除订单" forState:UIControlStateNormal];
                    [self.fuKuanBtn setTitle:@"再次购买" forState:UIControlStateNormal];
                    
                    
                    [self.quXiaoDingDanBtn addTarget:self action:@selector(chongXinGouMia1:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.fuKuanBtn addTarget:self action:@selector(chongXinGouMia2:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
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
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}

- (NSString *)setTimeStr:(NSString *)time
{
    if (time.length == 0) {
        
        return @"--";
    }
    
    // 时间戳
    NSDate * createdDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:createdDate];
}

- (IBAction)callIphoneClick:(id)sender {
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"将要拨打电话" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSString *str = [NSString stringWithFormat:@"tel://%@", @"010-51921371"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}


#pragma mark - 取消订单
- (void)quXiaoDingDanClick
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KQuXiaoDingDan];
    
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
            
            if (self.ShuaiXinBlack) {
                
                self.ShuaiXinBlack();
            }
            
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

#pragma mark - 付款
- (void)fuKuanClick
{
    ZJLog(@"付款");
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTZhiFuFangShiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTZhiFuFangShiTableViewController"];
    vc.order_id = self.order_id;
    __weak typeof(self) weakSelf = self;
    [vc setShuaiXinBlack:^{
       
        [weakSelf netWorkingYype];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 确认收货
- (void)queRenShouHuo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KQueRenShouHuo];
    
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
            
            if (self.ShuaiXinBlack) {
                
                self.ShuaiXinBlack();
            }
            
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

#pragma mark - 删除订单
- (void)shanChuDingDan
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDanShanChu];
    
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
            
            if (self.ShuaiXinBlack) {
                
                self.ShuaiXinBlack();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
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

#pragma mark - 再次购买
- (void)zaiCiGouMai
{
//    goods_id
    
    ZTShangPingModel *model = _dataSource[0];

    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJGoodsDetailVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
    nav.goodId = model.goods_id;
    [self.navigationController pushViewController:nav animated:YES];
}

#pragma mark - 重新1
- (void)chongXinGouMia1:(UIButton *)btn
{
    
    if (self.zhuanTai1 == 1) {
        
        [self quXiaoDingDanClick];
    }
    
    if (self.zhuanTai1 == 2) {
        
        
    }
    
    if (self.zhuanTai1 == 3) {
        
        
    }
    
    if (self.zhuanTai1 == 4) {
        
        
    }
    
    if (self.zhuanTai1 == 5) {
        
        
    }
    
    if (self.zhuanTai1 == 6) {
        
        [self shanChuDingDan];
    }
    
}


#pragma mark - 重新2
- (void)chongXinGouMia2:(UIButton *)btn
{
    
    if (self.zhuanTai2 == 1) {
        
        [self fuKuanClick];
    }
    
    if (self.zhuanTai2 == 2) {
        
        
    }
    
    if (self.zhuanTai2 == 3) {
        
        
    }
    
    if (self.zhuanTai2 == 4) {
        
        [self queRenShouHuo];
    }
    
    if (self.zhuanTai2 == 5) {
        
        
    }
    
    if (self.zhuanTai2 == 6) {
        
        [self zaiCiGouMai];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
