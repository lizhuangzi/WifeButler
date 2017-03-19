//
//  GoodsDetailRemarFooter.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GoodsDetailRemarFooterShowType) {
    GoodsDetailRemarFooterShowTypeFindMoreReview,
    GoodsDetailRemarFooterShowTypeNoReview,
    GoodsDetailRemarFooterShowTypeNothing,
};
/**这是评论section底部*/
@interface GoodsDetailRemarFooter : UIView

+ (instancetype)footerView;

@property (nonatomic,assign) GoodsDetailRemarFooterShowType showType;

/**查看更多*/
@property (nonatomic,copy)void(^seekMoreBlock)();

@end
