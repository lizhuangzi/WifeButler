//
//  HealthCircleTableHeaderView.m
//  PatientClient
//
//  Created by GDXL2012 on 15/11/23.
//  Copyright © 2015年 ikuki. All rights reserved.
//

#import "MedRefFriendCircleTableHeader.h"
#import "DocFriendHeaderModel.h"
//#import "CommonImagePreview.h"
#import "FontUtils.h"
//#import "NSDate+DocStandTime.h"
#import <CoreText/CoreText.h>
//#import "UIView+Preview.h"
#import "Masonry.h"
#import "WifeButlerDefine.h"

@interface MedRefFriendCircleTableHeader (){
    NSArray *imgUrlArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerView;  // 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;        // 姓名
@property (weak, nonatomic) IBOutlet UIImageView *relationImgIco; // 关注关系类型标识图标
@property (weak, nonatomic) IBOutlet UILabel *enumFKLabel; // 发起内容类型
@property (weak, nonatomic) IBOutlet UILabel *contentLabel; // 分享内容文本
@property (weak, nonatomic) IBOutlet UIView *imgBgView;  // 图片背景
@property (weak, nonatomic) IBOutlet UIView *otherContentBgView; // 其他类型内容背景
@property (weak, nonatomic) IBOutlet UILabel *otherContentTitleLabel; // 分享内容标题
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间
@property (weak, nonatomic) IBOutlet UIButton *opButton; // 操作按钮
@property (weak, nonatomic) IBOutlet UIImageView *originalHeaderView; // 作者头像
@property (weak, nonatomic) IBOutlet UIButton *forwardNameButton;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton; // 显示全文
@property (weak, nonatomic) IBOutlet UIButton *delDataBtn; // 删除按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherContentBgViewTopSpace;

@property (nonatomic, strong) NSMutableArray *imgViewArray;

@property (nonatomic, strong) NSMutableArray *showImgViewArray; // view中显示的图片

@property (nonatomic, copy) NSString *collectionType;

@property (nonatomic, copy) NSString *collectionImgUrl;

@property (nonatomic, strong) DocFriendHeaderModel *workModel;


@end

@implementation MedRefFriendCircleTableHeader

static float headImgLeftSpace = 10.0f;
static float topSpace = 15.0f;
static float headImgW = 40.0f;

static float nameLabelH = 19.0f; // 姓名label高度

static float nameLabelRightSpace = 10.0f; // 名称右侧控件间距
static float viewRightSpace = 10.0f;        // 页面右侧间距
static float imageSpace = 5.0f;   // 图片间隙

static float attachmentViewHDefault = 50.0f; // 显示文章等时附件区域高度
static float dateViewH = 23.0f;        // 时间区域高度

static float showAllBtnHig = 15;  // 全文按钮高度;

static float commonVerticalSpace = 8.0f; // 8为控件显示间距



/**
 * 获取view高度
 */
+(CGFloat) getHeadSectionHeadHeight:(DocFriendHeaderModel *) model{
    
    CGFloat height = 0;
    // 原244 = 320 - 56 - 20替换
    float contentViewFrameW = iphoneWidth - headImgLeftSpace - headImgW - nameLabelRightSpace -viewRightSpace;
    height = topSpace + nameLabelH;
    
    // 标题内容
    NSString *contentStr = model.content;
    
    CGFloat showBtnAndSpaceHig = showAllBtnHig + commonVerticalSpace;
    if (contentStr.length>0) { // 内容高度
        CGSize size = [[MedRefFriendCircleTableHeader setContentAttributed:model.content isGetHig:YES] boundingRectWithSize:CGSizeMake(contentViewFrameW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        if (size.height > AttributedStrHIG) { // 超过6行 需要显示全文按钮
            if (model.isShowAll) { // 显示全文
                model.showAllBtnHidden = YES;
            }else{  // 不显示全文 显示6行
                size.height = AttributedStrHIG;
                model.showAllBtnHidden = YES;
            }
        }else{ // 没有超过6行 不需要显示全文按钮
            model.showAllBtnHidden = NO;
            showBtnAndSpaceHig = 0;
        }

        height = height + commonVerticalSpace + size.height + 1.0f; //
    }else{ // 标题内容为空
        height = height + 1.0f;
        showBtnAndSpaceHig = 0;
        model.showAllBtnHidden = NO;
    }
    
    if (model.chtTypeEnum){
        if (model.imagesPath.length>0) {
            float attachmentViewH = 0.0f;
            NSInteger count =[model.imagesPath componentsSeparatedByString:@","].count;
            contentViewFrameW = iphoneWidth - (headImgLeftSpace + headImgW + viewRightSpace) * 2;
            switch (count) {
                case 1:
                    attachmentViewH = (contentViewFrameW - imageSpace) / 2;
                    break;
                case 2:
                    attachmentViewH = (contentViewFrameW - imageSpace) / 2.5;
                    break;
                case 4:
                    attachmentViewH = (contentViewFrameW - imageSpace) / 2.5 * 2 + imageSpace;
                    break;
                default:
                    if (count % 3 == 0) { // 3整数倍
                        attachmentViewH = (contentViewFrameW - imageSpace * 2) / 3 * (count / 3) + (count / 3 - 1) * imageSpace;
                    } else {
                        attachmentViewH = (contentViewFrameW - imageSpace * 2) / 3 * (count / 3 + 1) + (count / 3) * imageSpace;
                    }
                    break;
            }
            height = height + commonVerticalSpace + attachmentViewH + showBtnAndSpaceHig;
        } else {  // 没有图片
            height = height + 1 + showBtnAndSpaceHig ; // +1为图片背景最小高度
            if (!model.showAllBtnHidden) { // 如果不显示全文按钮
                height += commonVerticalSpace;
            }
        }
    } else {
        height = height + commonVerticalSpace + attachmentViewHDefault + showBtnAndSpaceHig;
    }
    height = height + dateViewH;
    return height; // 修正float型计算误差
}

-(NSMutableArray *)imgViewArray{
    if (!_imgViewArray) {
        _imgViewArray = [NSMutableArray array];
    }
    return _imgViewArray;
}

-(NSMutableArray *)showImgViewArray
{
    if (_showImgViewArray == nil) {
        _showImgViewArray = [NSMutableArray array];
    }
    return _showImgViewArray;
}

// 设置行间距
+ (NSMutableAttributedString *)setContentAttributed:(NSString *)content isGetHig:(BOOL)isGetHig
{
    
    NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc]initWithAttributedString:[FontUtils stringWithWeChatFriendCircleStyleString:content isGetHig:isGetHig]];
    return attrStr;
}


/**
 * 设置显示数据
 *  @param model
 */
-(void) setWorkmodel:(DocFriendHeaderModel *) model atSection:(NSInteger) section{
    self.currentSection = section;
    self.workModel = model;
    // 头像
    NSString *encodeurl=[model.caseHisTopHeadurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:encodeurl] placeholderImage:[UIImage imageNamed:@"work_tempPhoto"]];
    //名称
    self.nameLabel.text = model.caseHisTopName;
    // 关注类型：bothWayConcern, 单向关注：oneWayConcern，好友：friend
    if([model.relation isEqualToString:@"bothWanyConcern"]){
        self.relationImgIco.hidden = NO;
        [self.relationImgIco setImage:[UIImage imageNamed:@"double_attention"]];
        [self.enumFKLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            // 图片宽度+左右间距
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5.0f + 15.0f + 5.0f);
        }];
    } else if([model.relation isEqualToString:@"oneWayConcern"]){
        self.relationImgIco.hidden = NO;
        [self.relationImgIco setImage:[UIImage imageNamed:@"unidirectional_attention"]];
        [self.enumFKLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            // 图片宽度+左右间距
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5.0f + 15.0f + 5.0f);
        }];
    } else {
        self.relationImgIco.hidden = YES;
        [self.enumFKLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            // 图片宽度+左右间距
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5.0f);
        }];
    }
    self.enumFKLabel.text = @"哈哈";
    if (model.forwardPartyId.length == 0) { // 非转发
        self.forwardNameButton.hidden = YES;
    } else { // 转发
        self.forwardNameButton.hidden = NO;
        CGSize size = [FontUtils stringSize:model.forwardPartyName withSize:CGSizeMake(MAXFLOAT, 22.0f) font:self.enumFKLabel.font];
        [self.forwardNameButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(size.width + 10);
        }];
    }
    // 标题内容
    NSString *contentStr = model.content;
    if (contentStr.length == 0) {
        self.contentLabel.text = @"";
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(- 1.0f);
        }];
    } else {
        self.contentLabel.attributedText = [MedRefFriendCircleTableHeader setContentAttributed:contentStr isGetHig:NO];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(commonVerticalSpace);
        }];
    }
    
    // 是否显示全文按钮
    CGFloat showBtnAndSpaceHig = showAllBtnHig + commonVerticalSpace;
    if (model.showAllBtnHidden) {  // 显示按钮
        self.showAllButton.hidden = NO;
        if (model.isShowAll) {  // 显示全文
            self.contentLabel.numberOfLines = 0;
            [self.showAllButton setTitle:@"收起" forState:UIControlStateNormal];
        }else{  // 只显示6行
            self.contentLabel.numberOfLines = 6;
            [self.showAllButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    }else{  // 不显示按钮
        showBtnAndSpaceHig = 0;
        self.showAllButton.hidden = YES;
        self.contentLabel.numberOfLines = 0;
    }

    
    // cell中内容宽度 56左侧间距，10右间距
    // 原244 = 320 - 56 - 20替换
    float contentViewFrameW = iphoneWidth - headImgLeftSpace - headImgW - nameLabelRightSpace -viewRightSpace;
    if (model.chtTypeEnum) {
        self.otherContentBgView.hidden = YES;
        
        if (model.imagesPath.length > 0) {
            // 有图片
            self.imgBgView.hidden = NO;
            [self.imgBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(commonVerticalSpace + showBtnAndSpaceHig);
            }];
            
            contentViewFrameW = iphoneWidth - (headImgLeftSpace + headImgW + viewRightSpace) * 2;
            
            imgUrlArray = [model.imagesPath componentsSeparatedByString:@","];
            [self createImgViews];
            NSInteger arrayCount = imgUrlArray.count;
            float imageW = 0.0f;
            float datX = 0.0f;
            int divisor = 1;
            float attachmentViewH = 0.0f;
            switch (arrayCount) {
                case 1:
                    imageW = (contentViewFrameW - imageSpace) / 2;
                    datX = 0.0f;
                    divisor = 1;
                    attachmentViewH = imageW;
                    break;
                case 2:
                    imageW = (contentViewFrameW - imageSpace) / 2.5;
                    datX = imageW + imageSpace;
                    divisor = 2;
                    attachmentViewH = imageW;
                    break;
                case 4:
                    imageW = (contentViewFrameW - imageSpace) / 2.5;
                    datX = imageW + imageSpace;
                    divisor = 2;
                    attachmentViewH = imageW * 2 + imageSpace;
                    break;
                default:
                    imageW = (contentViewFrameW - imageSpace * 2) / 3;
                    datX = imageW + imageSpace;
                    divisor = 3;
                    if (arrayCount % 3 == 0) { // 3整数倍
                        attachmentViewH = imageW * (arrayCount / 3) + (arrayCount / 3 - 1) * imageSpace;
                    } else {
                        attachmentViewH = imageW * (arrayCount / 3 + 1) + (arrayCount / 3) * imageSpace;
                    }
                    break;
            }
            [self.showImgViewArray removeAllObjects]; // 删除之前显示的view
            NSInteger allImgCount = self.imgViewArray.count;
            for (int i=0; i<allImgCount; i++) {
                UIImageView *imgView = self.imgViewArray[i];
                if (i < arrayCount) {
                    CGRect rect = CGRectMake(i % divisor * datX, i / divisor * datX, imageW, imageW);
                    imgView.hidden = NO;
                    imgView.frame = rect;
                    imgView.tag = i;
                    NSString *encodeurl=[imgUrlArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [imgView sd_setImageWithURL:[NSURL URLWithString:encodeurl] placeholderImage:[UIImage imageNamed:@"work_backGrd"]];
                    [self.showImgViewArray addObject:imgView];
                }else{      // 多余的图片不显示
                    imgView.hidden = YES;
                }
            }
        } else {
            // 没有图片，不需要间距
            [self.imgBgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentLabel.mas_bottom);
            }];
            self.imgBgView.hidden = YES;
        }
        
    } else {
        self.imgBgView.hidden = YES;
        self.otherContentBgView.hidden = NO;
        self.otherContentBgViewTopSpace.constant = commonVerticalSpace + showBtnAndSpaceHig;
        // 文章标题label宽度
        self.otherContentTitleLabel.text=model.articleTitle;
        NSString *encodeurl=[model.articleAuthorIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodeurl];
        if ([model.chtTypeEnumFK isEqualToString:@"会议"]) {
            [self.originalHeaderView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"talk_subject_picture"]];
        }else{
            [self.originalHeaderView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"work_tempPhoto"]];
        }

    }
    // 时间
    NSString *newTime = model.createdStamp;//formatTime:model.createdStamps];
    self.timeLabel.text = newTime;
     if ([model.partyId isEqualToString:@""]) {
          // 自己发表的动态 可以删除
         self.delDataBtn.hidden=NO;
      }
     else
       { // 好友发布的动态  不可以删除
        self.delDataBtn.hidden=YES;
    }
}

