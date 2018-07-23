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
    [self.drawTool setup];
}
- (UIImage *)showingImg{
    return self.imageView.image;
}
- (void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    if (self.imageView) {
        self.imageView.image = showImage;
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
- (void)dealloc{
    NSLog(@"%s",__func__);
}


@end
