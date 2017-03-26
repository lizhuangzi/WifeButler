//
//  ZJTabBarController.m
//  Fish
//
//  Created by zjtdmac3 on 15/6/6.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import "ZJTabBarController.h"
#import "ZJHomePageController.h"
#import "ZJMineController.h"
#import "ZTHealthyLifestyleViewController.h"
#import "ZTGarbageOfRiceViewController.h"
#import "UIColor+HexColor.h"
#import "UIColor+EasyExistion.h"

@interface ZJTabBarController ()
@property(nonatomic,strong)ZJHomePageController *homePage;
@property(nonatomic,strong)ZJMineController *mine;
@end

@implementation ZJTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addChildVc];
    
    
    // 设置显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
}

- (void)addChildVc
{
    // 首页
    [self addChildVCWithSBName:@"ZJHomePageController" title:@"社区首页" norImageName:@"ZTHome" selectedImageName:@"ZTHomeLighlighted"];
    
    [self addChildVCWithSBName:@"ZTHealthyLifestyle" title:@"老伴资讯" norImageName:@"ZTTabInformation" selectedImageName:@"ZTTabInformationHighlighted"];

    [self addChildVCWithSBName:@"ZTGarbageOfRice" title:@"垃圾换大米" norImageName:@"ZTZhiHuan" selectedImageName:@"ZTZhiHuanHighlighted"];

    [self addChildVCWithSBName:@"ZJMineController" title:@"个人中心" norImageName:@"ZTWoDe" selectedImageName:@"ZTWoDeHighlighted"];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"tabBar = %@",self.tabBar.subviews);
    for (UIView * view in self.tabBar.subviews) {
        if([view isKindOfClass:NSClassFromString(@"_UIBarBackground")])
        {
            for (UIImageView * image in view.subviews) {
                if ([image isKindOfClass:[UIImageView class]]) {
                    image.hidden = YES;
                }
            }
        }
    }
}
// 通过一个SB创建控制器
- (void)addChildVCWithSBName:(NSString *)sbName  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{

    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];

    UINavigationController *nav = sb.instantiateInitialViewController;

    [self addChildVCWithController:nav.topViewController title:title norImageName:norImageName selectedImageName:selectedImageName];
}


// 设置指定控制器的相关属性
- (void)addChildVCWithController:(UIViewController *)vc  title:(NSString *)title norImageName:(NSString *)norImageName selectedImageName:(NSString *)selectedImageName{

    vc.title = title;
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HexCOLOR(@"#7d7d7d");
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = WifeButlerCommonRedColor;
    
    [vc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    vc.tabBarItem.image = [UIImage imageNamed:norImageName];

    vc.tabBarItem.selectedImage =  [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    [self addChildViewController:vc.navigationController];
}

@end
