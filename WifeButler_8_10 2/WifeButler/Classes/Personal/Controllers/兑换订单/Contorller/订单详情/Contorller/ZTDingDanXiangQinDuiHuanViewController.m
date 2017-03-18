//
//  ZTDingDanXiangQinDuiHuanViewController.m
//  WifeButler
//
//  Created by ZT on 16/8/5.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDingDanXiangQinDuiHuanViewController.h"
#import "ZTOrderXiangQinModel.h"
#import "ZJLoginController.h"
#import  "MJExtension.h"

@interface ZTDingDanXiangQinDuiHuanViewController ()
{
    ZTOrderXiangQinModel *_model;
}

@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLa;

@property (weak, nonatomic) IBOutlet UILabel *addressLab;


@property (weak, nonatomic) IBOutlet UILabel *liuYanLab;

@property (weak, nonatomic) IBOutlet UILabel *xiaDanTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *yuYueTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;

@property (weak, nonatomic) IBOutlet UIButton *keFuPhoneBtn;


@end

@implementation ZTDingDanXiangQinDuiHuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    [self netWorkingYype];
}

#pragma mark - 数据请求
- (void)netWorkingYype
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.order_id forKey:@"order_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanOrderListXiangQin];
    
    ZJLog(@"%@", dic);
    
    __weak typeof(self) weakSelf = self;

    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);

        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _model = [ZTOrderXiangQinModel mj_objectWithKeyValues:responseObject[@"resultCode"]];
            
            weakSelf.shopNameLab.text = _model.shop_name;
            [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, _model.file]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
            weakSelf.titleLab.text = _model.title;
            weakSelf.numLab.text = [NSString stringWithFormat:@"X%@", _model.weight];
            weakSelf.danweiLabel.text = _model.scale;
            
            NSArray *arrAddress = [_model.receipt componentsSeparatedByString:@","];
            weakSelf.nameLa.text =[NSString stringWithFormat:@"%@ %@", arrAddress[0],arrAddress[1]];
         
            weakSelf.addressLab.text = arrAddress[2];
            
            weakSelf.liuYanLab.text = _model.content;
            
            weakSelf.xiaDanTimeLab.text = [self setTimeStr:_model.time];
        
            if ([_model.status intValue] == 6) {
                
                weakSelf.orderTypeLab.text = @"已完成";
            }
            else
            {
                weakSelf.orderTypeLab.text = @"待收货";
            }
            
            weakSelf.yuYueTimeLab.text = _model.exchange_time;
            [weakSelf.keFuPhoneBtn setTitle:[NSString stringWithFormat:@"客服热线:%@", _model.mobile] forState:UIControlStateNormal];
            
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

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    
    }];
    
}


- (IBAction)keFuPhoneClick:(id)sender {
    
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"确认", nil);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"将要拨打电话" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //        ZJMontherFarModel *model = _dataSource1[1];
        NSString *str = [NSString stringWithFormat:@"tel://%@", _model.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [vc addAction:action];
    [vc addAction:otherAction];
    
    [self presentViewController:vc animated:YES completion:nil];

}

- (NSString *)setTimeStr:(NSString *)time
{
    // 时间戳
    NSDate * createdDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:createdDate];
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
