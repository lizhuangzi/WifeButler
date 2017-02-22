//
//  ZTSheQuQuanZiViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/7.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTSheQuQuanZiViewController.h"
#import "ZTSheQuChuanZiQiPaoViewController.h"
#import "ZTSheQuQuanZiTableViewCell.h"
#import "NSString+ZJMyString.h"
#import "ZJTrendsDetailController.h"
#import "ZJTrendsCellFrameModel.h"
#import "ZJSheQuanZiHeaderView.h"
#import "ZJFriendsCircleNavgationbar.h"
#import "ZTFaBuDongTaiViewController.h"
#import "ZJTrendsFunctionView.h"
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>
#import "ZJLoginController.h"
#import "MJRefresh.h"

@interface ZTSheQuQuanZiViewController ()<UIPopoverPresentationControllerDelegate,ZTSheQuQuanZiTableViewCellDelegate, UITableViewDataSource,UITableViewDelegate,ZJFriendsCircleNavgationbarDelegate, ZJSheQuanZiHeaderViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MWPhotoBrowserDelegate>

// 相机
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *imageIcon;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) ZTSheQuChuanZiQiPaoViewController * qiBao;
@property (nonatomic, strong) NSMutableArray *trendsArr;
@property (nonatomic, assign) int pageIndex;

@property (nonatomic, weak) ZJSheQuanZiHeaderView *headerView;
@property (nonatomic, weak) ZJFriendsCircleNavgationbar *navigationBar;

@property (nonatomic, weak) ZJFriendsCircleNavgationbar *navigationBarZT;

@property (nonatomic, strong) NSMutableArray * photoesArr;


@end

@implementation ZTSheQuQuanZiViewController

-(NSMutableArray *)trendsArr{
    
    if (!_trendsArr) {
        _trendsArr = [NSMutableArray array];
    }
    
    return _trendsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"社区圈子";
    
    self.photoesArr = [NSMutableArray array];
    
    [self settingTableView];
    
    [self settingNavigationBar];
    
    self.pageIndex = 1;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.pageIndex = 1;
        [self.trendsArr removeAllObjects];
        [self.tableView reloadData];
        [self getTrendsData];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.pageIndex ++;
        [self getTrendsData];
    }];
    
     [self getTrendsData];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)settingTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iphoneWidth, iphoneHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;

    tableView.tableFooterView = [[UIView alloc]init];
    
}

-(void)settingNavigationBar{
    
    ZJFriendsCircleNavgationbar *navigationBar = [[[NSBundle mainBundle]loadNibNamed:@"ZJFriendsCircleNavgationbar" owner:nil options:nil]lastObject];
    navigationBar.backgroundColor = [UIColor clearColor];
    navigationBar.size = CGSizeMake(iphoneWidth, 64);
    navigationBar.x = 0;
    navigationBar.y = 0;
    
    navigationBar.delegate = self;
    
    // 赋值给全局变量
    self.navigationBarZT = navigationBar;
    
    self.navigationBar = navigationBar;
    
    [self.view addSubview:navigationBar];

}


