//
//  ZTHuiZhuanDingDan1ViewController.m
//  YouHu
//
//  Created by zjtd on 16/4/30.
//  Copyright © 2016年 zjtdmac3. All rights reserved.
//

#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZTHuiZhuanPingJiaTableViewController.h"
#import "ZTDingDanXiangQingViewController.h"
#import "ZTZhiFuFangShiTableViewController.h"
#import "ZJGoodsDetailVC.h"
#import "ZTBackImageView.h"

#import "ZTGouWuCheFooterVIew.h"
#import "Order1TableViewCell.h"
#import "Order3TableViewCell.h"
#import "ZTWoDeDingDanModel.h"
#import "ZTShangPingModel.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"
#import "WifeButlerDefine.h"
#import "WifeButlerNoDataView.h"
#import "ZJShopClassVC.h"
#import "Masonry.h"

typedef enum {

    orderTypeQuanBu,      // 全部
    orderTypeDaiFuKuan,   // 代付款
    orderTypeDaiShouHuo,  // 代收货
    orderTypeDaiPingJia,  // 代评价
    orderTypeYiWanChen    // 已完成

}orderType;


@interface ZTHuiZhuanDingDan1ViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    // 筛选显示判断
    BOOL _isTanChuShaiXuan;
    
    int _prize;
}

@property (weak, nonatomic) IBOutlet UIButton *quanBuBtn;
@property (weak, nonatomic) IBOutlet UIButton *daiFuKuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *daiShouHuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *daiPingJiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *wanchenBtn;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *footView;


@property (nonatomic, assign) orderType  orderType;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dataSource1;
@end

@implementation ZTHuiZhuanDingDan1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"购物订单";
    self.footView.backgroundColor = WifeButlerTableBackGaryColor;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataSource1 = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _prize = 1;
    
    [self leftBtn];
    
    [self shuaXinJiaZa];

    [self netWorkingYype];
    
//    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 创建返回按钮
- (void)leftBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 20);
    [leftBtn setImage:[UIImage imageNamed:@"jiantou_03"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backLast) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *letbtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = letbtn;

}

- (void)backLast
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _prize = 1;
        [self netWorkingYype];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _prize ++;
        [self netWorkingYypeJiaZa];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ZJLog(@"111");

    return self.dataSource.count;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ZTWoDeDingDanModel *model = self.dataSource[section];

    self.dataSource1 = [ZTShangPingModel mj_objectArrayWithKeyValuesArray:model.goods];
    ZJLog(@"222");
    
    return self.dataSource1.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZJLog(@"333");
    ZTWoDeDingDanModel *model = self.dataSource[indexPath.section];
    
    // 这样错误
//    ZTShangPingModel *model_shop1 = self.dataSource1[indexPath.row];
    
    ZTShangPingModel *model_shop = [ZTShangPingModel mj_objectWithKeyValues:model.goods[indexPath.row]];
    
    if ([model.status intValue] == 5) {
    
        Order3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order3TableViewCell" forIndexPath:indexPath];
        [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:model_shop.files] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cell.titleLabel.text = model_shop.title;
        cell.numberLabel.text = [NSString stringWithFormat:@"X%@", model_shop.num];
        
        //  评价
        [cell setPingJiaBlack:^{
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanPingJia" bundle:nil];
            ZTHuiZhuanPingJiaTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTHuiZhuanPingJiaTableViewController"];
            vc.shop_id = model.shop_id;
            
            vc.order_id = model_shop.order_id;
            vc.goods_id = model_shop.goods_id;
            
            vc.titleTemp = model_shop.title;
            vc.icon = model_shop.files;
            
            [vc setShuaiXinBlack:^{
                
                [self netWorkingYype];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        return cell;
    }
    else
    {
        Order1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Order1TableViewCell" forIndexPath:indexPath];
        [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:model_shop.files] placeholderImage:PlaceHolderImage_Other];
        cell.priceLabel.text = [NSString stringWithFormat: @"¥%@",model_shop.price];
        cell.titleLab.text = model_shop.title;
        cell.numLab.text = [NSString stringWithFormat:@"X%@", model_shop.num];
        
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTWoDeDingDanModel *model = _dataSource[indexPath.section];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTDingDanXiangQingViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDingDanXiangQingViewController"];
    vc.order_id = model.id;
//    vc.statai_temp = model.status;
    vc.pay_way = model.pay_way;
    
    
    [vc setShuaiXinBlack:^{
       
        [self netWorkingYype];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        ZTWoDeDingDanModel *model = self.dataSource[section];
        
        return [self headViewShopName:model.shop_name];
        
    }else{
        
        ZTWoDeDingDanModel *model = self.dataSource[section];
        
        return [self headViewShopName:model.shop_name];
    }
    
    
}

- (UIView *)headViewShopName:(NSString *)name
{
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9.5, 25, 20)];
    imgV.image = [UIImage imageNamed:@"superMarket"];
    [headView addSubview:imgV];
    
    UILabel * nameLBL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame) + 5, 0, 200, 40)];
    nameLBL.textColor = WifeButlerGaryTextColor1;
    nameLBL.font = [UIFont systemFontOfSize:15];
    nameLBL.text = name;
    [headView addSubview:nameLBL];
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    ZTWoDeDingDanModel *model = _dataSource[section];
    
