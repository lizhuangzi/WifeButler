//
//  ZTQuanZiZTableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTQuanZiZTableViewCell.h"
#import "ZTSheQuQuanZiIconCollectionViewCell.h"


@implementation ZTQuanZiZTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.pingLuLab.layer.borderWidth = 1;
    self.pingLuLab.layer.borderColor = [UIColor colorWithWhite:0.805 alpha:1.000].CGColor;
    
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.frame.size.width / 2.0;
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconBtn.frame.size.width / 2.0;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_dataSource.count > 9) {
        
        return 9;
        
    }else{
        
        return _dataSource.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"5555");
    
    ZTSheQuQuanZiIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZTSheQuQuanZiIconCollectionViewCell" forIndexPath:indexPath];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, _dataSource[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    return cell;
    
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((iphoneWidth - 20) / 3.0, (iphoneWidth - 20) / 3.0);
}

-(void)setSelectRow:(NSInteger)selectRow
{
    _selectRow = selectRow;
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Add photos
    if (self.PhotoBlack) {
        
        self.PhotoBlack(self, indexPath);
    }
 
}


- (IBAction)huiFuClick:(id)sender {
    
    if (self.HuiFuBlack) {
        
        self.HuiFuBlack();
    }
    
}

- (IBAction)dianZhanClick:(id)sender {
    
    if (self.DianZhanBlack) {
        
        self.DianZhanBlack();
    }
}


- (IBAction)iconClick:(id)sender {
    
    if (self.dianJiIconBlack) {
        
        self.dianJiIconBlack();
    }
    
}



@end