// 创建imgView
-(void)createImgViews
{
    NSInteger imgViewCount = self.imgViewArray.count;
    NSInteger imgUrlCount = imgUrlArray.count;
    if (imgViewCount < imgUrlCount) {
        for (int i = 0; i < imgUrlCount - imgViewCount; i++) {
            UIImageView *view = [[UIImageView alloc] init];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view.userInteractionEnabled = YES;
            view.hidden = YES;
            UITapGestureRecognizer *recoginizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewClick:)];
            [view addGestureRecognizer:recoginizer];
            UILongPressGestureRecognizer *longTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapRecognizerClick:)];
            [view addGestureRecognizer:longTapRecognizer];
            [self.imgBgView addSubview:view];
            [self.imgViewArray addObject:view];
        }
    }
}


#pragma mark - 点击事件
//点击头像
-(void)headerImgClick:(UITapGestureRecognizer *)tapGesture{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    if(self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:pushPhotoAlbumWithPartyId:)]){
        [self.delegate tableHeaderView:self pushPhotoAlbumWithPartyId:self.workModel.partyId];
    }
}


// 点击全文
- (IBAction)showAllButtonClick:(id)sender {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    self.workModel.isShowAll = !self.workModel.isShowAll;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:showAllClickAtSection:)]) {
        [self.delegate tableHeaderView:self showAllClickAtSection:self.currentSection];
    }

}

