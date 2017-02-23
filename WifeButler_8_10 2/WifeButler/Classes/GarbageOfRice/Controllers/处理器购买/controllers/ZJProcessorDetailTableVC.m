//
//  ZJProcessorDetailTableVC.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJProcessorDetailTableVC.h"
#import "ZJProcessorDetailTableCell1.h"
#import "ZJProcessorDetailTableCell2.h"
#import "ZJProcessorDetailTableCell3.h"
#import "ZJProcessorDetailTableCell4.h"
#import "SDCycleScrollView.h"
#import "ZTLaJiJieShuanTableViewController.h"
#import "ZTChuLiQiXQModel.h"
#import  "MJExtension.h"

@interface ZJProcessorDetailTableVC () <ZJBuyGoodsNumDelegate, SDCycleScrollViewDelegate>
{
    NSMutableArray *_datsSource;
    
    ZTChuLiQiXQModel *_model;
}

/**
 *  颜色选择
 */
@property (nonatomic, copy) NSString * colorType;

/**
 *  数量
 */
@property (nonatomic, copy) NSString*goodNum;

/**
 *  轮播图
 */
@property (weak, nonatomic) IBOutlet UIView *gunDongView;

/**
 *  高度变化
 */
@property (nonatomic, assign) int GaoDu;

/**
 *  类型
 */
@property (nonatomic, assign) int type;

@end

@implementation ZJProcessorDetailTableVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTableViewFooterView];
    
    _datsSource = [NSMutableArray array];
    
    self.title = @"详情";
    
    [self netWorking];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置tableView的尾视图
- (void)setTableViewFooterView
{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 44, iphoneWidth, 100)];
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(50, 44, view.frame.size.width-100, 35)];
    
    [button setBackgroundColor:WifeButlerCommonRedColor];
    [button setTitle:@"立即购买" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:10.0];
    [button addTarget:self action:@selector(toBuy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.tableView.tableFooterView=view;
}

//立刻购买
- (void)toBuy
{
    if (KToken == nil) {
        
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    
    if (self.colorType == nil) {
        
        [SVProgressHUD showInfoWithStatus:@"请选择颜色"];
        return;
    }
    
    if (self.goodNum == 0) {
        
        self.goodNum = @"1";
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTLaJiaJieShuan" bundle:nil];
    ZTLaJiJieShuanTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTLaJiJieShuanTableViewController"];
    vc.tempId = self.goodId;
    vc.price = [self.goodNum intValue] * [_model.money floatValue];
    vc.yunFei = _model.ship_fee;
    vc.num = self.goodNum;
    vc.colorShop = self.colorType;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理协议
- (void)changeGoodsNumWithCurrentNum:(int)num
{

    self.goodNum = [NSString stringWithFormat:@"%d",num];

    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        
        ZJProcessorDetailTableCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"ZJProcessorDetailTableCell1"];
        
        cell.nameLabel.text = _model.title;
        cell.mobeyLabel.text = [NSString stringWithFormat:@"￥%@", _model.money];
        cell.saleLabel.text = [NSString stringWithFormat:@"销量%@件", _model.sales];
        
        return cell;
    }
    if (indexPath.row==1) {
        
        ZJProcessorDetailTableCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"ZJProcessorDetailTableCell2"];
        [cell setCollectionView];
        cell.labelAry = (NSMutableArray *)[_model.color componentsSeparatedByString:@","];
        
        __weak typeof(self) weakSelf = self;
        
        [cell setColorBlack:^(NSString *color) {
            
            weakSelf.colorType = color;
        }];
        
        return cell;
    }
    if (indexPath.row==2) {
        
        ZJProcessorDetailTableCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJProcessorDetailTableCell3"];
        cell.numTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        cell.delegate = self;
        return cell;
    }
    if (indexPath.row==3) {
        
        ZJProcessorDetailTableCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJProcessorDetailTableCell4"];
        
        [cell setSegmentView];
        
        cell.dataSource1 = (NSMutableArray *)[_model.contents componentsSeparatedByString:@","];
        cell.dataSource2 = (NSMutableArray *)[_model.goods_desc componentsSeparatedByString:@","];

        cell.goodId = self.goodId;
        
        __weak typeof(self) weakSelf = self;
        
        // 高度重新设定
        [cell setShangPinBlack:^(int a, CGFloat height) {
            
            weakSelf.type = a;
            weakSelf.GaoDu = height;
            
            [weakSelf.tableView reloadData];
        }];
        
        // 刷新嵌套tableView
        [cell.tableView1 reloadData];
        
        return cell;
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return 110;
    }
    if (indexPath.row==1) {
        
        return 110;
    }
    if (indexPath.row==2) {
        
        return 50;
    }
    if (indexPath.row==3) {
        
        if (self.type == 0) {
            
            return self.GaoDu + 32;
        }
        
        if (self.type == 1) {
            
            return self.GaoDu + 32;
        }
        
        if (self.type == 2) {
            
            return self.GaoDu + 32;
        }
        
    }
    
    return 0;
}

#pragma mark - 请求数据
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.goodId forKey:@"goods_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiChuLiQiXiangQin];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _model = [ZTChuLiQiXQModel mj_objectWithKeyValues:responseObject[@"resultCode"]];
            
            NSArray *str = [_model.contents componentsSeparatedByString:@","];
            
            self.GaoDu = (int)str.count * 200;
            
            // 轮播图
            [self createScorllView1:[_model.gallery componentsSeparatedByString:@","]];
            
            [self.tableView reloadData];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}




#pragma mark - 轮播图
- (void)createScorllView1:(NSArray *)imageArr
{
    NSMutableArray *imageArrMutTemp = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        NSString *imageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, imageArr[i]];
        
        [imageArrMutTemp addObject:imageStr];
    }
    
    CGRect rect = self.gunDongView.frame;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [self.gunDongView addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}



@end
