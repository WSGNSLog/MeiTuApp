//
//  EffectController.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/19.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "BaseController.h"

@interface EffectController : BaseController
@property (nonatomic, readonly) CGRect imageRect;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