//    订单状态 pay_way=1的时候（在线支付）
//    1待付款  2已取消 3 待发货 4 待收货 5 待评价 6 已评价
//   （如果pay_way是2， 1和3都是待发货，4是待收货付款）
    
    __weak typeof(self) weakSelf = self;
    
    if ([model.pay_way intValue] == 1) {
        
        //  1待付款
        if ([model.status intValue] == 1) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
            
            footView.deleteBtn.layer.borderWidth = 1;
            footView.deleteBtn.layer.cornerRadius = 5;
            footView.deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
            
            [footView.goShopBtn setTitle:@"付款" forState:UIControlStateNormal];
            [footView.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            
            // 付款
            [footView setGoShopBlack:^{
                
                ZJLog(@"付款");
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
                ZTZhiFuFangShiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTZhiFuFangShiTableViewController"];
                vc.order_id = model.id;
                
                __weak typeof(self) weakSelf = self;
                
                // 刷新
                [vc setShuaiXinBlack:^{
                    
                    [weakSelf netWorkingYype];
                }];
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            // 取消订单
            [footView setDeleteBlack:^{
                
                ZJLog(@"取消订单");
                [weakSelf netWorkingQuXiao:[model.id intValue]];
            }];
            
            return footView;
        }
        
//        // 2 已取消
        if ([model.status intValue] == 2) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor grayColor].CGColor;
            
            [footView.goShopBtn setTitle:@"已取消" forState:UIControlStateNormal];
            [footView.goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            footView.deleteBtn.hidden = YES;
            
            return footView;
        }
        
        // 3 待发货
        if ([model.status intValue] == 3) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
            [footView.goShopBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            
            footView.deleteBtn.hidden = YES;
            
            // 确认收货
            [footView setGoShopBlack:^{
                
                ZJLog(@"确认收货");
                [weakSelf netWorkingQueRen:[model.id intValue]];
            }];
            
            return footView;
            
        }
        
        // 4 待收货
        if ([model.status intValue] == 4) {
                
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
            [footView.goShopBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            footView.deleteBtn.hidden = YES;
            
            // 确认收货
            [footView setGoShopBlack:^{
                
                ZJLog(@"确认收货");
                [weakSelf netWorkingQueRen:[model.id intValue]];
            }];
            
            return footView;
        }
        
        // 5 待评价
        if ([model.status intValue] == 5) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            
            [footView.goShopBtn setTitle:@"评价" forState:UIControlStateNormal];
            [footView.goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            footView.deleteBtn.hidden = YES;
            
            return footView;
        }
        
        // 6 已完成
        if ([model.status intValue] == 6) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
            [footView.goShopBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            
            footView.deleteBtn.layer.borderWidth = 1;
            footView.deleteBtn.layer.cornerRadius = 5;
            footView.deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [footView.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
            // 再次购买
            [footView setGoShopBlack:^{
                
                ZTShangPingModel *shangPinModel = [ZTShangPingModel mj_objectWithKeyValues:model.goods[0]];
                
                ZJLog(@"再次购买");
                UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
                ZJGoodsDetailVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
                nav.goodId = shangPinModel.goods_id;
                [weakSelf.navigationController pushViewController:nav animated:YES];
            }];
            
            // 删除订单
            [footView setDeleteBlack:^{
                
                ZJLog(@"删除订单");
                [weakSelf netWorkingDelete:[model.id intValue]];
                
            }];
            
            return footView;
        }
    }
    else  // 线下支付
    {
        
        // 2 已取消
        if ([model.status intValue] == 2) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor grayColor].CGColor;
            
            [footView.goShopBtn setTitle:@"已取消" forState:UIControlStateNormal];
            [footView.goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            footView.deleteBtn.hidden = YES;
            
            return footView;
        }
        
        // 收货付款
        if ([model.status intValue] == 1 || [model.status intValue] == 3 || [model.status intValue] == 4)
        {
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor grayColor].CGColor;
            
            [footView.goShopBtn setTitle:@"收货付款" forState:UIControlStateNormal];
            [footView.goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            footView.deleteBtn.hidden = YES;
            
            // 货到付款
            [footView setGoShopBlack:^{
                
                ZJLog(@"货到付款");
//                [self netWorkingQueRen:[model.id intValue]];
            }];
            
            return footView;
        }

        
        // 5 待评价
        if ([model.status intValue] == 5) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            
            [footView.goShopBtn setTitle:@"评价" forState:UIControlStateNormal];
            [footView.goShopBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            footView.deleteBtn.hidden = YES;
            
            return footView;
        }
        
        // 6 已完成
        if ([model.status intValue] == 6) {
            
            ZTGouWuCheFooterVIew *footView = [[[NSBundle mainBundle] loadNibNamed:@"ZTGouWuChe" owner:self options:nil] firstObject];
            
            footView.frame = CGRectMake(0, 0, iphoneWidth, 30);
            footView.moneyLab.text = model.order_money;
            
            footView.goShopBtn.layer.borderWidth = 1;
            footView.goShopBtn.layer.cornerRadius = 5;
            footView.goShopBtn.layer.borderColor = [UIColor redColor].CGColor;
            [footView.goShopBtn setTitle:@"再次购买" forState:UIControlStateNormal];
            
            footView.deleteBtn.layer.borderWidth = 1;
            footView.deleteBtn.layer.cornerRadius = 5;
            footView.deleteBtn.layer.borderColor = [UIColor grayColor].CGColor;
            [footView.deleteBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            
            // 再次购买
            [footView setGoShopBlack:^{
                
                ZJLog(@"再次购买");
                ZTShangPingModel *shangPinModel = [ZTShangPingModel mj_objectWithKeyValues:model.goods[0]];
                
                UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
                ZJGoodsDetailVC * nav = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
                nav.goodId = shangPinModel.goods_id;
                
                [weakSelf.navigationController pushViewController:nav animated:YES];
            }];
            
            // 删除订单
            [footView setDeleteBlack:^{
                
                [weakSelf netWorkingDelete:[model.id intValue]];
            }];
            
            return footView;
        }
    }
    
    return [[UIView alloc] init];
}

#pragma mark - 数据请求
- (void)netWorkingYype
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    NSString * token = [WifeButlerAccount sharedAccount].userParty.token_app;
    [dic setObject:token forKey:@"token"];
    
    [dic setObject:@(_prize) forKey:@"pageindex"];
    
    if (self.orderType == orderTypeQuanBu) {
        
        [dic setObject:@(0) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiFuKuan) {
        
        [dic setObject:@(1) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiShouHuo) {
        
        [dic setObject:@(4) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiPingJia) {
        
        [dic setObject:@(5) forKey:@"status"];
    }
    if (self.orderType == orderTypeYiWanChen) {
        
        [dic setObject:@(6) forKey:@"status"];
    }
    

    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDan];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            self.dataSource = [ZTWoDeDingDanModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            
            // 是否有订单  没有给背景图片
            if (self.dataSource.count == 0) {
                
                WEAKSELF;
                WifeButlerNoDataViewShow(self.footView, 0, ^{
                    ZJShopClassVC * shop = [[ZJShopClassVC alloc]init];
                    [weakSelf.navigationController pushViewController:shop animated:YES];
                });
            }
            else
            {
                WifeButlerNoDataViewRemoveFrom(self.footView);
            }
            
            
            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer.hidden = YES;
                
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
        
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
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark - 数据加载
- (void)netWorkingYypeJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString * token = [WifeButlerAccount sharedAccount].userParty.token_app;
    
    [dic setObject:token forKey:@"token"];
    [dic setObject:@(_prize) forKey:@"pageindex"];
    
    if (self.orderType == orderTypeQuanBu) {
        
        [dic setObject:@(0) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiFuKuan) {
        
        [dic setObject:@(1) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiShouHuo) {
        
        [dic setObject:@(4) forKey:@"status"];
    }
    if (self.orderType == orderTypeDaiPingJia) {
        
        [dic setObject:@(5) forKey:@"status"];
    }
    if (self.orderType == orderTypeYiWanChen) {
        
        [dic setObject:@(6) forKey:@"status"];
    }
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDingDan];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [self.dataSource addObjectsFromArray:[ZTWoDeDingDanModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            
            NSArray *array = responseObject[@"resultCode"];
            
            if (array.count < 10) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
            }
            else
            {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            
            [self.tableView reloadData];

        }
        else
        {
        
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
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
                        
                        [self netWorkingYypeJiaZa];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


#pragma mark - 删除
- (void)netWorkingDelete:(int)order_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(order_id) forKey:@"order_id"];

    
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

#pragma mark - 取消订单
- (void)netWorkingQuXiao:(int)order_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(order_id) forKey:@"order_id"];
    
    
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


#pragma mark - 确认收货
- (void)netWorkingQueRen:(int)order_id
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(order_id) forKey:@"order_id"];
    
    
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




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 95;

}


#pragma mark - 全部
- (IBAction)quanBuClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.daiFuKuanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiPingJiaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = MAINCOLOR;
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view5.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    _orderType = orderTypeQuanBu;
    
    [_dataSource removeAllObjects];
    [_dataSource1 removeAllObjects];
    [self.tableView reloadData];
    
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 待付款
- (IBAction)daiFuKuanClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiFuKuanBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiPingJiaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = MAINCOLOR;
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view5.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    [_dataSource removeAllObjects];
    [_dataSource1 removeAllObjects];
    [self.tableView reloadData];
    _orderType = orderTypeDaiFuKuan;
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 待收货
- (IBAction)daiShouHuoClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiFuKuanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.daiPingJiaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = MAINCOLOR;
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view5.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    _orderType = orderTypeDaiShouHuo;
    
    [_dataSource removeAllObjects];
    [_dataSource1 removeAllObjects];
    [self.tableView reloadData];
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 待评价
- (IBAction)daiPingJiaClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiFuKuanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiPingJiaBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = MAINCOLOR;
    self.view5.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    [_dataSource removeAllObjects];
    [_dataSource1 removeAllObjects];
    [self.tableView reloadData];
    _orderType = orderTypeDaiPingJia;
    
   [_tableView.mj_header beginRefreshing];
}

#pragma mark - 完成
- (IBAction)tuiHuoClick:(id)sender {
    
    [self.quanBuBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiFuKuanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiShouHuoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daiPingJiaBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.wanchenBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view5.backgroundColor = MAINCOLOR;
    
    [_dataSource removeAllObjects];
    [_dataSource1 removeAllObjects];
    
    [self.tableView reloadData];
    
    _orderType = orderTypeYiWanChen;
    
    [_tableView.mj_header beginRefreshing];
}




@end