-(void)getTrendsData{
    
    NSString *url;
    NSDictionary *parameters;
    if (self.isMyQuanZi == YES) { // 我的圈子
        
        url = [HTTP_BaseURL stringByAppendingString:TRENDSLIST];
        parameters = @{@"token":KToken,@"pagesize":@"20",@"pageindex":@(self.pageIndex)};
    }
    else  // 他人圈子
    {
        url = [HTTP_BaseURL stringByAppendingString:ZTTaRenQuanZi];
        parameters = @{@"token":KToken, @"uid" : self.Zt_uid, @"pagesize":@"20",@"pageindex":@(self.pageIndex)};
    }
    

//    [CCNetWorkingTool POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        if ([CCNetWorkingTool success:responseObject]) {
//            
//            NSArray *trendsArr = [ZJTrendsListModel mj_objectArrayWithKeyValuesArray:responseObject[@"resultCode"][@"list"]];
//           
//            NSMutableArray *muArr = [NSMutableArray array];
//            
//            for (int i = 0; i < trendsArr.count; ++i) {
//                
//                ZJTrendsListModel *model = trendsArr[i];
//               
//                ZJTrendsCellFrameModel *frameModel = [[ZJTrendsCellFrameModel alloc]init];
//                frameModel.model = model;
//                [muArr addObject:frameModel];
//                
//            }
//            
//            [self.trendsArr addObjectsFromArray:muArr];
//            [self.tableView reloadData];
//            
//            [self settingHeaderViewWithBackGroundIcon:responseObject[@"resultCode"][@"bg"] icon:responseObject[@"resultCode"][@"avatar"] nickName:responseObject[@"resultCode"][@"nickname"]];
//        }
//        
//        
//        // 登录失效 进行提示登录
//        if ([[responseObject objectForKey:@"code"] intValue] == 40000) {
//            
//            [SVProgressHUD dismiss];
//            
//            __weak typeof(self) weakSelf = self;
//            
//            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"您登录已经失效,请重新进行登录哦!" preferredStyle:UIAlertControllerStyleAlert];
//            
//
//            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//                
//                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZJLogin" bundle:nil];
//                ZJLoginController *vc = [sb instantiateViewControllerWithIdentifier:@"ZJLoginController"];
//                vc.isLogo = YES;
//                [vc setShuaiXinShuJu:^{
//                    
//                    [self getTrendsData];
//                }];
//                
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }];
//            
//            [vc addAction:otherAction];
//            
//            [weakSelf presentViewController:vc animated:YES completion:nil];
//            
//        }
//
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    }];
    
}



-(void)settingHeaderViewWithBackGroundIcon:(NSString *)backGroundIcon icon:(NSString *)icon nickName:(NSString *)nickName{
  
    if (!self.headerView) {
        ZJSheQuanZiHeaderView *headerView = [[[NSBundle mainBundle]loadNibNamed:@"ZJSheQuanZiHeaderView" owner:nil options:nil]lastObject];
        headerView.frame = CGRectMake(0, 0, iphoneWidth, iphoneWidth * 2 / 3 + 60);
        headerView.delegate = self;
        self.headerView = headerView;
        self.tableView.tableHeaderView = headerView;
    }
    
    [self.headerView.backGroundIngView sd_setImageWithURL:[NSURL URLWithString:[KImageUrl stringByAppendingString:backGroundIcon]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    [self.headerView.icon sd_setImageWithURL:[NSURL URLWithString:[KImageUrl stringByAppendingString:icon]] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    self.headerView.name.text = nickName;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trendsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];
    
    NSString *ID = @"ZTSheQuQuanZiTableViewCell";
    
    ZTSheQuQuanZiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
       
        cell = [[ZTSheQuQuanZiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.delegate = self;
    }
    
    __weak typeof(self) weakSelf = self;
    
    [cell setPhotoBlack:^(ZTSheQuQuanZiTableViewCell *cell, NSIndexPath *indexPaht) {
        
        [weakSelf.photoesArr removeAllObjects];
        
        for (int i = 0; i < cell.dataSourceTemp.count; i ++) {
            
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrl, cell.dataSourceTemp[i]]]];
            [weakSelf.photoesArr addObject:photo];
        }
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        [browser setCurrentPhotoIndex:indexPaht.row];   // 设置是第几个显示
        [self.navigationController pushViewController:browser animated:YES];
    }];
    
    cell.frameMode = frameModel;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];

   
    return frameModel.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];
    ZJTrendsListModel *model = frameModel.model;

    ZJTrendsDetailController *detailCtrl = [[ZJTrendsDetailController alloc]init];
    detailCtrl.did = model.id;
    
    [detailCtrl setShuaiXinBlack:^{

        model.myup = @"1";
        
        [self.trendsArr removeAllObjects];
        
        [self getTrendsData];
    }];
    
    [self.navigationController pushViewController:detailCtrl animated:YES];
}


