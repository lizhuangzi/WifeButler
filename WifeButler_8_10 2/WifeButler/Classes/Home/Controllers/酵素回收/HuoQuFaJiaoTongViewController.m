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
#import "UIImage+ColorExistion.h"
#import "NetWorkPort.h"
#import "EnzyCashPledgeViewController.h"

@interface HuoQuFaJiaoTongViewController ()

@property (nonatomic,copy)NSString * money;

@property (weak, nonatomic) IBOutlet UIButton *cashPledgeBtn;
@end

@implementation HuoQuFaJiaoTongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"获取发酵桶";
    self.cashPledgeBtn.enabled = NO;
    [self.cashPledgeBtn setBackgroundImage:[UIImage imageWithColor:WifeButlerCommonRedColor] forState:UIControlStateNormal];
    
    [self.cashPledgeBtn setBackgroundImage:[UIImage imageWithColor:WifeButlerGaryTextColor2] forState:UIControlStateDisabled];
    
    [self.cashPledgeBtn setTitle:@"已支付押金" forState:UIControlStateDisabled];
    
    [self.cashPledgeBtn setTitle:@"支付押金" forState:UIControlStateNormal];

    [self requestData];
}


- (void)requestData
{
    [SVProgressHUD showWithStatus:@""];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KEnzymesRecycleisPaycashPledge parameter:@{@"userid":KUserId} success:^(NSDictionary * resultCode) {
        
        [SVProgressHUD dismiss];
        NSString * flag = resultCode[@"flag"];
        if ([flag isEqualToString:@"1"]) {
            self.cashPledgeBtn.enabled = NO;
        }else{
            self.cashPledgeBtn.enabled = YES;
        }
        self.money = resultCode[@"money"];
        ZJLog(@"%@",resultCode);
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络出错了"];
        self.cashPledgeBtn.enabled = NO;
    }];
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
            
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
            EnzyCashPledgeViewController * re = [sb instantiateViewControllerWithIdentifier:@"EnzyCashPledgeViewController"];
            [re setShuaiXinBlack:^{
                [weakSelf requestData];
            }];
            [weakSelf.navigationController pushViewController:re animated:YES];

            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"输入金额不合法"];
        }
    };
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
