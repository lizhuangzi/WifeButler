//
//  ZJProcessorDetailTableCell2.m
//  WifeButler
//
//  Created by .... on 16/5/19.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJProcessorDetailTableCell2.h"
#import "ZJProcessorCollectionViewCell.h"

@implementation ZJProcessorDetailTableCell2

#define CellHeight 30
#define CellWidth  (iphoneWidth-24)/4

- (void)awakeFromNib {
    // Initialization code
}

-(void)setCollectionView
{
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.frame = CGRectMake(0, 0, iphoneWidth, CellHeight+1);
    [self.collectionView reloadData];
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumInteritemSpacing=0;
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).minimumLineSpacing=0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.labelAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJProcessorCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ZJProcessorCollectionViewCell" forIndexPath:indexPath];
    cell.colorLabel.text=[self.labelAry objectAtIndex:indexPath.row];
    
    if ([_selectStr isEqualToString:[self.labelAry objectAtIndex:indexPath.row]]) {
        
        cell.colorLabel.layer.borderColor = [UIColor colorWithRed:54.0/255 green:179.0/255 blue:155.0/255 alpha:1].CGColor;
        cell.colorLabel.layer.borderWidth = 1;
        cell.colorLabel.layer.masksToBounds = YES;
        cell.colorLabel.textColor=[UIColor colorWithRed:54.0/255 green:179.0/255 blue:155.0/255 alpha:1];
    }
    else
    {
        cell.colorLabel.layer.borderColor = [UIColor grayColor].CGColor;
        cell.colorLabel.layer.borderWidth = 1;
        cell.colorLabel.layer.masksToBounds = YES;
        cell.colorLabel.textColor=[UIColor grayColor];
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellWidth, CellHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectStr = [self.labelAry objectAtIndex:indexPath.row];
    
    // 回调
    if (self.colorBlack) {
        
        self.colorBlack(_selectStr);
    }
    
    [collectionView reloadData];
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSMutableArray*)labelAry
{
    if (!_labelAry) {
        
        _labelAry = [NSMutableArray arrayWithObjects:@"红色",@"绿色",@"橙色",@"黄色",@"青色",@"蓝色",@"紫色", nil];
    }
    
    return _labelAry;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
