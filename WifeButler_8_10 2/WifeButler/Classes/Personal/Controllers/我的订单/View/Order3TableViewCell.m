//
//  Order3TableViewCell.m
//  DingPurchasingSuSong
//
//  Created by zjtdmac2 on 16/3/29.
//  Copyright © 2016年 zjtdmac2. All rights reserved.
//

#import "Order3TableViewCell.h"

@implementation Order3TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.pingJiaBtn.layer.borderWidth = 1;
    self.pingJiaBtn.layer.cornerRadius = 5;
    self.pingJiaBtn.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pingJiaClick:(id)sender {
    
    if (self.pingJiaBlack) {
        
        self.pingJiaBlack();
    }
    
}



@end
