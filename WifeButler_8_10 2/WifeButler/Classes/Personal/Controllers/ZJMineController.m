
#import "ZJMineController.h"
#import "WifeButlerHomeTableHeaderView.h"
#import "WifeButlerDefine.h"

@class WifeButlerHomeCircleButton;

@interface ZJMineController ()
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
/**用户姓名*/
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
/**用户等级*/
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

/**底部view*/
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@end

@implementation ZJMineController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initBottomUI().GetDefaultData().listenNotification();
}
#pragma mark - 初始化UI
- (ZJMineController * (^)())initBottomUI{
    
    return ^{
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
      
        return self;
    };
}

- (void)roundButtonClick:(UIButton *)button
{
    
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
- (ZJMineController * (^)())GetDefaultData
{
    return ^{
      
        [self getCurrentUserData];
        
        return self;
    };
}

- (void)getCurrentUserData
{
    WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
    if (![WifeButlerAccount sharedAccount].isLogin) {
        
        [self.nameLabel setTitle:@"登录/注册" forState:UIControlStateNormal];
        self.levelLabel.text = @"";
    }else{
        [self.nameLabel setTitle:party.nickname forState:UIControlStateNormal];
        self.levelLabel.text = @"环保达人";
    }
}

@end



