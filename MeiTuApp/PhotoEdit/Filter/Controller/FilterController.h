//
//  FilterController.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/18.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FilterController : UIViewController

@property (strong,nonatomic) UIImage *showImage;
@property (strong,nonatomic) UIImage *thumbImage;

@property (copy,nonatomic) void(^imageBlock)(UIImage *image);

@end
