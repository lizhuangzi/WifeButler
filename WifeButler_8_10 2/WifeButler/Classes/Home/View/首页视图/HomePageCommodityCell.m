//
//  HomePageCommodityCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/23.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "HomePageCommodityCell.h"
#import "UIColor+HexColor.h"

@interface HomePageCommodityCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**存放商品的容器*/
@property (weak, nonatomic) IBOutlet UIView *commoditiesBackView;

/**记录正在显示的商品个数*/
@property (nonatomic,assign) NSInteger showingNum;

@end

@implementation HomePageCommodityCell

- (void)awakeFromNib
{   
    [super awakeFromNib];
    self.titleLabel.textColor = WifeButlerCommonRedColor;
    self.contentView.backgroundColor = WifeButlerTableBackGaryColor;
}

+ (instancetype)CommodityCellWithTableView:(UITableView *)tableView{
    
    NSString * ID = @"HomePageCommodityCell";
    HomePageCommodityCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HomePageCommodityCell" owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)setModel:(HomePageSectionModel *)model
{
    _model = model;
    self.titleLabel.text = _model.title;
    
    NSInteger listCount = _model.list.count;
    NSInteger tempCount = 0;
    
    if (listCount>6) { //个数是否大于6个
        tempCount = 6;
    }else{
        tempCount = listCount;
    }
    //商品当前个数（复用来的）
    NSInteger backCount = self.commoditiesBackView.subviews.count;
    
    CGFloat wMargin = 1;
    CGFloat hMargin = 1;
    CGFloat viewWith = (iphoneWidth - 4*wMargin)/3;
    CGFloat viewHeight = viewWith/2*3;

    if (backCount <tempCount) {  //复用来的商品个小于数据个数
        
        
        for (NSInteger i = backCount; i<tempCount; i++) {
            
            //设置行号 列号
            NSInteger row = i/3;
            NSInteger col = i%3;
            //创建
            HomePageCommodityView * comView = [HomePageCommodityView HomePageCommodityView];
            [comView addTarget:self action:@selector(comViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.commoditiesBackView addSubview:comView];
            comView.frame = CGRectMake(wMargin + col * (viewWith + wMargin), hMargin + row * (viewHeight + hMargin), viewWith, viewHeight);
            
        }
        //显示数据
        for (NSInteger i = 0; i<tempCount; i++) {
            HomePageCommodityView * commodity = self.commoditiesBackView.subviews[i];
            commodity.cellModel = model.list[i];
            commodity.hidden = NO;
        }
       
    }else{
        
        for (NSInteger i = 0; i<tempCount; i++) {
           HomePageCommodityView * commodity = self.commoditiesBackView.subviews[i];
            commodity.cellModel = model.list[i];
            commodity.hidden = NO;
        }
        for (NSInteger i = tempCount; i<backCount; i++) {
            HomePageCommodityView * commodity = self.commoditiesBackView.subviews[i];
            commodity.hidden = YES;
        }
    }
    if (tempCount == 0) {
        _model.cellHeight = 37.5;
    }
    else if (tempCount<=3) {
        _model.cellHeight = viewHeight + 2 + 37.5;
    }else{
        _model.cellHeight = viewHeight * 2 + 3 + 37.5;
    }
}
- (IBAction)moreClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(HomePageCommodityCell:didClickFindMore:)]) {
        [self.delegate HomePageCommodityCell:self didClickFindMore:self.model];
    }
}

- (void)comViewClick:(HomePageCommodityView *)view{
    
    if ([self.delegate respondsToSelector:@selector(HomePageCommodityCell:didClickOneCommdity:)]) {
        [self.delegate HomePageCommodityCell:self didClickOneCommdity:view.cellModel];
    }
}

@end
