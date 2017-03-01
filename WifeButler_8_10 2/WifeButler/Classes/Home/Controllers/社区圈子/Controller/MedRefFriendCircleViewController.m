//
//  HealthCircleViewController.m
//  PatientClient
//
//  Created by GDXL2012 on 15/11/23.
//  Copyright © 2015年 ikuki. All rights reserved.
//  2016.3.17 常见 修改替换图片上传代码

#import "MedRefFriendCircleViewController.h"
#import "MedRefFriendCircleTableHeader.h"
#import "MedRefFriendCircleTableCell.h"
#import "DocFriendHeaderView.h"
#import "FriendCircleMarkPopView.h"
#import "CommentView.h"
#import "RightBarMorePopView.h"
#import "CSActionSheet.h"
#import "ImagePickerUtils.h"
#import "ImageUtils.h"

#import "DocFriendModel.h"
#import "DocFriendHeaderModel.h"
#import "DocFriendReviewModel.h"
#import "DocFriendPraiseModel.h"

#import "WifeButlerDefine.h"
#import "WifeButlerLoadingTableView.h"
#import "WifeButlerNetWorking.h"
#import "Masonry.h"

@interface MedRefFriendCircleViewController ()<UITableViewDataSource, UITableViewDelegate,WifeButlerloadingTableViewDelegate, MedRefFriendCircleTableHeaderDelegate, CSActionSheetDelegate, FriendCircleMarkPopViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RightBarMorePopViewDelegate>{
    int currentPage;
    NSArray *titleArray;
    NSArray *icoArray;
    NSDictionary *selectorDic;
    
    // 弹出框相关参数
    NSInteger userPraiseIndex;      // 点赞列表中用户点赞位置
    NSString *caseHisTopRevId;      // 用户点赞id
    BOOL isPraise;  // 是否点赞
    
}
@property (weak, nonatomic) IBOutlet WifeButlerLoadingTableView *friendCircleTableView;
// 数据列表
@property(nonatomic, strong) NSMutableArray *dataSource;
// cell 头部高度
@property(nonatomic, strong) NSMutableArray *headerHeightArray;

@property (nonatomic, assign) NSInteger currentOpSection; // 当前操作组，为数据源中实际位置，对应tableview需要+1

@property (nonatomic, retain) NSIndexPath *currentOpIndexPath; // 将要操作位置,为列表中实际位置，对应数据源section需要-1

@property (nonatomic, strong) NSArray *moreTitlesArray;
@property (nonatomic, strong) NSArray *moreTitlesIcoArray;
// @回复人的提示语
@property (nonatomic, copy) NSString *commentPlaceholder;
// @回复人的评论Id
@property (nonatomic, strong) DocFriendReviewModel *replyModel;
// 点击全文按钮时的位置
@property (nonatomic, assign) CGFloat selectOffect;

@end

@implementation MedRefFriendCircleViewController
static NSString *cellIndentifier = @"HeaderFirstTableViewCell";
static NSString *DocFriendHeaderViewIndentifier = @"DocFriendHeaderViewIndentifier";

static NSString *commentString = @"评论";
static NSString *cancelPraise = @"取消";
static NSString *setPraise = @"赞";
static NSString *deleteDynamic = @"删除"; // 删除动态
static NSString * repeatDynamic = @"转发";

-(void)dealloc
{
    NSLog(@"学术圈销毁!");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMemberVariable];
    
    [self initNavigationBar];
    
    [self initViewDisplay];
    
    [self startApplicationRequest:YES];
}

-(void)initNavigationBar{
    self.title = @"学术圈";
}

-(void)initMemberVariable{

    currentPage = 1;
    self.headerHeightArray = [NSMutableArray array];
    self.dataSource = [NSMutableArray array];
    selectorDic = @{commentString: @"publishCommentClick",
                    cancelPraise: @"cancelPraise",
                    setPraise: @"setPraise",
                    repeatDynamic:@"repeatDynamic"};
}

