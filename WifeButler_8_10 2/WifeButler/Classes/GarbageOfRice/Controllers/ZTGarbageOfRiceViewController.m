//
//  ZTGarbageOfRiceViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGarbageOfRiceViewController.h"
#import "ZTLaJiHuanMiTableViewCell.h"
#import "ZTLaJiChuLiQiTableViewCell.h"
#import "ZJProcessorDetailTableVC.h"
#import "ZTLaJiChuLiQiGouMaiModel.h"
#import "ZTLaJiHuanMiModel.h"
#import "ZTLaJiHuanMiViewController.h"
#import "UIColor+HexColor.h"

typedef enum {

    TypeLaJiDuiHuan,   // 垃圾兑换商品
    TypeLaJiGouMai     // 垃圾处理器购买

}TypeLaJi;

@interface ZTGarbageOfRiceViewController ()
{
    /**
     *  购买
     */
    NSMutableArray *_dataSource1;
    
    /**
     *  换米
     */
    NSMutableArray *_dataSource2;
    

    NSString *_strMobile;
    
    
    int _pize;
}

/**
 *  类型
 */
@property (nonatomic, assign) TypeLaJi typeLaJi;

@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UILabel *title1;

@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UILabel *title2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


/**
 *  商家
 */
@property (weak, nonatomic) IBOutlet UIImageView *shopIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *shopDesLab;
@property (weak, nonatomic) IBOutlet UILabel *shopTimeLab;

@property (weak, nonatomic) IBOutlet UIView *heardView;
@property (nonatomic, strong) UIView * headerVVV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeight;


@end

@implementation ZTGarbageOfRiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"垃圾换米";
    
    self.heardView.frame = CGRectMake(0, 0, iphoneWidth, 95);
    self.headerVVV = self.heardView;
    
    [self setPram];
    
    _pize = 1;
    
    [self createNav];
    
    [self shuaXinJiaZa];
    
    [_tableView.mj_header beginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)setPram
{
    self.shopIconImageView.layer.masksToBounds = YES;
    self.shopIconImageView.layer.cornerRadius = self.shopIconImageView.frame.size.width / 2.0;
    
    self.shopTimeLab.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pize = 1;
        [self netWorking];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pize ++;
        [self netWorkingJiaZa];
    }];

}


- (void)createNav
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    
    [self.navigationController.navigationBar setBarTintColor:WifeButlerCommonRedColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_typeLaJi == TypeLaJiDuiHuan) {
     
        return _dataSource2.count;
    }
    else
    {
    
        return _dataSource1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_typeLaJi == TypeLaJiDuiHuan) {
        
        ZTLaJiHuanMiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTLaJiHuanMiTableViewCell" forIndexPath:indexPath];
        
        ZTLaJiHuanMiModel *model = _dataSource2[indexPath.row];
        
        ZJLog(@"%@", model.file);
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.file] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cell.titleLab.text = model.title;
        
        // 如果没有简介的时候..显示暂无简介
        if (model.brief.length == 0) {
            
            cell.desLab.text = @"暂无简介";
        }
        else
        {
            cell.desLab.text = model.brief;
        }
        
        NSArray *array = [model.scale componentsSeparatedByString:@"/"];
        
        cell.num1Lab.text = array[0];
        if (array.count >=2) {
            cell.num2Lab.text = [NSString stringWithFormat:@"/%@", array[1]];
        }
        
        return cell;
    }
    else
    {
        ZTLaJiChuLiQiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTLaJiChuLiQiTableViewCell" forIndexPath:indexPath];
        
        ZTLaJiChuLiQiGouMaiModel *model = _dataSource1[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.files] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cell.titleLab.text = model.title;
        cell.numLab.text = [NSString stringWithFormat:@"￥%@", model.money];
        cell.xiaoLiangLab.text = [NSString stringWithFormat:@"销量%@件", model.sales];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_typeLaJi == TypeLaJiDuiHuan) {
        
        ZTLaJiChuLiQiGouMaiModel *model = _dataSource2[indexPath.row];
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZTGarbageOfRice" bundle:nil];
        ZTLaJiHuanMiViewController * nav=[sb instantiateViewControllerWithIdentifier:@"ZTLaJiHuanMiViewController"];
        nav.hidesBottomBarWhenPushed=YES;
        nav.good_id = model.id;
        [self.navigationController pushViewController:nav animated:YES];
    }
    else
    {
        
        ZTLaJiChuLiQiGouMaiModel *model = _dataSource1[indexPath.row];
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"ZTGarbageOfRice" bundle:nil];
        ZJProcessorDetailTableVC * nav=[sb instantiateViewControllerWithIdentifier:@"ZJProcessorDetailTableVC"];
        nav.hidesBottomBarWhenPushed=YES;
        nav.goodId = model.id;
        [self.navigationController pushViewController:nav animated:YES];
    }
}

