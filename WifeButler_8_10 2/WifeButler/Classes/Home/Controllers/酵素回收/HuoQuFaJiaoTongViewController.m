//
//  HuoQuFaJiaoTongViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HuoQuFaJiaoTongViewController.h"
#import "inputPayMoneyView.h"
#import "WifeButlerNetWorking.h"

@interface HuoQuFaJiaoTongViewController ()

@end

@implementation HuoQuFaJiaoTongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"获取发酵桶";
}


- (IBAction)payClick:(id)sender {
    [self showinputPayMoneyView];
}

/**显示支付弹出框*/
- (void)showinputPayMoneyView{
    __unsafe_unretained inputPayMoneyView * inputMoneyView = [inputPayMoneyView inputMoney];
    [inputMoneyView setfixedmoney:@"0.01"];
    WEAKSELF
    [inputMoneyView showFrom:self.view];
    
    inputMoneyView.block = ^(NSString * money){
        
        if (money.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"金额不能为空"];
            return ;
        }
        
        if ([weakSelf isNUMBER:money]) {
            
            if (money.doubleValue<0.01) {
                [SVProgressHUD showErrorWithStatus:@"金额必须一分以上"];
                return;
            }
            [inputMoneyView inputViewHid];
            
            [SVProgressHUD showWithStatus:@"正在生成订单中"];
            
            [weakSelf generateOrderWithMoney:money ProjectId:@"" Success:^(NSString *orderId) {
                [SVProgressHUD dismiss];
//                
//                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
//                LoveDonatePayViewController * re = [sb instantiateViewControllerWithIdentifier:@"LoveDonatePayViewController"];
    
            } Failure:^{
                [SVProgressHUD showErrorWithStatus:@"生成订单失败"];
            }];
            
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"输入金额不合法"];
        }
    };
}

- (void)generateOrderWithMoney:(NSString *)moneyStr ProjectId:(NSString *)projectId Success:(void(^)(NSString * orderId))success Failure:(void(^)())failure
{
    NSDictionary * parm = @{@"userid":KUserId,@"projectid":projectId,@"money":moneyStr};

//    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KLoveDonateGenerateOrder parameter:parm success:^(id resultCode) {
//        
//        !success?:success(resultCode[@"orderid"]);
//        
//    } failure:^(NSError *error) {
//        
//        !failure?: failure();
//    }];
}

/**判断是否是金钱*/
- (BOOL)isNUMBER:(NSString *)str
{
    NSString * parttern = @"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$";
    NSRegularExpression * ex = [NSRegularExpression regularExpressionWithPattern:parttern options:0 error:nil];
    NSArray * array = [ex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    return array.count == 1?YES:NO;
}

@end
