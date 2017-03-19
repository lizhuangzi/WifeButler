//
//  ZTJieSuanGouWuCheViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJieSuanGouWuCheViewController.h"
#import "ZTJieSuang11Model.h"
#import "ZTJieShuan2Model.h"
#import "ZTYouHuiJuanViewController.h"
#import "ZTjieSuanModel.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZJLoginController.h"
#import  "MJExtension.h"
#import "UserDeliverLocationReturnView.h"
#import "Masonry.h"
#import "JieSuanTableViewCell.h"
#import "JieSuanTableSectionHeader.h"
#import "NetWorkPort.h"
@interface ZTJieSuanGouWuCheViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_isZaiXianPay;      // 1在线支付   2货到付款
    
    ZTjieSuanModel *_modelAddress;
    ZTShouHuoAddressModel * _locationModel;
}

@property (nonatomic,strong) UserDeliverLocationReturnView * userInfoView;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;

@property (weak, nonatomic) IBOutlet UIView *addressView;


@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn1;
@property (weak, nonatomic) IBOutlet UIButton *ZhiFuFangShiBtn2;

@property (nonatomic,weak) UIButton * currentSelectBtn;

@property (weak, nonatomic) IBOutlet UILabel *allMoney;



@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger flag1;



@end

@implementation ZTJieSuanGouWuCheViewController

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"结算";
    
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    self.tableView1.backgroundColor = WifeButlerTableBackGaryColor;
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置userInfoView
    self.userInfoView = [[NSBundle mainBundle]loadNibNamed:@"UserDeliverLocationReturnView" owner:nil options:nil].lastObject;
    self.userInfoView.hidden = YES;
    
    WEAKSELF
    [self.userInfoView setReturnBlock:^{
        [weakSelf pushSelectLocationVc];
    }];
    [self.addressView addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressView.mas_top).offset(5);
        make.left.mas_equalTo(self.addressView);
        make.right.mas_equalTo(self.addressView);
        make.bottom.mas_equalTo(self.addressView.mas_bottom).offset(-5);
    }];
    
    
    self.view.backgroundColor = WifeButlerTableBackGaryColor;
    [self zhiFuClick:self.ZhiFuFangShiBtn1];
    
    self.allMoney.text = self.allMoneyYemp;
    
    [self.tableView1 registerNib:[UINib nibWithNibName:@"JieSuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"JieSuanTableViewCell"];
    
    [self netWorking];
}


- (IBAction)zhiFuClick:(UIButton *)sender {
    
    self.currentSelectBtn.selected = NO;
    sender.selected = YES;
    self.currentSelectBtn = sender;
    
    if (sender.tag == 249) {
        // 在线支付
        _isZaiXianPay = @"1";
    }else//货到付款
        _isZaiXianPay = @"2";
    
}


-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZTJieSuang11Model * sectionModel = _dataSource[section];
    return sectionModel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JieSuanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JieSuanTableViewCell" forIndexPath:indexPath];
    ZTJieSuang11Model * sectionModel = self.dataSource[indexPath.section];
    cell.model = sectionModel.goods[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JieSuanTableSectionHeader * header = [JieSuanTableSectionHeader HeaderViewWithTableView:tableView];
    ZTJieSuang11Model * sectionModel = _dataSource[section];
    header.shopName.text = sectionModel.shop_name;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46;
}

#pragma mark - 请求数据
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = KMoRenDiZhi;
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.userInfoView.hidden = NO;
            
            _modelAddress = [ZTjieSuanModel mj_objectWithKeyValues:responseObject[@"resultCode"][@"address"]];
            
            self.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",_modelAddress.realname,_modelAddress.sex,_modelAddress.phone];
            
            self.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@",_modelAddress.address];

        }
        else
        {
            
            if ([responseObject[@"code"] intValue] == 30000) {
                
                [SVProgressHUD dismiss];
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
//    if ([self.shouHuoAddressLab.text length] == 0 || [self.nameLab.text length] == 0 || [self.iphoneLab.text length] == 0) {
//        
//        [SVProgressHUD showErrorWithStatus:@"请填写完整的收货地址"];
//        return;
//    }
    
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






- (IBAction)NoaddressClick:(id)sender {
    
    [self pushSelectLocationVc];
}

- (void)pushSelectLocationVc
{
    WEAKSELF;
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    vc.isBack = YES;
    
    
    [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
        _locationModel = model;
        weakSelf.userInfoView.hidden = NO;
        
        weakSelf.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,model.sex,model.phone];
        
        weakSelf.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@",model.address];
    }];
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
}
@end
