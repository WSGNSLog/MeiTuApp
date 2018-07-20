//
//  EffectBaseTool.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "EffectBaseTool.h"
#import "LocalizableTool.h"
#import "BundleTool.h"
#import "UIImage+Utility.h"



//static const CGFloat kCLImageToolAnimationDuration = 0.3;
//static const CGFloat kCLImageToolFadeoutDuration   = 0.2;


@interface EffectBaseTool()

@property (nonatomic, strong) UIView *selectedMenu;


@end

@implementation EffectBaseTool
{
    UIImage *_originalImage;
    UIImage *_thumbnailImage;
    
    UIScrollView *_menuScroll;
    UIActivityIndicatorView *_indicatorView;
}

- (id)initWithImageEditor:(EffectController *)editor
{
    self = [super init];
    if(self){
        self.editor   = editor;
    }
    return self;
}

#pragma mark-

- (void)setup
{
    _originalImage = self.editor.showingImg;
    _thumbnailImage = [_originalImage resize:self.editor.imageRect.size];
    NSLog(@"==");

}

- (void)cleanup
{
    [self.selectedEffect cleanup];
    [_indicatorView removeFromSuperview];

//    [self.editor resetZoomScaleWithAnimated:YES];

}

- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_indicatorView = [self indicatorView];
        self->_indicatorView.center = self.editor.view.center;
        [self.editor.view addSubview:self->_indicatorView];
        [self->_indicatorView startAnimating];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self.selectedEffect applyEffect:self->_originalImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
}
- (UIActivityIndicatorView*)indicatorView
{
    
    // default indicator view
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    indicatorView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    indicatorView.layer.cornerRadius = 5;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    return indicatorView;
}




- (void)setSelectedEffect:(EffectBase *)selectedEffect
{
    if(selectedEffect != _selectedEffect){
        [_selectedEffect cleanup];
        _selectedEffect = selectedEffect;
        _selectedEffect.delegate = self;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumbnailImage];
        });
    }
}

- (void)buildThumbnailImage
{
    UIImage *image;
    if(self.selectedEffect.needsThumbnailPreview){
        image = [self.selectedEffect applyEffect:_thumbnailImage];
    }
    else{
        image = [self.selectedEffect applyEffect:_originalImage];
    }
    [self.editor performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}

#pragma mark- CLEffect delegate

- (void)effectParameterDidChange:(EffectBase *)effect
{
    if(effect == self.selectedEffect){
        static BOOL inProgress = NO;

        if(inProgress){ return; }
        inProgress = YES;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self buildThumbnailImage];
            inProgress = NO;
        });
    }
}

@end