/**
 * 图片点击
 */
-(void)imgViewClick:(UITapGestureRecognizer *)tapGesture{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    NSInteger index = tapGesture.view.tag;
    // 图片预览
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.workModel.partyId forKey:@"coverPartyId"];
    
//    [self showWithImageViews:self.showImgViewArray selectedView:self.showImgViewArray[index] type:kPreviewTypeDefult infoDict:dict];
}
/**
 * 图片长按
 */
-(void)longTapRecognizerClick:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]){
        return;
    }
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *collectionItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(didCollectionClick)];
    [menuController setMenuItems:@[collectionItem]];
    [menuController setTargetRect:CGRectInset(recognizer.view.frame, 0.0f, 4.0f) inView:self.imgBgView];
    [menuController setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuItemControllerDidHideClick) name:UIMenuControllerDidHideMenuNotification object:nil];
    self.collectionType = @"图片";
    self.collectionImgUrl = imgUrlArray[recognizer.view.tag];
}

/**
 * 分享内容点击事件触发
 */
- (IBAction)otherContentButtonClick:(id)sender {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:itemClickAtSection:)]) {
        [self.delegate tableHeaderView:self itemClickAtSection:self.currentSection];
    }
}

/**
 * 操作按钮点击
 */
- (IBAction)opButtonClick:(UIButton *)sender {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:markClickAtSection:withClickView:)]) {
        [self.delegate tableHeaderView:self markClickAtSection:self.currentSection withClickView:sender];
    }
}

