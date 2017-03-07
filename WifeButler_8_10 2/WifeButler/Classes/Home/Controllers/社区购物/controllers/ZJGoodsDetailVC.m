//
//  ZJGoodsDetailVC.m
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJGoodsDetailVC.h"
#import "ZJGoodsDetailCell1.h"
#import "ZJGoodsDetailCell2.h"
#import "ZJGoodsDetailCell3.h"
#import "ZJGoodsDetailCell4.h"
#import "SDCycleScrollView.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"

@interface ZJGoodsDetailVC ()<ZJBuyGoodsNumDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong)NSMutableDictionary*dataDic;//商品详情
@property (nonatomic, strong)NSMutableArray*dataAry;//商品评价列表
@property (nonatomic, copy) NSString*goodNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray*imgAry;

// 表示符号
@property (nonatomic, assign) BOOL Flag;

@property (nonatomic, assign) CGFloat  heightFlag;


@end

@implementation ZJGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self ZJNetWorking];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    self.title = @"商品详情";
    
    self.goodNum = @"1";
    
    self.pageSize = 1;
    
    // 默认设置no
    self.Flag = NO;
    
    // 评价数据请求
    [self ZJNetWorkingJiaZa];
    
    [self creteaReJres];
    
    [self.tableView.mj_header beginRefreshing];
}

//设置头部滚动视图
- (void)createScorllViewWuWang:(NSArray *)imageArr
{
    
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight*0.3)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 27, 18)];
    imageView.image = [UIImage imageNamed:@"ZTShangJiaDianPu"];
    [headerView addSubview:imageView];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(41, 5, 271, 21)];
    lab.text = self.dataDic[@"shop_name"];
    [headerView addSubview:lab];
    
//   宽 320     高: 124
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 32, iphoneWidth, iphoneHeight*0.3 - 18)];
    [headerView addSubview:view];
    
    UIView *view111 = [[UIView alloc] initWithFrame:CGRectMake(0, 31, iphoneWidth, 1)];
    view111.backgroundColor = [UIColor colorWithWhite:0.770 alpha:1.000];
    [headerView addSubview:view111];
    
    self.tableView.tableHeaderView = headerView;
    
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cycleScrollView2.delegate = self;
    cycleScrollView2.tag = 1;
    cycleScrollView2.pageControlAliment  = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    [view addSubview:cycleScrollView2];
    
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 图片
        cycleScrollView2.imageURLStringsGroup = imageArr;
    });
}

- (void)creteaReJres
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageSize = 1;
        [self ZJNetWorking];
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageSize ++;
        [self ZJNetWorkingJiaZa];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理协议
- (void)changeGoodsNumWithCurrentNum:(int)num
{
    self.goodNum = [NSString stringWithFormat:@"%d",num];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return 3;
    }
    else
    {
        return self.dataAry.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ZJGoodsDetailCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"good1"];
            
            cell.nameLabel.text=[self.dataDic objectForKey:@"title"];
            cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",[self.dataDic objectForKey:@"money"]];
            cell.saleLabel.text=[NSString stringWithFormat:@"%@",[self.dataDic objectForKey:@"sales"]];
            if ([[self.dataDic objectForKey:@"ship_time"] intValue]==1) {
                cell.titleLabel.text=@"45分钟到达";
            }
            if ([[self.dataDic objectForKey:@"ship_time"] intValue]==2) {
                cell.titleLabel.text=@"90分钟到达";
            }
            if ([[self.dataDic objectForKey:@"ship_time"] intValue]==3) {
                cell.titleLabel.text=@"超过90分钟到达";
            }
            
            return cell;
        }
        
        if (indexPath.row == 1) {
            
            ZJGoodsDetailCell2 *cell=[tableView dequeueReusableCellWithIdentifier:@"good2"];
            cell.delegate=self;
            
            cell.chooseLabel.text = [NSString stringWithFormat:@"%@件",self.goodNum];
            cell.remainLabel.text = [NSString stringWithFormat:@"%@件", self.dataDic[@"store"]];
            return cell;
        }
        
        if (indexPath.row == 2) {
        
            ZJGoodsDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"good3"];
            cell.webView.delegate = self;
            [cell.webView setBackgroundColor:[UIColor whiteColor]];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@?goods_id=%@",HTTP_BaseURL,KGoodDetailWebViewURL,self.goodId];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
            [cell.webView loadRequest:request];
            return cell;
        }
    
    }
    
    if (indexPath.section == 1) { //评论
//        [UIImage imageNamed:@""]
        ZJGoodsDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"good4"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        cell.nameLabel.text=[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        cell.pingLunLabel.text=[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"content"];
        cell.timeLabel.text=[self time:[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"time"]];
        return cell;
    }
    
    
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            
            return 114;
        }
        if (indexPath.row==1) {
            
            return 68;
        }
        if (indexPath.row==2) {
            
            
            if (_Flag == YES) {
                
                return self.heightFlag;
            }
            
            return 250;
        }

    }
    
    if (indexPath.section == 1) {
            
        return 129;
        
    }
    
    return 0;
}



