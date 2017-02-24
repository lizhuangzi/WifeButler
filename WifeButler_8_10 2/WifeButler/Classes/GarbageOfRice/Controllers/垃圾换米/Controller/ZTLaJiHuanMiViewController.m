//
//  ZTLaJiHuanMiViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiHuanMiViewController.h"
#import "ZTHuanMiCanShuTableViewCell.h"
#import "ZTHuanMiTuPianTableViewCell.h"
#import "SDCycleScrollView.h"
#import "ZTLaJiHuanMiModel.h"
#import "ZTJianJieH5TableViewCell.h"
#import "ZTZhiHuanTiJiaoViewController.h"
#import "UIColor+HexColor.h"
#import "MJRefresh.h"
#import  "MJExtension.h"

@interface ZTLaJiHuanMiViewController () <SDCycleScrollViewDelegate, UIWebViewDelegate>
{
    NSMutableArray *_dataSource;
    
    NSMutableArray *_dataSource1;
    
    int _isCanShu;
    
    ZTLaJiHuanMiModel *_model;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *kekeLab;
@property (weak, nonatomic) IBOutlet UILabel *kekeLab1;
@property (weak, nonatomic) IBOutlet UILabel *xiaoLiangLab;
@property (weak, nonatomic) IBOutlet UIButton *zhihuanbutton;

@property (weak, nonatomic) IBOutlet UIView *gunDong;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSeg;

@property(assign, nonatomic)BOOL flag;
@property(assign, nonatomic)CGFloat cellH;


// 线条
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZTLaJiHuanMiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"兑换详情";
    
    self.lineView.hidden = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self netWorking];
    
    [self.zhihuanbutton setBackgroundColor:WifeButlerCommonRedColor];
    
    [self.selectSeg setTintColor:WifeButlerCommonRedColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isCanShu == 0) {
        
        return 1;
        return _dataSource.count;
    }
    else
    {
        return _dataSource1.count;
    }

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_isCanShu == 0) {
        
//        ZTHuanMiTuPianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTHuanMiTuPianTableViewCell" forIndexPath:indexPath];
//        
//        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, _dataSource[indexPath.row]]]];
//        
//        return cell;
        
        // 改为H5后使用
        ZTJianJieH5TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTJianJieH5TableViewCell" forIndexPath:indexPath];
        
        NSString *str = [NSString stringWithFormat:@"%@goods/goods/exchange_detail_h5?goods_id=%@", HTTP_BaseURL, self.good_id];
        NSURL *loginUrl = [NSURL URLWithString:str];
        NSURLRequest *request = [NSURLRequest requestWithURL:loginUrl];
        [cell.jianJiewebView loadRequest:request];
        cell.jianJiewebView.delegate = self;
        
        return cell;
    }
    else
    {
        ZTHuanMiCanShuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTHuanMiCanShuTableViewCell" forIndexPath:indexPath];
        NSArray *arr = [_dataSource1[indexPath.row] componentsSeparatedByString:@"_"];
        
        cell.canDiLab.text = arr[0];
        cell.desLab.text = arr[1];
        
        return cell;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    webView.contentScaleFactor
    CGSize size = webView.scrollView.contentSize;
    
   // ZJLog(@"%@", size);
    webView.size = size;
    if (!_flag) {
        
        _flag = YES;
        _cellH = size.height;
        [_tableView reloadData];
    }
    
   // [webView layoutIfNeeded];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isCanShu == 0) {
        
        if (_flag) {
            
            return _cellH;
        }
        
        return 300;
    }
    else
    {
        return 33;
    }
    
    return 0;
}

- (IBAction)canPingSender:(id)sender {
    
    UISegmentedControl *seg = sender;
    
    _isCanShu = (int)seg.selectedSegmentIndex;
    
    if (_isCanShu == 0) {
        
        self.lineView.hidden = YES;
    }
    else
    {
        self.lineView.hidden = NO;
    }
    
    
    
    [self.tableView reloadData];
}

- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:@([self.good_id intValue]) forKey:@"goods_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KDuiHuanXiangQin];

    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            _model = [ZTLaJiHuanMiModel mj_objectWithKeyValues:responseObject[@"resultCode"]];
            
            self.titleLab.text = _model.title;
            
//            NSArray *arr = [_model.scale componentsSeparatedByString:@"/"];
//            
//            self.kekeLab.text = [NSString stringWithFormat:@"%@/", arr[0]];
//            self.kekeLab1.text = arr[1];
//            
//            self.xiaoLiangLab.text = [NSString stringWithFormat:@"销量%@件", _model.sales];
//            
//            
//            _dataSource = (NSMutableArray *)[_model.contents componentsSeparatedByString:@","];
//            _dataSource1 = (NSMutableArray *)[_model.goods_desc componentsSeparatedByString:@","];
//            
//            // 轮播图
//            [self createScorllView1:[_model.gallery componentsSeparatedByString:@","]];
            
            [self.tableView reloadData];
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        
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
    
    CGRect rect = self.gunDong.frame;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [self.gunDong addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArrMutTemp;
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 置换
- (IBAction)zhiHuanClick:(id)sender {

    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGarbageOfRice" bundle:nil];
    ZTZhiHuanTiJiaoViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTZhiHuanTiJiaoViewController"];
    vc.good_id = self.good_id;
    vc.pname = _model.title;
    [self.navigationController pushViewController:vc animated:YES];
    
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
