//
//  GoodReviewViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/19.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "GoodReviewViewController.h"
#import "ZJGoodsDetailCell4.h"
#import "NetWorkPort.h"

@interface GoodReviewViewController ()

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign) NSUInteger page;
@end

@implementation GoodReviewViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看评价";
    self.page = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZJGoodsDetailCell4" bundle:nil] forCellReuseIdentifier:@"good4"];
    [self requestData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGoodsDetailCell4 * cell = [tableView dequeueReusableCellWithIdentifier:@"good4"];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KImageUrl,[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cell.nameLabel.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"nickname"];
    cell.pingLunLabel.text=[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    cell.timeLabel.text=[self time:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"time"]];
    NSString * star = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"star"];
    [cell.startView setCurrentScore:[star floatValue]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


- (void)requestData
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [dic setObject:self.goodId forKey:@"goods_id"];
    [dic setObject:@(self.page) forKey:@"pageindex"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KGoodEvaluationList];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        
        // 登录成功
        if ([[responseObject objectForKey:@"code"] intValue]==10000) {
            
            [SVProgressHUD dismiss];
            self.dataArray.array = [responseObject objectForKey:@"resultCode"][@"arr"];
            
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

#pragma mark - 加载 刷新
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self requestData];
}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page++;
    [self requestData];
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
