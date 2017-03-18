//
//  MedRefFriendCircleTableCell.m
//  PatientClient
//
//  Created by GDXL2012 on 15/11/24.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import "MedRefFriendCircleTableCell.h"
#import "FontUtils.h"
#import "NSString+Size.h"
#import "CommonCoreTextView.h"
#import "DocFriendModel.h"
#import "DocFriendReviewModel.h"
#import "DocFriendPraiseModel.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"

#define labelFont [UIFont systemFontOfSize:14.0f]  // 字体大小

@interface MedRefFriendCircleTableCell(){
    UIColor *nameColor;     // 名称文字颜色
    UIView *praiseView;  // 点赞背景
    UIImageView *smallImg; //点赞图标
    
    UIImageView *topTriangleImgView; // 上三角
    
    UIView *reviseBgView;
    CommonCoreTextView *reviseView;             // 回复label
    
    float imgRighViewBeginX; // 头像右侧控件x位置
    float contentLabelW;    // 控件宽度
    
    UIView *separatorLineView;
    
    CommonCoreTextView *coreTextView; // 点赞
}
// 点赞按钮数组
@property (nonatomic, strong) NSMutableArray *praiseRangeArray;
// 点赞数据数组
@property (nonatomic, strong) NSArray *praiseModelArray;
// 评论model
@property (nonatomic, strong) DocFriendReviewModel *commentModel;

@end

@implementation MedRefFriendCircleTableCell

static float headImgLeftSpace = 10.0f;
static float headImgW = 40.0f;
static float imgRightSpace = 10.0f; // 头像右侧控件间距
static float viewRightSpace = 10.0f;        // 页面右侧间距

/**
 * 初始化一个空的cell
 */
-(id) initEmptyCellView:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, 0, 0);
    }
    return self;
}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView{
   // nameColor = HexCOLOR(MedRefWordColorNavyBlue);
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    imgRighViewBeginX = headImgLeftSpace + headImgW + imgRightSpace;
    contentLabelW = screenFrame.size.width - imgRighViewBeginX - viewRightSpace;
    topTriangleImgView = [[UIImageView alloc] init];
    topTriangleImgView.image = [UIImage imageNamed:@"academic_top_triangle"];
    [self.contentView addSubview:topTriangleImgView];
    // 尖角图片
    [topTriangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(imgRighViewBeginX + 10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(12, 7));
    }];
    
    // 点赞
    praiseView = [[UIView alloc] init];
    praiseView.backgroundColor = HexCOLOR(CommonContentBackgroundColor);
    [self.contentView addSubview:praiseView];
    [praiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgRighViewBeginX);
        make.top.mas_equalTo(topTriangleImgView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-viewRightSpace);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    smallImg=[[UIImageView alloc] init];
    smallImg.image=[UIImage imageNamed:@"academic_praise_y"];
    [praiseView addSubview:smallImg];
    // 点赞图标
    [smallImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.mas_equalTo(6);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    // 点赞名称
    coreTextView = [[CommonCoreTextView alloc] init];
    [praiseView addSubview:coreTextView];
    [coreTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(praiseView.mas_left).offset(10.0f);
        make.top.mas_equalTo(praiseView.mas_top).offset(4);
        make.right.mas_equalTo(praiseView.mas_right).offset(-10.0f);
        make.bottom.mas_equalTo(praiseView.mas_bottom).offset(-4);
    }];
    
    WEAKSELF
    [coreTextView setDidHighlightTextWithIndexClick:^(NSInteger index) {
        DocFriendPraiseModel *model = weakSelf.praiseModelArray[index];
        [weakSelf didPraiseClickWithPartyId:model.id];
    }];
    
    // 评论背景
    reviseBgView = [[UIView alloc] init];
    reviseBgView.backgroundColor = HexCOLOR(CommonContentBackgroundColor);
    [self.contentView addSubview:reviseBgView];
    [reviseBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgRighViewBeginX);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-viewRightSpace);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    // 评论
    reviseView = [[CommonCoreTextView alloc] init];
    [reviseBgView addSubview:reviseView];
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reviseViewLongRecognizer:)];
    [reviseView addGestureRecognizer:longRecognizer];
    [reviseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.0f);
        make.top.mas_equalTo(reviseBgView.mas_top).offset(2.0);
        make.right.mas_equalTo(-10.0f);
        make.bottom.mas_equalTo(reviseBgView.mas_bottom).offset(-2.0);
    }];
    
    // 点击名字
    [reviseView setDidHighlightTextWithIndexClick:^(NSInteger index) {
        if (index == 0) {
            [weakSelf didPraiseClickWithPartyId:weakSelf.commentModel.id];
        }else{
            [weakSelf didPraiseClickWithPartyId:weakSelf.commentModel.argued_id];
        }
    }];
    // 点击其他区域
    [reviseView setDidOtherTextClick:^{
        if (weakSelf.didCommentClick) {
            weakSelf.didCommentClick();
        }
    }];
    
    
    separatorLineView = [[UIView alloc] init];
    separatorLineView.backgroundColor = WifeButlerSeparateLineColor;
    [self.contentView addSubview:separatorLineView];
    [separatorLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgRighViewBeginX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-viewRightSpace);
        make.height.mas_equalTo(0.5);
    }];
    
}

