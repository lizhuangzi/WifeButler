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
    [joinShoppingBtn addTarget:self action:@selector(joinShop) forControlEvents:UIControlEventTouchUpInside];
    [joinShoppingBtn setBackgroundColor:WifeButlerCommonRedColor];
    [self addSubview:joinShoppingBtn];
    [joinShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(150);
    }];
    
    [self layoutIfNeeded];
    
    NSArray * array = @[@"客服",@"店铺",@"购物车"];
    NSArray * imageArray = @[@"kefu",@"dian_pu",@"caar"];
    CGFloat btnW = 50;
    CGFloat btnH = 55;
    CGFloat margin = ((iphoneWidth - joinShoppingBtn.width)-3*btnW)/4;
    for (int i = 0; i<3; i++) {
        titleBottomButton * button = [[titleBottomButton alloc]initWithImageWidth:25 andHeight:25];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [button setTitle: array[i] forState:UIControlStateNormal];
        [button setTitleColor:WifeButlerGaryTextColor1 forState:UIControlStateNormal];
        button.frame = CGRectMake(margin + (btnW + margin)*i, 5, btnW, btnH);
        [self addSubview:button];
        
        [button addTarget:self action:@selector(ohtersClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)joinShop
{
    if ([self.delegate respondsToSelector:@selector(GoodDetilBottomViewDidClickShopping:)]) {
        [self.delegate GoodDetilBottomViewDidClickShopping:self];
    }
}

- (void)ohtersClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(GoodDetilBottomViewDidClickOthers:andIndex:)]) {
        [self.delegate GoodDetilBottomViewDidClickOthers:self andIndex:btn.tag];
    }
}

@end