-(void)initViewDisplay{
    UINib *headerNib = [UINib nibWithNibName:@"MedRefFriendCircleTableHeader" bundle:[NSBundle mainBundle]];
    [self.friendCircleTableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:MedRefFriendCircleTableHeaderIdentifier];
    self.friendCircleTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

-(void)rightBarButtonClick{
    RightBarMorePopView *menuPopView = [RightBarMorePopView morePopViewWithType:kMenuPopViewImgBlack titleArray:self.moreTitlesArray imgArray:self.moreTitlesIcoArray width:123];
    menuPopView.delegate = self;
    [menuPopView show];
}

#pragma mark - 右侧更多按钮
-(void)morePopView:(RightBarMorePopView *)popView clickAtIndex:(NSInteger)index{

}



-(void)reloadHeadViewClick
{
    [self.friendCircleTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


-(NSArray *)moreTitlesArray{
    if (!_moreTitlesArray) {
        _moreTitlesArray = @[@"创建关系", @"发起病例", @"发起话题"];
    }
    return _moreTitlesArray;
}

-(NSArray *)moreTitlesIcoArray{
    if (!_moreTitlesIcoArray) {
        _moreTitlesIcoArray = @[[UIImage imageNamed:@"pop_add_friend_ico"],
                                [UIImage imageNamed:@"pop_share_case_ico"],
                                [UIImage imageNamed:@"pop_share_topic_ico"]];
    }
    return _moreTitlesIcoArray;
}

#pragma mark - HttpRequest 数据请求

// 请求列表数据，showWaitting YES 显示等待框
-(void)startApplicationRequest:(BOOL)showWaitting{

}
// 转发数据请求
-(void)forwardWithComment:(NSString *)comment atSection:(NSInteger)section{

}
// 评论数据请求
-(void)publishComment:(NSString *)content{
}
// 点赞or取消点赞
-(void)praiseRequestWith:(BOOL)praise
{
}

// 删除动态数据请求
-(void)deleteDynamicRequest{

}

// 删除评论数据请求
-(void)deleteComment {

}

//上传头像(顶部背景)
-(void)setUserBgImage:(UIImage *)headerImg{
  
}

-(void)detailDataChangeUpdata:(NSNotification *)notification
{
    DocFriendModel *changeModel = [notification.userInfo objectForKey:@"changeModel"];
    NSString *modelType = [notification.userInfo objectForKey:@"modelType"];
    for (int i = 0; i < self.dataSource.count; i ++) {
        DocFriendModel *model = self.dataSource[i];
        if ([model.headerModel.caseHisTopId isEqualToString:changeModel.headerModel.caseHisTopId]) {
            if ([modelType isEqualToString:@"change"]) {
                [self.dataSource replaceObjectAtIndex:i withObject:changeModel];
            }else if ([modelType isEqualToString:@"delete"]){
                [self.headerHeightArray removeObjectAtIndex:[self.dataSource indexOfObject:model]];
                [self.dataSource removeObject:model];
            }
            [self.friendCircleTableView reloadData];
            break;
        }
    }
}

// 数据处理
-(void)processingDataWith:(NSArray *)dataArray
{
    NSMutableArray *changeArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        DocFriendModel *model = [DocFriendModel friendModelWithDict:dic];
        [self.dataSource addObject:model];
        [changeArray addObject:model];
    }
    /**计算高度**/
    [self calculateHeaderViewHeight:changeArray];
}

// 计算headerView高度
-(void)calculateHeaderViewHeight:(NSArray *)array
{
    for (DocFriendModel *model in array) {
        CGFloat height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight:model.headerModel];
        [self.headerHeightArray addObject:[NSNumber numberWithFloat:height]];
    }

}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // +1为头
    return self.dataSource.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    } else {
        DocFriendModel *model = [self.dataSource objectAtIndex:section - 1];
        return model.cellCount;
    }
}
// 评论点赞 到底部分割线的距离
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0){
        return 0.5f;
    } else {
        return 15;
    }
}
// 评论点赞 到底部分割线显示的View
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 100;
        [footerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(footerView.mas_left);
            make.right.mas_equalTo(footerView.mas_right);
            make.bottom.mas_equalTo(footerView.mas_bottom);
            make.height.mas_equalTo(0.5f);
        }];
    }
    if (section == 0) {
        footerView.backgroundColor = [UIColor clearColor];
        footerView.contentView.backgroundColor = [UIColor whiteColor];

    } else {
        footerView.backgroundColor = [UIColor whiteColor];
        footerView.contentView.backgroundColor = [UIColor whiteColor];
        [footerView viewWithTag:100].backgroundColor = WifeButlerSeparateLineColor;
    }
    return footerView;
}

