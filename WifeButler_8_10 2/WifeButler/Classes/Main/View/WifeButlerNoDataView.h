//
//  WifeButlerNoDataView.h
//  WifeButler
//
//  Created by 李庄子 on 2017/3/16.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WifeButlerNoDataViewNoDataType) {
    /**无订单*/
    WifeButlerNoDataViewNoDataTypeNoOrder = 0,
    /**垃圾换大米界面无商家*/
    WifeButlerNoDataViewNoDataTypeExchange = 1,
    /**购物车无物品*/
    WifeButlerNoDataViewNoDataTypeshoppingCart = 2,
};

#define WifeButlerNoDataViewShow(view,T,reloblock) \
                                                WifeButlerNoDataView * nodataview =  [view viewWithTag:1024];\
                                                if(!nodataview)\
                                                    nodataview = [WifeButlerNoDataView noDataView];\
                                                nodataview.tag = 1024;\
                                                nodataview.frame = view.bounds;\
                                                [view addSubview:nodataview];\
                                                nodataview.type = T;\
                                                nodataview.reloadBlock = reloblock;

#define WifeButlerNoDataViewRemoveFrom(view) WifeButlerNoDataView * nodataview =  [view viewWithTag:1024];\
                                                [nodataview removeFromSuperview];

@interface WifeButlerNoDataView : UIView

+ (instancetype)noDataView;

@property (nonatomic,copy)void(^reloadBlock)();

@property (nonatomic,assign) WifeButlerNoDataViewNoDataType type;

@end
