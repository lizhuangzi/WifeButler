//
//  UserQRViewController.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/7.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "UserQRViewController.h"
#import "WifeButlerAccount.h"
#import "WifeButlerDefine2.h"
#import "PersonalPort.h"
#import "WifeButlerNetWorking.h"
#import "WifeButlerDefine.h"
#import "WifeButlerLocationManager.h"

@interface UserQRViewController ()

@property (weak, nonatomic) IBOutlet UIView *backWhiteView;
@property (weak, nonatomic) IBOutlet UILabel *userNameView;
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property (weak, nonatomic) IBOutlet UIImageView *userSexPictureView;
/**二维码imageview*/
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
/**用户地址*/
@property (weak, nonatomic) IBOutlet UILabel *userAddressView;
@end

@implementation UserQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的二维码";
    self.backWhiteView.layer.cornerRadius = 5;
    
    WifeButlerUserParty * party = [WifeButlerAccount sharedAccount].userParty;
    
    self.userNameView.text = party.nickname;
    [self.userIconView sd_setImageWithURL:party.iconFullPath placeholderImage:PlaceHolderImage_Person];
    self.userAddressView.text = party.defaultAddress;
    
    if ([party.gender isEqualToString:@"男"]) {
        self.userSexPictureView.image = [UIImage imageNamed:@"ZTWoDeHighlighted"];
    }else{
        self.userSexPictureView.image = [UIImage imageNamed:@"ZTWoDeHighlighted"];
    }
    
    [self RequestQRStrWithId:party.Id];
}

- (void)RequestQRStrWithId:(NSString *)ID {
   
    NSDictionary * parm = @{@"id":ID};
    [WifeButlerNetWorking getPackagingHttpRequestWithURLsite:KUserGetQRCode parameter:parm success:^(NSDictionary * resultCode) {
        
        [self generateQRImageWithString:resultCode[@"qrcode"]];
        
    } failure:^(NSError *error) {
        
        SVDCommonErrorDeal
    }];
}

- (void)generateQRImageWithString:(NSString *)qrstr
{
    if ([qrstr isKindOfClass:[NSString class]] && qrstr.length>0) {
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setDefaults];
        NSString *dataString = qrstr;
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        [filter setValue:data forKeyPath:@"inputMessage"];
        CIImage *outputImage = [filter outputImage];
        UIImage * finImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
        
        self.QRImageView.image = finImage;
    }
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
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