// 点击回复人名称
-(void)commentButtonClick
{
    if (self.didNameClick) {
        self.didNameClick(self.commentModel.id);
        NSLog(@"点击回复人名称");
    }
}

// 点击被回复人名称
-(void)replyButtonClick
{
    if (self.didNameClick) {
        self.didNameClick(self.commentModel.argued_id);
        NSLog(@"点击被回复人名称");
    }
}


-(NSMutableArray *)praiseRangeArray
{
    if (_praiseRangeArray == nil) {
        _praiseRangeArray = [NSMutableArray array];
    }
    return _praiseRangeArray;
}

/**
 * 获取回复内容view高度
 */
+(NSInteger) getHeadSectionRowHeightWithModel:(DocFriendReviewModel *) personInfoModel  atIndexPath:(NSIndexPath *)indexPath{
    float height = 0.0f;
    CGFloat textHig = [CommonCoreTextView getArrtibutedStrHeightWith:personInfoModel.contentAttributed coreTextViewWidth:iphoneWidth - 90];
    if (indexPath.row == 0) {
        height = textHig + 4 + 10;
    } else {
        height = textHig + 4;
    }
    return height;
}

/**
 * 获取点赞内容view高度
 */
+(NSInteger)getHeadSectionRowHeightWithPraiseArray:(DocFriendModel *)model
{
    return [CommonCoreTextView getArrtibutedStrHeightWith:model.praiseAttributed coreTextViewWidth:iphoneWidth - 90] + 8 + 7 + 3;
}

/**
 * 设置分割线隐藏
 */
-(void) setSeparatorLineViewHidden:(BOOL)hidden{
    separatorLineView.hidden = hidden;
}

/**
 * 设置点赞列表
 */
-(void) setPraiseArray:(DocFriendModel *)model atIndexPath:(NSIndexPath *)indexPath {
    praiseView.hidden = NO;
    reviseBgView.hidden = YES;
    topTriangleImgView.hidden = NO;
    [topTriangleImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(3);
    }];
    
    self.praiseModelArray = model.some;

    [coreTextView binWithAttributeStr:model.praiseAttributed selectRangeArray:model.praiseRangeArray];

}

/**
 * 设置回复消息
 */
-(void) setReviseModel:(DocFriendReviewModel *) personInfoModel atIndexPath:(NSIndexPath *)indexPath{
    self.commentModel = personInfoModel;
    praiseView.hidden = YES;
    reviseBgView.hidden = NO;
    if (indexPath.row == 0) {
        topTriangleImgView.hidden = NO;
        [topTriangleImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(3);
        }];
        [reviseBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        }];
    } else {
        topTriangleImgView.hidden = YES;
        [topTriangleImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(-10);
        }];
        [reviseBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
        }];
    }
    [reviseView binWithAttributeStr:personInfoModel.contentAttributed selectRangeArray:personInfoModel.rangeArray];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - 评论长按事件
-(void)reviseViewLongRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]){
        return;
    }
    
 //   UIMenuItem *collectionItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(didCollectionClick)];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(didCopyClick)];
 //   UIMenuItem *reportItem = [[UIMenuItem alloc] initWithTitle:@"投诉" action:@selector(didReportClick)];
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    if ([self.commentModel.id isEqualToString:@"" ]) { // 是自己的评论
//        [menuController setMenuItems:@[collectionItem,copyItem]];
//    }else{
//        [menuController setMenuItems:@[collectionItem,copyItem,reportItem]];
//    }
    
    [menuController setMenuItems:@[copyItem]];
    [menuController setTargetRect:CGRectInset(recognizer.view.frame, 0.0f, 4.0f) inView:self];
    [menuController setMenuVisible:YES animated:YES];
    reviseBgView.backgroundColor = WifeButlerGaryTextColor3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuItemControllerDidHideClick) name:UIMenuControllerDidHideMenuNotification object:nil];
}

// MenuController消失
-(void)menuItemControllerDidHideClick
{
    reviseBgView.backgroundColor = HexCOLOR(CommonContentBackgroundColor);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

// 点击收藏
-(void)didCollectionClick
{
    if (self.didCollectionItemClick) {
        self.didCollectionItemClick(self.commentModel);
    }
}

// 点击复制
-(void)didCopyClick
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.commentModel.content];
}

// 点击投诉
-(void)didReportClick
{
    if (self.didReportItemClick) {
        self.didReportItemClick(self.commentModel);
    }
}

// 点击删除
-(void)didDeleteClick
{
    if (self.didDeleteItemClick) {
        self.didDeleteItemClick();
    }
}

// 点击点赞人名称
-(void)didPraiseClickWithPartyId:(NSString *)partyId
{
    if (self.didNameClick) {
        self.didNameClick(partyId);
        NSLog(@"点击点赞人名称");
    }
}

#pragma mark - menu
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(didCopyClick) || action == @selector(didDeleteClick) || action == @selector(didCollectionClick) || action == @selector(didReportClick)) {
        return YES;
    }
    return  NO;
}

@end
