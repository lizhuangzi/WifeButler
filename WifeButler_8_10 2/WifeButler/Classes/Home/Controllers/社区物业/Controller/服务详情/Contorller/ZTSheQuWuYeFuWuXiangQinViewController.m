//
//  ZTSheQuWuYeFuWuXiangQinViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuWuYeFuWuXiangQinViewController.h"
#import "ZJGoodsDetailCell4.h"
#import "SDCycleScrollView.h"
#import "ZTPingLunModel.h"
#import "ZTYuYueViewController.h"
#import "MJRefresh.h"
#import  "MJExtension.h"

typedef enum {
    
    RefreshShuaXin,      // 刷新
    RefreshJiaZa,        // 加载
    
}Refresh;

@interface ZTSheQuWuYeFuWuXiangQinViewController () <SDCycleScrollViewDelegate, UIWebViewDelegate>
{
    int _price;
    
    // 商品id
    NSString *_strTemp;
    
    // 店铺id
    NSString *_strTempShop_id;
}

@property (weak, nonatomic) IBOutlet UIView *gunDongView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (weak, nonatomic) IBOutlet UIWebView *webViewjianJie;

@property (weak, nonatomic) IBOutlet UIButton *yuYueBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) Refresh refresh;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;


@property (weak, nonatomic) IBOutlet UIView *heardView;




@end

@implementation ZTSheQuWuYeFuWuXiangQinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"服务详情";
 
    [self setPram];
    
    [self creteaRefresh];
    
    [self netWorking];
    // 评论接口
    [self netWorkingJiaZa];
}

- (void)setPram
{
    _strTemp = @"";
    
    self.dataSource = [NSMutableArray array];
    
    _price = 1;
    
    self.yuYueBtn.layer.borderWidth = 1;
    self.yuYueBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.yuYueBtn.layer.cornerRadius = 5;
}

- (void)creteaRefresh
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _price = 1;
        self.refresh = RefreshShuaXin;
        [self netWorking];
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _price ++;
        self.refresh = RefreshJiaZa;
        [self netWorkingJiaZa];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGoodsDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"good4" forIndexPath:indexPath];

    ZTPingLunModel *model = self.dataSource[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.nameLabel.text = model.nickname;
    cell.pingLunLabel.text = model.content;
    cell.timeLabel.text = model.time;
    
    return cell;
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.goods_id forKey:@"goods_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuGoodDetail];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
 
            NSString *imgStr = [[responseObject objectForKey:@"resultCode"] objectForKey:@"gallery"];
            NSArray *array = [imgStr componentsSeparatedByString:@","];
            [self createScorllView1:array];
            
            self.titleLab.text = [[responseObject objectForKey:@"resultCode"] objectForKey:@"title"];
            self.priceLab.text = [NSString stringWithFormat:@"￥%@", [[responseObject objectForKey:@"resultCode"] objectForKey:@"money"]];
            self.numLab.text = [NSString stringWithFormat:@"￥%@", [[responseObject objectForKey:@"resultCode"] objectForKey:@"sales"]];
            
            _strTempShop_id = [[responseObject objectForKey:@"resultCode"] objectForKey:@"shop_id"];
            _strTemp = [[responseObject objectForKey:@"resultCode"] objectForKey:@"id"];
            
            NSString * urlStr = [NSString stringWithFormat:@"%@%@?goods_id=%@",HTTP_BaseURL, KGoodDetailWebViewURL, self.goods_id];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            self.webViewjianJie.delegate = self;
            [self.webViewjianJie loadRequest:request];
            
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize size = webView.scrollView.size;

//    webViewHeight
    ZJLog(@"%@", webView);
    
    self.heardView.frame = CGRectMake(0, 0, iphoneWidth, 275 + size.height);
    
//    self.heardView.frame = CGRectMake(0, 0, iphoneWidth, size.height);
    
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



- (void)netWorkingJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.goods_id forKey:@"goods_id"];
    [dic setObject:@(_price) forKey:@"pageindex"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGoodEvaluationList];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            [self.dataSource addObjectsFromArray:[ZTPingLunModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];

            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer.hidden = YES;
            }
            else
            {
                self.tableView.mj_footer.hidden = NO;
            }
            
            
            [self.tableView reloadData];
            
        }
        else
        {
            
            if ([responseObject[@"code"] intValue] == 30000) {
                
                self.tableView.mj_footer.hidden = YES;
            }
            else
            {
                
                [SVProgressHUD showInfoWithStatus:message];
            }
    
        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}


#pragma mark - 马上预约
- (IBAction)yuYueClcik:(id)sender {
    
    if (_strTemp.length == 0) {
        
        return;
    }
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有登录哦,请先进行登录."];
        return;
    }
    
    ZTYuYueViewController *vc = [[ZTYuYueViewController alloc] init];
    vc.goods_id = _strTemp;
    vc.dianPu_id = _strTempShop_id;
    vc.price = self.priceLab.text;
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
