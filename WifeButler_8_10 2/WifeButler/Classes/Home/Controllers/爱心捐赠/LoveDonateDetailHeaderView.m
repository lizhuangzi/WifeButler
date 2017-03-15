//
//  LoveDonateDetailHeaderView.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/15.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "LoveDonateDetailHeaderView.h"
#import "LoveDonateDetailModel.h"
#import "UIColor+HexColor.h"
@interface LoveDonateDetailHeaderView ()

@property (nonatomic,weak) UIImageView * imageView;

@property (nonatomic,weak) UIProgressView * progressView;

@property (nonatomic,strong) NSMutableArray * labelnumArr;

@property (nonatomic,weak) UILabel * percentDesLabel;
@end

@implementation LoveDonateDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.labelnumArr = [NSMutableArray array];
        
        UIImageView * image = [[UIImageView alloc]init];
        image.frame = CGRectMake(0, 0, frame.size.width, 160);
        [self addSubview:image];
        self.imageView = image;
        
        UILabel * percentDesLabel = [[UILabel alloc]init];
        percentDesLabel.font = [UIFont systemFontOfSize:13];
        percentDesLabel.textColor = HexCOLOR(@"#FFC086");
        [self addSubview:percentDesLabel];
        self.percentDesLabel = percentDesLabel;
        
        UIProgressView * pro = [[UIProgressView alloc]init];
        pro.bounds = CGRectMake(0, 0, frame.size.width - 60, 5);
        pro.trackTintColor = HexCOLOR(@"#e6e6e6");
        pro.progressTintColor = HexCOLOR(@"#FFC086");
        pro.y = CGRectGetMaxY(image.frame)+15;
        
        [self addSubview:pro];
        self.progressView = pro;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.progressView.centerX = self.centerX - 10;
    
    self.percentDesLabel.frame  = CGRectMake(CGRectGetMaxX(self.progressView.frame)+6, 0, 30, 20);
    self.percentDesLabel.centerY = self.progressView.centerY;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    self.progressView.transform = transform;
}

- (void)setModel:(LoveDonateDetailModel *)model
{
    _model = model;
     NSUInteger count;
     CGFloat labelY = 0;
    NSArray * nameArr;
    NSArray * numArr;
    if ([_model.percent isEqualToString:@"无上限"]) {
        self.progressView.hidden = YES;
        self.percentDesLabel.hidden = YES;
        labelY = CGRectGetMaxY(self.imageView.frame) + 10;
        count = 2;
        nameArr = @[@"用户捐款(元)",@"爱心(份)"];
        numArr = @[_model.user_donation,_model.count];
    }else{
        self.progressView.hidden = NO;
        
        self.percentDesLabel.hidden = NO;
        self.percentDesLabel.text = [NSString stringWithFormat:@"%@%%",_model.percent];
        
        labelY = CGRectGetMaxY(self.progressView.frame)+10;
        count = 3;
        nameArr = @[@"用户捐款(元)",@"目标(元)",@"爱心(元)"];
        numArr = @[_model.user_donation,_model.target_sum,_model.count];
        [self.progressView setProgress:_model.percent.floatValue/100];
    }
    
   
    CGFloat labelW = iphoneWidth/count;
    CGFloat labelH = 30;
   
    for (NSUInteger i = 0; i<count; i++) {
        
        UILabel * numLabel = [[UILabel alloc]init];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:numLabel];
        numLabel.frame = CGRectMake(i*labelW, labelY, labelW, labelH);
        numLabel.font = [UIFont systemFontOfSize:14];
        [self.labelnumArr addObject:numLabel];
        numLabel.text = numArr[i];
        
        UILabel * desLabel = [[UILabel alloc]init];
        desLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:desLabel];
        desLabel.frame = numLabel.frame;
        desLabel.y = CGRectGetMaxY(numLabel.frame);
        desLabel.text = nameArr[i];
        desLabel.font = [UIFont systemFontOfSize:15];
        desLabel.textColor = WifeButlerGaryTextColor4;
    }
    
    [self.imageView sd_setImageWithURL:_model.imageURL placeholderImage:PlaceHolderImage_Other];
}

@end
