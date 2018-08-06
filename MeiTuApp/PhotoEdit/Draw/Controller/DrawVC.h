//
//  DrawVC.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/23.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawVC : UIViewController
@property (nonatomic,strong,readonly) UIImage *showingImg;
@property (nonatomic, readonly) CGRect imageRect;
@property (nonatomic, readonly) CGRect imageFrame;
@property (strong,nonatomic) UIImage *showImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *optionView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (copy,nonatomic) void(^imageBlock)(UIImage *image);


@end
