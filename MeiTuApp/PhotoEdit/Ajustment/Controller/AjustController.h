//
//  AjustController.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AjustController : UIViewController

@property (nonatomic,strong,readonly) UIImage *showingImg;
@property (nonatomic, readonly) CGRect imageRect;
@property (strong,nonatomic) UIImage *showImage;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (copy,nonatomic) void(^imageBlock)(UIImage *image);


@end
