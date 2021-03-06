//
//  ZJShopClassVC.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJShopClassVC.h"

#import "ZJGoodsDetailVC.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZTHuiZhuanDingDan1ViewController.h"
#import "WZLBadgeImport.h"
#import "ZJLoginController.h"
#import "NetWorkPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "Masonry.h"
#import "CommonShopLeftSelectTypeView.h"
#import "CommunityShopMainModel.h"
#import "MJExtension.h"
#import "CommunityShopMainViewCell.h"
#import "WifeButlerLocationManager.h"
#import "WifeButlerNoDataView.h"

@interface ZJShopClassVC ()<CommonShopLeftSelectTypeViewSelectDelegate>
/**数据源*/
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,weak) CommonShopLeftSelectTypeView * selectTypeView;

@property (nonatomic,weak) ShopLeftSelectTypeViewModel * currentSelectModel;

@property (nonatomic,assign) NSUInteger page;
@end

@implementation ZJShopClassVC

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
    _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initViewAndUI];
    
    [self requestSelectTypeHttpData];
}

#pragma 规划UI
- (void)initViewAndUI
{
    self.page = 1;
    self.title = @"社区购物";
    
    UIButton * rightBtnOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtnOrder.frame = CGRectMake(0, 0, 22, 22);
    [rightBtnOrder setBackgroundImage:[UIImage imageNamed:@"ZTDingDan"] forState:UIControlStateNormal];
    [rightBtnOrder addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBtnOrder];
    self.navigationItem.rightBarButtonItem = item1;
    
    CommonShopLeftSelectTypeView * selectView = [CommonShopLeftSelectTypeView AddIntoFatherView:self.view];
    selectView.selectDelegate = self;
    self.selectTypeView = selectView;
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(selectView.mas_right);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 请求左侧选项数据
- (void)requestSelectTypeHttpData
{
    NSMutableDictionary * parmIndex = [NSMutableDictionary dictionary];
    parmIndex[@"jing"] = @([WifeButlerLocationManager sharedManager].longitude);
    parmIndex[@"wei"] = @([WifeButlerLocationManager sharedManager].latitude);
    
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KCommunityShopLeftList parameter:parmIndex success:^(NSDictionary * resultCode) {
        
        [SVProgressHUD dismiss];
        
        NSMutableArray * tempArray = [NSMutableArray new];
        NSDictionary * cats = resultCode[@"cats"];
        NSArray * period0 = cats[@"period_0"];
        for (NSDictionary * dict in period0) {
            
            ShopLeftSelectTypeViewModel * model = [ShopLeftSelectTypeViewModel ShopLeftSelectTypeViewModelWithDictionary:dict];
            [tempArray addObject:model];
        }
        
        [self.selectTypeView receiveDatas:tempArray];
        [self.selectTypeView defaultSelect];
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal
    }];
}

#pragma mark - 请求右侧主要数据
- (void)requestMainHttpData
{
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"jing"] = @([WifeButlerLocationManager sharedManager].longitude);
    parm[@"wei"] = @([WifeButlerLocationManager sharedManager].latitude);
    parm[@"cat_id"] = self.currentSelectModel.Id;
    parm[@"serve_id"] = self.currentSelectModel.serve_id;
    parm[@"pageindex"] = [NSString stringWithFormat:@"%zd",self.page];
    
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KCommunityShopRightList parameter:parm success:^(NSArray * resultCode) {
        [SVProgressHUD dismiss];
        
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        
        if (resultCode.count == 0) { //无数据
            if (self.page == 1) {
                [SVProgressHUD showInfoWithStatus:@"无数据"];
                //显示无数据
                WifeButlerNoDataViewShow(self.tableView, 1, nil);
            }else{
                self.page --;
                [SVProgressHUD showInfoWithStatus:@"没有更多了"];
            }
        }else{ //有数据

            for (NSDictionary * dict  in resultCode) {
                CommunityShopMainModel * model = [CommunityShopMainModel ShopMainModelWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            WifeButlerNoDataViewRemoveFrom(self.tableView);
        }
        [self.tableView reloadData];
        [self.tableView endRefreshing];
        
    } failure:^(NSError *error) {
        self.page = 1;
        SVDCommonErrorDeal
    }];

}

#pragma CommonShopLeftSelectTypeViewDelegate
- (void)CommonShopLeftSelectTypeView:(CommonShopLeftSelectTypeView *)view didSelect:(ShopLeftSelectTypeViewModel *)model
{
    self.currentSelectModel = model;
    self.page = 1;
    [self requestMainHttpData];
}

#pragma mark - tableDataSoruce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityShopMainViewCell * cell = [CommunityShopMainViewCell cellWithTalbeView:tableView];
    CommunityShopMainModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommunityShopMainModel * model = self.dataArray[indexPath.row];
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"ZJHomePageController" bundle:nil];
    ZJGoodsDetailVC * vc = [story instantiateViewControllerWithIdentifier:@"ZJGoodsDetailVC"];
    vc.goodId = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark loading refresh
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestMainHttpData];
}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self requestMainHttpData];
}

- (void)orderClick
{
    WifeButlerLetUserLoginCode
    UIStoryboard * story = [UIStoryboard storyboardWithName:@"ZTHuiZhuanDingDan" bundle:nil];
    ZTHuiZhuanDingDan1ViewController * vc = [story instantiateViewControllerWithIdentifier:@"ZTHuiZhuanDingDan1ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
