//
//  RecycleViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "RecycleViewController.h"
#import "RecycleTableViewCell.h"
#import "RecycleFooterView.h"
#import "Masonry.h"
#import "RecycleYuYueViewController.h"
#import "WifeButlerLocationManager.h"
#import "WifebutlerConst.h"
#import "WifeButlerNetWorking.h"
#import "NetWorkPort.h"
#import "UIImage+ColorExistion.h"
@interface RecycleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray * iconNameArray;
@property (nonatomic,strong) NSArray * nameArray;
@property (nonatomic,strong) NSArray * moneyArray;

@property (nonatomic,copy)NSString * yuyuephone;

@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;

@end

@implementation RecycleViewController




- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"回收服务";
    
    [self.yuyueBtn setBackgroundImage:[UIImage imageWithColor:WifeButlerGaryTextColor2] forState:UIControlStateDisabled];
     [self.yuyueBtn setBackgroundImage:[UIImage imageWithColor:WifeButlerCommonRedColor] forState:UIControlStateNormal];
    self.yuyueBtn.enabled = NO;
    self.iconNameArray = @[@"comp",@"telv",@"Rice",@"Rair",@"Rwash"];
    self.nameArray = @[@"电脑",@"电视机",@"冰箱",@"空调",@"洗衣机"];
    self.moneyArray = @[@"¥10.00-¥150.00/台",@"¥10.00-¥150.00/台",@"¥10.00-¥150.00/台",@"¥10.00-¥150.00/台",@"¥10.00-¥150.00/台"];

    [self.tableView registerNib:[UINib nibWithNibName:@"RecycleTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecycleTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self createFooterView];
    
    [self judgephone];
}

- (void)createFooterView
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 286)];
    RecycleFooterView * rview = [[NSBundle mainBundle]loadNibNamed:@"RecycleFooterView" owner:nil options:nil].lastObject;
  
    [backView addSubview:rview];
    [rview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backView);
    }];
    
    self.tableView.tableFooterView = backView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.iconNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecycleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecycleTableViewCell"];
    
    cell.ReimageView.image = [UIImage imageNamed:self.iconNameArray[indexPath.row]];
    cell.ReName.text = self.nameArray[indexPath.row];
    cell.ReMoney.text = self.moneyArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)yuyueClick:(id)sender {
    
    RecycleYuYueViewController * reVc = [RecycleYuYueViewController new];
    reVc.phoneNum = self.yuyuephone;
    [self.navigationController pushViewController:reVc animated:YES];
}

- (void)judgephone
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"lon"] = @([WifeButlerLocationManager sharedManager].longitude);
    parm[@"lat"] = @([WifeButlerLocationManager sharedManager].latitude);
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KGetSocialTelePhone parameter:parm success:^(NSDictionary * resultCode) {
        self.yuyueBtn.enabled = YES;
        self.yuyuephone = resultCode[@"mobile"];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"该地址不能回收."];
        self.yuyueBtn.enabled = NO;
    }];

}

@end
