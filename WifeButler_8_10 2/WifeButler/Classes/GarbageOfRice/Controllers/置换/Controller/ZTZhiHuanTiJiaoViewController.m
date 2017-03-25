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
#import "ZJLoginController.h"
#import  "MJExtension.h"
#import "Masonry.h"
#import "UserDeliverLocationReturnView.h"
#import "NetWorkPort.h"
#define MAX_LIMIT_NUMS  40

@interface ZTZhiHuanTiJiaoViewController () <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    ZTjieSuanModel *_model;
    ZTShouHuoAddressModel * _locationModel;
}

@property (strong, nonatomic) UserDeliverLocationReturnView *userInfoView;

@property (weak, nonatomic) IBOutlet UIView *addressView;


@property (weak, nonatomic) IBOutlet UITextView *liuYanTV;
@property (weak, nonatomic) IBOutlet UILabel *moRenLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
// 物品
@property (weak, nonatomic) IBOutlet UILabel *dongXiLab;

@property (weak, nonatomic) IBOutlet UITextField *weight;

@property (weak, nonatomic) IBOutlet UIView *duihuanKGView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation ZTZhiHuanTiJiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"置换";
    
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.clipsToBounds = YES;
    
    if ([self.danwei isEqualToString:@"kg"]) {
        self.duihuanKGView.hidden = NO;
    }else{
        self.duihuanKGView.hidden = YES;
        [self.duihuanKGView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }
    
    //设置userInfoView
    self.userInfoView = [[NSBundle mainBundle]loadNibNamed:@"UserDeliverLocationReturnView" owner:nil options:nil].lastObject;
    self.userInfoView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
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
            

            
            _model = [ZTjieSuanModel mj_objectWithKeyValues:responseObject[@"resultCode"][@"address"]];
            
            self.userInfoView.hidden = NO;
            
            self.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",_model.realname,_model.sex,_model.phone];
            
            self.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@ %@",_model.qu, _model.address];
//            [self.youHuiJuanLab setTitle:[NSString stringWithFormat:@"可使用%@张优惠券", responseObject[@"resultCode"][@"voucher"]] forState:UIControlStateNormal];
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


#pragma mark - 提交接口
- (void)netWorkingTiJiao
{
    
    if (self.timeLab.text.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"您的时间没有选择哦!"];
        return;
    }
    
//    if (self.weight.text.length == 0) {
//        
//        [SVProgressHUD showErrorWithStatus:@"您没有填写重量哦!"];
//        return;
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *str ;
    
    if (_locationModel) {
        str = [NSString stringWithFormat:@"%@,%@,%@",_locationModel.realname, _locationModel.phone, _locationModel.address];
    }else{
        str = [NSString stringWithFormat:@"%@,%@,%@",_model.realname, _model.phone, _model.address];
    }
    
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@"1" forKey:@"flag"];
    [dic setObject:self.good_id forKey:@"goods_id"];
    [dic setObject:self.timeLab.text forKey:@"exchange_time"];
    [dic setObject:self.liuYanTV.text forKey:@"text"];
    [dic setObject:KUserId forKey:@"id"];
    
    if ([self.danwei isEqualToString:@"kg"]) {
        [dic setObject:self.weight.text forKey:@"weight"];
    }else{
        [dic setObject:@"1" forKey:@"weight"];
    }
  
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

- (void)pushSelectLocationVc
{
    WEAKSELF;
    ZJGuangLiShouHuoDiZhiViewController *vc = [[ZJGuangLiShouHuoDiZhiViewController alloc] init];
    vc.isBack = YES;
    
    
    [vc setAddressBlack:^(ZTShouHuoAddressModel *model) {
        _locationModel = model;
        weakSelf.userInfoView.hidden = NO;
        
        weakSelf.userInfoView.userInfo.text = [NSString stringWithFormat:@"%@ %@ %@",model.realname,model.sex,model.phone];
        
        weakSelf.userInfoView.LocationInfo.text = [NSString stringWithFormat:@"%@ %@",model.qu,model.address];
    }];
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (IBAction)noLocationClick:(id)sender {
    
    [self pushSelectLocationVc];
}

@end
