//
//  BlurTool.h
//  MeiTuApp
//
//  Created by shiguang on 2018/7/20.
//  Copyright © 2018年 shiguang. All rights reserved.
//

#import "EffectBase.h"
#import "BlurFocusController.h"

@interface BlurTool : EffectBase
@property (nonatomic, weak) BlurFocusController *editor;


- (id)initWithImageEditor:(BlurFocusController *)editor;
- (void)setup;
- (void)cleanup;
- (void)didSelectedMenuAtIndex:(int)index;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;
@end
