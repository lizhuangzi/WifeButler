//
//  ZTZhiHuanTiJiaoViewController.m
//  WifeButler
//
//  Created by ZT on 16/8/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTZhiHuanTiJiaoViewController.h"
#import "ZTjieSuanModel.h"
#import "ZTXuanZeTimeViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZTDuiHuanDingDanViewController.h"

#define MAX_LIMIT_NUMS  40

@interface ZTZhiHuanTiJiaoViewController () <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    ZTjieSuanModel *_model;
}

@property (weak, nonatomic) IBOutlet UIView *addressView;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *shouHuoAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;

@property (weak, nonatomic) IBOutlet UITextView *liuYanTV;
@property (weak, nonatomic) IBOutlet UILabel *moRenLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
// 物品
@property (weak, nonatomic) IBOutlet UILabel *dongXiLab;

@property (weak, nonatomic) IBOutlet UITextField *weight;



@end

@implementation ZTZhiHuanTiJiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"置换";
    
    [self setPram];
    
    [self netWorking];
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
            
//            [self.youHuiJuanLab setTitle:[NSString stringWithFormat:@"可使用%@张优惠券", responseObject[@"resultCode"][@"voucher"]] forState:UIControlStateNormal];
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


#pragma mark - 提交接口
- (void)netWorkingTiJiao
{
    
    if (self.timeLab.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"您的时间没有选择哦!"];
        return;
    }
    
    if (self.weight.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"您没有填写重量哦!"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",self.nameLab.text, self.shouHuoAddressLab.text, self.iphoneLab.text];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.good_id forKey:@"goods_id"];
    [dic setObject:self.timeLab.text forKey:@"exchange_time"];
    [dic setObject:self.liuYanTV.text forKey:@"text"];
    [dic setObject:self.weight.text forKey:@"weight"];
    [dic setObject:str forKey:@"receipt"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiHuanDaMiTijiao];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTDuiHuanDingDan" bundle:nil];
            ZTDuiHuanDingDanViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDuiHuanDingDanViewController"];
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

- (void)setPram
{
    self.liuYanTV.layer.borderColor = [UIColor colorWithWhite:0.834 alpha:1.000].CGColor;
    self.liuYanTV.layer.borderWidth = 1;
    self.liuYanTV.layer.cornerRadius = 5;
    self.liuYanTV.delegate = self;
    
    self.weight.delegate = self;
    
    self.dongXiLab.text = self.pname;

}

- (void)textViewDidChange:(UITextView *)textView
{
    self.liuYanTV = textView;
    
    if ([self.liuYanTV.text length]==0)
    {
        [self.moRenLab setHidden:NO];
        
    }else
    {
        [self.moRenLab setHidden:YES];
        self.moRenLab.text = @"给商家留言(选填.)";
        
    }
}


- (IBAction)shangMenTimeClick:(id)sender {
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTTimeXuanZe" bundle:nil];
    ZTXuanZeTimeViewController * nav = [sb instantiateViewControllerWithIdentifier:@"ZTXuanZeTimeViewController"];
    nav.goods_id = self.good_id;
    nav.exchange = @"1";

    __weak typeof(self) weakSelf = self;
    
    [nav setBackTimeBlack:^(NSString *time) {

        ZJLog(@"%@", time);
        weakSelf.timeLab.text = time;
    }];

    [self.navigationController pushViewController:nav animated:YES];
    
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

- (IBAction)tiJiaoDingDanClick:(id)sender {
    
    [self netWorkingTiJiao];
}

// 限制密码的长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.weight) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 8) {
            
            return NO;
        }
    }
    
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//
//{
//    
//    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    
//    if ([string length] > 40)
//        
//    {
//        
//        string = [string substringToIndex:40];
//        
//    }
//    
//    textView.text = string;
//    
//    return NO;
//    
//}

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
