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

@interface GoodDetilBottomView ()

@property (nonatomic,assign) GoodDetilBottomViewShowType type;
@property (nonatomic,assign) id<GoodDetilBottomViewprotocol> delegate;
@end

@implementation GoodDetilBottomView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (GoodDetilBottomView *(^)())beginCreate
{
    return ^{
        
    UIButton * joinShoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinShoppingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (self.type == GoodDetilBottomViewShowTypeShopDetail) {
             [joinShoppingBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        }else{
             [joinShoppingBtn setTitle:@"马上预约" forState:UIControlStateNormal];
        }
   
    [joinShoppingBtn addTarget:self action:@selector(joinShop) forControlEvents:UIControlEventTouchUpInside];
    [joinShoppingBtn setBackgroundColor:WifeButlerCommonRedColor];
    [self addSubview:joinShoppingBtn];
    [joinShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        if ([self type] == GoodDetilBottomViewShowTypeShopDetail) {
            make.width.mas_equalTo(150);
        }else{
            make.width.mas_equalTo(200);
        }
    }];
    
    [self layoutIfNeeded];
    
    
    NSUInteger count = 0;
    if (self.type == GoodDetilBottomViewShowTypeShopDetail) {
        count = 3;
    }else{
        count = 2;
    }
    
    NSArray * array = @[@"客服",@"店铺",@"购物车"];
    NSArray * imageArray = @[@"kefu",@"dian_pu",@"caar"];
    CGFloat btnW = 50;
    CGFloat btnH = 55;
    CGFloat margin = ((iphoneWidth - joinShoppingBtn.width)-count*btnW)/(count + 1);
    for (int i = 0; i<count; i++) {
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
        
        return self;
    };
}

- (GoodDetilBottomView *(^)(GoodDetilBottomViewShowType type))setType
{
    return ^(GoodDetilBottomViewShowType type){
        
        self.type = type;
        return self;
    };
}

- (GoodDetilBottomView *(^)(id<GoodDetilBottomViewprotocol> delegate))setDelegate
{
    return ^(id<GoodDetilBottomViewprotocol> delegate){
      
        self.delegate = delegate;
        return self;
    };
}

+ (GoodDetilBottomView *(^)())n_e_w
{
    return ^{
        return self.n_e_w_withTypeAndDelegate(0,nil);
    };
}

+ (GoodDetilBottomView *(^)(GoodDetilBottomViewShowType type, id<GoodDetilBottomViewprotocol> delegate))n_e_w_withTypeAndDelegate
{
    return ^(GoodDetilBottomViewShowType type, id<GoodDetilBottomViewprotocol> delegate){
        GoodDetilBottomView * view = [[GoodDetilBottomView alloc]init];
        view.type = type;
        view.delegate = delegate;
        return self;
    };
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
