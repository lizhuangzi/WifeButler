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
#import "DocImageModel.h"
#import "DocFriendReviewModel.h"
#import "DocFriendPraiseModel.h"

#import "WifeButlerDefine.h"
#import "WifeButlerLoadingTableView.h"
#import "WifeButlerNetWorking.h"
#import "Masonry.h"
#import "NetWorkPort.h"
#import "WifeButlerDefine.h"
#import "PhotoBrowserGetter.h"
#import "PublicCircleViewController.h"

@interface MedRefFriendCircleViewController ()<UITableViewDataSource, UITableViewDelegate,WifeButlerloadingTableViewDelegate, MedRefFriendCircleTableHeaderDelegate, CSActionSheetDelegate, FriendCircleMarkPopViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RightBarMorePopViewDelegate>{
    
    NSArray *titleArray;
    NSArray *icoArray;
    NSDictionary *selectorDic;
    
    // 弹出框相关参数
    NSInteger userPraiseIndex;      // 点赞列表中用户点赞位置
    NSString *caseHisTopRevId;      // 用户点赞id
    BOOL isPraise;  // 是否点赞
    
}
@property (nonatomic,weak) WifeButlerLoadingTableView * tableView;
// 数据列表
@property(nonatomic, strong) NSMutableArray *dataArray;
// cell 头部高度
@property(nonatomic, strong) NSMutableArray *headerHeightArray;
/**图片浏览*/
@property (nonatomic,strong) PhotoBrowserGetter * browserGetter;

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

@property (nonatomic,assign) NSUInteger page;
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

- (NSMutableArray *)dataSource
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    self.title = @"社区圈子";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ZTAddPengYouQuan"] style:UIBarButtonItemStylePlain target:self action:@selector(rigViewClick)];
}

-(void)initMemberVariable{

    self.page = 1;
    self.headerHeightArray = [NSMutableArray array];
    selectorDic = @{commentString: @"publishCommentClick",
                    cancelPraise: @"cancelPraise",
                    setPraise: @"setPraise",
                    repeatDynamic:@"repeatDynamic"};
}

