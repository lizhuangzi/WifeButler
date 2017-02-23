//
//  ZJProcessorDetailTableCell4.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJProcessorDetailTableCell4.h"
#import "ZJProcessorDetailTableCell5.h"
#import "ZTShangPingGuiGeTableViewCell.h"
#import "ZTShangPinPingJiaTableViewCell.h"
#import "ZTPingLunModel.h"
#import  "MJExtension.h"

@implementation ZJProcessorDetailTableCell4

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSegmentView
{

    self.tableView1.dataSource = self;
    self.tableView1.delegate = self;
}

- (NSMutableArray *)dataSource2
{
    if (_dataSource2 == nil) {
        
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}


- (NSMutableArray *)dataSource3
{
    if (_dataSource3 == nil) {
        
        _dataSource3 = [NSMutableArray array];
    }
    return _dataSource3;
}


- (NSMutableArray *)dataSource1
{
    if (_dataSource1 == nil) {
        
        _dataSource1 = [NSMutableArray array];
    }
    
    return _dataSource1;
}



- (IBAction)segBtn:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.typeShop = typeShopJianJie;
        if (self.ShangPinBlack) {
            
            self.ShangPinBlack((int)sender.selectedSegmentIndex, self.dataSource1.count * 200);
        }
    }
    
    if (sender.selectedSegmentIndex == 1) {
        
        self.typeShop = typeShopCanShu;
        if (self.ShangPinBlack) {
            
            self.ShangPinBlack((int)sender.selectedSegmentIndex, self.dataSource2.count * 35);
        }
    }
    
    if (sender.selectedSegmentIndex == 2) {
        
        self.typeShop = typeShopPingJia;
        
        // 接口请求
        [self netWorkingPingLun];
        
    }
    
    
    [self.tableView1 reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.typeShop == typeShopJianJie) {
        
        return self.dataSource1.count;
    }
    
    if (self.typeShop == typeShopCanShu) {
        
        return self.dataSource2.count;
    }
    
    if (self.typeShop == typeShopPingJia) {
        
        return self.dataSource3.count;;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.typeShop == typeShopJianJie) {
        
        ZJProcessorDetailTableCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJProcessorDetailTableCell5" forIndexPath:indexPath];
        
        NSString *iconStr = [NSString stringWithFormat:@"%@%@", KImageUrl, self.dataSource1[indexPath.row]];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        return cell;
    }
    
    if (self.typeShop == typeShopCanShu) {
        
        ZTShangPingGuiGeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTShangPingGuiGeTableViewCell" forIndexPath:indexPath];
        
//        NSString *str = self.dataSource2[indexPath.row];
        
        NSArray *array = [self.dataSource2[indexPath.row] componentsSeparatedByString:@"_"];
        
        cell.desLab.text = array[0];
        cell.nameLab.text = array[1];
        
        
        
        return cell;
    }
    
    if (self.typeShop == typeShopPingJia) {
        
        ZTShangPinPingJiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTShangPinPingJiaTableViewCell" forIndexPath:indexPath];
        
        ZTPingLunModel *model = _dataSource3[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        cell.nameLab.text = model.nickname;
        cell.desLab.text = model.content;
        cell.timeLab.text = model.time;
        
        return cell;
    }
    
    return 0;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.typeShop == typeShopJianJie) {
        
        return 200;
    }
    
    if (self.typeShop == typeShopCanShu) {
        
        return 35;
    }
    
    if (self.typeShop == typeShopPingJia) {
        
        return 130;
    }
    
    return 0;
}

#pragma mark - 评论
- (void)netWorkingPingLun
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:self.goodId forKey:@"goods_id"];
    [dic setObject:@"20" forKey:@"pagesize"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLaJiChuLiQiPingJia];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.dataSource3 = [ZTPingLunModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"]];
            
            [self.tableView1 reloadData];
            
            if (self.ShangPinBlack) {
                
                self.ShangPinBlack(2, self.dataSource3.count * 130);
            }
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}


@end
