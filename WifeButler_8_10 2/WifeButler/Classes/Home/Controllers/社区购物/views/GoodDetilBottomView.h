//
//  GoodDetilBottomView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodDetilBottomView;

@protocol GoodDetilBottomViewprotocol <NSObject>

- (void)GoodDetilBottomViewDidClickShopping:(GoodDetilBottomView *)view;
- (void)GoodDetilBottomViewDidClickOthers:(GoodDetilBottomView *)view andIndex:(NSUInteger)index;
@end

typedef NS_ENUM(NSUInteger, GoodDetilBottomViewShowType) {
    GoodDetilBottomViewShowTypeShopDetail,
    GoodDetilBottomViewShowTypeServiceDetail,
};
/**这是详情下方的选择栏*/
@interface GoodDetilBottomView : UIView

+ (GoodDetilBottomView *(^)(GoodDetilBottomViewShowType type,id<GoodDetilBottomViewprotocol> delegate))n_e_w_withTypeAndDelegate;

+ (GoodDetilBottomView *(^)())n_e_w;

- (GoodDetilBottomView *(^)(id<GoodDetilBottomViewprotocol> delegate))setDelegate;

- (GoodDetilBottomView *(^)(GoodDetilBottomViewShowType type))setType;

- (GoodDetilBottomView *(^)())beginCreate;
@end
