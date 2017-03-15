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
    } failure:^(NSError *error) {
        SVDCommonErrorDeal
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
        [cell.webView loadHTMLString:@"adlkadslkalsdlalsdlasdlalsdlaldlsadllsafn\nasnfnasndnsdnnasdnnasdnansdnasndnasd\nkkasdllasdllasldlasldlasldnnvnasdkldlasdl" baseURL:nil];
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
        return self.webHeight;
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
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        _isLoadWeb = YES;
    }
}

//点击我要捐赠
- (void)donateClick
{
    
}

@end
