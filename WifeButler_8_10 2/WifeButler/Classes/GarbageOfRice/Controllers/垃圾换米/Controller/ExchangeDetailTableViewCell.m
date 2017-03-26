//
//  ExchangeDetailTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/12.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "ExchangeDetailTableViewCell.h"
#import "UIColor+EasyExistion.h"


@implementation ExchangeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderSend.backgroundColor = [UIColor setR:124 G:175 B:242];
    self.orderSend.layer.cornerRadius = 3;
    self.orderSend.clipsToBounds = YES;
    self.orderSend.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
