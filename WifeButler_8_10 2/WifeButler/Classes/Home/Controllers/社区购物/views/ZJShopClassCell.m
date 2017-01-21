//
//  ZJShopClassCell.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJShopClassCell.h"

@implementation ZJShopClassCell

- (IBAction)addBusClick:(id)sender {
    
    [self.delegate addBusWithPath:self.path];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.moneyLabel.adjustsFontSizeToFitWidth = YES;
}



@end