// 评论点赞以上显示的View高度
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0f;
    if (section != 0) {
        if (self.headerHeightArray.count >= section - 1) {
            height = [self.headerHeightArray[section - 1] floatValue];
        }else{
            DocFriendModel *model = [self.dataSource objectAtIndex:section - 1];
            height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight:model.headerModel];
        }
    }
    return height;
}
// 顶部个人头像名称和背景
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        DocFriendHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:DocFriendHeaderViewIndentifier];
        if (!headerView) {
            headerView = [[DocFriendHeaderView alloc] initWithReuseIdentifier:DocFriendHeaderViewIndentifier];
            
        }
        WEAKSELF

        // 点击头像或背景
        [headerView setHeaderImageViewTapClick:^(UITapGestureRecognizer *recognizer) {
            [weakSelf headerImageViewTap:recognizer];
        }];
        
        return headerView;
    } else {
        MedRefFriendCircleTableHeader *docView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MedRefFriendCircleTableHeaderIdentifier];
        DocFriendModel *model = [self.dataSource objectAtIndex:section - 1];
        [docView setWorkmodel:model.headerModel atSection:section -1];
        docView.delegate = self;
        docView.contentView.backgroundColor = [UIColor whiteColor];
                
        // 收藏
        [docView setDidCollectionItemClick:^(NSString *collectionType,NSString *collectionImgUrl,DocFriendHeaderModel *model) {
            
        }];
        
        // 投诉
        [docView setDidReportItemClick:^(DocFriendHeaderModel *model) {
        }];
        // 转发给好友
        [docView setDidForwardItemClick:^(NSString *forwordType, DocFriendHeaderModel *model){
          
        }];

        return docView;
    }
}

// 每一个section下cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    if (indexPath.section==0) {
        return 0;
    } else {
        DocFriendModel *model = [self.dataSource objectAtIndex:indexPath.section - 1];
        if(indexPath.row == 0 && model.praiseArray.count > 0){
            // 如果有点赞
            height = [MedRefFriendCircleTableCell getHeadSectionRowHeightWithPraiseArray:model];
        } else {
            height = [MedRefFriendCircleTableCell getHeadSectionRowHeightWithModel:[model.reviewArray objectAtIndex:indexPath.row] atIndexPath:indexPath];
        }
    }
    return height;
}

