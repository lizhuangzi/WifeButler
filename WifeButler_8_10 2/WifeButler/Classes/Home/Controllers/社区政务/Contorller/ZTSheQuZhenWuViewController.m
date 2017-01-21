//
//  ZTSheQuZhenWuViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuZhenWuViewController.h"
#import "ZTSheQuZhenWuTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ZTZhenWuXiangQinViewController.h"

@interface ZTSheQuZhenWuViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    int _pize;
    int _type;
}

@property (weak, nonatomic) IBOutlet UIView *gunDongView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSourceTop;
@property (nonatomic, strong) NSMutableArray * dataSource;
/**
 *  顶部轮播图的数据
 */
@property (nonatomic, strong) NSMutableArray * dataSourceGunDong;

@end

@implementation ZTSheQuZhenWuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setPram];
    
    [self shuaXinJiaZa];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setPram
{
    self.title = @"社区政务";
    
    self.dataSourceTop = [NSMutableArray array];
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self netWorking];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTSheQuZhenWuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTSheQuZhenWuTableViewCell" forIndexPath:indexPath];

    cell.titleLab.text = self.dataSource[indexPath.row][@"name"];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSource[indexPath.row][@"file"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTZhenWuXiangQinViewController *vc = [[ZTZhenWuXiangQinViewController alloc] init];
    vc.id_temp = self.dataSource[indexPath.row][@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuZhenWu];
    
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
            
            [self createScorllView1:responseObject[@"resultCode"][@"carousel"]];
            
            self.dataSourceGunDong = responseObject[@"resultCode"][@"carousel"];
            
            self.dataSourceTop = responseObject[@"resultCode"][@"main"];
  
            self.dataSource = self.dataSourceTop[0][@"article"];
            
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
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [self.gunDongView addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}



- (IBAction)Click1:(id)sender {

    self.dataSource = self.dataSourceTop[0][@"article"];
    
    [self.tableView reloadData];
}

- (IBAction)Click2:(id)sender {
    
    self.dataSource = self.dataSourceTop[1][@"article"];
    
    [self.tableView reloadData];
}

- (IBAction)Click3:(id)sender {
    
    self.dataSource = self.dataSourceTop[2][@"article"];
    
    [self.tableView reloadData];
    
}
- (IBAction)Click4:(id)sender {
    
    self.dataSource = self.dataSourceTop[3][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click5:(id)sender {
    
    self.dataSource = self.dataSourceTop[4][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click6:(id)sender {
    
    self.dataSource = self.dataSourceTop[5][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click7:(id)sender {
    
    self.dataSource = self.dataSourceTop[6][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click8:(id)sender {
    
    self.dataSource = self.dataSourceTop[7][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click9:(id)sender {
    
    self.dataSource = self.dataSourceTop[8][@"article"];
    
    [self.tableView reloadData];
}
- (IBAction)Click10:(id)sender {
    
    self.dataSource = self.dataSourceTop[9][@"article"];
    
    [self.tableView reloadData];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    ZTZhenWuXiangQinViewController *vc = [[ZTZhenWuXiangQinViewController alloc] init];
    vc.id_temp = self.dataSourceGunDong[index][@"goods_id"];
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
