//
//  ServiceDetailViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ServiceDetailViewController.h"
#import "WifeButlerDefine.h"
#import "ZTYuYueViewController.h"

@interface ServiceDetailViewController ()<GoodDetilBottomViewprotocol>
/**购物详情控制器*/
@property (nonatomic,strong) ZJGoodsDetailVC * detailVc;

@property (nonatomic,copy)NSString * goodId;

@property (nonatomic,weak) NSString * shopid;

@property (nonatomic,copy)NSString * price;
@end

@implementation ServiceDetailViewController

- (instancetype)initWithGoodId:(NSString *)Id
{
    if (self = [super init]) {
        self.goodId = Id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"服务详情";
    
    UIStoryboard * sb  = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    self.detailVc = [sb instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
    self.detailVc.goodId = self.goodId;
    
WEAKSELF
    
    [self.detailVc setSettingBottomBlock:^int(GoodDetilBottomView * bottom) {
        bottom.setType(GoodDetilBottomViewShowTypeServiceDetail).setDelegate(weakSelf);
        return 1;
    }];
    [self.detailVc setUsefulDataBlock:^(NSDictionary * resultCode) {
        weakSelf.shopid = resultCode[@"shop_id"];
        weakSelf.price = resultCode[@"money"];
    }];
    self.detailVc.view.frame = self.view.bounds;
    [self.view addSubview:self.detailVc.view];
    [self addChildViewController:self.detailVc];
}

#pragma mark - 代理
- (void)GoodDetilBottomViewDidClickShopping:(GoodDetilBottomView *)view
{
    ZTYuYueViewController *yuyue = [[ZTYuYueViewController alloc]init];
    yuyue.goods_id = self.goodId;
    yuyue.dianPu_id = self.shopid;
    yuyue.price = self.price;
    [self.navigationController pushViewController:yuyue animated:YES];
}

- (void)GoodDetilBottomViewDidClickOthers:(GoodDetilBottomView *)view andIndex:(NSUInteger)index
{
    if (index == 0) {
        ZJLog(@"点击客服");
    }else{
        ZJLog(@"点击店铺");
    }
}


- (void)dealloc
{
    ZJLog(@"服务详情 dealloc");
}

@end
