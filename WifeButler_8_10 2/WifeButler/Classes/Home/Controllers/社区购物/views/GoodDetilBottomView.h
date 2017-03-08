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


@interface GoodDetilBottomView : UIView

@property (nonatomic,assign) id<GoodDetilBottomViewprotocol> delegate;

@end
