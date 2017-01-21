//
//  ZTGouWuCheTableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTGouWuCheTableViewCell.h"

@implementation ZTGouWuCheTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)addClick:(id)sender {
    
    if (self.addBlack) {
        
        self.addBlack();
    }
}


- (IBAction)jianClick:(id)sender {
    
    if (self.jianBlack) {
        
        self.jianBlack();
    }
    
}


- (IBAction)deleteClick:(id)sender {
    
    if (self.deleteBlack) {
        
        self.deleteBlack();
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