// 设置评论点赞
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId=@"HeaderSecondTableViewTempCell";
    DocFriendModel *model = [self.dataSource objectAtIndex:indexPath.section - 1];
    MedRefFriendCircleTableCell *sectionCell = (MedRefFriendCircleTableCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!sectionCell) {
        sectionCell = [[MedRefFriendCircleTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [sectionCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(indexPath.row == 0 && model.praiseArray.count > 0){
        // 如果为分组第一个且类型为数组则该条数据为点赞消息
        [sectionCell setPraiseArray:model atIndexPath:indexPath];
        // 有评论需要显示分割线
        if (indexPath.row == 0 && model.reviewArray.count > 1) {
            [sectionCell setSeparatorLineViewHidden:NO];
        } else {
            [sectionCell setSeparatorLineViewHidden:YES];
        }
    } else {
        [sectionCell setReviseModel:[model.reviewArray objectAtIndex:indexPath.row] atIndexPath:indexPath];
        [sectionCell setSeparatorLineViewHidden:YES];
    }
    
    [self configActionWith:sectionCell indexPath:indexPath];
    
    return sectionCell;
}

- (void)configActionWith:(MedRefFriendCircleTableCell *)cell indexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    // 点击收藏
    [cell setDidCollectionItemClick:^(DocFriendReviewModel *model){
        
    }];
    
    // 点击投诉
    [cell setDidReportItemClick:^(DocFriendReviewModel *model) {
        
        
    }];
    
    // 点击人名称
    [cell setDidNameClick:^(NSString *partyId) {
        [weakSelf pushPhotoAlbumWithPartyId:partyId];
    }];
    
    DocFriendModel *currentModel = [self.dataSource objectAtIndex:indexPath.section - 1];
    // 点击评论
    [cell setDidCommentClick:^{
        // 如果存在menu控件 则隐藏控件
        if ([[UIMenuController sharedMenuController] isMenuVisible]) {
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
            return;
        }
        if(indexPath.row == 0 && currentModel.praiseArray.count > 0){
            // 如果为分组第一个且类型为数组则该条数据为点赞消息
        } else {
            DocFriendReviewModel *model = [currentModel.reviewArray objectAtIndex:indexPath.row];
            weakSelf.currentOpIndexPath = indexPath;
            weakSelf.currentOpSection = indexPath.section - 1;
            if ([model.partyId isEqualToString:[WifeButlerAccount sharedAccount].userParty.id]) { // 点击自己的评论
                CSActionSheet *action = [[CSActionSheet alloc] initWithNewTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
                action.tag = 1;
                [action show];
                
            }else{  // 点击别人的评论
                weakSelf.commentPlaceholder = [NSString stringWithFormat:@"回复%@:",model.partyName];
                weakSelf.replyModel = model;
                [weakSelf publishCommentClick];
            }
        }

    }];
    
    
}

// 点击评论



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 如果存在menu控件 则隐藏控件
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return;
    }
}

#pragma mark - HealthCircleTableHeaderViewDelegate 头像、文章等详情、更多按钮操作
// 进入个人相册页面
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView pushPhotoAlbumWithPartyId:(NSString *)partyId
{
    [self pushPhotoAlbumWithPartyId:partyId];
}

// 点击转发对象名称
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView forwardNameClickAtSection:(NSInteger)section{
    DocFriendModel *workModel = [self.dataSource objectAtIndex:section];
    [self pushToPersonalZone:workModel.headerModel.forwardPartyId];
}
// 点击链接图片
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView authorClickAtSection:(NSInteger)section{
    DocFriendModel *workModel = [self.dataSource objectAtIndex:section];
   
    [self pushToPersonalZone:workModel.headerModel.articleAuthorId];
    
}
// 全文按钮点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView showAllClickAtSection:(NSInteger)section
{
    // 重新计算高度 放入高度存储数组中
    DocFriendModel *workModel = [self.dataSource objectAtIndex:section];
    CGFloat height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight: workModel.headerModel];
    [self.headerHeightArray replaceObjectAtIndex:section withObject:[NSNumber numberWithFloat:height]];
    if (workModel.headerModel.isShowAll) {
        self.selectOffect = self.friendCircleTableView.contentOffset.y;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
           self.friendCircleTableView.contentOffset = CGPointMake(0, self.selectOffect);
        }];
    }
    [self.friendCircleTableView reloadSections:[[NSIndexSet alloc] initWithIndex:section + 1] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - privat method 页面跳转
// 进入个人相册页面
-(void)pushPhotoAlbumWithPartyId:(NSString *)partyId
{
   
}

// 跳转到个人主页
-(void)pushToPersonalZone:(NSString *)partyId{

}


#pragma mark - 页面点击事件
// 点击更多按钮
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView markClickAtSection:(NSInteger)section withClickView:(UIView *)view{
    
    self.currentOpSection = section;
    DocFriendModel *currentModel = [self.dataSource objectAtIndex:section];
    NSInteger row = currentModel.cellCount > 0 ? currentModel.cellCount - 1 : 0;
    self.currentOpIndexPath = [NSIndexPath indexPathForRow:row inSection:self.currentOpSection + 1];
    
    //判断是否点赞
    isPraise = NO;
    NSInteger count = currentModel.praiseArray.count;
    for (NSInteger index = 0; index < count; index++) {
        DocFriendPraiseModel *model = [currentModel.praiseArray objectAtIndex:index];
        if ([model.partyId isEqualToString:@""]) {
            isPraise=YES;
            userPraiseIndex = index;
            caseHisTopRevId = model.caseHisTopRevId;
            break;
        }
    }

    icoArray=@[@"academic_praise_n",@"academic_review",@"academic_share"];
    if (isPraise==YES) { // 已点赞
        titleArray = @[cancelPraise, commentString, repeatDynamic];
    } else {
        titleArray = @[setPraise, commentString, repeatDynamic];
    }
    // 如果是自己发布的不显示转发按钮
    if ([currentModel.headerModel.partyId isEqualToString:@""]){// [model.chtTypeEnumFK isEqualToString:@"话题"] || [model.chtTypeEnumFK isEqualToString:@"病历"]
        icoArray=@[@"academic_praise_n",@"academic_review"];
        if (isPraise==YES) { // 已点赞
            titleArray = @[cancelPraise, commentString];
        } else {
            titleArray = @[setPraise, commentString];
        }
    }
    FriendCircleMarkPopView *popView = [[FriendCircleMarkPopView alloc] init];
    [popView setItemTitles:titleArray withIcos:icoArray];
    popView.delegate = self;
    [popView showMarkViewWithReference:view withPosition:kShowMarkViewLeft offset:-(37 - 19) + 10];
}

#pragma mark - FriendCircleMarkPopViewDelegate 点击点赞 评论或转发
-(void)markPopView:(FriendCircleMarkPopView *)markView clickAtIndex:(NSInteger)index{
    NSString *titleKey = titleArray[index];
    NSString *selecterString = [selectorDic valueForKey:titleKey];
    self.commentPlaceholder = @"评论";
    self.replyModel = nil;
    [self performSelectorOnMainThread:NSSelectorFromString(selecterString) withObject:nil waitUntilDone:NO];
    
}

// 点击取消点赞
-(void)cancelPraise{
    [self praiseRequestWith:NO];
}
// 点击点赞
-(void)setPraise{
    [self praiseRequestWith:YES];
}

// 点击评论
-(void)publishCommentClick{
    
    CommentView *commentView = [CommentView showView];
    commentView.maxLength = 500;
    [commentView setPlaceHolder:self.commentPlaceholder];
    WEAKSELF
    [commentView showWithSendCommentBlock:^(NSString *content) {
        
        [weakSelf publishComment:content];
        
    }];
}
// 点击转发
-(void)repeatDynamic
{
    CommentView *commentView = [CommentView showView];
    commentView.receiveEmpty = YES;
    WEAKSELF
    [commentView showWithSendCommentBlock:^(NSString *content) {
        [weakSelf forwardWithComment:content atSection:self.currentOpSection];
    }];
}

// 点击删除动态消息
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView delectClickAtSection:(NSInteger)section{
    self.currentOpSection = section;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认删除这条动态消息?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1002;
    [alert show];
}

#pragma - mark alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 1002) { // 删除动态消息
            [self deleteDynamicRequest];
        }
    }
}
// 点击评论改变tableView的contentOffset
-(void)changeTableViewContentOffsetWith:(NSNotification *)notification{

    UIView *bottomview = notification.object;
    DocFriendModel *currentModel = [self.dataSource objectAtIndex:self.currentOpIndexPath.section - 1];
    NSIndexPath *path=  self.currentOpIndexPath;
    CGFloat height;
    // 有评论或点赞 取 cell 的相对位置
    if (currentModel.cellCount > 0) {
        MedRefFriendCircleTableCell *cell=[self.friendCircleTableView cellForRowAtIndexPath:path];
        CGRect frame = [self.friendCircleTableView convertRect:cell.frame toView:[[UIApplication sharedApplication].delegate window]];
        height=frame.size.height+frame.origin.y;
        // 如果点击的是最后一个cell 需要加上 cell已底部的间距 15
        if (path.row == currentModel.cellCount - 1) {
            frame = [self.friendCircleTableView convertRect:[self.friendCircleTableView rectForSection:path.section] toView:[[UIApplication sharedApplication].delegate window]];
            height=frame.size.height+frame.origin.y;
        }
    }else{ // 没有评论或点赞 取 headerView 的相对位置
        MedRefFriendCircleTableHeader *header=(MedRefFriendCircleTableHeader *)[self.friendCircleTableView headerViewForSection:self.currentOpIndexPath.section];
        CGRect frame = [self.friendCircleTableView convertRect:header.frame toView:[[UIApplication sharedApplication].delegate window]];
        height=frame.size.height+frame.origin.y+15;
    }
    CGFloat commentHeight=bottomview.frame.origin.y;
    CGFloat transform = commentHeight - height > 0 ? 0 : commentHeight-height;
    CGPoint point=self.friendCircleTableView.contentOffset;
    [self.friendCircleTableView setContentOffset:CGPointMake(point.x, point.y-transform) animated:YES];
}


