//
//  ZTJieSuan11TableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/5/31.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTJieSuan11TableViewCell.h"
#import "ZTShangPingXiangQin11TableViewCell.h"
#import "ZTJieShuan2Model.h"

@implementation ZTJieSuan11TableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (IBAction)youHuiJuanXuanZeClick:(id)sender {
    
    if (self.youHuijuanBlack) {
        
        self.youHuijuanBlack();
    }
    
}

- (void)setTableViewTempWithAry:(NSMutableArray *)Ary
{
    _dataSource=Ary;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZTShangPingXiangQin11TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZTShangPingXiangQin11TableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZTShangPingXiangQin11TableViewCell" owner:self options:nil] firstObject];
    }
    
    ZTJieShuan2Model *model = _dataSource[indexPath.row];
    
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", model.money];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.files] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    cell.titleLab.text = model.title;
    cell.numLab.text = [NSString stringWithFormat:@"X%@", model.num];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
