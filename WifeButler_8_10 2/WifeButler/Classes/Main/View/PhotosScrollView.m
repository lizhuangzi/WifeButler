//
//  PhotosScrollView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/8.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "PhotosScrollView.h"
#import "Masonry.h"
#import "WifeButlerDefine2.h"

@interface PhotosScrollView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView * collectionView;

@property (nonatomic,weak) UIPageControl * pageContorl;
@end

@implementation PhotosScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        collect.delegate = self;
        collect.backgroundColor = WifeButlerTableBackGaryColor;
        collect.dataSource = self;
        collect.showsHorizontalScrollIndicator = NO;
        collect.pagingEnabled = YES;
        [collect registerClass:[PhotosCollectionCell class] forCellWithReuseIdentifier:@"ID"];
        [self addSubview:collect];
        
        [collect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIPageControl * p = [[UIPageControl alloc]init];
        p.hidesForSinglePage = YES;
        p.pageIndicatorTintColor = [UIColor lightGrayColor];
        p.currentPageIndicatorTintColor = WifeButlerCommonRedColor;
        [self addSubview:p];
        self.pageContorl = p;
        [p mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];

    }
    return self;
}

- (void)setImageUrlStrings:(NSArray *)imageUrlStrings
{
    _imageUrlStrings = imageUrlStrings;
    self.pageContorl.numberOfPages = _imageUrlStrings.count;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageUrlStrings.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    NSString * imageUrlStr = self.imageUrlStrings[indexPath.item];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:PlaceHolderImage_Other];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.width, self.height);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x + self.width/2)/self.width;
    self.pageContorl.currentPage = page;
}

@end


@implementation PhotosCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        self.imageView = imageView;
    }
    return self;
}

@end
