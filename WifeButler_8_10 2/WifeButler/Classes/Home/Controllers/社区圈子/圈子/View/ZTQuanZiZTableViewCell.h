//
//  ZTQuanZiZTableViewCell.h
//  WifeButler
//
//  Created by ZT on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>

@interface ZTQuanZiZTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger  selectRow;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * dataSource;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *desLa;

@property (weak, nonatomic) IBOutlet UIButton *dianZhanBtn;

@property (weak, nonatomic) IBOutlet UILabel *dianZhanNumLab;

@property (weak, nonatomic) IBOutlet UILabel *pingLuLab;




@property (nonatomic, copy) void (^HuiFuBlack)(void);

@property (nonatomic, copy) void (^DianZhanBlack)(void);

@property (nonatomic, copy) void (^PhotoBlack)(ZTQuanZiZTableViewCell *cell, NSIndexPath *indexPath);

@property (nonatomic, copy) void (^dianJiIconBlack)(void);



@end
