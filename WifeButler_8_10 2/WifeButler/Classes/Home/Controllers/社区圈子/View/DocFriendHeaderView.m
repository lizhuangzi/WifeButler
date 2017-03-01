//
//  LifeLineHeaderView.m
//  PatientClient
//
//  Created by GDXL2012 on 15/7/2.
//  Copyright (c) 2015年 ikuki. All rights reserved.
//

#import "DocFriendHeaderView.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"

@interface DocFriendHeaderView()<UIGestureRecognizerDelegate>{
}
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UIImageView *userBgImageView;
@property (strong, nonatomic) UIView *headerBgView;

// 消息
@property (strong, nonatomic) UIView *messageBgView;
@property (strong, nonatomic) UIImageView *iconImgView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UIImageView *messageRightImgView;

@end

@implementation DocFriendHeaderView

/**
 * 返回view高度
 */
+(float)headerViewHeight{
    return 44 + iphoneWidth / 750 * 513; //200.0f * iphoneWidth / 320.0f + 25.0f + 32.0f;
}
// 有消息时的高度
+(float)headerMessageViewHeight
{
    return 120 + iphoneWidth / 750 * 513;
}

+(float)userHeaderViewHeight{
    return 88 + iphoneWidth / 750 * 513;
}

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.userBgImageView = [[UIImageView alloc] init];
    self.userBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userBgImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.userBgImageView];
    
    self.headerBgView = [[UIImageView alloc] init];
    self.headerBgView.backgroundColor = [UIColor whiteColor];
    self.headerBgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headerBgView];
    
    UIView *shadowview=[[UIView alloc]init];
    [self.headerBgView addSubview:shadowview];
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.backgroundColor = HexCOLOR(@"#c9c9c9");
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.headerBgView addSubview:self.headerImageView];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.font = [UIFont systemFontOfSize:17.0f];
    self.userNameLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.userNameLabel];
    
    self.messageBgView = [[UIView alloc] init];
    self.messageBgView.backgroundColor = WifeButlerTableBackGaryColor;
    self.messageBgView.layer.cornerRadius = 5;
    self.messageBgView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.messageBgView];
    
    self.iconImgView = [[UIImageView alloc] init];
    self.iconImgView.layer.cornerRadius = 5;
    self.iconImgView.layer.masksToBounds = YES;
    self.iconImgView.image = [UIImage imageNamed:@"work_tempPhoto_big"];
    [self.messageBgView addSubview:self.iconImgView];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.text = @"1条新消息";
    self.messageLabel.font = ThinFont(14);
    self.messageLabel.textColor = [UIColor whiteColor];
    [self.messageBgView addSubview:self.messageLabel];
    
    self.messageRightImgView = [[UIImageView alloc] init];
    self.messageRightImgView.image = [UIImage imageNamed:@"academic_rightItem"];
    [self.messageBgView addSubview:self.messageRightImgView];
    
    [self.userBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0).offset(-1.0f);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.userBgImageView.mas_width).multipliedBy(513.0f / 750.0f);
    }];
    
    [self.headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.userBgImageView.mas_bottom).offset(-12.5);
        make.height.mas_equalTo(75);
        make.width.mas_equalTo(self.headerBgView.mas_height).multipliedBy(1);
    }];
    
    [shadowview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.userBgImageView.mas_right);
        make.left.mas_equalTo(self.userBgImageView.mas_left);
        make.bottom.mas_equalTo(self.userBgImageView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.headerBgView).insets(UIEdgeInsetsMake(2, 2, 2, 2));
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headerBgView.mas_left).offset(-20);
        make.bottom.mas_equalTo(self.userBgImageView.mas_bottom).offset(-11);
    }];
    
    [self.messageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userBgImageView.mas_bottom).offset(68);
        make.centerX.equalTo(self.mas_centerX);
        make.width.offset(180);
        make.height.offset(40);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBgView.mas_centerY);
        make.left.equalTo(self.messageBgView.mas_left).offset(5);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.messageBgView.mas_centerX).offset(8);
        make.centerY.equalTo(self.messageBgView.mas_centerY);
    }];
    
    [self.messageRightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.messageBgView.mas_centerY);
        make.right.equalTo(self.messageBgView.mas_right).offset(-15);
        make.width.offset(7);
        make.height.offset(13);
    }];
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMessageRecognizer)];
    [self.messageBgView addGestureRecognizer:tapRecognizer];
    
    self.messageBgView.hidden = YES;
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.anchorPoint = CGPointZero;
    gradientLayer.bounds =  CGRectMake(0, 0, iphoneWidth, 40);
    gradientLayer.position = CGPointZero;
    UIColor * color1 = [UIColor clearColor];
    UIColor * color2 = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2];
    gradientLayer.colors = @[(id)color1.CGColor,(id)color2.CGColor];
    [shadowview.layer addSublayer:gradientLayer];
    [self.headerBgView.layer setBorderColor:HexCOLOR(@"#c9c9c9").CGColor];
    [self.headerBgView.layer setBorderWidth:0.5f];
    self.userNameLabel.shadowColor=[UIColor blackColor];
     self.userNameLabel.shadowOffset = CGSizeMake(0, 1.0f);
}

-(void)binWithModel:(id)model
{
    
 //   WifeButlerUserParty *docParty=[WifeButlerAccount sharedAccount].userParty;
//    NSString *encodeurl=[docParty.partyheadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:encodeurl] placeholderImage:[UIImage imageNamed:@"work_tempPhoto_big"]];
//    self.headerImageView.userInteractionEnabled = YES;
//    self.headerImageView.tag = 0;
//    [self.headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTap:)]];
//    NSString *codeurl=[docParty.spacePhotosUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.userBgImageView sd_setImageWithURL:[NSURL URLWithString:codeurl] placeholderImage:[UIImage imageNamed:@"academic_popview_background"]];
//
//    self.userNameLabel.text = docParty.name;
//    self.userBgImageView.userInteractionEnabled = YES;
//    self.userBgImageView.tag = 1;
//    [self.userBgImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTap:)]];
}

// 点击头像或背景
-(void)headerImageViewTap:(UITapGestureRecognizer *)recognizer
{
    if (self.headerImageViewTapClick) {
        self.headerImageViewTapClick(recognizer);
    }
}

// 点击消息
-(void)tapMessageRecognizer
{
    if (self.tapMessageRecognizerClick) {
        self.tapMessageRecognizerClick();
    }
}

@end
