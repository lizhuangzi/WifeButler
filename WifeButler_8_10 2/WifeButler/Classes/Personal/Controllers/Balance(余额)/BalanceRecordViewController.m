//
//  BalanceRecordViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "BalanceRecordViewController.h"
#import "BalanceRecordTableViewCell.h"

@interface BalanceRecordViewController ()

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation BalanceRecordViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"BalanceRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"BalanceRecordTableViewCell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BalanceRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BalanceRecordTableViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
