
//
//  ZTHealthyLifestyleViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/16.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTHealthyLifestyleViewController.h"
#import "ZTJianKangShenHuoTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ZTXiangQinHealthyLifeViewController.h"
#import "ZTJianKangShenHuoBottomModel.h"
#import "UIColor+HexColor.h"
@interface ZTHealthyLifestyleViewController ()<SDCycleScrollViewDelegate>
{
    int _pize;
    int _type;  // 类型
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 *  滚动视图
 */
@property (weak, nonatomic) IBOutlet UIView *gunDongView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;


@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;
@property (weak, nonatomic) IBOutlet UIImageView *icon4;


@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;

@property (nonatomic, strong) NSMutableArray * dataSourceTop;
@property (nonatomic, strong) NSMutableArray * dataSource;
// 轮播图
@property (nonatomic, strong) NSMutableArray * dataSourceLunBoTu;


@end

@implementation ZTHealthyLifestyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"健康生活";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _pize = 1;
    
    [self createNav];

    [self netWorking];
    
    [self shuaXinJiaZa];
}

- (void)createNav
{
    self.dataSourceTop = [NSMutableArray array];
    
    self.dataSource = [NSMutableArray array];
    
    self.dataSourceLunBoTu = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName :[UIFont boldSystemFontOfSize:17]};
    
    [self.navigationController.navigationBar setBarTintColor:WifeButlerCommonRedColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pize = 1;
        [self netWorkingBottom:_type];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _pize ++;
        [self netWorkingBottomJiaZa:_type];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTJianKangShenHuoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTJianKangShenHuoTableViewCell" forIndexPath:indexPath];

    ZTJianKangShenHuoBottomModel *model = self.dataSource[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.file]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cell.titleLab.text = model.name;
    cell.desLab.text = model.alt;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZTXiangQinHealthyLifeViewController *vc = [[ZTXiangQinHealthyLifeViewController alloc] init];
    ZTJianKangShenHuoBottomModel *model = self.dataSource[indexPath.row];
    vc.id_temp = model.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//ZTHuoDong
//ZTJiaoYuZiXun
//ZTQiTa
//ZTXinWen
#pragma mark - 咨询
- (IBAction)jiaoYuClick:(id)sender {
    
    self.view1.backgroundColor = MAINCOLOR;
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    [self.icon1 setImage:[UIImage imageNamed:@"ZTJiaoYuZiXun_S"]];
    [self.icon2 setImage:[UIImage imageNamed:@"ZTHuoDong"]];
    [self.icon3 setImage:[UIImage imageNamed:@"ZTXinWen"]];
    [self.icon4 setImage:[UIImage imageNamed:@"ZTQiTa"]];
    
    [self.title1 setTextColor:WifeButlerCommonRedColor];
    [self.title2 setTextColor:[UIColor blackColor]];
    [self.title3 setTextColor:[UIColor blackColor]];
    [self.title4 setTextColor:[UIColor blackColor]];

    
    _type = 0;
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 活动
- (IBAction)huoDongClick:(id)sender {
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = MAINCOLOR;
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    
    [self.icon1 setImage:[UIImage imageNamed:@"ZTJiaoYuZiXun"]];
    [self.icon2 setImage:[UIImage imageNamed:@"ZTHuoDong_S"]];
    [self.icon3 setImage:[UIImage imageNamed:@"ZTXinWen"]];
    [self.icon4 setImage:[UIImage imageNamed:@"ZTQiTa"]];
    
    [self.title1 setTextColor:[UIColor blackColor]];
    [self.title2 setTextColor:WifeButlerCommonRedColor];
    [self.title3 setTextColor:[UIColor blackColor]];
    [self.title4 setTextColor:[UIColor blackColor]];
    
    _type = 1;
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 生活
- (IBAction)shenHuoClick:(id)sender {
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = MAINCOLOR;
    self.view4.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    
    
    [self.icon1 setImage:[UIImage imageNamed:@"ZTJiaoYuZiXun"]];
    [self.icon2 setImage:[UIImage imageNamed:@"ZTHuoDong"]];
    [self.icon3 setImage:[UIImage imageNamed:@"ZTXinWen_S"]];
    [self.icon4 setImage:[UIImage imageNamed:@"ZTQiTa"]];
    
    [self.title1 setTextColor:[UIColor blackColor]];
    [self.title2 setTextColor:[UIColor blackColor]];
    [self.title3 setTextColor:WifeButlerCommonRedColor];
    [self.title4 setTextColor:[UIColor blackColor]];
    
    _type = 2;
    
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 其他
- (IBAction)qiTaClick:(id)sender {
    
    self.view1.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view2.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view3.backgroundColor = [UIColor colorWithWhite:0.744 alpha:1.000];
    self.view4.backgroundColor = MAINCOLOR;
    
    
    [self.icon1 setImage:[UIImage imageNamed:@"ZTJiaoYuZiXun"]];
    [self.icon2 setImage:[UIImage imageNamed:@"ZTHuoDong"]];
    [self.icon3 setImage:[UIImage imageNamed:@"ZTXinWen"]];
    [self.icon4 setImage:[UIImage imageNamed:@"ZTQiTa_S"]];
    
    [self.title1 setTextColor:[UIColor blackColor]];
    [self.title2 setTextColor:[UIColor blackColor]];
    [self.title3 setTextColor:[UIColor blackColor]];
    [self.title4 setTextColor:WifeButlerCommonRedColor];

    _type = 3;
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KJianKangShenHuo];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.dataSourceLunBoTu = responseObject[@"resultCode"][@"carousel"];
            
            [self createScorllView1:responseObject[@"resultCode"][@"carousel"]];
            
            self.dataSourceTop = responseObject[@"resultCode"][@"cats"];
            
            self.title1.text = self.dataSourceTop[0][@"name"];
            self.title2.text = self.dataSourceTop[1][@"name"];
            self.title3.text = self.dataSourceTop[2][@"name"];
            self.title4.text = self.dataSourceTop[3][@"name"];
            
//            [self.icon1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSourceTop[0][@"file"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu"]];
//            [self.icon2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSourceTop[1][@"file"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu"]];
//            [self.icon3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSourceTop[2][@"file"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu"]];
//            [self.icon4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSourceTop[3][@"file"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu"]];
         
            
            [self netWorkingBottom:_type];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)netWorkingBottom:(int)temp
{
    if (self.dataSourceTop.count < 1) {
        
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *tempA = self.dataSourceTop[temp][@"id"];
    
    [dic setObject:tempA forKey:@"cat_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KJianKangShenHuoBottom];

    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            self.dataSource = [ZTJianKangShenHuoBottomModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer = nil;
            }
            
            [self.tableView reloadData];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


- (void)netWorkingBottomJiaZa:(int)temp
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *tempA = self.dataSourceTop[temp][@"id"];
    
    [dic setObject:tempA forKey:@"cat_id"];
    [dic setObject:@(_pize) forKey:@"pageindex"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KJianKangShenHuoBottom];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [self.dataSource addObjectsFromArray:[ZTJianKangShenHuoBottomModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            [self.tableView reloadData];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


#pragma mark - 轮播图
- (void)createScorllView1:(NSArray *)imageArr
{
    NSMutableArray *imageArrMutTemp = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        NSString *imageStr = [NSString stringWithFormat:@"%@%@", KImageUrl, imageArr[i][@"file"]];
        
        [imageArrMutTemp addObject:imageStr];
    }
    
    CGRect rect = self.gunDongView.frame;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.delegate = self;
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [self.gunDongView addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ZTXiangQinHealthyLifeViewController *vc = [[ZTXiangQinHealthyLifeViewController alloc] init];
    vc.id_temp = self.dataSourceLunBoTu[index][@"goods_id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
