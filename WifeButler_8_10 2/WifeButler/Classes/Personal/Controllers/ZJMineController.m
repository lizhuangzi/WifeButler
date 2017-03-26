
#import "ZJMineController.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerHomeTableHeaderView.h"
#import "WifeButlerDefine.h"
#import "PersonalPort.h"
//跳转控制器
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "UserQRViewController.h"
#import "WifeButlerSettingViewController.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTGuangYuMyViewController.h"
#import "ZTYiJianFanKuiViewController.h"
#import "BalanceViewController.h"
#import "CardPocketListViewController.h"
#import "ZTYouHuiJuanViewController.h"
#import "ScoreViewController.h"
#import "ZJGuangLiShouHuoDiZhiViewController.h"
#import "ZTDuiHuanDingDanViewController.h"
#import "ZTBianJiZiliaoTableViewController.h"
#import "MJRefresh.h"

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
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

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
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"personNoti"] style:UIBarButtonItemStylePlain target:self action:@selector(usermsgclick)];
        
        //头像处理
        self.userIconView.layer.cornerRadius = 30;
        self.userIconView.layer.borderWidth = 1;
        self.userIconView.layer.borderColor = WifeButlerTableBackGaryColor.CGColor;
        self.userIconView.clipsToBounds = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerClick)];
        [self.userIconView addGestureRecognizer:tap];
        
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
        
        WEAKSELF
        self.backScrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            
            weakSelf.GetLocalData().GetHttpData();
        }];
        return self;
    };
}
#pragma mark- 监听通知
- (ZJMineController * (^)())listenNotification{
    
    return ^{
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regetData) name:LoginViewControllerDidLoginSuccessNotification object:nil];
      
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userLogOut) name:WifeButlerUserDidLogOutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCurrentUserData) name:UserDataDidFinishUpDate object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regetData) name:UserImportantInfoDidSuccessChangeNotification object:nil];
        return self;
    };
}
#pragma mark - 资产点击事件
/**余额点击*/
- (IBAction)balanceClick {
    WifeButlerLetUserLoginCode
    
    BalanceViewController * b = [[BalanceViewController alloc]init];
    [self.navigationController pushViewController:b animated:YES];
}
/**积分点击*/
- (IBAction)scoreClick {
    WifeButlerLetUserLoginCode
    
    ScoreViewController *vc = [[ScoreViewController alloc]init];
    vc.scoreTxt = self.userScore.titleLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}
/**卡包点击*/
- (IBAction)cardPocketClick {
    WifeButlerLetUserLoginCode
    
    CardPocketListViewController * p = [[CardPocketListViewController alloc]init];
    [self.navigationController pushViewController:p animated:YES];
}
/**优惠券点击*/
- (IBAction)couponClick {
    WifeButlerLetUserLoginCode
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZJMineController" bundle:nil];
        ZTYouHuiJuanViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTYouHuiJuanViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 8个圆形按钮点击事件
- (void)roundButtonClick:(UIButton *)button
{
    NSUInteger index = button.tag - 2017;
    WifeButlerLetUserLoginCode
    switch (index) {
            
        case 0:{ //兑换订单
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTDuiHuanDingDan" bundle:nil];
            ZTDuiHuanDingDanViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTDuiHuanDingDanViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{ //购物车
         
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
            ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{ //地址管理
            ZJGuangLiShouHuoDiZhiViewController * dizhi = [[ZJGuangLiShouHuoDiZhiViewController alloc]init];
            [self.navigationController pushViewController:dizhi animated:YES];
        }
            break;
        case 3:{ //我要开店
            [SVProgressHUD showInfoWithStatus:@"该功能暂未开通，敬请期待"];
        }
            break;
        case 4:{//意见反馈
            ZTYiJianFanKuiViewController * fankui = [[ZTYiJianFanKuiViewController alloc]init];
            [self.navigationController pushViewController:fankui animated:YES];
        }
            break;
        case 5:{ //打电话给客服
            D_CommonAlertShow(@"确定要拨打客服电话吗",^{
                
                NSString * str = @"telprompt://01051921371";
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            });
        }
            //01051921371
            break;
        case 6:{
            ZTGuangYuMyViewController * guanYU = [[ZTGuangYuMyViewController alloc]init];
            [self.navigationController pushViewController:guanYU animated:YES];
        }
            break;
        case 7:{ //设置
            WifeButlerSettingViewController * setting = [WifeButlerSettingViewController new];
            [self.navigationController pushViewController:setting animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 头部点击
/**姓名点击*/
- (IBAction)nameClick:(UIButton *)sender {
    
    if([WifeButlerAccount sharedAccount].isLogin) return;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
    vc.isLogo = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/**点击头像*/
- (void)headerClick
{
    if(![WifeButlerAccount sharedAccount].isLogin) return; //没有登录不处理
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTBianJiInfo" bundle:nil];
    ZTBianJiZiliaoTableViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ZTBianJiZiliaoTableViewController"];
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
                [self.userMoney setTitle: [NSString stringWithFormat:@"¥%@",resultCode[@"money"]] forState:UIControlStateNormal];
                [self.userDiscountCoupon setTitle:[NSString stringWithFormat:@"%@", resultCode[@"voucher"]]  forState:UIControlStateNormal] ;
                
                [self.backScrollView.mj_header endRefreshing];
            } failure:^(NSError *error) {
                [self.backScrollView.mj_header endRefreshing];
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

- (void)regetData
{
    self.GetLocalData().GetHttpData();
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

- (void)usermsgclick
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end



