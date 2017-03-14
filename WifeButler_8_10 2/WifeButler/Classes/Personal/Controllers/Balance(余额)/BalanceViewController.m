//
//  BalanceViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "BalanceViewController.h"
#import "BalanceRecordViewController.h"
#import "inputPayMoneyView.h"
#import "RechargePayViewController.h"
#import "SelectCardViewController.h"
#import "WifeButlerNetWorking.h"
#import "PersonalPort.h"

@interface BalanceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;

@property (weak, nonatomic) IBOutlet UIButton *btnWithDraw;

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"余额";
    self.btnRecharge.layer.cornerRadius = 5;
    self.btnWithDraw.layer.cornerRadius = 5;
    self.btnWithDraw.clipsToBounds = YES;
    self.btnRecharge.clipsToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(recordClick)];
    
    [self requestData];
}

- (void)requestData
{
    NSDictionary * parm = @{@"userid":KUserId,@"token":KToken};
    
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KUserBalance parameter:parm success:^(NSDictionary * resultCode) {
        
         self.numLabel.text = resultCode[@"money"];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 提现点击
- (IBAction)withdrawClick {
    [self showinputPayMoneyView:NO];
}
#pragma mark - 充值点击
- (IBAction)rechargeClick {
    [self showinputPayMoneyView:YES];
}



#pragma mark - 记录点击
- (void)recordClick
{
    BalanceRecordViewController * b = [[BalanceRecordViewController alloc]init];
    [self.navigationController pushViewController:b animated:YES];
}


/**显示支付弹出框*/
- (void)showinputPayMoneyView:(BOOL)isRecharge
{
    __unsafe_unretained inputPayMoneyView * inputMoneyView = [inputPayMoneyView inputMoney];
    MJWeakSelf
    [inputMoneyView showFrom:self.view];
    
    inputMoneyView.block = ^(NSString * money){
        
        if (money.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"金额不能为空"];
            return ;
        }
        
        if ([weakSelf isNUMBER:money]) {
            
            if (money.floatValue<0.01) {
                [SVProgressHUD showErrorWithStatus:@"金额必须一分以上"];
                return;
            }
            [inputMoneyView inputViewHid];
            
            NSString * flag = @"0";
            //    //进入支付界面.
            flag = isRecharge?@"1":@"2";
            [SVProgressHUD showWithStatus:@"正在生成订单中c"];
            [weakSelf generateOrderWithMoney:money AndFlag:flag Success:^(NSString * orderId){
                
                if (isRecharge) {
                   
                    RechargePayViewController * re = [RechargePayViewController new];
                    re.order_id = orderId;
                    [weakSelf.navigationController pushViewController:re animated:YES];
                    
                }else{ //进入选择提现的银行卡界面
                    SelectCardViewController * cardList = [[SelectCardViewController alloc]init];
                    [weakSelf.navigationController pushViewController:cardList animated:YES];
                }
                
            } Failure:^{
                [SVProgressHUD showErrorWithStatus:@"生成订单失败 请稍后重试"];
            }];
            
           
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"输入金额不合法"];
        }
    };
}

- (void)generateOrderWithMoney:(NSString *)moneyStr AndFlag:(NSString *)flag Success:(void(^)(NSString * orderId))success Failure:(void(^)())failure
{
    NSDictionary * parm = @{@"userid":@"",@"token":@"",@"money":@"",@"flag":@""};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KPayAndRechargeOrder parameter:parm success:^(id resultCode) {
        
        !success?:success(@"");
        
    } failure:^(NSError *error) {
        
        !failure?: failure();
    }];
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
