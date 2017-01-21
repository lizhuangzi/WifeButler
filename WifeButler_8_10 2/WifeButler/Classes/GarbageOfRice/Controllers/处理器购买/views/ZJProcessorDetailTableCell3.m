//
//  ZJProcessorDetailTableCell3.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJProcessorDetailTableCell3.h"

@implementation ZJProcessorDetailTableCell3

- (void)awakeFromNib {
    // Initialization code
    
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.borderColor = [UIColor colorWithWhite:0.757 alpha:1.000].CGColor;
    self.addBtn.layer.borderWidth = 0.75;
    
    self.deletebtn.layer.masksToBounds = YES;
    self.deletebtn.layer.borderColor = [UIColor colorWithWhite:0.757 alpha:1.000].CGColor;
    self.deletebtn.layer.borderWidth = 0.75;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)delBtnClick:(id)sender {
    
    if (self.goodsNum>1) {
        self.goodsNum--;
        self.numTextFiled.text=[NSString stringWithFormat:@"%d",self.goodsNum];
    }
    [self.delegate changeGoodsNumWithCurrentNum:self.goodsNum];
}

- (IBAction)addBtnClick:(id)sender {
    
    self.goodsNum++;
    self.numTextFiled.text =[NSString stringWithFormat:@"%d",self.goodsNum];
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
