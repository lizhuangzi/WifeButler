//
//  ZJGoodsDetailCell4.m
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJGoodsDetailCell4.h"

@implementation ZJGoodsDetailCell4

- (void)awakeFromNib {
    // Initialization code
    
    self.imgView.layer.masksToBounds = YES;
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
