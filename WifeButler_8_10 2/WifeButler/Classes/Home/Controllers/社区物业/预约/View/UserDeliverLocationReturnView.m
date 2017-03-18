//
//  UserDeliverLocationReturnView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/17.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "UserDeliverLocationReturnView.h"
#import "Masonry.h"

@interface UserDeliverLocationReturnView ()


@end

@implementation UserDeliverLocationReturnView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIButton * backCon = [UIButton buttonWithType:UIButtonTypeCustom];
    [backCon setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:backCon];
    [backCon addTarget:self action:@selector(didClick) forControlEvents:UIControlEventTouchUpInside];
    [backCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)didClick
{
    if (self.returnBlock) {
        self.returnBlock();
    }
}

@end
