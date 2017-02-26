//
//  XMGSocialViewController.m
//  02-网易新闻首页
//
//  Created by xiaomage on 15/7/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGSocialViewController.h"
#import "XMGConst.h"
#import "InformationPort.h"
#import "WifeButlerNetWorking.h"

#import "WifeButlerDefine.h"

#import "MJExtension.h"
#import "ZTJianKangShenHuoBottomModel.h"
#import "WifeButlerInfoTableViewCell.h"

@interface XMGSocialViewController ()

/**记录当前页数*/
@property (nonatomic,assign) NSInteger  page;

@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation XMGSocialViewController

static NSString *ID = @"social";

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.page = 1;

    [self.tableView registerClass:[WifeButlerInfoTableViewCell class] forCellReuseIdentifier:ID];
    
    NSLog(@"XMGSocialViewController - %f %f %f", XMGRed, XMGGreen, XMGBlue);
    
    [self requestHttpData];
}

- (void)requestHttpData{
    
    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
    parm[@"cat_id"] = self.controllerId;;
    parm[@"page"] = [NSString stringWithFormat:@"%zd",self.page];
    
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KinformationContent parameter:parm success:^(id resultCode) {
       
        NSArray * result = resultCode;
        
        NSArray * arr = [ZTJianKangShenHuoBottomModel mj_objectArrayWithKeyValuesArray:result];
        self.dataArray.array = arr;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
}

- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WifeButlerInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTJianKangShenHuoBottomModel * model = self.dataArray[indexPath.row];
    return model.cellHeigh;
}
@end
