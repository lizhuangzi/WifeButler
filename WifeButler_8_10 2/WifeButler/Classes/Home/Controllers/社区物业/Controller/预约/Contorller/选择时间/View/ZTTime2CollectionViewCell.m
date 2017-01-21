//
//  ZTTime2CollectionViewCell.m
//  WifeButler
//
//  Created by ZT on 16/6/12.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTTime2CollectionViewCell.h"
#import "ZTTime3CollectionViewCell.h"
#import "ZTTimeTopModel.h"

@implementation ZTTime2CollectionViewCell

- (void)setCollectionViewTemp
{
    self.isTagTemp = 0;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.collectionView.scrollEnabled = YES;
    
//    UIScrollView
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZTTime3CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTTime3CollectionViewCell" forIndexPath:indexPath];
    
    cell.xinQiLab.text = self.dataSource[indexPath.row][@"week"];
    cell.riQiLab.text = self.dataSource[indexPath.row][@"date"];
    
    if (_selectRow == indexPath.row) {
        
        cell.xinQiLab.textColor = [UIColor redColor];
        cell.riQiLab.textColor = [UIColor redColor];
    }
    else
    {
        cell.xinQiLab.textColor = [UIColor grayColor];
        cell.riQiLab.textColor = [UIColor grayColor];
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
    
    return CGSizeMake((iphoneWidth - 64) / 3.0, 48);
}

-(void)setSelectRow:(NSInteger)selectRow
{
    _selectRow = selectRow;
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.isTagTemp = indexPath.row;
    
    if (self.dianJiShiJianBlack) {
        
        self.dianJiShiJianBlack(indexPath.row);
    }
    
    [self.collectionView reloadData];
}


- (IBAction)leftClick:(id)sender {
    
    if (self.leftBlack) {
        
        self.leftBlack();
    }
}

- (IBAction)rightClick:(id)sender {
    
    if (self.rightBlack) {
        
        self.rightBlack();
    }
}


@end
