//
//  ZTYouHuiJuanViewController.h
//  WifeButler
//
//  Created by ZT on 16/5/26.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTYouHuiJuanModel.h"

@interface ZTYouHuiJuanViewController : UIViewController

/**
 *  是否返回
 */
@property (nonatomic, assign) BOOL  isFanHui;

@property (nonatomic, copy) void(^moneyBlack)(ZTYouHuiJuanModel *model);

@property (nonatomic, copy) void(^dataSorceBlack)(NSMutableArray *dataSorceTemp);

@property (nonatomic, strong) NSMutableArray * dataSourceYouHuiJuan;

@property (nonatomic, copy) NSString *biaoShi;

@property (nonatomic,assign) NSInteger isFrist;
/**
 *  店铺商品金额
 */
@property (nonatomic, copy) NSString * shopMoney;



@end