// 删除按钮点击
- (IBAction)delectButtonClick:(id)sender {
    [self resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:delectClickAtSection:)]) {
        [self.delegate tableHeaderView:self delectClickAtSection:self.currentSection];
    }
}
// 作者头像点击
- (IBAction)authorButtonClick:(id)sender {
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:authorClickAtSection:)]) {
        [self.delegate tableHeaderView:self authorClickAtSection:self.currentSection];
    }
}
// 转发对象名称点击
- (IBAction)forwarNameButtonClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableHeaderView:forwardNameClickAtSection:)]) {
        [self.delegate tableHeaderView:self forwardNameClickAtSection:self.currentSection];
    }
}

-(void)awakeFromNib{
    self.originalHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    self.originalHeaderView.clipsToBounds = YES;
    // 添加头像点击手势
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImgClick:)];
    [self.headerView addGestureRecognizer:tapGesture];
    self.timeLabel.font = ThinFont(12);
    
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:AttributedStrSize];
    self.enumFKLabel.font = ThinFont(AttributedStrSize);
    self.contentLabel.font = ThinFont(AttributedStrSize);
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLongRecognizer:)];
    [self.contentLabel addGestureRecognizer:recognizer];
    self.contentLabel.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *otherViewRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(contentLongRecognizer:)];
    [self.otherContentBgView addGestureRecognizer:otherViewRecognizer];
    
}


