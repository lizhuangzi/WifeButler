//
//  ZJTrendsCellFrameModel.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJTrendsListModel.h"
@interface ZJTrendsCellFrameModel : NSObject

@property (nonatomic, strong) ZJTrendsListModel *model;

@property (nonatomic, assign, readonly) CGRect headerViewF;
@property (nonatomic, assign, readonly) CGRect contentF;
@property (nonatomic, assign, readonly) CGRect collectionViewF;
@property (nonatomic, assign, readonly) CGRect functionViewF;
@property (nonatomic, assign, readonly) CGRect commendViewF;
@property (nonatomic, assign, readonly) CGRect commentViewF;

@property (nonatomic, assign, readonly) CGFloat cellH;
@end
