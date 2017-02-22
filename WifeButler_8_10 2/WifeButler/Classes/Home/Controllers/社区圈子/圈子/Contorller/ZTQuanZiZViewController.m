//
//  ZTSheQuQuanZiViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTQuanZiZViewController.h"
#import "ZTSheQuChuanZiQiPaoViewController.h"
#import "ZTQuanZiZViewController.h"
#import "NSString+ZJMyString.h"
#import "ZTSheQuQuanZiModel.h"
#import "ZTQuanZiZTableViewCell.h"
#import "ZTSheQuQuanZiViewController.h"
#import "ZJTrendsDetailController.h"
#import "ZTFaBuDongTaiViewController.h"
#import "ZTQuanZiView.h"
#import "ZJLoginController.h"
#import "MJRefresh.h"

@interface ZTQuanZiZViewController () <UIPopoverPresentationControllerDelegate,UITableViewDataSource, UITableViewDelegate, MWPhotoBrowserDelegate>
{
    int _pize;
    
    // 是否点击
    BOOL _isDianJi;
}

@property (nonatomic, strong) ZTSheQuChuanZiQiPaoViewController * qiBao;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) NSMutableArray * dataImageArr;

@property (nonatomic, strong) NSMutableArray * photoesArr;

// 顶部 右上角的按钮事件
@property (nonatomic, strong) ZTQuanZiView * quanZiFaBu;

// 北京View
@property (nonatomic, strong) UIView * backView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZTQuanZiZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"社区圈子";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZTAddPengYouQuan"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    [self setPram];
    
    [self shuaXinJiaZa];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新
- (void)shuaXinJiaZa
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _pize = 1;
        [self netWorking];
    }];
}

- (void)setPram
{
    _pize = 1;
    
    self.dataSource = [NSMutableArray array];
    
    self.dataImageArr = [NSMutableArray array];
    
    self.photoesArr = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTQuanZiZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTQuanZiZTableViewCell" forIndexPath:indexPath];
    
    ZTSheQuQuanZiModel *model = self.dataSource[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.nameLab.text = model.nickname;
    cell.timeLab.text = model.time;
    cell.desLa.text = model.content;
    cell.dianZhanNumLab.text = model.some;
    
    if ([model.myup intValue] == 1) { // 点过赞
        
        cell.dianZhanBtn.selected = YES;
    }
    else
    {
        cell.dianZhanBtn.selected = NO;
    }
    
    // 切割字符串出现问题,当字符串为空的时候,array.count也会为"1"
    if (model.gallery.length == 0) {
        
        cell.dataSource = @[];
    }
    else
    {
        NSArray *arr = [model.gallery componentsSeparatedByString:@","];
        
        cell.dataSource = arr;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [cell setPhotoBlack:^(ZTQuanZiZTableViewCell *cell, NSIndexPath *tempIndexPath) {
        
        [weakSelf.photoesArr removeAllObjects];
        
        for (int i = 0; i < cell.dataSource.count; i ++) {
            
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, cell.dataSource[i]]]];
            [weakSelf.photoesArr addObject:photo];
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [browser setCurrentPhotoIndex:tempIndexPath.row];   // 设置是第几个显示
        [self.navigationController pushViewController:browser animated:YES];
        
    }];
    
    __weak typeof(ZTQuanZiZTableViewCell *) cellTemp = cell;
    
    // 点赞
    [cell setDianZhanBlack:^{
        
        [weakSelf netWorkingDianZhan:model andTemp:cellTemp];
    }];
    
    // 头像点击进入他人圈子
    [cell setDianJiIconBlack:^{
       
        ZTSheQuQuanZiViewController * nav = [[ZTSheQuQuanZiViewController alloc]init];
        nav.isMyQuanZi = NO;
        nav.Zt_uid = model.uid;
        [weakSelf.navigationController pushViewController:nav animated:YES];
    }];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ZTSheQuQuanZiModel *model = self.dataSource[indexPath.row];
    
    CGFloat titleHeight = [model.content getMyStringHeightWithFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(iphoneWidth - 16, 1000)];
    
    // 切割字符圈出现问题,当字符串为空的时候,也会array.count为一
    if (model.gallery.length == 0) {
        
        return titleHeight + 169 + 6;
    }
    else
    {
        NSArray *array = [model.gallery componentsSeparatedByString:@","];
        
        if (array.count > 0) {
            
            if (array.count <= 3) {
                
                return titleHeight + 169 + 6 + (iphoneWidth - 20) / 3.0 + 10;
            }
            
            if (array.count > 3 && array.count <= 6) {
                
                return titleHeight + 169 + 6 + ((iphoneWidth - 20) / 3.0) * 2 + 10;
            }
            
            if (array.count > 6) {
                
                return titleHeight + 169 + 6 + ((iphoneWidth - 20) / 3.0) * 3 + 20;
            }
            
            return titleHeight + 169 + 6 + (iphoneWidth - 20) / 3.0 + 40;
        }
        else
        {
            return titleHeight + 169 + 6;
        }

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTSheQuQuanZiModel *model = self.dataSource[indexPath.row];
    ZJTrendsDetailController *detailCtrl = [[ZJTrendsDetailController alloc]init];
    detailCtrl.did = model.id;
    
    __weak typeof(self) weakSelf = self;
    
    // 详情页面进行点赞回调
    [detailCtrl setShuaiXinBlack:^{
        
        if (model.some.length == 0) {
            
            model.some = NSGetUserDefaults(@"nickname");
        }
        else
        {
            model.some = [model.some stringByAppendingFormat:@",%@", NSGetUserDefaults(@"nickname")];
        }
        
        model.myup = @"1";
        
        [weakSelf.tableView reloadData];
        
    }];
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

#pragma mark - 数据请求
- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(_pize) forKey:@"pageindex"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuQuanZi];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _pize = 2;
            
            [SVProgressHUD dismiss];
            
            self.dataSource = [ZTSheQuQuanZiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
        
            
            if (self.dataSource.count < 9) {
                
                self.tableView.mj_footer = nil;
            }
            else
            {
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    
                    [self netWorkingJiaZa];
                }];
            }
            
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
                    [vc setShuaiXinShuJu:^{
                        
                        [self netWorking];
                    }];
                    
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark - 数据请求
- (void)netWorkingJiaZa
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:@(_pize) forKey:@"pageindex"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuQuanZi];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            _pize ++;
            
            [SVProgressHUD dismiss];
            
            [self.dataSource addObjectsFromArray:[ZTSheQuQuanZiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]]];
            
            [self.tableView reloadData];

            if ([ZTSheQuQuanZiModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]].count<10) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            
        }
        else
        {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [vc setShuaiXinShuJu:^{
                        
                        [self netWorkingJiaZa];
                    }];
                
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
}


