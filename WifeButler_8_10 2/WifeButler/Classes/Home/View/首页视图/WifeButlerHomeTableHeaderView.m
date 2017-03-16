//
//  WifeButlerHomeTableHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/22.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerHomeTableHeaderView.h"
#import "SDCycleScrollView.h"
#import "ZTLunBoToModel.h"
#import "masonry.h"

@interface WifeButlerHomeTableHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic,weak) SDCycleScrollView * cycleScrollView2;

@end

@implementation WifeButlerHomeTableHeaderView

+ (instancetype)WifeButlerHomeTableHeaderViewWithimageArray:(NSArray *)imageArray
{
    WifeButlerHomeTableHeaderView * bf = [[WifeButlerHomeTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, 320)];
    
    if (imageArray) {
        bf.bannerImageURLStrings = imageArray;
    }
    return bf;
}

- (void)setBannerImageURLStrings:(NSArray *)bannerImageURLStrings
{
    _bannerImageURLStrings = bannerImageURLStrings;
    self.cycleScrollView2.imageURLStringsGroup = _bannerImageURLStrings;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //1.创建轮播装置
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, 136.5) delegate:self placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
        
        cycleScrollView2.backgroundColor = [UIColor whiteColor];
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        cycleScrollView2.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:cycleScrollView2];
        self.cycleScrollView2 = cycleScrollView2;
        
        
        //添加背景
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, cycleScrollView2.height+1, frame.size.width, frame.size.height - cycleScrollView2.height)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        //2.创建8个选项
        
        NSArray * titleArray = @[@"社区圈子",@"社区购物",@"社区服务",@"社区物业",@"环保日历",@"爱心捐赠",@"回收服务",@"酵素回收"];
        NSArray * imageNameArray = @[@"communityCircle",@"communityShop",@"communityService",@"communityRealEstate",@"EPcalendar",@"loveDonation",@"recycleService",@"jiaosuhuishou"];
        
        CGFloat btnW = 55;
        CGFloat btnH = 60;
        CGFloat margin = (iphoneWidth - 4*btnW)/5;
        CGFloat Hmargin = (backView.height - 2* btnH)/3;
        for (int i = 0; i<8; i++) {
            int row = i/4;
            int cloum = i%4;
            WifeButlerHomeCircleButton * button = [[WifeButlerHomeCircleButton alloc]initWithImageName:imageNameArray[i]  andtitle:titleArray[i]];
            button.tag = i+2017;
            [button addTarget:self action:@selector(roundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(margin + cloum *(btnW+margin), Hmargin + row * (btnH + Hmargin), btnW, btnH);
            [backView addSubview:button];
        }
        
    }
    return self;
}

- (void)roundButtonClick:(WifeButlerHomeCircleButton *)button
{
    !self.returnBlock?:self.returnBlock(button.tag - 2017);
}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
//   ZTLunBoToModel *model = _dataSource[index];
    
//    ZTXiangQinHealthyLifeViewController *vc = [[ZTXiangQinHealthyLifeViewController alloc] init];
//    vc.id_temp = model.goods_id;
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}



@end


@implementation WifeButlerHomeCircleButton

- (instancetype)initWithImageName:(NSString *)imageName andtitle:(NSString *)title
{
    if (self = [super init]) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:imageView];
        CGFloat height = 55;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(0);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(height);
            make.height.mas_equalTo(height);
        }];
        imageView.image = [UIImage imageNamed:imageName];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textColor = WifeButlerGaryTextColor4;
        [self addSubview:label];
        label.font = [UIFont systemFontOfSize:11];
        label.text = title;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
    }
    return self;
}


@end
