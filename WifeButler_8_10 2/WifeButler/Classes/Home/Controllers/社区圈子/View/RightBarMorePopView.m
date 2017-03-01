//
//  RightBarMorePopView.m
//  docClient
//
//  Created by GDXL2012 on 15/11/18.
//  Copyright © 2015年 luo. All rights reserved.
//

#import "RightBarMorePopView.h"
//#import "SingleTitlePopCell.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"

#define SeparatorMargin  10.0f

// 菜单选项类型
typedef enum PopCellType{
    kPopCellImgTitle,   // 左边图片，右侧文字
    kPopCellTitle       // 纯文本
}PopCellType;

@interface RightBarMorePopView()<UITableViewDataSource, UITableViewDelegate>{
    MenuPopViewImgType bgImgType;
    PopCellType popCellType;
    UIEdgeInsets contentEdgeInsets;
    UIColor *titleColor;
    CGFloat viewWidth;
}

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imgArray;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign, readwrite) BOOL isPopViewShow;
@end

@implementation RightBarMorePopView
static NSString *SingleTitlePopCellIdentifier = @"SingleTitlePopCellIdentifier";
static NSString *ImgTitlePopCellIdentifier = @"ImgTitlePopCellIdentifier";
static CGFloat itemHeight = 40.0f;
static CGFloat defaultViewWidth = 100.0f;

+(instancetype)morePopViewWithType:(MenuPopViewImgType)type titleArray:(NSArray*)titls imgArray:(NSArray *)imgs{
    return [[RightBarMorePopView alloc] initWithType:type titleArray:titls imgArray:imgs width:defaultViewWidth];
}

+(instancetype)morePopViewWithType:(MenuPopViewImgType)type titleArray:(NSArray*)titls imgArray:(NSArray *)imgs width:(CGFloat)width{
    return [[RightBarMorePopView alloc] initWithType:type titleArray:titls imgArray:imgs width:width];
}

-(instancetype)initWithType:(MenuPopViewImgType)type titleArray:(NSArray*)titls imgArray:(NSArray *)imgs width:(CGFloat)width{
    self = [super init];
    if (self) {
        viewWidth = width;
        bgImgType = type;
        [self initViewDisplay];
        [self setTitleArray:titls withImgArray:imgs];
    }
    return self;
}

-(void)show{
    self.isPopViewShow = YES;
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(window);
    }];
}

-(void)dismissVeiw{
    self.isPopViewShow = NO;
    [self removeFromSuperview];
}

-(void)initViewDisplay{
    self.edgeInsets = UIEdgeInsetsMake(0, SeparatorMargin, 0, SeparatorMargin);
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    if (bgImgType == kMenuPopViewImgBlack) {
        titleColor = [UIColor whiteColor];
    } else { // 其他默认为黑色
        titleColor = [UIColor blackColor];
    }
    self.isPopViewShow = NO;
    self.bgImgView = [[UIImageView alloc] init];
    self.bgImgView.image = [self getDefaultBgImgWithType:bgImgType];
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(64 + 3); // 导航栏和状态栏的高度
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_offset(itemHeight);
    }];
    
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.scrollEnabled = NO;
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuTableView.separatorColor = HexCOLOR(@"#5c5b5d");
    [self addSubview:self.menuTableView];
    
    if ([self.menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.menuTableView setSeparatorInset:self.edgeInsets];
    }
    if ([self.menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.menuTableView setLayoutMargins:self.edgeInsets];
    }
    
    contentEdgeInsets = UIEdgeInsetsMake(7, 0, 1, 0);
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgImgView).insets(contentEdgeInsets);
    }];
}

// more_menu_bg_black ,more_menu_bg_white
-(UIImage *)getDefaultBgImgWithType:(MenuPopViewImgType) type{
    UIImage *image = nil;
    if (bgImgType == kMenuPopViewImgBlack) {
        image = [UIImage imageNamed:@"more_menu_bg_black"];
    } else if(bgImgType == kMenuPopViewImgWhite){
        image = [UIImage imageNamed:@"more_menu_bg_white"];
    } else {
        return nil;
    }
    if (image) {
        // 默认图片高度200 * 94
        CGFloat halfImgHeight = image.size.height / 2;
        CGFloat halfImgWidth = image.size.width / 2;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfImgHeight - SeparatorMargin, halfImgWidth - SeparatorMargin, halfImgHeight + SeparatorMargin, halfImgWidth + SeparatorMargin)];
    }
    return image;
}

