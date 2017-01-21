//
//  ZJSheQuanZiHeaderView.h
//  WifeButler
//
//  Created by 陈振奎 on 16/6/13.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJSheQuanZiHeaderView;

@protocol ZJSheQuanZiHeaderViewDelegate <NSObject>

-(void)sheQuanZiHeaderView:(ZJSheQuanZiHeaderView *)view sendTrendsViewClicked:(UILabel *)sendTrendsLabel;

@end

@interface ZJSheQuanZiHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backGroundIngView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *sendTrendsLbel;

@property (nonatomic, weak) id<ZJSheQuanZiHeaderViewDelegate> delegate;

@end
