//
//  ZTOneSheQuWuYeCollectionViewCell.h
//  WifeButler
//
//  Created by ZT on 16/6/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTOneSheQuWuYeCollectionViewCell : UICollectionViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger  selectRow;

- (void)setCollectionViewTemp;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, copy) void (^dianJiShiJianBlack)(NSInteger i);





@end
