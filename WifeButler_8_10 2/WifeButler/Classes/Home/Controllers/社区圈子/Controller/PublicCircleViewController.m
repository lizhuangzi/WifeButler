//
//  PublicCircleViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/18.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "PublicCircleViewController.h"
#import "ConfirmImageCollectionViewCell.h"
#import "CSPlaceHolderTextView.h"
#import "Masonry.h"
#import "ImagePickerUtils.h"
#import "CSActionSheet.h"


#define ACTIONSHEETADDIMAGETAG 6
#define ACTIONSHEETDELETEIMAGETAG 7
@interface PublicCircleViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ConfirmImageCollectionViewCellImageClickDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,CSActionSheetDelegate>

/**collectionView 照片九宫格*/
@property (nonatomic,weak)UICollectionView * collectionView;
/**放有imageData的数组，上传时使用*/
@property (nonatomic,strong)NSMutableArray * imageDataArray;

@property (nonatomic,weak) CSPlaceHolderTextView * textView;


@end

@implementation PublicCircleViewController

static int deleteIndex = 0;

- (NSMutableArray *)imageDataArray
{
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布圈子";
    
    self.view.backgroundColor = [UIColor whiteColor];
    CSPlaceHolderTextView * text = [[CSPlaceHolderTextView alloc]init];
    text.placeHolder = @"想说点什么呢...";
    [self.view addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(140);
    }];
    
    [self.imageDataArray addObject:@"加号"];
    
    self.textView = text;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteImage:) name:ConfirmImageCollectionViewCellDeleteNotication object:nil];
    
    [self initCollection];
}
static NSString * ID = @"collectionView";

- (void)initCollection{
    
    //初始化创建collectionView
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionView * collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.backgroundColor = [UIColor whiteColor];
    collectView.scrollEnabled = NO;
    [collectView registerClass:[ConfirmImageCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectView];
    self.collectionView = collectView;

    [collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(280);
    }];
}

#pragma mark - collection数据源 代理 collectionViewDelegate & dataSourse

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return self.imageDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ConfirmImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.indexPath = indexPath;

    cell.image = self.imageDataArray[indexPath.item];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.collectionView.width - 50)/4, (self.collectionView.width - 50)/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark -点击图片放大代理 ConfirmImageCollectionViewCellImageClickDelegate

- (void)ConfirmImageCollectionViewCell:(ConfirmImageCollectionViewCell *)cell didClick:(UIImageView *)currentImageView
{

    
}


//点击加号
- (void)ConfirmImageCollectionViewCelldidClickPlusBtn:(ConfirmImageCollectionViewCell *)cell
{
    [self dealAddPlusClickEvent];
}

//长按图片删除
- (void)deleteImage:(NSNotification *)noti
{
    NSNumber * index = noti.userInfo[@"deleteIndex"];
    deleteIndex = index.intValue;
    CSActionSheet * sheet = [[CSActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    sheet.tag = ACTIONSHEETDELETEIMAGETAG;
    [sheet show];
}

- (void)dealAddPlusClickEvent
{
    CSActionSheet * sheet = [[CSActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"照相机", nil];
    sheet.tag = ACTIONSHEETADDIMAGETAG;
    [sheet show];
}

#pragma mark -CSActionSheet代理
- (void)actionSheet:(CSActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTIONSHEETADDIMAGETAG) { //增加图片
        if (buttonIndex == 0) {
            //图片来源 相册
            [ImagePickerUtils customPhotoSelect:self multip:YES filterType:QBImagePickerControllerFilterTypePhotos minNumber:0 maxNumber:10 - self.imageDataArray.count delegate:self];
        }else if (buttonIndex == 1) {
            [ImagePickerUtils takePhotoFromVC:self imgMode:kImagePickerModePhoto allowsEditing:YES withDelegate:self];
        }
    }else if (actionSheet.tag == ACTIONSHEETDELETEIMAGETAG){
        if (buttonIndex == 0) {
            if (self.imageDataArray.count == 9 && ![self.imageDataArray.lastObject isKindOfClass:[NSString class]]){
                [self.imageDataArray addObject:@"加号"];
            }
            
            [self.imageDataArray removeObjectAtIndex:deleteIndex];
            [self.collectionView reloadData];
        }
    }
}


- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    for (ALAsset * asset in assets) {
        
        if (self.imageDataArray.count == 9 && [self.imageDataArray.lastObject isKindOfClass:[NSString class]]) {
            [self.imageDataArray removeLastObject];
        }else if (self.imageDataArray.count == 9 && ![self.imageDataArray.lastObject isKindOfClass:[NSString class]]){
            [SVProgressHUD showInfoWithStatus:@"选择已满"];
            break;
        }
         UIImage * image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [self.imageDataArray insertObject:image atIndex:0];
    }
    [self.collectionView reloadData];
}
@end