#pragma mark - ZJFriendsCircleNavgationbarDelegate
-(void)friendsCircleNavgationbar:(ZJFriendsCircleNavgationbar *)navigationBar btnClicked:(NSInteger)btnTag{
    
    switch (btnTag) {
        case 100:{
            NSLog(@"左键");
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
            
        case 101:{
            NSLog(@"右键");
            
            [self backgroundView_Clicked];
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ZJSheQuanZiHeaderViewDelegate
-(void)sheQuanZiHeaderView:(ZJSheQuanZiHeaderView *)view sendTrendsViewClicked:(UILabel *)sendTrendsLabel{
    
    NSLog(@"发布动态--------");
    ZTFaBuDongTaiViewController *vc = [[ZTFaBuDongTaiViewController alloc] init];
    [vc setRefBlack:^{
       
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - ZTSheQuQuanZiTableViewCellDelegate

-(void)sheQuQuanZiTableViewCell:(ZTSheQuQuanZiTableViewCell *)cell functionViewClicked:(UIView *)view{
    
    if ([view isEqual:cell.headerView.icon]) {
        NSLog(@"头像点击------");
   
    
    }else if ([view isEqual:cell.headerView.deleteBtn]) {
        NSLog(@"删除动态-----");
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];
        ZJTrendsListModel *model = frameModel.model;
        
        [self netWorkingDelete:model andFrame:frameModel];
    
    
    }else if([view isEqual:cell.functionView.commendBtn]){
        
        NSLog(@"点赞动态---");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];
        ZJTrendsListModel *model = frameModel.model;
        
        [self netWorkingDianZhan:model andTableViewCell:(ZTSheQuQuanZiTableViewCell *)cell];
        
        //网络 请求成功后 commendBtn.selected = !commendBtn.isSelected;
        
    
    }else if ([view isEqual:cell.functionView.commmentBtn]){
        NSLog(@"评论动态----");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ZJTrendsCellFrameModel *frameModel = self.trendsArr[indexPath.row];
        ZJTrendsListModel *model = frameModel.model;
        
        ZJTrendsDetailController *detailCtrl = [[ZJTrendsDetailController alloc]init];
        detailCtrl.did = model.id;
        [self.navigationController pushViewController:detailCtrl animated:YES];
        
        
        
    }else if ([view isEqual:cell.pingLuLab]){
        NSLog(@"评论动态+++++++");
        
    }
 
}


// 头像背景图片
- (void)backgroundView_Clicked
{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Choose" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAC = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageToCamera];
        
    }];
    UIAlertAction *alertAC1 = [UIAlertAction actionWithTitle:@"选取相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self imageToPhoto];
    }];
    UIAlertAction *alertAC2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:alertAC];
    [alertVC addAction:alertAC1];
    [alertVC addAction:alertAC2];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//  选择相册
- (void)imageToPhoto
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.imagePicker.allowsEditing = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

/*选择相机*/
-(void)imageToCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.imagePicker.allowsEditing =YES;
        
        //设置拍照后的图片可被编辑
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.sourceType = sourceType;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"暂时不能打开相机需真机");
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _imageIcon = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self netWorkingGengXin];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 更新背景
- (void)netWorkingGengXin
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", ZTGengXinBeiJin];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (_imageIcon != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(_imageIcon, .5);
            
            [formData appendPartWithFileData:imageData name:@"bg" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            self.headerView.backGroundIngView.image = _imageIcon;
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
- (void)netWorkingDianZhan:(ZJTrendsListModel *)model andTableViewCell:(ZTSheQuQuanZiTableViewCell *)cell
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
            
            model.myup = @"1";
            cell.functionView.commendBtn.selected = !cell.functionView.commendBtn.selected;
            
            [self.trendsArr removeAllObjects];
            
            [self getTrendsData];
            
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

#pragma mark - 数据请求删除
- (void)netWorkingDelete:(ZJTrendsListModel *)model andFrame:(ZJTrendsCellFrameModel *)frameModel1
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:model.id forKey:@"topic_id"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", ZTPengYouQuanDele];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 成功
        if ([responseObject[@"code"] intValue] == 10000) {
    
            [SVProgressHUD dismiss];
            
            [self.trendsArr removeObject:frameModel1];
            
            [self.tableView reloadData];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
        
        
    }];
    
}


#pragma mark - 顶部状态栏改变
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat alphaT = scrollView.contentOffset.y / 200.0;
    
    if (alphaT > 1) {
        
        self.navigationBarZT.backgroundColor = [UIColor colorWithRed:0.133 green:0.714 blue:0.620 alpha:1.000];
    }
    else
    {
        self.navigationBarZT.backgroundColor = [UIColor colorWithRed:0.133 green:0.714 blue:0.620 alpha:alphaT];
    }
    
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



- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
