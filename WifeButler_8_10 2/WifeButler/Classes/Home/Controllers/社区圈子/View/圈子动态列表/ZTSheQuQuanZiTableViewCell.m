//
//  ZTSheQuQuanZiTableViewCell.m
//  WifeButler
//
//  Created by ZT on 16/6/11.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuQuanZiTableViewCell.h"
#define MARGIN 8

@interface ZTSheQuQuanZiTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation ZTSheQuQuanZiTableViewCell

static NSString *ID = @"trendsPicsCell";

- (void)awakeFromNib {
    
 
}

-(void)setFrameMode:(ZJTrendsCellFrameModel *)frameMode{
    
    _frameMode = frameMode;
 
    [self settingData];
    
    [self settingFrame];
}


-(void)settingData{
    
    if (self.dianZanNum) {
        [self.dianZanNum removeFromSuperview];
    }
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    
    [self.headerView.icon sd_setImageWithURL:[NSURL URLWithString:[KImageUrl stringByAppendingString:self.frameMode.model.avatar]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    
    if ([self.frameMode.model.myup intValue] == 1) {
        
        self.functionView.commendBtn.selected = YES;
    }
    else
    {
        self.functionView.commendBtn.selected = NO;
    }

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   
    formatter.dateFormat = @"MM-dd HH:mm";
    
    NSTimeInterval timeInterval = [self.frameMode.model.time doubleValue];
   
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];

    NSString *startTime = [formatter stringFromDate:startDate];
    self.headerView.time.text =  startTime;
    self.headerView.name.text = self.frameMode.model.nickname;
    
    self.desLa.text = self.frameMode.model.content;
   
    if (self.frameMode.model.gallery.length) {
        UICollectionViewFlowLayout *flowLaout = [[UICollectionViewFlowLayout alloc]init];
        [flowLaout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLaout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        //注册 cell
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
        

    }
    
    
    
    if (self.frameMode.model.some.length) {
        
        UIButton *commendNum = [UIButton buttonWithType:UIButtonTypeCustom];
        commendNum.titleLabel.font = [UIFont systemFontOfSize:14];
        commendNum.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [commendNum setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        commendNum.enabled = NO;
        [self.contentView addSubview:commendNum];
        self.dianZanNum = commendNum;
        
        [self.dianZanNum setImage:[UIImage imageNamed:@"ZTDianDainZhan"] forState:UIControlStateNormal];
        [self.dianZanNum setTitle:self.frameMode.model.some forState:UIControlStateNormal];
    }else{
        
        NSLog(@"-----");
    }
    
    self.pingLuLab.text = @"说些什么吧";
    
}

-(void)settingFrame{
    
    self.headerView.frame = self.frameMode.headerViewF;
    self.desLa.frame = self.frameMode.contentF;
    self.functionView.frame = self.frameMode.functionViewF;
    self.collectionView.frame = self.frameMode.collectionViewF;
    
    self.dianZanNum.frame = self.frameMode.commendViewF;
    self.pingLuLab.frame = self.frameMode.commentViewF;
    self.pingLuLab.layer.borderWidth = 1;
    self.pingLuLab.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pingLuLab.layer.cornerRadius = 5;
    self.pingLuLab.layer.masksToBounds = YES;
    self.pingLuLab.userInteractionEnabled = YES;

    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger count = 0;
    
    NSArray *arr = [self.frameMode.model.gallery componentsSeparatedByString:@","];

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
  
    NSArray *arr = [self.frameMode.model.gallery componentsSeparatedByString:@","];
    
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
    
    NSLog(@"图片点击");
    
    if (self.PhotoBlack) {
        
        self.PhotoBlack(self, indexPath);
    }
    
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        ZJTrendsHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"ZJTrendsHeaderView" owner:nil options:nil]lastObject];
        
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iocn_clicked:)];
        headerView.icon.userInteractionEnabled = YES;
        [headerView.icon addGestureRecognizer:headerTap];
        
        [headerView.deleteBtn addTarget:self action:@selector(deleteBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:headerView];
        self.headerView = headerView;
        
        
        UILabel *descLabel = [[UILabel alloc]init];
        descLabel.font = [UIFont systemFontOfSize:14];
        descLabel.numberOfLines = 0;
        [self.contentView addSubview:descLabel];
        self.desLa = descLabel;
        
        ZJTrendsFunctionView *functionView = [[[NSBundle mainBundle]loadNibNamed:@"ZJTrendsFunctionView" owner:nil options:nil]lastObject];
        
        [functionView.commendBtn addTarget:self action:@selector(commendBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [functionView.commmentBtn addTarget:self action:@selector(commentBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:functionView];
        self.functionView = functionView;
        
//        self.functionView.commendBtn.selected
        
        UILabel *commentLabel = [[UILabel alloc]init];
        commentLabel.font = [UIFont systemFontOfSize:14];
        commentLabel.textColor = [UIColor lightGrayColor];
       
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentViewClicked:)];
        [commentLabel addGestureRecognizer:tap];
        [self.contentView addSubview:commentLabel];
        self.pingLuLab = commentLabel;
       
    }
    
    return self;
}


-(void)iocn_clicked:(UITapGestureRecognizer *)sender{
    NSLog(@"头像");
    
    if ([self.delegate respondsToSelector:@selector(sheQuQuanZiTableViewCell:functionViewClicked:)]) {
        [self.delegate sheQuQuanZiTableViewCell:self functionViewClicked:sender.view];
    }

    
}


-(void)deleteBtn_clicked:(UIButton *)sender{
    
    NSLog(@"删除");
    
    if ([self.delegate respondsToSelector:@selector(sheQuQuanZiTableViewCell:functionViewClicked:)]) {
        [self.delegate sheQuQuanZiTableViewCell:self functionViewClicked:sender];
    }
    
    
    
}

-(void)commentViewClicked:(UITapGestureRecognizer *)sender{
    
    NSLog(@"评论");
    
    if ([self.delegate respondsToSelector:@selector(sheQuQuanZiTableViewCell:functionViewClicked:)]) {
        [self.delegate sheQuQuanZiTableViewCell:self functionViewClicked:sender.view];
    }

    
}

-(void)commendBtn_clicked:(UIButton *)sender{
    
    NSLog(@"点赞");
    if ([self.delegate respondsToSelector:@selector(sheQuQuanZiTableViewCell:functionViewClicked:)]) {
        
        [self.delegate sheQuQuanZiTableViewCell:self functionViewClicked:sender];
    }

    
    
}

-(void)commentBtn_clicked:(UIButton *)sender{
    
    NSLog(@"评论");
    
    if ([self.delegate respondsToSelector:@selector(sheQuQuanZiTableViewCell:functionViewClicked:)]) {
        [self.delegate sheQuQuanZiTableViewCell:self functionViewClicked:sender];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
