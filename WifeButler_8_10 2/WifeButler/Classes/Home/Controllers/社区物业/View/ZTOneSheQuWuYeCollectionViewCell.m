//
//  ZTOneSheQuWuYeCollectionViewCell.m
//  WifeButler
//
//  Created by ZT on 16/6/4.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTOneSheQuWuYeCollectionViewCell.h"
#import "ZTZiOneWuYeCollectionViewCell.h"
#import "ZTWuYeShangPinModel.h"

@implementation ZTOneSheQuWuYeCollectionViewCell


- (void)setCollectionViewTemp
{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTZiOneWuYeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTZiOneWuYeCollectionViewCell" forIndexPath:indexPath];
    
    ZTWuYeShangPinModel *model = _dataSource[indexPath.row];
    
    cell.titleLab.text = model.name;
    
    if (_selectRow == indexPath.row) {
    
        cell.lineView.hidden = NO;
        cell.titleLab.textColor = [UIColor redColor];
    }
    else
    {
        cell.lineView.hidden = YES;
        cell.titleLab.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(iphoneWidth / 6.0, 35);
}

-(void)setSelectRow:(NSInteger)selectRow
{
    _selectRow = selectRow;
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (self.dianJiShiJianBlack) {
        
        self.dianJiShiJianBlack(indexPath.row);
    }
}


@end
