//
//  GoodDetilBottomView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "GoodDetilBottomView.h"
#import "Masonry.h"
#import "titleBottomButton.h"

@implementation GoodDetilBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIButton * joinShoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinShoppingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [joinShoppingBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [joinShoppingBtn setBackgroundColor:WifeButlerCommonRedColor];
    [self addSubview:joinShoppingBtn];
    [joinShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(150);
    }];
    
    [self layoutIfNeeded];
    CGFloat btnW = 55;
    CGFloat btnH = 55;
    CGFloat margin = ((iphoneWidth - joinShoppingBtn.x)-3*btnW)/4;
    for (int i = 0; i<3; i++) {
        titleBottomButton * button = [[titleBottomButton alloc]init];
        [button setImage:[UIImage imageNamed:@"ZTIphoneRed"] forState:UIControlStateNormal];
        [button setTitle: @"客服" forState:UIControlStateNormal];
        [button setTitleColor:WifeButlerGaryTextColor1 forState:UIControlStateNormal];
        button.frame = CGRectMake(margin + (btnW + margin)*i, 5, btnW, btnH);
        [self addSubview:button];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
