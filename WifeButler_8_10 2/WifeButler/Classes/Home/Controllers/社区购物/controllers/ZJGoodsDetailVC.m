//
//  ZJGoodsDetailVC.m
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJGoodsDetailVC.h"
#import "ZJGoodsDetailCell1.h"
#import "ZJGoodsDetailCell3.h"
#import "ZJGoodsDetailCell4.h"
#import "GoodsDetailRemarFooter.h"
#import "GoodsDetailRemarkSectionHeader.h"
#import "PhotosScrollView.h"
#import "ZTPersonGouWuCheViewController.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"
#import "GoodDetilBottomView.h"
#import "WifeButlerDefine.h"

@interface ZJGoodsDetailVC ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,GoodDetilBottomViewprotocol>


@property (nonatomic, strong)NSMutableDictionary*dataDic;//商品详情
@property (nonatomic, strong)NSMutableArray*dataAry;//商品评价列表
@property (nonatomic, copy) NSString*goodNum;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)NSMutableArray*imgAry;

// 表示符号
@property (nonatomic, assign) BOOL Flag;

@property (nonatomic, assign) CGFloat  heightFlag;
@property (weak, nonatomic) IBOutlet GoodDetilBottomView *bottomView;
//评价次数和平均评分
@property (nonatomic,assign) NSInteger reviewCount;
@property (nonatomic,assign) CGFloat averageScore;
@end

@implementation ZJGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.backgroundColor = WifeButlerTableBackGaryColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.bottomView.delegate = self;
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
    
    UIView*headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight*0.5)];
    
//   宽 320     高: 124
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight*0.5 +1)];
    [headerView addSubview:view];
    
    self.tableView.tableHeaderView = headerView;
    
    // 网络加载 --- 创建带标题的图片轮播器
//    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
//    cycleScrollView2.delegate = self;
//    cycleScrollView2.tag = 1;
//    cycleScrollView2.pageControlAliment  = SDCycleScrollViewPageContolAlimentCenter;
//    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
//    cycleScrollView2.backgroundColor = [UIColor whiteColor];
    PhotosScrollView * photoScro = [[PhotosScrollView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    [view addSubview:photoScro];
    photoScro.imageUrlStrings = imageArr;
    // --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 图片
      //  cycleScrollView2.imageURLStringsGroup = imageArr;
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
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        
        return 2;
    }
    else if(section == 1)
    {
        return self.dataAry.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ZJGoodsDetailCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"good1"];
            
            cell.nameLabel.text=[self.dataDic objectForKey:@"title"];
            cell.moneyLabel.text=[NSString stringWithFormat:@"¥%@",[self.dataDic objectForKey:@"money"]];
            cell.saleLabel.text=[NSString stringWithFormat:@"已有%@人付款",[self.dataDic objectForKey:@"sales"]];
            cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@",self.dataDic[@"oldprice"]];
            cell.inventoryLabel.text = [NSString stringWithFormat:@"库存:%@",self.dataDic[@"store"]];
            return cell;
        }
        
        if (indexPath.row == 1) {
            
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"good2"];
            return cell;
        }

    }
    if (indexPath.section == 1) { //评论

        ZJGoodsDetailCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"good4"];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        cell.nameLabel.text=[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"nickname"];
        cell.pingLunLabel.text=[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"content"];
        cell.timeLabel.text=[self time:[[self.dataAry objectAtIndex:indexPath.row] objectForKey:@"time"]];
        return cell;
        
    }else if (indexPath.section == 2){
       
        
        ZJGoodsDetailCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"good3"];
        cell.webView.delegate = self;
        [cell.webView setBackgroundColor:[UIColor whiteColor]];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?goods_id=%@",HTTP_BaseURL,KGoodDetailWebViewURL,self.goodId];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [cell.webView loadRequest:request];
        return cell;
        
    }
    
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            
            return 94;
        }
        if (indexPath.row==1) {
            
            return 66;
        }
    }
    
    if (indexPath.section == 1) {
            
        return 100;
        
    }else if (indexPath.section == 2){
        
            
            if (_Flag == YES) {
                
                return self.heightFlag;
            }
            
            return 250;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        GoodsDetailRemarkSectionHeader * header = [GoodsDetailRemarkSectionHeader DetailRemarkSectionHeader];
        
        header.reViewLabel.text = [NSString stringWithFormat:@"%zd人评价",self.reviewCount];
        header.scoreLabel.text = [NSString stringWithFormat:@"%.1f",self.averageScore];
        
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 120;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        GoodsDetailRemarFooter * footer = [[GoodsDetailRemarFooter alloc]init];
        if (self.dataAry.count == 0) {
            footer.showType = GoodsDetailRemarFooterShowTypeNoReview;
        }else{
            footer.showType = GoodsDetailRemarFooterShowTypeFindMoreReview;
        }
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 44;
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
            self.dataAry.array = [responseObject objectForKey:@"resultCode"][@"arr"];
            self.reviewCount = [[responseObject objectForKey:@"resultCode"][@"count"] integerValue];
            self.averageScore = [[responseObject objectForKey:@"resultCode"][@"mean"] floatValue];
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


- (NSString *)time :(NSString*)timeStr
{
    NSDate * createdDate =[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return  [formatter stringFromDate:createdDate];
}

#pragma mark - BottomDelegate
- (void)GoodDetilBottomViewDidClickShopping:(GoodDetilBottomView *)view
{
    WifeButlerLetUserLoginCode
    
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
- (void)GoodDetilBottomViewDidClickOthers:(GoodDetilBottomView *)view andIndex:(NSUInteger)index
{
    if (index == 2) { //点击购物车
        WifeButlerLetUserLoginCode
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTGouWuChe" bundle:nil];
        ZTPersonGouWuCheViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTPersonGouWuCheViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
