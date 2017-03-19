//
//  LoveDonateDetailViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateDetailViewController.h"
#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "LoveDonateDetailViewCell.h"
#import "LoveDonateDetailHeaderView.h"
#import "LoveDonateDetailModel.h"
#import "Masonry.h"
#import "inputPayMoneyView.h"
#import "LoveDonatePayViewController.h"

@interface LoveDonateDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) LoveDonateDetailModel * viewModel;

@property (nonatomic,weak) LoveDonateDetailHeaderView * headerView;

@property (nonatomic,assign) CGFloat webHeight;

@property (nonatomic,assign) BOOL isLoadWeb;
@end

@implementation LoveDonateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"爱心捐赠";

    [self setUpUI];
    [self requestData];
}

- (void)setUpUI
{
    _isLoadWeb = NO;
    self.webHeight = 40;
    LoveDonateDetailHeaderView * header = [[LoveDonateDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 250)];
    self.tableView.tableHeaderView = header;
    self.headerView = header;
    [self.tableView registerNib:[UINib nibWithNibName:@"LoveDonateDetailViewCell" bundle:nil] forCellReuseIdentifier:@"LoveDonateDetailViewCell"];
    self.tableView.allowsSelection = NO;
    [self createBottomView];
}

- (void)createBottomView
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 55)];
    backView.backgroundColor = WifeButlerTableBackGaryColor;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.backgroundColor = WifeButlerCommonRedColor;
    [btn setTitle:@"我要捐款" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"IWantDonate"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(donateClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(20);
        make.right.mas_equalTo(backView.mas_right).offset(-20);
        make.centerY.mas_equalTo(backView.mas_centerY);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(backView.mas_top);
    }];
}

- (void)requestData
{
    NSString * urlStr = [NSString stringWithFormat:KLoveDonateProjectDetail,self.projectId];
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:urlStr parameter:nil success:^(NSDictionary * resultCode) {
        
        self.viewModel = [LoveDonateDetailModel modelWithDictionary:resultCode];
        self.headerView.model = self.viewModel;
        [self.tableView reloadData];
        [self.tableView endRefreshing];
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
        [self.tableView endRefreshing];
    }];

}

#pragma mark - tableviwdelegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoveDonateDetailViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LoveDonateDetailViewCell"];
    cell.webView.delegate = self;
    cell.webView.scrollView.scrollEnabled = NO;
    
    if (indexPath.row == 0) {
        cell.webView.hidden = YES;
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.viewModel.brief;
        [cell layoutIfNeeded];
        self.viewModel.cell1H = CGRectGetMaxY(cell.detailLabel.frame)+35;
        
    }else if (indexPath.row == 1){
        cell.webView.hidden = YES;
        cell.detailLabel.hidden = NO;
        cell.detailLabel.text = self.viewModel.organization;
        
        [cell layoutIfNeeded];
        self.viewModel.cell2H = CGRectGetMaxY(cell.detailLabel.frame)+35;
        
    }else{
        cell.webView.hidden = NO;
        cell.detailLabel.hidden = YES;
        NSString * urlStr = [NSString stringWithFormat:KLoveDonateHtml,self.projectId];
        NSURL * url = [NSURL URLWithString:urlStr];
        NSURLRequest * req = [NSURLRequest requestWithURL:url];
        [cell.webView loadRequest:req];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return self.viewModel.cell1H + self.webHeight + self.viewModel.cell2H;
    }else if(indexPath.row == 0){
        return self.viewModel.cell1H;
    }else{
        return self.viewModel.cell2H;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webH = webView.scrollView.contentSize.height;
    self.webHeight = webH + 35;
    webView.height = webH - 5;
    
    if (!_isLoadWeb) {
       
        [self.tableView reloadData];
        _isLoadWeb = YES;
    }
}

//点击我要捐赠
- (void)donateClick
{
    [self showinputPayMoneyView];
}

/**显示支付弹出框*/
- (void)showinputPayMoneyView{
    __unsafe_unretained inputPayMoneyView * inputMoneyView = [inputPayMoneyView inputMoney];
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
            
            [weakSelf generateOrderWithMoney:money ProjectId:self.projectId Success:^(NSString *orderId) {
                [SVProgressHUD dismiss];
                
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
                LoveDonatePayViewController * re = [sb instantiateViewControllerWithIdentifier:@"LoveDonatePayViewController"];
                re.order_id = orderId;
                [weakSelf.navigationController pushViewController:re animated:YES];
                
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
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KLoveDonateGenerateOrder parameter:parm success:^(id resultCode) {
        
        !success?:success(resultCode[@"orderid"]);
        
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

- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    [self requestData];
}

@end
