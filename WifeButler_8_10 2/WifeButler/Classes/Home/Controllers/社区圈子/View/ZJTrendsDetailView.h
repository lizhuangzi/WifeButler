//
//  ZJTrendsDetailView.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJDetailViewFrameModel.h"
#import "ZJTrendsDetailHeaderView.h"
#import "ZJTrendsFunctionView.h"

@class ZJTrendsDetailView;

@protocol ZJTrendsDetailViewDelegate <NSObject>

-(void)trendsDetailView:(ZJTrendsDetailView *)view functionViewClicked:(UIView *)functionView;

@end


@interface ZJTrendsDetailView : UIView
@property (nonatomic, strong) ZJDetailViewFrameModel *frameModel;

@property (nonatomic, weak) ZJTrendsDetailHeaderView *headerView;
@property (nonatomic, weak) UILabel *content;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) ZJTrendsFunctionView *functionView;
@property (nonatomic, weak) UIView *separateLine;

@property (nonatomic, weak) UIButton *commendNum;

@property (nonatomic, weak) id<ZJTrendsDetailViewDelegate> delegate;


@property (nonatomic, strong) NSArray * dataSourceTemp;

@property (nonatomic, copy) void (^PhotoBlack)(ZJTrendsDetailView *cell, NSIndexPath *indexPath);

@end