-(void)initViewDisplay{
    
    WifeButlerLoadingTableView * table = [[WifeButlerLoadingTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = WifeButlerTableBackGaryColor;
    table.dataSource = self;
    table.delegate = self;
    table.loadingDelegate = self;
    [self.view addSubview:table];
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView = table;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

-(void)rightBarButtonClick{
    RightBarMorePopView *menuPopView = [RightBarMorePopView morePopViewWithType:kMenuPopViewImgBlack titleArray:self.moreTitlesArray imgArray:self.moreTitlesIcoArray width:123];
    menuPopView.delegate = self;
    [menuPopView show];
}

#pragma mark - 右侧更多按钮
- (void)rigViewClick
{
    PublicCircleViewController * vc = [[PublicCircleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)reloadHeadViewClick
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
    
    [SVProgressHUD showWithStatus:@""];
    NSDictionary * parm = @{@"token":KToken,@"pageindex":@(self.page)};
    [WifeButlerNetWorking postPackagingHttpRequestWithURLsite:KSheQuQuanZi parameter:parm success:^(NSArray * resultCode) {
        
        D_SuccessLoadingDeal(0, resultCode, ^(NSArray * arr){
            [self processingDataWith:arr];
        });
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        D_FailLoadingDeal(0);
    }];
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
        if ([model.id isEqualToString:changeModel.id]) {
            if ([modelType isEqualToString:@"change"]) {
                [self.dataSource replaceObjectAtIndex:i withObject:changeModel];
            }else if ([modelType isEqualToString:@"delete"]){
                [self.headerHeightArray removeObjectAtIndex:[self.dataSource indexOfObject:model]];
                [self.dataSource removeObject:model];
            }
            [self.tableView reloadData];
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
        CGFloat height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight:model];
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
            height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight:model];
        }
    }else{
        return [DocFriendHeaderView headerViewHeight];
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
        if (!docView) {
            docView = [[NSBundle mainBundle]loadNibNamed:@"MedRefFriendCircleTableHeader" owner:nil options:nil].lastObject;
        }
        DocFriendModel *model = [self.dataSource objectAtIndex:section - 1];
        [docView setWorkmodel:model atSection:section -1];
        docView.delegate = self;
        docView.contentView.backgroundColor = [UIColor whiteColor];
                
        // 收藏
        [docView setDidCollectionItemClick:^(NSString *collectionType,NSString *collectionImgUrl,DocFriendHeaderModel *model) {
            
        }];
        
        // 投诉
        [docView setDidReportItemClick:^(DocFriendModel *model) {
        }];
        // 转发给好友
        [docView setDidForwardItemClick:^(NSString *forwordType, DocFriendModel *model){
          
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
        if(indexPath.row == 0 && model.some.count > 0){
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
    if(indexPath.row == 0 && model.some.count > 0){
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
        if(indexPath.row == 0 && currentModel.some.count > 0){
            // 如果为分组第一个且类型为数组则该条数据为点赞消息
        } else {
            DocFriendReviewModel *model = [currentModel.reviewArray objectAtIndex:indexPath.row];
            weakSelf.currentOpIndexPath = indexPath;
            weakSelf.currentOpSection = indexPath.section - 1;
            NSString * partyId = [WifeButlerAccount sharedAccount].userParty.Id;
            if ([model.uid isEqualToString:partyId]) { // 点击自己的评论
                CSActionSheet *action = [[CSActionSheet alloc] initWithNewTitle:@"" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
                action.tag = 1;
                [action show];
                
            }else{  // 点击别人的评论
                weakSelf.commentPlaceholder = [NSString stringWithFormat:@"回复%@:",model.nickname];
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
    [self pushToPersonalZone:workModel.forwardPartyId];
}

// 全文按钮点击
-(void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView showAllClickAtSection:(NSInteger)section
{
    // 重新计算高度 放入高度存储数组中
    DocFriendModel *workModel = [self.dataSource objectAtIndex:section];
    CGFloat height = [MedRefFriendCircleTableHeader getHeadSectionHeadHeight: workModel];
    [self.headerHeightArray replaceObjectAtIndex:section withObject:[NSNumber numberWithFloat:height]];
    if (workModel.isShowAll) {
        self.selectOffect = self.tableView.contentOffset.y;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
           self.tableView.contentOffset = CGPointMake(0, self.selectOffect);
        }];
    }
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:section + 1] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - privat method 页面跳转
// 进入个人主面
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
    NSInteger count = currentModel.some.count;
    for (NSInteger index = 0; index < count; index++) {
        DocFriendPraiseModel *model = [currentModel.some objectAtIndex:index];
        if ([model.id isEqualToString:@""]) {
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
    if ([currentModel.id isEqualToString:@""]){// [model.chtTypeEnumFK isEqualToString:@"话题"] || [model.chtTypeEnumFK isEqualToString:@"病历"]
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
#pragma mark - 预览多张图片
- (void)tableHeaderView:(MedRefFriendCircleTableHeader *)headerView didClickImageViewIndex:(NSUInteger)index andImageModelArr:(NSArray *)arr
{
    NSMutableArray * temp = [NSMutableArray array];
    for (DocImageModel * model in arr) {
        [temp addObject: model.url];
    }
    self.browserGetter = [PhotoBrowserGetter browserGetter];
    UIViewController * vc = [self.browserGetter getBrowserWithCurrentIndex:index andimageURLStrings:temp];
    [self.navigationController pushViewController:vc animated:YES];
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
        MedRefFriendCircleTableCell *cell=[self.tableView cellForRowAtIndexPath:path];
        CGRect frame = [self.tableView convertRect:cell.frame toView:[[UIApplication sharedApplication].delegate window]];
        height=frame.size.height+frame.origin.y;
        // 如果点击的是最后一个cell 需要加上 cell已底部的间距 15
        if (path.row == currentModel.cellCount - 1) {
            frame = [self.tableView convertRect:[self.tableView rectForSection:path.section] toView:[[UIApplication sharedApplication].delegate window]];
            height=frame.size.height+frame.origin.y;
        }
    }else{ // 没有评论或点赞 取 headerView 的相对位置
        MedRefFriendCircleTableHeader *header=(MedRefFriendCircleTableHeader *)[self.tableView headerViewForSection:self.currentOpIndexPath.section];
        CGRect frame = [self.tableView convertRect:header.frame toView:[[UIApplication sharedApplication].delegate window]];
        height=frame.size.height+frame.origin.y+15;
    }
    CGFloat commentHeight=bottomview.frame.origin.y;
    CGFloat transform = commentHeight - height > 0 ? 0 : commentHeight-height;
    CGPoint point=self.tableView.contentOffset;
    [self.tableView setContentOffset:CGPointMake(point.x, point.y-transform) animated:YES];
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
    [self.tableView reloadData];
}


#pragma mark - WifeButlerLoadingTableView代理
- (void)WifeButlerLoadingTableViewDidRefresh:(WifeButlerLoadingTableView *)tableView
{
    self.page = 1;
    [self becomeFirstResponder];
    [self startApplicationRequest:NO];

}

- (void)WifeButlerLoadingTableViewDidLoadingMore:(WifeButlerLoadingTableView *)tableView
{
    self.page ++;
    [self startApplicationRequest:NO];
}

@end



/*

(
 {
     "argued_id" = 0;
     "argued_name" = "";
     avatar = "/public/upload/images/20170108/recson_20170108143733343924005208.jpg";
     content = "";
     discuss =         (
                        {
                            "argued_id" = 0;
                            "argued_name" = "";
                            avatar = "/public/upload/images/20170105/recson_201701050945241788510072433.jpg";
                            child =                 (
                            );
                            content = "\U5783\U573e\U5206\U7c7b";
                            id = 4;
                            level = 1;
                            nickname = "\U7f57\U5ddd";
                            time = 1483879212;
                            "topic_id" = 3;
                            uid = 1;
                            "up_user" = 3;
                            upid = 3;
                        },
                        {
                            "argued_id" = 0;
                            "argued_name" = "";
                            avatar = "/public/upload/images/20160825/recson_201608251035032220910027279.jpg";
                            child =                 (
                            );
                            content = "\U5708\U5b50\U4eba\U4e0d\U591a\U54e6";
                            id = 7;
                            level = 1;
                            nickname = "user_28304";
                            time = 1488037191;
                            "topic_id" = 3;
                            uid = 51;
                            "up_user" = 3;
                            upid = 3;
                        }
                        );
     gallery =         (
                        {
                            h = 600;
                            url = "https://app.icanchubao.com/./public/upload/images/20170108/recson_201701081438134606590031272.jpg";
                            w = 450;
                        },
                        {
                            h = 450;
                            url = "https://app.icanchubao.com/./public/upload/images/20170108/recson_201701081438135128690038523.jpg";
                            w = 600;
                        },
                        {
                            h = 450;
                            url = "https://app.icanchubao.com/./public/upload/images/20170108/recson_201701081438135662220084079.jpg";
                            w = 600;
                        },
                        {
                            h = 450;
                            url = "https://app.icanchubao.com/./public/upload/images/20170108/recson_201701081438136335130069129.jpg";
                            w = 600;
                        },
                        {
                            h = 450;
                            url = "https://app.icanchubao.com/./public/upload/images/20170108/recson_201701081438136832080090239.jpg";
                            w = 600;
                        }
                        );
     id = 3;
     level = 0;
     myup = 0;
     nickname = "\U738b\U6dcb";
     some =         (
                     {
                         id = 51;
                         nickname = "user_283041";
                     },
                     {
                         id = 1;
                         nickname = "\U7f57\U5ddd";
                     },
                     {
                         id = 9;
                         nickname = "user_458671";
                     }
                     );
     time = 1483857493;
     "topic_id" = 0;
     uid = 3;
     "up_user" = 0;
     upid = 0;
     use = 0;
 },
 {
     "argued_id" = 0;
     "argued_name" = "";
     avatar = "/public/upload/images/20160825/recson_201608251035032220910027279.jpg";
     content = "";
     discuss =         (
                        {
                            "argued_id" = 0;
                            "argued_name" = "";
                            avatar = "public/upload/images/20170108/recson_20170108143733343924005208.jpg";
                            child =                 (
                                                     {
                                                         "argued_id" = 2;
                                                         "argued_name" = "\U738b\U6dcb";
                                                         avatar = "/public/upload/images/20170105/recson_201701050945241788510072433.jpg";
                                                         content = "\U58c1\U7eb8";
                                                         id = 6;
                                                         level = 2;
                                                         nickname = "\U7f57\U5ddd";
                                                         time = 1483942755;
                                                         "topic_id" = 1;
                                                         uid = 1;
                                                         "up_user" = 3;
                                                         upid = 2;
                                                     }
                                                     );
                            content = "\U4ec0\U4e48\U56fe";
                            id = 2;
                            level = 1;
                            nickname = "\U738b\U6dcb";
                            time = 1483692850;
                            "topic_id" = 1;
                            uid = 3;
                            "up_user" = 4;
                            upid = 1;
                        }
                        );
     gallery =         (
                        {
                            h = 480;
                            url = "https://app.icanchubao.com/./public/upload/images/20170106/recson_201701061159510544970013061.jpg";
                            w = 270;
                        }
                        );
     id = 1;
     level = 0;
     myup = 0;
     nickname = "\U5f20\U4e91\U5a1f";
     some =         (
                     {
                         id = 3;
                         nickname = "user_262812";
                     },
                     {
                         id = 4;
                         nickname = "\U5f20\U4e91\U5a1f";
                     }
                     );
     time = 1483675191;
     "topic_id" = 0;
     uid = 4;
     "up_user" = 0;
     upid = 0;
     use = 0;
 }
 )
 
 */

