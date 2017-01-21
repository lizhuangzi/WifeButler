//
//  ZJTrendsDetailView.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJTrendsDetailView.h"
#define MARGIN 8

@interface ZJTrendsDetailView() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end


@implementation ZJTrendsDetailView

static NSString *ID = @"trendsPicsCell";

-(void)setFrameModel:(ZJDetailViewFrameModel *)frameModel{
    
    _frameModel = frameModel;
    
    [self settingData];
    [self settingFrame];
    
    [self.collectionView reloadData];
    
}

-(void)settingData{
    
    
    [self.collectionView removeFromSuperview];
    
    ZJTrendsModel *model = self.frameModel.detailModel.topic;
    
    [self.headerView.icon sd_setImageWithURL:[NSURL URLWithString:[KImageUrl stringByAppendingString:model.avatar]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"MM-dd HH:mm";
    
    NSTimeInterval timeInterval = [model.time doubleValue];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSString *startTime = [formatter stringFromDate:startDate];
    self.headerView.time.text =  startTime;
    self.headerView.name.text = model.nickname;

    self.content.text = model.content;
    
    if (self.frameModel.detailModel.topic.gallery.length) {
        UICollectionViewFlowLayout *flowLaout = [[UICollectionViewFlowLayout alloc]init];
        [flowLaout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLaout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //注册 cell
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
    }
    
    
    if ([self.frameModel.detailModel.myup isEqualToString:@"0"]) {
        self.functionView.commendBtn.selected = NO;
    }else{
        
         self.functionView.commendBtn.selected = YES;
    }
    
    if (self.frameModel.detailModel.some.length) {
        [self.commendNum setImage:[UIImage imageNamed:@"ZTDianDainZhan"] forState:UIControlStateNormal];
        [self.commendNum setTitle:self.frameModel.detailModel.some forState:UIControlStateNormal];
    }

     
}

-(void)settingFrame{
   
    self.headerView.frame = self.frameModel.headerViewF;
    self.content.frame = self.frameModel.contentF;
    self.collectionView.frame = self.frameModel.collectionViewF;
     self.functionView.frame = self.frameModel.functionViewF;
    self.separateLine.frame = self.frameModel.separateLineF;
    self.commendNum.frame = self.frameModel.commendViewF;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = 0;
    NSArray *arr = [self.frameModel.detailModel.topic.gallery componentsSeparatedByString:@","];
    
    self.dataSourceTemp = arr;
    
    if (arr.count > 9) {
        count = 9;
    }else{
        
        count = arr.count;
        
    }
    
    return count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    NSArray *arr = [self.frameModel.detailModel.topic.gallery componentsSeparatedByString:@","];
    
    NSMutableArray *pics = [NSMutableArray array];
    
    if (arr.count > 9) {
        
        for (int i = 0; i < 9; ++i) {
            [pics addObject:arr[i]];
        }
        
    }else{
        
        pics = [arr mutableCopy];
    }
    
    NSString *picUrl = [KImageUrl stringByAppendingString:pics[indexPath.item]];
    
    UIImageView *imgView = [[UIImageView alloc]init];
    
    cell.backgroundView = imgView;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundView.clipsToBounds = YES;
    
    return cell;
}



//定义每个items 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((iphoneWidth - 4 * MARGIN) / 3, (iphoneWidth - 4 * MARGIN) / 3);
    
    
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(MARGIN, MARGIN, MARGIN, MARGIN);
}



//最小垂直间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return MARGIN;
}


//最小行间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return MARGIN;
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"1111..图片点击");
    
    if (self.PhotoBlack) {
        
        self.PhotoBlack(self, indexPath);
    }
    
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        ZJTrendsDetailHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"ZJTrendsDetailHeaderView" owner:nil options:nil]lastObject];
        
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icon_clicked:)];
        headerView.icon.userInteractionEnabled = YES;
        [headerView.icon addGestureRecognizer:headerTap];

        
        [self addSubview:headerView];
        self.headerView = headerView;
        
        UILabel *content = [[UILabel alloc]init];
        content.font = [UIFont systemFontOfSize:16];
        content.numberOfLines = 0;
        [self addSubview:content];
        self.content = content;
        
       

        ZJTrendsFunctionView *functionView = [[[NSBundle mainBundle]loadNibNamed:@"ZJTrendsFunctionView" owner:nil options:nil]lastObject];
        [functionView.commendBtn addTarget:self action:@selector(commendBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [functionView.commmentBtn addTarget:self action:@selector(commentBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:functionView];
        self.functionView = functionView;
        
        UIView *separateLIne = [[UIView alloc]init];
        separateLIne.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:separateLIne];
        self.separateLine = separateLIne;
  
        
        UIButton *commendNum = [UIButton buttonWithType:UIButtonTypeCustom];
        commendNum.titleLabel.font = [UIFont systemFontOfSize:14];
        commendNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [commendNum setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        commendNum.enabled = NO;
        [self addSubview:commendNum];
        self.commendNum = commendNum;

        
    }
    
    return self;
    
}


//动态头像点击
-(void)icon_clicked:(UITapGestureRecognizer *)sender{
    
    if ([self.delegate respondsToSelector:@selector(trendsDetailView:functionViewClicked:)]) {
        [self.delegate trendsDetailView:self functionViewClicked:sender.view];
    }
  
}


//点赞
-(void)commendBtn_clicked:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(trendsDetailView:functionViewClicked:)]) {
        [self.delegate trendsDetailView:self functionViewClicked:sender];
    }
    
}

//评论
-(void)commentBtn_clicked:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(trendsDetailView:functionViewClicked:)]) {
        [self.delegate trendsDetailView:self functionViewClicked:sender];
    }
    
}



@end
