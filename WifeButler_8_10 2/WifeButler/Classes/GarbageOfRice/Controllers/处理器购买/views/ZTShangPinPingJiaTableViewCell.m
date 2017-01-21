//
//  ZTShangPinPingJiaTableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTShangPinPingJiaTableViewCell.h"

@implementation ZTShangPinPingJiaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius =  self.iconImageView.frame.size.width / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
