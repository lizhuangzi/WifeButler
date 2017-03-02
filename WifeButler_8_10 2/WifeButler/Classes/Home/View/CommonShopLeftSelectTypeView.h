//
//  CommonShopLeftSelectTypeView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/2.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**selectModel*/
@interface ShopLeftSelectTypeViewModel : NSObject

@property (nonatomic,copy)NSString * name;

@property (nonatomic,copy)NSString * Id;

@property (nonatomic,copy)NSString * serve_id;

+ (instancetype)ShopLeftSelectTypeViewModelWithDictionary:(NSDictionary *)dict;

@end

@class CommonShopLeftSelectTypeView;

@protocol CommonShopLeftSelectTypeViewSelectDelegate <NSObject>

- (void)CommonShopLeftSelectTypeView:(CommonShopLeftSelectTypeView *)view didSelect:(ShopLeftSelectTypeViewModel *)model;

@end

/**左侧选择tableView*/
@interface CommonShopLeftSelectTypeView : UITableView

+ (instancetype)AddIntoFatherView:(UIView *)fatherView;

- (void)receiveDatas:(NSArray *)datas;

- (void)defaultSelect;

@property (nonatomic,assign) id<CommonShopLeftSelectTypeViewSelectDelegate> selectDelegate;

@end


