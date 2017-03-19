//
//  ZTDuiHuanOrder2TableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/8/5.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTDuiHuanOrder2TableViewCell.h"
#import "NSDate+NowTime.h"

@implementation ZTDuiHuanOrder2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.delegateBtn.layer.cornerRadius = 5;
    self.delegateBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.delegateBtn.layer.borderWidth = 1;
}

- (IBAction)deleteClick:(id)sender {
    
    if (self.deleteBlock) {
        
        self.deleteBlock();
    }
}


- (void)setDataSourceModel:(ZTDuiHuanOederModel *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, model.file]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    self.titleLab.text = model.title;
    self.numLab.text = [NSString stringWithFormat:@"%@g", model.weight];
    self.timeLabel.text = [NSDate getdateStrWithCurrentTime:model.time] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
