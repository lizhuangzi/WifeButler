//
//  WifeButlerNoDataView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/16.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerNoDataView.h"
#import "Masonry.h"
#import "UIColor+EasyExistion.h"

@interface WifeButlerNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *nodataImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodataBtnTopCon;

@property (weak, nonatomic) IBOutlet UIButton *nodataBtn;
@end

@implementation WifeButlerNoDataView

+ (instancetype)noDataView
{
    return [[NSBundle mainBundle]loadNibNamed:@"WifeButlerNoDataView" owner:nil options:nil].lastObject;
}

- (IBAction)reloadClick:(id)sender {
    
    [self removeFromSuperview];
    !self.reloadBlock?:self.reloadBlock();
}

- (void)setType:(WifeButlerNoDataViewNoDataType)type
{
    switch (type) {
            
        case WifeButlerNoDataViewNoDataTypeNoOrder:{
            
            UILabel * label = [[UILabel alloc]init];
            [self addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"您还没有订单哦赶快去购物吧.";
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.nodataImage.mas_bottom).offset(10);
                make.centerX.mas_equalTo(self.mas_centerX);
                make.height.mas_equalTo(17);
                make.width.mas_equalTo(200);
            }];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = WifeButlerGaryTextColor2;
            
            self.nodataBtnTopCon.constant = 40;
            [self.nodataBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
            [self.nodataBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nodataBtn setBackgroundColor:[UIColor setR:127 G:200 B:252]];
            self.nodataBtn.layer.cornerRadius = 3;
            self.nodataBtn.clipsToBounds = YES;
        }
            break;
        case WifeButlerNoDataViewNoDataTypeExchange:{
            [self.nodataBtn setTitle:@"附近暂无商家对接." forState:UIControlStateDisabled];
            [self.nodataBtn setTitleColor:WifeButlerGaryTextColor2 forState:UIControlStateDisabled];
            self.nodataBtn.enabled = NO;
        }
            break;
        case WifeButlerNoDataViewNoDataTypeshoppingCart:
        {
            [self.nodataBtn setTitle:@"购物车内暂无商品" forState:UIControlStateDisabled];
            [self.nodataBtn setTitleColor:WifeButlerGaryTextColor2 forState:UIControlStateDisabled];
            self.nodataBtn.enabled = NO;
        }
            break;
        default:
            break;
    }
}
@end
