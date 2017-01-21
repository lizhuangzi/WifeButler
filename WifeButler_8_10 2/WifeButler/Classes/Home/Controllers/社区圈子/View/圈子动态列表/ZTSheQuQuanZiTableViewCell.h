//
//  ZTSheQuQuanZiTableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/6/11.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJTrendsCellFrameModel.h"
#import "ZJTrendsHeaderView.h"
#import "ZJTrendsFunctionView.h"

@class ZTSheQuQuanZiTableViewCell;
@protocol ZTSheQuQuanZiTableViewCellDelegate <NSObject>

-(void)sheQuQuanZiTableViewCell:(ZTSheQuQuanZiTableViewCell *)cell functionViewClicked:(UIView *)view;

@end


@interface ZTSheQuQuanZiTableViewCell : UITableViewCell


@property (nonatomic, strong) ZJTrendsCellFrameModel *frameMode;

@property (nonatomic, weak) ZJTrendsHeaderView *headerView;

@property (weak, nonatomic) UILabel *desLa;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (nonatomic, weak) ZJTrendsFunctionView *functionView;

@property (weak, nonatomic) UIButton *dianZanNum;

@property (weak, nonatomic) UILabel *pingLuLab;

@property (nonatomic, weak) id<ZTSheQuQuanZiTableViewCellDelegate> delegate;

@property (nonatomic, copy) void (^PhotoBlack)(ZTSheQuQuanZiTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic, strong) NSArray * dataSourceTemp;



@end
