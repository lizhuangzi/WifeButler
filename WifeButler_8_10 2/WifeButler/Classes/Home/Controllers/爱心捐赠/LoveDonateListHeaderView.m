//
//  LoveDonateListHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/14.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateListHeaderView.h"
#import "UIColor+EasyExistion.h"
@interface LoveDonateListHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *loveCountLabel;

@end

@implementation LoveDonateListHeaderView

+ (instancetype)headerView
{
    return [[NSBundle mainBundle]loadNibNamed:@"LoveDonateListHeaderView" owner:nil options:nil].lastObject;
}

- (void)setLoveCount:(NSString *)loveCount
{
    _loveCount = loveCount;
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:@"已有"];
    
    //243 244 207
    NSAttributedString * countStr = [[NSAttributedString alloc]initWithString:_loveCount attributes:@{NSForegroundColorAttributeName:[UIColor setR:243 G:244 B:207],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    [attStr appendAttributedString:countStr];
    
    NSAttributedString * str2 = [[NSAttributedString alloc]initWithString:@"份爱心"];
    [attStr appendAttributedString:str2];
    
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2+_loveCount.length, str2.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(2+_loveCount.length, str2.length)];
    
    self.loveCountLabel.attributedText = attStr;
}

@end
