//
//  JieSuanTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "JieSuanTableViewCell.h"
#import "ZTJieShuan2Model.h"

@interface JieSuanTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation JieSuanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(ZTJieShuan2Model *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:_model.imageURL placeholderImage:PlaceHolderImage_Other];
    self.shopName.text = _model.title;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",_model.money];
    self.countLabel.text = [NSString stringWithFormat:@"X%@",_model.num];
}

@end
