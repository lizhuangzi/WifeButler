
#import "ZJMineController.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerHomeTableHeaderView.h"
#import "WifeButlerDefine.h"
#import "PersonalPort.h"
//跳转控制器
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "UserQRViewController.h"
#import "WifeButlerSettingViewController.h"

@class WifeButlerHomeCircleButton;

@interface ZJMineController ()
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
/**用户姓名*/
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
/**用户等级*/
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

/**用户余额*/
@property (weak, nonatomic) IBOutlet UIButton *userMoney;

/**用户积分*/
@property (weak, nonatomic) IBOutlet UIButton *userScore;
/**用户卡包*/
@property (weak, nonatomic) IBOutlet UIButton *userCardPocket;
/**优惠券*/
@property (weak, nonatomic) IBOutlet UIButton *userDiscountCoupon;

/**底部view*/
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@end

@implementation ZJMineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initBottomUI().listenNotification().GetLocalData().GetHttpData();
}
#pragma mark - 初始化UI
- (ZJMineController * (^)())initBottomUI{
    
    return ^{
        self.userIconView.layer.cornerRadius = 30;
        self.userIconView.clipsToBounds = YES;
        NSArray * titleArray = @[@"积分兑换",@"购物车",@"地址管理",@"我要开店",@"意见反馈",@"我的客服",@"关于我们",@"设置"];
        NSArray * imageNameArray = @[@"numberConversion",@"shopingCart",@"locationManage",@"setupShop",@"PersonFeedBack",@"MyService",@"aboutUs",@"personSetting"];
        
        CGFloat btnW = 50;
        CGFloat btnH = 60;
        CGFloat margin = (iphoneWidth - 4*btnW)/5;
        CGFloat Hmargin = (self.bottomContentView.height - 2* btnH)/3;
        for (int i = 0; i<8; i++) {
            int row = i/4;
            int cloum = i%4;
            WifeButlerHomeCircleButton * button = [[WifeButlerHomeCircleButton alloc]initWithImageName:imageNameArray[i]  andtitle:titleArray[i]];
            button.tag = i+2017;
            [button addTarget:self action:@selector(roundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(margin + cloum *(btnW+margin), Hmargin + row * (btnH + Hmargin), btnW, btnH);
            [self.bottomContentView addSubview:button];
        }
        return self;
    };
}
#pragma mark- 监听通知
- (ZJMineController * (^)())listenNotification{
    
    return ^{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrentUserData) name:LoginViewControllerDidLoginSuccessNotification object:nil];
      
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogOut) name:WifeButlerUserDidLogOutNotification object:nil];
        return self;
    };
}

- (void)roundButtonClick:(UIButton *)button
{
    NSUInteger index = button.tag - 2017;
    switch (index) {
        case 7:{
            WifeButlerSettingViewController * setting = [WifeButlerSettingViewController new];
            [self.navigationController pushViewController:setting animated:YES];
        }
            break;
            
        default:
            break;
    }
}
/**姓名点击*/
- (IBAction)nameClick:(UIButton *)sender {
    
    if([WifeButlerAccount sharedAccount].isLogin) return;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
    vc.isLogo = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取个人数据
- (ZJMineController * (^)())GetLocalData
{
    return ^{
      
        [self getCurrentUserData];
        
        return self;
    };
}


/**获取个人网络数据*/
- (ZJMineController * (^)())GetHttpData
{
    return ^{
        if ([WifeButlerAccount sharedAccount].isLogin) {
            
            WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
            NSMutableDictionary * parm = [NSMutableDictionary dictionary];
            parm[@"userid"] = party.Id;
            parm[@"token"] = party.token_app;
            [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KUserPocket parameter:parm success:^(NSDictionary * resultCode) {
                
                NSLog(@"%@",resultCode);
                
                [self.userCardPocket setTitle:resultCode[@"bankcardnum"]forState:UIControlStateNormal] ;
                [self.userScore setTitle:resultCode[@"integrals"] forState:UIControlStateNormal] ;
                [self.userMoney setTitle:[@"¥" stringByAppendingString:resultCode[@"money"]] forState:UIControlStateNormal];
                [self.userDiscountCoupon setTitle:[NSString stringWithFormat:@"%@", resultCode[@"voucher"]]  forState:UIControlStateNormal] ;
            } failure:^(NSError *error) {
                
                SVDCommonErrorDeal
            }];
        }
        
        return self;
    };
}

#pragma mark - 按钮事件
- (IBAction)orderClick {
    
    WifeButlerLetUserLoginCode
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTHuiZhuanDingDan1ViewController * vc = [story instantiateViewControllerWithIdentifier:@"ZTHuiZhuanDingDan1ViewController"];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)QRClick {
    
    UserQRViewController *qrVc = [[UserQRViewController alloc]init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

#pragma mark - 通知Notification
- (void)userLogOut
{
    self.GetLocalData();
}

- (void)getCurrentUserData
{
    WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
    if (![WifeButlerAccount sharedAccount].isLogin) {
        
        [self.nameLabel setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.levelLabel.text = @"";
        self.userIconView.image = [UIImage imageNamed:@"placeHolderIcon"];
        [self.userCardPocket setTitle:@"0" forState:UIControlStateNormal] ;
        [self.userScore setTitle:@"0" forState:UIControlStateNormal] ;
        [self.userMoney setTitle:@"¥0" forState:UIControlStateNormal];
        [self.userDiscountCoupon setTitle:@"0"forState:UIControlStateNormal] ;
        
    }else{
        [self.nameLabel setTitle:party.nickname forState:UIControlStateNormal];
        self.levelLabel.text = @"环保达人";
        NSString * iconStr = [KImageUrl stringByAppendingString:party.avatar];
        [self.userIconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"placeHolderIcon"]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end



