//
//  ZTBianJiZiliaoTableViewController.m
//  WifeButler
//
//  Created by ZT on 16/5/17.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZTBianJiZiliaoTableViewController.h"
#import "ZTLogoModel.h"


@interface ZTBianJiZiliaoTableViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// 相机
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *imageIcon;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UITextField *niChenTF;

@property (weak, nonatomic) IBOutlet UITextField *sexTF;

@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;


@end

@implementation ZTBianJiZiliaoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    // 设置个人信息
    [self setPersonInfo];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" norImage:nil higImage:nil tagert:self action:@selector(saveInfo)];
}

- (void)saveInfo
{
    // 头像上传
    [self netWorking];
}

- (void)netWorking
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:KToken forKey:@"token"];
    [dic setObject:self.niChenTF.text forKey:@"nickname"];
    [dic setObject:self.sexTF.text forKey:@"gender"];
    
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KPersonInfoXiuGai];
    
    ZJLog(@"%@", dic);
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 判断图片是否为空
        if (_imageIcon != nil) {
            
            // 压缩图片
            NSData *imageData = UIImageJPEGRepresentation(_imageIcon, .5);
            
            [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"imgurl.jpg" mimeType:@"image/jpg"];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [self downInfo];
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

- (void)downInfo
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];/*JSON反序列化确保得到的数据时JSON数据*/
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];/*添加接可收数据的数据可行*/
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:NSGetUserDefaults(@"mobile") forKey:@"mobile"];
    [dic setObject:NSGetUserDefaults(@"password") forKey:@"passwd"];
    
    NSString *url = [HTTP_BaseURL stringByAppendingFormat:@"%@", KLogo];
    
    ZJLog(@"%@", dic);
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *message = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
        
        ZJLog(@"%@", responseObject);
        
        // 登录成功
        if ([responseObject[@"code"] intValue] == 10000) {
            
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            
            ZTLogoModel *model = [ZTLogoModel mj_objectWithKeyValues:responseObject[@"resultCode"]];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            [ud setObject:model.token_app forKey:@"token_app"];
            [ud setObject:model.avatar forKey:@"avatar"];
            [ud setObject:model.gender forKey:@"gender"];
            [ud setObject:model.nickname forKey:@"nickname"];
            
            [ud synchronize];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            
            [SVProgressHUD showErrorWithStatus:message];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求失败,请检查你的网络连接"];
        
    }];
    
}



- (void)setPersonInfo
{
    self.iconImageV.layer.masksToBounds = YES;
    self.iconImageV.layer.cornerRadius = self.iconImageV.frame.size.width / 2.0;
    
    [self.niChenTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    self.niChenTF.text = NSGetUserDefaults(@"nickname");
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:NSGetUserDefaults(@"avatar")] placeholderImage:[UIImage imageNamed:@"ZTZhanWeiTu11"]];
    self.iphoneLab.text = NSGetUserDefaults(@"mobile");
    self.sexTF.text = NSGetUserDefaults(@"gender");
}



#pragma mark - 性别
- (IBAction)sexClick:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *alertAC = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sexTF.text = @"男";
        
    }];
    
    UIAlertAction *alertAC1 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.sexTF.text = @"女";
        
    }];
    UIAlertAction *alertAC2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertVC addAction:alertAC];
    [alertVC addAction:alertAC1];
    [alertVC addAction:alertAC2];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}



#pragma mark - 头像选择
- (IBAction)iconClick:(id)sender {
    
    [self backgroundView_Clicked];
}


// 头像上传
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
    
    [_iconImageV setImage:_imageIcon];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)textFieldDidChange:(id)sender
{
    if (self.niChenTF.text.length > 9)  // MAXLENGTH为最大字数
    {
        //超出限制字数时所要做的事
        self.niChenTF.text = [self.niChenTF.text substringToIndex:9];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
