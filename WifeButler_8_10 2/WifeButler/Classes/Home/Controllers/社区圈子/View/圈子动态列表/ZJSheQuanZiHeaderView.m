//
//  ZJSheQuanZiHeaderView.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJSheQuanZiHeaderView.h"

@implementation ZJSheQuanZiHeaderView

-(void)awakeFromNib{
    
    self.icon.layer.cornerRadius = self.icon.height / 2;
    self.icon.layer.masksToBounds = YES;
    
    self.icon.clipsToBounds = YES;
    self.backGroundIngView.clipsToBounds = YES;
    
    self.sendTrendsLbel.layer.borderWidth = 1;
    self.sendTrendsLbel.layer.borderColor = [UIColor colorWithWhite:0.651 alpha:1.000].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendTrendsLbel_clicked:)];
    
    [self.sendTrendsLbel addGestureRecognizer:tap];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.size = CGSizeMake(iphoneWidth, iphoneWidth *2/3 + 60);
}

-(void)sendTrendsLbel_clicked:(UITapGestureRecognizer *)sender{
    
    if ([self.delegate respondsToSelector:@selector(sheQuanZiHeaderView:sendTrendsViewClicked:)]) {
        [self.delegate sheQuanZiHeaderView:self sendTrendsViewClicked:(UILabel *)sender.view];
    }
    
    
}




@end
