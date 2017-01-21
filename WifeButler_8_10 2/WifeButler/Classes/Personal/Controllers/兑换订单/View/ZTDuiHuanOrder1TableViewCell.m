//
//  ZTDuiHuanOrder1TableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/8/5.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDuiHuanOrder1TableViewCell.h"

@implementation ZTDuiHuanOrder1TableViewCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.queRenBtn.layer.cornerRadius = 5;
    self.queRenBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.queRenBtn.layer.borderWidth = 1;
    
}

- (IBAction)queRenClick:(id)sender {
    
    if (self.queRenBlock) {
        
        self.queRenBlock();
    }
    
}

- (void)setDataSourceModel:(ZTDuiHuanOederModel *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.file]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    self.titleLab.text = model.title;
    self.numLab.text = [NSString stringWithFormat:@"%@g", model.weight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
