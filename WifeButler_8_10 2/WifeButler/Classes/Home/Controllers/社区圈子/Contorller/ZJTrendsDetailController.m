//
//  ZJTrendsDetailController.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJTrendsDetailController.h"
#import "ZJTrendsDetailModel.h"
#import "ZJCommentModel.h"
#import "ZJDetailViewFrameModel.h"
#import "ZJTrendsCommentViewFrameModel.h"
#import "ZJTrendsDetailReplyView.h"
#import "ZJTrendsDetailView.h"
#import "ZTJianPanView.h"
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>
#import "ZJLoginController.h"

@interface ZJTrendsDetailController ()<ZJThrendsDetailReplyViewDelegate,TYAttributedLabelDelegate, ZJTrendsDetailViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ZJTrendsDetailModel *detailModel;
@property (nonatomic, strong) ZJDetailViewFrameModel *frameModel;
@property (nonatomic, strong) NSMutableArray *commentFrames;//主评论列表 frame

@property (nonatomic, weak) ZJTrendsDetailView *trendsDetailView;

@property (nonatomic, strong) ZTJianPanView * keaboad;

@property (nonatomic, strong) NSMutableArray * photoesArr;

@end

@implementation ZJTrendsDetailController

- (ZJDetailViewFrameModel *)frameModel{
    
    if (!_frameModel) {
        
        _frameModel = [[ZJDetailViewFrameModel alloc]init];
    }
    
    return _frameModel;
}


-(NSMutableArray *)commentFrames{
    
    if (!_commentFrames) {
        
        _commentFrames = [NSMutableArray array];
    }
    
    return _commentFrames;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"动态详情";
    
    self.photoesArr = [NSMutableArray array];
    
    [self createScrollView];
    
    [self getTrendsDetailData];

}

-(void)commendFinished:(commendBlock)action{
    
    self.block = action;
    
}

-(void)commentFinished:(commentBlock)action{
    
    self.commentBlock = action;
}

-(void)createScrollView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight)];
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getTrendsDetailData];
        
    }];
}

- (void)getTrendsDetailData{
    
    NSString *url = [HTTP_BaseURL stringByAppendingString:TRENDSDETAIL];
    NSDictionary *parameters = @{@"token":KToken, @"topic_id":self.did};
    
    ZJLog(@"%@", parameters);
    
    [CCNetWorkingTool POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        if ([CCNetWorkingTool success:responseObject]) {
            
            ZJLog(@"%@", responseObject);
            
            self.detailModel = [ZJTrendsDetailModel mj_objectWithKeyValues:responseObject[@"resultCode"]];
            
            // 二层回复
            self.detailModel.comment = [ZJCommentModel mj_objectArrayWithKeyValuesArray:self.detailModel.comment];

            if (self.commentBlock) {
                
                self.commentBlock(self.detailModel.comment);
            }
            
            NSMutableArray *muArr = [NSMutableArray array];
            
            for (int i = 0; i < self.detailModel.comment.count; ++i) {
                
                ZJTrendsCommentViewFrameModel *commentFrameModel = [[ZJTrendsCommentViewFrameModel alloc] init];
                commentFrameModel.model = self.detailModel.comment[i];
                
                [muArr addObject:commentFrameModel];
            }
            
            self.commentFrames = [muArr mutableCopy];
            
            self.frameModel.detailModel = self.detailModel;
            
            [self refreshView];
            
        }
        
        // 登录失效 进行提示登录
        if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
            
            [SVProgressHUD dismiss];
            
            __weak typeof(self) weakSelf = self;
            
            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                vc.isLogo = YES;
                [vc setShuaiXinShuJu:^{
                    
                    [self getTrendsDetailData];
                }];
                
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            
            [vc addAction:otherAction];
            
            [weakSelf presentViewController:vc animated:YES completion:nil];
            
        }
        
        [self.scrollView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.scrollView.mj_header endRefreshing];
    }];
    
}