#pragma mark - 长按事件
// 长按内容
-(void)contentLongRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]){
        return;
    }
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(didCopyItemClick)];
    UIMenuItem *collectionItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(didCollectionClick)];
    UIMenuItem *forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(didForwardClick)];
    UIMenuItem *complaintItem = [[UIMenuItem alloc] initWithTitle:@"投诉" action:@selector(didComplaintClick)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if ([recognizer.view isKindOfClass:[UILabel class]]) { // 长按文字内容
        self.collectionType = @"文字";
//        self.contentLabel.backgroundColor = HexCOLOR(MedRefWordColorLongRecognizerGray);
        if ([self.workModel.partyId isEqualToString:@""]) { // 是自己发布的
            [menuController setMenuItems:@[copyItem,collectionItem]];
        }else{  // 不是自己发布的
            [menuController setMenuItems:@[copyItem,collectionItem,forwardItem,complaintItem]];
        }
    }else{      // 长按分享内容
        self.collectionType = @"链接";
//        self.otherContentBgView.backgroundColor = HexCOLOR(MedRefWordColorLongRecognizerBlue);
        if ([self.workModel.partyId isEqualToString:@""]) {
            [menuController setMenuItems:@[collectionItem]];
        }else{
            [menuController setMenuItems:@[collectionItem,forwardItem,complaintItem]];
        }
    }
    
    [menuController setTargetRect:CGRectInset(recognizer.view.frame, 0.0f, 4.0f) inView:self];
    [menuController setMenuVisible:YES animated:YES];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuItemControllerDidHideClick) name:UIMenuControllerDidHideMenuNotification object:nil];
}

// 长按分享内容框
-(void)otherViewLongRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]){
        return;
    }
    
    UIMenuItem *collectionItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(didCollectionClick)];
    UIMenuItem *complaintItem = [[UIMenuItem alloc] initWithTitle:@"投诉" action:@selector(didComplaintClick)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuItems:@[collectionItem,complaintItem]];
    [menuController setTargetRect:CGRectInset(recognizer.view.frame, 0.0f, 4.0f) inView:self];
    [menuController setMenuVisible:YES animated:YES];
//    self.otherContentBgView.backgroundColor = HexCOLOR(MedRefWordColorLongRecognizerBlue);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuItemControllerDidHideClick) name:UIMenuControllerDidHideMenuNotification object:nil];
}

// MenuController消失
-(void)menuItemControllerDidHideClick
{
    
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.otherContentBgView.backgroundColor = HexCOLOR(CommonContentBackgroundColor);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    [self resignFirstResponder];
}

#pragma mark - menu
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(didCopyItemClick) || action == @selector(didComplaintClick) || action == @selector(didCollectionClick) || action == @selector(didForwardClick)) {
        return YES;
    }
    return  NO;
}

// 点击复制
-(void)didCopyItemClick
{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:self.contentLabel.text];
    NSLog(@"复制..");
}

// 点击收藏
-(void)didCollectionClick
{
    if (self.didCollectionItemClick) {
        self.didCollectionItemClick(self.collectionType,self.collectionImgUrl,self.workModel);
        NSLog(@"收藏..");
    }
}

// 点击转发
-(void)didForwardClick
{
    if (self.didForwardItemClick) {
        self.didForwardItemClick(self.collectionType,self.workModel);
        NSLog(@"转发..");
    }
}

// 点击投诉
-(void)didComplaintClick
{
    if (self.didReportItemClick) {
        self.didReportItemClick(self.workModel);
        NSLog(@"投诉..");
    }
}


@end
