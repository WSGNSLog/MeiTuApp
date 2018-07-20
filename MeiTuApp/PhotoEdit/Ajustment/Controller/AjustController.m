//
//  AjustController.m
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "AjustController.h"
#import "AjustmentTool.h"

@interface AjustController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) AjustmentTool *ajustTool;

@end

@implementation AjustController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.imageView.image = self.showImage;
    self.ajustTool = [[AjustmentTool alloc]initWithImageEditor:self];
    [self.ajustTool setup];
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
    return AVMakeRectWithAspectRatioInsideRect(self.showImage.size, self.bgView.bounds);
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
