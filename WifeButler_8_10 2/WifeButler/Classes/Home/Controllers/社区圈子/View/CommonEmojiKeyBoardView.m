//
//  CommonEmojiKeyBoardView.m
//  CjSummary
//
//  Created by paopao on 16/8/16.
//  Copyright © 2016年 cj. All rights reserved.
//

#import "CommonEmojiKeyBoardView.h"
#import "CommonEmojiPageCell.h"
#import "CommonEmojiManager.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"

static NSString * const identifier = @"CommonEmojiPageCell";

@interface CommonEmojiKeyBoardView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *topLine;

@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UIButton *selectItem;

@property (nonatomic, strong) NSArray *keysArray;

@property (nonatomic, strong) NSArray *emotionDataArray;

@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (nonatomic, strong) NSArray *itemEmotionsPageArray;




@end

@implementation CommonEmojiKeyBoardView

static CGFloat keyBoardHig = 225;

static CGFloat bottomHig = 38;

static CGFloat pageHig = 32;

static CGFloat sendWid = 50;

static CGFloat itemWid = 45;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI
{
    self.backgroundColor = WifeButlerTableBackGaryColor;
    self.keysArray = @[@"People",@"Places",@"Objects",@"Nature"];
    self.emotionDataArray = [CommonEmojiManager emotionsData];
    self.itemEmotionsPageArray = [CommonEmojiManager emotionsItemPageArray];
    [self setUpCollectionView];
    [self setUpPageControl];
    [self setUpBottomView];
    [self setUpTopLine];
}

-(void)setUpCollectionView
{
    UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc] init];
    viewLayout.itemSize = CGSizeMake(iphoneWidth, keyBoardHig - bottomHig);
    viewLayout.minimumLineSpacing = 0;
    viewLayout.minimumInteritemSpacing = 0;
    viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, keyBoardHig - bottomHig) collectionViewLayout:viewLayout];
    [self.collectionView registerClass:[CommonEmojiPageCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.offset(-bottomHig);
    }];
}

-(void)setUpPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, keyBoardHig - bottomHig - pageHig, iphoneWidth, pageHig)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    self.pageControl.userInteractionEnabled = NO;
    NSRange range = NSRangeFromString(self.itemEmotionsPageArray[0]);
    self.pageControl.numberOfPages = range.length;
    [self addSubview:self.pageControl];

}

-(void)setUpBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, keyBoardHig - bottomHig, iphoneWidth, bottomHig)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    [self setUpScrollView];
    [self setUpSendButton];
}

-(void)setUpScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth - sendWid, bottomHig)];
    self.itemsArray = [NSMutableArray array];
    for (int i = 0 ; i < self.keysArray.count ; i++) {
        NSString *key = self.keysArray[i];
        NSArray *emotions = [CommonEmojiManager emotionsOfPage:0 andKey:key];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:20];
        if (i == 0) {
            button.backgroundColor = HexCOLOR(CommonContentBackgroundColor);
            self.selectItem = button;
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
        
        [button setTitle:emotions.firstObject forState:UIControlStateNormal];
        button.frame = CGRectMake(itemWid * i, 0, itemWid, bottomHig);
        button.tag = i;
        [button addTarget:self action:@selector(didItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(itemWid - 0.5, 5, 0.5, itemWid - 10)];
        line.backgroundColor = WifeButlerSeparateLineColor;
        [button addSubview:line];
        [self.scrollView addSubview:button];
        [self.itemsArray addObject:button];
    }
    [self.bottomView addSubview:self.scrollView];
}

-(void)setUpTopLine
{
    self.topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, 0.5)];
    self.topLine.backgroundColor = WifeButlerSeparateLineColor;
    [self addSubview:self.topLine];
}

// 切换表情
-(void)didItemClick:(UIButton *)button
{
    [self changeSelectItem:button];
    NSRange range = NSRangeFromString(self.itemEmotionsPageArray[button.tag]);
    self.collectionView.contentOffset = CGPointMake(range.location *iphoneWidth, 0);
    self.pageControl.currentPage = 0;
}

-(void)changeSelectItem:(UIButton *)button
{
    [self.selectItem setBackgroundColor:[UIColor whiteColor]];
    [button setBackgroundColor:HexCOLOR(CommonContentBackgroundColor)];
    self.selectItem = button;
    NSRange range = NSRangeFromString(self.itemEmotionsPageArray[button.tag]);
    self.pageControl.numberOfPages = range.length;
}

-(void)setUpSendButton
{
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
//    [self.sendButton setTitleColor:HexCOLOR(MedRefWordColorAuxiliaryTexts) forState:UIControlStateNormal];
//    [self.sendButton setBackgroundColor:HexCOLOR(CommonLightGrayColor)];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.sendButton.frame = CGRectMake(iphoneWidth - sendWid, 0, sendWid, bottomHig);
    [self.sendButton addTarget:self action:@selector(didSendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0.5, bottomHig)];
    line.backgroundColor = WifeButlerSeparateLineColor;
    [self.sendButton addSubview:line];
    [self.bottomView addSubview:self.sendButton];
}
// 发送
-(void)didSendButtonClick
{
    if (self.didSendClick) {
        self.didSendClick();
    }
}

#pragma mark - UICollectionViewDataSource
// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回每组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [CommonEmojiManager emotionPage];//[CommonEmojiManager emotionPageWithKey:self.selectKey];
}

// 返回cell外观
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CommonEmojiPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.emotions = [self.emotionDataArray objectAtIndex:indexPath.row];
    
    WEAKSELF
    [cell setDidDelegateClick:^{
        if (weakSelf.didDeleteClick) {
            weakSelf.didDeleteClick();
        }
    }];
    
    [cell setDidEmojiClick:^(NSString *emojiStr) {
        if (weakSelf.didEmojiClick) {
            weakSelf.didEmojiClick(emojiStr);
        }
    }];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
    NSRange selectRange = NSRangeFromString([self.itemEmotionsPageArray objectAtIndex:self.selectItem.tag]);
    if (page < selectRange.location) { // 切换到前一个Item
        [self changeSelectItem:[self.itemsArray objectAtIndex:self.selectItem.tag - 1]];
        NSRange newRange = NSRangeFromString([self.itemEmotionsPageArray objectAtIndex:self.selectItem.tag]);
        self.pageControl.currentPage = newRange.length - 1;
    }else if (page > selectRange.location + selectRange.length - 1){ // 切换到后一个Item
        [self changeSelectItem:[self.itemsArray objectAtIndex:self.selectItem.tag + 1]];
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = page - selectRange.location;
    }
    
}


@end