/**
 * 设置标题列表，图片列表，如果没有图片传nil
 */
-(void)setTitleArray:(NSArray*)titls withImgArray:(NSArray *)imgs{
    NSInteger count = titls.count;
    if (count > 0) {
        self.titleArray = nil;
        self.titleArray = [[NSArray alloc] initWithArray:titls];
        if (imgs.count > 0) {
            self.imgArray = nil;
            popCellType = kPopCellImgTitle;
            self.imgArray = [[NSArray alloc] initWithArray:imgs];
        } else {
            self.imgArray = nil;
            popCellType = kPopCellTitle;
        }
        [self.bgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(contentEdgeInsets.top + count * itemHeight);
        }];
        self.bgImgView.hidden = NO;
    } else {
        self.titleArray = nil;
        self.imgArray = nil;
        [self.bgImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0.01f);
        }];
        self.bgImgView.hidden = YES;
    }
}

/**
 * 设置菜单选项背景及内容偏移值
 */
-(void)setBgImage:(UIImage *)imge withContenOffSet:(UIEdgeInsets)insets{
    self.bgImgView.image = imge;
    contentEdgeInsets = insets;
    [self.menuTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgImgView).mas_offset(contentEdgeInsets);
    }];
}

/**
 * 设置文本颜色
 */
-(void)setTitleColor:(UIColor *)color{
    titleColor = color;
    if (self.isPopViewShow) {
        [self.menuTableView reloadData];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self dismissVeiw];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return itemHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (popCellType == kPopCellTitle) {
        SingleTitlePopCell *cell = [tableView dequeueReusableCellWithIdentifier:SingleTitlePopCellIdentifier];
        if (!cell) {
            cell  = [[SingleTitlePopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SingleTitlePopCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:self.edgeInsets];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:self.edgeInsets];
            }
        }
        cell.singleLabel.textColor = titleColor;
        cell.singleLabel.textAlignment = NSTextAlignmentCenter;
        cell.singleLabel.text = self.titleArray[indexPath.row];
        return cell;
    } else {
        ImageTitlePopCell *cell = [tableView dequeueReusableCellWithIdentifier:ImgTitlePopCellIdentifier];
        if (!cell) {
            cell = [[ImageTitlePopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImgTitlePopCellIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:systemheaderfont];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:self.edgeInsets];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:self.edgeInsets];
            }
        }
        cell.leftImageView.image = self.imgArray[indexPath.row];
        cell.titleLabel.textColor = titleColor;
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(morePopView:clickAtIndex:)]) {
        [self.delegate morePopView:self clickAtIndex:indexPath.row];
    }
    [self dismissVeiw];
}

@end


@implementation SingleTitlePopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewDisplay];
    }
    return self;
}

-(void)initViewDisplay{
    self.singleLabel = [[UILabel alloc] init];
    self.singleLabel.font = [UIFont systemFontOfSize:systemheaderfont];
    self.singleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.singleLabel];
    [self.singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

@end

@implementation ImageTitlePopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewDisplay];
    }
    return self;
}

-(void)initViewDisplay{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:systemheaderfont];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10.0f);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20.0f, 20.0f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).offset(8);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

@end




#define NeedRedView
#import "UIView+RedView.h"

@implementation RightBarMorePopView (RedView)


- (void)showRediViewAtIndex:(NSUInteger)index
{
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:index inSection:0];
   ImageTitlePopCell * cell = [self.menuTableView cellForRowAtIndexPath:indexpath];
    if ([cell isKindOfClass:[ImageTitlePopCell class]]) {
        [cell layoutIfNeeded];
        [cell.leftImageView showRedViewIfNeeded];
    }
}

- (void)hideRedViewAtIndex:(NSUInteger)index
{
    NSIndexPath * indexpath = [NSIndexPath indexPathForItem:index inSection:0];
    ImageTitlePopCell * cell = [self.menuTableView cellForRowAtIndexPath:indexpath];
    if ([cell isKindOfClass:[ImageTitlePopCell class]]) {
        [cell.leftImageView hideRedViewIfNeeded];
    }
}

@end
