//
//  GoodsDetailRemarFooter.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "GoodsDetailRemarFooter.h"
#import "masonry.h"

@interface GoodsDetailRemarFooter ()

@property (nonatomic,weak) UIButton * button;

@end

@implementation GoodsDetailRemarFooter

+ (instancetype)footerView
{
    return [[GoodsDetailRemarFooter alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看全部评价" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:WifeButlerCommonRedColor forState:UIControlStateNormal];
        [button setTitle:@"该商品暂无评价" forState:UIControlStateDisabled];
        [button setTitleColor:WifeButlerGaryTextColor2 forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(morepingjia) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"没有评价了" forState:UIControlStateSelected];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        self.button = button;
    }
    return self;
}

- (void)setShowType:(GoodsDetailRemarFooterShowType)showType
{
    _showType = showType;
    if (_showType == GoodsDetailRemarFooterShowTypeFindMoreReview) {
        self.button.enabled = YES;
        self.button.selected = NO;
         self.button.hidden = NO;
        self.backgroundColor = [UIColor whiteColor];
    }else if(_showType == GoodsDetailRemarFooterShowTypeNoReview){
        self.button.enabled = NO;
         self.button.selected = NO;
         self.button.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.button.enabled = NO;
        self.button.selected = YES;
        self.button.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)morepingjia
{
    if (self.seekMoreBlock) {
        self.seekMoreBlock();
    }
}
@end
