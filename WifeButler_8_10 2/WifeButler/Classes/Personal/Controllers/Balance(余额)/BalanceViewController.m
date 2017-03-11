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
#import "ZTZhiFuFangShiTableViewController.h"

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
}
#pragma mark - 提现点击
- (IBAction)withdrawClick {
    
}
#pragma mark - 充值点击
- (IBAction)rechargeClick {
    [self showinputPayMoneyView];
}



#pragma mark - 记录点击
- (void)recordClick
{
    BalanceRecordViewController * b = [[BalanceRecordViewController alloc]init];
    [self.navigationController pushViewController:b animated:YES];
}


/**显示支付弹出框*/
- (void)showinputPayMoneyView
{
    __unsafe_unretained inputPayMoneyView * inputMoneyView = [inputPayMoneyView inputMoney];
    MJWeakSelf
    [inputMoneyView showFrom:self.view];
    
    inputMoneyView.block = ^(NSString * money){
        
        if (money.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"金额不能为空"];
            return ;
        }
        
        if ([self isNUMBER:money]) {
            
            if (money.floatValue<0.01) {
                [SVProgressHUD showErrorWithStatus:@"金额必须一分以上"];
                return;
            }
            
            //    //进入支付界面.
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
            ZTZhiFuFangShiTableViewController * payVc =[sb instantiateViewControllerWithIdentifier:@"ZTZhiFuFangShiTableViewController"];
            [weakSelf.navigationController pushViewController:payVc animated:YES];
            [inputMoneyView inputViewHid];
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
