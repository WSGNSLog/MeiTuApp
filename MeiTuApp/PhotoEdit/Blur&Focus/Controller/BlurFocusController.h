//
//  BlurFocusController.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BaseController.h"

@interface BlurFocusController : BaseController


@property (nonatomic, readonly) CGRect imageRect;
@property (nonatomic,strong,readonly) UIImage *showingImg;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;



@end
