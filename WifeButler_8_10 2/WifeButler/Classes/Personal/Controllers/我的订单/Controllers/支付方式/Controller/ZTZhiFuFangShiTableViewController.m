//
//  ZTZhiFuFangShiTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/29.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTZhiFuFangShiTableViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZTTiShiKuanView.h"
#import "payRequsestHandler.h"
#import "WXApi.h"

typedef enum {

    zhifuBaoZhiFuFangShi,   // 支付宝
    weiXinZhiFuFangShi,     // 微信
    
}ZhiFuFangShi;

@interface ZTZhiFuFangShiTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *zhifuBaoBtn;

@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;

@property (nonatomic, assign) ZhiFuFangShi  fangShiPay;


/**
 *  确认
 */
@property (weak, nonatomic) IBOutlet UIButton *queRenBtn;


@end

@implementation ZTZhiFuFangShiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    
    [self setPram];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiXinPay:) name:@"ZT_WeiXinPay" object:nil];
}

- (void)setPram
{
    self.queRenBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.queRenBtn.layer.borderWidth = 1;
    self.queRenBtn.layer.cornerRadius = 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        
        self.fangShiPay = zhifuBaoZhiFuFangShi;
        
        self.zhifuBaoBtn.selected = NO;
        self.weiXinBtn.selected = NO;
    }
    
    if (indexPath.row == 2) {
        
        self.fangShiPay = weiXinZhiFuFangShi;
        
        self.zhifuBaoBtn.selected = YES;
        self.weiXinBtn.selected = YES;
    }
}

- (void)weiXinPay:(NSNotification *)notif
{
    int i = [notif.object intValue];
    
    ZJLog(@"微信支付结果结果结果::::%d", i);
    
    // 支付成功
    if (i == 0) {
        
        if (self.shuaiXinBlack) {
            
            self.shuaiXinBlack();
        }
        
        // 自定制弹窗
        [self createrCang];
    }
    
    // 支付错误
    if (i == -1) {
        
        [SVProgressHUD showErrorWithStatus:@"支付异常"];
    }
    
    // 用户取消支付
    if (i == -2) {
        
        [SVProgressHUD showErrorWithStatus:@"用户中途取消支付"];
        
//        if (self.shuaiXinBlack) {
//            
//            self.shuaiXinBlack();
//        }
//        
//        // 自定制弹窗
//        [self createrCang];
    }
    
}

- (IBAction)queRenClick:(id)sender {
    
    ZJLog(@"确认支付");
    
    // 支付宝
    if (self.fangShiPay == zhifuBaoZhiFuFangShi) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:KToken forKey:@"token"];
        [dic setObject:self.order_id forKey:@"order_id"];
        
        NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KZhiFuBaoZhiFu];
        
        ZJLog(@"%@", dic);
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];
            
            NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            
            ZJLog(@"%@", responseObject);
            
            NSString *mesage = [responseObject objectForKey:@"resultCode"];
            NSString *appScheme = @"laoBaoGuanJiaAlipay";

            // 成功
            if ([responseObject[@"code"] intValue] == 10000) {
                
                [[AlipaySDK defaultService] payOrder:mesage fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    NSLog(@"reslut = %@",resultDic);
                    
                    int code = [[resultDic objectForKey:@"resultStatus"] intValue];
                    
                    if(code == 9000){
                        
//                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                        if (self.shuaiXinBlack) {
                            
                            self.shuaiXinBlack();
                        }
                        
                        // 自定制弹窗
                        [self createrCang];
                        
                    }else if (code == 8000){
                        
                        [SVProgressHUD showInfoWithStatus:@"正在处理中"];
                        
                    }else if (code == 4000){
                        
                        [SVProgressHUD showInfoWithStatus:@"订单支付失败"];
                        
                    }else if (code==6001){
                        
                        [SVProgressHUD showInfoWithStatus:@"用户中途取消"];
                        
                    }else if (code==6002){
                        
                        [SVProgressHUD showInfoWithStatus:@"网络连接出错"];
                    }
                
                }];

            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
        
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            
        }];

    }
    else // 微信
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:KToken forKey:@"token"];
        [dic setObject:self.order_id forKey:@"order_id"];
        
        NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWeiXinZhiFu];
        
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
                
                [SVProgressHUD dismiss];
                
                NSDictionary *result = responseObject;
                
                time_t now;
                time(&now);
                NSString * time_stamp  = [NSString stringWithFormat:@"%ld", now];
                PayReq* req             = [[PayReq alloc] init];
                NSMutableDictionary *dict=[result objectForKey:@"resultCode"];
                
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"mch_id"];
                req.prepayId            = [dict objectForKey:@"prepay_id"];
                req.nonceStr            = [self md5:time_stamp];
                req.timeStamp           = [time_stamp intValue];
                req.package             = @"Sign=WXpay";
                
                NSMutableDictionary *signParams=[[NSMutableDictionary alloc] init];
                [signParams setObject: req.openID        forKey:@"appid"];
                [signParams setObject: req.nonceStr    forKey:@"noncestr"];
                [signParams setObject: req.package      forKey:@"package"];
                [signParams setObject: req.partnerId        forKey:@"partnerid"];
                [signParams setObject: time_stamp   forKey:@"timestamp"];
                [signParams setObject: req.prepayId     forKey:@"prepayid"];
                req.sign                = [self createMd5Sign:signParams];
            
                [WXApi sendReq:req];
            
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
            
        }];

    }
    
    
    
}

- (void)createrCang
{
    ZTTiShiKuanView *tishiView = [[[NSBundle mainBundle] loadNibNamed:@"ZTTiShiView" owner:self options:nil] firstObject];
    tishiView.backView.alpha = 0.5;
    tishiView.titleLab.text = @"付款成功";
    tishiView.frame = CGRectMake(0, 64, iphoneWidth, iphoneHeight);
    
    UIWindow *wid = [[UIApplication sharedApplication] keyWindow];
    [wid addSubview:tishiView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [tishiView removeFromSuperview];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
}


- (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"laoban9966133645laoban9966133645"];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    //[debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
