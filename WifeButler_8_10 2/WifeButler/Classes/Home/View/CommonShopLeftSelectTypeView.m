//
//  CommonShopLeftSelectTypeView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CommonShopLeftSelectTypeView.h"
#import "Masonry.h"

@implementation ShopLeftSelectTypeViewModel

+ (instancetype)ShopLeftSelectTypeViewModelWithDictionary:(NSDictionary *)dict
{
    ShopLeftSelectTypeViewModel * model = [ShopLeftSelectTypeViewModel new];
    model.name = dict[@"name"];
    model.Id = dict[@"id"];
    model.serve_id = dict[@"serve_id"];
    return model;
}

@end

@interface CommonShopLeftSelectTypeView ()<UITableViewDataSource,UITableViewDelegate>

/**数据源*/
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation CommonShopLeftSelectTypeView

+ (instancetype)AddIntoFatherView:(UIView *)fatherView
{
    CommonShopLeftSelectTypeView * table = [[CommonShopLeftSelectTypeView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [fatherView addSubview:table];
    
    table.backgroundColor = WifeButlerTableBackGaryColor;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fatherView.mas_top);
        make.left.mas_equalTo(fatherView.mas_left);
        make.bottom.mas_equalTo(fatherView.mas_bottom);
        make.width.mas_equalTo(99);
    }];
    
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    return table;
}

- (void)defaultSelect
{
    if (self.dataArray.count>0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self tableView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (NSMutableArray *)dataArray
{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)receiveDatas:(NSArray *)datas
{
    [self.dataArray addObjectsFromArray:datas];
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
                
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"CommonShopLeftSelectTypeView";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        UIView * selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        selectView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = selectView;
    }
    ShopLeftSelectTypeViewModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopLeftSelectTypeViewModel * model = self.dataArray[indexPath.row];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = WifeButlerCommonRedColor;
    if ([self.selectDelegate respondsToSelector:@selector(CommonShopLeftSelectTypeView:didSelect:)]) {
        [self.selectDelegate CommonShopLeftSelectTypeView:self didSelect:model];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}


@end
