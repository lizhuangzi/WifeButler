//
//  ZTTime2CollectionViewCell.h
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTTime2CollectionViewCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger  selectRow;

- (void)setCollectionViewTemp;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger  isTagTemp;

@property (nonatomic, copy) void (^dianJiShiJianBlack)(NSInteger i);

@property (nonatomic, copy) void (^rightBlack)(void);

@property (nonatomic, copy) void (^leftBlack)(void);


@end
