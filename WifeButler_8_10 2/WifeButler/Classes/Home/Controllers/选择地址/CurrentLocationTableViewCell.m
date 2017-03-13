//
//  CurrentLocationTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/13.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "CurrentLocationTableViewCell.h"

@interface CurrentLocationTableViewCell ()

@end

@implementation CurrentLocationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.locationLabel.text = @"正在定位当前定位...";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
