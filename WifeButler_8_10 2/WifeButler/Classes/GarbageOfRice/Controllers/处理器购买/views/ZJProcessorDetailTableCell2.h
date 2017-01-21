//
//  ZJProcessorDetailTableCell2.h
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJProcessorDetailTableCell2 : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray*labelAry;
@property (nonatomic,copy)NSString*selectStr;

/**
 *  颜色black
 */
@property (nonatomic, copy) void(^colorBlack)(NSString *str);

-(void)setCollectionView;


@end
