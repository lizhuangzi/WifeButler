//
//  ZTKaiDianTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/6/18.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTKaiDianTableViewController.h"
#import "ZTDianPuXinXiTableViewController.h"
#import "NSString+ZJMyJudgeString.h"
#import "ZJLoginController.h"

@interface ZTKaiDianTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    
    int _isID;
}


@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *name_IDCard;



@property (weak, nonatomic) IBOutlet UIButton *btn1;


@property (weak, nonatomic) IBOutlet UIButton *ID_Card1;
@property (weak, nonatomic) IBOutlet UIButton *ID_Card2;
@property (weak, nonatomic) IBOutlet UIButton *ID_Card3;

@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;

/**
 *  选择的图片
 */
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end

@implementation ZTKaiDianTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn1.selected = YES;
    
    self.title = @"我的开店";
    
    [self setPram];
}

- (void)setPram
{
    self.nameTF.delegate = self;

    
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    [self.name_IDCard addTarget:self action:@selector(textFieldDidChange1:) forControlEvents:UIControlEventEditingChanged];
}


- (IBAction)ID_Card1Onclick:(id)sender {
    
    _isID = 0;
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Choose" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAc1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToCamera];
    }];
    
    UIAlertAction *alertAc2 = [UIAlertAction actionWithTitle:@"选取相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToPhoto];
    }];
    
    UIAlertAction *alertAc3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVc addAction:alertAc1];
    [alertVc addAction:alertAc2];
    [alertVc addAction:alertAc3];
    
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (IBAction)ID_Card2Onclick:(id)sender {
    
    _isID = 1;
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Choose" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAc1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToCamera];
    }];
    
    UIAlertAction *alertAc2 = [UIAlertAction actionWithTitle:@"选取相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToPhoto];
    }];
    
    UIAlertAction *alertAc3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVc addAction:alertAc1];
    [alertVc addAction:alertAc2];
    [alertVc addAction:alertAc3];
    
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (IBAction)ID_Card3Onclick:(id)sender {
    
    _isID = 2;
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Choose" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAc1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToCamera];
    }];
    
    UIAlertAction *alertAc2 = [UIAlertAction actionWithTitle:@"选取相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf imageToPhoto];
    }];
    
    UIAlertAction *alertAc3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVc addAction:alertAc1];
    [alertVc addAction:alertAc2];
    [alertVc addAction:alertAc3];
    
    
    [self presentViewController:alertVc animated:YES completion:nil];
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
    if (_isID == 0) {
        
        _image1 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.ID_Card1 setBackgroundImage:nil forState:UIControlStateNormal];
        [self.ID_Card1 setImage:_image1 forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (_isID == 1) {
        
        _image2 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.ID_Card2 setBackgroundImage:_image2 forState:UIControlStateNormal];
        
        [self.ID_Card2 setImage:nil forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
    if (_isID == 2)
    {
        _image3 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [self.ID_Card3 setBackgroundImage:_image3 forState:UIControlStateNormal];
        
        [self.ID_Card3 setImage:nil forState:UIControlStateNormal];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)shenQinClick:(id)sender {
    
    [self netWorking];
}

#pragma mark - 申请开店
- (void)netWorking
{
//    if ([NSString isIDCardPerson:self.nameTF.text] == NO) {
//        
//        [SVProgressHUD showErrorWithStatus:@"名字不合理哦!"];
//        return;
//    }

    
    if (self.nameTF.text.length < 1  || self.nameTF.text.length > 9) {
        
        [SVProgressHUD showErrorWithStatus:@"真实姓名不合理哦!"];
        return;
    }
    
    if ([self.name_IDCard.text validateIdentityCard] == NO) {
        
        [SVProgressHUD showErrorWithStatus:@"身份证号码格式不正确!"];
        return;
    }
    
    if (_image1 == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"图片不能为空哦!"];
        return;
    }
    
    if (_image2 == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"图片不能为空哦!"];
        return;
    }
    
    if (_image3 == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"图片不能为空哦!"];
        return;
    }

    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.nameTF.text forKey:@"realname"];
    [dic setObject:self.name_IDCard.text forKey:@"id_card"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KWoDeGeRenXinXi];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (_image1 != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(_image1, .5);
            
            [formData appendPartWithFileData:imageData name:@"avatar1" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
            
        }
        if (_image2 != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(_image2, .5);
            
            [formData appendPartWithFileData:imageData name:@"avatar2" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
            
        }
        if (_image3 != nil) {
            
            NSData *imageData = UIImageJPEGRepresentation(_image3, .5);
            
            [formData appendPartWithFileData:imageData name:@"avatar3" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD dismiss];
            
            NSSaveUserDefaults(responseObject[@"resultCode"], @"ZTserve_id");
            
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZTWoYaoKaiDian" bundle:nil];
            ZTDianPuXinXiTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ZTDianPuXinXiTableViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
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

- (void)textFieldDidChange:(id)sender
{
    if (self.nameTF.text.length > 9)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.nameTF.text = [self.nameTF.text substringToIndex:9];
    }
}

- (void)textFieldDidChange1:(id)sender
{
    if (self.name_IDCard.text.length > 20)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.name_IDCard.text = [self.name_IDCard.text substringToIndex:20];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
