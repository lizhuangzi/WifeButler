//
//  XMGHomeViewController.m
//  02-网易新闻首页
//
//  Created by xiaomage on 15/7/6.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGHomeViewController.h"
#import "XMGSocialViewController.h"
#import "XMGHomeLabel.h"
#import "XMGConst.h"
#import "masonry.h"

@interface XMGHomeViewController () <UIScrollViewDelegate>


@property (nonatomic,weak) UIView * sliderlineView;

@property (nonatomic,strong) NSMutableArray * titleArray;

@end

@implementation XMGHomeViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"XMGHomeViewController - %f %f %f", XMGRed, XMGGreen, XMGBlue);
    
    [self createUI];
}

- (void)createUI
{
    self.view.backgroundColor = WifeButlerSeparateLineColor;
    
    UIScrollView *  titleScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, iphoneWidth, 44)];
    titleScro.backgroundColor = [UIColor whiteColor];
    titleScro.showsVerticalScrollIndicator = NO;
    titleScro.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:titleScro];
    self.titleScrollView = titleScro;
    [titleScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(44);
    }];
    
    [titleScro layoutIfNeeded];
    //滑块底部的线
    UIView * sliderLineView = [[UIView alloc]initWithFrame:CGRectMake(15, titleScro.height-3, 90, 3)];
    sliderLineView.backgroundColor = WifeButlerCommonRedColor;
    [titleScro addSubview:sliderLineView];
    self.sliderlineView = sliderLineView;
    
    
    UIScrollView *  contentScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    contentScro.pagingEnabled = YES;
    contentScro.showsHorizontalScrollIndicator = NO;
    contentScro.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentScro];
    self.contentScrollView = contentScro;
    [contentScro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleScro.mas_bottom).offset(1);
        make.right.mas_equalTo(self.view.mas_right);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

- (void)config
{
    [self setupTitle];
    self.contentScrollView.delegate = self;
    // 默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

/**
 * 添加标题
 */
- (void)setupTitle
{
    // 定义临时变量
    CGFloat labelW = 100;
    CGFloat labelY = 0;
    CGFloat labelH = self.titleScrollView.frame.size.height;
    
    NSLog(@"%@",self.childViewControllers);
    // 添加label
    for (NSInteger i = 0; i<self.childViewControllers.count; i++) {
        
        XMGHomeLabel *label = [[XMGHomeLabel alloc] init];
        label.text = [self.childViewControllers[i] title];
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.tag = i;
        [self.titleScrollView addSubview:label];
        
        if (i == 0) { // 最前面的label
            label.scale = 1.0;
        }
        //添加进数组
        [self.titleArray addObject:label];
    }
    
    // 设置contentSize
    self.titleScrollView.contentSize = CGSizeMake(7 * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(7 * [UIScreen mainScreen].bounds.size.width, 0);
}

/**
 * 监听顶部label点击
 */
- (void)labelClick:(UITapGestureRecognizer *)tap
{
    // 取出被点击label的索引
    NSInteger index = tap.view.tag;
    
    // 让底部的内容scrollView滚动到对应位置
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 一些临时变量
    CGFloat width = iphoneWidth;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    XMGHomeLabel *label = self.titleArray[index];
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (XMGHomeLabel *otherLabel in self.titleArray) {
        if (otherLabel != label) otherLabel.scale = 0.0;
    }
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x / iphoneWidth;
    self.sliderlineView.x = self.titleScrollView.contentSize.width/scrollView.contentSize.width * scrollView.contentOffset.x + 7.5;
    
    if (scale < 0 || scale > self.titleArray.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    XMGHomeLabel *leftLabel = self.titleArray[leftIndex];
    
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    XMGHomeLabel *rightLabel = (rightIndex == self.titleArray.count) ? nil : self.titleArray[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
}

@end
