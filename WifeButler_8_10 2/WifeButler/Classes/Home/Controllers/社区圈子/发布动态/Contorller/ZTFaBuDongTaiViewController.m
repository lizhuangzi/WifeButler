//
//  ZTFaBuDongTaiViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTFaBuDongTaiViewController.h"
#import "UIImageView+Del.h"
#import "ZYQAssetPickerController.h"
#import "ZJLoginController.h"

@interface ZTFaBuDongTaiViewController ()<UITextViewDelegate, UIActionSheetDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIImageViewDelDelegate, ZYQAssetPickerControllerDelegate>
{
    UIButton *btn;
    
    UIScrollView *src;
}

@property (nonatomic, strong) ZYQAssetPickerController *picker;

@property (weak, nonatomic) IBOutlet UILabel *pingLuLab;

@property (weak, nonatomic) IBOutlet UIView *addArr;

@property (nonatomic, strong) NSArray *mArr;

@property (weak, nonatomic) IBOutlet UITextView *desTextV;

@property (nonatomic, strong) NSMutableArray  * imageArray;

@property (nonatomic,retain) UIActionSheet *actionSheet;

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end



@implementation ZTFaBuDongTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"发布动态";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(AddAddress)];
    
    [self certeSorllerBtn];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.desTextV = textView;
    
    if ([self.desTextV.text length]==0)
    {
        [self.pingLuLab setHidden:NO];
        
    }else
    {
        [self.pingLuLab setHidden:YES];
        self.pingLuLab.text = @"说点什么吧......";
        
    }
}


#pragma mark - 创建scr和btn
- (void)certeSorllerBtn
{
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 10, 120, 120);
    [btn setImage:[UIImage imageNamed:@"addImageShangChuang.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backgroundView_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = self.addArr.frame;
    src = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, iphoneWidth, frame.size.height)];
    src.pagingEnabled = YES;
    src.backgroundColor = [UIColor lightGrayColor];
    src.delegate = self;
    src.backgroundColor = [UIColor whiteColor];
    [self.addArr addSubview:src];
    
    [self SXScrollView];
    
}


#pragma mark - 拍照和相册的点击事件
- (void)backgroundView_Clicked
{
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"选取相册", nil];
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:self.view];
}


#pragma mark - 刷新scrollview
- (void)SXScrollView//刷新
{
    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    src.contentSize = CGSizeMake(120 * self.imageArray.count + 120, 120);
    
    for (int i = 0; i < self.imageArray.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initDelWithFrame:CGRectMake(i * 120 + 10, 10, 110, 110)];
        imageView.delDelegate = self;
        [imageView setImage:self.imageArray[i]];
        [src addSubview:imageView];
    }
    btn.frame = CGRectMake(self.imageArray.count * 120 + 10, 10, 110, 110);
    [btn setImage:[UIImage imageNamed:@"ZTaddimage"] forState:UIControlStateNormal];
    [src addSubview:btn];
}

#pragma mark -创建相册
- (void)btnClick{
    
    self.picker = [[ZYQAssetPickerController alloc] init];
    self.picker.maximumNumberOfSelection = 9 - self.imageArray.count;
    self.picker.assetsFilter = [ALAssetsFilter allPhotos];
    self.picker.showEmptyGroups = NO;
    self.picker.delegate = self;
    self.picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
            
        } else {
            
            return YES;
        }
    }];
    
    [self presentViewController:self.picker animated:YES completion:NULL];
    
}

#pragma mark - 删除
-(void)imageViewDel:(UIImageView *)imageView
{
    [self.imageArray removeObject:imageView.image];
    [self SXScrollView];
}


#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    for (int i = 0; i < assets.count; i ++) {
        
        ALAsset *asset = assets[i];
        
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [self.imageArray addObject:tempImg];
        
    }
    
    [self SXScrollView];
    
}

#pragma mark - 照相的代理
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self.imageArray addObject:image];
    
    [self SXScrollView];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 相机选择
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self imageToCamera];
            break;
        case 1:
            [self btnClick];
            break;
        default:
            break;
    }
}

- (void)AddAddress
{
    
    
    [self netWorking];
}


- (void)netWorking
{
    if (self.imageArray.count > 9) {
        
        [SVProgressHUD showErrorWithStatus:@"最多上传9张图片哦!"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.desTextV.text forKey:@"content"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", ZTFaBuDongTai];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < self.imageArray.count; i ++) {
            
            NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 0.5);
            
            NSString *gallery = [NSString stringWithFormat:@"gallery%d", i + 1];
            
            [formData appendPartWithFileData:imageData name:gallery fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            if (self.refBlack) {
                
                self.refBlack();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
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


- (NSMutableArray *)imageArray
{
    if (!_imageArray ){
        
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
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