#warning 点赞或评论以后执行此方法 最好延迟执行
//刷新或创建所有view
-(void)refreshView{
    
    [self createTrendsDetailView];  //详情 view
    
    [self createReplyView];         //回复 view
}

//动态内容
-(void)createTrendsDetailView{
    
//    if (!self.trendsDetailView) {
    
        ZJTrendsDetailView *detailView = [[ZJTrendsDetailView alloc] init];
        
        detailView.frameModel = self.frameModel;
        
        detailView.frame = CGRectMake(0, 0, iphoneWidth, self.frameModel.viewH);
        
        [self.scrollView addSubview:detailView];
        
        detailView.delegate = self;
        
        self.trendsDetailView = detailView;
        
        __weak typeof(self) weakSelf = self;
        
        [detailView setPhotoBlack:^(ZJTrendsDetailView *cell, NSIndexPath *indexPPP) {
            
            [weakSelf.photoesArr removeAllObjects];
            
            for (int i = 0; i < cell.dataSourceTemp.count; i ++) {
                
                MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, cell.dataSourceTemp[i]]]];
                [weakSelf.photoesArr addObject:photo];
            }
            
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            [browser setCurrentPhotoIndex:indexPPP.row];   // 设置是第几个显示
            [weakSelf.navigationController pushViewController:browser animated:YES];
        }];
        
//    }
}


