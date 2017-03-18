//
//  UIColor+HexColor.h
//  CCME
//
//  Created by huangwei on 14-9-7.
//  Copyright (c) 2014年 ___beidou___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WifeButlerCommonRedColor HexCOLOR(@"#fe564c")
#define WifeButlerTableBackGaryColor HexCOLOR(@"#f4f4f4")
#define WifeButlerSeparateLineColor HexCOLOR(@"#eaeaea")
#define WifeButlerGaryTextColor1 HexCOLOR(@"#333333")
#define WifeButlerGaryTextColor2 HexCOLOR(@"#666666")
#define WifeButlerGaryTextColor3 HexCOLOR(@"#929292")
#define WifeButlerGaryTextColor4  HexCOLOR(@"#999999")
#define WifeButlerNavyBlueColor   HexCOLOR(@"#576b95")  // 深蓝色字体
#define CommonContentBackgroundColor    @"#f6f6f6"  // 内容背景

#define HexCOLOR(hex) ([UIColor colorWithHexString:hex])
#define HexCOLORNew(hex,alpha) ([UIColor colorWithHexString:hex Alpha:alpha])

@interface UIColor (HexColor)

+ (UIColor *)hexColor:(int)hexString;
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert Alpha:(CGFloat)alpha;


@end