#pragma mark - 数据请求点赞
- (void)netWorkingDianZhan:(ZTSheQuQuanZiModel *)model andTemp:(ZTQuanZiZTableViewCell *)cell
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:model.id forKey:@"topic_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuQuanZiDianZhan];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {

            [SVProgressHUD dismiss];
            
            if (model.some.length == 0) {
                
                model.some = NSGetUserDefaults(@"nickname");
            }
            else
            {
                model.some = [model.some stringByAppendingFormat:@",%@", NSGetUserDefaults(@"nickname")];
            }
            
            cell.dianZhanBtn.selected = YES;
            model.myup = @"1";
            
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


- (void)rightItemClick{
    
    
    if (_isDianJi == NO) {
        
        _isDianJi = YES;
        
        __weak typeof(self) weakSelf = self;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.quanZiFaBu.frame = CGRectMake(iphoneWidth - 105, 64, 100, 88);
        }];
        
        
        // 发布动态
        [self.quanZiFaBu setFaBuDongTaiBlack:^{
            
            // 隐藏
            [weakSelf hiddenQuanZi];
            
            ZTFaBuDongTaiViewController *vc = [[ZTFaBuDongTaiViewController alloc] init];
            [vc setRefBlack:^{
                
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        // 我的圈子
        [self.quanZiFaBu setWoDeDongTaiBlack:^{
            
            // 隐藏
            [weakSelf hiddenQuanZi];
            
            ZTSheQuQuanZiViewController * nav = [[ZTSheQuQuanZiViewController alloc]init];
            nav.isMyQuanZi = YES;
            [weakSelf.navigationController pushViewController:nav animated:YES];
        }];
        
        
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight)];
        self.backView.alpha = 0.2;
        self.backView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.backView];
        
        
        [self.view addSubview:self.quanZiFaBu];
        
    }
    else
    {
        _isDianJi = NO;
        
        [self.backView removeFromSuperview];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _quanZiFaBu.frame = CGRectMake(iphoneWidth - 105, -88, 100, 88);
        }];
        
    }
}

#pragma mark - 显示
- (void)showQuanZi
{
    __weak typeof(self) weakSelf = self;
    
    _isDianJi = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.quanZiFaBu.frame = CGRectMake(iphoneWidth - 105, 64, 100, 88);
    }];
}

#pragma mark - 隐藏
- (void)hiddenQuanZi
{
    [self.backView removeFromSuperview];
    
    __weak typeof(self) weakSelf = self;
    
    _isDianJi = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.quanZiFaBu.frame = CGRectMake(iphoneWidth - 105, -88, 100, 88);
    }];
}



- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}


- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photoesArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoesArr.count) {
        
        return [self.photoesArr objectAtIndex:index];
    }

    return nil;
}

- (ZTQuanZiView *)quanZiFaBu
{
    if (!_quanZiFaBu) {
        
        _quanZiFaBu = [[[NSBundle mainBundle] loadNibNamed:@"ZTQuanZiView" owner:self options:nil] firstObject];
        
        _quanZiFaBu.frame = CGRectMake(iphoneWidth - 105, 0, 100, 88);
        
    }
    
    return _quanZiFaBu;
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