//回复
-(void)createReplyView{
    
    for (UIView *subView in self.scrollView.subviews) {
        
        if ([subView isKindOfClass:[ZJTrendsDetailReplyView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    CGFloat totalH = CGRectGetMaxY(self.trendsDetailView.frame);
    
    if (self.commentFrames.count) {
        
        CGFloat replyViewY = 8;
        
        for (int i = 0; i < self.commentFrames.count; ++i) {
            
            ZJTrendsDetailReplyView *replyView = [[ZJTrendsDetailReplyView alloc]init];
            
            replyView.delegate = self;
            replyView.textView.delegate = self;
            
            replyView.frameModel = self.commentFrames[i];
            
            totalH += replyView.frameModel.viewH;
            
            replyView.frame = CGRectMake(0, CGRectGetMaxY(self.trendsDetailView.frame) + replyViewY, iphoneWidth, replyView.frameModel.viewH);
         
            [self.scrollView addSubview:replyView];
            
            replyViewY += replyView.frameModel.viewH + 8;
            
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(0, totalH + 64);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZJTrendsDetailViewDelegate

-(void)trendsDetailView:(ZJTrendsDetailView *)view functionViewClicked:(UIView *)functionView{
    
    if ([functionView isEqual:view.headerView.icon]) {
        
        NSLog(@"头像点击------");
        
        
    }else if([functionView isEqual:view.functionView.commendBtn]){
        
        NSLog(@"点赞动态---");
        
        ZJTrendsModel *model = self.detailModel.topic;
        
        [self netWorkingDianZhan:model andView:view];
       //网络请求成功后调用这句话
        
//        view.functionView.commendBtn.selected = !view.functionView.commendBtn.isSelected;
        
        
    }else if ([functionView isEqual:view.functionView.commmentBtn]){
        
        NSLog(@"评论动态----");
        
        self.keaboad = [[[NSBundle mainBundle] loadNibNamed:@"ZTJianPangView" owner:self options:nil] firstObject];
        
        self.keaboad.frame = CGRectMake(0, iphoneHeight - 44, iphoneWidth, 44);
        
        __weak typeof(self) weakSelf = self;
        
        ZJTrendsModel *model = self.detailModel.topic;
        
        // 点击完成
        [self.keaboad setFaSongBlack:^(NSString *text) {
            
            [weakSelf netWorkingPingLun:model andLevel:@"1" andContont:text];
        }];
        
        [self.keaboad.textView becomeFirstResponder];
        
        [self.view addSubview:self.keaboad];
        
        
    }
}

#pragma mark - ZJThrendsDetailReplyViewDelegate
//会员头像，回复按钮，评论会员昵称点击
-(void)threndsDetailReplyView:(ZJTrendsDetailReplyView *)view subButtonClickedWithType:(ZJThrendsDetailReplyViewButtonType)buttonType{
    
    switch (buttonType) {
        case ZJThrendsDetailReplyViewButtonTypeIcon:{
            NSLog(@"评论头像点击%@",view.frameModel.model.avatar);
           
            //用户 id
            NSString *uid = view.frameModel.model.uid;
           //用户昵称
            NSString *nickname = view.frameModel.model.nickname;
            
        }
            break;
        case ZJThrendsDetailReplyViewButtonTypeName:{
            NSLog(@"评论昵称点击%@",view.frameModel.model.nickname);
            
            //用户 id
            NSString *uid = view.frameModel.model.uid;
            //用户昵称
            NSString *nickname = view.frameModel.model.nickname;
        
        }
            break;
        case ZJThrendsDetailReplyViewButtonTypeReply:{
            NSLog(@"回复按钮点击%@",view.frameModel.model.nickname);
            
            //用户 id
            NSString *uid = view.frameModel.model.uid;
            
            //用户昵称
            NSString *nickname = view.frameModel.model.nickname;
            
            //评论id
            NSString *cid = view.frameModel.model.id;
            
            
            if ([uid isEqualToString:KID]) {//自己

                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能对自己评论" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *surenAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                
                [alertCtrl addAction:surenAction];
                
                
                [self.navigationController presentViewController:alertCtrl animated:YES completion:nil];
                

            }else{
                

            NSLog(@"------uid:%@------nickname:%@", uid, nickname);
            
            self.keaboad = [[[NSBundle mainBundle] loadNibNamed:@"ZTJianPangView" owner:self options:nil] firstObject];
            
            self.keaboad.frame = CGRectMake(0, iphoneHeight - 44, iphoneWidth, 44);
            
            __weak typeof(self) weakSelf = self;
            
            // 点击完成
            [self.keaboad setFaSongBlack:^(NSString *text) {
                
                [weakSelf netWorkingPingLun1:nickname andId:cid andLevel:@"2" andContont:text];
            }];
            
            [self.keaboad.textView becomeFirstResponder];
            
            [self.view addSubview:self.keaboad];
                
            }
            
        }
            break;
            
        default:
            break;
    }
}




//属性文字点击
-(void)threndsDetailReplyView:(ZJTrendsDetailReplyView *)view textViewClickedWithData:(id)data{
    
    if ([data isKindOfClass:[NSString class]]) {
        
        NSLog(@"回复评论 -- id%@",data);
        NSArray *dataArr = [data componentsSeparatedByString:@","];
        
        if ([dataArr[1] isEqualToString:KID]) {//自己
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"不能对自己评论" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *surenAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
            }];
            
            
            [alertCtrl addAction:surenAction];
       
            
            [self.navigationController presentViewController:alertCtrl animated:YES completion:nil];
            
        }else{
            
            // 用户 id
            NSString *uid = view.frameModel.model.uid;
            // 用户昵称
            NSString *nickname = view.frameModel.model.nickname;
            // 评论id
            NSString *cid = view.frameModel.model.id;
        
            // 要回复的评论 id
            NSString *commentId = dataArr[0];
            // 被评论的会员 id
            NSString *commentUId = dataArr[1];
            // 被评论的会员昵称
            NSString *commentNickName = dataArr[2];
            
            
            self.keaboad = [[[NSBundle mainBundle] loadNibNamed:@"ZTJianPangView" owner:self options:nil] firstObject];
            
            self.keaboad.frame = CGRectMake(0, iphoneHeight - 44, iphoneWidth, 44);
            
            __weak typeof(self) weakSelf = self;
            
            // 点击完成
            [self.keaboad setFaSongBlack:^(NSString *text) {
                
                [weakSelf netWorkingPingLun1:nickname andId:cid andLevel:@"2" andContont:text];
            }];
            
            [self.keaboad.textView becomeFirstResponder];
            
            [self.view addSubview:self.keaboad];
            
            [self createCommentViewWithCommentId:commentId commentedNickName:commentNickName];
        
        }
        
    }else if ([data isKindOfClass:[NSArray class]]){
        
        NSLog(@"进入好友圈子  %@",data);
        
        //点击text的好友 id
        NSString *uid = data[0];
         //点击text的好友 昵称
        NSString *nickName = data[1];
            
        
    }
    
}



#pragma mark - 评论   level等级   text:内容
- (void)netWorkingPingLun:(ZJTrendsModel *)model andLevel:(NSString *)level andContont:(NSString *)text
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.did forKey:@"topic_id"];        // 原帖动态id
    [dic setObject:self.did forKey:@"msg_id"];           // 上级id
    [dic setObject:text forKey:@"content"];
    [dic setObject:self.did forKey:@"argued_id"];        // 被评论id
    [dic setObject:model.nickname forKey:@"argued_name"];           // 被评论人名
    [dic setObject:level forKey:@"level"];            // 评论等级
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", ZTPengYouQuanPingLun];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            // 键盘字数清空
            self.keaboad.textView.text = @"";
            [self.keaboad.textView resignFirstResponder];
    
            [self hiddenKeabord];
            
            [self performSelector:@selector(getTrendsDetailData) withObject:nil afterDelay:1.0];
            
         
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        
        
    }];
    
}

#pragma mark - 隐藏键盘
- (void)hiddenKeabord
{
    self.keaboad.hidden = YES;
}


#pragma mark - 评论    nicname:昵称    level:等级   text:内容
- (void)netWorkingPingLun1:(NSString *)nickname andId:(NSString *)temp_id andLevel:(NSString *)level andContont:(NSString *)text
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.did forKey:@"topic_id"];        // 原帖动态id
    [dic setObject:temp_id forKey:@"msg_id"];           // 上级id
    [dic setObject:text forKey:@"content"];
    [dic setObject:temp_id forKey:@"argued_id"];        // 被评论id
    [dic setObject:nickname forKey:@"argued_name"];     // 被评论人名
    [dic setObject:level forKey:@"level"];              // 评论等级
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", ZTPengYouQuanPingLun];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            self.keaboad.textView.text = @"";
            [self.keaboad.textView resignFirstResponder];
            
            [self hiddenKeabord];
            
            [self performSelector:@selector(getTrendsDetailData) withObject:nil afterDelay:1.0];
            
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
            }

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        
        
    }];
    
}

#pragma mark - 数据请求点赞
- (void)netWorkingDianZhan:(ZJTrendsModel *)model andView:(ZJTrendsDetailView *)view
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:model.id forKey:@"topic_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KSheQuQuanZiDianZhan];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];

            view.functionView.commendBtn.selected = !view.functionView.commendBtn.isSelected;
        
            [self performSelector:@selector(getTrendsDetailData) withObject:nil afterDelay:1.0];
            
            if (self.shuaiXinBlack) {
                
                self.shuaiXinBlack();
            }
            
        }
        else
        {
            
            // 登录失效 进行提示登录
            if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
                
                [SVProgressHUD dismiss];
                
                __weak typeof(self) weakSelf = self;
                
                UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
                    ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
                    vc.isLogo = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }];
                
                [vc addAction:otherAction];
                
                [weakSelf presentViewController:vc animated:YES completion:nil];
                
            }
            else
            {
                
                [SVProgressHUD showErrorWithStatus:message];
            }

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photoesArr.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoesArr.count) {
        
        return [self.photoesArr objectAtIndex:index];
    }
    
    return nil;
}




//创建评论键盘
-(void)createCommentViewWithCommentId:(NSString *)commentId commentedNickName:(NSString *)commentNickName{
    
    
    
    
}

@end