#pragma mark - 垃圾换米
- (IBAction)laJiHuanMIClick:(id)sender {
    
    self.heardView.frame = CGRectMake(0, 0, iphoneWidth, 95);
    self.tableView.tableHeaderView = self.heardView;
    self.heardView.hidden = NO;
    
    [_dataSource1 removeAllObjects];
    [_dataSource2 removeAllObjects];
    [self.tableView reloadData];
    
    [self.icon1 setImage:[UIImage imageNamed:@"ZTDuiHuanDaMiHight"]];
    [self.title1 setTextColor:WifeButlerCommonRedColor];
    [self.icon2 setImage:[UIImage imageNamed:@"ZTLaJiChuLiQi"]];
    [self.title2 setTextColor:[UIColor grayColor]];
    
    self.typeLaJi = TypeLaJiDuiHuan;
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 垃圾处理器购买
- (IBAction)gouMaiLaJiChuLiQiClick:(id)sender {
    
    [_dataSource2 removeAllObjects];
    [_dataSource1 removeAllObjects];
    [self.tableView reloadData];
    
    self.heardView.frame = CGRectMake(0, 0, iphoneWidth, 0);
    self.heardView.hidden = YES;
    self.tableView.tableHeaderView = self.heardView;
    [self.icon1 setImage:[UIImage imageNamed:@"ZTDuiHuanDaMi"]];
    [self.title1 setTextColor:[UIColor grayColor]];
    
    [self.icon2 setImage:[UIImage imageNamed:@"ZTLaJiChuLiQiHight"]];
    [self.title2 setTextColor:WifeButlerCommonRedColor];
    
     self.typeLaJi = TypeLaJiGouMai;
    [_tableView.mj_header beginRefreshing];
}


#pragma mark - 垃圾处理器购买数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *url;
    
    if (_typeLaJi == TypeLaJiDuiHuan) { // 换米
                
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:@(_pize) forKey:@"pageindex"];
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiHuanMiList];

    }
    else
    {
        [dic setObject:@(_pize) forKey:@"pageindex"];
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiChuLiQiList];
    }

    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            if (_typeLaJi == TypeLaJiDuiHuan) { // 换米
                
                _dataSource2 = [ZTLaJiHuanMiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"][@"goods"]];
                
                [self.shopIconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, responseObject[@"resultCode"][@"shop"][@"shop_pic"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]] ;
                
                self.shopTitleLab.text = responseObject[@"resultCode"][@"shop"][@"shop_name"];
                self.shopDesLab.text = responseObject[@"resultCode"][@"shop"][@"address"];
                self.shopTimeLab.text = [NSString stringWithFormat:@"营业时间:%@", responseObject[@"resultCode"][@"shop"][@"serve_time"]];
                
                _strMobile = responseObject[@"resultCode"][@"shop"][@"mobile"];
                
                if (_dataSource2.count < 9) {
                    
                    self.tableView.mj_footer.hidden = YES;
                }
                else
                {
                    self.tableView.mj_footer.hidden = NO;
                }
            }
            else
            {
                _dataSource1 = [ZTLaJiChuLiQiGouMaiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
                
                if (_dataSource1.count < 9) {
                    
                    self.tableView.mj_footer.hidden = YES;
                }
                else
                {
                    self.tableView.mj_footer.hidden = NO;
                }
            }

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

- (void)netWorkingJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@(_pize) forKey:@"pageindex"];
    
    NSString *url;
    
    if (_typeLaJi == TypeLaJiDuiHuan) { // 换米
        
        [dic setObject:NSGetUserDefaults(@"jing") forKey:@"jing"];
        [dic setObject:NSGetUserDefaults(@"wei") forKey:@"wei"];
        [dic setObject:@(_pize) forKey:@"pageindex"];
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiHuanMiList];
        
    }
    else
    {
        [dic setObject:@(_pize) forKey:@"pageindex"];
        url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiChuLiQiList];
        
    }
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            if (_typeLaJi == TypeLaJiDuiHuan) { // 换米
                
                [_dataSource2 addObjectsFromArray:[ZTLaJiHuanMiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"][@"goods"]]];
            }
            else
            {
                [_dataSource1 addObjectsFromArray:[ZTLaJiChuLiQiGouMaiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            }
            
            [self.tableView reloadData];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark - 打电话
- (IBAction)collClick:(id)sender {
    
    if (_strMobile == nil) {
        
        [SVProgressHUD showInfoWithStatus:@"商家电话获取不成功, 请重新刷新页面"];
        return;
    }
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"将要拨打电话" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //        ZJMontherFarModel *model = _dataSource1[1];
        NSString *str = [NSString stringWithFormat:@"tel://%@", _strMobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];
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
