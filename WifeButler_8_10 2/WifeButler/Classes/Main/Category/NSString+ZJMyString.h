//
//  NSString+ZJMyString.h
//  Fish
//
//  Created by JL on 15/6/10.
//  Copyright (c) 2015年 zjtdmac3. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSString (ZJMyString)

- (CGFloat)getMyStringHeightWithFont:(UIFont *)font andSize:(CGSize)size;
- (CGFloat)getMyStringWidthWidthWithFont:(UIFont *)font andSize:(CGSize)size;
- (CGSize)getMyStringSizeWithFont:(UIFont *)font andSize:(CGSize)size;

@end