#pragma mark - 头像设置
-(void)headerImageViewTap:(UITapGestureRecognizer *)gesture{
    if (gesture.view.tag == 0) {
        [self pushPhotoAlbumWithPartyId:nil];
        return;
    }
    CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithNewTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"照相机", nil];
    //设置样式
    actionSheet.tag = 0;
    [actionSheet show];
}
#pragma mark - CSActionSheetDelegate 头像设置
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            [ImagePickerUtils selectPhotoFromViewController:self allowsEditing:YES withDelegate:self];
        }else if (buttonIndex == 1) {
            [ImagePickerUtils takePhotoFromVC:self imgMode:kImagePickerModePhoto allowsEditing:YES withDelegate:self];
        }
    }else if (actionSheet.tag == 1){ // 删除自己的评论
        if (buttonIndex == 0) {
            [self deleteComment];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
      WEAKSELF
    dispatch_async(DISPATCH_GLOBAL_QUEUE, ^{
        UIImage *selectImg = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *scaleImg = [ImageUtils comparessImageFromOriginalImage:selectImg];
        [weakSelf performSelectorOnMainThread:@selector(setUserBgImage:) withObject:scaleImg waitUntilDone:NO];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
        {
   
}

// 页面滚动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

// 刷新页面数据
-(void)reloatTableView{
    [self.friendCircleTableView reloadData];
}


#pragma mark - WifeButlerLoadingTableView代理
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    currentPage = 1;
    [self becomeFirstResponder];
    [self startApplicationRequest:NO];

}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    currentPage ++;
    [self startApplicationRequest:NO];
}

@end
