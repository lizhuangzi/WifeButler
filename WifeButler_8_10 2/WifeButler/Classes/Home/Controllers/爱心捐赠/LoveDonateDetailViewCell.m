//
//  LoveDonateDetailViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateDetailViewCell.h"

@implementation LoveDonateDetailViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailLabel.preferredMaxLayoutWidth = iphoneWidth - 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
