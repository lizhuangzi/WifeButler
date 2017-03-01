//
//  CommonEmojiPageCell.m
//  CjSummary
//
//  Created by paopao on 16/8/17.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "CommonEmojiPageCell.h"
#import "CommonEmojiCell.h"

static NSString * const identifier = @"CommonEmojiCell";

static NSInteger adaptiveHeight(CGFloat i6_h,CGFloat i6p_h,CGFloat h) {
    NSInteger height;
    static NSInteger screenHeight;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    });
    if (screenHeight == 667) {
        height = i6_h;
    }else if (screenHeight == 736) {
        height = i6p_h;
    }else {
        height = h;
    }
    return height;
};

#define AdaptiveHeight(i6,i6p,i)  adaptiveHeight(i6,i6p,i)
// 每页多少个
#define emojiCountOfLine   AdaptiveHeight(8,9,7)
// 距离顶部距离
#define collectionTop AdaptiveHeight(27,27,27)
// 距离底部距离
#define collectionBottom AdaptiveHeight(38,38,38)
// cell 高度
#define cellHig AdaptiveHeight(187,187,177)

static CGFloat emojiItemWid = 30;

static CGFloat leftSpace = 20;

@interface CommonEmojiPageCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation CommonEmojiPageCell

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = (iphoneWidth - leftSpace * 2 - emojiCountOfLine * emojiItemWid) / (emojiCountOfLine - 1);
        flowLayout.itemSize = CGSizeMake(emojiItemWid, emojiItemWid);
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.minimumLineSpacing = (cellHig - collectionTop - collectionBottom - emojiItemWid * 3 ) / 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(collectionTop, leftSpace, collectionBottom, leftSpace);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"CommonEmojiCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emotions.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommonEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row < _emotions.count) {
        [cell.EmojiButton setTitle:[_emotions objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [cell.EmojiButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else{
        [cell.EmojiButton setTitle:@"" forState:UIControlStateNormal];
        [cell.EmojiButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _emotions.count) {
        // 点击最后一个 删除
        if (self.didDelegateClick) {
            self.didDelegateClick();
        }
    }else{
        if (self.didEmojiClick) {
            self.didEmojiClick([_emotions objectAtIndex:indexPath.row]);
        }
    }
}

@end
