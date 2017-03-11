//
//  CardPocketTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/11.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CardPocketTableViewCell.h"

@interface CardPocketTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cardBankName;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UIView *colorfulBackGroundView;

@end

@implementation CardPocketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorfulBackGroundView.layer.cornerRadius = 7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
