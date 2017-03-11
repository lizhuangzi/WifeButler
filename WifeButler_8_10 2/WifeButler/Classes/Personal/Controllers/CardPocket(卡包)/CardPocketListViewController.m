//
//  CardPocketListViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketListViewController.h"
#import "CardPocketTableViewCell.h"
#import "CardPocketAddViewController.h"

@interface CardPocketListViewController ()

@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation CardPocketListViewController

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"我的卡包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Cardadd"] style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    [self.tableView registerNib:[UINib nibWithNibName:@"CardPocketTableViewCell" bundle:nil] forCellReuseIdentifier:@"CardPocketTableViewCell"];
}


- (void)addClick
{
    CardPocketAddViewController * vc = [[CardPocketAddViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CardPocketTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CardPocketTableViewCell" forIndexPath:indexPath];
    return cell;
}

@end
