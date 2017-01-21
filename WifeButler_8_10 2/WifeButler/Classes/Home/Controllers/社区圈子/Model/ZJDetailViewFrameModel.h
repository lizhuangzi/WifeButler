//
//  ZJDetailViewFrameModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJTrendsDetailModel.h"
@interface ZJDetailViewFrameModel : NSObject

@property (nonatomic, strong) ZJTrendsDetailModel *detailModel;
@property (nonatomic, assign, readonly) CGRect headerViewF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect collectionViewF;
@property (nonatomic, assign, readonly) CGRect functionViewF;
@property (nonatomic, assign, readonly) CGRect separateLineF;
@property (nonatomic, assign, readonly) CGRect commendViewF;
@property (nonatomic, assign, readonly) CGFloat viewH;
@end
