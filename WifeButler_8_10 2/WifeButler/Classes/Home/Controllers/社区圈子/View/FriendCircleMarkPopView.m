//
//  FriendCircleMarkPopView.m
//  PatientClient
//
//  Created by GDXL2012 on 15/11/24.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import "FriendCircleMarkPopView.h"
#import "FontUtils.h"
#import "WifeButlerDefine.h"
#import "Masonry.h"
@interface FriendCircleMarkPopView(){
    CGFloat totalWidth;
}

@property(nonatomic, strong) UIView *markBgView;
@property(nonatomic, strong) UIFont *titleFont;

@end

@implementation FriendCircleMarkPopView

static CGFloat minItemHeight = 80.0f;
static CGFloat viewHeight = 40.0f;
static CGFloat icoImgWidth = 17.0f;
static CGFloat imgTitleSpace = 8.0f;
static CGFloat sepViewMargin = 8.0f;
static CGFloat sepViewWidth = 0.5f;

-(instancetype)init{
    self = [super init];
    if (self) {
        [self iniViewAndMemberVariable];
    }
    return self;
}

-(void)iniViewAndMemberVariable{
    self.backgroundColor = [UIColor clearColor];
    self.titleFont = [UIFont systemFontOfSize:systemcontentfont];
    self.markBgView = [[UIView alloc] init];
    self.markBgView.backgroundColor = HexCOLOR(@"#4c5154");
    self.markBgView.layer.cornerRadius = 5.0f;
    self.markBgView.layer.masksToBounds = YES;
    self.markBgView.userInteractionEnabled = YES;
    [self addSubview:self.markBgView];
}


-(void)setItemTitles:(NSArray *)titleArray{
    NSInteger titleCount = titleArray.count;
    if (titleCount > 0) {
        CGFloat itemWidth = 0.0f;
        CGFloat datX = 0.0f;
        for (int index = 0; index < titleCount; index ++) {
            NSString *title = titleArray[index];
            CGSize size = [FontUtils stringSize:title withSize:CGSizeMake(MAXFLOAT, viewHeight) font:self.titleFont];
            itemWidth = size.width+ 5;
            if (itemWidth < minItemHeight) {
                itemWidth = minItemHeight;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.tag = index;
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:systemheaderfont];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, imgTitleSpace, 0, 0);
            button.frame = CGRectMake(datX, 0, itemWidth, viewHeight);
            [self.markBgView addSubview:button];
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            datX = datX + itemWidth;
            if (index != titleCount - 1) {
                UIView *sepView=[[UIView alloc]init];
                sepView.backgroundColor = HexCOLOR(@"#373d40");
                sepView.frame = CGRectMake(datX, sepViewMargin, sepViewWidth, viewHeight - sepViewMargin * 2);
                [self.markBgView addSubview:sepView];
                datX = datX + sepViewWidth;
            }
        }
        totalWidth = datX;
    }
}

/**
 * titleArray、icoArray均不能为空，切个数相等
 */
-(void)setItemTitles:(NSArray *)titleArray withIcos:(NSArray *)icoArray{
    NSInteger titleCount = titleArray.count;
    NSInteger icoCount = icoArray.count;
    if (titleCount > 0 && icoCount > 0 && titleCount == icoCount) {
        CGFloat itemWidth = 0.0f;
        CGFloat datX = 0.0f;
        for (int index = 0; index < titleCount; index ++) {
            NSString *title = titleArray[index];
            CGSize size = [FontUtils stringSize:title withSize:CGSizeMake(MAXFLOAT, viewHeight) font:self.titleFont];
            itemWidth = size.width + icoImgWidth + 5;
            if (itemWidth < minItemHeight) {
                itemWidth = minItemHeight;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.tag = index;
            [button setImage:[UIImage imageNamed:icoArray[index]] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:systemheaderfont];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, imgTitleSpace/2, 0, 0);
            button.imageEdgeInsets=UIEdgeInsetsMake(0, 0,0,imgTitleSpace/2);
            button.frame = CGRectMake(datX, 0, itemWidth, viewHeight);
            [self.markBgView addSubview:button];
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            datX = datX + itemWidth;
            if (index != titleCount - 1) {
                UIView *sepView=[[UIView alloc]init];
                sepView.backgroundColor = HexCOLOR(@"#373d40");
                sepView.frame = CGRectMake(datX, sepViewMargin, sepViewWidth, viewHeight - sepViewMargin * 2);
                [self.markBgView addSubview:sepView];
                datX = datX + sepViewWidth;
            }
        }
        totalWidth = datX;
    }
}

-(void)showMarkViewWithReference:(UIView *)view withPosition:(ShowMarkViewPosition)positionType offset:(CGFloat)offset{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect rect = [view convertRect:view.bounds toView:window];
    if (positionType == kShowMarkViewLeft) {
        [self.markBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(rect.origin.y - (viewHeight - rect.size.height) / 2);
            make.left.mas_equalTo(rect.origin.x - offset);//(rect.origin.x - totalWidth - offset);
            make.size.mas_equalTo(CGSizeMake(totalWidth, viewHeight));
        }];
    } else if(positionType == kShowMarkViewRight){
        [self.markBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(rect.origin.y - (viewHeight - rect.size.height) / 2);
            make.right.mas_equalTo(rect.origin.x + rect.size.width + totalWidth + offset);
            make.size.mas_equalTo(CGSizeMake(totalWidth, viewHeight));
        }];
    } else if (positionType == kShowMarkViewTop){
        [self.markBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(rect.origin.y - viewHeight - offset);
            make.left.mas_equalTo(rect.origin.x - (totalWidth - rect.size.width) / 2);
            make.size.mas_equalTo(CGSizeMake(totalWidth, viewHeight));
        }];
    } else {
        [self.markBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(rect.origin.y + viewHeight + offset);
            make.left.mas_equalTo(rect.origin.x - (totalWidth - rect.size.width) / 2);
            make.size.mas_equalTo(CGSizeMake(totalWidth, viewHeight));
        }];
    }
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, iphoneWidth, iphoneHeight)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(rect.origin.x - offset, (rect.origin.y - (viewHeight - rect.size.height) / 2), totalWidth, viewHeight) cornerRadius:0] bezierPathByReversingPath]];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.path = path.CGPath;
    [self.layer setMask:shapelayer];
    if (positionType == kShowMarkViewLeft) {

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.markBgView.transform = CGAffineTransformMakeTranslation(-totalWidth - 10, 0);

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                self.markBgView.transform = CGAffineTransformMakeTranslation(- totalWidth, 0);
            } completion:nil];
        }];
    }
}



-(void)itemButtonClick:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(markPopView:clickAtIndex:)]) {
        [self.delegate markPopView:self clickAtIndex:button.tag];
    }
    [self dismissView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

-(void)dismissView{
    [self removeFromSuperview];
}

@end
