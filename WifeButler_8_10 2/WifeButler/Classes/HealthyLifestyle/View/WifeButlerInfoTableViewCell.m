//
//  WifeButlerInfoTableViewCell.m
//  WifeButler
//
//  Created by 李庄子 on 2017/2/26.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "WifeButlerInfoTableViewCell.h"
#import "ZTJianKangShenHuoBottomModel.h"
#import "Masonry.h"

typedef NS_ENUM(NSUInteger, WifeButlerInfoTableViewCellShowType) {
    
    WifeButlerInfoTableViewCellShowTypeNopicture = 0,
    WifeButlerInfoTableViewCellShowTypeOnepicture = 1,
    WifeButlerInfoTableViewCellShowTypeManypictures = 2,
};

@interface WifeButlerInfoTableViewCell ()
/**标题*/
@property (nonatomic,weak) UILabel * titleLabel;
/**内容*/
@property (nonatomic,weak) UILabel * contentLabel;
/**日期*/
@property (nonatomic,weak) UILabel * dateLabel;
/**阅读次数*/
@property (nonatomic,weak) UILabel * readTimeLabel;

/**图像的容器*/
@property (nonatomic,weak) UIView * imageBackView;

@property (nonatomic,assign) WifeButlerInfoTableViewCellShowType showType;

@end

@implementation WifeButlerInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.numberOfLines = 0;
        titleLabel.preferredMaxLayoutWidth = iphoneWidth - 20;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UILabel * contentLabel = [[UILabel alloc]init];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor lightGrayColor];
        contentLabel.numberOfLines = 0;
        contentLabel.preferredMaxLayoutWidth = iphoneWidth - 20;
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        UILabel * dateLabel = [[UILabel alloc]init];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
        UILabel * readTimeLabel = [[UILabel alloc]init];
        readTimeLabel.font = [UIFont systemFontOfSize:13];
        readTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:readTimeLabel];
        self.readTimeLabel = readTimeLabel;
        
        UIView * imageBackView = [[UIView alloc]init];
        [self.contentView addSubview:imageBackView];
        self.imageBackView = imageBackView;
        
    }
    return self;
}

- (void)MASLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(self.contentLabel.mas_left);
    }];
    
    [self.readTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
    }];
    
    [self.imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(60);
    }];
}

- (void)setModel:(ZTJianKangShenHuoBottomModel *)model
{
    _model = model;
    
    //赋值数据
    self.titleLabel.text = model.name;
    self.contentLabel.text = model.alt;
    self.readTimeLabel.text = [NSString stringWithFormat:@"阅读次数:%@次",model.readnum];
    self.dateLabel.text = model.time;
    
    NSUInteger currentCount = self.imageBackView.subviews.count;
    NSUInteger modelCount = _model.imageURLStrs.count;
    
    //处理图片的显示隐藏
    [self dealImageShowWithcurrentCount:currentCount andModelCount:modelCount];
    //加载图片
    [self showImageViewWithArray:_model.imageURLStrs];
    //处理布局
    [self dealTheLayoutWithCurrentCount:currentCount andModelCount:modelCount];
    
    [self layoutIfNeeded];
    
    model.cellHeigh = CGRectGetMaxY(self.dateLabel.frame)+ 10;
}


/**处理布局*/
- (void)dealTheLayoutWithCurrentCount:(NSUInteger)currentCount andModelCount:(NSUInteger)modelCount
{
    if (modelCount == 1) { //如果只有一个
        self.showType = WifeButlerInfoTableViewCellShowTypeOnepicture;
        
        UIImageView * imageView = self.imageBackView.subviews[0];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.imageBackView);
        }];
        
    }else if(modelCount == 0){ //没有图片
        self.showType = WifeButlerInfoTableViewCellShowTypeNopicture;
        
        for (int i = 0; i<currentCount; i++) {
            
            UIImageView * imageView = self.imageBackView.subviews[0];
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(0);
                make.top.mas_equalTo(self.imageBackView.mas_top);
                make.left.mas_equalTo(i*60+10);
            }];
        }
    }else{  //大于1张图片
        
        self.showType = WifeButlerInfoTableViewCellShowTypeManypictures;
        
        for (int i = 0; i<modelCount; i++) {
            
            UIImageView * imageView = self.imageBackView.subviews[i];
            
            [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(60);
                make.top.mas_equalTo(self.imageBackView.mas_top);
                make.left.mas_equalTo(i*(60+10)+10);
            }];
        }
    }
    [self updateOtherConstraints];
}

- (void)updateOtherConstraints{
    
    
    [self.imageBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        if (self.showType == WifeButlerInfoTableViewCellShowTypeNopicture) {
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        }else {
            if (self.showType == WifeButlerInfoTableViewCellShowTypeOnepicture)
                make.top.mas_equalTo(self.mas_top).offset(15);
            else make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
            
            make.height.mas_equalTo(60);
        }
    }];

    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (self.showType == WifeButlerInfoTableViewCellShowTypeOnepicture)
            make.top.mas_equalTo(self.mas_top).offset(85);
        else make.top.mas_equalTo(self.mas_top).offset(15);
        
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (self.showType == WifeButlerInfoTableViewCellShowTypeManypictures) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(75);
        }else{
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
        }
        make.left.mas_equalTo(self.contentLabel.mas_left);
    }];
    
    [self.readTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (self.showType == WifeButlerInfoTableViewCellShowTypeManypictures)
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(75);
        else make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
        
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
}


/**控制图片的显示或因隐藏*/
- (void)dealImageShowWithcurrentCount:(NSUInteger)currentCount andModelCount:(NSUInteger)modelCount
{
    if (currentCount < modelCount) { //当前的少 再创造
        
        for (int i = 0; i<currentCount; i++) {
            
            UIImageView * imageView = self.imageBackView.subviews[i];
            imageView.hidden = NO;
        }
        
        for (NSUInteger i = currentCount; i<modelCount; i++) {
            
            UIImageView * imageView = [[UIImageView alloc]init];
            [self.imageBackView addSubview:imageView];
            
        }
        
    }else{ //如果当前的多于模型的 则多余的隐藏
        if (currentCount != modelCount) {
            
            for (NSUInteger i = currentCount - 1; i>modelCount; i--) {
                
                UIImageView * imageView = self.imageBackView.subviews[i];
                imageView.hidden = YES;
            }
        }
        
    }
}

/**加载图片*/
- (void)showImageViewWithArray:(NSArray *)imageUrls
{
    for (int i  = 0; i<imageUrls.count; i++) {
        UIImageView * imageView = self.imageBackView.subviews[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrls[i]] placeholderImage:nil];
    }
}

@end
