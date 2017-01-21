//
//  ZJGoodsDetailCell2.m
//  WifeButler
//
//  Created by .... on 16/5/30.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJGoodsDetailCell2.h"

@implementation ZJGoodsDetailCell2

- (void)awakeFromNib {
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.borderColor = [UIColor colorWithWhite:0.757 alpha:1.000].CGColor;
    self.addBtn.layer.borderWidth = 0.75;
    
    self.delBtn.layer.masksToBounds = YES;
    self.delBtn.layer.borderColor = [UIColor colorWithWhite:0.757 alpha:1.000].CGColor;
    self.delBtn.layer.borderWidth = 0.75;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addNumClick:(id)sender {
    
    self.goodsNum++;
    self.numTextFiled.text =[NSString stringWithFormat:@"%d",self.goodsNum];
    [self.delegate changeGoodsNumWithCurrentNum:self.goodsNum];
}

- (IBAction)delNumClick:(id)sender {
    
    if (self.goodsNum>1) {
        self.goodsNum--;
        self.numTextFiled.text=[NSString stringWithFormat:@"%d",self.goodsNum];
    }
    [self.delegate changeGoodsNumWithCurrentNum:self.goodsNum];
}

- (int)goodsNum
{
    if (_goodsNum == 0) {
        
        return _goodsNum = 1;
    }
    
    return _goodsNum;
}

@end
