//
//  ZTLaJiHuanMiTableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/5/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTLaJiHuanMiTableViewCell.h"
#import "ZTLaJiHuanMiModel.h"

@interface ZTLaJiHuanMiTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *exchangeTimesLabel;

@property (weak, nonatomic) IBOutlet UILabel *originalMoneyLab;

@property (weak, nonatomic) IBOutlet UILabel *currentMoneyLab;

@end

@implementation ZTLaJiHuanMiTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.currentMoneyLab.textColor = WifeButlerCommonRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)LaJiHuanMiTableViewCellWithTableView:(UITableView *)tableView{
    
    static NSString * ID = @"ZTLaJiHuanMiTableViewCell";
    
    ZTLaJiHuanMiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ZTLaJiHuanMiTableViewCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(ZTLaJiHuanMiModel *)model
{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImageStr]];
    self.titleLab.text = _model.title;
    
    int num = 0;
    if (model.sales != nil) {
        num = [model.sales intValue];
    }
    self.exchangeTimesLabel.text = [NSString stringWithFormat:@"兑换次数%d次",num];
    self.originalMoneyLab.text = [NSString stringWithFormat:@"¥%@",_model.oldprice];
    
    self.currentMoneyLab.text = [NSString stringWithFormat:@"%@分/%@",_model.scale,_model.danwei];
}

@end
