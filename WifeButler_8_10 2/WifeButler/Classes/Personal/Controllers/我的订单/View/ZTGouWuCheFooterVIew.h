//
//  ZTGouWuCheFooterVIew.h
//  WifeButler
//
//  Created by ZT on 16/5/28.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTGouWuCheFooterVIew : UIView



@property (weak, nonatomic) IBOutlet UILabel *shiFuKuanLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *goShopBtn;


@property (nonatomic, copy) void (^deleteBlack)(void);

@property (nonatomic, copy) void(^goShopBlack)(void);

@end
