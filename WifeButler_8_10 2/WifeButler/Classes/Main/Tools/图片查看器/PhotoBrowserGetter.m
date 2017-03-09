//
//  PhotoBrowserGetter.m
//  WifeButler
//
//  Created by 李庄子 on 2017/3/9.
//  Copyright © 2017年 zjtd. All rights reserved.
//

#import "PhotoBrowserGetter.h"
#import "MWPhotoBrowser.h"

@interface PhotoBrowserGetter ()<MWPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray * photos;
@end

@implementation PhotoBrowserGetter

+ (instancetype)browserGetter
{
    return [[self alloc]init];
}

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (UIViewController *)getBrowserWithCurrentIndex:(NSUInteger)index andimageURLStrings:(NSArray *)photoImageUrls{
     
    for (int i = 0; i<photoImageUrls.count; i++) {
        NSString * str = photoImageUrls[i];
        MWPhoto * photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:str]];
        [self.photos addObject:photo];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    [browser setCurrentPhotoIndex:index];
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    
    return browser;
}


#pragma mark - PhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return  self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count) {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}


@end
