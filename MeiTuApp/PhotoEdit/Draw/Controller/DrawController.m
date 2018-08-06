//
//  DrawController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "DrawController.h"
#import "DrawTool.h"

@interface DrawController ()


@property (nonatomic,strong) DrawTool *drawTool;

@end

@implementation DrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.showImage;
 
    self.drawTool = [[DrawTool alloc]initWithImageEditor:self];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.autoresizingMask = NO;
    [self.drawTool setup];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self resetImageViewFrame];
}
- (UIImage *)showingImg{
    return self.imageView.image;
}

- (void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    if (self.imageView) {
        self.imageView.image = showImage;
        [self resetImageViewFrame];
    }
}

- (IBAction)saveClick:(id)sender{
    if (self.imageBlock) {
        self.imageBlock(self.imageView.image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (CGRect)imageRect{
    return AVMakeRectWithAspectRatioInsideRect(self.showImage.size, self.scrollView.bounds);
}
- (void)resetImageViewFrame
{
    _imageView.frame = self.imageFrame;
}
- (CGRect)imageFrame{
   
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        return CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
    return _imageView.frame;
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
