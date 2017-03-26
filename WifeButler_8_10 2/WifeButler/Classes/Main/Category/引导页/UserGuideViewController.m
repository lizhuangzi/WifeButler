//
//  UserGuideViewController.m
//  Mahjong
//
//  Created by zjtdmac2 on 15/7/6.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "UserGuideViewController.h"
#import "ZJTabBarController.h"

#define KRenWuXiangQing @""

// 屏幕
#define KPingKuan   [[UIScreen mainScreen] bounds].size.width
#define KPingGao    [[UIScreen mainScreen] bounds].size.height

@interface UserGuideViewController ()<UIScrollViewDelegate>
{
    UIPageControl * pageControl;
    NSMutableArray *_dataSource;
}

@end

@implementation UserGuideViewController
- (instancetype)init
{
    if (self = [super init]) {
         self.type = 0;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    [self initGuide];
}

- (void)initGuide
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KPingKuan, KPingGao)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    [scrollView setContentSize:CGSizeMake(KPingKuan*3, 0)];
    [scrollView setPagingEnabled:YES];      // 视图整页显示
    [scrollView setBounces:NO];             // 避免弹跳效果,避免把根视图露出来
    [scrollView setDelegate:self];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KPingKuan, KPingGao)];
    [imageview setImage:[UIImage imageNamed:@"sp2"]];
    [scrollView addSubview:imageview];
    
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(KPingKuan, 0, KPingKuan, KPingGao)];
    [imageview1 setImage:[UIImage imageNamed:@"sp3"]];
    [scrollView addSubview:imageview1];
    
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(KPingKuan*2, 0, KPingKuan, KPingGao)];
    [imageview2 setImage:[UIImage imageNamed:@"sp4"]];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(push)];
    [imageview2 setUserInteractionEnabled:YES];
    [imageview2 addGestureRecognizer:tap];
    [scrollView addSubview:imageview2];
    
    
    [self.view addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KPingGao-30, KPingKuan, 20)];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 3;
    [self.view addSubview:pageControl]; //将pageControl封装到featureView
}

- (void)push
{
    if (self.type == 0) {
        [self presentViewController:[[ZJTabBarController alloc] init] animated:YES completion:^{
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView
{
    NSInteger index = fabs(sView.contentOffset.x) / sView.frame.size.width;
    [pageControl setCurrentPage:index];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
