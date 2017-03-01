//
//  CSActionSheetCell.m
//  docClient
//
//  Created by GDXL2012 on 15/8/18.
//  Copyright (c) 2015年 luo. All rights reserved.
//

#import "CSActionSheetCell.h"
#import "Masonry.h"

typedef enum ActionSheetCellType{
    kActionSheetCellTypeNormal,
    kActionSheetCellTypeBottom,
    kActionSheetCellTypeTop
}ActionSheetCellType;

@interface CSActionSheetCell(){
    UIView *topView;
    UIView *centerView;
    UIView *bottomView;
    UIView *lineView;
}

@property (nonatomic, assign) BOOL isNewStyle;

@end

@implementation CSActionSheetCell

// 顶部圆角cell
+(instancetype)topRoundedSquareActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle{
    return [[CSActionSheetCell alloc] initWithActionCellStyle:kActionSheetCellTypeTop reuseIdentifier:reuseIdentifier isNewStyle:isNewStyle];
}

// 底部圆角cell
+(instancetype)bottomRoundedSquareActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle{
    return [[CSActionSheetCell alloc] initWithActionCellStyle:kActionSheetCellTypeBottom reuseIdentifier:reuseIdentifier isNewStyle:isNewStyle];
}

//正常cell
+(instancetype)normalActionSheetCell:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle{
    
    return [[CSActionSheetCell alloc] initWithActionCellStyle:kActionSheetCellTypeNormal reuseIdentifier:reuseIdentifier isNewStyle:isNewStyle];
}

-(instancetype)initWithActionCellStyle:(ActionSheetCellType)style reuseIdentifier:(NSString *)reuseIdentifier isNewStyle:(BOOL)isNewStyle{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isNewStyle = isNewStyle;
        if (style == kActionSheetCellTypeBottom) {
            [self initBottomCell];
        } else if(style == kActionSheetCellTypeTop){
            [self initTopCell];
        } else {
            [self initCommonView];
        }
    }
    return self;
}

-(void)initCommonView{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = WifeButlerSeparateLineColor;
    lineView.hidden = _sepViewHidden;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.mas_equalTo(self.mas_left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.right.mas_equalTo(self.mas_right);
    }];
}

-(void)initTopCell{
    topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    if (!self.isNewStyle) {
        topView.layer.cornerRadius = 3.0f;
        topView.layer.masksToBounds = YES;
    }
    [self.contentView addSubview:topView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(3.0f);
        make.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [self initCommonView];
}

-(void)initBottomCell{
    topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:topView];
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    if (!self.isNewStyle) {
        bottomView.layer.cornerRadius = 3.0f;
        bottomView.layer.masksToBounds = YES;
    }

    [self.contentView addSubview:bottomView];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-3.0f);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self initCommonView];
}

-(void)setSepViewHidden:(BOOL)hidden{
    _sepViewHidden = hidden;
    if (lineView) {
        lineView.hidden = hidden;
    }
}

@end
