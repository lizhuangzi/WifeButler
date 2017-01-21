//
//  ZJDetailViewFrameModel.m
//  WifeButler
//
//  Created by 陈振奎 on 16/6/14.
//  Copyright © 2016年 zjtd. All rights reserved.
//

#import "ZJDetailViewFrameModel.h"
#define MARGIN 8

@implementation ZJDetailViewFrameModel

-(void)setDetailModel:(ZJTrendsDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    ZJTrendsModel *model = detailModel.topic;
    
    _headerViewF = CGRectMake(0, 0, iphoneWidth, 80);
    
    CGFloat contentH = [model.content getMyStringHeightWithFont:[UIFont systemFontOfSize:14] andSize:CGSizeMake(iphoneWidth - MARGIN * 2, MAXFLOAT)];
   
    _contentF = CGRectMake(MARGIN, CGRectGetMaxY(_headerViewF), iphoneWidth - MARGIN * 2, contentH);
   
    
    if (!model.gallery.length) {
        
         _collectionViewF = CGRectMake(0, CGRectGetMaxY(_contentF), iphoneWidth, 0);
        
    }else{
    
    NSArray *pics = [model.gallery componentsSeparatedByString:@","];
    
        
        NSInteger count = 0;
        
        if (pics.count > 9) {
            count = 9;
        }else{
            count = pics.count;
        }
        
        NSInteger rows = (count - 1)/3 + 1;
        
        _collectionViewF = CGRectMake(0, CGRectGetMaxY(_contentF), iphoneWidth, (rows + 1) * MARGIN + rows * ((iphoneWidth - (3 + 1)*MARGIN)/3));
        
    }
    
    _functionViewF = CGRectMake(0, CGRectGetMaxY(_collectionViewF), iphoneWidth, 40);
    
    _separateLineF = CGRectMake(0, CGRectGetMaxY(_functionViewF), iphoneWidth, 1);
    
    if (detailModel.some.length) {
        
        _commendViewF = CGRectMake(MARGIN, CGRectGetMaxY(_separateLineF), iphoneWidth - MARGIN * 2, 30);
        
    }else{
        
        _commendViewF = CGRectMake(MARGIN, CGRectGetMaxY(_separateLineF), iphoneWidth - MARGIN * 2, 0);
        
    }

    _viewH = CGRectGetMaxY(_commendViewF) + MARGIN * 2;

}
@end