#pragma mark - webViewDatelate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    webView.contentScaleFactor
    CGSize size = webView.scrollView.contentSize;
    
    // ZJLog(@"%@", size);
    webView.size = size;

    if (self.Flag == NO) {
        
        self.Flag = YES;
        
        self.heightFlag = size.height;
        
        [self.tableView reloadData];
        
    }
    // [webView layoutIfNeeded];
    
}



- (void)ZJNetWorking
{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    [dic setObject:self.goodId forKey:@"goods_id"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuGouWuGoodDetail];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            self.dataDic = [responseObject objectForKey:@"resultCode"];
            NSString *imgStr = [self.dataDic objectForKey:@"gallery"];
            NSArray *array = [imgStr componentsSeparatedByString:@","];
            for (int i = 0; i < [array count]; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%@%@",KImageUrl,[array objectAtIndex:i]];
                [self.imgAry addObject:str];
            }
            [self createScorllViewWuWang:self.imgAry];
            [self.tableView reloadData];
        }else
        {
            [SVProgressHUD showInfoWithStatus:[responseObject objectForKey:@"message"]];
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)ZJNetWorkingJiaZa
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:self.goodId forKey:@"goods_id"];
    [dic setObject:@(self.pageSize) forKey:@"pageindex"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGoodEvaluationList];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue]==10000) {
            
            [SVProgressHUD dismiss];
            self.dataAry = [responseObject objectForKey:@"resultCode"];
            
            if (self.dataAry.count < 9) {
                
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}



-(NSMutableDictionary*)dataDic
{
    if (!_dataDic) {
        _dataDic=[[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}

-(NSMutableArray*)dataAry
{
    if (!_dataAry) {
        _dataAry=[[NSMutableArray alloc]init];
    }
    return _dataAry;
}

-(NSMutableArray*)imgAry
{
    if (!_imgAry) {
        _imgAry=[[NSMutableArray alloc]init];
    }
    return _imgAry;
}

//加入购物车
- (IBAction)addToBuyBus:(id)sender {
    
    if (KToken == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有登录,请先进行登录"];
        return;
    }
    
    if ([self.dataDic[@"store"] intValue] < [self.goodNum intValue]) {
        
        [SVProgressHUD showErrorWithStatus:@"您选择的数量大于库存"];
        return;
        
    }
    
    
    
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    [dic setObject:self.goodId forKey:@"goods_id"];
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.goodNum forKey:@"num"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KAddBusURL];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue]==10000) {
            [SVProgressHUD showSuccessWithStatus:
             @"加入购物车成功"];
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
            ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            [self.tableView reloadData];
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
            }

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];
}

-(void)getWebViewUrl
{
    NSMutableDictionary*dic=[NSMutableDictionary dictionary];
    [dic setObject:self.goodId forKey:@"goods_id"];
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.goodNum forKey:@"num"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KAddBusURL];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        ZJLog(@"%@", responseObject);
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue]==10000) {
            
            [SVProgressHUD showSuccessWithStatus:
             @"加入购物车成功"];
            [self.tableView reloadData];
            
        }else
        {
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
    }];
}

- (NSString *)time :(NSString*)timeStr
{
    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return  [formatter stringFromDate:createdDate];
}

@end
